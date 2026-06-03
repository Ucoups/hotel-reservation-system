# Data Dictionary

## Ringkasan Database

Data dictionary ini disusun berdasarkan struktur final database `hotel_reservation_db` pada MySQL 8.0. Dokumen ini menjelaskan metadata setiap kolom, constraint, dan relasi pada Sistem Reservasi Hotel.

| Komponen | Jumlah |
|---|---:|
| Jumlah tabel | 12 |
| Jumlah primary key | 12 constraint |
| Jumlah foreign key | 13 constraint |
| Jumlah unique key | 9 constraint |
| Jumlah check constraint | 8 constraint |

## Kamus Data

| Entitas | Atribut| Tipe Data | Panjang Data | Primary Key | Foreign Key | Unique Key | Nullable | Default Value | Constraint | Deskripsi |
|---|---|---|---|---|---|---|---|---|---|---|
| tamu | id_tamu | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik untuk setiap tamu. |
| tamu | nama_tamu | VARCHAR | 100 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Nama lengkap tamu hotel. |
| tamu | no_identitas | VARCHAR | 30 | Tidak | Tidak | Ya | Tidak | - | NOT NULL, UNIQUE | Nomor identitas resmi tamu seperti KTP atau paspor. |
| tamu | jenis_kelamin | ENUM | Laki-laki/Perempuan | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Jenis kelamin tamu. |
| tamu | no_telepon | VARCHAR | 20 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Nomor telepon aktif tamu. |
| tamu | email | VARCHAR | 100 | Tidak | Tidak | Ya | Ya | - | UNIQUE | Email tamu yang digunakan untuk kontak dan administrasi. |
| tamu | alamat | TEXT | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Alamat tempat tinggal tamu. |
| tamu | created_at | TIMESTAMP | - | Tidak | Tidak | Tidak | Ya | CURRENT_TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Waktu pencatatan data tamu. |
| pegawai | id_pegawai | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik untuk setiap pegawai. |
| pegawai | nama_pegawai | VARCHAR | 100 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Nama lengkap pegawai hotel. |
| pegawai | jabatan | VARCHAR | 50 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Jabatan pegawai dalam operasional hotel. |
| pegawai | no_telepon | VARCHAR | 20 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Nomor telepon pegawai. |
| pegawai | email | VARCHAR | 100 | Tidak | Tidak | Ya | Tidak | - | NOT NULL, UNIQUE | Email resmi pegawai. |
| pegawai | created_at | TIMESTAMP | - | Tidak | Tidak | Tidak | Ya | CURRENT_TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Waktu pencatatan data pegawai. |
| tipe_kamar | id_tipe_kamar | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik tipe kamar. |
| tipe_kamar | nama_tipe | VARCHAR | 50 | Tidak | Tidak | Ya | Tidak | - | NOT NULL, UNIQUE | Nama tipe kamar seperti Standard, Superior, Deluxe, Family, atau Suite. |
| tipe_kamar | kapasitas | INT | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (kapasitas > 0) | Kapasitas maksimal tamu untuk tipe kamar. |
| tipe_kamar | harga_per_malam | DECIMAL | 12,2 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (harga_per_malam >= 0) | Harga dasar kamar per malam. |
| tipe_kamar | deskripsi | TEXT | - | Tidak | Tidak | Tidak | Ya | - | - | Deskripsi tambahan mengenai tipe kamar. |
| fasilitas | id_fasilitas | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik fasilitas. |
| fasilitas | nama_fasilitas | VARCHAR | 80 | Tidak | Tidak | Ya | Tidak | - | NOT NULL, UNIQUE | Nama fasilitas hotel. |
| fasilitas | deskripsi | TEXT | - | Tidak | Tidak | Tidak | Ya | - | - | Deskripsi fasilitas. |
| kamar | id_kamar | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik kamar. |
| kamar | id_tipe_kamar | INT | - | Tidak | Ya | Tidak | Tidak | - | NOT NULL, FK ke tipe_kamar, ON UPDATE CASCADE, ON DELETE RESTRICT | Referensi tipe kamar. |
| kamar | nomor_kamar | VARCHAR | 10 | Tidak | Tidak | Ya | Tidak | - | NOT NULL, UNIQUE | Nomor kamar hotel. |
| kamar | lantai | VARCHAR | 10 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Lantai tempat kamar berada. |
| kamar | status_kamar | ENUM | Tersedia/Dipesan/Terisi/Perawatan | Tidak | Tidak | Tidak | Tidak | Tersedia | NOT NULL, DEFAULT 'Tersedia' | Status operasional kamar. |
| reservasi | id_reservasi | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik reservasi. |
| reservasi | id_tamu | INT | - | Tidak | Ya | Tidak | Tidak | - | NOT NULL, FK ke tamu, ON UPDATE CASCADE, ON DELETE RESTRICT | Tamu yang melakukan reservasi. |
| reservasi | id_pegawai | INT | - | Tidak | Ya | Tidak | Tidak | - | NOT NULL, FK ke pegawai, ON UPDATE CASCADE, ON DELETE RESTRICT | Pegawai yang menangani reservasi. |
| reservasi | tanggal_reservasi | DATE | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Tanggal reservasi dibuat. |
| reservasi | tanggal_checkin_rencana | DATE | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Tanggal rencana check-in. |
| reservasi | tanggal_checkout_rencana | DATE | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (tanggal_checkout_rencana > tanggal_checkin_rencana) | Tanggal rencana check-out. |
| reservasi | status_reservasi | ENUM | Menunggu/Dikonfirmasi/Check-in/Selesai/Dibatalkan | Tidak | Tidak | Tidak | Tidak | Menunggu | NOT NULL, DEFAULT 'Menunggu' | Status reservasi. |
| detail_reservasi | id_detail_reservasi | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik detail reservasi. |
| detail_reservasi | id_reservasi | INT | - | Tidak | Ya | Ya | Tidak | - | NOT NULL, FK ke reservasi, UNIQUE (id_reservasi, id_kamar), ON UPDATE CASCADE, ON DELETE CASCADE | Reservasi yang memiliki detail kamar. |
| detail_reservasi | id_kamar | INT | - | Tidak | Ya | Ya | Tidak | - | NOT NULL, FK ke kamar, UNIQUE (id_reservasi, id_kamar), ON UPDATE CASCADE, ON DELETE RESTRICT | Kamar yang dipesan dalam reservasi. |
| detail_reservasi | jumlah_malam | INT | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (jumlah_malam > 0) | Lama menginap dalam satuan malam. |
| detail_reservasi | harga_per_malam | DECIMAL | 12,2 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (harga_per_malam >= 0) | Harga kamar saat reservasi dibuat. |
| detail_reservasi | subtotal | DECIMAL | 12,2 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (subtotal >= 0) | Total biaya kamar pada detail reservasi. |
| pembayaran | id_pembayaran | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik pembayaran. |
| pembayaran | id_reservasi | INT | - | Tidak | Ya | Tidak | Tidak | - | NOT NULL, FK ke reservasi, ON UPDATE CASCADE, ON DELETE CASCADE | Reservasi yang dibayar. |
| pembayaran | tanggal_pembayaran | DATE | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Tanggal pembayaran dicatat. |
| pembayaran | jumlah_bayar | DECIMAL | 12,2 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL, CHECK (jumlah_bayar > 0) | Nominal pembayaran. |
| pembayaran | metode_pembayaran | ENUM | Tunai/Transfer/Kartu Kredit/E-Wallet | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Metode pembayaran. |
| pembayaran | status_pembayaran | ENUM | Pending/Lunas/Gagal/Refund | Tidak | Tidak | Tidak | Tidak | Pending | NOT NULL, DEFAULT 'Pending' | Status pembayaran. |
| checkin | id_checkin | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik check-in. |
| checkin | id_reservasi | INT | - | Tidak | Ya | Ya | Tidak | - | NOT NULL, UNIQUE, FK ke reservasi, ON UPDATE CASCADE, ON DELETE CASCADE | Reservasi yang melakukan check-in. |
| checkin | waktu_checkin | DATETIME | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Waktu aktual check-in. |
| checkin | id_pegawai | INT | - | Tidak | Ya | Tidak | Tidak | - | NOT NULL, FK ke pegawai, ON UPDATE CASCADE, ON DELETE RESTRICT | Pegawai yang mencatat check-in. |
| checkin | catatan | TEXT | - | Tidak | Tidak | Tidak | Ya | - | - | Catatan saat check-in. |
| checkout | id_checkout | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik check-out. |
| checkout | id_reservasi | INT | - | Tidak | Ya | Ya | Tidak | - | NOT NULL, UNIQUE, FK ke reservasi, ON UPDATE CASCADE, ON DELETE CASCADE | Reservasi yang melakukan check-out. |
| checkout | waktu_checkout | DATETIME | - | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Waktu aktual check-out. |
| checkout | id_pegawai | INT | - | Tidak | Ya | Tidak | Tidak | - | NOT NULL, FK ke pegawai, ON UPDATE CASCADE, ON DELETE RESTRICT | Pegawai yang mencatat check-out. |
| checkout | biaya_tambahan | DECIMAL | 12,2 | Tidak | Tidak | Tidak | Tidak | 0 | NOT NULL, DEFAULT 0, CHECK (biaya_tambahan >= 0) | Biaya tambahan saat check-out. |
| checkout | catatan | TEXT | - | Tidak | Tidak | Tidak | Ya | - | - | Catatan saat check-out. |
| kamar_fasilitas | id_kamar | INT | - | Ya | Ya | Tidak | Tidak | - | PRIMARY KEY (id_kamar, id_fasilitas), FK ke kamar, ON UPDATE CASCADE, ON DELETE CASCADE | Kamar yang memiliki fasilitas. |
| kamar_fasilitas | id_fasilitas | INT | - | Ya | Ya | Tidak | Tidak | - | PRIMARY KEY (id_kamar, id_fasilitas), FK ke fasilitas, ON UPDATE CASCADE, ON DELETE CASCADE | Fasilitas yang tersedia pada kamar. |
| log_aktivitas | id_log | INT | - | Ya | Tidak | Tidak | Tidak | AUTO_INCREMENT | PRIMARY KEY, AUTO_INCREMENT | Identitas unik log aktivitas. |
| log_aktivitas | id_pegawai | INT | - | Tidak | Ya | Tidak | Ya | - | FK ke pegawai, ON UPDATE CASCADE, ON DELETE SET NULL | Pegawai yang terkait dengan aktivitas. |
| log_aktivitas | aktivitas | VARCHAR | 100 | Tidak | Tidak | Tidak | Tidak | - | NOT NULL | Nama aktivitas sistem. |
| log_aktivitas | waktu_aktivitas | DATETIME | - | Tidak | Tidak | Tidak | Tidak | CURRENT_TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Waktu aktivitas dicatat. |
| log_aktivitas | keterangan | TEXT | - | Tidak | Tidak | Tidak | Ya | - | - | Keterangan detail aktivitas. |

