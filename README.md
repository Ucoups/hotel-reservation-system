# 🏨 Sistem Basis Data Reservasi Hotel

> **Project Akhir — Mata Kuliah Basis Data (Kelas B)**  
> Program Studi S1 Statistika · FMIPA · Universitas Jenderal Soedirman · 2026

---

## 📋 Deskripsi Project

Sistem Basis Data Relasional untuk manajemen **reservasi hotel** yang dirancang dan diimplementasikan menggunakan **MySQL 8.0**. Sistem ini mencakup seluruh siklus operasional hotel mulai dari pemesanan kamar, check-in, check-out, pembayaran, hingga audit trail aktivitas pegawai.

Sistem dibangun dengan memenuhi standar normalisasi **3NF**, dilengkapi trigger anti-double booking, stored procedure berprinsip ACID, dan berbagai query analitik untuk kebutuhan manajemen hotel.

---


## 👥 Anggota Tim — Kelompok G

| No | Nama | NIM | Kontribusi Utama |
|----|------|-----|-----------------|
| 1  | [Nasywa Putri Maitsa] | [K1D024043] | PPT, View dan Function |
| 2  | [Nayla Edenine Qohar] | [K1D024044] | DDL, DML, Data Dummy, Laporan |
| 3  | [Abdurrahman Yusuf] | [K1D024058] | ERD, Query dan Logical Design |
| 4  | [Bertha Misella Silalahi] | [K1D024068] | Trigger,Procedure, Video Demo|

---
## Latar Belakang
Industri perhotelan merupakan salah satu sektor jasa yang terus berkembang seiring meningkatnya mobilitas masyarakat dan kebutuhan akomodasi. Dalam operasional hotel, pengelolaan data reservasi kamar, data tamu, pembayaran, check-in, check-out, serta penggunaan fasilitas menjadi aspek yang sangat penting untuk menjamin pelayanan yang efektif dan efisien.

Pengelolaan data secara manual berpotensi menimbulkan berbagai permasalahan, seperti kesalahan pencatatan reservasi, duplikasi data tamu, kesulitan dalam memantau ketersediaan kamar, hingga keterlambatan dalam penyusunan laporan operasional hotel. Oleh karena itu, diperlukan suatu sistem basis data yang mampu mengintegrasikan seluruh data operasional hotel secara terstruktur dan konsisten.

Sistem Reservasi Hotel merupakan solusi yang dapat digunakan untuk mengelola informasi kamar, tamu, reservasi, pembayaran, penggunaan fasilitas, serta proses check-in dan check-out secara terpusat. Dengan penerapan basis data relasional, data dapat disimpan secara terorganisasi, meminimalkan redundansi, menjaga integritas data, serta memudahkan proses pengolahan informasi.

Berdasarkan permasalahan tersebut, dilakukan perancangan dan implementasi Sistem Basis Data Reservasi Hotel sebagai penerapan konsep basis data relasional yang telah dipelajari selama perkuliahan.

## Rumusan Masalah
1.	Bagaimana merancang sistem basis data yang mampu mengelola proses reservasi hotel secara terintegrasi?
2.	Bagaimana membangun model data yang sesuai dengan kebutuhan operasional hotel?
3.	Bagaimana menerapkan normalisasi hingga bentuk normal ketiga (3NF)?
4.	Bagaimana mengimplementasikan basis data menggunakan DBMS relasional?
5.	Bagaimana membuat query, view, function, procedure, dan trigger untuk mendukung operasional hotel?

## Tujuan
1.	Merancang sistem basis data reservasi hotel yang terstruktur dan terintegrasi.
2.	Membuat Entity Relationship Diagram (ERD) dan skema relasional.
3.	Menerapkan proses normalisasi hingga Third Normal Form (3NF).
4.	Mengimplementasikan basis data menggunakan SQL.
5.	Membuat query dan objek basis data lanjutan untuk mendukung pengelolaan hotel.

## 🗂️ Struktur Repository

