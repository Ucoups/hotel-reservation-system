import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getSemuaKamar = async (_req: Request, res: Response) => {
  try {
    const kamarList = await prisma.kamar.findMany({
      include: {
        tipe_kamar: true
      },
      orderBy: {
        nomor_kamar: 'asc'
      }
    });

    return res.status(200).json({
      success: true,
      data: kamarList
    });
  } catch (error: any) {
    console.error('Error saat mengambil data kamar:', error);
    return res.status(500).json({ success: false, message: 'Gagal mengambil data kamar.', error: error.message });
  }
};

export const getTipeKamar = async (_req: Request, res: Response) => {
  try {
    const tipeKamarList = await prisma.tipe_kamar.findMany({
      orderBy: {
        nama_tipe: 'asc'
      }
    });

    return res.status(200).json({
      success: true,
      data: tipeKamarList
    });
  } catch (error: any) {
    console.error('Error saat mengambil data tipe kamar:', error);
    return res.status(500).json({ success: false, message: 'Gagal mengambil data tipe kamar.', error: error.message });
  }
};

export const tambahKamar = async (req: Request, res: Response) => {
  const { nomor_kamar, lantai, id_tipe_kamar } = req.body;

  if (!nomor_kamar || !lantai || !id_tipe_kamar) {
    return res.status(400).json({ success: false, message: 'Semua field (nomor_kamar, lantai, id_tipe_kamar) harus diisi.' });
  }

  try {
    // Cek apakah nomor kamar sudah ada
    const existing = await prisma.kamar.findUnique({
      where: { nomor_kamar }
    });

    if (existing) {
      return res.status(400).json({ success: false, message: 'Nomor kamar sudah terdaftar.' });
    }

    const kamarBaru = await prisma.kamar.create({
      data: {
        nomor_kamar,
        lantai,
        id_tipe_kamar: Number(id_tipe_kamar)
      }
    });

    return res.status(201).json({
      success: true,
      message: 'Kamar berhasil ditambahkan.',
      data: kamarBaru
    });
  } catch (error: any) {
    console.error('Error saat menambahkan kamar:', error);
    return res.status(500).json({ success: false, message: 'Gagal menambahkan kamar.', error: error.message });
  }
};

export const updateKamar = async (req: Request, res: Response) => {
  const id_kamar = Number(req.params.id);
  const { nomor_kamar, lantai, id_tipe_kamar } = req.body;

  if (!nomor_kamar || !lantai || !id_tipe_kamar) {
    return res.status(400).json({ success: false, message: 'Semua field (nomor_kamar, lantai, id_tipe_kamar) harus diisi.' });
  }

  try {
    // Cek konflik nomor kamar dengan kamar lain
    const existing = await prisma.kamar.findFirst({
      where: { 
        nomor_kamar,
        NOT: { id_kamar }
      }
    });

    if (existing) {
      return res.status(400).json({ success: false, message: 'Nomor kamar sudah digunakan oleh kamar lain.' });
    }

    const kamarUpdated = await prisma.kamar.update({
      where: { id_kamar },
      data: {
        nomor_kamar,
        lantai,
        id_tipe_kamar: Number(id_tipe_kamar)
      }
    });

    return res.status(200).json({
      success: true,
      message: 'Kamar berhasil diperbarui.',
      data: kamarUpdated
    });
  } catch (error: any) {
    console.error('Error saat memperbarui kamar:', error);
    return res.status(500).json({ success: false, message: 'Gagal memperbarui kamar.', error: error.message });
  }
};

export const hapusKamar = async (req: Request, res: Response) => {
  const id_kamar = Number(req.params.id);

  try {
    const kamar = await prisma.kamar.findUnique({
      where: { id_kamar }
    });

    if (!kamar) {
      return res.status(404).json({ success: false, message: 'Kamar tidak ditemukan.' });
    }

    if (kamar.status_kamar === 'Terisi' || kamar.status_kamar === 'Dipesan') {
      return res.status(400).json({ success: false, message: `Kamar tidak dapat dihapus karena berstatus '${kamar.status_kamar}'.` });
    }

    await prisma.kamar.delete({
      where: { id_kamar }
    });

    return res.status(200).json({
      success: true,
      message: 'Kamar berhasil dihapus.'
    });
  } catch (error: any) {
    console.error('Error saat menghapus kamar:', error);
    return res.status(500).json({ success: false, message: 'Gagal menghapus kamar. Pastikan tidak ada data yang terkait dengan kamar ini.', error: error.message });
  }
};
