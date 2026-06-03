# README Normalisasi

## Tujuan Normalisasi

Normalisasi dilakukan untuk memastikan rancangan database Sistem Reservasi Hotel memiliki struktur yang efisien, konsisten, dan bebas dari duplikasi data yang tidak diperlukan. Proses ini membantu menghindari anomali insert, update, dan delete serta memudahkan penerapan relasi antar tabel.

## Alur Normalisasi

```text
UNF -> 1NF -> 2NF -> 3NF
```

| Tahap | Fokus Utama | Hasil |
|---|---|---|
| UNF | Mengidentifikasi data belum normal, repeating group, dan redundansi. | Data awal reservasi hotel masih bercampur. |
| 1NF | Menghilangkan repeating group dan membuat nilai atomik. | Data dipisahkan agar setiap kolom berisi satu nilai. |
| 2NF | Menghilangkan partial dependency. | Data master dan transaksi mulai dipisahkan ke tabel berbeda. |
| 3NF | Menghilangkan transitive dependency. | Database final terdiri dari 12 tabel yang saling berelasi. |

## Functional Dependency Utama

```text
id_tamu -> nama_tamu, no_identitas, email
id_pegawai -> nama_pegawai, jabatan
id_tipe_kamar -> nama_tipe, kapasitas, harga_per_malam
id_kamar -> id_tipe_kamar, nomor_kamar
id_reservasi -> id_tamu, id_pegawai, tanggal_reservasi
id_pembayaran -> jumlah_bayar, metode_pembayaran
```

Functional dependency tersebut menjadi dasar pemisahan tabel agar setiap atribut ditempatkan pada entitas yang tepat.

## Daftar File Normalisasi

| File | Isi |
|---|---|
| `UNF.md` | Definisi UNF, contoh tabel sebelum normalisasi, repeating group, dan redundansi data. |
| `1NF.md` | Definisi 1NF, transformasi dari UNF ke 1NF, contoh tabel 1NF, dan nilai atomik. |
| `2NF.md` | Definisi 2NF, partial dependency, transformasi dari 1NF ke 2NF, dan contoh tabel hasil 2NF. |
| `3NF.md` | Definisi 3NF, transitive dependency, transformasi dari 2NF ke 3NF, dan hasil akhir database. |

## Ringkasan Hasil Akhir

Hasil akhir normalisasi menghasilkan 12 tabel:

1. `tamu`
2. `pegawai`
3. `tipe_kamar`
4. `fasilitas`
5. `kamar`
6. `reservasi`
7. `detail_reservasi`
8. `pembayaran`
9. `checkin`
10. `checkout`
11. `kamar_fasilitas`
12. `log_aktivitas`

Database telah memenuhi 3NF karena seluruh atribut non-key bergantung langsung pada primary key tabel masing-masing dan tidak terdapat ketergantungan transitif yang melanggar prinsip normalisasi.
