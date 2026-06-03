USE hotel_reservation_db;

DELIMITER //

DROP FUNCTION IF EXISTS fn_hitung_total_biaya //

CREATE FUNCTION fn_hitung_total_biaya(
    p_harga_per_malam DECIMAL(12,2),
    p_jumlah_malam INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN COALESCE(p_harga_per_malam, 0) * COALESCE(p_jumlah_malam, 0);
END //

DELIMITER ;

-- Contoh:
-- SELECT fn_hitung_total_biaya(550000, 3) AS total_biaya;

