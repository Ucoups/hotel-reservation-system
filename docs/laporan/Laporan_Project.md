# Laporan Project Basis Data

# Sistem Reservasi Hotel

## Identitas Project

| Komponen | Keterangan |
|---|---|
| Nama Project | Sistem Reservasi Hotel |
| Database | `hotel_reservation_db` |
| DBMS | MySQL 8.0 |
| Studi Kasus | Reservasi Hotel |
| Jenis Project | Project Akademik Basis Data |

# BAB I Pendahuluan

## 1.1 Latar Belakang

Hotel merupakan salah satu jenis usaha jasa yang memiliki proses operasional kompleks, mulai dari pendataan tamu, pengelolaan kamar, reservasi, pembayaran, check-in, check-out, hingga pelaporan aktivitas. Seluruh proses tersebut membutuhkan pencatatan yang akurat agar pelayanan kepada tamu berjalan baik dan data operasional dapat dipertanggungjawabkan.

Apabila data hotel dikelola tanpa struktur basis data yang baik, maka risiko duplikasi data, kesalahan pencatatan, inkonsistensi status kamar, kesalahan pembayaran, dan keterlambatan pelaporan akan meningkat. Oleh karena itu, diperlukan rancangan basis data relasional yang mampu mengatur data secara sistematis dan menjaga integritas antar entitas.

Project ini membahas perancangan dan implementasi database Sistem Reservasi Hotel menggunakan MySQL 8.0. Rancangan database mencakup tabel, relasi, constraint, index, data dummy, query, view, stored procedure, function, trigger, ERD, normalisasi, dan data dictionary.

## 1.2 Rumusan Masalah

1. Bagaimana merancang database yang sesuai untuk studi kasus Sistem Reservasi Hotel?
2. Bagaimana menentukan entitas, atribut, primary key, foreign key, dan relasi antar tabel?
3. Bagaimana menjaga integritas data melalui constraint dan relasi database?
4. Bagaimana menerapkan normalisasi agar data tidak mengalami duplikasi berlebihan?
5. Bagaimana menyediakan query dan objek database lanjutan untuk mendukung pelaporan?

## 1.3 Tujuan

1. Merancang database Sistem Reservasi Hotel yang terstruktur dan konsisten.
2. Mengimplementasikan database menggunakan MySQL 8.0.
3. Menerapkan primary key, foreign key, unique constraint, check constraint, default value, dan index.
4. Menyediakan data dummy realistis untuk pengujian.
5. Menyediakan query, view, stored procedure, function, dan trigger.
6. Menyusun dokumentasi project yang siap digunakan untuk laporan dan presentasi.

## 1.4 Manfaat

Project ini bermanfaat untuk memahami penerapan konsep basis data relasional secara praktis. Selain itu, project ini membantu menunjukkan proses analisis kebutuhan, perancangan ERD, normalisasi, implementasi SQL, dan pengujian query dalam satu studi kasus yang utuh.

# BAB II Analisis Kebutuhan

## 2.1 Aktor Sistem

| Aktor | Peran |
|---|---|
| Tamu | Melakukan reservasi, menginap, dan melakukan pembayaran. |
| Resepsionis | Mengelola reservasi, mencatat check-in, dan mencatat check-out. |
| Kasir | Mencatat pembayaran dan status pembayaran. |
| Supervisor | Memantau laporan reservasi, pembayaran, status kamar, dan log aktivitas. |

## 2.2 Kebutuhan Fungsional

