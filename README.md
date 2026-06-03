# Hotel Reservation System

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Database Project](https://img.shields.io/badge/Database-Project-success)
![Crow's Foot ERD](https://img.shields.io/badge/ERD-Crow's%20Foot-orange)
![Academic Project](https://img.shields.io/badge/Academic-Project-purple)

## Deskripsi Project

Hotel Reservation System adalah project Basis Data dengan studi kasus Sistem Reservasi Hotel. Project ini dirancang untuk mengelola data tamu, pegawai, tipe kamar, kamar, fasilitas, reservasi, detail reservasi, pembayaran, check-in, check-out, dan log aktivitas menggunakan MySQL 8.0.

Project ini berfokus pada perancangan database relasional yang lengkap, mulai dari analisis kebutuhan, normalisasi, ERD, DDL, DML, query pengujian, view, stored procedure, function, trigger, hingga database dump.

## Latar Belakang

Hotel membutuhkan sistem pencatatan data yang terstruktur agar proses reservasi, pembayaran, check-in, check-out, dan pelaporan dapat dilakukan secara konsisten. Tanpa basis data yang baik, data tamu dan transaksi dapat mengalami duplikasi, inkonsistensi, serta sulit ditelusuri. Oleh karena itu, project ini menerapkan konsep basis data relasional untuk menghasilkan rancangan database yang rapi, valid, dan siap diuji.

## Tujuan Project

- Merancang database Sistem Reservasi Hotel berbasis MySQL 8.0.
- Menerapkan normalisasi hingga 3NF.
- Mengimplementasikan relasi antar tabel menggunakan primary key dan foreign key.
- Menjaga integritas data menggunakan unique constraint, check constraint, default value, dan index.
- Menyediakan script SQL lengkap untuk DDL, DML, query, view, procedure, trigger, function, dan dump database.
- Menyusun dokumentasi project yang siap digunakan untuk laporan akademik dan repository GitHub.

## Fitur Sistem

- Kelola data tamu, pegawai, tipe kamar, kamar hotel, dan fasilitas kamar.
- Kelola reservasi kamar beserta detail kamar yang dipesan.
- Kelola pembayaran reservasi dengan metode pembayaran yang dibatasi oleh ENUM.
- Kelola proses check-in dan check-out tamu.
- Kelola log aktivitas sistem untuk mencatat aktivitas penting.
- Pencegahan double booking kamar berdasarkan periode tanggal reservasi yang bertabrakan.
- Validasi kamar berstatus `Perawatan` agar tidak dapat dipesan.
- Perubahan status kamar otomatis dari `Tersedia`, `Dipesan`, `Terisi`, hingga kembali `Tersedia`.
- Laporan detail reservasi tamu.
- Laporan pembayaran.
- Stored procedure untuk menghitung total reservasi.
- Function untuk menghitung total biaya.
- Trigger untuk validasi reservasi, perubahan status kamar, dan pencatatan aktivitas pembayaran.

## Aturan Bisnis Utama

- Kamar yang sudah memiliki reservasi aktif pada periode tanggal tertentu tidak dapat dipesan kembali jika periode tanggalnya bertabrakan.
- Kamar dengan status `Perawatan` tidak dapat dimasukkan ke detail reservasi.
- Saat kamar dimasukkan ke detail reservasi, status kamar berubah menjadi `Dipesan` jika sebelumnya `Tersedia`.
- Saat tamu melakukan check-in, status kamar pada reservasi tersebut berubah menjadi `Terisi`.
- Saat tamu melakukan check-out, status kamar pada reservasi tersebut kembali menjadi `Tersedia` selama kamar tidak sedang `Perawatan`.
- Reservasi berstatus `Dibatalkan` tidak dihitung sebagai konflik dalam pengecekan double booking.

## Aktor Sistem

| Aktor | Deskripsi |
|---|---|
| Tamu | Melakukan reservasi, menginap, dan melakukan pembayaran. |
| Resepsionis | Mengelola reservasi, check-in, dan check-out. |
| Kasir | Mencatat pembayaran tamu. |
| Supervisor | Memantau laporan reservasi, pembayaran, status kamar, dan aktivitas sistem. |

## Daftar Tabel

| No | Nama Tabel | Deskripsi |
|---:|---|---|
| 1 | `tamu` | Menyimpan data identitas tamu. |
| 2 | `pegawai` | Menyimpan data pegawai hotel. |
| 3 | `tipe_kamar` | Menyimpan kategori kamar dan harga per malam. |
| 4 | `fasilitas` | Menyimpan data fasilitas hotel. |
| 5 | `kamar` | Menyimpan data kamar fisik hotel. |
| 6 | `reservasi` | Menyimpan transaksi reservasi. |
| 7 | `detail_reservasi` | Menyimpan rincian kamar pada reservasi. |
| 8 | `pembayaran` | Menyimpan data pembayaran reservasi. |
| 9 | `checkin` | Menyimpan data realisasi check-in. |
| 10 | `checkout` | Menyimpan data realisasi check-out. |
| 11 | `kamar_fasilitas` | Menyimpan relasi kamar dan fasilitas. |
| 12 | `log_aktivitas` | Menyimpan catatan aktivitas sistem. |

## ERD

ERD menggunakan notasi Crow's Foot dan tersedia pada folder:

- `erd/ERD_CrowFoot.mmd`
- `erd/ERD_CrowFoot.drawio`

Relasi utama:

- `tamu` ke `reservasi`: 1:M
- `pegawai` ke `reservasi`: 1:M
- `pegawai` ke `checkin`: 1:M
- `pegawai` ke `checkout`: 1:M
- `pegawai` ke `log_aktivitas`: 1:M
- `tipe_kamar` ke `kamar`: 1:M
- `reservasi` ke `detail_reservasi`: 1:M
- `kamar` ke `detail_reservasi`: 1:M
- `reservasi` ke `pembayaran`: 1:M
- `reservasi` ke `checkin`: 1:0..1
- `reservasi` ke `checkout`: 1:0..1
- `kamar` ke `fasilitas`: M:N melalui `kamar_fasilitas`

ERD utama hanya menampilkan tabel fisik dan relasi database. View dan trigger didokumentasikan terpisah pada bagian implementasi SQL karena bukan entitas utama pada ERD.

## Struktur Folder

```text
Hotel_Reservation_System/
|-- README.md
|-- .gitignore
|-- docs/
|   |-- proposal/
|   |-- laporan/
|   |-- presentasi/
|   |-- normalization/
|   `-- video_demo/
|-- erd/
|-- database/
|   |-- ddl/
|   |-- dml/
|   |-- query/
|   |-- view/
|   |-- procedure/
|   |-- trigger/
|   |-- function/
|   `-- dump/
|-- normalization/
|-- data_dictionary/
|-- sample_data/
`-- assets/
    |-- logo/
    |-- screenshot/
    `-- diagram/
```

## Teknologi yang Digunakan

- MySQL 8.0
- MySQL Workbench
- Mermaid ERD
- Draw.io
- Markdown
- CSV sample data

## Cara Instalasi

1. Pastikan MySQL Server dan MySQL Workbench sudah terpasang.
2. Clone atau salin folder project ke komputer lokal.
3. Buka MySQL Workbench.
4. Buat koneksi ke MySQL Server.
5. Jalankan script SQL sesuai urutan pada bagian berikutnya.

## Cara Menjalankan Script SQL

Jalankan file SQL secara berurutan:

```sql
SOURCE database/ddl/01_ddl.sql;
SOURCE database/dml/02_dml.sql;
SOURCE database/view/04_view.sql;
SOURCE database/procedure/05_procedure.sql;
SOURCE database/trigger/06_trigger.sql;
SOURCE database/function/07_function.sql;
SOURCE database/query/03_query.sql;
```

Jika menggunakan MySQL Workbench, buka setiap file SQL dan tekan tombol Execute sesuai urutan tersebut.

## Cara Restore Database Dump

Database dump tersedia pada:

```text
database/dump/hotel_reservation_dump.sql
```

Cara restore melalui MySQL Workbench:

1. Buka MySQL Workbench.
2. Pilih menu `Server`.
3. Pilih `Data Import`.
4. Pilih opsi import dari file dump.
5. Pilih file `hotel_reservation_dump.sql`.
6. Jalankan proses import sampai selesai.

Cara restore melalui terminal:

```bash
mysql -u root -p < database/dump/hotel_reservation_dump.sql
```

## Cara Verifikasi Hasil

Setelah seluruh script dijalankan, lakukan verifikasi berikut:

```sql
SELECT COUNT(*) FROM tamu;
SELECT COUNT(*) FROM reservasi;
SELECT * FROM vw_detail_reservasi_tamu;
CALL sp_hitung_total_reservasi(1, @total);
SELECT @total AS total_biaya_reservasi;
SELECT fn_hitung_total_biaya(350000, 2) AS total_biaya;
SELECT * FROM log_aktivitas ORDER BY waktu_aktivitas DESC;
```

## Daftar File Penting

| File | Fungsi |
|---|---|
| `database/ddl/01_ddl.sql` | Membuat database dan seluruh tabel. |
| `database/dml/02_dml.sql` | Mengisi data dummy realistis. |
| `database/query/03_query.sql` | Menguji query sederhana, join, subquery/CTE, dan agregasi. |
| `database/view/04_view.sql` | Membuat view laporan. |
| `database/procedure/05_procedure.sql` | Membuat stored procedure. |
| `database/trigger/06_trigger.sql` | Membuat trigger anti double booking, validasi kamar perawatan, perubahan status kamar, dan log pembayaran. |
| `database/function/07_function.sql` | Membuat function perhitungan biaya. |
| `database/dump/hotel_reservation_dump.sql` | File dump database. |
| `erd/ERD_CrowFoot.mmd` | ERD dalam format Mermaid. |
| `data_dictionary/Data_Dictionary.md` | Dokumentasi kamus data. |
| `docs/laporan/Laporan_Project.md` | Laporan akhir project. |

## Screenshot Sistem

Screenshot hasil implementasi dapat disimpan pada folder:

```text
assets/screenshot/
```

Jenis screenshot yang direkomendasikan:

- Reverse Engineering ERD dari MySQL Workbench.
- Hasil eksekusi query sederhana.
- Hasil query join.
- Hasil view laporan reservasi.
- Hasil procedure, function, dan trigger.

## Kontributor / Anggota Kelompok

| Nama | NIM | Peran | Tanggung Jawab |
|---|---|---|---|
| NAMA_ANGGOTA_1 | NIM_ANGGOTA_1 | Database Designer | Merancang ERD, relasi, dan normalisasi. |
| NAMA_ANGGOTA_2 | NIM_ANGGOTA_2 | SQL Developer | Menyusun DDL, DML, query, view, procedure, function, dan trigger. |
| NAMA_ANGGOTA_3 | NIM_ANGGOTA_3 | Documentation Writer | Menyusun proposal, laporan, data dictionary, dan README. |
| NAMA_ANGGOTA_4 | NIM_ANGGOTA_4 | Tester | Menguji script SQL dan validasi hasil query. |

## Lisensi

Project ini digunakan untuk keperluan akademik dan pembelajaran. Seluruh script dan dokumentasi dapat dikembangkan kembali untuk kebutuhan studi, portofolio, atau penelitian dengan tetap mencantumkan konteks penggunaan secara etis.

## Kesimpulan

Hotel Reservation System berhasil merepresentasikan proses utama reservasi hotel dalam bentuk database relasional. Database telah dirancang dengan 12 tabel, relasi primary key dan foreign key, constraint integritas data, data dummy realistis, query pengujian, view, stored procedure, function, trigger, ERD, dan dokumentasi pendukung. Project ini siap digunakan sebagai bahan laporan, presentasi, dan publikasi repository GitHub.
