import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const layananDefault: any[] = [
    { nama_layanan: 'Pembersihan Kamar Ekstra', harga: 50000, tipe_charge: 'PER_SEKALI_AKSI' },
    { nama_layanan: 'Sewa Kasur Tambahan', harga: 150000, tipe_charge: 'PER_HARI' },
    { nama_layanan: 'Late Check-Out', harga: 100000, tipe_charge: 'PER_JAM' },
  ];

  for (const layanan of layananDefault) {
    const exists = await prisma.layanan_tambahan.findUnique({
      where: { nama_layanan: layanan.nama_layanan }
    });

    if (!exists) {
      await prisma.layanan_tambahan.create({
        data: layanan
      });
      console.log(`Berhasil menambahkan layanan: ${layanan.nama_layanan}`);
    } else {
      await prisma.layanan_tambahan.update({
        where: { id_layanan: exists.id_layanan },
        data: layanan
      });
      console.log(`Berhasil memperbarui layanan: ${layanan.nama_layanan}`);
    }
  }

  console.log('Seeding selesai!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
