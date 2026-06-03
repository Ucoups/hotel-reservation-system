# README ERD

Folder ini berisi rancangan Entity Relationship Diagram untuk Sistem Reservasi Hotel.

- `ERD_CrowFoot.mmd`: ERD dalam format Mermaid dengan notasi Crow's Foot.
- `ERD_CrowFoot.png`: hasil visualisasi ERD utama dari Mermaid.
- `ERD_CrowFoot.drawio`: file diagram yang dapat dibuka dan disunting melalui draw.io.
- `ERD_Hotel_Reservation.mwb`: file model database MySQL Workbench.

## Ruang Lingkup ERD Utama

ERD utama hanya menampilkan tabel fisik, atribut penting, primary key, foreign key, unique key, dan relasi antar tabel sesuai DDL. View dan trigger tidak dimasukkan ke ERD utama karena keduanya bukan entitas/tabel fisik.

- View seperti `vw_detail_reservasi_tamu` dan `vw_laporan_pembayaran` didokumentasikan terpisah pada file SQL view dan laporan implementasi.
- Trigger seperti anti double booking, validasi kamar perawatan, perubahan status kamar, dan log pembayaran didokumentasikan terpisah pada file SQL trigger, business rules, dan laporan implementasi.

## Relasi Utama Sistem

- Satu tamu dapat membuat banyak reservasi.
- Satu pegawai dapat menangani banyak reservasi.
- Satu pegawai dapat mencatat banyak check-in.
- Satu pegawai dapat mencatat banyak check-out.
- Satu pegawai dapat memiliki banyak log aktivitas.
- Satu tipe kamar memiliki banyak kamar.
- Satu reservasi memiliki satu atau lebih detail reservasi.
- Satu kamar dapat muncul pada banyak detail reservasi.
- Satu reservasi dapat memiliki beberapa pembayaran.
- Satu reservasi dapat memiliki nol atau satu check-in karena reservasi bisa belum direalisasikan.
- Satu reservasi dapat memiliki nol atau satu check-out karena reservasi bisa belum selesai.
- Satu kamar dapat memiliki banyak fasilitas melalui tabel penghubung `kamar_fasilitas`.

## Tabel Penghubung M:N

Tabel `kamar_fasilitas` merepresentasikan relasi many-to-many antara `kamar` dan `fasilitas`. Primary key tabel ini bersifat composite, yaitu gabungan dari:

- `id_kamar`
- `id_fasilitas`

Kedua kolom tersebut sekaligus menjadi foreign key ke tabel induknya masing-masing.