## Relasi Antar Tabel

| Relasi | Kardinalitas | Penjelasan |
|---|---|---|
| `tamu` -> `reservasi` | 1:M | Satu tamu dapat memiliki banyak reservasi, sedangkan satu reservasi hanya dimiliki satu tamu. |
| `pegawai` -> `reservasi` | 1:M | Satu pegawai dapat menangani banyak reservasi. |
| `tipe_kamar` -> `kamar` | 1:M | Satu tipe kamar dapat digunakan oleh banyak kamar. |
| `reservasi` -> `detail_reservasi` | 1:M | Satu reservasi dapat memiliki satu atau lebih detail kamar. |
| `kamar` -> `detail_reservasi` | 1:M | Satu kamar dapat muncul dalam banyak detail reservasi berbeda. |
| `reservasi` -> `pembayaran` | 1:M | Satu reservasi dapat memiliki satu atau lebih pembayaran. |
| `reservasi` -> `checkin` | 1:1 | Satu reservasi hanya dapat memiliki satu catatan check-in. |
| `reservasi` -> `checkout` | 1:1 | Satu reservasi hanya dapat memiliki satu catatan check-out. |
| `pegawai` -> `checkin` | 1:M | Satu pegawai dapat mencatat banyak proses check-in. |
| `pegawai` -> `checkout` | 1:M | Satu pegawai dapat mencatat banyak proses check-out. |
| `kamar` <-> `fasilitas` | M:N | Banyak kamar dapat memiliki banyak fasilitas melalui tabel `kamar_fasilitas`. |
| `pegawai` -> `log_aktivitas` | 1:M | Satu pegawai dapat memiliki banyak catatan aktivitas. |

