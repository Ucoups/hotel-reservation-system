# UNF (Unnormalized Form)

## Definisi UNF

Unnormalized Form (UNF) adalah bentuk data awal yang belum mengikuti aturan normalisasi. Pada tahap ini, data masih dapat mengandung atribut gabungan, nilai multivalue, repeating group, dan redundansi data. Bentuk UNF sering muncul dari formulir transaksi atau catatan operasional yang masih mencampur beberapa informasi dalam satu baris.

Pada studi kasus Sistem Reservasi Hotel, data awal reservasi dapat berisi data tamu, kamar, tipe kamar, fasilitas, tanggal menginap, pembayaran, dan pegawai pencatat dalam satu tabel besar. Bentuk ini belum ideal untuk database relasional karena sulit menerapkan primary key, foreign key, dan constraint secara konsisten.

## Tabel Sebelum Normalisasi

Contoh tabel UNF berikut menggambarkan data reservasi hotel sebelum proses normalisasi.

| id_reservasi | nama_tamu | no_identitas | pegawai | kamar | tipe_kamar | fasilitas | tanggal_checkin | tanggal_checkout | pembayaran |
|---|---|---|---|---|---|---|---|---|---|
| R001 | Andi Pratama | 3174010101900001 | Rina Kartika | 101, 102 | Standard, Standard | Wi-Fi, AC, TV LED | 2026-05-10 | 2026-05-12 | Transfer, Rp700.000, Lunas |
| R002 | Siti Rahmawati | 3273024502920002 | Doni Saputra | 201 | Superior | Wi-Fi, AC, TV LED, Breakfast | 2026-05-11 | 2026-05-14 | Kartu Kredit, Rp1.350.000, Lunas |
| R003 | Budi Santoso | 3578011203880003 | Fajar Nugroho | 301 | Deluxe | Wi-Fi, AC, TV LED, Mini Bar, Room Service | 2026-05-12 | 2026-05-14 | E-Wallet, Rp1.200.000, Lunas |

## Repeating Group

Repeating group terjadi karena satu kolom menyimpan lebih dari satu nilai. Contohnya:

- Kolom `kamar` berisi `101, 102`.
- Kolom `tipe_kamar` berisi lebih dari satu tipe untuk satu reservasi.
- Kolom `fasilitas` berisi beberapa fasilitas dalam satu sel.
- Kolom `pembayaran` menggabungkan metode pembayaran, nominal, dan status pembayaran.

Repeating group membuat data sulit dicari, dihitung, dan divalidasi menggunakan SQL.

## Redundansi Data

Redundansi data terjadi ketika informasi yang sama disimpan berulang. Contohnya:

- Nama dan nomor identitas tamu dapat berulang pada banyak transaksi.
- Nama tipe kamar dan fasilitas dapat ditulis berulang pada setiap reservasi.
- Informasi pembayaran dapat bercampur dengan data reservasi sehingga sulit dipisahkan.

Redundansi meningkatkan risiko inkonsistensi. Misalnya, jika nama fasilitas berubah dari `TV LED` menjadi `Smart TV`, perubahan harus dilakukan pada banyak baris.

## Permasalahan pada UNF

| Permasalahan | Dampak |
|---|---|
| Data tidak atomik | Kolom berisi banyak nilai sehingga sulit difilter dan dihitung. |
| Repeating group | Satu reservasi dapat menyimpan banyak kamar dan fasilitas dalam satu kolom. |
| Redundansi data | Data tamu, kamar, tipe kamar, dan fasilitas berulang. |
| Risiko inkonsistensi | Perubahan data master dapat tidak seragam. |
| Sulit menerapkan key | Primary key dan foreign key sulit dirancang karena data masih bercampur. |
| Sulit membuat laporan | Query laporan menjadi kompleks dan rawan kesalahan. |

## Tabel Sesudah Normalisasi

Data UNF perlu diproses ke tahap 1NF dengan memecah nilai multivalue menjadi nilai atomik. Hasil tahap berikutnya akan memisahkan informasi menjadi tabel seperti `tamu`, `pegawai`, `kamar`, `fasilitas`, `reservasi`, dan `pembayaran`.

## Kesimpulan

UNF merupakan bentuk awal data yang belum layak dijadikan struktur database final. Tahap ini penting untuk mengidentifikasi masalah utama seperti repeating group dan redundansi data sebelum dilakukan transformasi ke 1NF.
