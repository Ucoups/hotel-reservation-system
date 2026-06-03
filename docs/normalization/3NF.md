# 3NF (Third Normal Form)

## Definisi 3NF

Third Normal Form (3NF) adalah tahap normalisasi yang memastikan tabel sudah memenuhi 2NF dan tidak memiliki transitive dependency. Transitive dependency terjadi ketika atribut non-key bergantung pada atribut non-key lain, bukan langsung pada primary key.

## Transitive Dependency

Contoh transitive dependency pada data reservasi hotel:

```text
id_reservasi -> id_tamu -> nama_tamu, no_identitas, email
id_reservasi -> id_pegawai -> nama_pegawai, jabatan
id_kamar -> id_tipe_kamar -> nama_tipe, kapasitas, harga_per_malam
id_reservasi -> pembayaran -> jumlah_bayar, metode_pembayaran
```

Ketergantungan tersebut dihilangkan dengan menempatkan data tamu, pegawai, tipe kamar, pembayaran, check-in, dan check-out pada tabel masing-masing.

## Transformasi dari 2NF ke 3NF

Transformasi dari 2NF ke 3NF dilakukan dengan:

1. Memastikan data tamu hanya disimpan pada tabel `tamu`.
2. Memastikan data pegawai hanya disimpan pada tabel `pegawai`.
3. Memastikan informasi tipe kamar hanya disimpan pada tabel `tipe_kamar`.
4. Memisahkan data pembayaran ke tabel `pembayaran`.
5. Memisahkan data check-in ke tabel `checkin`.
6. Memisahkan data check-out ke tabel `checkout`.
7. Memisahkan aktivitas sistem ke tabel `log_aktivitas`.

## Tabel Sebelum Normalisasi

| id_reservasi | id_tamu | nama_tamu | id_kamar | id_tipe_kamar | nama_tipe | harga_per_malam | jumlah_bayar | metode_pembayaran |
|---|---|---|---|---|---|---:|---:|---|
| R001 | T001 | Andi Pratama | K001 | TK001 | Standard | 350000 | 700000 | Transfer |

Tabel tersebut masih mengandung transitive dependency karena nama tamu bergantung pada `id_tamu`, nama tipe kamar bergantung pada `id_tipe_kamar`, dan pembayaran memiliki atribut yang seharusnya disimpan pada tabel pembayaran.

## Hasil Akhir Database

| No | Nama Tabel | Fungsi |
|---:|---|---|
| 1 | `tamu` | Menyimpan data identitas tamu. |
| 2 | `pegawai` | Menyimpan data pegawai hotel. |
| 3 | `tipe_kamar` | Menyimpan kategori kamar, kapasitas, dan harga. |
| 4 | `fasilitas` | Menyimpan daftar fasilitas hotel. |
| 5 | `kamar` | Menyimpan data kamar fisik hotel. |
| 6 | `reservasi` | Menyimpan transaksi reservasi. |
| 7 | `detail_reservasi` | Menyimpan rincian kamar pada reservasi. |
| 8 | `pembayaran` | Menyimpan data pembayaran reservasi. |
| 9 | `checkin` | Menyimpan data realisasi check-in. |
| 10 | `checkout` | Menyimpan data realisasi check-out. |
| 11 | `kamar_fasilitas` | Menyimpan relasi many-to-many antara kamar dan fasilitas. |
| 12 | `log_aktivitas` | Menyimpan catatan aktivitas sistem. |

## Functional Dependency Final

```text
id_tamu -> nama_tamu, no_identitas, jenis_kelamin, no_telepon, email, alamat, created_at
id_pegawai -> nama_pegawai, jabatan, no_telepon, email, created_at
id_tipe_kamar -> nama_tipe, kapasitas, harga_per_malam, deskripsi
id_fasilitas -> nama_fasilitas, deskripsi
id_kamar -> id_tipe_kamar, nomor_kamar, lantai, status_kamar
id_reservasi -> id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi
id_detail_reservasi -> id_reservasi, id_kamar, jumlah_malam, harga_per_malam, subtotal
id_pembayaran -> id_reservasi, tanggal_pembayaran, jumlah_bayar, metode_pembayaran, status_pembayaran
id_checkin -> id_reservasi, waktu_checkin, id_pegawai, catatan
id_checkout -> id_reservasi, waktu_checkout, id_pegawai, biaya_tambahan, catatan
(id_kamar, id_fasilitas) -> relasi fasilitas pada kamar
id_log -> id_pegawai, aktivitas, waktu_aktivitas, keterangan
```

## Tabel Sesudah Normalisasi

```text
tamu(id_tamu PK, nama_tamu, no_identitas UK, jenis_kelamin, no_telepon, email UK, alamat, created_at)
pegawai(id_pegawai PK, nama_pegawai, jabatan, no_telepon, email UK, created_at)
tipe_kamar(id_tipe_kamar PK, nama_tipe UK, kapasitas, harga_per_malam, deskripsi)
fasilitas(id_fasilitas PK, nama_fasilitas UK, deskripsi)
kamar(id_kamar PK, id_tipe_kamar FK, nomor_kamar UK, lantai, status_kamar)
reservasi(id_reservasi PK, id_tamu FK, id_pegawai FK, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
detail_reservasi(id_detail_reservasi PK, id_reservasi FK, id_kamar FK, jumlah_malam, harga_per_malam, subtotal)
pembayaran(id_pembayaran PK, id_reservasi FK, tanggal_pembayaran, jumlah_bayar, metode_pembayaran, status_pembayaran)
checkin(id_checkin PK, id_reservasi FK/UK, waktu_checkin, id_pegawai FK, catatan)
checkout(id_checkout PK, id_reservasi FK/UK, waktu_checkout, id_pegawai FK, biaya_tambahan, catatan)
kamar_fasilitas(id_kamar PK/FK, id_fasilitas PK/FK)
log_aktivitas(id_log PK, id_pegawai FK, aktivitas, waktu_aktivitas, keterangan)
```

## Manfaat 3NF

- Mengurangi duplikasi data.
- Menjaga konsistensi data master dan transaksi.
- Mempermudah proses update, insert, dan delete.
- Mempermudah penerapan primary key dan foreign key.
- Memudahkan pembuatan laporan reservasi, pembayaran, dan aktivitas sistem.
- Meningkatkan kualitas rancangan database untuk kebutuhan akademik dan implementasi.

## Kesimpulan

Database Sistem Reservasi Hotel telah mencapai 3NF karena setiap atribut non-key bergantung langsung pada primary key tabelnya dan tidak terdapat transitive dependency. Struktur final database sudah sesuai dengan kebutuhan project Basis Data.
