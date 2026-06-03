# 1NF (First Normal Form)

## Definisi 1NF

First Normal Form (1NF) adalah tahap normalisasi yang memastikan setiap atribut berisi nilai atomik. Nilai atomik berarti satu kolom hanya boleh menyimpan satu nilai, bukan daftar nilai atau gabungan beberapa informasi.

Suatu tabel memenuhi 1NF apabila:

- Setiap kolom bernilai atomik.
- Tidak terdapat repeating group.
- Setiap baris dapat diidentifikasi dengan primary key atau candidate key.
- Data multivalue dipisahkan menjadi baris berbeda.

## Transformasi dari UNF ke 1NF

Pada bentuk UNF, kolom seperti `kamar`, `fasilitas`, dan `pembayaran` masih berisi nilai gabungan. Untuk mencapai 1NF, data tersebut dipisahkan sehingga setiap baris hanya berisi satu kamar dan satu fasilitas.

## Tabel Sebelum Normalisasi

| id_reservasi | nama_tamu | kamar | fasilitas | pembayaran |
|---|---|---|---|---|
| R001 | Andi Pratama | 101, 102 | Wi-Fi, AC, TV LED | Transfer, Rp700.000, Lunas |

Tabel tersebut belum memenuhi 1NF karena kolom `kamar`, `fasilitas`, dan `pembayaran` tidak atomik.

## Contoh Tabel Hasil 1NF

| id_reservasi | nama_tamu | no_identitas | nomor_kamar | tipe_kamar | fasilitas | tanggal_checkin | tanggal_checkout | metode_pembayaran | jumlah_bayar | status_pembayaran |
|---|---|---|---|---|---|---|---|---|---:|---|
| R001 | Andi Pratama | 3174010101900001 | 101 | Standard | Wi-Fi | 2026-05-10 | 2026-05-12 | Transfer | 700000 | Lunas |
| R001 | Andi Pratama | 3174010101900001 | 101 | Standard | AC | 2026-05-10 | 2026-05-12 | Transfer | 700000 | Lunas |
| R001 | Andi Pratama | 3174010101900001 | 101 | Standard | TV LED | 2026-05-10 | 2026-05-12 | Transfer | 700000 | Lunas |
| R001 | Andi Pratama | 3174010101900001 | 102 | Standard | Wi-Fi | 2026-05-10 | 2026-05-12 | Transfer | 700000 | Lunas |

## Penjelasan Nilai Atomik

Nilai atomik diterapkan dengan cara:

- Kolom `nomor_kamar` hanya menyimpan satu nomor kamar.
- Kolom `fasilitas` hanya menyimpan satu nama fasilitas.
- Kolom `pembayaran` dipisah menjadi `metode_pembayaran`, `jumlah_bayar`, dan `status_pembayaran`.
- Setiap baris merepresentasikan satu fakta yang lebih spesifik.

## Functional Dependency pada 1NF

Pada tahap 1NF, beberapa functional dependency mulai terlihat:

```text
id_tamu -> nama_tamu, no_identitas, email
id_pegawai -> nama_pegawai, jabatan
id_kamar -> nomor_kamar, tipe_kamar
id_reservasi -> id_tamu, tanggal_checkin, tanggal_checkout
id_pembayaran -> jumlah_bayar, metode_pembayaran, status_pembayaran
```

Namun, data tersebut masih bercampur dalam satu tabel besar sehingga masih terjadi partial dependency dan redundansi.

## Tabel Sesudah Normalisasi

Setelah 1NF, data belum langsung menjadi tabel final. Tahap ini menghasilkan data atomik yang kemudian dipisahkan lebih lanjut pada 2NF menjadi tabel seperti:

- `tamu`
- `reservasi`
- `kamar`
- `tipe_kamar`
- `fasilitas`
- `pembayaran`

## Kesimpulan

1NF berhasil menghilangkan repeating group dan memastikan nilai pada setiap kolom bersifat atomik. Namun, tabel 1NF masih memiliki duplikasi data dan partial dependency sehingga perlu dilanjutkan ke 2NF.
