import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Ambil semua menu restoran
export const getSemuaMenu = async (_req: Request, res: Response) => {
  try {
    const menuList = await prisma.menu_restoran.findMany({
      orderBy: {
        nama_menu: 'asc'
      }
    });

    return res.status(200).json({
      success: true,
      data: menuList
    });
  } catch (error: any) {
    console.error('Error saat mengambil data menu restoran:', error);
    return res.status(500).json({ success: false, message: 'Gagal mengambil data menu restoran.', error: error.message });
  }
};

// Tambah menu baru
export const tambahMenu = async (req: Request, res: Response) => {
  const { nama_menu, harga, kategori, isTersedia } = req.body;

  if (!nama_menu || harga === undefined || !kategori) {
    return res.status(400).json({ success: false, message: 'Field nama_menu, harga, dan kategori harus diisi.' });
  }

  try {
    // Cek duplikasi
    const existing = await prisma.menu_restoran.findUnique({
      where: { nama_menu }
    });

    if (existing) {
      return res.status(400).json({ success: false, message: 'Nama menu sudah terdaftar.' });
    }

    const menuBaru = await prisma.menu_restoran.create({
      data: {
        nama_menu,
        harga,
        kategori,
        isTersedia: isTersedia !== undefined ? isTersedia : true
      }
    });

    return res.status(201).json({
      success: true,
      message: 'Menu berhasil ditambahkan.',
      data: menuBaru
    });
  } catch (error: any) {
    console.error('Error saat menambahkan menu:', error);
    return res.status(500).json({ success: false, message: 'Gagal menambahkan menu.', error: error.message });
  }
};

// Update menu
export const updateMenu = async (req: Request, res: Response) => {
  const id_menu = Number(req.params.id);
  const { nama_menu, harga, kategori, isTersedia } = req.body;

  if (!nama_menu || harga === undefined || !kategori) {
    return res.status(400).json({ success: false, message: 'Field nama_menu, harga, dan kategori harus diisi.' });
  }

  try {
    const existing = await prisma.menu_restoran.findFirst({
      where: { 
        nama_menu,
        NOT: { id_menu }
      }
    });

    if (existing) {
      return res.status(400).json({ success: false, message: 'Nama menu sudah digunakan oleh menu lain.' });
    }

    const menuUpdated = await prisma.menu_restoran.update({
      where: { id_menu },
      data: {
        nama_menu,
        harga,
        kategori,
        isTersedia
      }
    });

    return res.status(200).json({
      success: true,
      message: 'Menu berhasil diperbarui.',
      data: menuUpdated
    });
  } catch (error: any) {
    console.error('Error saat memperbarui menu:', error);
    return res.status(500).json({ success: false, message: 'Gagal memperbarui menu.', error: error.message });
  }
};

// Hapus menu
export const hapusMenu = async (req: Request, res: Response) => {
  const id_menu = Number(req.params.id);

  try {
    const menu = await prisma.menu_restoran.findUnique({
      where: { id_menu }
    });

    if (!menu) {
      return res.status(404).json({ success: false, message: 'Menu tidak ditemukan.' });
    }

    await prisma.menu_restoran.delete({
      where: { id_menu }
    });

    return res.status(200).json({
      success: true,
      message: 'Menu berhasil dihapus.'
    });
  } catch (error: any) {
    console.error('Error saat menghapus menu:', error);
    return res.status(500).json({ success: false, message: 'Gagal menghapus menu. Pastikan tidak ada pesanan yang menggunakan menu ini.', error: error.message });
  }
};
