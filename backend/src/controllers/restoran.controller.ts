import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * GET /api/restoran/menu
 * Mengambil daftar seluruh menu makanan dan minuman.
 */
export const getMenu = async (_req: Request, res: Response) => {
  try {
    const menuList = await prisma.menu_restoran.findMany({
      orderBy: { id_menu: 'asc' }
    });

    return res.status(200).json({
      success: true,
      count: menuList.length,
      data: menuList
    });
  } catch (error: any) {
    console.error('Error saat mengambil menu restoran:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal mengambil daftar menu restoran.',
      error: error.message
    });
  }
};

/**
 * POST /api/restoran/order-to-room
 * Memproses pesanan makanan/minuman dan digabungkan ke tagihan kamar aktif (Charge-to-Room).
 */
export const orderToRoom = async (req: Request, res: Response) => {
  const { id_kamar, items } = req.body;

  // Validasi input
  if (!id_kamar || !items || !Array.isArray(items) || items.length === 0) {
    return res.status(400).json({
      success: false,
      message: 'ID Kamar dan daftar item pesanan (array) wajib disediakan.'
    });
  }

  try {
    // 1. Validasi status kamar harus 'Terisi' (Occupied)
    const kamar = await prisma.kamar.findUnique({
      where: { id_kamar: Number(id_kamar) }
    });

    if (!kamar) {
      return res.status(404).json({
        success: false,
        message: 'Kamar tidak ditemukan.'
      });
    }

    if (kamar.status_kamar !== 'Terisi') {
      return res.status(400).json({
        success: false,
        message: `Kamar ${kamar.nomor_kamar} tidak berstatus Terisi (Occupied). Fitur Charge-to-Room hanya dapat digunakan oleh tamu yang sedang menginap.`
      });
    }

    // 2. Cari ID Reservasi aktif yang terhubung dengan kamar ini dan berstatus 'Check-in'
    const activeRes = await prisma.reservasi.findFirst({
      where: {
        status_reservasi: 'Check_in',
        detail_reservasi: {
          some: {
            id_kamar: kamar.id_kamar
          }
        }
      }
    });

    if (!activeRes) {
      return res.status(404).json({
        success: false,
        message: `Tidak ada reservasi aktif berstatus Check-in untuk Kamar ${kamar.nomor_kamar}.`
      });
    }

    // 3. Jalankan transaksi Prisma untuk memasukkan pesanan dan mencatat log
    const orderResults = await prisma.$transaction(async (tx) => {
      const orders = [];

      for (const item of items) {
        // Cari menu untuk memvalidasi harga
        const menu = await tx.menu_restoran.findUnique({
          where: { id_menu: Number(item.id_menu) }
        });

        if (!menu) {
          throw new Error(`Menu dengan ID ${item.id_menu} tidak ditemukan.`);
        }

        if (!menu.isTersedia) {
          throw new Error(`Menu ${menu.nama_menu} sedang tidak tersedia (habis).`);
        }

        const totalHarga = Number(menu.harga) * Number(item.jumlah);

        // Masukkan data pesanan
        const newOrder = await tx.pesanan_restoran.create({
          data: {
            id_reservasi: activeRes.id_reservasi,
            id_menu: menu.id_menu,
            jumlah: Number(item.jumlah),
            total_harga: totalHarga,
            status_bayar: 'Charge_to_Room'
          }
        });

        // Catat aktivitas ke log
        await tx.log_aktivitas.create({
          data: {
            id_pegawai: 1, // Anggap resepsionis sistem
            aktivitas: 'Order Restoran',
            keterangan: `Pesanan F&B [${menu.nama_menu}] sebanyak ${item.jumlah} porsi berhasil digabungkan ke Kamar ${kamar.nomor_kamar} (Tagihan: Rp${totalHarga.toLocaleString('id-ID')}).`
          }
        });

        orders.push({
          id_pesanan: newOrder.id_pesanan,
          nama_menu: menu.nama_menu,
          jumlah: newOrder.jumlah,
          total_harga: Number(newOrder.total_harga)
        });
      }

      return orders;
    });

    return res.status(200).json({
      success: true,
      message: `Pesanan berhasil digabungkan ke tagihan Kamar ${kamar.nomor_kamar}!`,
      data: orderResults
    });

  } catch (error: any) {
    console.error('Error saat memproses order to room:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal memproses pesanan F&B ke kamar.',
      error: error.message
    });
  }
};
