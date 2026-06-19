USE hotel_reservation_db;

-- =========================================================
-- DML DATA DUMMY SISTEM RESERVASI HOTEL PRO
-- DBMS: MySQL 8.0 / 8.4
-- =========================================================

-- 1. INSERT DATA TAMU (Termasuk flag is_active)
INSERT INTO tamu (id_tamu, nama_tamu, no_identitas, jenis_kelamin, no_telepon, email, alamat, is_active) VALUES
(1, 'Andi Pratama', '1001', 'Laki-laki', '081234567801', 'andi.pratama@example.com', 'Jl. Melati No. 10, Jakarta', 1),
(2, 'Siti Rahmawati', '1002', 'Perempuan', '081234567802', 'siti.rahmawati@example.com', 'Jl. Braga No. 25, Bandung', 1),
(3, 'Budi Santoso', '1003', 'Laki-laki', '081234567803', 'budi.santoso@example.com', 'Jl. Diponegoro No. 8, Surabaya', 1),
(4, 'Dewi Lestari', '1004', 'Perempuan', '081234567804', 'dewi.lestari@example.com', 'Jl. Malioboro No. 15, Yogyakarta', 1),
(5, 'Rizky Ramadhan', '1005', 'Laki-laki', '081234567805', 'rizky.ramadhan@example.com', 'Jl. Sudirman No. 21, Tangerang', 1),
(6, 'Nadia Putri', '1006', 'Perempuan', '081234567806', 'nadia.putri@example.com', 'Jl. Ahmad Yani No. 9, Bekasi', 1),
(7, 'Hendra Wijaya', '1007', 'Laki-laki', '081234567807', 'hendra.wijaya@example.com', 'Jl. Gejayan No. 12, Yogyakarta', 1),
(8, 'Maya Sari', '1008', 'Perempuan', '081234567808', 'maya.sari@example.com', 'Jl. Pengayoman No. 18, Makassar', 1),
(9, 'Arief Nugraha', '1009', 'Laki-laki', '081234567809', 'arief.nugraha@example.com', 'Jl. Margonda Raya No. 30, Depok', 1),
(10, 'Lina Marlina', '1010', 'Perempuan', '081234567810', 'lina.marlina@example.com', 'Jl. Veteran No. 5, Malang', 1),
(11, 'Fauzan Akbar', '1011', 'Laki-laki', '081234567811', 'fauzan.akbar@example.com', 'Jl. Mulawarman No. 7, Balikpapan', 1),
(12, 'Intan Permata', '1012', 'Perempuan', '081234567812', 'intan.permata@example.com', 'Jl. Teuku Umar No. 16, Denpasar', 1),
(13, 'Yoga Saputra', '1013', 'Laki-laki', '081234567813', 'yoga.saputra@example.com', 'Jl. Khatib Sulaiman No. 11, Padang', 1),
(14, 'Putri Amelia', '1014', 'Perempuan', '081234567814', 'putri.amelia@example.com', 'Jl. Sisingamangaraja No. 22, Medan', 1),
(15, 'Agus Setiawan', '1015', 'Laki-laki', '081234567815', 'agus.setiawan@example.com', 'Jl. Basuki Rahmat No. 3, Palembang', 1),
(16, 'Citra Anjani', '1016', 'Perempuan', '081234567816', 'citra.anjani@example.com', 'Jl. Slamet Riyadi No. 40, Solo', 1),
(17, 'Dimas Arya', '1017', 'Laki-laki', '081234567817', 'dimas.arya@example.com', 'Jl. Serpong Raya No. 19, Tangerang Selatan', 1),
(18, 'Rani Maharani', '1018', 'Perempuan', '081234567818', 'rani.maharani@example.com', 'Jl. Asia Afrika No. 14, Bandung', 1),
(19, 'Teguh Firmansyah', '1019', 'Laki-laki', '081234567819', 'teguh.firmansyah@example.com', 'Jl. Gatot Subroto No. 28, Jakarta', 1),
(20, 'Selvi Oktaviani', '1020', 'Perempuan', '081234567820', 'selvi.oktaviani@example.com', 'Jl. Imam Bonjol No. 6, Serang', 1);

