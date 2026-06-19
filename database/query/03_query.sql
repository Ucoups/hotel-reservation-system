USE hotel_reservation_db;

-- =============================================================================
-- KELOMPOK 1: QUERY OPERASIONAL HARIAN (FRONT OFFICE & RESERVASI)
-- =============================================================================

-- Query 1.1: Pemantauan Kamar Siap Jual & Status Pemeliharaan Real-time
-- Kegunaan: Membantu resepsionis melihat kamar mana yang bisa langsung di-check-in.
SELECT 
    k.nomor_kamar, 
    k.lantai, 
    tk.nama_tipe, 
    CONCAT('Rp', FORMAT(tk.harga_per_malam, 0, 'id_ID')) AS harga_per_malam,
    k.status_kamar
FROM kamar k
JOIN tipe_kamar tk 
    ON k.id_tipe_kamar = tk.id_tipe_kamar
WHERE k.status_kamar IN ('Tersedia', 'Perawatan')
ORDER BY k.lantai ASC, k.nomor_kamar ASC;


-- Query 1.2: Manifest Log Check-In Hari Ini Lengkap dengan Detail Tamu
-- Kegunaan: Daftar dokumen pegangan Front Office untuk menyambut tamu datang.
SELECT 
    r.id_reservasi, 
    t.nama_tamu, 
    t.no_telepon,
    GROUP_CONCAT(k.nomor_kamar SEPARATOR ', ') AS kamar_dipesan,
    DATE_FORMAT(r.tanggal_checkin_rencana, '%d-%m-%Y') AS jadwal_checkin,
    DATE_FORMAT(r.tanggal_checkout_rencana, '%d-%m-%Y') AS jadwal_checkout,
    r.status_reservasi
FROM reservasi r
JOIN tamu t 
    ON r.id_tamu = t.id_tamu
JOIN detail_reservasi dr 
    ON r.id_reservasi = dr.id_reservasi
JOIN kamar k 
    ON dr.id_kamar = k.id_kamar
GROUP BY 
    r.id_reservasi, 
    t.nama_tamu, 
    t.no_telepon, 
    r.tanggal_checkin_rencana, 
    r.tanggal_checkout_rencana, 
    r.status_reservasi
ORDER BY r.tanggal_checkin_rencana DESC;


-- Query 1.3: Pemetaan Fasilitas Spesifik per Nomor Kamar
-- Kegunaan: Memberikan informasi akurat ke tamu mengenai benefit kamar mereka.
SELECT 
    k.nomor_kamar, 
    tk.nama_tipe, 
    GROUP_CONCAT(f.nama_fasilitas SEPARATOR ' | ') AS daftar_fasilitas
FROM kamar_fasilitas kf
JOIN kamar k 
    ON kf.id_kamar = k.id_kamar
JOIN tipe_kamar tk 
    ON k.id_tipe_kamar = tk.id_tipe_kamar
JOIN fasilitas f 
    ON kf.id_fasilitas = f.id_fasilitas
GROUP BY k.nomor_kamar, tk.nama_tipe
ORDER BY k.nomor_kamar ASC;


-- =============================================================================
-- KELOMPOK 2: QUERY AUDIT KEUANGAN & PEMBAYARAN (CASHIER & FINANCE)
-- =============================================================================

-- Query 2.1: Laporan Invoice / Total Tagihan Akhir Tamu Lengkap
-- Kegunaan: Menghitung total tagihan (Kamar + Total Malam + Biaya Tambahan Checkout).
SELECT 
    r.id_reservasi AS 'ID Reservasi',
    t.nama_tamu AS 'Nama Tamu',
    GROUP_CONCAT(DISTINCT k.nomor_kamar SEPARATOR ', ') AS 'Nomor Kamar',
    GROUP_CONCAT(DISTINCT tk.nama_tipe SEPARATOR ', ') AS 'Jenis Tipe Kamar',
    SUM(dr.jumlah_malam) AS 'Total Malam (Semua Kamar)',
    COUNT(dr.id_kamar) AS 'Jumlah Kamar Dipesan',
    DATE_FORMAT(ci.waktu_checkin, '%d-%m-%Y %H:%i') AS 'Waktu Check-In',
    DATE_FORMAT(co.waktu_checkout, '%d-%m-%Y %H:%i') AS 'Waktu Check-Out',
    CONCAT('Rp', FORMAT(SUM(dr.subtotal), 0, 'id_ID')) AS 'Total Biaya Kamar Dasar',
    CONCAT('Rp', FORMAT(COALESCE(co.biaya_tambahan, 0), 0, 'id_ID')) AS 'Biaya Tambahan Checkout',
    CONCAT('Rp', FORMAT(SUM(dr.subtotal) + COALESCE(co.biaya_tambahan, 0), 0, 'id_ID')) AS 'GRAND TOTAL TAGIHAN'
