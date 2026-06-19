import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * GET /api/dashboard/status-kamar
 * Mengambil data status ketersediaan kamar secara real-time langsung dari database View.
 */
export const getStatusKamar = async (_req: Request, res: Response) => {
  try {
    // Menjalankan query langsung ke view untuk performa yang optimal dan instan
    const kamarStatusList = await prisma.$queryRawUnsafe<any[]>(
      'SELECT * FROM vw_status_kamar_opsional;'
    );

    return res.status(200).json({
      success: true,
      count: kamarStatusList.length,
      data: kamarStatusList
    });
  } catch (error: any) {
    console.error('Error saat menarik data dari view status kamar:', error);
    
    return res.status(500).json({
      success: false,
      message: 'Gagal mengambil data status kamar dari database.',
      error: error.message
    });
  }
};
