# 🏢 Sistem Basis Data Reservasi Hotel - Enterprise Layout (UNSOED 2026)

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)
![UNSOED](https://img.shields.io/badge/UNSOED-FMIPA--Statistika-yellow?style=for-the-badge)
![Group-Project](https://img.shields.io/badge/Kelompok-G--1-green?style=for-the-badge)
![Status-Academic](https://img.shields.io/badge/Academic-Documentation-blueviolet?style=for-the-badge)

---

## 📌 1. Identitas Proyek & Tim Pengembang

Dokumentasi ini disusun sebagai bagian dari luaran akademik praktikum dan proyek mata kuliah Sistem Basis Data. Sistem Basis Data Reservasi Hotel (Enterprise Version) ini merupakan hasil perancangan dan implementasi terstruktur untuk memenuhi kebutuhan operasional industri perhotelan modern.

* **Judul Laporan:** Laporan Project Basis Data - Sistem Basis Data Reservasi Hotel
* **Institusi:** Program Studi Statistika, Jurusan Matematika, Fakultas Matematika dan Ilmu Pengetahuan Alam, Universitas Jenderal Soedirman (UNSOED), Purwokerto.
* **Tahun Akademik:** 2026
* **Tim Pengembang (Kelompok G-1):**
  
  | No | Nama Pengembang | Nomor Induk Mahasiswa (NIM) | Peran Utama | Tanggung Jawab Utama |
  |---|---|---|---|---|
  | 1 | **Nasywa Putri Maitsa** | K1D024043 | Database Designer | Perancangan konsep data, normalisasi, dan pembuatan kamus data. |
  | 2 | **Nayla Edenine Qohar** | K1D024044 | Business Analyst & QA | Penyusunan aturan bisnis (*business rules*) dan pengujian skenario error. |
  | 3 | **Abdurrahman Yusuf** | K1D024058 | SQL Lead Developer | Penyusunan DDL, DML, Stored Procedures, Triggers, Views, dan Functions. |
  | 4 | **Bertha Misella Silalahi** | K1D024068 | Technical Writer | Penyusunan laporan teknis, dokumentasi skema relasional, dan proposal. |

* **Dosen Pengampu:** Lutfiah Maharani Siniwi, S.Stat., M.Stat.

---

## 📝 2. Pendahuluan & Deskripsi Studi Kasus

### Latar Belakang
Industri perhotelan modern dituntut untuk memiliki tingkat efisiensi operasional yang sangat tinggi dan ketepatan data yang mutlak. Pengelolaan hotel konvensional yang masih mengandalkan pencatatan manual atau sistem terdesentralisasi non-relasional sering kali menghadapi kendala serius. Beberapa masalah klasik yang sering muncul di antaranya:
* **Duplikasi Data:** Pengulangan penulisan identitas tamu yang sama pada setiap pemesanan baru, yang memboroskan ruang penyimpanan.
* **Inkonsistensi Status Kamar:** Terjadinya *double booking* di mana satu kamar fisik dipesan oleh dua pihak yang berbeda pada tanggal yang beririsan (*race condition*).
* **Keterlambatan Pelaporan Keuangan:** Kesulitan menghitung sisa tagihan secara *real-time* akibat pembayaran bertahap (*split payment*), biaya tambahan check-out (*late charge/damage charge*), dan kalkulasi subtotal yang masih manual.
* **Ketiadaan Audit Trail:** Tidak adanya rekaman log aktivitas yang akurat mengenai pegawai mana yang memproses check-in, check-out, atau menerima pembayaran uang masuk.

Untuk memecahkan masalah tersebut, Kelompok G-1 merancang dan mengimplementasikan sistem basis data relasional terintegrasi menggunakan MySQL 8.0. Arsitektur data ini memindahkan seluruh validasi aturan bisnis secara mandiri ke tingkat database (*self-contained business logic*), sehingga menjamin konsistensi data secara absolut terlepas dari teknologi backend aplikasi yang digunakan.

### Tujuan & Manfaat
#### 1. Bagi Pihak Manajemen Hotel
* Menjamin keamanan operasional kamar melalui pencegahan *double booking* otomatis di tingkat database.
* Memantau ketersediaan kamar, laporan pembayaran, dan kinerja staf secara langsung (*real-time*).
* Meminimalkan risiko kerugian keuangan dengan adanya sistem proteksi kelebihan bayar (*overpayment protection*).

#### 2. Bagi Tamu Hotel
* Memberikan kepastian pemesanan tanpa risiko tumpang tindih kamar.
* Proses transaksi check-in dan check-out yang lebih cepat dan transparan dengan tagihan yang terperinci.

#### 3. Bagi Tim Pengembang (Mahasiswa)
* Menerapkan konsep normalisasi database secara riil hingga bentuk normal ketiga (3NF).
* Memahami cara kerja transaksi atomik (ACID) dan pemrograman basis data lanjutan (*Stored Procedures, Triggers, Functions, Views*).

---

## ⚙️ 3. Analisis Kebutuhan & Aturan Bisnis (Business Rules)

### 3.1 Ruang Lingkup Sistem (Scope)
Sistem basis data reservasi hotel ini mengkapsulasi seluruh proses bisnis inti perhotelan:
1. **Pendaftaran Tamu & Pegawai:** Registrasi biodata unik, nomor telepon, email, serta kontrol status aktif pegawai dan tamu.
2. **Pengelolaan Kamar & Fasilitas:** Kamar fisik dipetakan berdasarkan tipe (Standard, Deluxe, Suite, dll.) dengan harga dasar per malam yang berbeda, serta relasi dinamis terhadap daftar fasilitas kamar yang tersedia.
3. **Pemesanan Kamar (Reservasi):** Tamu dapat memesan satu atau beberapa kamar sekaligus dalam satu reservasi untuk rentang tanggal rencana tertentu.
4. **Pembayaran Enkapsulasi:** Transaksi pembayaran didokumentasikan secara terperinci dengan pencatatan metode pembayaran, tanggal transaksi, dan validasi nominal terhadap sisa tagihan.
5. **Realisasi Check-In & Check-Out:** Pencatatan waktu aktual saat tamu memasuki kamar dan saat tamu meninggalkan hotel beserta pembebanan biaya tambahan operasional.
6. **Audit Trail Otomatis:** Setiap mutasi keuangan penting akan direkam langsung oleh sistem ke dalam tabel log aktivitas pegawai.

### 3.2 Identifikasi Aktor & Peran
Basis data ini membagi hak akses dan tanggung jawab berdasarkan tabel relasional pegawai ke dalam beberapa peran berikut:

| Peran Aktor | Hak Akses Tabel Utama | Deskripsi Peran Operasional |
|---|---|---|
| **Tamu** | `tamu`, `reservasi` | Melakukan registrasi identitas diri, memilih tipe kamar, melakukan pembayaran deposit/lunas, dan menginap. |
| **Resepsionis** | `reservasi`, `checkin`, `checkout`, `kamar` | Mengelola pemetaan kamar kosong, memverifikasi data check-in tamu datang, memproses kepulangan check-out, dan memperbarui status kamar fisik. |
| **Kasir** | `pembayaran` | Mencatat transaksi pembayaran dari tamu, memilih metode pembayaran, memvalidasi sisa tagihan, dan mengeluarkan invoice. |
| **Supervisor / Manajer** | `log_aktivitas`, seluruh `Views` | Memantau kinerja operasional hotel melalui laporan audit trail, okupansi kamar harian, laporan bulanan keuangan, dan performa produktivitas staf. |

### 3.3 Aturan Bisnis Inti (Core Business Rules)
Aturan bisnis berikut dikunci secara mutlak pada tingkat database menggunakan constraint, trigger, dan stored procedure:
* **Unik & Kritis:** Kolom `no_identitas` dan `email` tamu wajib bernilai unik (`UNIQUE`) untuk menghindari duplikasi identitas pelanggan.
* **Konsistensi Tanggal Rencana:** Tanggal check-out rencana wajib lebih besar dari tanggal check-in rencana (`tanggal_checkout_rencana > tanggal_checkin_rencana`). Pengecekan ini diikat oleh `CHECK CONSTRAINT`.
* **Proteksi Double Booking:** Satu kamar fisik hanya boleh dipesan oleh satu reservasi aktif pada rentang tanggal tertentu. Jika terdapat irisan tanggal hunian (`check-in` baru < `check-out` lama AND `check-out` baru > `check-in` lama), DBMS akan membatalkan penyisipan data secara paksa.
* **Otomasi Subtotal Finansial:** Kolom `subtotal` pada tabel `detail_reservasi` tidak boleh diinput manual, melainkan dihitung secara otomatis sebagai `jumlah_malam * harga_per_malam`.
* **Korelasi Operasional (1:1):** Catatan check-in dan check-out terikat secara unik (`UNIQUE`) terhadap satu reservasi. Reservasi yang sudah check-in tidak dapat melakukan check-in ulang, demikian pula untuk check-out.
* **Soft Delete Data Master:** Penanda status `is_active` (`TINYINT(1) DEFAULT 1`) disematkan pada tabel `tamu` dan `pegawai`. Proses penonaktifan data master dilakukan dengan mengubah nilai `is_active` menjadi `0`, bukan melakukan penghapusan fisik (`DELETE`), guna menjaga keutuhan relasi data transaksi masa lampau.

---

## 🗺️ 4. Perancangan Basis Data & Normalisasi (3NF)

### 4.1 Alur Normalisasi (UNF ke 3NF)
Proses normalisasi dilakukan secara bertahap dari dokumen tidak ternormalisasi (*Unnormalized Form*) hingga mencapai bentuk normal ketiga (*Third Normal Form*):

1. **Unnormalized Form (UNF):**
   Data transaksi reservasi awal dikumpulkan dalam satu berkas besar yang berisi grup berulang (*repeating groups*) seperti data tamu, tipe kamar, detail kamar yang dipesan, dan pembayaran yang digabungkan dalam satu baris record.
2. **First Normal Form (1NF):**
   Repeating groups dihilangkan dengan membuat setiap baris record memiliki nilai atomik (tunggal). Semua kolom diisi penuh tanpa ada sel yang kosong atau berisi array data. Namun, terdapat banyak redundansi data tamu dan kamar.
3. **Second Normal Form (2NF):**
   Menghilangkan ketergantungan parsial (*partial dependency*). Atribut-atribut non-key yang hanya bergantung pada sebagian kunci primer dipisahkan. Data master seperti data tamu, kamar, tipe kamar, pegawai, dan fasilitas dipisahkan ke tabel tersendiri, terpisah dari tabel transaksi reservasi.
4. **Third Normal Form (3NF):**
   Menghilangkan ketergantungan transitif (*transitive dependency*). Hubungan di mana atribut non-key bergantung pada atribut non-key lainnya dipecah. Data pembayaran, check-in, check-out, serta data jembatan kamar-fasilitas dipisahkan ke tabel mandiri. Hasil akhirnya adalah **12 tabel yang bersih dan saling berelasi tanpa ada anomali update, insert, atau delete**.

### 4.2 Skema Relasional (Logical Design)
Berdasarkan hasil transformasi 3NF, skema relasional logis dari ke-12 tabel didefinisikan sebagai berikut:

* **`tamu`** (`id_tamu` **PK**, `nama_tamu`, `no_identitas` **UK**, `jenis_kelamin`, `no_telepon`, `email` **UK**, `alamat`, `is_active`, `created_at`, `updated_at`)
* **`pegawai`** (`id_pegawai` **PK**, `nama_pegawai`, `jabatan`, `no_telepon`, `email` **UK**, `is_active`, `created_at`, `updated_at`)
* **`tipe_kamar`** (`id_tipe_kamar` **PK**, `nama_tipe` **UK**, `kapasitas`, `harga_per_malam`, `deskripsi`)
* **`fasilitas`** (`id_fasilitas` **PK**, `nama_fasilitas` **UK**, `deskripsi`)
* **`kamar`** (`id_kamar` **PK**, `id_tipe_kamar` **FK**, `nomor_kamar` **UK**, `lantai`, `status_kamar`)
* **`reservasi`** (`id_reservasi` **PK**, `id_tamu` **FK**, `id_pegawai` **FK**, `tanggal_reservasi`, `tanggal_checkin_rencana`, `tanggal_checkout_rencana`, `status_reservasi`)
* **`detail_reservasi`** (`id_detail_reservasi` **PK**, `id_reservasi` **FK**, `id_kamar` **FK**, `jumlah_malam`, `harga_per_malam`, `subtotal` **GENERATED STORED**, **UK**(`id_reservasi`, `id_kamar`))
* **`pembayaran`** (`id_pembayaran` **PK**, `id_reservasi` **FK**, `tanggal_pembayaran`, `jumlah_bayar`, `metode_pembayaran`, `status_pembayaran`)
* **`checkin`** (`id_checkin` **PK**, `id_reservasi` **FK/UK**, `waktu_checkin`, `id_pegawai` **FK**, `catatan`)
* **`checkout`** (`id_checkout` **PK**, `id_reservasi` **FK/UK**, `waktu_checkout`, `id_pegawai` **FK**, `biaya_tambahan`, `catatan`)
* **`kamar_fasilitas`** (`id_kamar` **PK/FK**, `id_fasilitas` **PK/FK**)
* **`log_aktivitas`** (`id_log` **PK**, `id_pegawai` **FK**, `aktivitas`, `waktu_aktivitas`, `keterangan`)

### 4.3 Struktur Kardinalitas
Kardinalitas relasi database dikelola dengan aturan berikut:
* **`tamu` ke `reservasi` (`1:M`):** Tamu dapat memesan reservasi berulang kali.
* **`tipe_kamar` ke `kamar` (`1:M`):** Tipe kamar Deluxe digunakan oleh banyak nomor kamar fisik.
* **`reservasi` ke `detail_reservasi` (`1:M`):** Satu reservasi dapat memuat banyak kamar sekaligus.
* **`reservasi` ke `checkin` & `checkout` (`1:1`):** Realisasi waktu check-in dan check-out dicatat tepat satu kali per transaksi reservasi untuk menjamin validitas operasional.
* **`kamar` ke `fasilitas` (`M:N`):** Kamar fisik berelasi dengan banyak fasilitas hotel. Hubungan ini didekonstruksi menggunakan tabel junction **`kamar_fasilitas`** yang berisi pasangan kunci primer komposit `(id_kamar, id_fasilitas)`.

---

## 💎 5. Arsitektur Lanjutan & Integritas Data (Advanced DDL Features)

### 5.1 Audit Trail & Soft Delete
Data historis transaksi finansial hotel sangat bergantung pada keberadaan data tamu dan pegawai. 
* **Alasan Arsitektur:** Jika data pegawai dihapus secara fisik (`DELETE`), database akan mengalami kegagalan integritas kunci asing (*foreign key constraint violation*) pada tabel transaksi.
* **Solusi Soft Delete:** Kolom `is_active` digunakan untuk menyembunyikan data master dari sistem aktif tanpa menghapusnya dari disk.
* **Solusi Audit Trail:** Pada tabel `log_aktivitas`, foreign key `id_pegawai` dikonfigurasi dengan opsi `ON DELETE SET NULL` dan `ON UPDATE CASCADE`.
  ```sql
  CONSTRAINT FK_LOG_PEGAWAI FOREIGN KEY (ID_PEGAWAI) REFERENCES PEGAWAI(ID_PEGAWAI)
      ON UPDATE CASCADE ON DELETE SET NULL
  ```
  Artinya, jika data pegawai terpaksa dihapus secara fisik, catatan aktivitas audit penting pegawai tersebut pada masa lalu tetap tersimpan di tabel log dengan nilai `id_pegawai = NULL` (tidak merusak data laporan).

### 5.2 Integritas Finansial (Generated Column)
Pada detail reservasi, nilai kolom `subtotal` dideklarasikan sebagai virtual generated column yang langsung disimpan di media penyimpanan disk (`STORED`).
```sql
SUBTOTAL DECIMAL(12,2) GENERATED ALWAYS AS (JUMLAH_MALAM * HARGA_PER_MALAM) STORED
```
* **Fungsi:** Mengunci formula kalkulasi di tingkat database. Backend developer atau aplikasi kasir tidak dapat memanipulasi atau mengirimkan nilai subtotal yang salah. Nilai subtotal dijamin selalu konsisten 100% secara matematis.

### 5.3 Check Constraints
Untuk mencegah kesalahan fatal penginputan data numerik negatif oleh pengguna, database menerapkan `CHECK CONSTRAINT` pada kolom sensitif:
* `CHECK (kapasitas > 0)` pada tabel `tipe_kamar`.
* `CHECK (harga_per_malam >= 0)` pada tabel `tipe_kamar` dan `detail_reservasi`.
* `CHECK (jumlah_malam > 0)` pada tabel `detail_reservasi`.
* `CHECK (jumlah_bayar > 0)` pada tabel `pembayaran`.
* `CHECK (biaya_tambahan >= 0)` pada tabel `checkout`.
* `CHECK (tanggal_checkout_rencana > tanggal_checkin_rencana)` pada tabel `reservasi`.

### 5.4 Database Indexing
Untuk mengoptimalkan performa query pencarian data di hotel berskala besar, indeks khusus didirikan pada kolom yang paling sering digunakan dalam klausa `WHERE`, `JOIN`, dan `ORDER BY`:
```sql
-- Mempercepat pencarian kamar berdasarkan tipe dan status (untuk Front Office)
INDEX IDX_KAMAR_TIPE (ID_TIPE_KAMAR);
INDEX IDX_KAMAR_STATUS (STATUS_KAMAR);

-- Mempercepat pelacakan transaksi reservasi berdasarkan tamu, pegawai, dan statusnya
INDEX IDX_RESERVASI_TAMU (ID_TAMU);
INDEX IDX_RESERVASI_PEGAWAI (ID_PEGAWAI);
INDEX IDX_RESERVASI_STATUS (STATUS_RESERVASI);

-- Mempercepat pencarian data pembayaran & audit log berdasarkan rentang waktu
INDEX IDX_PEMBAYARAN_RESERVASI (ID_RESERVASI);
INDEX IDX_PEMBAYARAN_STATUS (STATUS_PEMBAYARAN);
INDEX IDX_LOG_WAKTU (WAKTU_AKTIVITAS);
```

---

## 🚀 6. Implementasi Objek Programmable & Pengujian (DML & Objects)

### 6.1 Database Views (5 View)

Berikut adalah definisi lengkap SQL untuk kelima objek *view* yang digunakan untuk pelaporan dan pemantauan sistem:

#### 1. `vw_detail_reservasi_tamu`
Menampilkan rincian reservasi tamu secara terperinci untuk kebutuhan Front Office.
```sql
CREATE OR REPLACE VIEW VW_DETAIL_RESERVASI_TAMU AS
SELECT
    R.ID_RESERVASI,
    T.NAMA_TAMU,
    T.NO_TELEPON,
    K.NOMOR_KAMAR,
    TK.NAMA_TIPE,
    DATE_FORMAT(R.TANGGAL_RESERVASI, '%d-%m-%Y %H:%i') AS TANGGAL_BOOKING,
    DATE_FORMAT(R.TANGGAL_CHECKIN_RENCANA, '%d-%m-%Y') AS RENCANA_CHECKIN,
    DATE_FORMAT(R.TANGGAL_CHECKOUT_RENCANA, '%d-%m-%Y') AS RENCANA_CHECKOUT,
    DR.JUMLAH_MALAM,
    DR.HARGA_PER_MALAM,
    DR.SUBTOTAL,
    R.STATUS_RESERVASI
FROM RESERVASI R
JOIN TAMU T ON R.ID_TAMU = T.ID_TAMU
JOIN DETAIL_RESERVASI DR ON R.ID_RESERVASI = DR.ID_RESERVASI
JOIN KAMAR K ON DR.ID_KAMAR = K.ID_KAMAR
JOIN TIPE_KAMAR TK ON K.ID_TIPE_KAMAR = TK.ID_TIPE_KAMAR;
```

#### 2. `vw_billing_reservasi_summary`
Menampilkan ringkasan tagihan per reservasi serta sisa piutang untuk melacak tamu yang kurang bayar (`sisa_tagihan > 0`).
```sql
CREATE OR REPLACE VIEW VW_BILLING_RESERVASI_SUMMARY AS
SELECT 
    R.ID_RESERVASI,
    T.ID_TAMU,
    T.NAMA_TAMU,
    R.STATUS_RESERVASI,
    IFNULL(SUM(DR.SUBTOTAL), 0) AS TOTAL_BIAYA_KAMAR,
    IFNULL(CO.BIAYA_TAMBAHAN, 0) AS BIAYA_TAMBAHAN_CHECKOUT,
    (IFNULL(SUM(DR.SUBTOTAL), 0) + IFNULL(CO.BIAYA_TAMBAHAN, 0)) AS GRAND_TOTAL_TAGIHAN,
    IFNULL((SELECT SUM(JUMLAH_BAYAR) FROM PEMBAYARAN WHERE ID_RESERVASI = R.ID_RESERVASI AND STATUS_PEMBAYARAN = 'Lunas'), 0) AS TOTAL_TELAH_DIBAYAR,
    ((IFNULL(SUM(DR.SUBTOTAL), 0) + IFNULL(CO.BIAYA_TAMBAHAN, 0)) - 
     IFNULL((SELECT SUM(JUMLAH_BAYAR) FROM PEMBAYARAN WHERE ID_RESERVASI = R.ID_RESERVASI AND STATUS_PEMBAYARAN = 'Lunas'), 0)) AS SISA_TAGIHAN
FROM RESERVASI R
JOIN TAMU T ON R.ID_TAMU = T.ID_TAMU
LEFT JOIN DETAIL_RESERVASI DR ON R.ID_RESERVASI = DR.ID_RESERVASI
LEFT JOIN CHECKOUT CO ON R.ID_RESERVASI = CO.ID_RESERVASI
GROUP BY R.ID_RESERVASI, T.ID_TAMU, CO.BIAYA_TAMBAHAN;
```

#### 3. `vw_laporan_pembayaran`
Digunakan oleh bagian Finance untuk mengaudit arus kas pembayaran masuk.
```sql
CREATE OR REPLACE VIEW VW_LAPORAN_PEMBAYARAN AS
SELECT
    PB.ID_PEMBAYARAN,
    R.ID_RESERVASI,
    T.NAMA_TAMU,
    DATE_FORMAT(PB.TANGGAL_PEMBAYARAN, '%d-%m-%Y %H:%i:%s') AS WAKTU_PEMBAYARAN,
    PB.JUMLAH_BAYAR,
    PB.METODE_PEMBAYARAN,
    PB.STATUS_PEMBAYARAN
FROM PEMBAYARAN PB
JOIN RESERVASI R ON PB.ID_RESERVASI = R.ID_RESERVASI
JOIN TAMU T ON R.ID_TAMU = T.ID_TAMU;
```

#### 4. `vw_status_kamar_opsional`
Menampilkan okupansi kamar fisik secara *real-time* berserta nama tamu yang menginap (jika kamar terisi).
```sql
CREATE OR REPLACE VIEW VW_STATUS_KAMAR_OPSIONAL AS
SELECT 
    K.ID_KAMAR,
    K.NOMOR_KAMAR,
    K.LANTAI,
    TK.NAMA_TIPE,
    TK.HARGA_PER_MALAM,
    K.STATUS_KAMAR,
    CASE 
        WHEN K.STATUS_KAMAR = 'Terisi' THEN (
            SELECT T.NAMA_TAMU 
            FROM DETAIL_RESERVASI DR
            JOIN RESERVASI R ON DR.ID_RESERVASI = R.ID_RESERVASI
            JOIN TAMU T ON R.ID_TAMU = T.ID_TAMU
            WHERE DR.ID_KAMAR = K.ID_KAMAR AND R.STATUS_RESERVASI = 'Check-in'
            LIMIT 1
        )
        ELSE '-'
    END AS NAMA_TAMU_SEKARANG
FROM KAMAR K
JOIN TIPE_KAMAR TK ON K.ID_TIPE_KAMAR = TK.ID_TIPE_KAMAR;
```

#### 5. `vw_performa_staf_operasional`
Memantau produktivitas pegawai aktif berdasarkan akumulasi transaksi reservasi, check-in, dan check-out yang ditangani.
```sql
CREATE OR REPLACE VIEW VW_PERFORMA_STAF_OPERASIONAL AS
SELECT 
    P.ID_PEGAWAI,
    P.NAMA_PEGAWAI,
    P.JABATAN,
    (SELECT COUNT(*) FROM RESERVASI WHERE ID_PEGAWAI = P.ID_PEGAWAI) AS JUMLAH_HANDLE_RESERVASI,
    (SELECT COUNT(*) FROM CHECKIN WHERE ID_PEGAWAI = P.ID_PEGAWAI) AS JUMLAH_HANDLE_CHECKIN,
    (SELECT COUNT(*) FROM CHECKOUT WHERE ID_PEGAWAI = P.ID_PEGAWAI) AS JUMLAH_HANDLE_CHECKOUT
FROM PEGAWAI P
WHERE P.IS_ACTIVE = 1;
```

---

### 6.2 Stored Procedures (3 Procedure)

#### 1. `sp_hitung_invoice_lengkap`
Menghitung rincian finansial lengkap dari satu reservasi menggunakan parameter output.
```sql
DELIMITER //

CREATE PROCEDURE SP_HITUNG_INVOICE_LENGKAP(
    IN  P_ID_RESERVASI   INT,
    OUT P_BIAYA_KAMAR    DECIMAL(12,2),
    OUT P_BIAYA_TAMBAHAN DECIMAL(12,2),
    OUT P_GRAND_TOTAL    DECIMAL(12,2),
    OUT P_TOTAL_DIBAYAR  DECIMAL(12,2),
    OUT P_SISA_TAGIHAN   DECIMAL(12,2)
)
BEGIN
    SELECT COALESCE(SUM(SUBTOTAL), 0) INTO P_BIAYA_KAMAR
    FROM DETAIL_RESERVASI WHERE ID_RESERVASI = P_ID_RESERVASI;

    SELECT COALESCE(BIAYA_TAMBAHAN, 0) INTO P_BIAYA_TAMBAHAN
    FROM CHECKOUT WHERE ID_RESERVASI = P_ID_RESERVASI;

    SET P_GRAND_TOTAL = P_BIAYA_KAMAR + P_BIAYA_TAMBAHAN;

    SELECT COALESCE(SUM(JUMLAH_BAYAR), 0) INTO P_TOTAL_DIBAYAR
    FROM PEMBAYARAN WHERE ID_RESERVASI = P_ID_RESERVASI AND STATUS_PEMBAYARAN = 'Lunas';

    SET P_SISA_TAGIHAN = P_GRAND_TOTAL - P_TOTAL_DIBAYAR;
END //

DELIMITER ;
```

#### 2. `sp_proses_pembayaran_aman`
Membungkus pencatatan pembayaran dalam transaksi aman ACID. Jika sisa tagihan lunas, status reservasi otomatis diubah menjadi `Dikonfirmasi`.
```sql
DELIMITER //

CREATE PROCEDURE SP_PROSES_PEMBAYARAN_AMAN(
    IN  P_ID_RESERVASI    INT,
    IN  P_JUMLAH_BAYAR    DECIMAL(12,2),
    IN  P_METODE          ENUM('Tunai', 'Transfer', 'Kartu Kredit', 'E-Wallet'),
    IN  P_ID_PEGAWAI      INT,
    OUT P_STATUS_PESAN    VARCHAR(100)
)
BEGIN
    DECLARE V_BIAYA_KAMAR    DECIMAL(12,2);
    DECLARE V_BIAYA_TAMBAHAN DECIMAL(12,2);
    DECLARE V_GRAND_TOTAL    DECIMAL(12,2);
    DECLARE V_TOTAL_DIBAYAR  DECIMAL(12,2);
    DECLARE V_SISA_TAGIHAN   DECIMAL(12,2);
    
    CALL SP_HITUNG_INVOICE_LENGKAP(P_ID_RESERVASI, V_BIAYA_KAMAR, V_BIAYA_TAMBAHAN, V_GRAND_TOTAL, V_TOTAL_DIBAYAR, V_SISA_TAGIHAN);
    
    IF V_SISA_TAGIHAN <= 0 THEN
        SET P_STATUS_PESAN = 'GAGAL: Tagihan untuk reservasi ini sudah lunas.';
    ELSE
        START TRANSACTION;
            INSERT INTO PEMBAYARAN (ID_RESERVASI, JUMLAH_BAYAR, METODE_PEMBAYARAN, STATUS_PEMBAYARAN)
            VALUES (P_ID_RESERVASI, P_JUMLAH_BAYAR, P_METODE, 'Lunas');
            
            SET V_TOTAL_DIBAYAR = V_TOTAL_DIBAYAR + P_JUMLAH_BAYAR;
            SET V_SISA_TAGIHAN  = V_GRAND_TOTAL - V_TOTAL_DIBAYAR;
            
            UPDATE RESERVASI 
            SET STATUS_RESERVASI = 'Dikonfirmasi' 
            WHERE ID_RESERVASI = P_ID_RESERVASI 
              AND STATUS_RESERVASI = 'Menunggu' 
              AND V_SISA_TAGIHAN <= 0;
            
            INSERT INTO LOG_AKTIVITAS (ID_PEGAWAI, AKTIVITAS, KETERANGAN)
            VALUES (P_ID_PEGAWAI, 'Mencatat Pembayaran', CONCAT('Pembayaran sebesar Rp', FORMAT(P_JUMLAH_BAYAR, 0, 'id_ID'), ' berhasil dicatat untuk Reservasi ID ', P_ID_RESERVASI));
        COMMIT;
        SET P_STATUS_PESAN = CONCAT('SUKSES: Pembayaran berhasil. Sisa tagihan saat ini: Rp', FORMAT(V_SISA_TAGIHAN, 0, 'id_ID'));
    END IF;
END //

DELIMITER ;
```

#### 3. `sp_batal_reservasi_otomatis`
Membatalkan reservasi yang belum check-in secara aman, mengosongkan kembali status kamar, dan memproses pengembalian dana (*refund*).
```sql
DELIMITER //

CREATE PROCEDURE SP_BATAL_RESERVASI_OTOMATIS(
    IN  P_ID_RESERVASI INT,
    IN  P_ID_PEGAWAI   INT,
    OUT P_STATUS_PESAN VARCHAR(100)
)
BEGIN
    DECLARE V_STATUS_SEKARANG VARCHAR(30);
    
    SELECT STATUS_RESERVASI INTO V_STATUS_SEKARANG FROM RESERVASI WHERE ID_RESERVASI = P_ID_RESERVASI;
    
    IF V_STATUS_SEKARANG IN ('Check-in', 'Selesai', 'Dibatalkan') THEN
        SET P_STATUS_PESAN = CONCAT('GAGAL: Reservasi tidak bisa dibatalkan karena status sudah ', V_STATUS_SEKARANG);
    ELSE
        START TRANSACTION;
            UPDATE RESERVASI SET STATUS_RESERVASI = 'Dibatalkan' WHERE ID_RESERVASI = P_ID_RESERVASI;
            
            UPDATE KAMAR SET STATUS_KAMAR = 'Tersedia' WHERE ID_KAMAR IN (
                SELECT ID_KAMAR FROM DETAIL_RESERVASI WHERE ID_RESERVASI = P_ID_RESERVASI
            );
            
            UPDATE PEMBAYARAN SET STATUS_PEMBAYARAN = 'Refund' WHERE ID_RESERVASI = P_ID_RESERVASI;
            
            INSERT INTO LOG_AKTIVITAS (ID_PEGAWAI, AKTIVITAS, KETERANGAN)
            VALUES (P_ID_PEGAWAI, 'Pembatalan Reservasi', CONCAT('Reservasi ID ', P_ID_RESERVASI, ' dibatalkan. Kamar dikosongkan kembali.'));
        COMMIT;
        SET P_STATUS_PESAN = 'SUKSES: Reservasi berhasil dibatalkan dan status kamar telah diperbarui.';
    END IF;
END //

DELIMITER ;
```

---

### 6.3 Database Triggers (5 Trigger)

#### 1. `trg_before_detail_reservasi_insert` (Anti-Double Booking & Perawatan)
Mencegah pemesanan kamar jika kamar berstatus sedang dalam perbaikan (*Perawatan*) ATAU jika kamar tersebut telah dipesan oleh tamu lain pada tanggal menginap yang beririsan.
```sql
DELIMITER //

CREATE TRIGGER TRG_BEFORE_DETAIL_RESERVASI_INSERT
BEFORE INSERT ON DETAIL_RESERVASI
FOR EACH ROW
BEGIN
    DECLARE V_STATUS_KAMAR     VARCHAR(20);
    DECLARE V_TANGGAL_CHECKIN  DATE;
    DECLARE V_TANGGAL_CHECKOUT DATE;
    DECLARE V_JUMLAH_BENTROK   INT DEFAULT 0;

    SELECT STATUS_KAMAR INTO V_STATUS_KAMAR FROM KAMAR WHERE ID_KAMAR = NEW.ID_KAMAR;

    IF V_STATUS_KAMAR = 'Perawatan' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'OPERASI DITOLAK: Kamar tidak dapat dipesan karena sedang dalam masa pemeliharaan/Perawatan.';
    END IF;

    SELECT TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA
    INTO V_TANGGAL_CHECKIN, V_TANGGAL_CHECKOUT
    FROM RESERVASI WHERE ID_RESERVASI = NEW.ID_RESERVASI;

    SELECT COUNT(*) INTO V_JUMLAH_BENTROK
    FROM DETAIL_RESERVASI DR
    JOIN RESERVASI R ON DR.ID_RESERVASI = R.ID_RESERVASI
    WHERE DR.ID_KAMAR = NEW.ID_KAMAR
      AND DR.ID_RESERVASI <> NEW.ID_RESERVASI
      AND R.STATUS_RESERVASI NOT IN ('Dibatalkan', 'Selesai')
      AND R.TANGGAL_CHECKIN_RENCANA < V_TANGGAL_CHECKOUT
      AND R.TANGGAL_CHECKOUT_RENCANA > V_TANGGAL_CHECKIN;

    IF V_JUMLAH_BENTROK > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'OPERASI DITOLAK: Kamar sudah ter-booking oleh tamu lain pada periode tanggal tersebut.';
    END IF;
END //

DELIMITER ;
```

#### 2. `trg_after_detail_reservasi_insert`
Secara otomatis mengubah status kamar fisik menjadi `Dipesan` setelah berhasil dialokasikan dalam detail reservasi.
```sql
DELIMITER //

CREATE TRIGGER TRG_AFTER_DETAIL_RESERVASI_INSERT
AFTER INSERT ON DETAIL_RESERVASI
FOR EACH ROW
BEGIN
    UPDATE KAMAR SET STATUS_KAMAR = 'Dipesan'
    WHERE ID_KAMAR = NEW.ID_KAMAR AND STATUS_KAMAR = 'Tersedia';
END //

DELIMITER ;
```

#### 3. `trg_after_checkin_insert`
Mengubah status kamar fisik menjadi `Terisi` dan status transaksi reservasi menjadi `Check-in` saat tamu melakukan kedatangan fisik.
```sql
DELIMITER //

CREATE TRIGGER TRG_AFTER_CHECKIN_INSERT
AFTER INSERT ON CHECKIN
FOR EACH ROW
BEGIN
    UPDATE KAMAR K
    JOIN DETAIL_RESERVASI DR ON K.ID_KAMAR = DR.ID_KAMAR
    SET K.STATUS_KAMAR = 'Terisi'
    WHERE DR.ID_RESERVASI = NEW.ID_RESERVASI;

    UPDATE RESERVASI SET STATUS_RESERVASI = 'Check-in'
    WHERE ID_RESERVASI = NEW.ID_RESERVASI;
END //

DELIMITER ;
```

#### 4. `trg_after_checkout_insert`
Mengubah status kamar fisik kembali ke `Tersedia` (jika tidak dalam status perawatan) dan menutup status reservasi menjadi `Selesai` ketika tamu check-out.
```sql
DELIMITER //

CREATE TRIGGER TRG_AFTER_CHECKOUT_INSERT
AFTER INSERT ON CHECKOUT
FOR EACH ROW
BEGIN
    UPDATE KAMAR K
    JOIN DETAIL_RESERVASI DR ON K.ID_KAMAR = DR.ID_KAMAR
    SET K.STATUS_KAMAR = 'Tersedia'
    WHERE DR.ID_RESERVASI = NEW.ID_RESERVASI AND K.STATUS_KAMAR <> 'Perawatan';

    UPDATE RESERVASI SET STATUS_RESERVASI = 'Selesai'
    WHERE ID_RESERVASI = NEW.ID_RESERVASI;
END //

DELIMITER ;
```

#### 5. `trg_after_pembayaran_insert`
Perekaman audit trail keuangan otomatis ke dalam tabel log aktivitas pegawai setiap kali pembayaran transaksi kasir berhasil dicatat.
```sql
DELIMITER //

CREATE TRIGGER TRG_AFTER_PEMBAYARAN_INSERT
AFTER INSERT ON PEMBAYARAN
FOR EACH ROW
BEGIN
    INSERT INTO LOG_AKTIVITAS (ID_PEGAWAI, AKTIVITAS, KETERANGAN)
    SELECT
        R.ID_PEGAWAI,
        'Pembayaran Masuk',
        CONCAT('Pembayaran Sukses untuk Reservasi ID ', NEW.ID_RESERVASI, 
               ' sebesar Rp', FORMAT(NEW.JUMLAH_BAYAR, 0, 'id_ID'), 
               ' melalui metode [', NEW.METODE_PEMBAYARAN, '].')
    FROM RESERVASI R
    WHERE R.ID_RESERVASI = NEW.ID_RESERVASI;
END //

DELIMITER ;
```

---

### 6.4 User-Defined Functions (3 Function)

#### 1. `fn_hitung_durasi_malam`
Menghitung jumlah malam menginap berdasarkan selisih hari tanggal masuk dan keluar secara aman.
```sql
DELIMITER //

CREATE FUNCTION FN_HITUNG_DURASI_MALAM(
    P_CHECKIN  DATE,
    P_CHECKOUT DATE
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE V_DURASI INT;
    
    IF P_CHECKOUT <= P_CHECKIN OR P_CHECKIN IS NULL OR P_CHECKOUT IS NULL THEN
        RETURN 0;
    END IF;
    
    SET V_DURASI = DATEDIFF(P_CHECKOUT, P_CHECKIN);
    RETURN V_DURASI;
END //

DELIMITER ;
```

#### 2. `fn_total_pendapatan_reservasi`
Menghitung total tagihan kotor (akumulasi subtotal kamar + biaya tambahan check-out jika ada).
```sql
DELIMITER //

CREATE FUNCTION FN_TOTAL_PENDAPATAN_RESERVASI(
    P_ID_RESERVASI INT
)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE V_TOTAL_KAMAR    DECIMAL(12,2);
    DECLARE V_TOTAL_TAMBAHAN DECIMAL(12,2);
    
    SELECT COALESCE(SUM(SUBTOTAL), 0) INTO V_TOTAL_KAMAR
    FROM DETAIL_RESERVASI WHERE ID_RESERVASI = P_ID_RESERVASI;
    
    SELECT COALESCE(BIAYA_TAMBAHAN, 0) INTO V_TOTAL_TAMBAHAN
    FROM CHECKOUT WHERE ID_RESERVASI = P_ID_RESERVASI;
    
    RETURN V_TOTAL_KAMAR + V_TOTAL_TAMBAHAN;
END //

DELIMITER ;
```

#### 3. `fn_cek_status_pembayaran` (Function Composition)
Menentukan status keuangan reservasi dengan membandingkan total pembayaran lunas dengan total piutang reservasi (memanggil `fn_total_pendapatan_reservasi`).
```sql
DELIMITER //

CREATE FUNCTION FN_CEK_STATUS_PEMBAYARAN(
    P_ID_RESERVASI INT
)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE V_TOTAL_TAGIHAN DECIMAL(12,2);
    DECLARE V_TOTAL_BAYAR   DECIMAL(12,2);
    
    -- Memanggil fungsi pendapatan reservasi (Komposisi Fungsi)
    SET V_TOTAL_TAGIHAN = FN_TOTAL_PENDAPATAN_RESERVASI(P_ID_RESERVASI);
    
    SELECT COALESCE(SUM(JUMLAH_BAYAR), 0) INTO V_TOTAL_BAYAR
    FROM PEMBAYARAN
    WHERE ID_RESERVASI = P_ID_RESERVASI AND STATUS_PEMBAYARAN = 'Lunas';
    
    IF V_TOTAL_BAYAR = 0 THEN
        RETURN 'BELUM BAYAR';
    ELSEIF V_TOTAL_BAYAR < V_TOTAL_TAGIHAN THEN
        RETURN 'KURANG BAYAR';
    ELSE
        RETURN 'LUNAS';
    END IF;
END //

DELIMITER ;
```

---

### 6.5 Skenario Uji Coba Integrasi Skrip (Testing Suite)

#### Skenario A: Pengujian Proteksi Trigger & Kontrol Data (Negatif)
Membuktikan ketangguhan pertahanan database terhadap *input* tidak valid atau bentrok jadwal:

* **Pengecekan Kamar Perawatan (Maintenance Room Restriction):**
  ```sql
  -- Input reservasi baru ID: 911
  INSERT INTO RESERVASI (ID_RESERVASI, ID_TAMU, ID_PEGAWAI, TANGGAL_RESERVASI, TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA, STATUS_RESERVASI)
  VALUES (911, 3, 2, NOW(), '2026-07-01', '2026-07-03', 'Menunggu');

  -- Coba pesan Kamar ID: 5 (Nomor Kamar 105, berstatus 'Perawatan')
  -- Ekspektasi: Operasi ditolak dengan pesan: "OPERASI DITOLAK: Kamar tidak dapat dipesan karena sedang dalam masa pemeliharaan/Perawatan"
  INSERT INTO DETAIL_RESERVASI (ID_DETAIL_RESERVASI, ID_RESERVASI, ID_KAMAR, JUMLAH_MALAM, HARGA_PER_MALAM)
  VALUES (911, 911, 5, 2, 350000.00);
  ```

* **Pengecekan Double Booking (Anti-Collision Room Validation):**
  ```sql
  -- Input reservasi ID: 912 untuk rentang tanggal '2026-05-11' s/d '2026-05-13'
  INSERT INTO RESERVASI (ID_RESERVASI, ID_TAMU, ID_PEGAWAI, TANGGAL_RESERVASI, TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA, STATUS_RESERVASI)
  VALUES (912, 1, 1, NOW(), '2026-05-11', '2026-05-13', 'Dikonfirmasi');

  -- Coba pesan Kamar ID: 1 (Nomor Kamar 101, tipe Standard)
  -- Ekspektasi: Gagal karena Kamar 101 sudah terisi atau dipesan pada tanggal tersebut oleh reservasi lain.
  -- DBMS melempar pesan: "OPERASI DITOLAK: Kamar sudah ter-booking oleh tamu lain pada periode tanggal tersebut"
  INSERT INTO DETAIL_RESERVASI (ID_DETAIL_RESERVASI, ID_RESERVASI, ID_KAMAR, JUMLAH_MALAM, HARGA_PER_MALAM)
  VALUES (912, 912, 1, 2, 350000.00);
  ```

#### Skenario B: Pengujian Alur Transaksi Berhasil (Positif)
Simulasi pemesanan kamar Deluxe nomor 104 (ID Kamar: 4) secara linier tanpa eror:

* **Langkah 1: Inisialisasi Reservasi & Detail Kamar**
  ```sql
  INSERT INTO RESERVASI (ID_RESERVASI, ID_TAMU, ID_PEGAWAI, TANGGAL_RESERVASI, TANGGAL_CHECKIN_RENCANA, TANGGAL_CHECKOUT_RENCANA, STATUS_RESERVASI)
  VALUES (913, 2, 4, NOW(), '2026-08-01', '2026-08-03', 'Dikonfirmasi');

  INSERT INTO DETAIL_RESERVASI (ID_DETAIL_RESERVASI, ID_RESERVASI, ID_KAMAR, JUMLAH_MALAM, HARGA_PER_MALAM)
  VALUES (913, 913, 4, 2, 350000.00);
  ```
  *(Status Kamar 104 otomatis berubah menjadi 'Dipesan' akibat efek trigger `trg_after_detail_reservasi_insert`)*

* **Langkah 2: Melakukan Pembayaran Pelunasan**
  ```sql
  INSERT INTO PEMBAYARAN (ID_RESERVASI, JUMLAH_BAYAR, METODE_PEMBAYARAN, STATUS_PEMBAYARAN)
  VALUES (913, 700000.00, 'E-Wallet', 'Lunas');
  ```
  *(Trigger otomatis menulis log audit mutasi keuangan ke tabel `log_aktivitas`)*

* **Langkah 3: Pelaksanaan Kedatangan Tamu (Check-In)**
  ```sql
  INSERT INTO CHECKIN (ID_CHECKIN, ID_RESERVASI, ID_PEGAWAI, CATATAN)
  VALUES (913, 913, 4, 'Tamu check-in, kamar siap digunakan.');
  ```
  *(Trigger otomatis memperbarui status Kamar 104 menjadi 'Terisi' dan status reservasi menjadi 'Check-in')*

* **Langkah 4: Proses Kepulangan Tamu (Check-Out)**
  ```sql
  INSERT INTO CHECKOUT (ID_CHECKOUT, ID_RESERVASI, ID_PEGAWAI, BIAYA_TAMBAHAN, CATATAN)
  VALUES (913, 913, 2, 0.00, 'Tamu check-out tepat waktu.');
  ```
  *(Kamar 104 dibebaskan kembali menjadi 'Tersedia' dan transaksi reservasi 913 ditutup menjadi 'Selesai')*

---

## 🏁 7. Kesimpulan & Saran Pengembangan

### Kesimpulan
Sistem Basis Data Reservasi Hotel (Enterprise Version) rancangan **Kelompok G-1 UNSOED 2026** telah berhasil mereduksi seluruh kompleksitas operasional hotel ke dalam rancangan 12 tabel terintegrasi yang memenuhi kriteria bentuk normal ketiga (3NF). Seluruh aturan bisnis penting—mulai dari proteksi bentrok tanggal hunian (*double booking*), penghitungan otomatis subtotal kamar, sinkronisasi alur kamar fisik secara atomik, hingga penegakan kontrol audit trail—berhasil diekapsulasi secara mandiri di level database. Arsitektur ini menjamin keandalan transaksi finansial dan integritas data tanpa bergantung pada validasi aplikasi luar.

### Saran Pengembangan
1. **Penerapan Enkripsi Data Pribadi:** Melakukan enkripsi data sensitif tamu pada kolom `no_identitas` menggunakan fungsi AES bawaan MySQL (`AES_ENCRYPT` dan `AES_DECRYPT`) untuk kepatuhan terhadap regulasi privasi data.
2. **Table Partitioning:** Menerapkan pembagian tabel (*partitioning*) secara berkala (misal per tahun) pada tabel `log_aktivitas` dan `pembayaran` untuk mengantisipasi penurunan kecepatan query saat data mencapai jutaan baris.
3. **Event Scheduler:** Memanfaatkan scheduler internal MySQL untuk mengubah reservasi dengan status `Menunggu` yang tidak dibayar dalam waktu 2 jam setelah pembuatan reservasi menjadi `Dibatalkan` secara otomatis.
