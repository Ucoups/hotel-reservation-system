# Proposal Project Basis Data

## Judul

Sistem Reservasi Hotel Berbasis Database MySQL 8.0.

## Latar Belakang

Industri perhotelan memiliki proses operasional yang bergantung pada ketepatan pencatatan data, mulai dari pendataan tamu, pengelolaan kamar, reservasi, pembayaran, check-in, check-out, hingga pelaporan aktivitas. Jika seluruh proses tersebut dilakukan secara manual atau tidak terintegrasi, risiko kesalahan pencatatan, duplikasi data, kehilangan riwayat transaksi, dan keterlambatan laporan akan meningkat.

Basis data relasional diperlukan untuk menyimpan data hotel secara terstruktur, konsisten, dan mudah ditelusuri. Melalui penerapan primary key, foreign key, unique constraint, check constraint, view, stored procedure, function, dan trigger, sistem dapat menjaga integritas data sekaligus mendukung kebutuhan pelaporan. Project ini dirancang sebagai studi kasus akademik untuk menerapkan konsep perancangan basis data pada Sistem Reservasi Hotel menggunakan MySQL 8.0.

## Rumusan Masalah

1. Bagaimana merancang struktur database yang mampu merepresentasikan proses reservasi hotel secara lengkap?
2. Bagaimana menentukan entitas, atribut, relasi, primary key, dan foreign key yang sesuai dengan studi kasus hotel?
3. Bagaimana menjaga integritas data tamu, kamar, reservasi, pembayaran, check-in, dan check-out?
4. Bagaimana menerapkan normalisasi agar rancangan database tidak memiliki duplikasi data yang berlebihan?
5. Bagaimana menyediakan query, view, procedure, function, dan trigger untuk mendukung operasional dan pelaporan hotel?

## Tujuan Sistem

1. Merancang database Sistem Reservasi Hotel yang terstruktur dan memenuhi kaidah basis data relasional.
2. Mengimplementasikan tabel, relasi, constraint, index, dan objek database pendukung pada MySQL 8.0.
3. Menghasilkan rancangan yang mampu mengelola data tamu, pegawai, kamar, fasilitas, reservasi, pembayaran, check-in, check-out, dan log aktivitas.
4. Menyediakan data dummy realistis untuk pengujian query dan validasi sistem.
5. Menyusun dokumentasi project yang siap digunakan untuk laporan akademik, presentasi, dan publikasi repository.

## Ruang Lingkup Sistem

Ruang lingkup project meliputi:

1. Pengelolaan data master tamu.
2. Pengelolaan data master pegawai.
3. Pengelolaan tipe kamar dan kamar hotel.
4. Pengelolaan fasilitas dan relasi fasilitas pada kamar.
5. Pengelolaan transaksi reservasi dan detail reservasi.
6. Pengelolaan pembayaran reservasi.
7. Pencatatan proses check-in dan check-out.
8. Pencatatan log aktivitas sistem.
9. Penyediaan view untuk laporan detail reservasi dan pembayaran.
10. Penyediaan stored procedure, function, dan trigger sebagai implementasi lanjutan basis data.
11. Pencegahan double booking kamar berdasarkan periode tanggal reservasi.
12. Validasi agar kamar berstatus Perawatan tidak dapat dipesan.
13. Perubahan status kamar otomatis pada proses reservasi, check-in, dan check-out.

Sistem ini berfokus pada perancangan dan implementasi database, bukan pada pengembangan antarmuka aplikasi.

## Identifikasi Aktor

| Aktor | Peran | Kebutuhan Utama |
|---|---|---|
| Tamu | Pihak yang melakukan reservasi dan pembayaran kamar hotel. | Data identitas tercatat, reservasi dapat dibuat, pembayaran dapat dicatat, dan status reservasi dapat diketahui. |
| Resepsionis | Pegawai yang menangani reservasi, check-in, dan check-out. | Mengelola data reservasi, memeriksa ketersediaan kamar, serta mencatat kedatangan dan kepulangan tamu. |
| Kasir | Pegawai yang bertanggung jawab terhadap transaksi pembayaran. | Mencatat pembayaran, metode pembayaran, nominal pembayaran, dan status pembayaran. |
| Supervisor | Pegawai yang memantau operasional dan laporan hotel. | Melihat laporan reservasi, pembayaran, status kamar, dan aktivitas sistem. |

## Kebutuhan Fungsional

