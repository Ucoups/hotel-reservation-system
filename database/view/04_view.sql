USE hotel_reservation_db;

CREATE OR REPLACE VIEW vw_detail_reservasi_tamu AS
SELECT
    r.id_reservasi,
    t.nama_tamu,
    t.no_telepon,
    k.nomor_kamar,
    tk.nama_tipe,
    r.tanggal_checkin_rencana,
    r.tanggal_checkout_rencana,
    dr.jumlah_malam,
    dr.harga_per_malam,
    dr.subtotal,
    r.status_reservasi
FROM reservasi r
JOIN tamu t ON r.id_tamu = t.id_tamu
JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
JOIN kamar k ON dr.id_kamar = k.id_kamar
JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar;

CREATE OR REPLACE VIEW vw_laporan_pembayaran AS
SELECT
    pb.id_pembayaran,
    r.id_reservasi,
    t.nama_tamu,
    pb.tanggal_pembayaran,
    pb.jumlah_bayar,
    pb.metode_pembayaran,
    pb.status_pembayaran
FROM pembayaran pb
JOIN reservasi r ON pb.id_reservasi = r.id_reservasi
JOIN tamu t ON r.id_tamu = t.id_tamu;

