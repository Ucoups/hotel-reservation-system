USE hotel_reservation_db;

-- =============================================================================
-- SECTION 1: DETEKSI & RE-INITIALIZATION TRIGGER
-- =============================================================================
DELIMITER //

DROP TRIGGER IF EXISTS trg_before_detail_reservasi_insert //
DROP TRIGGER IF EXISTS trg_after_detail_reservasi_insert //
DROP TRIGGER IF EXISTS trg_after_checkin_insert //
DROP TRIGGER IF EXISTS trg_after_checkout_insert //
DROP TRIGGER IF EXISTS trg_after_pembayaran_insert //

-- -----------------------------------------------------------------------------
-- TRIGGER 1: BEFORE INSERT ON detail_reservasi
-- Logika Bisnis: Menolak plot kamar jika berstatus 'Perawatan' ATAU jika tanggal 
--                hunian bertabrakan dengan reservasi aktif lain (Anti Double Booking).
-- -----------------------------------------------------------------------------
CREATE TRIGGER trg_before_detail_reservasi_insert
BEFORE INSERT ON detail_reservasi
FOR EACH ROW
BEGIN
    DECLARE v_status_kamar     VARCHAR(20);
    DECLARE v_tanggal_checkin  DATE;
    DECLARE v_tanggal_checkout DATE;
    DECLARE v_jumlah_bentrok   INT DEFAULT 0;

    -- [A] Ambil status riil kamar fisik saat ini
    SELECT status_kamar INTO v_status_kamar
    FROM kamar
    WHERE id_kamar = NEW.id_kamar;

    IF v_status_kamar = 'Perawatan' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'OPERASI DITOLAK: Kamar tidak dapat dipesan karena sedang dalam masa pemeliharaan/Perawatan.';
    END IF;

    -- [B] Ambil batas rentang tanggal hunian dari tabel header (reservasi)
    SELECT tanggal_checkin_rencana, tanggal_checkout_rencana
    INTO v_tanggal_checkin, v_tanggal_checkout
    FROM reservasi
    WHERE id_reservasi = NEW.id_reservasi;

    -- [C] Kalkulasi irisan tanggal untuk mencegah terjadinya double booking
    SELECT COUNT(*) INTO v_jumlah_bentrok
    FROM detail_reservasi dr
    JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
    WHERE dr.id_kamar = NEW.id_kamar
      AND dr.id_reservasi <> NEW.id_reservasi
      AND r.status_reservasi NOT IN ('Dibatalkan', 'Selesai')
      AND r.tanggal_checkin_rencana < v_tanggal_checkout
      AND r.tanggal_checkout_rencana > v_tanggal_checkin;

    IF v_jumlah_bentrok > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'OPERASI DITOLAK: Kamar sudah ter-booking oleh tamu lain pada periode tanggal tersebut.';
    END IF;
END //

-- -----------------------------------------------------------------------------
-- TRIGGER 2: AFTER INSERT ON detail_reservasi
-- Logika Bisnis: Mengubah kamar menjadi 'Dipesan' setelah plot detail valid.
-- -----------------------------------------------------------------------------
CREATE TRIGGER trg_after_detail_reservasi_insert
AFTER INSERT ON detail_reservasi
FOR EACH ROW
BEGIN
    UPDATE kamar
    SET status_kamar = 'Dipesan'
    WHERE id_kamar = NEW.id_kamar
      AND status_kamar = 'Tersedia';
END //

-- -----------------------------------------------------------------------------
-- TRIGGER 3: AFTER INSERT ON checkin
-- Logika Bisnis: Mengubah kamar menjadi 'Terisi' dan status reservasi menjadi 'Check-in'.
-- -----------------------------------------------------------------------------
CREATE TRIGGER trg_after_checkin_insert
AFTER INSERT ON checkin
FOR EACH ROW
BEGIN
    UPDATE kamar k
    JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar
    SET k.status_kamar = 'Terisi'
    WHERE dr.id_reservasi = NEW.id_reservasi;

    UPDATE reservasi
    SET status_reservasi = 'Check-in'
    WHERE id_reservasi = NEW.id_reservasi;
