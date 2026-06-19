import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * GET /api/admin/laporan-omset
 * Mengambil tren pendapatan bulanan beserta metrik KPI utama (Total Omset, Kamar Terlaris, Rasio Okupansi).
 */
export const getLaporanOmset = async (_req: Request, res: Response) => {
  try {
    // 1. Ambil data tren bulanan dengan kueri CTE
    const monthlyOmset = await prisma.$queryRaw<any[]>`
      WITH PendapatanBulanan AS (
          SELECT 
              DATE_FORMAT(tanggal_pembayaran, '%Y-%m') AS periode,
              SUM(jumlah_bayar) AS total_omset,
              COUNT(id_pembayaran) AS total_transaksi
          FROM pembayaran
          WHERE status_pembayaran = 'Lunas'
          GROUP BY DATE_FORMAT(tanggal_pembayaran, '%Y-%m')
      )
      SELECT 
          periode,
          total_transaksi,
          total_omset,
          CONCAT('Rp', FORMAT(total_omset, 0, 'id_ID')) AS omset_bersih_bulanan
      FROM PendapatanBulanan
      ORDER BY periode DESC;
    `;

    const monthlyOmsetClean = monthlyOmset.map(row => ({
      periode: row.periode,
      total_transaksi: Number(row.total_transaksi),
      total_omset: Number(row.total_omset),
      omset_bersih_bulanan: row.omset_bersih_bulanan
    }));

    // 2. Hitung KPI Card: Total Omset (Lunas)
    const totalOmsetRes = await prisma.$queryRaw<any[]>`
      SELECT SUM(jumlah_bayar) AS total FROM pembayaran WHERE status_pembayaran = 'Lunas';
    `;
    const totalOmset = Number(totalOmsetRes[0]?.total || 0);

    // 3. Hitung KPI Card: Kamar Terlaris
    const kamarTerlarisRes = await prisma.$queryRaw<any[]>`
      SELECT 
          tk.nama_tipe,
          COUNT(dr.id_kamar) AS total_kali_dipesan
      FROM detail_reservasi dr
      JOIN kamar k ON dr.id_kamar = k.id_kamar
      JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar
      GROUP BY tk.id_tipe_kamar, tk.nama_tipe
      ORDER BY total_kali_dipesan DESC
      LIMIT 1;
    `;
    const kamarTerlaris = kamarTerlarisRes[0]?.nama_tipe || '-';

    // 4. Hitung KPI Card: Rasio Okupansi Kamar Saat Ini (%)
    const okupansiRes = await prisma.$queryRaw<any[]>`
      SELECT 
        (SELECT COUNT(*) FROM kamar WHERE status_kamar = 'Terisi') / 
        (SELECT COUNT(*) FROM kamar) * 100 AS rasio;
    `;
    const rasioOkupansi = Number(okupansiRes[0]?.rasio || 0);

    return res.status(200).json({
      success: true,
      kpi: {
        total_omset: totalOmset,
        kamar_terlaris: kamarTerlaris,
        rasio_okupansi: Number(rasioOkupansi.toFixed(1))
      },
      data: monthlyOmsetClean
    });
  } catch (error: any) {
    console.error('Error saat menarik data laporan omset:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal mengambil data laporan omset dari database.',
      error: error.message
    });
  }
};

/**
 * GET /api/admin/performa-staf
 * Mengambil rekapitulasi performa staf operasional (jumlah reservasi, check-in, check-out) dari view.
 */
export const getPerformaStaf = async (_req: Request, res: Response) => {
  try {
    // Menarik data produktivitas staf langsung dari database view
    const rawStaf = await prisma.$queryRawUnsafe<any[]>(
      'SELECT * FROM vw_performa_staf_operasional;'
    );

    const data = rawStaf.map(row => ({
      id_pegawai: Number(row.id_pegawai),
      nama_pegawai: row.nama_pegawai,
      jabatan: row.jabatan,
      jumlah_handle_reservasi: Number(row.jumlah_handle_reservasi),
      jumlah_handle_checkin: Number(row.jumlah_handle_checkin),
      jumlah_handle_checkout: Number(row.jumlah_handle_checkout)
    }));

    return res.status(200).json({
      success: true,
      count: data.length,
      data
    });
  } catch (error: any) {
    console.error('Error saat menarik data performa staf:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal mengambil data performa staf dari database.',
      error: error.message
    });
  }
};