-- 2. INSERT DATA PEGAWAI (Termasuk flag is_active)
INSERT INTO pegawai (id_pegawai, nama_pegawai, jabatan, no_telepon, email, is_active) VALUES
(1, 'Rina Kartika', 'Resepsionis', '081300000001', 'rina.kartika@hotel.local', 1),
(2, 'Fajar Nugroho', 'Supervisor Front Office', '081300000002', 'fajar.nugroho@hotel.local', 1),
(3, 'Maya Puspita', 'Kasir', '081300000003', 'maya.puspita@hotel.local', 1),
(4, 'Doni Saputra', 'Resepsionis', '081300000004', 'doni.saputra@hotel.local', 1),
(5, 'Ayu Wulandari', 'Housekeeping', '081300000005', 'ayu.wulandari@hotel.local', 1),
(6, 'Bagus Prakoso', 'Manager Operasional', '081300000006', 'bagus.prakoso@hotel.local', 1),
(7, 'Nina Herlina', 'Customer Service', '081300000007', 'nina.herlina@hotel.local', 1),
(8, 'Rafael Aditya', 'Night Auditor', '081300000008', 'rafael.aditya@hotel.local', 1),
(9, 'Salsa Kirana', 'Kasir', '081300000009', 'salsa.kirana@hotel.local', 1),
(10, 'Wahyu Hidayat', 'Bellboy', '081300000010', 'wahyu.hidayat@hotel.local', 1);

-- 3. INSERT DATA TIPE KAMAR
INSERT INTO tipe_kamar (id_tipe_kamar, nama_tipe, kapasitas, harga_per_malam, deskripsi) VALUES
(1, 'Standard', 2, 350000.00, 'Kamar standar untuk tamu individu atau pasangan dengan fasilitas dasar.'),
(2, 'Superior', 2, 450000.00, 'Kamar superior dengan area lebih luas dan fasilitas tambahan.'),
(3, 'Deluxe', 2, 600000.00, 'Kamar deluxe dengan interior lebih nyaman dan pemandangan kota.'),
(4, 'Family', 4, 850000.00, 'Kamar keluarga dengan kapasitas lebih besar.'),
(5, 'Suite', 4, 1250000.00, 'Kamar suite premium dengan ruang duduk dan fasilitas lengkap.');

-- 4. INSERT DATA FASILITAS
INSERT INTO fasilitas (id_fasilitas, nama_fasilitas, deskripsi) VALUES
(1, 'Wi-Fi', 'Akses internet nirkabel di kamar dan area hotel.'),
(2, 'AC', 'Pendingin ruangan pribadi di dalam kamar.'),
(3, 'TV LED', 'Televisi LED dengan saluran lokal dan internasional.'),
(4, 'Mini Bar', 'Lemari pendingin kecil untuk minuman dan makanan ringan.'),
(5, 'Breakfast', 'Sarapan pagi untuk tamu hotel.'),
(6, 'Kolam Renang', 'Akses kolam renang hotel.'),
(7, 'Gym', 'Akses pusat kebugaran hotel.'),
(8, 'Bathtub', 'Bak mandi pribadi di kamar.'),
(9, 'Room Service', 'Layanan pemesanan makanan dan minuman ke kamar.'),
(10, 'Laundry', 'Layanan pencucian pakaian tamu.');

