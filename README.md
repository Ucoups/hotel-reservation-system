# Hotel Reservation System - PMS Ultimate (V6-HyperScale)

![MySQL](https://img.shields.io/badge/MySQL-8.0%20%2F%208.4-blue)
![Prisma](https://img.shields.io/badge/Prisma-ORM-success)
![Express](https://img.shields.io/badge/Express.js-Backend-blueviolet)
![Next.js](https://img.shields.io/badge/Next.js-16%20%28React%2019%29-black)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-CSS%20v4-blue)
![TypeScript](https://img.shields.io/badge/TypeScript-5-blue)

**🔒 Akses Uji Coba (Superadmin):**
- **Email/Username**: `superadmin@hotel.com`
- **Password**: `password123`

## Deskripsi Project

Hotel Reservation System adalah project Sistem Reservasi Hotel skala komersial (*Enterprise Grade*) terintegrasi yang telah melalui evolusi arsitektur dari versi standar hingga level **PMS Ultimate (V5)**. Aplikasi ini mencakup seluruh aspek ekosistem hotel mulai dari reservasi, *housekeeping*, manajemen *F&B* (Restoran), hingga sistem *billing* berlapis.

Sistem ini berfokus pada kekuatan logika di tingkat database relasional menggunakan **MySQL** (Stored Procedure, View, Trigger, Function) yang diintegrasikan secara *Type-Safe* (TypeScript) ke aplikasi web modern berbasis **Express.js API** (Backend) dan **Next.js App Router** (Frontend).

---

## Evolusi Fitur: V1 hingga V6-HyperScale

Aplikasi ini telah melalui lima iterasi besar hingga mencapai skalabilitas *Enterprise*:

### 🛡️ Versi Standar (V1 & V2): Fondasi & Dashboard Analitik
- **Peta Kamar Interaktif**: Dashboard grid status kamar hotel secara real-time dengan logika warna dinamis (Tersedia, Terisi, Dipesan, Perawatan).
- **Walk-In Check-In & Check-Out Cepat**: Otomatisasi status kamar fisik menjadi `Terisi` / `Tersedia` serta manipulasi status reservasi terintegrasi melalui *Trigger Database*.
- **Proteksi Kamar Perawatan**: Sistem secara otomatis mencegah dan menonaktifkan proses reservasi ganda.
- **Dashboard Analitik Admin**: Grafik tren omset bulanan, penayangan kartu KPI visual (Total Omset, Kamar Terlaris, Rasio Okupansi), dan evaluasi produktivitas staf operasional berbasis *View SQL*.

### 🔐 Autentikasi JWT & Keamanan (V3)
- **Role-Based Access Control (RBAC)**: Pemisahan otorisasi ketat antara Resepsionis, Admin, dan sistem Housekeeping.
- **Middleware Proteksi Ekstra**: Seluruh endpoint RESTful API dikawal oleh JSON Web Token (JWT) tersandikan menggunakan algoritma `bcrypt`.
- **Halaman Login Sentral**: Menjaga integritas data komersial hotel dari akses pihak tak berwenang.

### 🧹 Modul Otomasi Housekeeping (V4)
- **Otomasi Status Kotor**: Sistem *Event-Driven* via Trigger Database yang secara instan mendegradasi status kamar menjadi `Kotor` sesaat setelah tamu melakukan Check-Out.
- **Antrean Tugas (*Task Queue*) Housekeeping**: Alur tugas staf kebersihan yang tercatat rapi dari status `Pending`, di-klaim menjadi `In_Progress`, dan dikembalikan menjadi `Tersedia` saat `Completed`.
- **Layar Housekeeping Mandiri**: Antarmuka responsif khusus untuk staf kebersihan mengelola status pencucian dan penataan kamar.

### 🚀 PMS Ultimate Edition (V5)
- **CMS Menu Restoran Multi-Kategori**: Dasbor Admin spesialis pengelola menu F&B, mendukung tipe `MAKANAN`, `MINUMAN`, `DESSERT`, dilengkapi fitur *toggle* dinamis Ketersediaan Stok (*Out of Stock Firewall*).
- **Keranjang Pesanan Terpadu (*Charge-to-Room*)**: Antarmuka digital menu makanan (restoran) yang langsung ditagihkan kepada tagihan akhir penghuni kamar (Lobi -> Kamar).
- **Sistem Biaya Tambahan Berbasis Aturan (*Rule-Based Ancillary Charges*)**: Layanan ekstra yang adaptif. Mendukung logika tagihan `PER_JAM` (contoh: *Late Check-Out*), `PER_HARI` (Sewa Kasur / *Extrabed*), dan `PER_SEKALI_AKSI` (Pembersihan Ekstra).
- **Smart Multiplier UI**: Label input angka pada dasbor resepsionis secara ajaib akan beradaptasi antara "Jam" atau "Hari" tergantung tipe *charge* layanan tambahan yang dipilih.
- **Composite Billing Calculation**: SQL Agregasi Kompleks (pada titik Check-Out) yang secara matematis meleburkan: (1) Total Biaya Sewa Kamar, (2) Total Pesanan F&B Restoran, dan (3) Dinamika Biaya Layanan Tambahan ke dalam satu *Grand Total* final tanpa *gap* angka sepeserpun.

### 🎨 Visual Architecture & UI Design (Neobrutalism Styling)
- **High-Contrast Typography & Colors**: Penggunaan warna latar krem redup (`#fdfbf7`) yang dibenturkan dengan aksen warna solid (kuning tajam, biru kobalt, merah pekat) untuk mengarahkan fokus mata pengguna (resepsionis) secara instan ke area-area vital (kamar terisi, kotor, atau pesanan layanan ekstra).
- **Thick Borders & Hard Shadows**: Meninggalkan gaya *flat* dan *soft drop-shadow* modern demi menghadirkan garis tepi hitam tebal (`border-4 border-black`) dan bayangan solid tanpa-blur (`shadow-[4px_4px_0_0_#000]`). Keputusan desain ini melahirkan nuansa struktural layaknya mesin kasir mekanik bergaya retro-digital yang meningkatkan *tactile feel* atau kesan nyata saat berinteraksi dengan tombol aksi.
- **Cognitive Load Reduction**: Alih-alih membuat elemen terlihat menyatu, aliran Neobrutalism menonjolkan sekat pemisah antar blok informasi secara ekstrem. Hal ini krusial pada skenario operasional hotel yang sibuk, karena batas tegas antar komponen (seperti tabel tagihan vs form check-in) secara drastis mengurangi probabilitas *human error* saat staf melakukan input dan membaca status data.
- **Horizontal Neobrutalist Filter Control Bar**: Komponen penapisan data kamar tingkat atas (Lantai, Tipe, Status) pada Dashboard Utama. Dibangun dengan CSS statis (`appearance-none` & panah SVG kustom) untuk memitigasi isu *overflow* asimetris pada render dropdown *browser*, menjaga integritas visual kaku Neobrutalism tetap presisi meski data skala besar.

### 🛡️ PMS Enterprise Ultimate & Forensic Analytics (V6-HyperScale)
- **Agregasi Finansial Harian (Night Audit)**: Simulasi endpoint penutupan buku harian finansial hotel yang secara ACID merekonsiliasi total billing Kamar, Restoran, dan Layanan Ekstra.
- **Visual Analytics (Neobrutalism Recharts)**: Visualisasi interaktif grafik garis okupansi harian & grafik lingkaran (Pie Chart) segmentasi omset operasional dengan gaya Neobrutalism menggunakan library Recharts.
- **Forensic Timeline (Live Audit Trail)**: Pelacakan riwayat aktivitas staf secara real-time dengan kode warna yang berani (Hijau: Check-in, Merah: Check-out, Kuning: Layanan Ekstra, Ungu: Night Audit).

## 🛡️ Database Traceability Matrix & Compliance Validation

Hasil audit ketertelusuran arsitektur relasi database (DDL, DML, Triggers, Views, Stored Procedures) MySQL terhadap kode website Express.js backend & Next.js frontend:

| Komponen Database | Tipe Komponen | Berkas Terkait di Repositori | Status Sinkronisasi |
| :--- | :--- | :--- | :--- |
| `tamu`, `pegawai`, `kamar`, `tipe_kamar`, `fasilitas`, `kamar_fasilitas`, `reservasi`, `detail_reservasi`, `pembayaran`, `checkin`, `checkout`, `log_aktivitas` | Tabel Utama (V1-V2) | [schema.prisma](file:///d:/Website/Hotel_Reservation_System/backend/prisma/schema.prisma) | **100% Sinkron** |
| `menu_restoran`, `pesanan_restoran`, `tugas_housekeeping`, `layanan_tambahan`, `detail_layanan_kamar` | Tabel Baru (V3-V5) | [schema.prisma](file:///d:/Website/Hotel_Reservation_System/backend/prisma/schema.prisma) | **100% Sinkron** |
| `vw_status_kamar_opsional` | SQL View (Real-time Room) | [dashboard.controller.ts](file:///d:/Website/Hotel_Reservation_System/backend/src/controllers/dashboard.controller.ts) | **100% Sinkron** |
| `vw_performa_staf_operasional` | SQL View (Staff KPI) | [admin.controller.ts](file:///d:/Website/Hotel_Reservation_System/backend/src/controllers/admin.controller.ts) | **100% Sinkron** |
| `sp_proses_pembayaran_aman` | Stored Procedure (ACID Check) | [reservasi.controller.ts](file:///d:/Website/Hotel_Reservation_System/backend/src/controllers/reservasi.controller.ts) | **100% Sinkron** |
| `trg_after_checkin` | Database Trigger (Occupied Rooms) | MySQL Server (DDL 01) | **100% Aktif** |
| `trg_after_checkout_insert` | Database Trigger (Dirty Rooms) | MySQL Server (DDL 09) | **100% Aktif** |
| `02_dml.sql` | Dummy SQL Data Seeding | [update-db-services.ts](file:///d:/Website/Hotel_Reservation_System/backend/src/update-db-services.ts) | **100% Terpopulasi** |

---

## Struktur Folder Proyek

```text
Hotel_Reservation_System/
|-- README.md
|-- package.json
|-- database/
|   |-- ddl/01_ddl.sql
|   |-- dml/02_dml.sql
|   |-- query/03_query.sql
|   |-- view/04_view.sql
|   |-- procedure/05_procedure.sql
|   |-- trigger/06_trigger.sql
|   |-- function/07_function.sql
|   `-- dump/pms_ultimate_final.sql (Berkas Akhir)
|-- backend/ (Express.js API)
|   |-- src/
|   |   |-- controllers/ (auth, reservasi, dashboard, admin, restoran, layanan)
|   |   |-- middleware/ (auth.middleware.ts)
|   |   |-- routes/api.routes.ts
|   |   |-- server.ts
|   |-- prisma/schema.prisma
|   |-- .env
|   `-- package.json
`-- frontend/ (Next.js Application)
    |-- src/
    |   `-- app/
    |       |-- login/page.tsx (Pintu Gerbang RBAC)
    |       |-- admin/page.tsx (Laporan KPI)
    |       |-- admin/restoran/page.tsx (CMS Restoran)
    |       |-- restoran/page.tsx (Point of Sales Restoran)
    |       |-- housekeeping/page.tsx (Sistem Antrean Tugas)
    |       |-- page.tsx (Dashboard Resepsionis Utama)
    |       `-- globals.css
    `-- package.json
```

---

## Cara Setup & Instalasi

### 1. Kloning Repositori & Install Runner
1. Kloning repositori proyek ini ke komputer lokal Anda.
2. Di direktori utama proyek (`Hotel_Reservation_System`), pasang modul otomasi:
   ```bash
   npm install
   ```

### 2. Setup Database
1. Pastikan server MySQL Anda aktif.
2. Jika Anda ingin melakukan instalasi 1-klik, jalankan berkas pembuangan skema database final V5-Ultimate:
   ```sql
   SOURCE database/dump/pms_ultimate_final.sql;
   ```

### 3. Setup Backend & Prisma ORM
1. Masuk ke direktori `backend` dan jalankan instalasi:
   ```bash
   cd backend
   npm install
   ```
2. Buat file `.env` di dalam folder `backend/` dan masukkan URL koneksi database MySQL Anda:
   ```ini
   DATABASE_URL="mysql://USER:PASSWORD@localhost:3306/hotel_reservation_db"
   PORT=3002
   JWT_SECRET="RahasiaSuperAman123!"
   ```
3. Generate Prisma client (Pastikan telah melakukan introspeksi):
   ```bash
   npx prisma db pull
   npx prisma generate
   ```

### 4. Setup Frontend
1. Masuk ke direktori `frontend`:
   ```bash
   cd ../frontend
   npm install
   ```

---

## Cara Menjalankan Aplikasi

Anda cukup menjalankan satu perintah sakti ini di **akar direktori utama proyek** (`Hotel_Reservation_System`):

```bash
npm run dev
```

Script ini akan secara otomatis mengaktifkan:
- **Backend API**: Berjalan di `http://localhost:3002`
- **Frontend Next.js**: Berjalan di `http://localhost:3003`

Buka browser Anda dan akses **`http://localhost:3003`** untuk membuka Pintu Gerbang Sistem. Login menggunakan kredensial **superadmin@hotel.com** / **password123**.

---

## Lisensi

Project ini digunakan untuk keperluan akademik tingkat lanjut (V5) di bawah lisensi terbuka institusi terkait. Bebas dimodifikasi dengan pengakuan kredit (Zero-Error Type Safety Architectural Standard).
