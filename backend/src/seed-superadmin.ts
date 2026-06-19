import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function seedSuperAdmin() {
  console.log('Menyiapkan akun Super Admin...');
  
  const email = 'superadmin@hotel.com';
  const rawPassword = 'password123';
  const hashedPassword = await bcrypt.hash(rawPassword, 10);
  
  try {
    const existingAdmin = await prisma.pegawai.findUnique({
      where: { email }
    });

    if (existingAdmin) {
      console.log(`Akun ${email} sudah ada. Memperbarui password...`);
      await prisma.pegawai.update({
        where: { email },
        data: { password: hashedPassword, jabatan: 'Admin' }
      });
      console.log(`Password untuk ${email} berhasil di-reset menjadi 'password123'.`);
    } else {
      await prisma.pegawai.create({
        data: {
          nama_pegawai: 'Super Administrator',
          jabatan: 'Admin',
          no_telepon: '080000000000',
          email: email,
          is_active: true,
          password: hashedPassword
        }
      });
      console.log(`Akun Super Admin berhasil dibuat!`);
      console.log(`Email: ${email}`);
      console.log(`Password: ${rawPassword}`);
      console.log(`Hash bcrypt: ${hashedPassword}`);
    }
  } catch (error) {
    console.error('Gagal membuat akun Super Admin:', error);
  } finally {
    await prisma.$disconnect();
  }
}

seedSuperAdmin();