FROM reservasi r
JOIN tamu t 
    ON r.id_tamu = t.id_tamu
JOIN detail_reservasi dr 
    ON r.id_reservasi = dr.id_reservasi
JOIN kamar k 
    ON dr.id_kamar = k.id_kamar
JOIN tipe_kamar tk 
    ON k.id_tipe_kamar = tk.id_tipe_kamar
LEFT JOIN checkin ci 
    ON r.id_reservasi = ci.id_reservasi
LEFT JOIN checkout co 
    ON r.id_reservasi = co.id_reservasi
GROUP BY 
    r.id_reservasi, 
    t.nama_tamu, 
    ci.waktu_checkin, 
    co.waktu_checkout, 
    co.biaya_tambahan
ORDER BY r.id_reservasi ASC;


-- =============================================================================
-- KELOMPOK 3: QUERY ANALISIS EKSEKUTIF (MANAGEMENT REPORT & CTE)
-- =============================================================================

-- Query 3.1: Laporan Tren Pendapatan Bulanan Hotel (Metode Bisnis Pro)
-- Kegunaan: Bahan meeting bulanan Direksi untuk melihat pertumbuhan omset.
WITH PendapatanBulanan AS (
    SELECT 
        DATE_FORMAT(tanggal_pembayaran, '%Y-%m') AS periode,
        SUM(jumlah_bayar) AS total_omset,
        COUNT(id_pembayaran) AS total_transaksi
    FROM pembayaran
    WHERE status_pembayaran = 'Lunas'
    GROUP BY DATE_FORMAT(tanggal_pembayaran, '%Y-%m')
)
SELECT 
    periode,
    total_transaksi,
    CONCAT('Rp', FORMAT(total_omset, 0, 'id_ID')) AS omset_bersih_bulanan
FROM PendapatanBulanan
ORDER BY periode DESC;


-- Query 3.2: Analisis Kamar Terlaris (Tingkat Okupansi Berdasarkan Tipe Kamar)
-- Kegunaan: Strategi marketing untuk mengetahui tipe kamar mana yang paling diminati pasar.
SELECT 
    tk.nama_tipe,
    COUNT(dr.id_kamar) AS total_kali_dipesan,
    SUM(dr.jumlah_malam) AS akumulasi_malam_terjual,
    CONCAT('Rp', FORMAT(SUM(dr.subtotal), 0, 'id_ID')) AS kontribusi_pendapatan
FROM detail_reservasi dr
JOIN kamar k 
    ON dr.id_kamar = k.id_kamar
JOIN tipe_kamar tk 
    ON k.id_tipe_kamar = tk.id_tipe_kamar
GROUP BY tk.id_tipe_kamar, tk.nama_tipe
ORDER BY total_kali_dipesan DESC;


-- Query 3.3: Deteksi Tamu Loyal / Pelanggan Setia (Loyalty Program)
-- Kegunaan: Menentukan tamu yang berhak mendapatkan diskon khusus member/reward khusus.
SELECT 
    t.id_tamu, 
    t.nama_tamu, 
    t.email,
    COUNT(r.id_reservasi) AS total_kunjungan,
    GROUP_CONCAT(DISTINCT r.status_reservasi SEPARATOR ', ') AS histori_status
FROM tamu t
JOIN reservasi r 
    ON t.id_tamu = r.id_tamu
GROUP BY t.id_tamu, t.nama_tamu, t.email
HAVING total_kunjungan >= 2
ORDER BY total_kunjungan DESC;