-- 5. INSERT DATA KAMAR
INSERT INTO kamar (id_kamar, id_tipe_kamar, nomor_kamar, lantai, status_kamar) VALUES
(1, 1, '101', '1', 'Tersedia'),
(2, 1, '102', '1', 'Dipesan'),
(3, 1, '103', '1', 'Terisi'),
(4, 1, '104', '1', 'Tersedia'),
(5, 1, '105', '1', 'Perawatan'),
(6, 2, '201', '2', 'Dipesan'),
(7, 2, '202', '2', 'Terisi'),
(8, 2, '203', '2', 'Tersedia'),
(9, 2, '204', '2', 'Tersedia'),
(10, 2, '205', '2', 'Dipesan'),
(11, 3, '301', '3', 'Terisi'),
(12, 3, '302', '3', 'Dipesan'),
(13, 3, '303', '3', 'Tersedia'),
(14, 3, '304', '3', 'Tersedia'),
(15, 3, '305', '3', 'Dipesan'),
(16, 4, '401', '4', 'Terisi'),
(17, 4, '402', '4', 'Dipesan'),
(18, 4, '403', '4', 'Tersedia'),
(19, 4, '404', '4', 'Tersedia'),
(20, 4, '405', '4', 'Dipesan'),
(21, 5, '501', '5', 'Terisi'),
(22, 5, '502', '5', 'Dipesan'),
(23, 5, '503', '5', 'Tersedia'),
(24, 5, '504', '5', 'Tersedia'),
(25, 5, '505', '5', 'Dipesan');

-- 6. INSERT DATA RESERVASI (Tanggal Reservasi menggunakan format DATETIME)
INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi) VALUES
(1, 1, 1, '2026-05-01 09:15:00', '2026-05-10', '2026-05-12', 'Selesai'),
(2, 2, 1, '2026-05-02 10:30:00', '2026-05-11', '2026-05-14', 'Selesai'),
(3, 3, 2, '2026-05-03 14:22:00', '2026-05-12', '2026-05-14', 'Selesai'),
(4, 4, 4, '2026-05-04 11:05:00', '2026-05-13', '2026-05-17', 'Selesai'),
(5, 5, 7, '2026-05-05 16:40:00', '2026-05-15', '2026-05-17', 'Selesai'),
(6, 6, 1, '2026-05-06 08:12:00', '2026-05-16', '2026-05-17', 'Selesai'),
(7, 7, 2, '2026-05-07 13:50:00', '2026-05-18', '2026-05-20', 'Selesai'),
(8, 8, 4, '2026-05-08 10:15:00', '2026-05-19', '2026-05-22', 'Selesai'),
(9, 9, 7, '2026-05-09 15:30:00', '2026-05-20', '2026-05-22', 'Selesai'),
(10, 10, 1, '2026-05-10 11:20:00', '2026-05-21', '2026-05-24', 'Selesai'),
(11, 11, 2, '2026-05-11 09:00:00', '2026-06-01', '2026-06-03', 'Check-in'),
(12, 12, 4, '2026-05-12 14:45:00', '2026-06-02', '2026-06-03', 'Check-in'),
(13, 13, 7, '2026-05-13 17:10:00', '2026-06-05', '2026-06-08', 'Dikonfirmasi'),
(14, 14, 1, '2026-05-14 10:00:00', '2026-06-06', '2026-06-08', 'Dikonfirmasi'),
(15, 15, 2, '2026-05-15 11:35:00', '2026-06-09', '2026-06-13', 'Dikonfirmasi'),
(16, 16, 4, '2026-05-16 13:20:00', '2026-06-10', '2026-06-12', 'Dikonfirmasi'),
(17, 17, 7, '2026-05-17 16:15:00', '2026-06-12', '2026-06-13', 'Dikonfirmasi'),
(18, 18, 1, '2026-05-18 09:50:00', '2026-06-14', '2026-06-16', 'Dikonfirmasi'),
(19, 19, 2, '2026-05-19 14:05:00', '2026-06-17', '2026-06-20', 'Menunggu'),
(20, 20, 4, '2026-05-20 11:30:00', '2026-06-18', '2026-06-20', 'Menunggu'),
(21, 3, 7, '2026-05-21 10:00:00', '2026-06-21', '2026-06-23', 'Dibatalkan'),
(22, 8, 1, '2026-05-22 15:25:00', '2026-06-24', '2026-06-25', 'Dikonfirmasi');