| No | Kebutuhan | Deskripsi |
|---:|---|---|
| 1 | Kelola data tamu | Menyimpan identitas tamu hotel. |
| 2 | Kelola data pegawai | Menyimpan pegawai yang menangani operasional hotel. |
| 3 | Kelola tipe kamar | Menyimpan kategori kamar, kapasitas, dan harga. |
| 4 | Kelola kamar | Menyimpan nomor kamar, lantai, tipe, dan status kamar. |
| 5 | Kelola fasilitas | Menyimpan daftar fasilitas hotel. |
| 6 | Kelola fasilitas kamar | Mencatat fasilitas pada setiap kamar. |
| 7 | Kelola reservasi | Mencatat transaksi reservasi tamu. |
| 8 | Kelola detail reservasi | Mencatat kamar yang dipesan dalam reservasi. |
| 9 | Kelola pembayaran | Mencatat pembayaran reservasi. |
| 10 | Kelola check-in | Mencatat kedatangan aktual tamu. |
| 11 | Kelola check-out | Mencatat kepulangan aktual dan biaya tambahan. |
| 12 | Kelola laporan | Menyediakan laporan reservasi dan pembayaran. |
| 13 | Kelola log aktivitas | Mencatat aktivitas penting pada sistem. |
| 14 | Validasi double booking | Menolak pemesanan kamar jika periode tanggal reservasi bertabrakan dengan reservasi aktif lain. |
| 15 | Validasi kamar perawatan | Menolak pemesanan kamar yang sedang berstatus Perawatan. |
| 16 | Kelola status kamar otomatis | Mengubah status kamar sesuai proses reservasi, check-in, dan check-out. |

## 2.3 Kebutuhan Non-Fungsional

| No | Kebutuhan | Deskripsi |
|---:|---|---|
| 1 | Integritas data | Data dijaga menggunakan PK, FK, UNIQUE, CHECK, dan DEFAULT. |
| 2 | Konsistensi data | Nilai status dan metode pembayaran dibatasi menggunakan ENUM. |
| 3 | Ketersediaan data | Database dapat digunakan untuk operasional dan pengujian query. |
| 4 | Kemudahan pelaporan | View dan query disediakan untuk membantu penyusunan laporan. |
| 5 | Skalabilitas | Struktur tabel memungkinkan penambahan data hotel di masa mendatang. |

## 2.4 Business Rules

1. Satu tamu dapat memiliki banyak reservasi.
2. Satu reservasi hanya dimiliki oleh satu tamu.
3. Satu reservasi ditangani oleh satu pegawai.
4. Satu tipe kamar dapat digunakan oleh banyak kamar.
5. Satu kamar hanya memiliki satu tipe kamar.
6. Nomor kamar harus unik.
7. Nomor identitas tamu harus unik.
8. Satu reservasi dapat memiliki satu atau lebih detail reservasi.
9. Satu detail reservasi hanya mencatat satu kamar.
10. Tanggal check-out rencana harus lebih besar dari tanggal check-in rencana.
11. Jumlah malam harus lebih dari nol.
12. Pembayaran harus terkait dengan reservasi valid.
13. Satu reservasi hanya memiliki satu check-in.
14. Satu reservasi hanya memiliki satu check-out.
15. Satu kamar dapat memiliki banyak fasilitas.
16. Satu fasilitas dapat dimiliki banyak kamar.
17. Aktivitas penting dapat dicatat dalam log aktivitas.
18. Kamar tidak boleh dipesan pada periode tanggal yang bertabrakan dengan reservasi aktif lain untuk kamar yang sama.
19. Reservasi berstatus Dibatalkan tidak dihitung sebagai konflik dalam pengecekan double booking.
20. Kamar dengan status Perawatan tidak boleh dimasukkan ke detail reservasi.
21. Status kamar berubah menjadi Dipesan setelah kamar berhasil dimasukkan ke detail reservasi dan sebelumnya berstatus Tersedia.
22. Status kamar berubah menjadi Terisi ketika tamu melakukan check-in.
23. Status kamar kembali menjadi Tersedia ketika tamu melakukan check-out, kecuali kamar sedang dalam status Perawatan.

# BAB III Perancangan Basis Data

## 3.1 Identifikasi Entitas

Database terdiri dari 12 tabel:

| No | Entitas | Fungsi |
|---:|---|---|
| 1 | `tamu` | Menyimpan data identitas tamu. |
| 2 | `pegawai` | Menyimpan data pegawai hotel. |
| 3 | `tipe_kamar` | Menyimpan kategori kamar dan harga. |
| 4 | `fasilitas` | Menyimpan data fasilitas. |
| 5 | `kamar` | Menyimpan data kamar fisik hotel. |
| 6 | `reservasi` | Menyimpan transaksi reservasi. |
| 7 | `detail_reservasi` | Menyimpan rincian kamar dalam reservasi. |
| 8 | `pembayaran` | Menyimpan pembayaran reservasi. |
| 9 | `checkin` | Menyimpan data check-in. |
| 10 | `checkout` | Menyimpan data check-out. |
| 11 | `kamar_fasilitas` | Menyimpan relasi kamar dan fasilitas. |
| 12 | `log_aktivitas` | Menyimpan aktivitas sistem. |

## 3.2 ERD

ERD menggunakan notasi Crow's Foot dan tersedia pada file `erd/ERD_CrowFoot.mmd` serta `erd/ERD_CrowFoot.drawio`.

Relasi utama:

- `tamu` ke `reservasi`: 1:M.
- `pegawai` ke `reservasi`: 1:M.
- `pegawai` ke `checkin`: 1:M.
- `pegawai` ke `checkout`: 1:M.
- `pegawai` ke `log_aktivitas`: 1:M.
- `tipe_kamar` ke `kamar`: 1:M.
- `reservasi` ke `detail_reservasi`: 1:M.
- `kamar` ke `detail_reservasi`: 1:M.
- `reservasi` ke `pembayaran`: 1:M.
- `reservasi` ke `checkin`: 1:0..1.
- `reservasi` ke `checkout`: 1:0..1.
- `kamar` ke `fasilitas`: M:N melalui `kamar_fasilitas`.

ERD utama hanya menampilkan tabel fisik dan relasi database. View seperti `vw_detail_reservasi_tamu` dan `vw_laporan_pembayaran` serta trigger database tidak dimasukkan ke ERD utama karena bukan entitas relasional.

## 3.3 Normalisasi

Normalisasi dilakukan dari UNF sampai 3NF.

| Tahap | Hasil |
|---|---|
| UNF | Data masih memiliki repeating group, nilai multivalue, dan redundansi. |
| 1NF | Nilai dibuat atomik dan repeating group dihilangkan. |
| 2NF | Partial dependency dihilangkan dengan memisahkan data master dan transaksi. |
| 3NF | Transitive dependency dihilangkan sehingga setiap atribut non-key bergantung langsung pada primary key. |

Functional dependency utama:

```text
id_tamu -> nama_tamu, no_identitas, email
id_pegawai -> nama_pegawai, jabatan
id_tipe_kamar -> nama_tipe, kapasitas, harga_per_malam
id_kamar -> id_tipe_kamar, nomor_kamar
id_reservasi -> id_tamu, id_pegawai, tanggal_reservasi
id_pembayaran -> jumlah_bayar, metode_pembayaran
```

## 3.4 Data Dictionary

Data dictionary tersedia pada `data_dictionary/Data_Dictionary.md` dan `data_dictionary/Data_Dictionary.xlsx`. Dokumentasi tersebut memuat nama tabel, nama kolom, tipe data, panjang data, primary key, foreign key, unique key, nullable, default value, constraint, dan deskripsi.

Ringkasan database:

- Jumlah tabel: 12.
- Jumlah primary key: 12 constraint.
- Jumlah foreign key: 13 constraint.
- Jumlah unique key: 9 constraint.
- Jumlah check constraint: 8 constraint.

# BAB IV Implementasi Basis Data

## 4.1 Implementasi DDL

Implementasi DDL terdapat pada `database/ddl/01_ddl.sql`. File tersebut berisi:

- `CREATE DATABASE IF NOT EXISTS hotel_reservation_db`.
- `USE hotel_reservation_db`.
- `DROP TABLE IF EXISTS` dengan urutan child ke parent.
- `CREATE TABLE` untuk 12 tabel.
- Primary key, foreign key, unique key, check constraint, default value, dan index.
- `ENGINE=InnoDB` pada seluruh tabel.

## 4.2 Implementasi DML