## Catatan Status Kamar

Kolom `status_kamar` pada tabel `kamar` menggunakan ENUM sesuai DDL, yaitu `Tersedia`, `Dipesan`, `Terisi`, dan `Perawatan`.

| Nilai Status | Makna Operasional |
|---|---|
| `Tersedia` | Kamar dapat dipesan dan belum terikat reservasi aktif pada periode tertentu. |
| `Dipesan` | Kamar sudah masuk ke detail reservasi dan menunggu proses check-in. |
| `Terisi` | Kamar sedang digunakan oleh tamu yang sudah melakukan check-in. |
| `Perawatan` | Kamar sedang tidak dapat digunakan karena maintenance dan tidak boleh dipesan. |

## Keterangan Constraint Penting

- `CHECK (tanggal_checkout_rencana > tanggal_checkin_rencana)` memastikan periode reservasi valid.
- `CHECK (kapasitas > 0)` memastikan kapasitas tipe kamar bernilai positif.
- `CHECK (harga_per_malam >= 0)` memastikan harga kamar tidak negatif.
- `CHECK (jumlah_malam > 0)` memastikan lama menginap minimal satu malam.
- `CHECK (subtotal >= 0)` memastikan subtotal tidak negatif.
- `CHECK (jumlah_bayar > 0)` memastikan pembayaran bernilai positif.
- `CHECK (biaya_tambahan >= 0)` memastikan biaya tambahan tidak negatif.
- Unique key pada `no_identitas`, `email`, `nomor_kamar`, dan beberapa relasi menjaga data tidak ganda.
