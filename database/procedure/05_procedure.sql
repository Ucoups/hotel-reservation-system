USE hotel_reservation_db;

-- =============================================================================
-- 1. STORED PROCEDURE: sp_hitung_invoice_lengkap
-- Fungsi: Menghitung rincian finansial reservasi (kamar, tambahan, bayar, sisa).
-- Upgrade: Menyertakan tagihan pesanan restoran (Charge-to-Room) ke dalam grand total.
-- =============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_hitung_invoice_lengkap //

CREATE PROCEDURE sp_hitung_invoice_lengkap(
    IN  p_id_reservasi   INT,
    OUT p_biaya_kamar    DECIMAL(12,2),
    OUT p_biaya_tambahan DECIMAL(12,2),
    OUT p_grand_total    DECIMAL(12,2),
    OUT p_total_dibayar  DECIMAL(12,2),
    OUT p_sisa_tagihan   DECIMAL(12,2)
)
BEGIN
    DECLARE v_biaya_restoran DECIMAL(12,2) DEFAULT 0.00;

    -- [A] Hitung total biaya kamar dasar dari detail_reservasi
    SELECT COALESCE(SUM(subtotal), 0)
    INTO p_biaya_kamar
    FROM detail_reservasi
    WHERE id_reservasi = p_id_reservasi;

    -- [B] Ambil biaya tambahan dari tabel checkout
    SELECT COALESCE(biaya_tambahan, 0)
    INTO p_biaya_tambahan
    FROM checkout
    WHERE id_reservasi = p_id_reservasi;

    -- [B2] Ambil total tagihan restoran dengan status Charge-to-Room
    SELECT COALESCE(SUM(total_harga), 0)
    INTO v_biaya_restoran
    FROM pesanan_restoran
    WHERE id_reservasi = p_id_reservasi
      AND status_bayar = 'Charge-to-Room';

    -- [C] Kalkulasi Grand Total (Kamar + Biaya Tambahan + Restoran)
    SET p_grand_total = p_biaya_kamar + p_biaya_tambahan + v_biaya_restoran;

    -- [D] Hitung total uang yang sudah dibayar dengan status 'Lunas'
    SELECT COALESCE(SUM(jumlah_bayar), 0)
    INTO p_total_dibayar
    FROM pembayaran
    WHERE id_reservasi = p_id_reservasi 
      AND status_pembayaran = 'Lunas';

    -- [E] Hitung sisa tagihan akhir
    SET p_sisa_tagihan = p_grand_total - p_total_dibayar;
END //

DELIMITER ;


-- =============================================================================
-- 2. STORED PROCEDURE: sp_proses_pembayaran_aman
-- Fungsi: Mencatat pembayaran baru dengan validasi sisa tagihan & automasi status.
-- =============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_proses_pembayaran_aman //