END //

-- -----------------------------------------------------------------------------
-- TRIGGER 4: AFTER INSERT ON checkout
-- Logika Bisnis: Mengembalikan kamar ke status 'Tersedia' & tutup reservasi jadi 'Selesai'.
-- -----------------------------------------------------------------------------
CREATE TRIGGER trg_after_checkout_insert
AFTER INSERT ON checkout
FOR EACH ROW
BEGIN
    UPDATE kamar k
    JOIN detail_reservasi dr ON k.id_kamar = dr.id_kamar
    SET k.status_kamar = 'Tersedia'
    WHERE dr.id_reservasi = NEW.id_reservasi
      AND k.status_kamar <> 'Perawatan';

    UPDATE reservasi
    SET status_reservasi = 'Selesai'
    WHERE id_reservasi = NEW.id_reservasi;
END //

-- -----------------------------------------------------------------------------
-- TRIGGER 5: AFTER INSERT ON pembayaran
-- Logika Bisnis: Audit Trail otomatis yang merekam mutasi uang masuk ke log_aktivitas.
-- -----------------------------------------------------------------------------
CREATE TRIGGER trg_after_pembayaran_insert
AFTER INSERT ON pembayaran
FOR EACH ROW
BEGIN
    INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
    SELECT
        r.id_pegawai,
        'Pembayaran Masuk',
        CONCAT('Pembayaran Sukses untuk Reservasi ID ', NEW.id_reservasi, 
               ' sebesar Rp', FORMAT(NEW.jumlah_bayar, 0, 'id_ID'), 
               ' melalui metode [', NEW.metode_pembayaran, '].')
    FROM reservasi r
    WHERE r.id_reservasi = NEW.id_reservasi;
END //

DELIMITER ;


-- =============================================================================
-- SECTION 2: AUTOMATED TESTING SCRIPTS (INTEGRATION VALIDATION)
-- =============================================================================

-- Skenario 0: Pembersihan Total Data Pengujian Sebelumnya (Mencegah Duplicate Key)
SET SQL_SAFE_UPDATES = 0;

DELETE FROM log_aktivitas WHERE keterangan LIKE '%Reservasi ID 91%';
DELETE FROM checkout WHERE id_reservasi IN (911, 912, 913);
DELETE FROM checkin WHERE id_reservasi IN (911, 912, 913);
DELETE FROM pembayaran WHERE id_reservasi IN (911, 912, 913);
DELETE FROM detail_reservasi WHERE id_reservasi IN (911, 912, 913);
DELETE FROM reservasi WHERE id_reservasi IN (911, 912, 913);

-- Kembalikan status kamar master uji coba ke kondisi default sistem
UPDATE kamar SET status_kamar = 'Tersedia' WHERE id_kamar IN (1, 4);
UPDATE kamar SET status_kamar = 'Perawatan' WHERE id_kamar = 5;

SET SQL_SAFE_UPDATES = 1;


-- -----------------------------------------------------------------------------
-- KELOMPOK A: PENGUJIAN SKENARIO NEGATIF (UJI COBA PROTEKSI TRIGGER)
-- Catatan Profesional: Blok kode di bawah ini memicu pesan pembatasan data secara sengaja.
-- -----------------------------------------------------------------------------

-- [TEST 1] Proteksi Kamar Rusak/Dalam Pemeliharaan
-- Ekspektasi: Langkah 1 Sukses masuk, Langkah 2 WAJIB GAGAL memunculkan Error 1644 (Kamar Perawatan)
INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
VALUES (911, 3, 2, NOW(), '2026-07-01', '2026-07-03', 'Menunggu');

-- Eksekusi Detail (Akan digagalkan oleh Trigger 1)
INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam)
VALUES (911, 911, 5, 2, 350000.00);


