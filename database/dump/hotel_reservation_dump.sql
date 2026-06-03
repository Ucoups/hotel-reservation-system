CREATE DATABASE  IF NOT EXISTS `hotel_reservation_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hotel_reservation_db`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hotel_reservation_db
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '3f2b3786-177e-11f1-8bdd-40c2ba842458:1-3220';

--
-- Table structure for table `checkin`
--

DROP TABLE IF EXISTS `checkin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkin` (
  `id_checkin` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `waktu_checkin` datetime NOT NULL,
  `id_pegawai` int NOT NULL,
  `catatan` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_checkin`),
  UNIQUE KEY `id_reservasi` (`id_reservasi`),
  KEY `fk_checkin_pegawai` (`id_pegawai`),
  CONSTRAINT `fk_checkin_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_checkin_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin`
--

LOCK TABLES `checkin` WRITE;
/*!40000 ALTER TABLE `checkin` DISABLE KEYS */;
INSERT INTO `checkin` VALUES (1,1,'2026-05-10 14:05:00',1,'Tamu datang tepat waktu dan kamar siap digunakan.'),(2,2,'2026-05-11 14:20:00',4,'Check-in berjalan normal.'),(3,3,'2026-05-12 15:10:00',1,'Tamu meminta kamar bebas asap rokok.'),(4,4,'2026-05-13 13:55:00',2,'Tamu keluarga membawa dua anak.'),(5,5,'2026-05-15 14:30:00',7,'Tamu meminta tambahan bantal.'),(6,6,'2026-05-16 16:00:00',4,'Dua kamar standard digunakan untuk rombongan kecil.'),(7,7,'2026-05-18 14:15:00',1,'Check-in tanpa kendala.'),(8,8,'2026-05-19 15:25:00',2,'Tamu menitipkan koper di concierge.'),(9,9,'2026-05-20 14:40:00',7,'Tamu meminta late checkout jika memungkinkan.'),(10,10,'2026-05-21 13:50:00',1,'Tamu suite melakukan check-in lebih awal.'),(11,11,'2026-06-01 14:10:00',4,'Status reservasi berubah menjadi check-in.'),(12,12,'2026-06-02 15:00:00',7,'Tamu mengonfirmasi sarapan untuk dua orang.');
/*!40000 ALTER TABLE `checkin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkout`
--

DROP TABLE IF EXISTS `checkout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkout` (
  `id_checkout` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `waktu_checkout` datetime NOT NULL,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkout`
--

LOCK TABLES `checkout` WRITE;
/*!40000 ALTER TABLE `checkout` DISABLE KEYS */;
INSERT INTO `checkout` VALUES (1,1,'2026-05-12 11:00:00',2,0.00,'Check-out selesai tanpa biaya tambahan.'),(2,2,'2026-05-14 10:45:00',4,50000.00,'Tambahan biaya laundry.'),(3,3,'2026-05-14 11:10:00',1,0.00,'Kamar dikembalikan dalam kondisi baik.'),(4,4,'2026-05-17 11:25:00',2,100000.00,'Tambahan room service.'),(5,5,'2026-05-17 10:55:00',7,0.00,'Tamu puas dengan layanan suite.'),(6,6,'2026-05-17 11:15:00',4,0.00,'Check-out rombongan selesai.'),(7,7,'2026-05-20 11:05:00',1,75000.00,'Tambahan minibar.'),(8,8,'2026-05-22 10:50:00',2,0.00,'Check-out normal.'),(9,9,'2026-05-22 12:00:00',7,150000.00,'Tambahan late checkout.'),(10,10,'2026-05-24 11:30:00',1,0.00,'Check-out suite selesai.');
/*!40000 ALTER TABLE `checkout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detail_reservasi`
--

DROP TABLE IF EXISTS `detail_reservasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_reservasi` (
  `id_detail_reservasi` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `id_kamar` int NOT NULL,
  `jumlah_malam` int NOT NULL,
  `harga_per_malam` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id_detail_reservasi`),
  UNIQUE KEY `uk_reservasi_kamar` (`id_reservasi`,`id_kamar`),
  KEY `idx_detail_kamar` (`id_kamar`),
  CONSTRAINT `fk_detail_kamar` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_detail_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `detail_reservasi_chk_1` CHECK ((`jumlah_malam` > 0)),
  CONSTRAINT `detail_reservasi_chk_2` CHECK ((`harga_per_malam` >= 0)),
  CONSTRAINT `detail_reservasi_chk_3` CHECK ((`subtotal` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_reservasi`
--

LOCK TABLES `detail_reservasi` WRITE;
/*!40000 ALTER TABLE `detail_reservasi` DISABLE KEYS */;
INSERT INTO `detail_reservasi` VALUES (1,1,1,2,350000.00,700000.00),(2,2,6,3,450000.00,1350000.00),(3,3,11,2,600000.00,1200000.00),(4,4,16,4,850000.00,3400000.00),(5,5,21,2,1250000.00,2500000.00),(6,6,2,1,350000.00,350000.00),(7,6,3,1,350000.00,350000.00),(8,7,7,2,450000.00,900000.00),(9,8,12,3,600000.00,1800000.00),(10,9,17,2,850000.00,1700000.00),(11,10,22,3,1250000.00,3750000.00),(12,11,4,2,350000.00,700000.00),(13,11,8,2,450000.00,900000.00),(14,12,13,1,600000.00,600000.00),(15,13,18,3,850000.00,2550000.00),(16,14,23,2,1250000.00,2500000.00),(17,15,5,4,350000.00,1400000.00),(18,16,9,2,450000.00,900000.00),(19,16,14,2,600000.00,1200000.00),(20,17,19,1,850000.00,850000.00),(21,18,24,2,1250000.00,2500000.00),(22,19,10,3,450000.00,1350000.00),(23,20,15,2,600000.00,1200000.00),(24,21,20,2,850000.00,1700000.00),(25,22,25,1,1250000.00,1250000.00),(26,22,1,1,350000.00,350000.00);
/*!40000 ALTER TABLE `detail_reservasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fasilitas`
--

DROP TABLE IF EXISTS `fasilitas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fasilitas` (
  `id_fasilitas` int NOT NULL AUTO_INCREMENT,
  `nama_fasilitas` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_fasilitas`),
  UNIQUE KEY `nama_fasilitas` (`nama_fasilitas`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fasilitas`
--

LOCK TABLES `fasilitas` WRITE;
/*!40000 ALTER TABLE `fasilitas` DISABLE KEYS */;
INSERT INTO `fasilitas` VALUES (1,'Wi-Fi','Akses internet nirkabel di kamar dan area hotel.'),(2,'AC','Pendingin ruangan pribadi di dalam kamar.'),(3,'TV LED','Televisi LED dengan saluran lokal dan internasional.'),(4,'Mini Bar','Lemari pendingin kecil untuk minuman dan makanan ringan.'),(5,'Breakfast','Sarapan pagi untuk tamu hotel.'),(6,'Kolam Renang','Akses kolam renang hotel.'),(7,'Gym','Akses pusat kebugaran hotel.'),(8,'Bathtub','Bak mandi pribadi di kamar.'),(9,'Room Service','Layanan pemesanan makanan dan minuman ke kamar.'),(10,'Laundry','Layanan pencucian pakaian tamu.');
/*!40000 ALTER TABLE `fasilitas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kamar`
--

DROP TABLE IF EXISTS `kamar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kamar`
--

LOCK TABLES `kamar` WRITE;
/*!40000 ALTER TABLE `kamar` DISABLE KEYS */;
INSERT INTO `kamar` VALUES (1,1,'101','1','Tersedia'),(2,1,'102','1','Dipesan'),(3,1,'103','1','Terisi'),(4,1,'104','1','Tersedia'),(5,1,'105','1','Perawatan'),(6,2,'201','2','Dipesan'),(7,2,'202','2','Terisi'),(8,2,'203','2','Tersedia'),(9,2,'204','2','Tersedia'),(10,2,'205','2','Dipesan'),(11,3,'301','3','Terisi'),(12,3,'302','3','Dipesan'),(13,3,'303','3','Tersedia'),(14,3,'304','3','Tersedia'),(15,3,'305','3','Dipesan'),(16,4,'401','4','Terisi'),(17,4,'402','4','Dipesan'),(18,4,'403','4','Tersedia'),(19,4,'404','4','Tersedia'),(20,4,'405','4','Dipesan'),(21,5,'501','5','Terisi'),(22,5,'502','5','Dipesan'),(23,5,'503','5','Tersedia'),(24,5,'504','5','Tersedia'),(25,5,'505','5','Dipesan');
/*!40000 ALTER TABLE `kamar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kamar_fasilitas`
--

DROP TABLE IF EXISTS `kamar_fasilitas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kamar_fasilitas` (
  `id_kamar` int NOT NULL,
  `id_fasilitas` int NOT NULL,
  PRIMARY KEY (`id_kamar`,`id_fasilitas`),
  KEY `fk_kf_fasilitas` (`id_fasilitas`),
  CONSTRAINT `fk_kf_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_kf_kamar` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kamar_fasilitas`
--

LOCK TABLES `kamar_fasilitas` WRITE;
/*!40000 ALTER TABLE `kamar_fasilitas` DISABLE KEYS */;
INSERT INTO `kamar_fasilitas` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),(8,2),(9,2),(10,2),(11,2),(12,2),(13,2),(14,2),(15,2),(16,2),(17,2),(18,2),(19,2),(20,2),(21,2),(22,2),(23,2),(24,2),(25,2),(1,3),(2,3),(3,3),(4,3),(5,3),(6,3),(7,3),(8,3),(9,3),(10,3),(11,3),(12,3),(13,3),(14,3),(15,3),(16,3),(17,3),(18,3),(19,3),(20,3),(21,3),(22,3),(23,3),(24,3),(25,3),(11,4),(12,4),(13,4),(14,4),(15,4),(21,4),(22,4),(23,4),(24,4),(25,4),(6,5),(7,5),(8,5),(9,5),(10,5),(11,5),(12,5),(13,5),(14,5),(15,5),(16,5),(17,5),(18,5),(19,5),(20,5),(21,5),(22,5),(23,5),(24,5),(25,5),(16,6),(17,6),(18,6),(19,6),(20,6),(21,6),(22,6),(23,6),(24,6),(25,6),(21,7),(22,7),(23,7),(24,7),(25,7),(21,8),(22,8),(23,8),(24,8),(25,8),(11,9),(12,9),(13,9),(14,9),(15,9),(16,9),(17,9),(18,9),(19,9),(20,9),(21,9),(22,9),(23,9),(24,9),(25,9),(16,10),(17,10),(18,10),(19,10),(20,10),(21,10),(22,10),(23,10),(24,10),(25,10);
/*!40000 ALTER TABLE `kamar_fasilitas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_aktivitas`
--

DROP TABLE IF EXISTS `log_aktivitas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_aktivitas`
--

LOCK TABLES `log_aktivitas` WRITE;
/*!40000 ALTER TABLE `log_aktivitas` DISABLE KEYS */;
INSERT INTO `log_aktivitas` VALUES (1,1,'Membuat Reservasi','2026-05-01 09:15:00','Reservasi ID 1 dibuat untuk tamu Andi Pratama.'),(2,3,'Mencatat Pembayaran','2026-05-02 10:20:00','Pembayaran reservasi ID 2 dicatat lunas.'),(3,4,'Proses Check-in','2026-05-11 14:20:00','Check-in reservasi ID 2 berhasil dilakukan.'),(4,2,'Proses Check-out','2026-05-14 10:45:00','Check-out reservasi ID 2 selesai dengan biaya laundry.'),(5,7,'Konfirmasi Reservasi','2026-05-15 11:00:00','Reservasi ID 15 dikonfirmasi oleh customer service.'),(6,9,'Mencatat Pembayaran','2026-05-16 13:30:00','Pembayaran reservasi ID 16 diterima melalui transfer.'),(7,1,'Update Status Kamar','2026-05-17 12:00:00','Status kamar diperbarui setelah check-out.'),(8,5,'Pemeriksaan Kamar','2026-05-18 09:00:00','Housekeeping memeriksa kamar setelah tamu check-out.'),(9,8,'Audit Malam','2026-05-19 23:30:00','Night auditor melakukan pemeriksaan transaksi harian.'),(10,6,'Monitoring Operasional','2026-05-20 16:45:00','Manager operasional mengevaluasi tingkat okupansi kamar.'),(11,3,'Proses Refund','2026-05-21 14:10:00','Refund reservasi ID 21 dicatat karena reservasi dibatalkan.'),(12,7,'Konfirmasi Reservasi','2026-05-22 10:35:00','Reservasi ID 22 dikonfirmasi untuk jadwal menginap bulan Juni.');
/*!40000 ALTER TABLE `log_aktivitas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pegawai`
--

DROP TABLE IF EXISTS `pegawai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pegawai` (
  `id_pegawai` int NOT NULL AUTO_INCREMENT,
  `nama_pegawai` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jabatan` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_telepon` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pegawai`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pegawai`
--

LOCK TABLES `pegawai` WRITE;
/*!40000 ALTER TABLE `pegawai` DISABLE KEYS */;
INSERT INTO `pegawai` VALUES (1,'Rina Kartika','Resepsionis','081300000001','rina.kartika@hotel.local','2026-05-31 09:13:51'),(2,'Fajar Nugroho','Supervisor Front Office','081300000002','fajar.nugroho@hotel.local','2026-05-31 09:13:51'),(3,'Maya Puspita','Kasir','081300000003','maya.puspita@hotel.local','2026-05-31 09:13:51'),(4,'Doni Saputra','Resepsionis','081300000004','doni.saputra@hotel.local','2026-05-31 09:13:51'),(5,'Ayu Wulandari','Housekeeping','081300000005','ayu.wulandari@hotel.local','2026-05-31 09:13:51'),(6,'Bagus Prakoso','Manager Operasional','081300000006','bagus.prakoso@hotel.local','2026-05-31 09:13:51'),(7,'Nina Herlina','Customer Service','081300000007','nina.herlina@hotel.local','2026-05-31 09:13:51'),(8,'Rafael Aditya','Night Auditor','081300000008','rafael.aditya@hotel.local','2026-05-31 09:13:51'),(9,'Salsa Kirana','Kasir','081300000009','salsa.kirana@hotel.local','2026-05-31 09:13:51'),(10,'Wahyu Hidayat','Bellboy','081300000010','wahyu.hidayat@hotel.local','2026-05-31 09:13:51');
/*!40000 ALTER TABLE `pegawai` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pembayaran`
--

DROP TABLE IF EXISTS `pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pembayaran` (
  `id_pembayaran` int NOT NULL AUTO_INCREMENT,
  `id_reservasi` int NOT NULL,
  `tanggal_pembayaran` date NOT NULL,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `metode_pembayaran` enum('Tunai','Transfer','Kartu Kredit','E-Wallet') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_pembayaran` enum('Pending','Lunas','Gagal','Refund') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`id_pembayaran`),
  KEY `idx_pembayaran_reservasi` (`id_reservasi`),
  KEY `idx_pembayaran_status` (`status_pembayaran`),
  CONSTRAINT `fk_pembayaran_reservasi` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pembayaran_chk_1` CHECK ((`jumlah_bayar` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pembayaran`
--

LOCK TABLES `pembayaran` WRITE;
/*!40000 ALTER TABLE `pembayaran` DISABLE KEYS */;
INSERT INTO `pembayaran` VALUES (1,1,'2026-05-01',700000.00,'Transfer','Lunas'),(2,2,'2026-05-02',1350000.00,'Kartu Kredit','Lunas'),(3,3,'2026-05-03',1200000.00,'E-Wallet','Lunas'),(4,4,'2026-05-04',3400000.00,'Transfer','Lunas'),(5,5,'2026-05-05',2500000.00,'Kartu Kredit','Lunas'),(6,6,'2026-05-06',700000.00,'Tunai','Lunas'),(7,7,'2026-05-07',900000.00,'Transfer','Lunas'),(8,8,'2026-05-08',1800000.00,'E-Wallet','Lunas'),(9,9,'2026-05-09',1700000.00,'Kartu Kredit','Lunas'),(10,10,'2026-05-10',3750000.00,'Transfer','Lunas'),(11,11,'2026-05-11',1600000.00,'Transfer','Lunas'),(12,12,'2026-05-12',600000.00,'Tunai','Lunas'),(13,13,'2026-05-13',2550000.00,'Transfer','Pending'),(14,14,'2026-05-14',2500000.00,'Kartu Kredit','Lunas'),(15,15,'2026-05-15',1400000.00,'E-Wallet','Pending'),(16,16,'2026-05-16',2100000.00,'Transfer','Lunas'),(17,17,'2026-05-17',850000.00,'Tunai','Lunas'),(18,18,'2026-05-18',2500000.00,'Kartu Kredit','Pending'),(19,19,'2026-05-19',1350000.00,'Transfer','Pending'),(20,20,'2026-05-20',1200000.00,'E-Wallet','Pending'),(21,21,'2026-05-21',1700000.00,'Transfer','Refund'),(22,22,'2026-05-22',1600000.00,'Kartu Kredit','Lunas');
/*!40000 ALTER TABLE `pembayaran` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_pembayaran_insert` AFTER INSERT ON `pembayaran` FOR EACH ROW BEGIN
    INSERT INTO log_aktivitas (id_pegawai, aktivitas, waktu_aktivitas, keterangan)
    SELECT
        r.id_pegawai,
        'Pembayaran Masuk',
        NOW(),
        CONCAT('Pembayaran reservasi ID ', NEW.id_reservasi, ' sebesar ', NEW.jumlah_bayar, ' dicatat.')
    FROM reservasi r
    WHERE r.id_reservasi = NEW.id_reservasi;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `reservasi`
--

DROP TABLE IF EXISTS `reservasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservasi` (
  `id_reservasi` int NOT NULL AUTO_INCREMENT,
  `id_tamu` int NOT NULL,
  `id_pegawai` int NOT NULL,
  `tanggal_reservasi` date NOT NULL,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservasi`
--

LOCK TABLES `reservasi` WRITE;
/*!40000 ALTER TABLE `reservasi` DISABLE KEYS */;
INSERT INTO `reservasi` VALUES (1,1,1,'2026-05-01','2026-05-10','2026-05-12','Selesai'),(2,2,1,'2026-05-02','2026-05-11','2026-05-14','Selesai'),(3,3,2,'2026-05-03','2026-05-12','2026-05-14','Selesai'),(4,4,4,'2026-05-04','2026-05-13','2026-05-17','Selesai'),(5,5,7,'2026-05-05','2026-05-15','2026-05-17','Selesai'),(6,6,1,'2026-05-06','2026-05-16','2026-05-17','Selesai'),(7,7,2,'2026-05-07','2026-05-18','2026-05-20','Selesai'),(8,8,4,'2026-05-08','2026-05-19','2026-05-22','Selesai'),(9,9,7,'2026-05-09','2026-05-20','2026-05-22','Selesai'),(10,10,1,'2026-05-10','2026-05-21','2026-05-24','Selesai'),(11,11,2,'2026-05-11','2026-06-01','2026-06-03','Check-in'),(12,12,4,'2026-05-12','2026-06-02','2026-06-03','Check-in'),(13,13,7,'2026-05-13','2026-06-05','2026-06-08','Dikonfirmasi'),(14,14,1,'2026-05-14','2026-06-06','2026-06-08','Dikonfirmasi'),(15,15,2,'2026-05-15','2026-06-09','2026-06-13','Dikonfirmasi'),(16,16,4,'2026-05-16','2026-06-10','2026-06-12','Dikonfirmasi'),(17,17,7,'2026-05-17','2026-06-12','2026-06-13','Dikonfirmasi'),(18,18,1,'2026-05-18','2026-06-14','2026-06-16','Dikonfirmasi'),(19,19,2,'2026-05-19','2026-06-17','2026-06-20','Menunggu'),(20,20,4,'2026-05-20','2026-06-18','2026-06-20','Menunggu'),(21,3,7,'2026-05-21','2026-06-21','2026-06-23','Dibatalkan'),(22,8,1,'2026-05-22','2026-06-24','2026-06-25','Dikonfirmasi');
/*!40000 ALTER TABLE `reservasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tamu`
--

DROP TABLE IF EXISTS `tamu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tamu` (
  `id_tamu` int NOT NULL AUTO_INCREMENT,
  `nama_tamu` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_identitas` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_telepon` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tamu`),
  UNIQUE KEY `no_identitas` (`no_identitas`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tamu`
--

LOCK TABLES `tamu` WRITE;
/*!40000 ALTER TABLE `tamu` DISABLE KEYS */;
INSERT INTO `tamu` VALUES (1,'Andi Pratama','3174010101900001','Laki-laki','081234567801','andi.pratama@example.com','Jl. Melati No. 10, Jakarta','2026-05-31 09:13:51'),(2,'Siti Rahmawati','3273024502920002','Perempuan','081234567802','siti.rahmawati@example.com','Jl. Braga No. 25, Bandung','2026-05-31 09:13:51'),(3,'Budi Santoso','3578011203880003','Laki-laki','081234567803','budi.santoso@example.com','Jl. Diponegoro No. 8, Surabaya','2026-05-31 09:13:51'),(4,'Dewi Lestari','3374015204950004','Perempuan','081234567804','dewi.lestari@example.com','Jl. Malioboro No. 15, Yogyakarta','2026-05-31 09:13:51'),(5,'Rizky Ramadhan','3671011804960005','Laki-laki','081234567805','rizky.ramadhan@example.com','Jl. Sudirman No. 21, Tangerang','2026-05-31 09:13:51'),(6,'Nadia Putri','3175026107980006','Perempuan','081234567806','nadia.putri@example.com','Jl. Ahmad Yani No. 9, Bekasi','2026-05-31 09:13:51'),(7,'Hendra Wijaya','3471042206870007','Laki-laki','081234567807','hendra.wijaya@example.com','Jl. Gejayan No. 12, Yogyakarta','2026-05-31 09:13:51'),(8,'Maya Sari','7371015403910008','Perempuan','081234567808','maya.sari@example.com','Jl. Pengayoman No. 18, Makassar','2026-05-31 09:13:51'),(9,'Arief Nugraha','3276010712860009','Laki-laki','081234567809','arief.nugraha@example.com','Jl. Margonda Raya No. 30, Depok','2026-05-31 09:13:51'),(10,'Lina Marlina','3573024405900010','Perempuan','081234567810','lina.marlina@example.com','Jl. Veteran No. 5, Malang','2026-05-31 09:13:51'),(11,'Fauzan Akbar','6471011504890011','Laki-laki','081234567811','fauzan.akbar@example.com','Jl. Mulawarman No. 7, Balikpapan','2026-05-31 09:13:51'),(12,'Intan Permata','5171015807940012','Perempuan','081234567812','intan.permata@example.com','Jl. Teuku Umar No. 16, Denpasar','2026-05-31 09:13:51'),(13,'Yoga Saputra','1371012003930013','Laki-laki','081234567813','yoga.saputra@example.com','Jl. Khatib Sulaiman No. 11, Padang','2026-05-31 09:13:51'),(14,'Putri Amelia','1275016302970014','Perempuan','081234567814','putri.amelia@example.com','Jl. Sisingamangaraja No. 22, Medan','2026-05-31 09:13:51'),(15,'Agus Setiawan','1671010505850015','Laki-laki','081234567815','agus.setiawan@example.com','Jl. Basuki Rahmat No. 3, Palembang','2026-05-31 09:13:51'),(16,'Citra Anjani','3372014701990016','Perempuan','081234567816','citra.anjani@example.com','Jl. Slamet Riyadi No. 40, Solo','2026-05-31 09:13:51'),(17,'Dimas Arya','3674022607920017','Laki-laki','081234567817','dimas.arya@example.com','Jl. Serpong Raya No. 19, Tangerang Selatan','2026-05-31 09:13:51'),(18,'Rani Maharani','3271016806880018','Perempuan','081234567818','rani.maharani@example.com','Jl. Asia Afrika No. 14, Bandung','2026-05-31 09:13:51'),(19,'Teguh Firmansyah','3173030901840019','Laki-laki','081234567819','teguh.firmansyah@example.com','Jl. Gatot Subroto No. 28, Jakarta','2026-05-31 09:13:51'),(20,'Selvi Oktaviani','3673015709960020','Perempuan','081234567820','selvi.oktaviani@example.com','Jl. Imam Bonjol No. 6, Serang','2026-05-31 09:13:51');
/*!40000 ALTER TABLE `tamu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipe_kamar`
--

DROP TABLE IF EXISTS `tipe_kamar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipe_kamar`
--

LOCK TABLES `tipe_kamar` WRITE;
/*!40000 ALTER TABLE `tipe_kamar` DISABLE KEYS */;
INSERT INTO `tipe_kamar` VALUES (1,'Standard',2,350000.00,'Kamar standar untuk tamu individu atau pasangan dengan fasilitas dasar.'),(2,'Superior',2,450000.00,'Kamar superior dengan area lebih luas dan fasilitas tambahan.'),(3,'Deluxe',2,600000.00,'Kamar deluxe dengan interior lebih nyaman dan pemandangan kota.'),(4,'Family',4,850000.00,'Kamar keluarga dengan kapasitas lebih besar.'),(5,'Suite',4,1250000.00,'Kamar suite premium dengan ruang duduk dan fasilitas lengkap.');
/*!40000 ALTER TABLE `tipe_kamar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_detail_reservasi_tamu`
--

DROP TABLE IF EXISTS `vw_detail_reservasi_tamu`;
/*!50001 DROP VIEW IF EXISTS `vw_detail_reservasi_tamu`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_detail_reservasi_tamu` AS SELECT 
 1 AS `id_reservasi`,
 1 AS `nama_tamu`,
 1 AS `no_telepon`,
 1 AS `nomor_kamar`,
 1 AS `nama_tipe`,
 1 AS `tanggal_checkin_rencana`,
 1 AS `tanggal_checkout_rencana`,
 1 AS `jumlah_malam`,
 1 AS `harga_per_malam`,
 1 AS `subtotal`,
 1 AS `status_reservasi`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_laporan_pembayaran`
--

DROP TABLE IF EXISTS `vw_laporan_pembayaran`;
/*!50001 DROP VIEW IF EXISTS `vw_laporan_pembayaran`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_laporan_pembayaran` AS SELECT 
 1 AS `id_pembayaran`,
 1 AS `id_reservasi`,
 1 AS `nama_tamu`,
 1 AS `tanggal_pembayaran`,
 1 AS `jumlah_bayar`,
 1 AS `metode_pembayaran`,
 1 AS `status_pembayaran`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'hotel_reservation_db'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_hitung_total_biaya` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_hitung_total_biaya`(
    p_harga_per_malam DECIMAL(12,2),
    p_jumlah_malam INT
) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN
    RETURN COALESCE(p_harga_per_malam, 0) * COALESCE(p_jumlah_malam, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_hitung_total_reservasi` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_hitung_total_reservasi`(
    IN p_id_reservasi INT,
    OUT p_total_biaya DECIMAL(12,2)
)
BEGIN
    SELECT COALESCE(SUM(subtotal), 0)
    INTO p_total_biaya
    FROM detail_reservasi
    WHERE id_reservasi = p_id_reservasi;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_detail_reservasi_tamu`
--

/*!50001 DROP VIEW IF EXISTS `vw_detail_reservasi_tamu`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_detail_reservasi_tamu` AS select `r`.`id_reservasi` AS `id_reservasi`,`t`.`nama_tamu` AS `nama_tamu`,`t`.`no_telepon` AS `no_telepon`,`k`.`nomor_kamar` AS `nomor_kamar`,`tk`.`nama_tipe` AS `nama_tipe`,`r`.`tanggal_checkin_rencana` AS `tanggal_checkin_rencana`,`r`.`tanggal_checkout_rencana` AS `tanggal_checkout_rencana`,`dr`.`jumlah_malam` AS `jumlah_malam`,`dr`.`harga_per_malam` AS `harga_per_malam`,`dr`.`subtotal` AS `subtotal`,`r`.`status_reservasi` AS `status_reservasi` from ((((`reservasi` `r` join `tamu` `t` on((`r`.`id_tamu` = `t`.`id_tamu`))) join `detail_reservasi` `dr` on((`r`.`id_reservasi` = `dr`.`id_reservasi`))) join `kamar` `k` on((`dr`.`id_kamar` = `k`.`id_kamar`))) join `tipe_kamar` `tk` on((`k`.`id_tipe_kamar` = `tk`.`id_tipe_kamar`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_laporan_pembayaran`
--

/*!50001 DROP VIEW IF EXISTS `vw_laporan_pembayaran`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_laporan_pembayaran` AS select `pb`.`id_pembayaran` AS `id_pembayaran`,`r`.`id_reservasi` AS `id_reservasi`,`t`.`nama_tamu` AS `nama_tamu`,`pb`.`tanggal_pembayaran` AS `tanggal_pembayaran`,`pb`.`jumlah_bayar` AS `jumlah_bayar`,`pb`.`metode_pembayaran` AS `metode_pembayaran`,`pb`.`status_pembayaran` AS `status_pembayaran` from ((`pembayaran` `pb` join `reservasi` `r` on((`pb`.`id_reservasi` = `r`.`id_reservasi`))) join `tamu` `t` on((`r`.`id_tamu` = `t`.`id_tamu`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-31 16:41:02