-- 7. INSERT DATA DETAIL RESERVASI (Kolom subtotal dibuang karena sudah AUTO-GENERATED)
INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam) VALUES
(1, 1, 1, 2, 350000.00),
(2, 2, 6, 3, 450000.00),
(3, 3, 11, 2, 600000.00),
(4, 4, 16, 4, 850000.00),
(5, 5, 21, 2, 1250000.00),
(6, 6, 2, 1, 350000.00),
(7, 6, 3, 1, 350000.00),
(8, 7, 7, 2, 450000.00),
(9, 8, 12, 3, 600000.00),
(10, 9, 17, 2, 850000.00),
(11, 10, 22, 3, 1250000.00),
(12, 11, 4, 2, 350000.00),
(13, 11, 8, 2, 450000.00),
(14, 12, 13, 1, 600000.00),
(15, 13, 18, 3, 850000.00),
(16, 14, 23, 2, 1250000.00),
(17, 15, 5, 4, 350000.00),
(18, 16, 9, 2, 450000.00),
(19, 16, 14, 2, 600000.00),
(20, 17, 19, 1, 850000.00),
(21, 18, 24, 2, 1250000.00),
(22, 19, 10, 3, 450000.00),
(23, 20, 15, 2, 600000.00),
(24, 21, 20, 2, 850000.00),
(25, 22, 25, 1, 1250000.00),
(26, 22, 1, 1, 350000.00);

-- 8. INSERT DATA PEMBAYARAN (Menggunakan DATETIME)
INSERT INTO pembayaran (id_pembayaran, id_reservasi, tanggal_pembayaran, jumlah_bayar, metode_pembayaran, status_pembayaran) VALUES
(1, 1, '2026-05-01 09:20:00', 400000.00, 'Transfer', 'Lunas'),
(2, 1, '2026-05-01 09:25:00', 300000.00, 'Kartu Kredit', 'Lunas'), 
(3, 2, '2026-05-02 10:45:00', 1350000.00, 'Kartu Kredit', 'Lunas'),
(4, 3, '2026-05-03 14:30:00', 1200000.00, 'E-Wallet', 'Lunas'),
(5, 4, '2026-05-04 11:15:00', 3400000.00, 'Transfer', 'Lunas'),
(6, 5, '2026-05-05 16:55:00', 2500000.00, 'Kartu Kredit', 'Lunas'),
(7, 6, '2026-05-06 08:30:00', 700000.00, 'Tunai', 'Lunas'),
(8, 7, '2026-05-07 14:00:00', 900000.00, 'Transfer', 'Lunas'),
(9, 8, '2026-05-08 10:30:00', 1800000.00, 'E-Wallet', 'Lunas'),
(10, 9, '2026-05-09 15:45:00', 1700000.00, 'Kartu Kredit', 'Lunas'),
(11, 10, '2026-05-10 11:40:00', 3750000.00, 'Transfer', 'Lunas'),
(12, 11, '2026-05-11 09:15:00', 1600000.00, 'Transfer', 'Lunas'),
(13, 12, '2026-05-12 15:00:00', 600000.00, 'Tunai', 'Lunas'),
(14, 13, '2026-05-13 17:25:00', 2550000.00, 'Transfer', 'Pending'),
(15, 14, '2026-05-14 10:15:00', 2500000.00, 'Kartu Kredit', 'Lunas'),
(16, 15, '2026-05-15 11:50:00', 1400000.00, 'E-Wallet', 'Pending'),
(17, 16, '2026-05-16 13:45:00', 2100000.00, 'Transfer', 'Lunas'),
(18, 17, '2026-05-17 16:30:00', 850000.00, 'Tunai', 'Lunas'),
(19, 18, '2026-05-18 10:00:00', 2500000.00, 'Kartu Kredit', 'Pending'),
(20, 19, '2026-05-19 14:20:00', 1350000.00, 'Transfer', 'Pending'),
(21, 20, '2026-05-20 11:45:00', 1200000.00, 'E-Wallet', 'Pending'),
(22, 21, '2026-05-21 10:30:00', 1700000.00, 'Transfer', 'Refund'),
(23, 1, '2026-05-12 11:00:00', 100000.00, 'Tunai', 'Lunas');

