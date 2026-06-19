import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Ambil daftar kamar kotor / tugas housekeeping aktif
export const getTugasAktif = async (_req: Request, res: Response) => {
  try {
    const tugasList = await prisma.tugas_housekeeping.findMany({
      where: {
        status_tugas: {
          in: ['Pending', 'In_Progress']
        }
      },
      include: {
        kamar: {
          include: {
            tipe_kamar: true
          }
        },
        pegawai: true
      },
      orderBy: {
        waktu_dibuat: 'asc'
      }
    });

    return res.status(200).json({
      success: true,
      data: tugasList
    });
  } catch (error: any) {
    console.error('Error saat mengambil tugas housekeeping:', error);
    return res.status(500).json({ success: false, message: 'Gagal mengambil data tugas housekeeping.', error: error.message });
  }
};

// Mulai membersihkan kamar
export const mulaiTugas = async (req: Request, res: Response) => {
  const id_tugas = Number(req.params.id);
  const id_pegawai = req.user?.id_pegawai; // Diambil dari middleware auth JWT

  if (!id_pegawai) {
    return res.status(401).json({ success: false, message: 'ID Pegawai tidak ditemukan dalam token.' });
  }

  try {
    const tugas = await prisma.tugas_housekeeping.findUnique({
      where: { id_tugas }
    });

    if (!tugas) {
      return res.status(404).json({ success: false, message: 'Tugas tidak ditemukan.' });
    }

    if (tugas.status_tugas !== 'Pending') {
      return res.status(400).json({ success: false, message: 'Tugas ini sudah diambil atau selesai.' });
    }

    const tugasUpdated = await prisma.tugas_housekeeping.update({
      where: { id_tugas },
      data: {
        id_pegawai: id_pegawai,
        status_tugas: 'In_Progress',
        waktu_mulai: new Date()
      }
    });

    return res.status(200).json({
      success: true,
      message: 'Tugas berhasil dimulai.',
      data: tugasUpdated
    });
  } catch (error: any) {
    console.error('Error saat memulai tugas housekeeping:', error);
    return res.status(500).json({ success: false, message: 'Gagal memulai tugas housekeeping.', error: error.message });
  }
};

// Selesai membersihkan kamar
export const selesaikanTugas = async (req: Request, res: Response) => {
  const id_tugas = Number(req.params.id);

  try {
    const tugas = await prisma.tugas_housekeeping.findUnique({
      where: { id_tugas }
    });

    if (!tugas) {
      return res.status(404).json({ success: false, message: 'Tugas tidak ditemukan.' });
    }

    if (tugas.status_tugas !== 'In_Progress') {
      return res.status(400).json({ success: false, message: 'Tugas ini harus dalam status In_Progress untuk dapat diselesaikan.' });
    }

    // Gunakan transaksi untuk update status tugas dan status kamar sekaligus
    await prisma.$transaction([
      prisma.tugas_housekeeping.update({
        where: { id_tugas },
        data: {
          status_tugas: 'Completed',
          waktu_selesai: new Date()
        }
      }),
      prisma.kamar.update({
        where: { id_kamar: tugas.id_kamar },
        data: {
          status_kamar: 'Tersedia'
        }
      })
    ]);

    return res.status(200).json({
      success: true,
      message: 'Tugas berhasil diselesaikan. Kamar kini kembali Tersedia.'
    });
  } catch (error: any) {
    console.error('Error saat menyelesaikan tugas housekeeping:', error);
    return res.status(500).json({ success: false, message: 'Gagal menyelesaikan tugas housekeeping.', error: error.message });
  }
};