Implementasi DML terdapat pada `database/dml/02_dml.sql`. Data dummy dibuat realistis dengan konteks hotel di Indonesia.

Ringkasan data:

| Tabel | Jumlah Minimal | Status |
|---|---:|---|
| `tamu` | 20 | Terpenuhi |
| `pegawai` | 10 | Terpenuhi |
| `tipe_kamar` | 5 | Terpenuhi |
| `fasilitas` | 10 | Terpenuhi |
| `kamar` | 20 | Terpenuhi |
| `reservasi` | 20 | Terpenuhi |
| `detail_reservasi` | 20 | Terpenuhi |
| `pembayaran` | 20 | Terpenuhi |
| `checkin` | 10 | Terpenuhi |
| `checkout` | 10 | Terpenuhi |
| `kamar_fasilitas` | 30 | Terpenuhi |
| `log_aktivitas` | 10 | Terpenuhi |

## 4.3 Implementasi View

View terdapat pada `database/view/04_view.sql`.

| View | Fungsi |
|---|---|
| `vw_detail_reservasi_tamu` | Menampilkan detail reservasi tamu beserta kamar dan tipe kamar. |
| `vw_laporan_pembayaran` | Menampilkan laporan pembayaran reservasi. |

## 4.4 Implementasi Stored Procedure

Stored procedure terdapat pada `database/procedure/05_procedure.sql`.

| Procedure | Fungsi |
|---|---|
| `sp_hitung_total_reservasi` | Menghitung total biaya reservasi berdasarkan subtotal pada tabel `detail_reservasi`. |

## 4.5 Implementasi Function

Function terdapat pada `database/function/07_function.sql`.

| Function | Fungsi |
|---|---|
| `fn_hitung_total_biaya` | Menghitung total biaya berdasarkan harga per malam dan jumlah malam. |

## 4.6 Implementasi Trigger

Trigger terdapat pada `database/trigger/06_trigger.sql`.

| Trigger | Fungsi |
|---|---|
| `trg_before_detail_reservasi_insert` | Mencegah double booking kamar berdasarkan overlap tanggal reservasi dan menolak kamar berstatus Perawatan. |
| `trg_after_detail_reservasi_insert` | Mengubah status kamar menjadi Dipesan setelah kamar berhasil dimasukkan ke detail reservasi. |
| `trg_after_checkin_insert` | Mengubah status kamar menjadi Terisi saat data check-in dicatat. |
| `trg_after_checkout_insert` | Mengubah status kamar kembali menjadi Tersedia saat data check-out dicatat, selama kamar tidak berstatus Perawatan. |
| `trg_after_pembayaran_insert` | Mencatat log aktivitas setelah data pembayaran baru dimasukkan. |

### 4.6.1 Skenario Perubahan Status Kamar

Implementasi trigger menggunakan nilai ENUM yang tersedia pada DDL, yaitu `Tersedia`, `Dipesan`, `Terisi`, dan `Perawatan`. Alur status kamar berjalan sebagai berikut:

1. Saat kamar masih dapat dipesan, status kamar bernilai `Tersedia`.
2. Setelah kamar berhasil dimasukkan ke `detail_reservasi`, trigger mengubah status menjadi `Dipesan`.
3. Setelah tamu melakukan check-in, trigger mengubah status kamar menjadi `Terisi`.
4. Setelah tamu melakukan check-out, trigger mengubah status kamar kembali menjadi `Tersedia`.
5. Jika kamar berstatus `Perawatan`, trigger menolak kamar tersebut untuk dimasukkan ke reservasi.

### 4.6.2 Validasi Anti Double Booking

Trigger `trg_before_detail_reservasi_insert` memeriksa periode tanggal pada tabel `reservasi` sebelum data detail reservasi disimpan. Konflik dianggap terjadi apabila tanggal check-in rencana reservasi lama lebih kecil dari tanggal check-out rencana reservasi baru, dan tanggal check-out rencana reservasi lama lebih besar dari tanggal check-in rencana reservasi baru. Dengan logika tersebut, reservasi yang saling bertabrakan ditolak, sedangkan reservasi yang dimulai setelah periode sebelumnya selesai tetap diperbolehkan. Reservasi dengan status `Dibatalkan` tidak dihitung sebagai konflik.

