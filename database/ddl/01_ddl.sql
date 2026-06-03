CREATE DATABASE IF NOT EXISTS hotel_reservation_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hotel_reservation_db;

DROP TABLE IF EXISTS log_aktivitas;
DROP TABLE IF EXISTS kamar_fasilitas;
DROP TABLE IF EXISTS checkout;
DROP TABLE IF EXISTS checkin;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_reservasi;
DROP TABLE IF EXISTS reservasi;
DROP TABLE IF EXISTS kamar;
DROP TABLE IF EXISTS fasilitas;
DROP TABLE IF EXISTS tipe_kamar;
DROP TABLE IF EXISTS pegawai;
DROP TABLE IF EXISTS tamu;

CREATE TABLE tamu (
    id_tamu INT AUTO_INCREMENT PRIMARY KEY,
    nama_tamu VARCHAR(100) NOT NULL,
    no_identitas VARCHAR(30) NOT NULL UNIQUE,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan') NOT NULL,
    no_telepon VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    alamat TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE pegawai (
    id_pegawai INT AUTO_INCREMENT PRIMARY KEY,
    nama_pegawai VARCHAR(100) NOT NULL,
    jabatan VARCHAR(50) NOT NULL,
    no_telepon VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE tipe_kamar (
    id_tipe_kamar INT AUTO_INCREMENT PRIMARY KEY,
    nama_tipe VARCHAR(50) NOT NULL UNIQUE,
    kapasitas INT NOT NULL CHECK (kapasitas > 0),
    harga_per_malam DECIMAL(12,2) NOT NULL CHECK (harga_per_malam >= 0),
    deskripsi TEXT
) ENGINE=InnoDB;

CREATE TABLE fasilitas (
    id_fasilitas INT AUTO_INCREMENT PRIMARY KEY,
    nama_fasilitas VARCHAR(80) NOT NULL UNIQUE,
    deskripsi TEXT
) ENGINE=InnoDB;

CREATE TABLE kamar (
    id_kamar INT AUTO_INCREMENT PRIMARY KEY,
    id_tipe_kamar INT NOT NULL,
    nomor_kamar VARCHAR(10) NOT NULL UNIQUE,
    lantai VARCHAR(10) NOT NULL,
    status_kamar ENUM('Tersedia', 'Dipesan', 'Terisi', 'Perawatan') NOT NULL DEFAULT 'Tersedia',
    CONSTRAINT fk_kamar_tipe FOREIGN KEY (id_tipe_kamar) REFERENCES tipe_kamar(id_tipe_kamar)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_kamar_tipe (id_tipe_kamar),
    INDEX idx_kamar_status (status_kamar)
) ENGINE=InnoDB;

CREATE TABLE reservasi (
    id_reservasi INT AUTO_INCREMENT PRIMARY KEY,
    id_tamu INT NOT NULL,
    id_pegawai INT NOT NULL,
    tanggal_reservasi DATE NOT NULL,
    tanggal_checkin_rencana DATE NOT NULL,
    tanggal_checkout_rencana DATE NOT NULL,
    status_reservasi ENUM('Menunggu', 'Dikonfirmasi', 'Check-in', 'Selesai', 'Dibatalkan') NOT NULL DEFAULT 'Menunggu',
    CONSTRAINT fk_reservasi_tamu FOREIGN KEY (id_tamu) REFERENCES tamu(id_tamu)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_reservasi_pegawai FOREIGN KEY (id_pegawai) REFERENCES pegawai(id_pegawai)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tanggal_reservasi CHECK (tanggal_checkout_rencana > tanggal_checkin_rencana),
    INDEX idx_reservasi_tamu (id_tamu),
    INDEX idx_reservasi_pegawai (id_pegawai),
    INDEX idx_reservasi_status (status_reservasi)
) ENGINE=InnoDB;

CREATE TABLE detail_reservasi (
    id_detail_reservasi INT AUTO_INCREMENT PRIMARY KEY,
    id_reservasi INT NOT NULL,
    id_kamar INT NOT NULL,
    jumlah_malam INT NOT NULL CHECK (jumlah_malam > 0),
    harga_per_malam DECIMAL(12,2) NOT NULL CHECK (harga_per_malam >= 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_detail_reservasi FOREIGN KEY (id_reservasi) REFERENCES reservasi(id_reservasi)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_kamar FOREIGN KEY (id_kamar) REFERENCES kamar(id_kamar)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY uk_reservasi_kamar (id_reservasi, id_kamar),
    INDEX idx_detail_kamar (id_kamar)
) ENGINE=InnoDB;

CREATE TABLE pembayaran (
    id_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    id_reservasi INT NOT NULL,
    tanggal_pembayaran DATE NOT NULL,
    jumlah_bayar DECIMAL(12,2) NOT NULL CHECK (jumlah_bayar > 0),
    metode_pembayaran ENUM('Tunai', 'Transfer', 'Kartu Kredit', 'E-Wallet') NOT NULL,
    status_pembayaran ENUM('Pending', 'Lunas', 'Gagal', 'Refund') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_pembayaran_reservasi FOREIGN KEY (id_reservasi) REFERENCES reservasi(id_reservasi)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_pembayaran_reservasi (id_reservasi),
    INDEX idx_pembayaran_status (status_pembayaran)
) ENGINE=InnoDB;

CREATE TABLE checkin (
    id_checkin INT AUTO_INCREMENT PRIMARY KEY,
    id_reservasi INT NOT NULL UNIQUE,
    waktu_checkin DATETIME NOT NULL,
    id_pegawai INT NOT NULL,
    catatan TEXT,
    CONSTRAINT fk_checkin_reservasi FOREIGN KEY (id_reservasi) REFERENCES reservasi(id_reservasi)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_checkin_pegawai FOREIGN KEY (id_pegawai) REFERENCES pegawai(id_pegawai)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE checkout (
    id_checkout INT AUTO_INCREMENT PRIMARY KEY,
    id_reservasi INT NOT NULL UNIQUE,
    waktu_checkout DATETIME NOT NULL,
    id_pegawai INT NOT NULL,
    biaya_tambahan DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (biaya_tambahan >= 0),
    catatan TEXT,
    CONSTRAINT fk_checkout_reservasi FOREIGN KEY (id_reservasi) REFERENCES reservasi(id_reservasi)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_checkout_pegawai FOREIGN KEY (id_pegawai) REFERENCES pegawai(id_pegawai)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE kamar_fasilitas (
    id_kamar INT NOT NULL,
    id_fasilitas INT NOT NULL,
    PRIMARY KEY (id_kamar, id_fasilitas),
    CONSTRAINT fk_kf_kamar FOREIGN KEY (id_kamar) REFERENCES kamar(id_kamar)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_kf_fasilitas FOREIGN KEY (id_fasilitas) REFERENCES fasilitas(id_fasilitas)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE log_aktivitas (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pegawai INT NULL,
    aktivitas VARCHAR(100) NOT NULL,
    waktu_aktivitas DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    keterangan TEXT,
    CONSTRAINT fk_log_pegawai FOREIGN KEY (id_pegawai) REFERENCES pegawai(id_pegawai)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_log_waktu (waktu_aktivitas),
    INDEX idx_log_pegawai (id_pegawai)
) ENGINE=InnoDB;

