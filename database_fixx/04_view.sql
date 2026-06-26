USE hotel_reservation_db;

-- =========================================================
-- 1. VIEW: DASHBOARD REAL-TIME RESERVASI TAMU
-- Fungsi: Menampilkan detail reservasi aktif/lalu secara lengkap.
-- Upgrade: Menambahkan format mata uang lokal (Rupiah) dan status pembayaran summary.
-- =========================================================
CREATE OR REPLACE VIEW vw_detail_reservasi_tamu AS
SELECT
    r.id_reservasi,
    t.nama_tamu,
    t.no_telepon,
    k.nomor_kamar,
    tk.nama_tipe,
    DATE_FORMAT(r.tanggal_reservasi, '%d-%m-%Y %H:%i') AS tanggal_booking,
    DATE_FORMAT(r.tanggal_checkin_rencana, '%d-%m-%Y') AS rencana_checkin,
    DATE_FORMAT(r.tanggal_checkout_rencana, '%d-%m-%Y') AS rencana_checkout,
    dr.jumlah_malam,
    dr.harga_per_malam,
    dr.subtotal,
    r.status_reservasi
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
JOIN kamar k ON dr.id_kamar = k.id_kamar
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar;


-- =========================================================
-- 2. VIEW: LAPORAN KEUANGAN & RIWAYAT PEMBAYARAN
-- Fungsi: Digunakan oleh Kasir/Finance untuk audit transaksi masuk.
-- Upgrade: Menggunakan DATETIME (sesuai DDL baru) dan mengurutkan secara kronologis.
-- =========================================================
CREATE OR REPLACE VIEW vw_laporan_keuangan AS
SELECT
    pb.id_pembayaran,
    r.id_reservasi,
    t.nama_tamu,
    DATE_FORMAT(pb.tanggal_pembayaran, '%d-%m-%Y %H:%i:%s') AS waktu_pembayaran,
    pb.jumlah_bayar,
    pb.metode_pembayaran,
    pb.status_pembayaran
FROM pembayaran pb
JOIN reservasi r ON pb.id_reservasi = r.id_reservasi
JOIN tamu t ON r.id_tamu = t.id_tamu;


-- =========================================================
-- 3. UPGRADE: VIEW REKAPITULASI BILL/BILLING UTAMA (BARU)
-- Fungsi: Menghitung total biaya kamar vs total yang sudah dibayar secara realtime per reservasi.
-- Kegunaan: Mengetahui secara instan apakah tamu "Kurang Bayar" atau "Lunas".
-- =========================================================
CREATE OR REPLACE VIEW vw_billing_reservasi_summary AS
SELECT 
    r.id_reservasi,
    t.id_tamu,
    t.nama_tamu,
    r.status_reservasi,
    
    -- 1. Total Biaya Kamar Dasar (Diambil bersih dari Subquery bk)
    IFNULL(bk.total_biaya_kamar, 0) AS total_biaya_kamar,
    
    -- 2. Biaya Tambahan dari Tabel Checkout (Jika ada)
    IFNULL(co.biaya_tambahan, 0) AS biaya_tambahan_checkout,
    
    -- 3. Grand Total Tagihan Murni (Hanya Kamar + Checkout)
    (IFNULL(bk.total_biaya_kamar, 0) + IFNULL(co.biaya_tambahan, 0)) AS grand_total_tagihan,
    
    -- 4. Total Uang yang Sudah Dibayar Lunas (Diambil dari Subquery pby)
    IFNULL(pby.total_telah_dibayar, 0) AS total_telah_dibayar,
    
    -- 5. Sisa Tagihan Akhir (Grand Total - Total Telah Dibayar)
    ((IFNULL(bk.total_biaya_kamar, 0) + IFNULL(co.biaya_tambahan, 0)) - 
     IFNULL(pby.total_telah_dibayar, 0)) AS sisa_tagihan

FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
LEFT JOIN checkout co ON r.id_reservasi = co.id_reservasi

-- Subquery A: Menghitung total biaya kamar secara terisolasi per reservasi
LEFT JOIN (
    SELECT id_reservasi, SUM(subtotal) AS total_biaya_kamar
    FROM detail_reservasi
    GROUP BY id_reservasi
) bk ON r.id_reservasi = bk.id_reservasi

-- Subquery B: Menghitung akumulasi pembayaran lunas (Mendukung Split Payment)
LEFT JOIN (
    SELECT id_reservasi, SUM(jumlah_bayar) AS total_telah_dibayar
    FROM pembayaran
    WHERE status_pembayaran = 'Lunas'
    GROUP BY id_reservasi
) pby ON r.id_reservasi = pby.id_reservasi;


-- =========================================================
-- 4. UPGRADE: VIEW OKUPANSI & STATUS KAMAR REAL-TIME (BARU)
-- Fungsi: Keperluan resepsionis (Front Office) saat mau memetakan kamar kosong/isi.
-- =========================================================
CREATE OR REPLACE VIEW vw_status_kamar_opsional AS 
SELECT  
    k.id_kamar, 
    k.nomor_kamar, 
    k.lantai, 
    tk.nama_tipe, 
    tk.harga_per_malam, 
    k.status_kamar, 
    
    -- 1. Menampilkan info tamu yang sedang menempati kamar saat ini (Sanitasi dengan IFNULL)
    CASE  
        WHEN k.status_kamar = 'Terisi' THEN (
            SELECT IFNULL(t.nama_tamu, '-')
            FROM detail_reservasi dr 
            JOIN reservasi r ON dr.id_reservasi = r.id_reservasi 
            JOIN tamu t ON r.id_tamu = t.id_tamu 
            WHERE dr.id_kamar = k.id_kamar 
              AND r.status_reservasi = 'Check-in' 
            LIMIT 1 
        ) 
        ELSE '-' 
    END AS nama_tamu_sekarang

FROM kamar k 
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar;


-- =========================================================
-- 5. UPGRADE: VIEW KINERJA PRODUKTIVITAS PEGAWAI (BARU)
-- Fungsi: Keperluan manajemen/HRD untuk melihat performa kerja staf (KPI).
-- =========================================================
CREATE OR REPLACE VIEW vw_performa_staf_operasional AS
SELECT 
    p.id_pegawai,
    p.nama_pegawai,
    p.jabatan,
    (SELECT COUNT(*) FROM reservasi WHERE id_pegawai = p.id_pegawai) AS jumlah_handle_reservasi,
    (SELECT COUNT(*) FROM checkin WHERE id_pegawai = p.id_pegawai) AS jumlah_handle_checkin,
    (SELECT COUNT(*) FROM checkout WHERE id_pegawai = p.id_pegawai) AS jumlah_handle_checkout
FROM pegawai p
WHERE p.is_active = 1;