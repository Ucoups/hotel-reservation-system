USE hotel_reservation_db;

-- =========================================================
-- INTEGRASI MODUL RESTORAN (F&B) & CHARGE-TO-ROOM
-- =========================================================

-- Hapus tabel jika sudah ada (sesuai urutan foreign key)
DROP TABLE IF EXISTS pesanan_restoran;
DROP TABLE IF EXISTS menu_restoran;

-- 1. TABEL MASTER MENU RESTORAN
CREATE TABLE menu_restoran (
  id_menu INT AUTO_INCREMENT PRIMARY KEY,
  nama_menu VARCHAR(100) NOT NULL UNIQUE,
  harga DECIMAL(12, 2) NOT NULL,
  tipe ENUM('Makanan', 'Minuman') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. TABEL TRANSAKSI PESANAN RESTORAN
CREATE TABLE pesanan_restoran (
  id_pesanan INT AUTO_INCREMENT PRIMARY KEY,
  id_reservasi INT NOT NULL,
  id_menu INT NOT NULL,
  jumlah INT NOT NULL,
  total_harga DECIMAL(12, 2) NOT NULL,
  status_bayar ENUM('Lunas', 'Charge-to-Room') NOT NULL,
  waktu_pesan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pesanan_reservasi FOREIGN KEY (id_reservasi) REFERENCES reservasi (id_reservasi) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pesanan_menu FOREIGN KEY (id_menu) REFERENCES menu_restoran (id_menu) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. SEED DATA MENU RESTORAN
INSERT INTO menu_restoran (id_menu, nama_menu, harga, tipe) VALUES
(1, 'Nasi Goreng Spesial', 35000.00, 'Makanan'),
(2, 'Mie Goreng Seafood', 38000.00, 'Makanan'),
(3, 'Sup Ayam Kampung', 30000.00, 'Makanan'),
(4, 'Es Teh Manis', 8000.00, 'Minuman'),
(5, 'Jus Jeruk Segar', 15000.00, 'Minuman');