# BAB V Pengujian Query dan Objek Lanjutan

## 5.1 Query Sederhana

File `database/query/03_query.sql` menyediakan query sederhana untuk:

- Menampilkan seluruh data tamu.
- Menampilkan kamar yang tersedia.
- Menampilkan tipe kamar dengan harga di atas Rp500.000.

## 5.2 Query Join

Query join digunakan untuk menggabungkan data minimal tiga tabel, antara lain:

- Detail reservasi dengan data tamu dan pegawai.
- Detail kamar yang dipesan.
- Laporan pembayaran per reservasi.
- Fasilitas pada setiap kamar.

## 5.3 Query Subquery dan CTE

Query subquery digunakan untuk mencari reservasi dengan total biaya di atas rata-rata. CTE digunakan untuk menghitung ringkasan total pembayaran per reservasi.

## 5.4 Query Group By dan Having

Query `GROUP BY` dan `HAVING` digunakan untuk menghitung jumlah reservasi per tamu dan menyaring hasil berdasarkan jumlah reservasi.

## 5.5 Pengujian View, Procedure, Function, dan Trigger

Contoh pengujian:

```sql
SELECT * FROM vw_detail_reservasi_tamu;
SELECT * FROM vw_laporan_pembayaran;

CALL sp_hitung_total_reservasi(1, @total);
SELECT @total AS total_biaya_reservasi;

SELECT fn_hitung_total_biaya(350000, 2) AS total_biaya;

-- Uji log pembayaran
INSERT INTO pembayaran (id_reservasi, tanggal_pembayaran, jumlah_bayar, metode_pembayaran, status_pembayaran)
VALUES (1, CURDATE(), 100000.00, 'Transfer', 'Pending');

SELECT * FROM log_aktivitas
WHERE aktivitas = 'Pembayaran Masuk'
ORDER BY waktu_aktivitas DESC;

-- Uji perubahan status kamar
SELECT nomor_kamar, status_kamar
FROM kamar
WHERE id_kamar = 1;
```

# BAB VI Penutup

## 6.1 Kesimpulan

Project Sistem Reservasi Hotel berhasil merancang dan mengimplementasikan database relasional menggunakan MySQL 8.0. Database memiliki 12 tabel utama, relasi antar tabel, constraint integritas data, data dummy realistis, query pengujian, view, stored procedure, function, trigger, ERD, normalisasi, data dictionary, dan database dump.

Rancangan database telah memenuhi prinsip dasar Basis Data, terutama dalam hal konsistensi nama tabel dan kolom, penerapan primary key dan foreign key, normalisasi hingga 3NF, serta penyediaan objek database lanjutan untuk mendukung kebutuhan pelaporan dan audit.

## 6.2 Saran

Pengembangan selanjutnya dapat mencakup:

1. Pembuatan antarmuka aplikasi berbasis web atau desktop.
2. Penambahan fitur manajemen pengguna dan hak akses.
3. Penambahan laporan okupansi kamar dan pendapatan bulanan.
4. Integrasi sistem reservasi online.
5. Pengembangan backup dan restore database otomatis.

# Lampiran

| Lampiran | Lokasi File |
|---|---|
| DDL | `database/ddl/01_ddl.sql` |
| DML | `database/dml/02_dml.sql` |
| Query | `database/query/03_query.sql` |
| View | `database/view/04_view.sql` |
| Procedure | `database/procedure/05_procedure.sql` |
| Trigger | `database/trigger/06_trigger.sql` |
| Function | `database/function/07_function.sql` |
| ERD | `erd/ERD_CrowFoot.mmd` |
| Data Dictionary | `data_dictionary/Data_Dictionary.md` |
| Normalisasi | `normalization/` dan `docs/normalization/` |
| Database Dump | `database/dump/hotel_reservation_dump.sql` |
