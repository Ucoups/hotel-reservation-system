-- 1. Ubah tipe ENUM pada kolom status_kamar
ALTER TABLE kamar 
MODIFY COLUMN status_kamar ENUM('Tersedia', 'Dipesan', 'Terisi', 'Kotor', 'Perawatan') NOT NULL DEFAULT 'Tersedia';

-- 2. Buat tabel tugas_housekeeping
CREATE TABLE IF NOT EXISTS tugas_housekeeping (
  id_tugas INT AUTO_INCREMENT PRIMARY KEY,
  id_kamar INT NOT NULL,
  id_pegawai INT NULL,
  status_tugas ENUM('Pending', 'In_Progress', 'Completed') NOT NULL DEFAULT 'Pending',
  waktu_dibuat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  waktu_mulai DATETIME NULL,
  waktu_selesai DATETIME NULL,
  CONSTRAINT fk_tugas_kamar FOREIGN KEY (id_kamar) REFERENCES kamar(id_kamar) ON DELETE CASCADE,
  CONSTRAINT fk_tugas_pegawai FOREIGN KEY (id_pegawai) REFERENCES pegawai(id_pegawai) ON DELETE SET NULL,
  INDEX idx_tugas_kamar (id_kamar),
  INDEX idx_tugas_status (status_tugas)
) ENGINE=InnoDB;

-- 3. Perbarui Trigger Checkout
DROP TRIGGER IF EXISTS trg_after_checkout_insert;

DELIMITER //
CREATE TRIGGER trg_after_checkout_insert
AFTER INSERT ON checkout
FOR EACH ROW
BEGIN
    -- Ubah status kamar menjadi kotor
    UPDATE kamar k
    JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar
    SET k.status_kamar = 'Kotor'
    WHERE dr.id_reservasi = NEW.id_reservasi
      AND k.status_kamar <> 'Perawatan';

    -- Tutup reservasi
    UPDATE reservasi
    SET status_reservasi = 'Selesai'
    WHERE id_reservasi = NEW.id_reservasi;
    
    -- Insert ke tabel tugas_housekeeping untuk kamar yang baru saja check-out
    INSERT INTO tugas_housekeeping (id_kamar, status_tugas)
    SELECT dr.id_kamar, 'Pending'
    FROM detail_reservasi dr
    WHERE dr.id_reservasi = NEW.id_reservasi;
END //
DELIMITER ;
