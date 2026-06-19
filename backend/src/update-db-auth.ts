import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('Menambahkan kolom password ke tabel pegawai...');
  
  try {
    // 1. Eksekusi ALTER TABLE
    await prisma.$executeRawUnsafe(`
      ALTER TABLE pegawai 
      ADD COLUMN password VARCHAR(255) NULL
    `);
    console.log('Kolom password berhasil ditambahkan.');
  } catch (error: any) {
    if (error.message.includes('Duplicate column name')) {
      console.log('Kolom password sudah ada.');
    } else {
      console.error('Gagal menambahkan kolom password:', error);
      throw error;
    }
  }

  // 2. Hash default password
  const defaultPassword = 'password123';
  const hashedPassword = await bcrypt.hash(defaultPassword, 10);

  // 3. Update semua pegawai yang password-nya masih NULL
  const count = await prisma.$executeRawUnsafe(`
    UPDATE pegawai 
    SET password = '${hashedPassword}' 
    WHERE password IS NULL
  `);

  console.log(`Berhasil mengupdate ${count} pegawai dengan password default.`);

  // 4. Ubah kolom menjadi NOT NULL setelah semua diisi
  try {
    await prisma.$executeRawUnsafe(`
      ALTER TABLE pegawai 
      MODIFY COLUMN password VARCHAR(255) NOT NULL
    `);
    console.log('Kolom password diubah menjadi NOT NULL.');
  } catch (error) {
    console.error('Gagal mengubah kolom menjadi NOT NULL:', error);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
