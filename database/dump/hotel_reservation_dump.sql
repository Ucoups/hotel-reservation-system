CREATE DATABASE IF NOT EXISTS `hotel_reservation_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `hotel_reservation_db`;

-- =============================================================================
-- CONFIGURATION & SYSTEM PRESETS
-- =============================================================================
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- =============================================================================
-- 1. TABLE STRUCTURE & DATA: `tamu`
-- =============================================================================
DROP TABLE IF EXISTS `tamu`;
CREATE TABLE `tamu` (
  `id_tamu` int NOT NULL AUTO_INCREMENT,
  `nama_tamu` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_identitas` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_telepon` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT '1 = Aktif, 0 = Soft Delete',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tamu`),
  UNIQUE KEY `no_identitas` (`no_identitas`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `tamu` WRITE;
INSERT INTO `tamu` (`id_tamu`, `nama_tamu`, `no_identitas`, `jenis_kelamin`, `no_telepon`, `email`, `alamat`, `is_active`) VALUES 
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
UNLOCK TABLES;

-- =============================================================================
-- 2. TABLE STRUCTURE & DATA: `pegawai`
-- =============================================================================
DROP TABLE IF EXISTS `pegawai`;
CREATE TABLE `pegawai` (
  `id_pegawai` int NOT NULL AUTO_INCREMENT,
  `nama_pegawai` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jabatan` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_telepon` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT '1 = Aktif, 0 = Non-Aktif',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pegawai`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `pegawai` WRITE;
INSERT INTO `pegawai` (`id_pegawai`, `nama_pegawai`, `jabatan`, `no_telepon`, `email`, `is_active`) VALUES 
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
UNLOCK TABLES;

-- =============================================================================
-- 3. TABLE STRUCTURE & DATA: `tipe_kamar`
-- =============================================================================
DROP TABLE IF EXISTS `tipe_kamar`;
CREATE TABLE `tipe_kamar` (
  `id_tipe_kamar` int NOT NULL AUTO_INCREMENT,
  `nama_tipe` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kapasitas` int NOT NULL,
  `harga_per_malam` decimal(12,2) NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_tipe_kamar`),
  UNIQUE KEY `nama_tipe` (`nama_tipe`),
  CONSTRAINT `tipe_kamar_chk_1` CHECK ((`kapasitas` > 0)),
  CONSTRAINT `tipe_kamar_chk_2` CHECK ((`harga_per_malam` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `tipe_kamar` WRITE;
INSERT INTO `tipe_kamar` VALUES 
(1, 'Standard', 2, 350000.00, 'Kamar standar untuk tamu individu atau pasangan dengan fasilitas dasar.'),
(2, 'Superior', 2, 450000.00, 'Kamar superior dengan area lebih luas dan fasilitas tambahan.'),
(3, 'Deluxe', 2, 600000.00, 'Kamar deluxe dengan interior lebih nyaman dan pemandangan kota.'),
(4, 'Family', 4, 850000.00, 'Kamar keluarga dengan kapasitas lebih besar.'),
(5, 'Suite', 4, 1250000.00, 'Kamar suite premium dengan ruang duduk dan fasilitas lengkap.');
UNLOCK TABLES;

-- =============================================================================
-- 4. TABLE STRUCTURE & DATA: `fasilitas`
-- =============================================================================
DROP TABLE IF EXISTS `fasilitas`;
CREATE TABLE `fasilitas` (
  `id_fasilitas` int NOT NULL AUTO_INCREMENT,
  `nama_fasilitas` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_fasilitas`),
  UNIQUE KEY `nama_fasilitas` (`nama_fasilitas`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `fasilitas` WRITE;
INSERT INTO `fasilitas` VALUES 
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
UNLOCK TABLES;

-- =============================================================================
-- 5. TABLE STRUCTURE & DATA: `kamar`
-- =============================================================================
DROP TABLE IF EXISTS `kamar`;
CREATE TABLE `kamar` (
  `id_kamar` int NOT NULL AUTO_INCREMENT,
  `id_tipe_kamar` int NOT NULL,
  `nomor_kamar` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lantai` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_kamar` enum('Tersedia','Dipesan','Terisi','Perawatan') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Tersedia',
  PRIMARY KEY (`id_kamar`),
  UNIQUE KEY `nomor_kamar` (`nomor_kamar`),
  KEY `idx_kamar_tipe` (`id_tipe_kamar`),
  KEY `idx_kamar_status` (`status_kamar`),
  CONSTRAINT `fk_kamar_tipe` FOREIGN KEY (`id_tipe_kamar`) REFERENCES `tipe_kamar` (`id_tipe_kamar`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `kamar` WRITE;
INSERT INTO `kamar` VALUES 
(1, 1, '101', '1', 'Tersedia'), (2, 1, '102', '1', 'Dipesan'), (3, 1, '103', '1', 'Terisi'), (4, 1, '104', '1', 'Tersedia'), (5, 1, '105', '1', 'Perawatan'),
(6, 2, '201', '2', 'Dipesan'), (7, 2, '202', '2', 'Terisi'),  (8, 2, '203', '2', 'Tersedia'),  (9, 2, '204', '2', 'Tersedia'),  (10, 2, '205', '2', 'Dipesan'),
(11, 3, '301', '3', 'Terisi'), (12, 3, '302', '3', 'Dipesan'), (13, 3, '303', '3', 'Tersedia'), (14, 3, '304', '3', 'Tersedia'), (15, 3, '305', '3', 'Dipesan'),
(16, 4, '401', '4', 'Terisi'), (17, 4, '402', '4', 'Dipesan'), (18, 4, '403', '4', 'Tersedia'), (19, 4, '404', '4', 'Tersedia'), (20, 4, '405', '4', 'Dipesan'),
(21, 5, '501', '5', 'Terisi'), (22, 5, '502', '5', 'Dipesan'), (23, 5, '503', '5', 'Tersedia'), (24, 5, '504', '5', 'Tersedia'), (25, 5, '505', '5', 'Dipesan');
UNLOCK TABLES;

-- =============================================================================
-- 6. TABLE STRUCTURE & DATA: `reservasi`
-- =============================================================================
DROP TABLE IF EXISTS `reservasi`;
CREATE TABLE `reservasi` (
  `id_reservasi` int NOT NULL AUTO_INCREMENT,
  `id_tamu` int NOT NULL,
  `id_pegawai` int NOT NULL,
  `tanggal_reservasi` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tanggal_checkin_rencana` date NOT NULL,
  `tanggal_checkout_rencana` date NOT NULL,
  `status_reservasi` enum('Menunggu','Dikonfirmasi','Check-in','Selesai','Dibatalkan') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Menunggu',
  PRIMARY KEY (`id_reservasi`),
  KEY `idx_reservasi_tamu` (`id_tamu`),
  KEY `idx_reservasi_pegawai` (`id_pegawai`),
  KEY `idx_reservasi_status` (`status_reservasi`),
  CONSTRAINT `fk_reservasi_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reservasi_tamu` FOREIGN KEY (`id_tamu`) REFERENCES `tamu` (`id_tamu`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_tanggal_reservasi` CHECK ((`tanggal_checkout_rencana` > `tanggal_checkin_rencana`))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `reservasi` WRITE;
INSERT INTO `reservasi` VALUES 
(1,1,1,'2026-05-01 09:15:00','2026-05-10','2026-05-12','Selesai'),
(2,2,1,'2026-05-02 10:30:00','2026-05-11','2026-05-14','Selesai'),
(3,3,2,'2026-05-03 14:22:00','2026-05-12','2026-05-14','Selesai'),
(4,4,4,'2026-05-04 11:05:00','2026-05-13','2026-05-17','Selesai'),
(5,5,7,'2026-05-05 16:40:00','2026-05-15','2026-05-17','Selesai'),
(6,6,1,'2026-05-06 08:12:00','2026-05-16','2026-05-17','Selesai'),
(7,7,2,'2026-05-07 13:50:00','2026-05-18','2026-05-20','Selesai'),
(8,8,4,'2026-05-08 10:15:00','2026-05-19','2026-05-22','Selesai'),
(9,9,7,'2026-05-09 15:30:00','2026-05-20','2026-05-22','Selesai'),
(10,10,1,'2026-05-10 11:20:00','2026-05-21','2026-05-24','Selesai'),
(11,11,2,'2026-05-11 09:00:00','2026-06-01','2026-06-03','Check-in'),
(12,12,4,'2026-05-12 14:45:00','2026-06-02','2026-06-03','Check-in'),
(13,13,7,'2026-05-13 17:10:00','2026-06-05','2026-06-08','Dikonfirmasi'),
(14,14,1,'2026-05-14 10:00:00','2026-06-06','2026-06-08','Dikonfirmasi'),
(15,15,2,'2026-05-15 11:35:00','2026-06-09','2026-06-13','Dikonfirmasi'),
(16,16,4,'2026-05-16 13:20:00','2026-06-10','2026-06-12','Dikonfirmasi'),
(17,17,7,'2026-05-17 16:15:00','2026-06-12','2026-06-13','Dikonfirmasi'),
(18,18,1,'2026-05-18 09:50:00','2026-06-14','2026-06-16','Dikonfirmasi'),
(19,19,2,'2026-05-19 14:05:00','2026-06-17','2026-06-20','Menunggu'),
(20,20,4,'2026-05-20 11:30:00','2026-06-18','2026-06-20','Menunggu'),
(21,3,7,'2026-05-21 10:00:00','2026-06-21','2026-06-23','Dibatalkan'),
(22,8,1,'2026-05-22 15:25:00','2026-06-24','2026-06-25','Dikonfirmasi');
UNLOCK TABLES;

-- =============================================================================
-- 7. TABLE STRUCTURE & DATA: `detail_reservasi` (AUTO-GENERATED UPGRADE)
-- =============================================================================
DROP TABLE IF EXISTS `detail_reservasi`;
CREATE TABLE `detail_reservasi` (
  `id_detail_reservasi` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `id_kamar` int NOT NULL,
  `jumlah_malam` int NOT NULL,
  `harga_per_malam` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`jumlah_malam` * `harga_per_malam`)) STORED,
  PRIMARY KEY (`id_detail_reservasi`),
  UNIQUE KEY `uk_reservasi_kamar` (`id_reservasi`,`id_kamar`),
  KEY `idx_detail_kamar` (`id_kamar`),
  CONSTRAINT `fk_detail_kamar` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_detail_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `detail_reservasi_chk_1` CHECK ((`jumlah_malam` > 0)),
  CONSTRAINT `detail_reservasi_chk_2` CHECK ((`harga_per_malam` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `detail_reservasi` WRITE;
INSERT INTO `detail_reservasi` (`id_detail_reservasi`, `id_reservasi`, `id_kamar`, `jumlah_malam`, `harga_per_malam`) VALUES 
(1,1,1,2,350000.00), (2,2,6,3,450000.00), (3,3,11,2,600000.00), (4,4,16,4,850000.00), (5,5,21,2,1250000.00), 
(6,6,2,1,350000.00), (7,6,3,1,350000.00), (8,7,7,2,450000.00), (9,8,12,3,600000.00), (10,9,17,2,850000.00), 
(11,10,22,3,1250000.00), (12,11,4,2,350000.00), (13,11,8,2,450000.00), (14,12,13,1,600000.00), (15,13,18,3,850000.00), 
(16,14,23,2,1250000.00), (17,15,5,4,350000.00), (18,16,9,2,450000.00), (19,16,14,2,600000.00), (20,17,19,1,850000.00), 
(21,18,24,2,1250000.00), (22,19,10,3,450000.00), (23,20,15,2,600000.00), (24,21,20,2,850000.00), (25,22,25,1,1250000.00), 
(26,22,1,1,350000.00);
UNLOCK TABLES;

-- =============================================================================
-- 8. TABLE STRUCTURE & DATA: `pembayaran`
-- =============================================================================
DROP TABLE IF EXISTS `pembayaran`;
CREATE TABLE `pembayaran` (
  `id_pembayaran` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `tanggal_pembayaran` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `metode_pembayaran` enum('Tunai','Transfer','Kartu Kredit','E-Wallet') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_pembayaran` enum('Pending','Lunas','Gagal','Refund') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`id_pembayaran`),
  KEY `idx_pembayaran_reservasi` (`id_reservasi`),
  KEY `idx_pembayaran_status` (`status_pembayaran`),
  CONSTRAINT `fk_pembayaran_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pembayaran_chk_1` CHECK ((`jumlah_bayar` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `pembayaran` WRITE;
INSERT INTO `pembayaran` VALUES 
(1,1,'2026-05-01 09:20:00',400000.00,'Transfer','Lunas'), (2,1,'2026-05-01 09:25:00',300000.00,'Kartu Kredit','Lunas'), 
(3,2,'2026-05-02 10:45:00',1350000.00,'Kartu Kredit','Lunas'), (4,3,'2026-05-03 14:30:00',1200000.00,'E-Wallet','Lunas'), 
(5,4,'2026-05-04 11:15:00',3400000.00,'Transfer','Lunas'), (6,5,'2026-05-05 16:55:00',2500000.00,'Kartu Kredit','Lunas'), 
(7,6,'2026-05-06 08:30:00',700000.00,'Tunai','Lunas'), (8,7,'2026-05-07 14:00:00',900000.00,'Transfer','Lunas'), 
(9,8,'2026-05-08 10:30:00',1800000.00,'E-Wallet','Lunas'), (10,9,'2026-05-09 15:45:00',1700000.00,'Kartu Kredit','Lunas'), 
(11,10,'2026-05-10 11:40:00',3750000.00,'Transfer','Lunas'), (12,11,'2026-05-11 09:15:00',1600000.00,'Transfer','Lunas'), 
(13,12,'2026-05-12 15:00:00',600000.00,'Tunai','Lunas'), (14,13,'2026-05-13 17:25:00',2550000.00,'Transfer','Pending'), 
(15,14,'2026-05-14 10:15:00',2500000.00,'Kartu Kredit','Lunas'), (16,15,'2026-05-15 11:50:00',1400000.00,'E-Wallet','Pending'), 
(17,16,'2026-05-16 13:45:00',2100000.00,'Transfer','Lunas'), (18,17,'2026-05-17 16:30:00',850000.00,'Tunai','Lunas'), 
(19,18,'2026-05-18 10:00:00',2500000.00,'Kartu Kredit','Pending'), (20,19,'2026-05-19 14:20:00',1350000.00,'Transfer','Pending'), 
(21,20,'2026-05-20 11:45:00',1200000.00,'E-Wallet','Pending'), (22,21,'2026-05-21 10:30:00',1700000.00,'Transfer','Refund'), 
(23,1,'2026-05-12 11:00:00',100000.00,'Tunai','Lunas');
UNLOCK TABLES;

-- =============================================================================
-- 9. TABLE STRUCTURE & DATA: `checkin`
-- =============================================================================
DROP TABLE IF EXISTS `checkin`;
CREATE TABLE `checkin` (
  `id_checkin` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `waktu_checkin` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_pegawai` int NOT NULL,
  `catatan` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_checkin`),
  UNIQUE KEY `id_reservasi` (`id_reservasi`),
  KEY `fk_checkin_pegawai` (`id_pegawai`),
  CONSTRAINT `fk_checkin_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_checkin_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `checkin` WRITE;
INSERT INTO `checkin` VALUES 
(1,1,'2026-05-10 14:05:00',1,'Tamu datang tepat waktu dan kamar siap digunakan.'),
(2,2,'2026-05-11 14:20:00',4,'Check-in berjalan normal.'),
(3,3,'2026-05-12 15:10:00',1,'Tamu meminta kamar bebas asap rokok.'),
(4,4,'2026-05-13 13:55:00',2,'Tamu keluarga membawa dua anak.'),
(5,5,'2026-05-15 14:30:00',7,'Tamu meminta tambahan bantal.'),
(6,6,'2026-05-16 16:00:00',4,'Dua kamar standard digunakan untuk rombongan kecil.'),
(7,7,'2026-05-18 14:15:00',1,'Check-in tanpa kendala.'),
(8,8,'2026-05-19 15:25:00',2,'Tamu menitipkan koper di concierge.'),
(9,9,'2026-05-20 14:40:00',7,'Tamu meminta late checkout jika memungkinkan.'),
(10,10,'2026-05-21 13:50:00',1,'Tamu suite melakukan check-in lebih awal.'),
(11,11,'2026-06-01 14:10:00',4,'Status reservasi otomatis berubah menjadi check-in via trigger.'),
(12,12,'2026-06-02 15:00:00',7,'Tamu mengonfirmasi sarapan untuk dua orang.');
UNLOCK TABLES;

-- =============================================================================
-- 10. TABLE STRUCTURE & DATA: `checkout`
-- =============================================================================
DROP TABLE IF EXISTS `checkout`;
CREATE TABLE `checkout` (
  `id_checkout` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `waktu_checkout` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_pegawai` int NOT NULL,
  `biaya_tambahan` decimal(12,2) NOT NULL DEFAULT '0.00',
  `catatan` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_checkout`),
  UNIQUE KEY `id_reservasi` (`id_reservasi`),
  KEY `fk_checkout_pegawai` (`id_pegawai`),
  CONSTRAINT `fk_checkout_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_checkout_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `checkout_chk_1` CHECK ((`biaya_tambahan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `checkout` WRITE;
INSERT INTO `checkout` VALUES 
(1,1,'2026-05-12 11:00:00',2,0.00,'Check-out selesai tanpa biaya tambahan.'),
(2,2,'2026-05-14 10:45:00',4,50000.00,'Tambahan biaya laundry.'),
(3,3,'2026-05-14 11:10:00',1,0.00,'Kamar dikembalikan dalam kondisi baik.'),
(4,4,'2026-05-17 11:25:00',2,100000.00,'Tambahan room service.'),
(5,5,'2026-05-17 10:55:00',7,0.00,'Tamu puas dengan layanan suite.'),
(6,6,'2026-05-17 11:15:00',4,0.00,'Check-out rombongan selesai.'),
(7,7,'2026-05-20 11:05:00',1,75000.00,'Tambahan minibar.'),
(8,8,'2026-05-22 10:50:00',2,0.00,'Check-out normal.'),
(9,9,'2026-05-22 12:00:00',7,150000.00,'Tambahan late checkout.'),
(10,10,'2026-05-24 11:30:00',1,0.00,'Check-out suite selesai, status kamar kembali tersedia.');
UNLOCK TABLES;

-- =============================================================================
-- 11. TABLE STRUCTURE & DATA: `kamar_fasilitas`
-- =============================================================================
DROP TABLE IF EXISTS `kamar_fasilitas`;
CREATE TABLE `kamar_fasilitas` (
  `id_kamar` int NOT NULL,
  `id_fasilitas` int NOT NULL,
  PRIMARY KEY (`id_kamar`,`id_fasilitas`),
  KEY `fk_kf_fasilitas` (`id_fasilitas`),
  CONSTRAINT `fk_kf_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_kf_kamar` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `kamar_fasilitas` WRITE;
INSERT INTO `kamar_fasilitas` VALUES 
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),
(1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),(8,2),(9,2),(10,2),(11,2),(12,2),(13,2),(14,2),(15,2),(16,2),(17,2),(18,2),(19,2),(20,2),(21,2),(22,2),(23,2),(24,2),(25,2),
(1,3),(2,3),(3,3),(4,3),(5,3),(6,3),(7,3),(8,3),(9,3),(10,3),(11,3),(12,3),(13,3),(14,3),(15,3),(16,3),(17,3),(18,3),(19,3),(20,3),(21,3),(22,3),(23,3),(24,3),(25,3),
(11,4),(12,4),(13,4),(14,4),(15,4),(21,4),(22,4),(23,4),(24,4),(25,4),
(6,5),(7,5),(8,5),(9,5),(10,5),(11,5),(12,5),(13,5),(14,5),(15,5),(16,5),(17,5),(18,5),(19,5),(20,5),(21,5),(22,5),(23,5),(24,5),(25,5),
(16,6),(17,6),(18,6),(19,6),(20,6),(21,6),(22,6),(23,6),(24,6),(25,6),
(21,7),(22,7),(23,7),(24,7),(25,7),(21,8),(22,8),(23,8),(24,8),(25,8),
(11,9),(12,9),(13,9),(14,9),(15,9),(16,9),(17,9),(18,9),(19,9),(20,9),(21,9),(22,9),(23,9),(24,9),(25,9),
(16,10),(17,10),(18,10),(19,10),(20,10),(21,10),(22,10),(23,10),(24,10),(25,10);
UNLOCK TABLES;

-- =============================================================================
-- 12. TABLE STRUCTURE & DATA: `log_aktivitas`
-- =============================================================================
DROP TABLE IF EXISTS `log_aktivitas`;
CREATE TABLE `log_aktivitas` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `id_pegawai` int DEFAULT NULL,
  `aktivitas` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `waktu_aktivitas` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `keterangan` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_log`),
  KEY `idx_log_waktu` (`waktu_aktivitas`),
  KEY `idx_log_pegawai` (`id_pegawai`),
  CONSTRAINT `fk_log_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `log_aktivitas` WRITE;
INSERT INTO `log_aktivitas` VALUES 
(1,1,'Membuat Reservasi','2026-05-01 09:15:00','Reservasi ID 1 dibuat untuk tamu Andi Pratama.'),
(2,3,'Mencatat Pembayaran','2026-05-02 10:20:00','Pembayaran reservasi ID 2 dicatat lunas.'),
(3,4,'Proses Check-in','2026-05-11 14:20:00','Check-in reservasi ID 2 berhasil dilakukan.'),
(4,2,'Proses Check-out','2026-05-14 10:45:00','Check-out reservasi ID 2 selesai dengan biaya laundry.'),
(5,7,'Konfirmasi Reservasi','2026-05-15 11:00:00','Reservasi ID 15 dikonfirmasi oleh customer service.'),
(6,9,'Mencatat Pembayaran','2026-05-16 13:30:00','Pembayaran reservasi ID 16 diterima melalui transfer.'),
(7,1,'Update Status Kamar','2026-05-17 12:00:00','Status kamar diperbarui setelah check-out.'),
(8,5,'Pemeriksaan Kamar','2026-05-18 09:00:00','Housekeeping memeriksa kamar setelah tamu check-out.'),
(9,8,'Audit Malam','2026-05-19 23:30:00','Night auditor melakukan pemeriksaan transaksi harian.'),
(10,6,'Monitoring Operasional','2026-05-20 16:45:00','Manager operasional mengevaluasi tingkat okupansi kamar.'),
(11,3,'Proses Refund','2026-05-21 14:10:00','Refund reservasi ID 21 dicatat karena reservasi dibatalkan.'),
(12,7,'Konfirmasi Reservasi','2026-05-22 10:35:00','Reservasi ID 22 dikonfirmasi untuk jadwal menginap bulan Juni.');
UNLOCK TABLES;

-- =============================================================================
-- SYSTEM COMPONENTS: ARCHITECTURAL VIEWS
-- =============================================================================
CREATE OR REPLACE VIEW `vw_detail_reservasi_tamu` AS 
SELECT r.id_reservasi, t.nama_tamu, t.no_telepon, k.nomor_kamar, tk.nama_tipe, 
       DATE_FORMAT(r.tanggal_reservasi, '%d-%m-%Y %H:%i') AS tanggal_booking,
       DATE_FORMAT(r.tanggal_checkin_rencana, '%d-%m-%Y') AS rencana_checkin,
       DATE_FORMAT(r.tanggal_checkout_rencana, '%d-%m-%Y') AS rencana_checkout,
       dr.jumlah_malam, dr.harga_per_malam, dr.subtotal, r.status_reservasi 
FROM reservasi r 
JOIN tamu t ON r.id_tamu = t.id_tamu 
JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi 
JOIN kamar k ON dr.id_kamar = k.id_kamar 
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar;

CREATE OR REPLACE VIEW `vw_laporan_pembayaran` AS 
SELECT pb.id_pembayaran, r.id_reservasi, t.nama_tamu, 
       DATE_FORMAT(pb.tanggal_pembayaran, '%d-%m-%Y %H:%i:%s') AS waktu_pembayaran, 
       pb.jumlah_bayar, pb.metode_pembayaran, pb.status_pembayaran 
FROM pembayaran pb 
JOIN reservasi r ON pb.id_reservasi = r.id_reservasi 
JOIN tamu t ON r.id_tamu = t.id_tamu;

CREATE OR REPLACE VIEW `vw_billing_reservasi_summary` AS
SELECT r.id_reservasi, t.id_tamu, t.nama_tamu, r.status_reservasi,
       IFNULL(SUM(dr.subtotal), 0) AS grand_total_tagihan,
       IFNULL(co.biaya_tambahan, 0) AS biaya_tambahan_checkout,
       (IFNULL(SUM(dr.subtotal), 0) + IFNULL(co.biaya_tambahan, 0)) AS grand_total_invoice,
       IFNULL((SELECT SUM(jumlah_bayar) FROM pembayaran WHERE id_reservasi = r.id_reservasi AND status_pembayaran = 'Lunas'), 0) AS total_telah_dibayar,
       ((IFNULL(SUM(dr.subtotal), 0) + IFNULL(co.biaya_tambahan, 0)) - IFNULL((SELECT SUM(jumlah_bayar) FROM pembayaran WHERE id_reservasi = r.id_reservasi AND status_pembayaran = 'Lunas'), 0)) AS sisa_tagihan
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
LEFT JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
LEFT JOIN checkout co ON r.id_reservasi = co.id_reservasi
GROUP BY r.id_reservasi, t.id_tamu, co.biaya_tambahan;

CREATE OR REPLACE VIEW `vw_status_kamar_opsional` AS
SELECT k.id_kamar, k.nomor_kamar, k.lantai, tk.nama_tipe, tk.harga_per_malam, k.status_kamar,
       CASE WHEN k.status_kamar = 'Terisi' THEN (
            SELECT t.nama_tamu FROM detail_reservasi dr 
            JOIN reservasi r ON dr.id_reservasi = r.id_reservasi 
            JOIN tamu t ON r.id_tamu = t.id_tamu 
            WHERE dr.id_kamar = k.id_kamar AND r.status_reservasi = 'Check-in' LIMIT 1
       ) ELSE '-' END AS nama_tamu_sekarang
FROM kamar k
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar;

CREATE OR REPLACE VIEW `vw_performa_staf_operasional` AS
SELECT p.id_pegawai, p.nama_pegawai, p.jabatan,
       (SELECT COUNT(*) FROM reservasi WHERE id_pegawai = p.id_pegawai) AS jumlah_handle_reservasi,
       (SELECT COUNT(*) FROM checkin WHERE id_pegawai = p.id_pegawai) AS jumlah_handle_checkin,
       (SELECT COUNT(*) FROM checkout WHERE id_pegawai = p.id_pegawai) AS jumlah_handle_checkout
FROM pegawai p WHERE p.is_active = 1;

-- =============================================================================
-- SYSTEM COMPONENTS: STORED FUNCTIONS
-- =============================================================================
DELIMITER //

CREATE FUNCTION `fn_hitung_durasi_malam`(p_checkin DATE, p_checkout DATE) RETURNS int
    DETERMINISTIC
BEGIN
    IF p_checkout <= p_checkin OR p_checkin IS NULL OR p_checkout IS NULL THEN RETURN 0; END IF;
    RETURN DATEDIFF(p_checkout, p_checkin);
END //

CREATE FUNCTION `fn_total_pendapatan_reservasi`(p_id_reservasi INT) RETURNS decimal(12,2)
    READS SQL DATA
BEGIN
    DECLARE v_total_kamar DECIMAL(12,2);
    DECLARE v_total_tambahan DECIMAL(12,2);
    SELECT COALESCE(SUM(subtotal), 0) INTO v_total_kamar FROM detail_reservasi WHERE id_reservasi = p_id_reservasi;
    SELECT COALESCE(biaya_tambahan, 0) INTO v_total_tambahan FROM checkout WHERE id_reservasi = p_id_reservasi;
    RETURN v_total_kamar + v_total_tambahan;
END //

CREATE FUNCTION `fn_cek_status_pembayaran`(p_id_reservasi INT) RETURNS varchar(30)
    READS SQL DATA
BEGIN
    DECLARE v_total_tagihan DECIMAL(12,2);
    DECLARE v_total_bayar DECIMAL(12,2);
    SET v_total_tagihan = fn_total_pendapatan_reservasi(p_id_reservasi);
    SELECT COALESCE(SUM(jumlah_bayar), 0) INTO v_total_bayar FROM pembayaran WHERE id_reservasi = p_id_reservasi AND status_pembayaran = 'Lunas';
    IF v_total_bayar = 0 THEN RETURN 'BELUM BAYAR';
    ELSEIF v_total_bayar < v_total_tagihan THEN RETURN 'KURANG BAYAR';
    ELSE RETURN 'LUNAS'; END IF;
END //
DELIMITER ;

-- =============================================================================
-- SYSTEM COMPONENTS: STORED PROCEDURES
-- =============================================================================
DELIMITER //

CREATE PROCEDURE `sp_hitung_invoice_lengkap`(
    IN p_id_reservasi INT, OUT p_biaya_kamar DECIMAL(12,2), OUT p_biaya_tambahan DECIMAL(12,2),
    OUT p_grand_total DECIMAL(12,2), OUT p_total_dibayar DECIMAL(12,2), OUT p_sisa_tagihan DECIMAL(12,2)
)
BEGIN
    SELECT COALESCE(SUM(subtotal), 0) INTO p_biaya_kamar FROM detail_reservasi WHERE id_reservasi = p_id_reservasi;
    SELECT COALESCE(biaya_tambahan, 0) INTO p_biaya_tambahan FROM checkout WHERE id_reservasi = p_id_reservasi;
    SET p_grand_total = p_biaya_kamar + p_biaya_tambahan;
    SELECT COALESCE(SUM(jumlah_bayar), 0) INTO p_total_dibayar FROM pembayaran WHERE id_reservasi = p_id_reservasi AND status_pembayaran = 'Lunas';
    SET p_sisa_tagihan = p_grand_total - p_total_dibayar;
END //

CREATE PROCEDURE `sp_proses_pembayaran_aman`(
    IN p_id_reservasi INT, IN p_jumlah_bayar DECIMAL(12,2), IN p_metode ENUM('Tunai','Transfer','Kartu Kredit','E-Wallet'),
    IN p_id_pegawai INT, OUT p_status_pesan VARCHAR(100)
)
BEGIN
    DECLARE v_biaya_kamar, v_biaya_tambahan, v_grand_total, v_total_dibayar, v_sisa_tagihan DECIMAL(12,2);
    CALL sp_hitung_invoice_lengkap(p_id_reservasi, v_biaya_kamar, v_biaya_tambahan, v_grand_total, v_total_dibayar, v_sisa_tagihan);
    IF v_sisa_tagihan <= 0 THEN SET p_status_pesan = 'GAGAL: Tagihan untuk reservasi ini sudah lunas.';
    ELSE
        START TRANSACTION;
            INSERT INTO pembayaran (id_reservasi, jumlah_bayar, metode_pembayaran, status_pembayaran) VALUES (p_id_reservasi, p_jumlah_bayar, p_metode, 'Lunas');
            SET v_total_dibayar = v_total_dibayar + p_jumlah_bayar;
            SET v_sisa_tagihan = v_grand_total - v_total_dibayar;
            UPDATE reservasi SET status_reservasi = 'Dikonfirmasi' WHERE id_reservasi = p_id_reservasi AND status_reservasi = 'Menunggu' AND v_sisa_tagihan <= 0;
            INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan) VALUES (p_id_pegawai, 'Mencatat Pembayaran', CONCAT('Pembayaran sebesar Rp', FORMAT(p_jumlah_bayar, 0, 'id_ID'), ' sukses dicatat untuk ID ', p_id_reservasi));
        COMMIT;
        SET p_status_pesan = CONCAT('SUKSES: Sisa tagihan saat ini: Rp', FORMAT(v_sisa_tagihan, 0, 'id_ID'));
    END IF;
END //

CREATE PROCEDURE `sp_batal_reservasi_otomatis`(IN p_id_reservasi INT, IN p_id_pegawai INT, OUT p_status_pesan VARCHAR(100))
BEGIN
    DECLARE v_status_sekarang VARCHAR(30);
    SELECT status_reservasi INTO v_status_sekarang FROM reservasi WHERE id_reservasi = p_id_reservasi;
    IF v_status_sekarang IN ('Check-in', 'Selesai', 'Dibatalkan') THEN SET p_status_pesan = CONCAT('GAGAL: Status reservasi sudah ', v_status_sekarang);
    ELSE
        START TRANSACTION;
            UPDATE reservasi SET status_reservasi = 'Dibatalkan' WHERE id_reservasi = p_id_reservasi;
            UPDATE kamar SET status_kamar = 'Tersedia' WHERE id_kamar IN (SELECT id_kamar FROM detail_reservasi WHERE id_reservasi = p_id_reservasi);
            UPDATE pembayaran SET status_pembayaran = 'Refund' WHERE id_reservasi = p_id_reservasi;
            INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan) VALUES (p_id_pegawai, 'Pembatangan Reservasi', CONCAT('Reservasi ID ', p_id_reservasi, ' dibatalkan otomatis oleh sistem.'));
        COMMIT;
        SET p_status_pesan = 'SUKSES: Pemesanan kamar dibatalkan & status reset kosong.';
    END IF;
END //
DELIMITER ;

-- =============================================================================
-- SYSTEM COMPONENTS: AUTOMATION TRIGGERS
-- =============================================================================
DELIMITER //

CREATE TRIGGER `trg_before_detail_reservasi_insert` BEFORE INSERT ON `detail_reservasi` FOR EACH ROW 
BEGIN
    DECLARE v_status_kamar VARCHAR(20); DECLARE v_tanggal_checkin, v_tanggal_checkout DATE; DECLARE v_jumlah_bentrok INT DEFAULT 0;
    SELECT status_kamar INTO v_status_kamar FROM kamar WHERE id_kamar = NEW.id_kamar;
    IF v_status_kamar = 'Perawatan' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OPERASI DITOLAK: Kamar tidak dapat dipesan karena sedang dalam masa pemeliharaan/Perawatan.'; END IF;
    SELECT tanggal_checkin_rencana, tanggal_checkout_rencana INTO v_tanggal_checkin, v_tanggal_checkout FROM reservasi WHERE id_reservasi = NEW.id_reservasi;
    SELECT COUNT(*) INTO v_jumlah_bentrok FROM detail_reservasi dr JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
    WHERE dr.id_kamar = NEW.id_kamar AND dr.id_reservasi <> NEW.id_reservasi AND r.status_reservasi NOT IN ('Dibatalkan', 'Selesai') AND r.tanggal_checkin_rencana < v_tanggal_checkout AND r.tanggal_checkout_rencana > v_tanggal_checkin;
    IF v_jumlah_bentrok > 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OPERASI DITOLAK: Kamar sudah ter-booking oleh tamu lain pada periode tanggal tersebut.'; END IF;
END //

CREATE TRIGGER `trg_after_detail_reservasi_insert` AFTER INSERT ON `detail_reservasi` FOR EACH ROW 
BEGIN
    UPDATE kamar SET status_kamar = 'Dipesan' WHERE id_kamar = NEW.id_kamar AND status_kamar = 'Tersedia';
END //

CREATE TRIGGER `trg_after_checkin_insert` AFTER INSERT ON `checkin` FOR EACH ROW 
BEGIN
    UPDATE kamar k JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar SET k.status_kamar = 'Terisi' WHERE dr.id_reservasi = NEW.id_reservasi;
    UPDATE reservasi SET status_reservasi = 'Check-in' WHERE id_reservasi = NEW.id_reservasi;
END //

CREATE TRIGGER `trg_after_checkout_insert` AFTER INSERT ON `checkout` FOR EACH ROW 
BEGIN
    UPDATE kamar k JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar SET k.status_kamar = 'Tersedia' WHERE dr.id_reservasi = NEW.id_reservasi AND k.status_kamar <> 'Perawatan';
    UPDATE reservasi SET status_reservasi = 'Selesai' WHERE id_reservasi = NEW.id_reservasi;
END //

CREATE TRIGGER `trg_after_pembayaran_insert` AFTER INSERT ON `pembayaran` FOR EACH ROW 
BEGIN
    INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
    SELECT r.id_pegawai, 'Pembayaran Masuk', CONCAT('Pembayaran Sukses untuk Reservasi ID ', NEW.id_reservasi, ' sebesar Rp', FORMAT(NEW.jumlah_bayar, 0, 'id_ID'), ' melalui metode [', NEW.metode_pembayaran, '].')
    FROM reservasi r WHERE r.id_reservasi = NEW.id_reservasi;
END //
DELIMITER ;

-- =============================================================================
-- RESET SYSTEM PARAMETERS
-- =============================================================================
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;