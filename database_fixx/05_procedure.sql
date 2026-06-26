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

    -- [C] Kalkulasi Grand Total Murni (Kamar + Biaya Tambahan Checkout)
    SET p_grand_total = p_biaya_kamar + p_biaya_tambahan;

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
    DECLARE v_biaya_kamar    DECIMAL(12,2);
    DECLARE v_biaya_tambahan DECIMAL(12,2);
    DECLARE v_grand_total    DECIMAL(12,2);
    DECLARE v_total_dibayar  DECIMAL(12,2);
    DECLARE v_sisa_tagihan   DECIMAL(12,2);
    
    -- Ambil data invoice terkini lewat reusability call
    LOAD_INVOICE: BEGIN
        CALL sp_hitung_invoice_lengkap(
            p_id_reservasi, 
            v_biaya_kamar, 
            v_biaya_tambahan, 
            v_grand_total, 
            v_total_dibayar, 
            v_sisa_tagihan
        );
    END LOAD_INVOICE;
    
    -- Validasi keuangan: Cegah jika sudah lunas
    IF v_sisa_tagihan <= 0 THEN
        SET p_status_pesan = 'GAGAL: Tagihan untuk reservasi ini sudah lunas.';
    ELSE
        -- Menggunakan proteksi ACID transaction level
        START TRANSACTION;
            -- 1. Insert data pembayaran baru ke tabel fisik
            INSERT INTO pembayaran (id_reservasi, jumlah_bayar, metode_pembayaran, status_pembayaran)
            VALUES (p_id_reservasi, p_jumlah_bayar, p_metode, 'Lunas');
            
            -- 2. Rekalkulasi matematika sisa tagihan
            SET v_total_dibayar = v_total_dibayar + p_jumlah_bayar;
            SET v_sisa_tagihan  = v_grand_total - v_total_dibayar;
            
            -- 3. Jika lunas penuh, naikkan status dari 'Menunggu' menjadi 'Dikonfirmasi'
            UPDATE reservasi 
            SET status_reservasi = 'Dikonfirmasi' 
            WHERE id_reservasi = p_id_reservasi 
              AND status_reservasi = 'Menunggu' 
              AND v_sisa_tagihan <= 0;
            
            -- 4. Tembakkan histori audit trail ke log_aktivitas
            INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
            VALUES (
                p_id_pegawai, 
                'Mencatat Pembayaran', 
                CONCAT('Pembayaran sebesar Rp', FORMAT(p_jumlah_bayar, 0, 'id_ID'), ' sukses dicatat untuk Reservasi ID ', p_id_reservasi)
            );
            
        COMMIT;
        SET p_status_pesan = CONCAT('SUKSES: Pembayaran dicatat. Sisa tagihan: Rp', FORMAT(v_sisa_tagihan, 0, 'id_ID'));
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
    
    -- Tarik status master data saat ini
    SELECT status_reservasi INTO v_status_sekarang 
    FROM reservasi 
    WHERE id_reservasi = p_id_reservasi;
    
    -- Proteksi Aturan Bisnis: Kamar terisi atau selesai tidak boleh dicancel sepihak
    IF v_status_sekarang IN ('Check-in', 'Selesai', 'Dibatalkan') THEN
        SET p_status_pesan = CONCAT('GAGAL: Reservasi tidak bisa dibatalkan karena status sudah ', v_status_sekarang);
    ELSE
        START TRANSACTION;
            -- 1. Update status induk reservasi
            UPDATE reservasi 
            SET status_reservasi = 'Dibatalkan' 
            WHERE id_reservasi = p_id_reservasi;
            
            -- 2. Kembalikan status unit kamar menjadi 'Tersedia' agar bisa dijual kembali
            UPDATE kamar 
            SET status_kamar = 'Tersedia' 
            WHERE id_kamar IN (
                SELECT id_kamar FROM detail_reservasi WHERE id_reservasi = p_id_reservasi
            );
            
            -- 3. Set otomatis status keuangan menjadi 'Refund' demi keperluan pembukuan Akuntansi
            UPDATE pembayaran 
            SET status_pembayaran = 'Refund' 
            WHERE id_reservasi = p_id_reservasi;
            
            -- 4. Dokumentasikan pembatalan ke audit trail
            INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
            VALUES (
                p_id_pegawai, 
                'Pembatalan Reservasi', 
                CONCAT('Reservasi ID ', p_id_reservasi, ' dibatalkan otomatis. Status unit kamar di-reset.')
            );
            
        COMMIT;
        SET p_status_pesan = 'SUKSES: Reservasi berhasil dibatalkan dan alokasi kamar telah dibebaskan.';
    END IF;
END //

DELIMITER ;


-- =======================================================
-- Panduan Cara Pengujian
-- =======================================================
-- -- 1. Menguji fungsi hitung tagihan riil pada Reservasi ID 19 (Status: Menunggu, belum bayar penuh)
CALL sp_hitung_invoice_lengkap(19, @biaya_kmr, @biaya_add, @grand_total, @total_bayar, @sisa_tagihan);
SELECT @biaya_kmr AS Kamar, @biaya_add AS Tambahan, @grand_total AS Grand_Total, @total_bayar AS Paid, @sisa_tagihan AS Sisa;

-- 2. Melakukan eksekusi pembayaran lunas aman untuk Reservasi ID 19 oleh Pegawai Kasir ID 3
CALL sp_proses_pembayaran_aman(19, 1350000.00, 'Transfer', 3, @pesan_pembayaran);
SELECT @pesan_pembayaran AS 'Status Respon Sistem';

-- 3. Memverifikasi apakah log aktivitas keuangan otomatis tercatat di log internal
SELECT * FROM log_aktivitas ORDER BY waktu_aktivitas DESC LIMIT 1;