```
hotel-reservation-db/
│
├── 📄 README.md                          ← Dokumentasi utama (file ini)
│
├── 📁 sql/
│   ├── 01_ddl.sql                        ← CREATE TABLE, constraint, index, trigger dasar
│   ├── 02_dml.sql                        ← INSERT data dummy (12 tabel, 300+ baris)
│   ├── 03_query.sql                      ← 10 query SELECT (sederhana → kompleks)
│   ├── 04_view.sql                       ← 5 VIEW (dashboard, billing, KPI staf)
│   ├── 05_procedure.sql                  ← 3 STORED PROCEDURE (invoice, bayar, batal)
│   ├── 06_trigger.sql                    ← 5 TRIGGER (anti-double booking, audit trail)
│   └── 07_function.sql                   ← 3 FUNCTION (durasi, tagihan, status bayar)
│
├── 📁 docs/
│   ├── Laporan_Reservasi_Hotel_Lengkap.pdf   ← Laporan lengkap BAB I–VI
│   └── ERD_Reservasi_Hotel.png               ← Diagram ERD (Crow's Foot)
│
├── 📁 dump/
│   └── hotel_reservation_db_dump.sql     ← Full database backup (langsung restore)
│
└── 📁 slides/
    └── Presentasi_Kelompok_G.pptx        ← Slide presentasi (maks. 15 slide)
```

---
## Identifikasi Aktor & Peran
Basis data ini membagi hak akses dan tanggung jawab berdasarkan tabel relasional pegawai ke dalam beberapa peran berikut:

| Peran Aktor | Hak Akses Tabel Utama | Deskripsi Peran Operasional |
|---|---|---|
| **Tamu** | `tamu`, `reservasi` | Melakukan registrasi identitas diri, memilih tipe kamar, melakukan pembayaran deposit/lunas, dan menginap. |
| **Resepsionis** | `reservasi`, `checkin`, `checkout`, `kamar` | Mengelola pemetaan kamar kosong, memverifikasi data check-in tamu datang, memproses kepulangan check-out, dan memperbarui status kamar fisik. |
| **Kasir** | `pembayaran` | Mencatat transaksi pembayaran dari tamu, memilih metode pembayaran, memvalidasi sisa tagihan, dan mengeluarkan invoice. |
| **Supervisor / Manajer** | `log_aktivitas`, seluruh `Views` | Memantau kinerja operasional hotel melalui laporan audit trail, okupansi kamar harian, laporan bulanan keuangan, dan performa produktivitas staf. |

## 🗄️ Skema Database

### Entitas Utama (12 Tabel)

```
tamu ──────────────┐
                   ├──> reservasi ──> detail_reservasi ──> kamar ──> tipe_kamar
pegawai ───────────┘         │                                  └──> kamar_fasilitas ──> fasilitas
                             ├──> pembayaran
                             ├──> checkin
                             └──> checkout
                             
log_aktivitas ──> pegawai
```

| Tabel | Deskripsi | Baris Data |
|-------|-----------|------------|
| `tamu` | Data tamu hotel | 20 |
| `pegawai` | Data staf front-office | 10 |
| `tipe_kamar` | Kategori kamar (Standard–Suite) | 5 |
| `fasilitas` | Fasilitas yang tersedia | 10 |
| `kamar` | Unit kamar individual (lantai 1–5) | 25 |
| `reservasi` | Header transaksi menginap | 22 |
| `detail_reservasi` | Kamar yang dipesan per reservasi | 26 |
| `pembayaran` | Transaksi pembayaran | 23 |
| `checkin` | Catatan check-in aktual | 12 |
| `checkout` | Catatan check-out aktual | 10 |
| `kamar_fasilitas` | Relasi many-to-many kamar–fasilitas | 127 |
| `log_aktivitas` | Audit trail aktivitas pegawai | 12 |