CREATE PROCEDURE sp_proses_pembayaran_aman(
    IN  p_id_reservasi    INT,
    IN  p_jumlah_bayar    DECIMAL(12,2),
    IN  p_metode          ENUM('Tunai', 'Transfer', 'Kartu Kredit', 'E-Wallet'),
    IN  p_id_pegawai      INT,
    OUT p_status_pesan    VARCHAR(100)
)
BEGIN
    -- Deklarasi variabel internal untuk kalkulasi invoice
    DECLARE v_biaya_kamar    DECIMAL(12,2);
    DECLARE v_biaya_tambahan DECIMAL(12,2);
    DECLARE v_grand_total    DECIMAL(12,2);
    DECLARE v_total_dibayar  DECIMAL(12,2);
    DECLARE v_sisa_tagihan   DECIMAL(12,2);
    
    -- Ambil data invoice terkini (Reusability)
    CALL sp_hitung_invoice_lengkap(
        p_id_reservasi, 
        v_biaya_kamar, 
        v_biaya_tambahan, 
        v_grand_total, 
        v_total_dibayar, 
        v_sisa_tagihan
    );
    
    -- Validasi: Cegah pembayaran jika tagihan sudah lunas/minus
    IF v_sisa_tagihan <= 0 THEN
        SET p_status_pesan = 'GAGAL: Tagihan untuk reservasi ini sudah lunas.';
    ELSE
        -- Menggunakan Transaction untuk menjaga integritas data (ACID)
        START TRANSACTION;
            -- 1. Insert data pembayaran baru
            INSERT INTO pembayaran (id_reservasi, jumlah_bayar, metode_pembayaran, status_pembayaran)
            VALUES (p_id_reservasi, p_jumlah_bayar, p_metode, 'Lunas');
            
            -- 2. Rekalkulasi sisa tagihan terbaru
            SET v_total_dibayar = v_total_dibayar + p_jumlah_bayar;
            SET v_sisa_tagihan  = v_grand_total - v_total_dibayar;
            
            -- 3. Jika tagihan lunas, perbarui status reservasi (Khusus status 'Menunggu')
            UPDATE reservasi 
            SET status_reservasi = 'Dikonfirmasi' 
            WHERE id_reservasi = p_id_reservasi 
              AND status_reservasi = 'Menunggu' 
              AND v_sisa_tagihan <= 0;
            
            -- 4. Catat riwayat transaksi ke log aktivitas
            INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
            VALUES (
                p_id_pegawai, 
                'Mencatat Pembayaran', 
                CONCAT('Pembayaran sebesar Rp', FORMAT(p_jumlah_bayar, 0, 'id_ID'), ' berhasil dicatat untuk Reservasi ID ', p_id_reservasi)
            );
            
        COMMIT;
        SET p_status_pesan = CONCAT('SUKSES: Pembayaran berhasil. Sisa tagihan saat ini: Rp', FORMAT(v_sisa_tagihan, 0, 'id_ID'));
    END IF;
END //

DELIMITER ;


-- =============================================================================
-- 3. STORED PROCEDURE: sp_batal_reservasi_otomatis
-- Fungsi: Membatalkan reservasi secara aman, reset status kamar & proses refund.
-- =============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_batal_reservasi_otomatis //

CREATE PROCEDURE sp_batal_reservasi_otomatis(
    IN  p_id_reservasi INT,
    IN  p_id_pegawai   INT,
    OUT p_status_pesan VARCHAR(100)
)
BEGIN
    DECLARE v_status_sekarang VARCHAR(30);
    
    -- Ambil status reservasi saat ini
    SELECT status_reservasi INTO v_status_sekarang 
    FROM reservasi 
    WHERE id_reservasi = p_id_reservasi;
    
    -- Validasi: Reservasi yang sudah berjalan (Check-in/Selesai) tidak boleh dibatalkan
    IF v_status_sekarang IN ('Check-in', 'Selesai', 'Dibatalkan') THEN
        SET p_status_pesan = CONCAT('GAGAL: Reservasi tidak bisa dibatalkan karena status sudah ', v_status_sekarang);
    ELSE
        START TRANSACTION;
            -- 1. Ubah status master reservasi menjadi 'Dibatalkan'
            UPDATE reservasi 
            SET status_reservasi = 'Dibatalkan' 
            WHERE id_reservasi = p_id_reservasi;
            
            -- 2. Lepas plot/status kamar kembali menjadi 'Tersedia'
            UPDATE kamar 
            SET status_kamar = 'Tersedia' 
            WHERE id_kamar IN (
                SELECT id_kamar FROM detail_reservasi WHERE id_reservasi = p_id_reservasi
            );
            
            -- 3. Set semua pembayaran terkait menjadi status 'Refund'
            UPDATE pembayaran 
            SET status_pembayaran = 'Refund' 
            WHERE id_reservasi = p_id_reservasi;
            
            -- 4. Dokumentasikan pembatalan ke log aktivitas
            INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
            VALUES (
                p_id_pegawai, 
                'Pembatalan Reservasi', 
                CONCAT('Reservasi ID ', p_id_reservasi, ' dibatalkan. Kamar dikosongkan kembali.')
            );
            
        COMMIT;
        SET p_status_pesan = 'SUKSES: Reservasi berhasil dibatalkan dan status kamar telah diperbarui.';
    END IF;
END //

DELIMITER ;