| No | Kebutuhan Fungsional | Deskripsi |
|---:|---|---|
| 1 | Kelola data tamu | Sistem menyimpan, memperbarui, dan menampilkan data identitas tamu. |
| 2 | Kelola data pegawai | Sistem menyimpan data pegawai yang terlibat dalam operasional hotel. |
| 3 | Kelola tipe kamar | Sistem menyimpan kategori kamar, kapasitas, dan harga per malam. |
| 4 | Kelola data kamar | Sistem menyimpan nomor kamar, lantai, tipe kamar, dan status kamar. |
| 5 | Kelola fasilitas | Sistem menyimpan daftar fasilitas hotel yang tersedia. |
| 6 | Kelola fasilitas kamar | Sistem mencatat fasilitas yang dimiliki setiap kamar. |
| 7 | Kelola reservasi | Sistem mencatat reservasi yang dilakukan tamu. |
| 8 | Kelola detail reservasi | Sistem mencatat kamar yang dipesan pada setiap reservasi. |
| 9 | Kelola pembayaran | Sistem mencatat pembayaran berdasarkan reservasi. |
| 10 | Kelola check-in | Sistem mencatat waktu aktual kedatangan tamu. |
| 11 | Kelola check-out | Sistem mencatat waktu aktual kepulangan tamu dan biaya tambahan. |
| 12 | Kelola laporan reservasi | Sistem menyediakan data laporan detail reservasi tamu. |
| 13 | Kelola laporan pembayaran | Sistem menyediakan data laporan pembayaran reservasi. |
| 14 | Kelola aktivitas sistem | Sistem mencatat aktivitas penting melalui tabel log aktivitas. |
| 15 | Validasi double booking | Sistem menolak pemesanan kamar jika periode tanggal reservasi bertabrakan dengan reservasi aktif lain. |
| 16 | Validasi kamar perawatan | Sistem menolak detail reservasi untuk kamar yang sedang berstatus Perawatan. |
| 17 | Kelola status kamar otomatis | Sistem memperbarui status kamar menjadi Dipesan, Terisi, atau Tersedia sesuai proses reservasi, check-in, dan check-out. |

## Kebutuhan Non-Fungsional

| No | Kebutuhan Non-Fungsional | Deskripsi |
|---:|---|---|
| 1 | Keamanan data | Data tamu, pegawai, dan transaksi harus terlindungi dari akses tidak sah. |
| 2 | Integritas data | Relasi antar tabel harus dijaga menggunakan primary key, foreign key, unique constraint, dan check constraint. |
| 3 | Ketersediaan sistem | Database harus dapat digunakan saat proses reservasi dan operasional hotel berlangsung. |
| 4 | Kemudahan penggunaan | Struktur tabel dan query harus mudah dipahami oleh pengguna akademik dan pengembang. |
| 5 | Skalabilitas | Rancangan database harus dapat dikembangkan untuk kebutuhan data hotel yang lebih besar. |
| 6 | Konsistensi data | Format status, metode pembayaran, dan nilai numerik harus konsisten sesuai constraint. |
| 7 | Kemudahan pelaporan | Struktur database harus mendukung pembuatan laporan reservasi, pembayaran, dan aktivitas. |

## Business Rules

1. Satu tamu dapat memiliki lebih dari satu reservasi.
2. Satu reservasi hanya dimiliki oleh satu tamu.
3. Satu reservasi ditangani oleh satu pegawai.
4. Satu pegawai dapat menangani banyak reservasi.
5. Satu tipe kamar dapat digunakan oleh banyak kamar.
6. Satu kamar hanya memiliki satu tipe kamar.
7. Nomor kamar harus unik dan tidak boleh digunakan oleh kamar lain.
8. Nomor identitas tamu harus unik.
9. Email pegawai harus unik.
10. Satu reservasi dapat memiliki satu atau lebih detail reservasi.
11. Satu detail reservasi hanya mencatat satu kamar dalam satu reservasi.
12. Tanggal check-out rencana harus lebih besar dari tanggal check-in rencana.
13. Jumlah malam menginap harus lebih dari nol.
14. Harga kamar dan subtotal tidak boleh bernilai negatif.
15. Pembayaran harus terkait dengan reservasi yang valid.
16. Jumlah pembayaran harus lebih dari nol.
17. Satu reservasi hanya memiliki satu catatan check-in.
18. Satu reservasi hanya memiliki satu catatan check-out.
19. Satu kamar dapat memiliki banyak fasilitas.
20. Satu fasilitas dapat tersedia pada banyak kamar.
21. Aktivitas penting seperti pembayaran, check-in, dan check-out dapat dicatat dalam log aktivitas.
22. Kamar tidak boleh dipesan pada periode tanggal yang bertabrakan dengan reservasi aktif lain untuk kamar yang sama.
23. Reservasi berstatus Dibatalkan tidak dihitung sebagai konflik dalam pengecekan double booking.
24. Kamar dengan status Perawatan tidak boleh dimasukkan ke detail reservasi.
25. Status kamar berubah menjadi Dipesan setelah kamar berhasil dimasukkan ke detail reservasi dan sebelumnya berstatus Tersedia.
26. Status kamar berubah menjadi Terisi ketika tamu melakukan check-in.
27. Status kamar kembali menjadi Tersedia ketika tamu melakukan check-out, kecuali kamar sedang dalam status Perawatan.

## Kesimpulan Proposal

Project Sistem Reservasi Hotel dirancang untuk menunjukkan penerapan konsep basis data relasional secara lengkap. Rancangan ini mencakup analisis kebutuhan, normalisasi, ERD, DDL, DML, query, view, procedure, function, trigger, dan dokumentasi. Dengan rancangan yang terstruktur, database diharapkan mampu menjaga integritas data dan mendukung proses operasional hotel secara sistematis.