## Business Rules
1.	Setiap tamu harus terdaftar dalam sistem sebelum melakukan reservasi.
2.	Nomor identitas dan email tamu harus bersifat unik.
3.	Setiap reservasi harus terkait dengan satu tamu.
4.	Setiap reservasi harus dicatat atau ditangani oleh seorang pegawai.
5.	Tanggal check-out harus lebih besar dari tanggal check-in.
6.	Satu reservasi dapat mencakup satu atau lebih kamar.
7.	Satu kamar hanya boleh digunakan oleh satu reservasi pada periode yang sama.
8.	Setiap kamar harus memiliki satu tipe kamar.
9.	Nomor kamar harus unik.
10.	Status kamar harus selalu diperbarui sesuai kondisi terkini.
11.	Subtotal detail reservasi dihitung dari harga per malam dikalikan jumlah malam menginap. 
12.	Reservasi dapat memiliki satu atau lebih transaksi pembayaran.
13.	Jumlah pembayaran yang diterima tidak boleh bernilai negatif.
14.	Status pembayaran harus menunjukkan kondisi pembayaran yang sebenarnya.
15.	Check-in hanya dapat dilakukan untuk reservasi yang valid dan aktif.
16.	Setiap reservasi hanya dapat memiliki satu data check-in.
17.	Check-out hanya dapat dilakukan setelah proses check-in tercatat.
18.	Setiap reservasi hanya dapat memiliki satu data check-out.
19.	Data check-in dan check-out harus dicatat oleh pegawai yang bertugas.
20.	Biaya tambahan saat check-out tidak boleh bernilai negatif.
21.	Satu kamar dapat memiliki banyak fasilitas dan satu fasilitas dapat tersedia pada banyak kamar.
22.	Nama fasilitas harus unik.
23.	Setiap aktivitas penting yang dilakukan pegawai harus dicatat dalam log aktivitas.
24.	Email pegawai harus unik.
25.	Data yang sudah digunakan dalam transaksi reservasi tidak boleh dihapus secara langsung. 


## Relasi dan Kardinalitas
1.	tamu → reservasi : 1 : N (Satu tamu dapat melakukan banyak reservasi, sedangkan satu reservasi hanya dimiliki oleh satu tamu)
2.	pegawai → reservasi : 1 : N (Satu pegawai dapat menangani banyak reservasi, sedangkan satu reservasi hanya ditangani oleh satu pegawai)
3.	tipe_kamar → kamar : 1 : N (Satu tipe kamar dapat dimiliki oleh banyak kamar, sedangkan satu kamar hanya memiliki satu tipe kamar)
4.	reservasi → detail_reservasi : 1 : N (Satu reservasi dapat memiliki beberapa detail reservasi, sedangkan satu detail reservasi hanya terkait dengan satu reservasi)
5.	kamar → detail_reservasi : 1 : N (Satu kamar dapat muncul pada banyak detail reservasi dalam waktu yang berbeda, sedangkan satu detail reservasi hanya merujuk pada satu kamar)
6.	reservasi → pembayaran : 1 : N (Satu reservasi dapat memiliki beberapa transaksi pembayaran, sedangkan satu pembayaran hanya terkait dengan satu reservasi)
7.	reservasi → checkin : 1 : 1 (Satu reservasi hanya memiliki satu data check-in dan satu data check-in hanya terkait dengan satu reservasi)
8.	reservasi → checkout : 1 : 1 (Satu reservasi hanya memiliki satu data check-out dan satu data check-out hanya terkait dengan satu reservasi)
9.	pegawai → checkin : 1 : N (Satu pegawai dapat mencatat banyak proses check-in, sedangkan satu data check-in hanya dicatat oleh satu pegawai yang bertugas)
10.	pegawai → checkout : 1 : N (Satu pegawai dapat mencatat banyak proses check-out, sedangkan satu data check-out hanya dicatat oleh satu pegawai yang bertugas)
11.	pegawai → log aktivitas : 1 : N (Satu pegawai dapat menghasilkan banyak catatan aktivitas, sedangkan satu log aktivitas hanya dimiliki oleh satu pegawai)
12.	kamar → kamar fasilitas : 1 : N melalui tabel kamar_fasilitas (Satu kamar dapat memiliki banyak data pada tabel KAMAR_FASILITAS, sedangkan satu data KAMAR_FASILITAS hanya terkait dengan satu kamar)
13.	fasilitas → kamar fasilitas : 1 : N (Satu fasilitas dapat digunakan oleh banyak kamar, sedangkan satu data KAMAR_FASILITAS hanya terkait dengan satu fasilitas)

Relasi antara entitas KAMAR dan FASILITAS sebenarnya merupakan relasi Many-to-Many (M:N). Untuk mengimplementasikan relasi tersebut pada basis data relasional, digunakan entitas asosiasi KAMAR_FASILITAS yang memecah hubungan M:N menjadi dua relasi 1:N, yaitu KAMAR–KAMAR_FASILITAS dan FASILITAS–KAMAR_FASILITAS


