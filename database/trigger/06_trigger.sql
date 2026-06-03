USE hotel_reservation_db;

-- =========================================================
-- TRIGGER SISTEM RESERVASI HOTEL
-- DBMS: MySQL 8.0
--
-- Daftar trigger:
-- 1. trg_before_detail_reservasi_insert
--    Mencegah double booking dan menolak kamar Perawatan.
-- 2. trg_after_detail_reservasi_insert
--    Mengubah status kamar menjadi Dipesan setelah kamar masuk detail reservasi.
-- 3. trg_after_checkin_insert
--    Mengubah status kamar menjadi Terisi saat tamu check-in.
-- 4. trg_after_checkout_insert
--    Mengubah status kamar menjadi Tersedia saat tamu check-out.
-- 5. trg_after_pembayaran_insert
--    Mencatat log aktivitas setelah pembayaran masuk.
--
-- Catatan:
-- Status kamar mengikuti ENUM pada DDL:
-- Tersedia, Dipesan, Terisi, Perawatan.
-- =========================================================

DELIMITER //

DROP TRIGGER IF EXISTS trg_before_detail_reservasi_insert //
DROP TRIGGER IF EXISTS trg_after_detail_reservasi_insert //
DROP TRIGGER IF EXISTS trg_after_checkin_insert //
DROP TRIGGER IF EXISTS trg_after_checkout_insert //
DROP TRIGGER IF EXISTS trg_after_pembayaran_insert //

-- =========================================================
-- TRIGGER 1: ANTI DOUBLE BOOKING DAN VALIDASI KAMAR PERAWATAN
-- =========================================================
CREATE TRIGGER trg_before_detail_reservasi_insert
BEFORE INSERT ON detail_reservasi
FOR EACH ROW
BEGIN
    DECLARE v_status_kamar VARCHAR(20);
    DECLARE v_tanggal_checkin DATE;
    DECLARE v_tanggal_checkout DATE;
    DECLARE v_jumlah_bentrok INT DEFAULT 0;

    SELECT status_kamar
    INTO v_status_kamar
    FROM kamar
    WHERE id_kamar = NEW.id_kamar;

    IF v_status_kamar = 'Perawatan' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Reservasi ditolak: kamar sedang dalam status Perawatan.';
    END IF;

    SELECT tanggal_checkin_rencana, tanggal_checkout_rencana
    INTO v_tanggal_checkin, v_tanggal_checkout
    FROM reservasi
    WHERE id_reservasi = NEW.id_reservasi;

    SELECT COUNT(*)
    INTO v_jumlah_bentrok
    FROM detail_reservasi dr
    JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
    WHERE dr.id_kamar = NEW.id_kamar
      AND dr.id_reservasi <> NEW.id_reservasi
      AND r.status_reservasi <> 'Dibatalkan'
      AND r.tanggal_checkin_rencana < v_tanggal_checkout
      AND r.tanggal_checkout_rencana > v_tanggal_checkin;

    IF v_jumlah_bentrok > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Reservasi ditolak: kamar sudah dipesan pada periode tanggal yang bertabrakan.';
    END IF;
END //

-- =========================================================
-- TRIGGER 2: UPDATE STATUS KAMAR SETELAH DETAIL RESERVASI DIBUAT
-- =========================================================
CREATE TRIGGER trg_after_detail_reservasi_insert
AFTER INSERT ON detail_reservasi
FOR EACH ROW
BEGIN
    UPDATE kamar
    SET status_kamar = 'Dipesan'
    WHERE id_kamar = NEW.id_kamar
      AND status_kamar = 'Tersedia';
END //

-- =========================================================
-- TRIGGER 3: UPDATE STATUS KAMAR SAAT CHECK-IN
-- =========================================================
CREATE TRIGGER trg_after_checkin_insert
AFTER INSERT ON checkin
FOR EACH ROW
BEGIN
    UPDATE kamar k
    JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar
    SET k.status_kamar = 'Terisi'
    WHERE dr.id_reservasi = NEW.id_reservasi;
END //

