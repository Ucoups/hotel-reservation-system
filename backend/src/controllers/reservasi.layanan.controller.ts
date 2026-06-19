import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Ambil semua master data layanan tambahan
export const getMasterLayanan = async (_req: Request, res: Response) => {
  try {
    const layananList = await prisma.layanan_tambahan.findMany({
      orderBy: {
        nama_layanan: 'asc'
      }
    });

    return res.status(200).json({
      success: true,
      data: layananList
    });
  } catch (error: any) {
    console.error('Error saat mengambil data master layanan:', error);
    return res.status(500).json({ success: false, message: 'Gagal mengambil data layanan tambahan.', error: error.message });
  }
};

// Pesan layanan tambahan untuk kamar yang sedang di-booking
export const pesanLayanan = async (req: Request, res: Response) => {
  const { id_kamar, id_layanan, jumlah } = req.body;

  if (!id_kamar || !id_layanan || !jumlah) {
    return res.status(400).json({ success: false, message: 'Field id_kamar, id_layanan, dan jumlah harus diisi.' });
  }

  try {
    // 1. Cari reservasi yang sedang aktif di kamar tersebut
    const reservasiAktif = await prisma.$queryRaw<{id_reservasi: any}[]>`
      SELECT r.id_reservasi FROM detail_reservasi dr
      JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
      WHERE dr.id_kamar = ${Number(id_kamar)} AND r.status_reservasi = 'Check-in'
      LIMIT 1
    `;

    if (reservasiAktif.length === 0) {
      return res.status(400).json({ success: false, message: 'Kamar tersebut tidak sedang dalam status Check-In.' });
    }

    const idReservasi = Number(reservasiAktif[0].id_reservasi);

    // 2. Ambil harga layanan dari master
    const layananMaster = await prisma.layanan_tambahan.findUnique({
      where: { id_layanan: Number(id_layanan) }
    });

    if (!layananMaster) {
      return res.status(404).json({ success: false, message: 'Layanan tambahan tidak ditemukan.' });
    }

    const qty = Number(jumlah);
    const harga = Number(layananMaster.harga);
    const totalHarga = harga * qty;

    // 3. Insert ke detail_layanan_kamar
    const pesananBaru = await prisma.detail_layanan_kamar.create({
      data: {
        id_reservasi: idReservasi,
        id_layanan: Number(id_layanan),
        jumlah: qty,
        total_harga: totalHarga
      }
    });

    // Catat log aktivitas
    await prisma.log_aktivitas.create({
      data: {
        id_pegawai: 1, // Default admin/superadmin
        aktivitas: 'Tambah Layanan',
        keterangan: `Layanan ekstra [${layananMaster.nama_layanan}] sebanyak ${qty} ditambahkan ke Reservasi ID ${idReservasi} (Tagihan: Rp${totalHarga.toLocaleString('id-ID')}).`
      }
    });

    return res.status(201).json({
      success: true,
      message: 'Layanan ekstra berhasil dipesan.',
      data: pesananBaru
    });

  } catch (error: any) {
    console.error('Error saat memesan layanan:', error);
    return res.status(500).json({ success: false, message: 'Gagal memesan layanan tambahan.', error: error.message });
  }
};