-- 9. INSERT DATA CHECK-IN
INSERT INTO checkin (id_checkin, id_reservasi, waktu_checkin, id_pegawai, catatan) VALUES
(1, 1, '2026-05-10 14:05:00', 1, 'Tamu datang tepat waktu dan kamar siap digunakan.'),
(2, 2, '2026-05-11 14:20:00', 4, 'Check-in berjalan normal.'),
(3, 3, '2026-05-12 15:10:00', 1, 'Tamu meminta kamar bebas asap rokok.'),
(4, 4, '2026-05-13 13:55:00', 2, 'Tamu keluarga membawa dua anak.'),
(5, 5, '2026-05-15 14:30:00', 7, 'Tamu meminta tambahan bantal.'),
(6, 6, '2026-05-16 16:00:00', 4, 'Dua kamar standard digunakan untuk rombongan kecil.'),
(7, 7, '2026-05-18 14:15:00', 1, 'Check-in tanpa kendala.'),
(8, 8, '2026-05-19 15:25:00', 2, 'Tamu menitipkan koper di concierge.'),
(9, 9, '2026-05-20 14:40:00', 7, 'Tamu meminta late checkout jika memungkinkan.'),
(10, 10, '2026-05-21 13:50:00', 1, 'Tamu suite melakukan check-in lebih awal.'),
(11, 11, '2026-06-01 14:10:00', 4, 'Status reservasi otomatis berubah menjadi check-in via trigger.'),
(12, 12, '2026-06-02 15:00:00', 7, 'Tamu mengonfirmasi sarapan untuk dua orang.');

-- 10. INSERT DATA CHECK-OUT
INSERT INTO checkout (id_checkout, id_reservasi, waktu_checkout, id_pegawai, biaya_tambahan, catatan) VALUES
(1, 1, '2026-05-12 11:00:00', 2, 0.00, 'Check-out selesai tanpa biaya tambahan.'),
(2, 2, '2026-05-14 10:45:00', 4, 50000.00, 'Tambahan biaya laundry.'),
(3, 3, '2026-05-14 11:10:00', 1, 0.00, 'Kamar dikembalikan dalam kondisi baik.'),
(4, 4, '2026-05-17 11:25:00', 2, 100000.00, 'Tambahan room service.'),
(5, 5, '2026-05-17 10:55:00', 7, 0.00, 'Tamu puas dengan layanan suite.'),
(6, 6, '2026-05-17 11:15:00', 4, 0.00, 'Check-out rombongan selesai.'),
(7, 7, '2026-05-20 11:05:00', 1, 75000.00, 'Tambahan minibar.'),
(8, 8, '2026-05-22 10:50:00', 2, 0.00, 'Check-out normal.'),
(9, 9, '2026-05-22 12:00:00', 7, 150000.00, 'Tambahan late checkout.'),
(10, 10, '2026-05-24 11:30:00', 1, 0.00, 'Check-out suite selesai, status kamar kembali tersedia.');