---

## ⚙️ Cara Menjalankan

### Prasyarat

- **MySQL 8.0+** (atau MariaDB 10.6+)
- MySQL client: [MySQL Workbench](https://www.mysql.com/products/workbench/), [DBeaver](https://dbeaver.io/), atau CLI

### Opsi A — Restore dari Database Dump (Direkomendasikan)

Cara paling cepat, langsung mendapatkan database lengkap dengan data:

```bash
# Via MySQL CLI
mysql -u root -p < dump/hotel_reservation_db_dump.sql

# Verifikasi
mysql -u root -p -e "USE hotel_reservation_db; SHOW TABLES;"
```

### Opsi B — Jalankan Script Bertahap

Jalankan file SQL **sesuai urutan nomor**:

```bash
# 1. Buat struktur database
mysql -u root -p < sql/01_ddl.sql

# 2. Isi data dummy
mysql -u root -p < sql/02_dml.sql

# 3. Jalankan query pengujian
mysql -u root -p hotel_reservation_db < sql/03_query.sql

# 4. Buat View
mysql -u root -p hotel_reservation_db < sql/04_view.sql

# 5. Buat Stored Procedure
mysql -u root -p hotel_reservation_db < sql/05_procedure.sql

# 6. Buat Trigger
mysql -u root -p hotel_reservation_db < sql/06_trigger.sql

# 7. Buat Function
mysql -u root -p hotel_reservation_db < sql/07_function.sql
```

### Opsi C — Via MySQL Workbench / DBeaver

1. Buka aplikasi dan sambungkan ke server MySQL lokal
2. Buka setiap file `.sql` dari folder `sql/`
3. Eksekusi sesuai urutan **01 → 02 → 03 → 04 → 05 → 06 → 07**

> ⚠️ **Catatan:** Jalankan `01_ddl.sql` **sebelum** file lainnya. File ini akan membuat database `hotel_reservation_db` secara otomatis.

---

## 🔍 Fitur Utama Sistem

### Query & Analitik (03_query.sql)

| # | Query | Tujuan |
|---|-------|--------|
| Q1 | Kamar Tersedia Real-time | Pemantauan status kamar harian |
| Q2 | Manifest Check-in Lengkap | Daftar tamu beserta kamar dan jadwal |
| Q3 | Pemetaan Fasilitas per Kamar | Info fasilitas untuk tamu |
| Q4 | Invoice Grand Total | Total tagihan per reservasi (6 tabel JOIN) |
| Q5 | Analisis Kamar Terlaris | Tingkat okupansi per tipe kamar |
| Q6 | Tren Pendapatan Bulanan | Laporan omset dengan CTE |
| Q7 | Deteksi Tamu Loyal | Kandidat program loyalitas (HAVING) |

### View (04_view.sql)

| View | Digunakan Oleh |
|------|---------------|
| `vw_detail_reservasi_tamu` | Resepsionis — dashboard reservasi |
| `vw_laporan_pembayaran` | Kasir — riwayat transaksi |
| `vw_billing_reservasi_summary` | Kasir — monitoring piutang & sisa tagihan |
| `vw_status_kamar_opsional` | Housekeeping — peta status kamar real-time |
| `vw_performa_staf_operasional` | Manajer — KPI produktivitas pegawai |

### Stored Procedure (05_procedure.sql)

```sql
-- Hitung invoice lengkap per reservasi
CALL sp_hitung_invoice_lengkap(1, @kamar, @tambahan, @total, @dibayar, @sisa);
SELECT @kamar, @tambahan, @total, @dibayar, @sisa;

-- Catat pembayaran baru dengan validasi
CALL sp_proses_pembayaran_aman(19, 500000.00, 'Transfer', 3, @pesan);
SELECT @pesan;

-- Batalkan reservasi (otomatis reset kamar + refund)
CALL sp_batal_reservasi_otomatis(20, 6, @pesan);
SELECT @pesan;
```

### Trigger (06_trigger.sql)

| Trigger | Event | Efek Otomatis |
|---------|-------|---------------|
| `trg_before_detail_reservasi_insert` | BEFORE INSERT | Tolak kamar Perawatan & cegah double booking |
| `trg_after_detail_reservasi_insert` | AFTER INSERT | Status kamar → `Dipesan` |
| `trg_after_checkin_insert` | AFTER INSERT | Status kamar → `Terisi`, reservasi → `Check-in` |
| `trg_after_checkout_insert` | AFTER INSERT | Status kamar → `Tersedia`, reservasi → `Selesai` |
| `trg_after_pembayaran_insert` | AFTER INSERT | Catat audit trail ke `log_aktivitas` |

### Function (07_function.sql)

```sql
-- Hitung durasi menginap (malam)
SELECT fn_hitung_durasi_malam('2026-06-01', '2026-06-05');
-- Output: 4

-- Hitung total tagihan (kamar + biaya tambahan)
SELECT fn_total_pendapatan_reservasi(1);
-- Output: 700000.00

-- Cek status pembayaran teks
SELECT fn_cek_status_pembayaran(13);
-- Output: 'KURANG BAYAR'

-- Laporan billing seluruh reservasi (gabungan 3 function)
SELECT
    id_reservasi,
    fn_hitung_durasi_malam(tanggal_checkin_rencana, tanggal_checkout_rencana) AS durasi_malam,
    fn_total_pendapatan_reservasi(id_reservasi)                               AS total_tagihan,
    fn_cek_status_pembayaran(id_reservasi)                                    AS status_keuangan
FROM reservasi;
```

---

## 📐 Desain & Keputusan Teknis

### Normalisasi
Skema dirancang hingga **Third Normal Form (3NF)**:
- **1NF** — Semua kolom atomik, tidak ada kelompok berulang
- **2NF** — Tidak ada partial dependency pada kunci komposit
- **3NF** — Tidak ada transitive dependency antar atribut non-kunci

### Generated Column
Kolom `subtotal` pada `detail_reservasi` menggunakan `GENERATED ALWAYS AS (jumlah_malam * harga_per_malam) STORED` — dihitung otomatis oleh MySQL, menjamin konsistensi tanpa bergantung logika aplikasi.

### Snapshot Harga
`harga_per_malam` pada `detail_reservasi` disimpan sebagai snapshot saat pemesanan (bukan FK ke `tipe_kamar`), sehingga perubahan tarif kamar di masa depan tidak mempengaruhi histori transaksi.

### Soft Delete
Tabel `tamu` dan `pegawai` menggunakan kolom `is_active` (flag `1`/`0`) sebagai mekanisme soft delete — data tidak dihapus fisik agar histori reservasi tetap terjaga.

### Anti-Double Booking
Proteksi double booking diimplementasikan di **tingkat database** melalui `trg_before_detail_reservasi_insert` menggunakan deteksi irisan tanggal:
```sql
r.tanggal_checkin_rencana  < v_tanggal_checkout AND
r.tanggal_checkout_rencana > v_tanggal_checkin
```

---

## 🧪 Pengujian Trigger (Skenario End-to-End)

File `06_trigger.sql` menyertakan 6 skenario uji otomatis:

```sql
-- Jalankan skenario pengujian lengkap
mysql -u root -p hotel_reservation_db < sql/06_trigger.sql
```

| Test | Skenario | Ekspektasi |
|------|----------|------------|
| TEST 1 | Pesan kamar yang sedang Perawatan | ❌ GAGAL — Error 1644 |
| TEST 2 | Double booking pada tanggal yang sama | ❌ GAGAL — Error 1644 |
| TEST 3 | Booking kamar tersedia | ✅ SUKSES — status → Dipesan |
| TEST 4 | Pembayaran masuk | ✅ SUKSES — log audit tercatat |
| TEST 5 | Proses check-in | ✅ SUKSES — status → Terisi & Check-in |
| TEST 6 | Proses check-out | ✅ SUKSES — status → Tersedia & Selesai |

---

## 📊 Statistik Implementasi

| Komponen | Jumlah |
|----------|--------|
| Tabel | 12 |
| Constraint (PK/FK/UNIQUE/CHECK/dll.) | 60+ |
| Index | 7 |
| Baris data dummy | 300+ |
| Query SELECT | 7 |
| View | 5 |
| Stored Procedure | 3 |
| Trigger | 5 |
| Function | 3 |

---
## Kesimpulan
Project ini berhasil merancang dan mengimplementasikan Sistem Basis Data Relasional Reservasi Hotel secara menyeluruh menggunakan DBMS MySQL 8.0. Beberapa pencapaian utama yang dapat disimpulkan adalah sebagai berikut:
1.	Sistem berhasil dimodelkan dengan 12 entitas/tabel yang saling terhubung melalui foreign key constraint, mencakup seluruh siklus bisnis hotel mulai dari reservasi, check-in, check-out, hingga pembayaran.
2.	Proses normalisasi dilakukan secara sistematis dari Unnormalized Form (UNF) hingga Third Normal Form (3NF), mengeliminasi seluruh partial dependency dan transitive dependency sehingga menjamin konsistensi dan efisiensi penyimpanan data.
3.	Implementasi DDL mencakup 12 jenis constraint (PK, FK, UNIQUE, CHECK, NOT NULL, DEFAULT, GENERATED, INDEX, ON UPDATE CASCADE, ON DELETE RESTRICT/CASCADE/SET NULL) yang memastikan integritas data di tingkat database.
4.	Sebanyak 7 query SELECT dengan tingkat kompleksitas bertingkat berhasil dibuat, mulai dari query sederhana dengan JOIN 2 tabel, query dengan JOIN 6 tabel sekaligus, CTE (Common Table Expression), subquery, hingga agregasi multi-fungsi dengan GROUP BY dan HAVING.
5.	Lima view diimplementasikan untuk menyederhanakan akses data bagi berbagai peran pengguna (resepsionis, kasir, housekeeping, manajemen).
6.	Tiga stored procedure dirancang dengan prinsip ACID (menggunakan START TRANSACTION/COMMIT), validasi guard clause, dan reusability antar prosedur.
7.	Lima trigger berhasil mengotomasi perubahan status kamar dan audit trail tanpa intervensi manual, termasuk perlindungan anti-double booking tingkat database menggunakan BEFORE INSERT trigger.
8.	Tiga stored function dibuat dengan memanfaatkan konsep function composition (fn_cek_status_pembayaran memanggil fn_total_pendapatan_reservasi) untuk menghindari duplikasi logika bisnis.

## Saran
Meskipun sistem telah berjalan sesuai spesifikasi, terdapat beberapa aspek yang dapat dikembangkan lebih lanjut:
1.	Integrasi dengan lapisan aplikasi (front-end berbasis web atau mobile) agar sistem dapat digunakan secara interaktif oleh pegawai hotel tanpa perlu mengeksekusi SQL secara langsung.
2.	Penambahan modul manajemen SDM (jadwal shift pegawai, penggajian) untuk melengkapi sistem operasional hotel secara menyeluruh.
3.	Implementasi partisi tabel (table partitioning) pada tabel reservasi dan pembayaran untuk mengoptimalkan performa query ketika volume data sudah mencapai skala besar.
4.	Penambahan fitur pencarian ketersediaan kamar berbasis rentang tanggal yang dapat diakses oleh tamu secara mandiri (self-service booking portal).
5.	Penggunaan event scheduler MySQL untuk mengotomasi tugas periodik seperti pengiriman notifikasi reminder check-in kepada tamu atau pembatalan otomatis reservasi yang tidak terbayar dalam batas waktu tertentu.
6.	Enkripsi kolom sensitif (no_identitas, email, no_telepon) menggunakan AES_ENCRYPT/AES_DECRYPT untuk kepatuhan terhadap regulasi perlindungan data pribadi.

## 📚 Referensi

- Coronel, C., & Morris, S. (2019). *Database Systems: Design, Implementation, and Management* (13th ed.). Cengage Learning.
- Elmasri, R., & Navathe, S. B. (2016). *Fundamentals of Database Systems* (7th ed.). Pearson.
- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). *Database System Concepts* (7th ed.). McGraw-Hill.

---

## 📄 Lisensi

Project ini dibuat untuk keperluan akademik mata kuliah Basis Data, Program Studi S1 Statistika, FMIPA Universitas Jenderal Soedirman.

---

<div align="center">
  <sub>Kelompok G · Kelas B · Basis Data · FMIPA UNSOED · 2026</sub>
</div>