-- =========================================================
-- TRIGGER 4: UPDATE STATUS KAMAR SAAT CHECK-OUT
-- =========================================================
CREATE TRIGGER trg_after_checkout_insert
AFTER INSERT ON checkout
FOR EACH ROW
BEGIN
    UPDATE kamar k
    JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar
    SET k.status_kamar = 'Tersedia'
    WHERE dr.id_reservasi = NEW.id_reservasi
      AND k.status_kamar <> 'Perawatan';
END //

-- =========================================================
-- TRIGGER 5: LOG AKTIVITAS SETELAH PEMBAYARAN MASUK
-- Trigger lama dipertahankan karena masih relevan untuk audit pembayaran.
-- =========================================================
CREATE TRIGGER trg_after_pembayaran_insert
AFTER INSERT ON pembayaran
FOR EACH ROW
BEGIN
    INSERT INTO log_aktivitas (id_pegawai, aktivitas, waktu_aktivitas, keterangan)
    SELECT
        r.id_pegawai,
        'Pembayaran Masuk',
        NOW(),
        CONCAT('Pembayaran reservasi ID ', NEW.id_reservasi, ' sebesar ', NEW.jumlah_bayar, ' dicatat.')
    FROM reservasi r
    WHERE r.id_reservasi = NEW.id_reservasi;
END //

DELIMITER ;

-- =========================================================
-- QUERY UJI TRIGGER
-- Jalankan setelah 01_ddl.sql, 02_dml.sql, dan 06_trigger.sql.
-- Gunakan ID baru agar tidak bentrok dengan data dummy yang sudah ada.
-- =========================================================

-- 1. Uji kamar tidak bisa double booking.
-- Kamar 101 sudah memiliki reservasi ID 1 pada 2026-05-10 sampai 2026-05-12.
-- Insert berikut seharusnya gagal karena periode 2026-05-11 sampai 2026-05-13 bertabrakan.
-- INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
-- VALUES (101, 1, 1, '2026-06-03', '2026-05-11', '2026-05-13', 'Dikonfirmasi');
-- INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam, subtotal)
-- VALUES (101, 101, 1, 2, 350000.00, 700000.00);

-- 2. Uji kamar boleh dipesan setelah periode sebelumnya selesai.
-- Insert berikut seharusnya berhasil karena mulai pada tanggal checkout reservasi sebelumnya.
-- INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
-- VALUES (102, 2, 1, '2026-06-03', '2026-05-12', '2026-05-13', 'Dikonfirmasi');
-- INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam, subtotal)
-- VALUES (102, 102, 1, 1, 350000.00, 350000.00);
-- SELECT nomor_kamar, status_kamar FROM kamar WHERE id_kamar = 1;

-- 3. Uji kamar Perawatan tidak bisa dipesan.
-- Kamar 105 pada data dummy memiliki status Perawatan.
-- Insert detail berikut seharusnya gagal.
-- INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
-- VALUES (103, 3, 2, '2026-06-03', '2026-07-01', '2026-07-03', 'Dikonfirmasi');
-- INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam, subtotal)
-- VALUES (103, 103, 5, 2, 350000.00, 700000.00);

-- 4. Uji status kamar berubah menjadi Terisi saat check-in.
-- INSERT INTO checkin (id_checkin, id_reservasi, waktu_checkin, id_pegawai, catatan)
-- VALUES (101, 102, '2026-05-12 14:00:00', 1, 'Uji trigger check-in.');
-- SELECT nomor_kamar, status_kamar FROM kamar WHERE id_kamar = 1;

-- 5. Uji status kamar kembali Tersedia saat checkout.
-- INSERT INTO checkout (id_checkout, id_reservasi, waktu_checkout, id_pegawai, biaya_tambahan, catatan)
-- VALUES (101, 102, '2026-05-13 11:00:00', 1, 0.00, 'Uji trigger checkout.');
-- SELECT nomor_kamar, status_kamar FROM kamar WHERE id_kamar = 1;

-- 6. Uji trigger log pembayaran lama tetap berjalan.
-- INSERT INTO pembayaran (id_reservasi, tanggal_pembayaran, jumlah_bayar, metode_pembayaran, status_pembayaran)
-- VALUES (102, CURDATE(), 350000.00, 'Transfer', 'Lunas');
-- SELECT * FROM log_aktivitas
-- WHERE aktivitas = 'Pembayaran Masuk'
-- ORDER BY waktu_aktivitas DESC;
