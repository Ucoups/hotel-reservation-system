USE hotel_reservation_db;

-- =============================================================================
-- 1. STORED FUNCTION: fn_hitung_durasi_malam
-- Fungsi: Menghitung selisih malam antara tanggal check-in dan check-out.
-- =============================================================================
DELIMITER //

DROP FUNCTION IF EXISTS fn_hitung_durasi_malam //

CREATE FUNCTION fn_hitung_durasi_malam(
    p_checkin  DATE,
    p_checkout DATE
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_durasi INT;
    
    -- Validasi: Jika tanggal tidak logis atau kosong, kembalikan nilai 0
    IF p_checkout <= p_checkin OR p_checkin IS NULL OR p_checkout IS NULL THEN
        RETURN 0;
    END IF;
    
    -- Hitung selisih hari/malam menggunakan fungsi bawaan DATEDIFF
    SET v_durasi = DATEDIFF(p_checkout, p_checkin);
    
    RETURN v_durasi;
END //

DELIMITER ;


-- =============================================================================
-- 2. STORED FUNCTION: fn_total_pendapatan_reservasi
-- Fungsi: Menghitung total piutang kotor (Kamar + Biaya Tambahan) per reservasi.
-- =============================================================================
DELIMITER //

DROP FUNCTION IF EXISTS fn_total_pendapatan_reservasi //

CREATE FUNCTION fn_total_pendapatan_reservasi(
    p_id_reservasi INT
)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total_kamar    DECIMAL(12,2);
    DECLARE v_total_tambahan DECIMAL(12,2);
    
    -- [A] Akumulasikan seluruh subtotal kamar pada detail reservasi
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_total_kamar
    FROM detail_reservasi
    WHERE id_reservasi = p_id_reservasi;
    
    -- [B] Ambil biaya tambahan dari transaksi check-out (jika sudah check-out)
    SELECT COALESCE(biaya_tambahan, 0)
    INTO v_total_tambahan
    FROM checkout
    WHERE id_reservasi = p_id_reservasi;
    
    -- [C] Kembalikan total akumulasi finansial
    RETURN v_total_kamar + v_total_tambahan;
END //

DELIMITER ;


-- =============================================================================
-- 3. STORED FUNCTION: fn_cek_status_pembayaran
-- Fungsi: Membandingkan total tagihan vs total bayar untuk menentukan status billing.
-- =============================================================================
DELIMITER //

DROP FUNCTION IF EXISTS fn_cek_status_pembayaran //

CREATE FUNCTION fn_cek_status_pembayaran(
    p_id_reservasi INT
)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE v_total_tagihan DECIMAL(12,2);
    DECLARE v_total_bayar   DECIMAL(12,2);
    
    -- [A] Dapatkan total tagihan menggunakan fungsi sebelumnya (Reusability)
    SET v_total_tagihan = fn_total_pendapatan_reservasi(p_id_reservasi);
    
    -- [B] Hitung total akumulasi pembayaran riil yang berstatus 'Lunas'
    SELECT COALESCE(SUM(jumlah_bayar), 0)
    INTO v_total_bayar
    FROM pembayaran
    WHERE id_reservasi = p_id_reservasi 
      AND status_pembayaran = 'Lunas';
    
    -- [C] Evaluasi logika penentuan status teks billing
    IF v_total_bayar = 0 THEN
        RETURN 'BELUM BAYAR';
    ELSEIF v_total_bayar < v_total_tagihan THEN
        RETURN 'KURANG BAYAR';
    ELSE
        RETURN 'LUNAS';
    END IF;
END //

DELIMITER ;



-- =========================================================
-- Contoh Penggunaan:
-- =========================================================
-- 1. Uji fungsi kalkulasi durasi malam secara mandiri
SELECT fn_hitung_durasi_malam('2026-06-01', '2026-06-05') AS jumlah_malam;

-- 2. Uji fungsi kalkulasi total pendapatan kotor dari Reservasi ID: 1
SELECT fn_total_pendapatan_reservasi(1) AS grand_total_invoice;

-- 3. Uji fungsi pemantauan status tagihan finansial dari Reservasi ID: 13
SELECT fn_cek_status_pembayaran(13) AS status_bill;

-- 4. IMPLEMENTASI PRO: Menggabungkan seluruh fungsi ke dalam satu query laporan bersih
SELECT 
    id_reservasi,
    tanggal_checkin_rencana,
    tanggal_checkout_rencana,
    fn_hitung_durasi_malam(tanggal_checkin_rencana, tanggal_checkout_rencana) AS 'Durasi (Malam)',
    fn_total_pendapatan_reservasi(id_reservasi) AS 'Total Tagihan',
    fn_cek_status_pembayaran(id_reservasi) AS 'Status Keuangan'
FROM reservasi;