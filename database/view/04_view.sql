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
    -- Memformat tanggal agar lebih mudah dibaca oleh UI Aplikasi
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
CREATE OR REPLACE VIEW vw_laporan_pembayaran AS
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
    -- Menghitung total biaya seluruh kamar yang dipesan di reservasi tersebut
    IFNULL(SUM(dr.subtotal), 0) AS total_biaya_kamar,
    -- Mengambil biaya tambahan saat checkout jika ada
    IFNULL(co.biaya_tambahan, 0) AS biaya_tambahan_checkout,
    -- Mengambil total tagihan belanja restoran yang digabung ke kamar
    IFNULL((SELECT SUM(total_harga) FROM pesanan_restoran WHERE id_reservasi = r.id_reservasi AND status_bayar = 'Charge-to-Room'), 0) AS total_biaya_restoran,
    -- Total keseluruhan yang harus dibayar (Kamar + Checkout + Restoran)
    (IFNULL(SUM(dr.subtotal), 0) + IFNULL(co.biaya_tambahan, 0) + 
     IFNULL((SELECT SUM(total_harga) FROM pesanan_restoran WHERE id_reservasi = r.id_reservasi AND status_bayar = 'Charge-to-Room'), 0)) AS grand_total_tagihan,
    -- Menghitung total uang yang sudah dibayar (mengantisipasi split payment)
    IFNULL((SELECT SUM(jumlah_bayar) FROM pembayaran WHERE id_reservasi = r.id_reservasi AND status_pembayaran = 'Lunas'), 0) AS total_telah_dibayar,
    -- Menghitung sisa tagihan secara matematis
    ((IFNULL(SUM(dr.subtotal), 0) + IFNULL(co.biaya_tambahan, 0) + 
      IFNULL((SELECT SUM(total_harga) FROM pesanan_restoran WHERE id_reservasi = r.id_reservasi AND status_bayar = 'Charge-to-Room'), 0)) - 
     IFNULL((SELECT SUM(jumlah_bayar) FROM pembayaran WHERE id_reservasi = r.id_reservasi AND status_pembayaran = 'Lunas'), 0)) AS sisa_tagihan
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
LEFT JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
LEFT JOIN checkout co ON r.id_reservasi = co.id_reservasi
GROUP BY r.id_reservasi, t.id_tamu, co.biaya_tambahan;


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
    -- Menampilkan info tamu yang sedang menempati kamar saat ini (jika ada)
    CASE 
        WHEN k.status_kamar = 'Terisi' THEN (
            SELECT t.nama_tamu 
            FROM detail_reservasi dr
            JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
            JOIN tamu t ON r.id_tamu = t.id_tamu
            WHERE dr.id_kamar = k.id_kamar AND r.status_reservasi = 'Check-in'
            LIMIT 1
        )
        ELSE '-'
    END AS nama_tamu_sekarang,
    -- Menampilkan total tagihan belanja restoran berjalan yang digabungkan ke kamar
    CASE 
        WHEN k.status_kamar = 'Terisi' THEN (
            SELECT IFNULL(SUM(pr.total_harga), 0)
            FROM detail_reservasi dr
            JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
            JOIN pesanan_restoran pr ON r.id_reservasi = pr.id_reservasi
            WHERE dr.id_kamar = k.id_kamar 
              AND r.status_reservasi = 'Check-in'
              AND pr.status_bayar = 'Charge-to-Room'
        )
        ELSE 0
    END AS tagihan_restoran
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