/**
 * GET /api/admin/logs
 * Mengambil 50 log audit trail terbaru beserta nama staf/pegawai yang memicunya.
 */
export const getAuditLogs = async (_req: Request, res: Response) => {
  try {
    const logs = await prisma.log_aktivitas.findMany({
      include: {
        pegawai: {
          select: {
            nama_pegawai: true,
            jabatan: true
          }
        }
      },
      orderBy: {
        waktu_aktivitas: 'desc'
      },
      take: 50
    });

    return res.status(200).json({
      success: true,
      data: logs
    });
  } catch (error: any) {
    console.error('Error saat mengambil data log audit:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal mengambil log aktivitas.',
      error: error.message
    });
  }
};

/**
 * POST /api/admin/night-audit
 * Mensimulasikan penutupan buku harian finansial hotel dengan membekukan transaksi hari ini
 * dan menjumlahkan seluruh pendapatan (Kamar, Restoran, Ekstra).
 */
export const runNightAudit = async (req: Request, res: Response) => {
  const id_pegawai = Number(req.body.id_pegawai) || 1;

  try {
    const result = await prisma.$transaction(async (tx) => {
      // 1. Hitung total pembayaran kamar hari ini (Lunas)
      const pembayaranKamar = await tx.$queryRaw<any[]>`
        SELECT COALESCE(SUM(jumlah_bayar), 0) AS total 
        FROM pembayaran 
        WHERE DATE(tanggal_pembayaran) = CURDATE() AND status_pembayaran = 'Lunas';
      `;
      const roomRevenue = Number(pembayaranKamar[0]?.total || 0);

      // 2. Hitung total pesanan restoran hari ini
      const pesananRestoran = await tx.$queryRaw<any[]>`
        SELECT COALESCE(SUM(total_harga), 0) AS total 
        FROM pesanan_restoran 
        WHERE DATE(waktu_pesan) = CURDATE();
      `;
      const restaurantRevenue = Number(pesananRestoran[0]?.total || 0);

      // 3. Hitung total layanan tambahan hari ini
      const layananTambahan = await tx.$queryRaw<any[]>`
        SELECT COALESCE(SUM(total_harga), 0) AS total 
        FROM detail_layanan_kamar 
        WHERE DATE(waktu_pesan) = CURDATE();
      `;
      const servicesRevenue = Number(layananTambahan[0]?.total || 0);

      const totalRevenue = roomRevenue + restaurantRevenue + servicesRevenue;

      // 4. Catat aktivitas Night Audit ke log
      const keterangan = `Night Audit dijalankan: Kamar: Rp${roomRevenue.toLocaleString('id-ID')}, Restoran: Rp${restaurantRevenue.toLocaleString('id-ID')}, Layanan Tambahan: Rp${servicesRevenue.toLocaleString('id-ID')}. Total Pendapatan Harian: Rp${totalRevenue.toLocaleString('id-ID')}.`;
      
      await tx.log_aktivitas.create({
        data: {
          id_pegawai,
          aktivitas: 'Night Audit',
          keterangan
        }
      });

      return {
        roomRevenue,
        restaurantRevenue,
        servicesRevenue,
        totalRevenue,
        keterangan
      };
    });

    return res.status(200).json({
      success: true,
      message: 'Night Audit berhasil dijalankan.',
      data: result
    });
  } catch (error: any) {
    console.error('Error saat menjalankan Night Audit:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal menjalankan Night Audit.',
      error: error.message
    });
  }
};

