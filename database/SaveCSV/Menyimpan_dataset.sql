SHOW VARIABLES LIKE 'secure_file_priv';  -- 'secure_file_priv', 'C:\\ProgramData\\MySQL\\MySQL Server 9.6\\Uploads\\'


SELECT *
FROM tamu
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/tamu.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT *
FROM kamar
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/kamar.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM pegawai
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/pegawai.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM tipe_kamar
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/tipe_kamar.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM fasilitas
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/fasilitas.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM reservasi
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/reservasi.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM detail_reservasi
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/detail_reservasi.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM pembayaran
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/pembayaran.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM checkin
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/checkin.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM checkout
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/checkout.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM kamar_fasilitas
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/kamar_fasilitas.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM log_aktivitas
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/log_aktivitas.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


































