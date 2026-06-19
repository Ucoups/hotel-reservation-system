import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const prisma = new PrismaClient();
const JWT_SECRET = process.env.JWT_SECRET || 'supersecretjwtkey_hotel_2026';

export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email dan password harus diisi.' });
  }

  try {
    const pegawai = await prisma.pegawai.findUnique({
      where: { email }
    });

    if (!pegawai || !pegawai.password) {
      return res.status(401).json({ success: false, message: 'Kredensial tidak valid.' });
    }

    if (!pegawai.is_active) {
      return res.status(403).json({ success: false, message: 'Akun dinonaktifkan.' });
    }

    const isMatch = await bcrypt.compare(password, pegawai.password);

    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Kredensial tidak valid.' });
    }

    // Buat JWT Token
    const payload = {
      id_pegawai: pegawai.id_pegawai,
      email: pegawai.email,
      jabatan: pegawai.jabatan
    };

    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1d' });

    return res.status(200).json({
      success: true,
      message: 'Login berhasil.',
      token,
      user: payload
    });
  } catch (error: any) {
    console.error('Error saat login:', error);
    return res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server.', error: error.message });
  }
};
