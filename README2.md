# 🏢 Sistem Reservasi Hotel - Arsitektur Basis Data Tingkat Enterprise

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)
![Database Architecture](https://img.shields.io/badge/Database-Architecture-success?style=for-the-badge)
![Security & Triggers](https://img.shields.io/badge/Security-Triggers-red?style=for-the-badge)
![Academic & Production](https://img.shields.io/badge/Status-Production--Ready-blueviolet?style=for-the-badge)

---

## 📌 1. Pendahuluan & Deskripsi Sistem

Dalam industri perhotelan modern berskala *enterprise*, sistem pengelolaan reservasi yang andal, aman, dan konsisten secara waktu nyata (*real-time*) merupakan fondasi utama dari efisiensi operasional. Kompleksitas manajemen hotel tidak hanya terletak pada penyimpanan data tamu, tetapi juga pada penyelesaian tantangan kritis seperti **sinkronisasi status kamar**, **pemeliharaan integritas finansial**, dan **pencatatan audit log** yang menyeluruh untuk mencegah penyelewengan.

Sistem Reservasi Hotel (Enterprise Version) ini dirancang khusus untuk mengatasi tantangan tersebut dengan memindahkan logika bisnis kritis langsung ke dalam tingkat basis data (*self-contained business logic*). Pendekatan arsitektur ini memastikan bahwa:
1. **Pencegahan Overbooking / Double Booking** diselesaikan secara mutlak di tingkat database menggunakan *trigger* validasi transaksional, sehingga tidak ada ketergantungan pada pengecekan tingkat aplikasi (backend) yang rentan terhadap *race conditions*.
2. **Sinkronisasi Status Kamar** (dari *Tersedia*, *Dipesan*, *Terisi*, hingga *Tersedia kembali* atau dalam masa *Perawatan*) berjalan secara otomatis dan atomik melalui *trigger* pasca-transaksi (*after insert*).
3. **Integritas Finansial** dijamin dengan penggunaan *virtual generated columns* untuk kalkulasi otomatis, kontrol transaksi ACID (*Atomicity, Consistency, Isolation, Durability*) melalui *stored procedures*, dan proteksi kelebihan bayar (*overpayment*).
4. **Audit Trail Komprehensif** merekam setiap mutasi pembayaran dan aktivitas operasional secara non-destruktif ke dalam log aktivitas sistem secara otomatis.

Dengan arsitektur yang mandiri (*self-contained*), database ini tidak hanya berfungsi sebagai media penyimpanan pasif (*passive storage*), melainkan sebagai mesin penegak aturan bisnis (*business rule enforcement engine*) yang kokoh, cepat, dan aman dari manipulasi eksternal.

---

## ⚙️ 2. Analisis & Spesifikasi Sistem

### 2.1 Ruang Lingkup Sistem (Scope)
Sistem reservasi ini melingkupi siklus operasional hotel ujung-ke-ujung (*end-to-end*) yang terbagi menjadi beberapa modul inti basis data:
* **Manajemen Profil & Tamu:** Mengelola data identitas tamu secara unik, aman, dan mendukung penghapusan logis (*soft delete*) untuk menjaga riwayat transaksi.
* **Manajemen Pegawai & Akuntabilitas:** Mencatat data pegawai beserta jabatannya untuk menetapkan tanggung jawab hukum atas setiap transaksi check-in, check-out, dan pencatatan pembayaran.
* **Master Kamar & Fasilitas:** Mengelola data fisik kamar, pengelompokan tipe kamar (kapasitas dan harga dasar per malam), serta relasi banyak-ke-banyak (*many-to-many*) antara kamar dengan fasilitas yang tersedia.
* **Transaksi Reservasi (Header & Detail):** Memproses pemesanan kamar yang fleksibel di mana satu reservasi dapat mencakup beberapa kamar sekaligus (*multi-room reservation*) untuk durasi menginap tertentu.
* **Enkapsulasi Pembayaran:** Mengelola pembayaran tagihan reservasi secara bertahap (*split payment*) dengan validasi ketat terhadap batas maksimum tagihan guna menghindari kesalahan input kasir.
* **Operasional Check-In & Check-Out:** Dokumentasi waktu riil kedatangan tamu, pencatatan kondisi/catatan fisik kamar saat check-in, serta pencatatan waktu keluar beserta pembebanan biaya tambahan (*extra charge*) jika ada kerusakan atau keterlambatan.
* **Audit Trail (Aktivitas Log):** Perekaman otomatis aktivitas operasional pegawai untuk keperluan kepatuhan (*compliance*) dan forensik data.

### 2.2 Aturan Bisnis (Business Rules)
Untuk menjamin konsistensi data, arsitektur basis data menerapkan aturan bisnis yang divalidasi langsung oleh DBMS:
1. **Hubungan Tamu & Reservasi:** Satu tamu dapat memiliki banyak riwayat reservasi (`1:M`), namun satu reservasi hanya terikat pada satu tamu terdaftar.
2. **Validasi Rentang Waktu:** Tanggal rencana check-out harus secara logis lebih besar dari tanggal rencana check-in (`tanggal_checkout_rencana > tanggal_checkin_rencana`). Jika dilanggar, DBMS akan menolak penyimpanan data.
3. **Restriksi Kamar Perawatan:** Kamar yang memiliki status operasional `Perawatan` tidak diizinkan masuk ke dalam transaksi pemesanan baru.
4. **Kalkulasi Subtotal Otomatis:** Nilai subtotal di dalam detail reservasi dihitung secara otomatis oleh sistem melalui formula `jumlah_malam * harga_per_malam` tanpa intervensi manual dari backend developer.
5. **Anti Double-Booking:** Kamar yang sama tidak boleh dimasukkan ke dalam detail reservasi aktif yang memiliki irisan tanggal hunian bertabrakan dengan reservasi lain yang sudah terkonfirmasi.
6. **Proteksi Overpayment:** Nominal pembayaran yang diinput oleh kasir tidak boleh melebihi sisa tagihan aktif dari reservasi terkait.
7. **Pembersihan Status Kamar:** Saat proses check-out selesai, status kamar harus otomatis kembali menjadi `Tersedia` (kecuali jika diset menjadi `Perawatan` untuk pembersihan mendalam).
8. **Soft Delete Data Master:** Data tamu dan pegawai tidak boleh dihapus secara fisik (`DELETE`) agar tidak merusak integritas referensial data transaksi masa lalu. Penghapusan dilakukan secara logis melalui penanda status `is_active = 0`.

---

## 🔄 3. Deskripsi Alur Kerja (Workflow Diagram & Process)

### 3.1 Alur Reservasi & Pembayaran

```text
[ TAMU ] ──> Pilih Kamar & Tanggal ──> Cek Bentrok Tanggal (Trigger Validasi)
                                                │
                                       ┌────────┴────────┐
                                    [BENTROK]        [TERSEDIA]
                                       │                 │
                                 Ditolak (Error)    Status Kamar: 'Dipesan'
                                                    Reservasi: 'Menunggu'
                                                         │
                                                         ▼
                                                Kasir Input Pembayaran
                                                         │
                                            ┌────────────┴────────────┐
                                    [OVERPAYMENT]               [VALID]
                                         │                            │
                                   Ditolak (Error)            Pembayaran Disimpan
                                                              Log Audit Keuangan
                                                                      │
                                                           ┌──────────┴──────────┐
                                                    [SISA TAGIHAN > 0]    [SISA TAGIHAN <= 0]
                                                           │                     │
                                                   Tetap 'Menunggu'       Set 'Dikonfirmasi'
```

* **Proses Transaksi:**
  1. Tamu melakukan pemesanan untuk kamar tertentu pada rentang tanggal rencana check-in dan check-out.
  2. Sebelum data disimpan ke tabel `detail_reservasi`, *trigger* `trg_before_detail_reservasi_insert` melakukan pengecekan ganda: memastikan status kamar tidak sedang `Perawatan` dan tidak ada reservasi terkonfirmasi lain yang memesan kamar tersebut pada tanggal yang saling tumpang tindih (*overlap*).
  3. Jika aman, reservasi tercatat dengan status awal `Menunggu` dan status kamar fisik berubah menjadi `Dipesan` (*after insert trigger*).
  4. Ketika tamu melakukan pembayaran deposit atau pelunasan, kasir menginput data ke tabel `pembayaran`.
  5. *Trigger* sebelum penyisipan data pembayaran (`trg_before_insert_pembayaran`) menghitung sisa tagihan saat ini. Jika jumlah bayar baru melebihi sisa tagihan, transaksi dihentikan secara paksa (*raise error*).
  6. Jika pembayaran valid, status reservasi diperbarui menjadi `Dikonfirmasi` (apabila tagihan telah lunas) dan rincian transaksi kasir langsung disalin ke tabel audit `log_aktivitas`.

### 3.2 Alur Operasional Check-In & Check-Out

```text
[ RESERVASI DIKONFIRMASI ]
           │
           ▼
Panggil Stored Procedure: sp_proses_checkin_aman (Atomic Transaction)
           │
           ├──> INSERT INTO checkin
           ├──> UPDATE kamar SET status_kamar = 'Terisi' (Trigger)
           ├──> UPDATE reservasi SET status_reservasi = 'Check-in' (Trigger)
           ├──> INSERT INTO log_aktivitas (Audit Trail)
           │
     [ COMMIT / ROLLBACK JIKA ERROR ]
           │
           ▼
[ TAMU MENGINAP (Status Kamar: Terisi) ]
           │
           ▼
Tamu Check-Out ──> Catat Biaya Tambahan (Jika Ada)
           │
           ▼
INSERT INTO checkout ──> Trigger AFTER INSERT:
                             ├──> UPDATE kamar SET status_kamar = 'Tersedia'
                             ├──> UPDATE reservasi SET status_reservasi = 'Selesai'
                             └──> Catat Audit Log Penutupan Transaksi
```

* **Proses Transaksi:**
  1. Pada hari kedatangan, resepsionis mengeksekusi *Stored Procedure* `sp_proses_checkin_aman`. Prosedur ini bekerja di dalam satu cakupan transaksi ACID guna memastikan pencatatan data ke tabel `checkin` terlaksana secara aman.
  2. *Trigger* `trg_after_checkin_insert` merespons penyisipan data check-in dengan mengubah status kamar fisik secara instan menjadi `Terisi` dan status reservasi menjadi `Check-in`.
  3. Saat tamu selesai menginap, pegawai memproses kepulangan dengan memasukkan data ke tabel `checkout` (mencatat waktu keluar riil serta biaya tambahan seperti *late check-out* atau denda kerusakan barang jika ada).
  4. Penyisipan data checkout memicu *trigger* `trg_after_checkout_insert` yang bertugas melepaskan kembali status kamar menjadi `Tersedia` agar dapat dipesan kembali oleh tamu lain, serta mengubah status reservasi akhir menjadi `Selesai` secara otomatis.

---

## 🗺️ 4. Arsitektur Data & Relasi (ERD Schema)

Berikut adalah visualisasi hubungan relasional database menggunakan notasi *Crow's Foot* yang menggambarkan aliran kunci utama (*Primary Key* - PK) ke kunci tamu (*Foreign Key* - FK):

```mermaid
erDiagram
    TAMU {
        INT id_tamu PK
        VARCHAR nama_tamu
        VARCHAR no_identitas UNIQUE
        ENUM jenis_kelamin
        VARCHAR no_telepon
        VARCHAR email UNIQUE
        TEXT alamat
        TINYINT is_active
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }

    PEGAWAI {
        INT id_pegawai PK
        VARCHAR nama_pegawai
        VARCHAR jabatan
        VARCHAR no_telepon
        VARCHAR email UNIQUE
        TINYINT is_active
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }

    TIPE_KAMAR {
        INT id_tipe_kamar PK
        VARCHAR nama_tipe UNIQUE
        INT kapasitas
        DECIMAL harga_per_malam
        TEXT deskripsi
    }

    FASILITAS {
        INT id_fasilitas PK
        VARCHAR nama_fasilitas UNIQUE
        TEXT deskripsi
    }

    KAMAR {
        INT id_kamar PK
        INT id_tipe_kamar FK
        VARCHAR nomor_kamar UNIQUE
        VARCHAR lantai
        ENUM status_kamar
    }

    KAMAR_FASILITAS {
        INT id_kamar PK_FK
        INT id_fasilitas PK_FK
    }

    RESERVASI {
        INT id_reservasi PK
        INT id_tamu FK
        INT id_pegawai FK
        DATETIME tanggal_reservasi
        DATE tanggal_checkin_rencana
        DATE tanggal_checkout_rencana
        ENUM status_reservasi
    }

    DETAIL_RESERVASI {
        INT id_detail_reservasi PK
        INT id_reservasi FK
        INT id_kamar FK
        INT jumlah_malam
        DECIMAL harga_per_malam
        DECIMAL subtotal "GENERATED STORED"
    }

    PEMBAYARAN {
        INT id_pembayaran PK
        INT id_reservasi FK
        DATETIME tanggal_pembayaran
        DECIMAL jumlah_bayar
        ENUM metode_pembayaran
        ENUM status_pembayaran
    }

    CHECKIN {
        INT id_checkin PK
        INT id_reservasi FK_UNIQUE
        DATETIME waktu_checkin
        INT id_pegawai FK
        TEXT catatan
    }

    CHECKOUT {
        INT id_checkout PK
        INT id_reservasi FK_UNIQUE
        DATETIME waktu_checkout
        INT id_pegawai FK
        DECIMAL biaya_tambahan
        TEXT catatan
    }

    LOG_AKTIVITAS {
        INT id_log PK
        INT id_pegawai FK
        VARCHAR aktivitas
        DATETIME waktu_aktivitas
        TEXT keterangan
    }

    TAMU ||--o{ RESERVASI : "melakukan"
    PEGAWAI ||--o{ RESERVASI : "membuat"
    PEGAWAI ||--o{ CHECKIN : "memproses"
    PEGAWAI ||--o{ CHECKOUT : "memproses"
    PEGAWAI ||--o{ LOG_AKTIVITAS : "melakukan"
    TIPE_KAMAR ||--o{ KAMAR : "mengelompokkan"
    KAMAR ||--o{ KAMAR_FASILITAS : "memiliki"
    FASILITAS ||--o{ KAMAR_FASILITAS : "tersedia di"
    RESERVASI ||--o{ DETAIL_RESERVASI : "memiliki"
    KAMAR ||--o{ DETAIL_RESERVASI : "dipesan"
    RESERVASI ||--o{ PEMBAYARAN : "dibiayai"
    RESERVASI ||--o| CHECKIN : "terealisasi"
    RESERVASI ||--o| CHECKOUT : "ditutup"
```

### Penjelasan Kunci Hubungan & Integritas Referensial:
1. **`kamar` ke `tipe_kamar`:** Hubungan `1:M` menggunakan opsi `ON UPDATE CASCADE ON DELETE RESTRICT` untuk mencegah terhapusnya tipe kamar yang masih digunakan oleh kamar fisik aktif.
2. **`reservasi` ke `tamu` & `pegawai`:** Menerapkan `ON DELETE RESTRICT` guna memastikan data transaksi historis tidak hilang secara tidak sengaja akibat penghapusan data tamu atau pegawai secara langsung.
3. **`detail_reservasi` ke `reservasi`:** Menggunakan opsi `ON DELETE CASCADE` sehingga jika dokumen induk reservasi dihapus, seluruh detail pemesanan kamar terkait akan terhapus otomatis demi menjaga konsistensi.
4. **`kamar_fasilitas`:** Tabel persimpangan (*junction table*) dengan kunci primer komposit (`id_kamar`, `id_fasilitas`) untuk menormalisasi hubungan banyak-ke-banyak (*many-to-many*) antara kamar fisik dengan inventaris fasilitas hotel.

---

## 💎 5. Fitur Unggulan Arsitektur Data (Advanced Database Features)

### 5.1 Soft Delete (Penghapusan Logis Data Master)
Metode penghapusan logis diterapkan pada tabel master `tamu` dan `pegawai` melalui kolom flag `is_active` (`TINYINT(1)`). Data transaksi historis tetap valid untuk kebutuhan pelaporan keuangan jangka panjang.
* **Keuntungan:** Mencegah *broken references* (kegagalan kunci asing) tanpa kehilangan akurasi audit log operasional masa lalu.
* **Implementasi Query Seleksi Data Aktif:**
```sql
SELECT 
    ID_TAMU, 
    NAMA_TAMU, 
    EMAIL, 
    NO_TELEPON 
FROM TAMU 
WHERE IS_ACTIVE = 1;
```

### 5.2 Data Integrity via Virtual Generated Columns (`subtotal`)
Penghitungan subtotal pembayaran pada tabel `detail_reservasi` diserahkan sepenuhnya ke mesin database menggunakan *Virtual Generated Column* yang disimpan secara fisik (`STORED`).
* **Keuntungan:** Menghilangkan redundansi data, menghindari ketidakcocokan nilai akibat kalkulasi yang salah di sisi aplikasi, dan mempercepat waktu respons query laporan.
* **Implementasi DDL:**
```sql
CREATE TABLE DETAIL_RESERVASI (
    ID_DETAIL_RESERVASI INT AUTO_INCREMENT PRIMARY KEY,
    ID_RESERVASI INT NOT NULL,
    ID_KAMAR INT NOT NULL,
    JUMLAH_MALAM INT NOT NULL CHECK (JUMLAH_MALAM > 0),
    HARGA_PER_MALAM DECIMAL(12,2) NOT NULL CHECK (HARGA_PER_MALAM >= 0),
    -- Subtotal otomatis dihitung oleh database untuk akurasi data finansial
    SUBTOTAL DECIMAL(12,2) GENERATED ALWAYS AS (JUMLAH_MALAM * HARGA_PER_MALAM) STORED,
    CONSTRAINT FK_DETAIL_RESERVASI FOREIGN KEY (ID_RESERVASI) REFERENCES RESERVASI(ID_RESERVASI)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=INNODB;
```

### 5.3 Overpayment Protection via Trigger
Guna menjaga akurasi arus kas keuangan, sistem dilengkapi *trigger* pra-penyisipan data pembayaran untuk memastikan jumlah uang yang dibayarkan tidak melebihi sisa tagihan reservasi.
* **Keuntungan:** Menghindari kerugian administrasi akibat pengembalian dana manual atau kesalahan kasir saat menginput pembayaran.
* **Implementasi SQL Trigger:**
```sql
DELIMITER //

CREATE TRIGGER TRG_BEFORE_INSERT_PEMBAYARAN
BEFORE INSERT ON PEMBAYARAN
FOR EACH ROW
BEGIN
    DECLARE V_TOTAL_TAGIHAN DECIMAL(12,2);
    DECLARE V_TOTAL_DIBAYAR  DECIMAL(12,2);
    DECLARE V_SISA_TAGIHAN   DECIMAL(12,2);
    
    -- 1. Hitung total tagihan kotor menggunakan fungsi yang sudah ada (kamar + denda checkout)
    SET V_TOTAL_TAGIHAN = FN_TOTAL_PENDAPATAN_RESERVASI(NEW.ID_RESERVASI);
    
    -- 2. Hitung akumulasi pembayaran sukses sebelumnya
    SELECT COALESCE(SUM(JUMLAH_BAYAR), 0) INTO V_TOTAL_DIBAYAR
    FROM PEMBAYARAN
    WHERE ID_RESERVASI = NEW.ID_RESERVASI 
      AND STATUS_PEMBAYARAN = 'Lunas';
      
    -- 3. Tentukan sisa tagihan riil
    SET V_SISA_TAGIHAN = V_TOTAL_TAGIHAN - V_TOTAL_DIBAYAR;
    
    -- 4. Validasi kelebihan bayar
    IF NEW.JUMLAH_BAYAR > V_SISA_TAGIHAN THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'OPERASI DITOLAK: Jumlah pembayaran yang diinput melebihi sisa tagihan reservasi (Overpayment).';
    END IF;
END //

DELIMITER ;
```

### 5.4 Atomic Operations via Stored Procedure
Proses check-in melibatkan pembaruan beberapa tabel sekaligus. Sistem menggunakan *Stored Procedure* transaksional `sp_proses_checkin_aman` dengan *Exit Handler* untuk memastikan keandalan eksekusi (*All-or-Nothing*).
* **Keuntungan:** Menghindari keadaan data setengah terproses (*partial updates*) apabila koneksi terputus di tengah proses.
* **Implementasi SQL Stored Procedure:**
```sql
DELIMITER //

CREATE PROCEDURE SP_PROSES_CHECKIN_AMAN(
    IN  P_ID_RESERVASI INT,
    IN  P_ID_PEGAWAI   INT,
    IN  P_CATATAN      TEXT,
    OUT P_STATUS_PESAN VARCHAR(100)
)
BEGIN
    DECLARE V_STATUS_RESERVASI VARCHAR(30);
    DECLARE V_KAMAR_PERAWATAN  INT DEFAULT 0;
    
    -- Exit Handler untuk melakukan ROLLBACK otomatis jika terjadi error SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET P_STATUS_PESAN = 'GAGAL: Terjadi kesalahan internal database. Transaksi dibatalkan (Rollback).';
    END;
    
    -- Ambil status reservasi saat ini
    SELECT STATUS_RESERVASI INTO V_STATUS_RESERVASI
    FROM RESERVASI
    WHERE ID_RESERVASI = P_ID_RESERVASI;
    
    -- Cek jika ada kamar dalam plot reservasi yang berstatus 'Perawatan'
    SELECT COUNT(*) INTO V_KAMAR_PERAWATAN
    FROM DETAIL_RESERVASI DR
    JOIN KAMAR K ON DR.ID_KAMAR = K.ID_KAMAR
    WHERE DR.ID_RESERVASI = P_ID_RESERVASI 
      AND K.STATUS_KAMAR = 'Perawatan';
    
    -- Validasi logika bisnis sebelum melakukan perubahan data
    IF V_STATUS_RESERVASI IS NULL THEN
        SET P_STATUS_PESAN = 'GAGAL: ID Reservasi tidak ditemukan.';
    ELSEIF V_STATUS_RESERVASI <> 'Dikonfirmasi' AND V_STATUS_RESERVASI <> 'Menunggu' THEN
        SET P_STATUS_PESAN = CONCAT('GAGAL: Check-in ditolak karena status reservasi adalah ', V_STATUS_RESERVASI);
    ELSEIF V_KAMAR_PERAWATAN > 0 THEN
        SET P_STATUS_PESAN = 'GAGAL: Kamar masih dalam masa perbaikan/Perawatan.';
    ELSE
        -- Mulai transaksi atomik
        START TRANSACTION;
            
            -- 1. Catat kedatangan ke tabel checkin
            INSERT INTO CHECKIN (ID_RESERVASI, ID_PEGAWAI, CATATAN)
            VALUES (P_ID_RESERVASI, P_ID_PEGAWAI, P_CATATAN);
            
            -- [Efek Samping Trigger trg_after_checkin_insert]:
            -- - Mengubah kamar terkait di detail_reservasi menjadi 'Terisi'
            -- - Mengubah status reservasi menjadi 'Check-in'
            
            -- 2. Tulis riwayat operasional ke log audit
            INSERT INTO LOG_AKTIVITAS (ID_PEGAWAI, AKTIVITAS, KETERANGAN)
            VALUES (
                P_ID_PEGAWAI, 
                'Check-In Tamu', 
                CONCAT('Sukses memproses check-in untuk Reservasi ID ', P_ID_RESERVASI, '.')
            );
            
        COMMIT;
        SET P_STATUS_PESAN = 'SUKSES: Proses check-in berhasil dicatat dan status kamar diperbarui.';
    END IF;
END //

DELIMITER ;
```

### 5.5 Real-time Occupancy & Status Monitoring View
Keperluan resepsionis (*Front Office*) dipenuhi melalui *view* yang menyajikan data ketersediaan kamar secara *real-time* lengkap dengan detail nama tamu yang sedang menginap tanpa perlu menulis *join* yang rumit di tingkat aplikasi.
* **Keuntungan:** Mempercepat beban kerja sistem dalam melakukan query ketersediaan kamar langsung dari memori.
* **Implementasi SQL View:**
```sql
CREATE OR REPLACE VIEW VW_DASHBOARD_OKUPANSI_KAMAR AS
SELECT 
    K.ID_KAMAR,
    K.NOMOR_KAMAR,
    K.LANTAI,
    TK.NAMA_TIPE,
    TK.HARGA_PER_MALAM,
    K.STATUS_KAMAR,
    -- Dapatkan nama tamu secara dinamis jika status kamar terisi
    CASE 
        WHEN K.STATUS_KAMAR = 'Terisi' THEN (
            SELECT T.NAMA_TAMU 
            FROM DETAIL_RESERVASI DR
            JOIN RESERVASI R ON DR.ID_RESERVASI = R.ID_RESERVASI
            JOIN TAMU T ON R.ID_TAMU = T.ID_TAMU
            WHERE DR.ID_KAMAR = K.ID_KAMAR 
              AND R.STATUS_RESERVASI = 'Check-in'
            LIMIT 1
        )
        ELSE '-'
    END AS NAMA_TAMU_SEKARANG
FROM KAMAR K
JOIN TIPE_KAMAR TK ON K.ID_TIPE_KAMAR = TK.ID_TIPE_KAMAR;
```

---

## 🚀 6. Panduan Instalasi & Pengujian Skrip

### 6.1 Langkah Instalasi Menggunakan Skrip SQL Berurutan
Untuk melakukan inisialisasi basis data di server MySQL lokal atau MySQL Workbench, ikuti langkah-langkah di bawah ini secara disiplin:

1. Buka terminal atau konsol MySQL, hubungkan ke server Anda:
   ```bash
   mysql -u root -p
   ```
2. Jalankan skrip DDL untuk membuat skema tabel utama:
   ```sql
   SOURCE database/ddl/01_ddl.sql;
   ```
3. Sisipkan data dummy terstruktur ke dalam tabel master dan transaksi:
   ```sql
   SOURCE database/dml/02_dml.sql;
   ```
4. Buat objek visualisasi data (Views):
   ```sql
   SOURCE database/view/04_view.sql;
   ```
5. Daftarkan fungsi bantu penghitungan keuangan (Functions):
   ```sql
   SOURCE database/function/07_function.sql;
   ```
6. Daftarkan stored procedure transaksional (Procedures):
   ```sql
   SOURCE database/procedure/05_procedure.sql;
   ```
7. Aktifkan otomasi dan validasi trigger sistem (Triggers):
   ```sql
   SOURCE database/trigger/06_trigger.sql;
   ```
8. Muat query pengujian operasional harian:
   ```sql
   SOURCE database/query/03_query.sql;
   ```

### 6.2 Metode Pemulihan Database Menggunakan File Dump
Apabila Anda ingin langsung memulihkan seluruh struktur dan data siap pakai dari file cadangan (*database dump*):
* **Menggunakan CLI / Terminal:**
  ```bash
  mysql -u nama_user -p hotel_reservation_db < database/dump/hotel_reservation_dump.sql
  ```
* **Menggunakan GUI MySQL Workbench:**
  1. Pilih menu utama `Server` -> `Data Import`.
  2. Pilih opsi radio button `Import from Self-Contained File`.
  3. Arahkan direktori path ke file [hotel_reservation_dump.sql](file:///d:/Statistika/Tugas/Basdat/project/Hotel_Reservation_System/database/dump/hotel_reservation_dump.sql).
  4. Pilih target schema: `hotel_reservation_db` (klik *New* jika belum dibuat).
  5. Klik tombol `Start Import` dan tunggu hingga indikator menunjukkan status selesai.

---

### 6.3 Skenario Pengujian Validasi Sistem (Testing Suite)

#### A. Skenario Negatif (Uji Coba Proteksi Kegagalan)
Jalankan perintah SQL di bawah ini untuk membuktikan bahwa database menolak operasi ilegal secara mandiri:

1. **Uji Coba Reservasi Kamar dalam Perawatan (Ekspektasi: Gagal)**
   ```sql
   -- Langkah 1: Buat reservasi penampung
   INSERT INTO RESERVASI (ID_RESERVASI, ID_TAMU, ID_PEGAWAI, TANGGAL_RESERVASI, TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA, STATUS_RESERVASI)
   VALUES (999, 1, 2, NOW(), '2026-07-01', '2026-07-03', 'Menunggu');
   
   -- Langkah 2: Plot kamar nomor 105 (ID Kamar: 5) yang berstatus 'Perawatan'
   -- DBMS wajib melemparkan error 1644: "Kamar tidak dapat dipesan karena sedang dalam masa pemeliharaan/Perawatan"
   INSERT INTO DETAIL_RESERVASI (ID_DETAIL_RESERVASI, ID_RESERVASI, ID_KAMAR, JUMLAH_MALAM, HARGA_PER_MALAM)
   VALUES (999, 999, 5, 2, 350000.00);
   ```

2. **Uji Coba Double Booking Kamar (Ekspektasi: Gagal)**
   ```sql
   -- Langkah 1: Buat reservasi penampung kedua untuk rentang tanggal yang sama
   INSERT INTO RESERVASI (ID_RESERVASI, ID_TAMU, ID_PEGAWAI, TANGGAL_RESERVASI, TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA, STATUS_RESERVASI)
   VALUES (998, 2, 2, NOW(), '2026-05-11', '2026-05-13', 'Dikonfirmasi');
   
   -- Langkah 2: Plot kamar nomor 101 (ID Kamar: 1) yang sudah dipesan oleh tamu lain pada tanggal tersebut
   -- DBMS wajib melemparkan error 1644: "Kamar sudah ter-booking oleh tamu lain pada periode tanggal tersebut"
   INSERT INTO DETAIL_RESERVASI (ID_DETAIL_RESERVASI, ID_RESERVASI, ID_KAMAR, JUMLAH_MALAM, HARGA_PER_MALAM)
   VALUES (998, 998, 1, 2, 350000.00);
   ```

3. **Uji Coba Proteksi Pembayaran Berlebih / Overpayment (Ekspektasi: Gagal)**
   ```sql
   -- Ambil sisa tagihan dari reservasi ID 13 menggunakan function bantu
   SELECT FN_CEK_STATUS_PEMBAYARAN(13) AS 'Status Awal';
   
   -- Misalkan sisa tagihan adalah Rp200.000, lalu kasir mencoba menginput pembayaran Rp500.000
   -- DBMS wajib menggagalkan insert data karena diproteksi oleh trigger
   INSERT INTO PEMBAYARAN (ID_RESERVASI, JUMLAH_BAYAR, METODE_PEMBAYARAN, STATUS_PEMBAYARAN)
   VALUES (13, 500000.00, 'Tunai', 'Lunas');
   ```

---

#### B. Skenario Positif (Uji Coba Keberhasilan Proses End-to-End)
Ikuti langkah-langkah di bawah ini untuk mensimulasikan alur bisnis operasional hotel yang sukses:

1. **Membuat Registrasi Reservasi Baru**
   ```sql
   -- Tambahkan header reservasi untuk Tamu ID: 2, Pegawai ID: 4
   INSERT INTO RESERVASI (ID_RESERVASI, ID_TAMU, ID_PEGAWAI, TANGGAL_RESERVASI, TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA, STATUS_RESERVASI)
   VALUES (900, 2, 4, NOW(), '2026-08-01', '2026-08-03', 'Menunggu');
   
   -- Tambahkan detail pemesanan Kamar ID: 4 (Nomor kamar 104, tipe Deluxe) untuk 2 malam
   INSERT INTO DETAIL_RESERVASI (ID_DETAIL_RESERVASI, ID_RESERVASI, ID_KAMAR, JUMLAH_MALAM, HARGA_PER_MALAM)
   VALUES (900, 900, 4, 2, 350000.00);
   ```
   * *Verifikasi:* Kamar nomor 104 akan otomatis berganti status dari `Tersedia` menjadi `Dipesan`.
   ```sql
   SELECT NOMOR_KAMAR, STATUS_KAMAR FROM KAMAR WHERE ID_KAMAR = 4;
   ```

2. **Melakukan Pembayaran Transaksi**
   ```sql
   -- Panggil stored procedure pembayaran aman untuk melunasi tagihan (Rp700.000)
   CALL SP_PROSES_PEMBAYARAN_AMAN(900, 700000.00, 'Transfer', 4, @out_pesan);
   SELECT @out_pesan AS 'Log Eksekusi Pembayaran';
   ```
   * *Verifikasi:* Status Reservasi 900 otomatis berganti menjadi `Dikonfirmasi` dan data mutasi tercatat pada log aktivitas audit.
   ```sql
   SELECT STATUS_RESERVASI FROM RESERVASI WHERE ID_RESERVASI = 900;
   SELECT * FROM LOG_AKTIVITAS ORDER BY ID_LOG DESC LIMIT 1;
   ```

3. **Mengeksekusi Proses Kedatangan Tamu (Check-In)**
   ```sql
   -- Panggil stored procedure checkin aman
   CALL SP_PROSES_CHECKIN_AMAN(900, 4, 'Check-in lancar, kunci diserahkan.', @out_pesan_checkin);
   SELECT @out_pesan_checkin AS 'Log Eksekusi Check-In';
   ```
   * *Verifikasi:* Kamar nomor 104 berubah status menjadi `Terisi`, dan nama tamu muncul di Dashboard Real-time.
   ```sql
   SELECT * FROM VW_DASHBOARD_OKUPANSI_KAMAR WHERE NOMOR_KAMAR = '104';
   ```

4. **Mengeksekusi Tamu Pulang (Check-Out)**
   ```sql
   -- Catat data checkout dengan biaya tambahan denda Rp50.000 karena gelas pecah
   INSERT INTO CHECKOUT (ID_RESERVASI, ID_PEGAWAI, BIAYA_TAMBAHAN, CATATAN)
   VALUES (900, 2, 50000.00, 'Denda gelas pecah di kamar.');
   ```
   * *Verifikasi Akhir:* Status reservasi ditutup menjadi `Selesai`, dan status kamar kembali dibersihkan menjadi `Tersedia`.
   ```sql
   SELECT STATUS_RESERVASI FROM RESERVASI WHERE ID_RESERVASI = 900;
   SELECT NOMOR_KAMAR, STATUS_KAMAR FROM KAMAR WHERE ID_KAMAR = 4;
   ```

---

## 👨‍💻 Kontributor & Pengembangan

Aplikasi Arsitektur Basis Data ini dirancang untuk memenuhi standar sistem ERP perhotelan modern skala menengah ke atas. Anda dipersilakan melakukan *forking*, modifikasi skema tabel, atau integrasi langsung dengan framework backend pilihan Anda (Node.js, Laravel, Django, atau Spring Boot).
