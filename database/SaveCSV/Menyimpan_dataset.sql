USE hotel_reservation_db;

-- =============================================================================
-- KELOMPOK 1: EXPORT DATA MASTER (ENTITAS BERDIRI SENDIRI)
-- =============================================================================

-- 1. Export Data Master Tamu
SELECT * FROM tamu
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/tamu.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 2. Export Data Master Pegawai
SELECT * FROM pegawai
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/pegawai.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 3. Export Data Tipe Kamar
SELECT * FROM tipe_kamar
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/tipe_kamar.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 4. Export Data Master Fasilitas Hotel
SELECT * FROM fasilitas
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/fasilitas.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';


-- =============================================================================
-- KELOMPOK 2: EXPORT DATA OPERASIONAL & TRANSAKSI (MEMILIKI FOREIGN KEY)
-- =============================================================================

-- 5. Export Data Kamar Fisik
SELECT * FROM kamar
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/kamar.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 6. Export Data Induk Reservasi (Header)
SELECT * FROM reservasi
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/reservasi.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 7. Export Data Detail Penempatan Kamar Reservasi
SELECT * FROM detail_reservasi
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/detail_reservasi.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 8. Export Data Log Keuangan Pembayaran
SELECT * FROM pembayaran
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/pembayaran.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 9. Export Data Riwayat Masuk Tamu (Check-In)
SELECT * FROM checkin
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/checkin.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 10. Export Data Riwayat Keluar & Denda Tamu (Check-Out)
SELECT * FROM checkout
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/checkout.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';


-- =============================================================================
-- KELOMPOK 3: EXPORT DATA JEMBATAN RELASI & AUDIT SYSTEM LOG
-- =============================================================================

-- 11. Export Data Jembatan Many-to-Many Kamar & Fasilitas
SELECT * FROM kamar_fasilitas
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/kamar_fasilitas.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- 12. Export Data Audit Forensik Sistem Log Aktivitas
SELECT * FROM log_aktivitas
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/log_aktivitas.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';