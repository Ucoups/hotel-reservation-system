USE hotel_reservation_db;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_hitung_total_reservasi //

CREATE PROCEDURE sp_hitung_total_reservasi(
    IN p_id_reservasi INT,
    OUT p_total_biaya DECIMAL(12,2)
)
BEGIN
    SELECT COALESCE(SUM(subtotal), 0)
    INTO p_total_biaya
    FROM detail_reservasi
    WHERE id_reservasi = p_id_reservasi;
END //

DELIMITER ;

-- Contoh penggunaan:
-- CALL sp_hitung_total_reservasi(1, @total);
-- SELECT @total AS total_biaya_reservasi;