-- [TEST 2] Proteksi Double Booking (Tabrakan Jadwal Kamar)
-- Ekspektasi: Langkah 1 Sukses masuk, Langkah 2 WAJIB GAGAL memunculkan Error 1644 (Tabrakan Tanggal dengan Reservasi ID 1)
INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
VALUES (912, 1, 1, NOW(), '2026-05-11', '2026-05-13', 'Dikonfirmasi');

-- Eksekusi Detail (Akan digagalkan oleh Trigger 1)
INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam)
VALUES (912, 912, 1, 2, 350000.00);


-- -----------------------------------------------------------------------------
-- KELOMPOK B: PENGUJIAN SKENARIO POSITIF (ALUR SIKLUS SUKSES END-TO-END)
-- Catatan Profesional: Blok kode di bawah ini dirancang berjalan linier tanpa eror.
-- -----------------------------------------------------------------------------

-- [TEST 3] Alur Pemesanan (Booking) Kamar yang Tersedia
-- Ekspektasi: Data masuk sempurna dan status kamar otomatis berubah menjadi 'Dipesan'.
INSERT INTO reservasi (id_reservasi, id_tamu, id_pegawai, tanggal_reservasi, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
VALUES (913, 2, 4, NOW(), '2026-08-01', '2026-08-03', 'Dikonfirmasi');

INSERT INTO detail_reservasi (id_detail_reservasi, id_reservasi, id_kamar, jumlah_malam, harga_per_malam)
VALUES (913, 913, 4, 2, 350000.00);

-- ASSERT CHECK 3: Memastikan Kamar 104 berubah status menjadi 'Dipesan' (Efek Trigger 2)
SELECT nomor_kamar, status_kamar FROM kamar WHERE id_kamar = 4;


-- [TEST 4] Simulasi Pembayaran Tagihan Masuk
-- Ekspektasi: Transaksi keuangan tersimpan dan log aktivitas terbuat otomatis dengan rapi.
INSERT INTO pembayaran (id_reservasi, jumlah_bayar, metode_pembayaran, status_pembayaran)
VALUES (913, 700000.00, 'E-Wallet', 'Lunas');

-- ASSERT CHECK 4: Memeriksa rekaman teks audit finansial format Rupiah hasil olahan Trigger 5
SELECT keterangan, waktu_aktivitas FROM log_aktivitas ORDER BY id_log DESC LIMIT 1;


-- [TEST 5] Simulasi Kedatangan Tamu (Proses Check-In)
-- Ekspektasi: Status kamar fisik berubah menjadi 'Terisi' & Status master reservasi berubah menjadi 'Check-in'.
INSERT INTO checkin (id_checkin, id_reservasi, id_pegawai, catatan)
VALUES (913, 913, 4, 'Tamu melakukan check-in, kamar siap digunakan.');

-- ASSERT CHECK 5: Memastikan sinkronisasi status kamar dan data transaksi (Efek Trigger 3)
SELECT nomor_kamar, status_kamar FROM kamar WHERE id_kamar = 4;
SELECT id_reservasi, status_reservasi FROM reservasi WHERE id_reservasi = 913;


-- [TEST 6] Simulasi Tamu Pulang (Proses Check-Out Selesai)
-- Ekspektasi: Kamar otomatis dikosongkan kembali ('Tersedia') & Status master reservasi ditutup dengan status 'Selesai'.
INSERT INTO checkout (id_checkout, id_reservasi, id_pegawai, biaya_tambahan, catatan)
VALUES (913, 913, 2, 0.00, 'Check-out selesai tanpa ada kehilangan fasilitas.');

-- ASSERT CHECK 6: Memastikan kamar telah bersih dan siap disewa kembali oleh pelanggan baru (Efek Trigger 4)
SELECT nomor_kamar, status_kamar FROM kamar WHERE id_kamar = 4;
SELECT id_reservasi, status_reservasi FROM reservasi WHERE id_reservasi = 913;