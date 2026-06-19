import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  await prisma.$executeRawUnsafe(`
    CREATE OR REPLACE VIEW vw_status_kamar_opsional AS
    SELECT 
        k.id_kamar,
        k.nomor_kamar,
        k.lantai,
        t.nama_tipe,
        t.harga_per_malam,
        k.status_kamar,
        COALESCE(
            (SELECT ta.nama_tamu 
             FROM reservasi r
             JOIN tamu ta ON r.id_tamu = ta.id_tamu
             JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
             WHERE dr.id_kamar = k.id_kamar AND r.status_reservasi = 'Check-in'
             LIMIT 1), 
            '-'
        ) AS nama_tamu_sekarang,
        COALESCE(
            (SELECT SUM(pr.total_harga)
             FROM pesanan_restoran pr
             JOIN reservasi r ON pr.id_reservasi = r.id_reservasi
             JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
             WHERE dr.id_kamar = k.id_kamar 
               AND r.status_reservasi = 'Check-in'
               AND pr.status_bayar = 'Charge-to-Room'),
            0
        ) AS tagihan_restoran,
        COALESCE(
            (SELECT SUM(dlk.total_harga)
             FROM detail_layanan_kamar dlk
             JOIN reservasi r ON dlk.id_reservasi = r.id_reservasi
             JOIN detail_reservasi dr ON r.id_reservasi = dr.id_reservasi
             WHERE dr.id_kamar = k.id_kamar 
               AND r.status_reservasi = 'Check-in'),
            0
        ) AS tagihan_layanan_tambahan
    FROM kamar k
    JOIN tipe_kamar t ON k.id_tipe_kamar = t.id_tipe_kamar;
  `);

  console.log('View vw_status_kamar_opsional berhasil diupdate!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