-- 11. INSERT DATA KAMAR FASILITAS
INSERT INTO kamar_fasilitas (id_kamar, id_fasilitas) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3),
(4, 1), (4, 2), (4, 3),
(5, 1), (5, 2), (5, 3),
(6, 1), (6, 2), (6, 3), (6, 5),
(7, 1), (7, 2), (7, 3), (7, 5),
(8, 1), (8, 2), (8, 3), (8, 5),
(9, 1), (9, 2), (9, 3), (9, 5),
(10, 1), (10, 2), (10, 3), (10, 5),
(11, 1), (11, 2), (11, 3), (11, 4), (11, 5), (11, 9),
(12, 1), (12, 2), (12, 3), (12, 4), (12, 5), (12, 9),
(13, 1), (13, 2), (13, 3), (13, 4), (13, 5), (13, 9),
(14, 1), (14, 2), (14, 3), (14, 4), (14, 5), (14, 9),
(15, 1), (15, 2), (15, 3), (15, 4), (15, 5), (15, 9),
(16, 1), (16, 2), (16, 3), (16, 5), (16, 6), (16, 9), (16, 10),
(17, 1), (17, 2), (17, 3), (17, 5), (17, 6), (17, 9), (17, 10),
(18, 1), (18, 2), (18, 3), (18, 5), (18, 6), (18, 9), (18, 10),
(19, 1), (19, 2), (19, 3), (19, 5), (19, 6), (19, 9), (19, 10),
(20, 1), (20, 2), (20, 3), (20, 5), (20, 6), (20, 9), (20, 10),
(21, 1), (21, 2), (21, 3), (21, 4), (21, 5), (21, 6), (21, 7), (21, 8), (21, 9), (21, 10),
(22, 1), (22, 2), (22, 3), (22, 4), (22, 5), (22, 6), (22, 7), (22, 8), (22, 9), (22, 10),
(23, 1), (23, 2), (23, 3), (23, 4), (23, 5), (23, 6), (23, 7), (23, 8), (23, 9), (23, 10),
(24, 1), (24, 2), (24, 3), (24, 4), (24, 5), (24, 6), (24, 7), (24, 8), (24, 9), (24, 10),
(25, 1), (25, 2), (25, 3), (25, 4), (25, 5), (25, 6), (25, 7), (25, 8), (25, 9), (25, 10);

-- 12. INSERT DATA LOG AKTIVITAS
INSERT INTO log_aktivitas (id_log, id_pegawai, aktivitas, waktu_aktivitas, keterangan) VALUES
(1, 1, 'Membuat Reservasi', '2026-05-01 09:15:00', 'Reservasi ID 1 dibuat untuk tamu Andi Pratama.'),
(2, 3, 'Mencatat Pembayaran', '2026-05-02 10:20:00', 'Pembayaran reservasi ID 2 dicatat lunas.'),
(3, 4, 'Proses Check-in', '2026-05-11 14:20:00', 'Check-in reservasi ID 2 berhasil dilakukan.'),
(4, 2, 'Proses Check-out', '2026-05-14 10:45:00', 'Check-out reservasi ID 2 selesai dengan biaya laundry.'),
(5, 7, 'Konfirmasi Reservasi', '2026-05-15 11:00:00', 'Reservasi ID 15 dikonfirmasi oleh customer service.'),
(6, 9, 'Mencatat Pembayaran', '2026-05-16 13:30:00', 'Pembayaran reservasi ID 16 diterima melalui transfer.'),
(7, 1, 'Update Status Kamar', '2026-05-17 12:00:00', 'Status kamar diperbarui setelah check-out.'),
(8, 5, 'Pemeriksaan Kamar', '2026-05-18 09:00:00', 'Housekeeping memeriksa kamar setelah tamu check-out.'),
(9, 8, 'Audit Malam', '2026-05-19 23:30:00', 'Night auditor melakukan pemeriksaan transaksi harian.'),
(10, 6, 'Monitoring Operasional', '2026-05-20 16:45:00', 'Manager operasional mengevaluasi tingkat okupansi kamar.'),
(11, 3, 'Proses Refund', '2026-05-21 14:10:00', 'Refund reservasi ID 21 dicatat karena reservasi dibatalkan.'),
(12, 7, 'Konfirmasi Reservasi', '2026-05-22 10:35:00', 'Reservasi ID 22 dikonfirmasi untuk jadwal menginap bulan Juni.');

-- =========================================================
-- VALIDASI AKHIR: VALIDASI INTEGRITAS DATA & AUTO-CALCULATION
-- =========================================================
SELECT 
    dr.id_reservasi,
    t.nama_tamu,
    k.nomor_kamar,
    dr.jumlah_malam,
    dr.harga_per_malam,
    dr.subtotal AS 'Subtotal (Dihitung Otomatis)'
FROM detail_reservasi dr
JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN kamar k ON dr.id_kamar = k.id_kamar
LIMIT 5;