# 2NF (Second Normal Form)

## Definisi 2NF

Second Normal Form (2NF) adalah tahap normalisasi yang memastikan tabel sudah memenuhi 1NF dan seluruh atribut non-key bergantung penuh pada primary key. 2NF berfokus pada penghapusan partial dependency.

Partial dependency terjadi ketika atribut non-key hanya bergantung pada sebagian dari composite key, bukan pada keseluruhan key.

## Partial Dependency

Pada bentuk 1NF, satu baris dapat diidentifikasi oleh kombinasi data seperti `id_reservasi`, `id_kamar`, dan `id_fasilitas`. Masalah muncul karena beberapa atribut hanya bergantung pada sebagian dari kombinasi tersebut.

Contoh partial dependency:

```text
id_tamu -> nama_tamu, no_identitas, email
id_pegawai -> nama_pegawai, jabatan
id_tipe_kamar -> nama_tipe, kapasitas, harga_per_malam
id_kamar -> id_tipe_kamar, nomor_kamar
id_fasilitas -> nama_fasilitas, deskripsi
id_reservasi -> id_tamu, id_pegawai, tanggal_reservasi
id_pembayaran -> jumlah_bayar, metode_pembayaran
```

Ketergantungan tersebut harus dipisahkan agar setiap tabel hanya menyimpan atribut yang benar-benar bergantung pada primary key tabelnya.

## Transformasi dari 1NF ke 2NF

Transformasi dilakukan dengan memecah tabel besar hasil 1NF menjadi beberapa tabel berdasarkan kelompok ketergantungan data.

## Tabel Sebelum Normalisasi

| id_reservasi | id_tamu | nama_tamu | id_kamar | nomor_kamar | id_tipe_kamar | nama_tipe | id_fasilitas | nama_fasilitas | jumlah_bayar |
|---|---|---|---|---|---|---|---|---|---:|
| R001 | T001 | Andi Pratama | K001 | 101 | TK001 | Standard | F001 | Wi-Fi | 700000 |
| R001 | T001 | Andi Pratama | K001 | 101 | TK001 | Standard | F002 | AC | 700000 |

Masalah utama tabel tersebut adalah data tamu, kamar, tipe kamar, fasilitas, dan pembayaran berulang pada banyak baris.

## Contoh Tabel Hasil 2NF

### Tabel `tamu`

| id_tamu | nama_tamu | no_identitas | email |
|---|---|---|---|
| T001 | Andi Pratama | 3174010101900001 | andi.pratama@example.com |

### Tabel `tipe_kamar`

| id_tipe_kamar | nama_tipe | kapasitas | harga_per_malam |
|---|---|---:|---:|
| TK001 | Standard | 2 | 350000 |

### Tabel `kamar`

| id_kamar | id_tipe_kamar | nomor_kamar | status_kamar |
|---|---|---|---|
| K001 | TK001 | 101 | Tersedia |

### Tabel `fasilitas`

| id_fasilitas | nama_fasilitas | deskripsi |
|---|---|---|
| F001 | Wi-Fi | Akses internet nirkabel |
| F002 | AC | Pendingin ruangan |

### Tabel `reservasi`

| id_reservasi | id_tamu | id_pegawai | tanggal_reservasi | tanggal_checkin_rencana | tanggal_checkout_rencana |
|---|---|---|---|---|---|
| R001 | T001 | P001 | 2026-05-01 | 2026-05-10 | 2026-05-12 |

### Tabel `detail_reservasi`

| id_detail_reservasi | id_reservasi | id_kamar | jumlah_malam | subtotal |
|---|---|---|---:|---:|
| DR001 | R001 | K001 | 2 | 700000 |

### Tabel `kamar_fasilitas`

| id_kamar | id_fasilitas |
|---|---|
| K001 | F001 |
| K001 | F002 |

## Functional Dependency Setelah 2NF

```text
id_tamu -> nama_tamu, no_identitas, jenis_kelamin, no_telepon, email, alamat
id_pegawai -> nama_pegawai, jabatan, no_telepon, email
id_tipe_kamar -> nama_tipe, kapasitas, harga_per_malam, deskripsi
id_kamar -> id_tipe_kamar, nomor_kamar, lantai, status_kamar
id_fasilitas -> nama_fasilitas, deskripsi
id_reservasi -> id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi
id_detail_reservasi -> id_reservasi, id_kamar, jumlah_malam, harga_per_malam, subtotal
```

## Tabel Sesudah Normalisasi

Pada tahap 2NF, data dipisahkan menjadi tabel:

- `tamu`
- `pegawai`
- `tipe_kamar`
- `kamar`
- `fasilitas`
- `reservasi`
- `detail_reservasi`
- `kamar_fasilitas`

## Kesimpulan

2NF menghilangkan partial dependency dengan memisahkan atribut ke tabel yang sesuai. Hasilnya, data lebih konsisten, duplikasi berkurang, dan struktur database lebih siap untuk disempurnakan ke 3NF.
