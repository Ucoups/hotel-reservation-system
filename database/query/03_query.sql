USE hotel_reservation_db;

-- Query sederhana 1: menampilkan semua tamu
SELECT * FROM tamu;

-- Query sederhana 2: menampilkan kamar yang tersedia
SELECT nomor_kamar, lantai, status_kamar
FROM kamar
WHERE status_kamar = 'Tersedia';

-- Query sederhana 3: menampilkan tipe kamar dengan harga di atas Rp500.000
SELECT nama_tipe, kapasitas, harga_per_malam
FROM tipe_kamar
WHERE harga_per_malam > 500000;

-- JOIN 1: detail reservasi lengkap dengan tamu dan pegawai
SELECT r.id_reservasi, t.nama_tamu, p.nama_pegawai, r.tanggal_checkin_rencana, r.tanggal_checkout_rencana, r.status_reservasi
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN pegawai p ON r.id_pegawai = p.id_pegawai;

-- JOIN 2: detail kamar yang dipesan
SELECT r.id_reservasi, t.nama_tamu, k.nomor_kamar, tk.nama_tipe, dr.jumlah_malam, dr.subtotal
FROM detail_reservasi dr
JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN kamar k ON dr.id_kamar = k.id_kamar
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar;

-- JOIN 3: laporan pembayaran per reservasi
SELECT pb.id_pembayaran, t.nama_tamu, r.id_reservasi, pb.tanggal_pembayaran, pb.jumlah_bayar, pb.metode_pembayaran, pb.status_pembayaran
FROM pembayaran pb
JOIN reservasi r ON pb.id_reservasi = r.id_reservasi
JOIN tamu t ON r.id_tamu = t.id_tamu;

-- JOIN 4: fasilitas pada setiap kamar
SELECT k.nomor_kamar, tk.nama_tipe, f.nama_fasilitas
FROM kamar_fasilitas kf
JOIN kamar k ON kf.id_kamar = k.id_kamar
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar
JOIN fasilitas f ON kf.id_fasilitas = f.id_fasilitas
ORDER BY k.nomor_kamar, f.nama_fasilitas;

-- Subquery 1: reservasi dengan total biaya di atas rata-rata
SELECT r.id_reservasi, t.nama_tamu, SUM(dr.subtotal) AS total_biaya
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
GROUP BY r.id_reservasi, t.nama_tamu
HAVING total_biaya > (
    SELECT AVG(total_reservasi)
    FROM (
        SELECT SUM(subtotal) AS total_reservasi
        FROM detail_reservasi
        GROUP BY id_reservasi
    ) x
);

-- CTE 1: ringkasan total pembayaran per reservasi
WITH total_pembayaran AS (
    SELECT id_reservasi, SUM(jumlah_bayar) AS total_bayar
    FROM pembayaran
    GROUP BY id_reservasi
)
SELECT r.id_reservasi, t.nama_tamu, COALESCE(tp.total_bayar, 0) AS total_bayar
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
LEFT JOIN total_pembayaran tp ON r.id_reservasi = tp.id_reservasi;

-- GROUP BY + HAVING: tamu dengan lebih dari satu reservasi
SELECT t.id_tamu, t.nama_tamu, COUNT(r.id_reservasi) AS jumlah_reservasi
FROM tamu t
JOIN reservasi r ON t.id_tamu = r.id_tamu
GROUP BY t.id_tamu, t.nama_tamu
HAVING COUNT(r.id_reservasi) >= 1;

