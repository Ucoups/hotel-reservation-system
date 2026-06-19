import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * POST /api/reservasi/pembayaran
 * Mencatat pembayaran secara aman menggunakan Stored Procedure database.
 */
export const prosesPembayaran = async (req: Request, res: Response) => {
  const { id_reservasi, jumlah_bayar, metode_pembayaran, id_pegawai } = req.body;

  // Validasi input dasar di backend
  if (!id_reservasi || !jumlah_bayar || !metode_pembayaran || !id_pegawai) {
    return res.status(400).json({
      success: false,
      message: 'Field id_reservasi, jumlah_bayar, metode_pembayaran, dan id_pegawai wajib diisi.'
    });
  }

  try {
    // Menggunakan interactive transaction untuk memastikan kedua query berjalan
    // pada koneksi database yang sama sehingga variabel sesi MySQL (@status_pesan) tetap terjaga.
    const statusPesan = await prisma.$transaction(async (tx) => {
      // 1. Eksekusi Stored Procedure
      await tx.$executeRawUnsafe(
        'CALL sp_proses_pembayaran_aman(?, ?, ?, ?, @status_pesan);',
        Number(id_reservasi),
        Number(jumlah_bayar),
        metode_pembayaran,
        Number(id_pegawai)
      );

      // 2. Ambil nilai OUT parameter @status_pesan dari sesi koneksi yang sama
      const output = await tx.$queryRaw<{ status_pesan: string }[]>`
        SELECT @status_pesan AS status_pesan;
      `;

      return output[0]?.status_pesan || '';
    });

    // Cek apakah output mengandung pesan kegagalan bisnis
    if (statusPesan.startsWith('GAGAL:')) {
      return res.status(400).json({
        success: false,
        message: statusPesan
      });
    }

    return res.status(200).json({
      success: true,
      message: statusPesan
    });

  } catch (error: any) {
    console.error('Error saat memproses pembayaran SP:', error);

    // Deteksi jika error dilempar sengaja oleh Trigger/Constraint Database (Error 1644 / SQLSTATE 45000)
    // Di Prisma, error mentah dari database dibungkus dalam properti message atau meta.
    const dbErrorMessage = error.message || '';
    
    // Periksa jika ada kata kunci pembatalan transaksi dari Trigger DDL/Trigger 06
    if (dbErrorMessage.includes('OPERASI DITOLAK') || dbErrorMessage.includes('GAGAL')) {
      // Potong pesan error agar lebih ramah untuk dibaca user di frontend
      const cleanMessage = dbErrorMessage.split('\n').pop() || dbErrorMessage;
      return res.status(400).json({
        success: false,
        message: 'Transaksi ditolak oleh sistem database.',
        detail: cleanMessage.replace(/.*(?:Raw query failed. Code: \d+. Status: \d+. Message: )/, '')
      });
    }

    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan sistem internal pada server backend.',
      error: error.message
    });
  }
};

/**
 * POST /api/kamar/checkin
 * Mengubah status kamar menjadi Terisi melalui fitur Walk-In Reservation.
 */
export const prosesCheckIn = async (req: Request, res: Response) => {
  const { id_kamar, nama_tamu, email, durasi_menginap } = req.body;
  if (!id_kamar || !nama_tamu || !durasi_menginap) {
    return res.status(400).json({ success: false, message: 'Data Form Check-In tidak lengkap!' });
  }

  try {
    // Transaksi Prisma: Menyisipkan Data ke Tamu -> Reservasi -> Detail -> Checkin
    // Trigger trg_after_checkin di DB akan otomatis mengubah status kamar menjadi Terisi!
    await prisma.$transaction(async (tx) => {
      // 1. Buat Tamu Baru (Mockup Random KTP karena Walk-in cepat)
      const noKTP = 'WIK-' + Date.now();
      await tx.$executeRaw`
        INSERT INTO tamu (nama_tamu, no_identitas, jenis_kelamin, no_telepon, email, alamat) 
        VALUES (${nama_tamu}, ${noKTP}, 'Laki-laki', '-', ${email || null}, 'Walk-in Guest')
      `;
      const tamuRes = await tx.$queryRaw<{id_tamu: any}[]>`SELECT LAST_INSERT_ID() as id_tamu`;
      const idTamu = Number(tamuRes[0]?.id_tamu || 0);

      // 2. Buat Header Reservasi
      await tx.$executeRaw`
        INSERT INTO reservasi (id_tamu, id_pegawai, tanggal_checkin_rencana, tanggal_checkout_rencana, status_reservasi)
        VALUES (${idTamu}, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL ${Number(durasi_menginap)} DAY), 'Menunggu')
      `;
      const resRes = await tx.$queryRaw<{id_reservasi: any}[]>`SELECT LAST_INSERT_ID() as id_reservasi`;
      const idReservasi = Number(resRes[0]?.id_reservasi || 0);

      // 3. Ambil harga per malam dari kamar
      const hargaRes = await tx.$queryRaw<{harga_per_malam: any}[]>`
        SELECT tk.harga_per_malam FROM kamar k JOIN tipe_kamar tk ON k.id_tipe_kamar = tk.id_tipe_kamar WHERE k.id_kamar = ${id_kamar}
      `;
      const harga = Number(hargaRes[0]?.harga_per_malam || 0);

      // 4. Insert Detail Reservasi
      await tx.$executeRaw`
        INSERT INTO detail_reservasi (id_reservasi, id_kamar, jumlah_malam, harga_per_malam)
        VALUES (${idReservasi}, ${id_kamar}, ${Number(durasi_menginap)}, ${harga})
      `;

      // 5. Insert Check-In (Ini akan men-trigger status_kamar -> Terisi & status_reservasi -> Check-in)
      await tx.$executeRaw`
        INSERT INTO checkin (id_reservasi, id_pegawai, catatan)
        VALUES (${idReservasi}, 1, 'Check-in Instan dari Dashboard Resepsionis')
      `;

      // 6. Catat aktivitas check-in ke log_aktivitas
      await tx.$executeRaw`
        INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
        VALUES (1, 'Check-In Tamu', ${`Check-In Reservasi ID ${idReservasi} sukses untuk tamu ${nama_tamu} di Kamar ID ${id_kamar}.`})
      `;
    });
    
    return res.status(200).json({ success: true, message: `Berhasil Check-In atas nama ${nama_tamu}!` });
  } catch (error: any) {
    console.error('Error saat prosesCheckIn:', error);
    return res.status(500).json({ success: false, message: 'Gagal memproses Check-In.', error: error.message });
  }
};

/**
 * POST /api/kamar/checkout
 * Menyisipkan data ke tabel checkout sehingga Trigger membebaskan kamar.
 */
export const prosesCheckOut = async (req: Request, res: Response) => {
  const { id_kamar } = req.body;
  if (!id_kamar) return res.status(400).json({ success: false, message: 'ID Kamar diperlukan' });

  try {
    const checkoutSummary = await prisma.$transaction(async (tx) => {
      // Cari ID Reservasi yang sedang Check-in di kamar ini
      const resData = await tx.$queryRaw<{id_reservasi: any}[]>`
        SELECT r.id_reservasi FROM detail_reservasi dr
        JOIN reservasi r ON dr.id_reservasi = r.id_reservasi
        WHERE dr.id_kamar = ${id_kamar} AND r.status_reservasi = 'Check-in'
        LIMIT 1
      `;

      if (resData.length === 0) throw new Error('Tidak ada reservasi aktif di kamar ini.');
      
      const idReservasi = Number(resData[0].id_reservasi);

      // Hitung total biaya sewa kamar
      const kamarCostRes = await tx.$queryRaw<{total: any}[]>`
        SELECT COALESCE(SUM(subtotal), 0) as total FROM detail_reservasi WHERE id_reservasi = ${idReservasi}
      `;
      const totalKamar = Number(kamarCostRes[0]?.total || 0);

      // Hitung total biaya restoran (Charge-to-Room)
      const restoranCostRes = await tx.$queryRaw<{total: any}[]>`
        SELECT COALESCE(SUM(total_harga), 0) as total FROM pesanan_restoran 
        WHERE id_reservasi = ${idReservasi} AND status_bayar = 'Charge-to-Room'
      `;
      const totalRestoran = Number(restoranCostRes[0]?.total || 0);

      // Hitung total biaya layanan tambahan (Extra Services)
      const layananCostRes = await tx.$queryRaw<{total: any}[]>`
        SELECT COALESCE(SUM(total_harga), 0) as total FROM detail_layanan_kamar
        WHERE id_reservasi = ${idReservasi}
      `;
      const totalLayanan = Number(layananCostRes[0]?.total || 0);

      const grandTotal = totalKamar + totalRestoran + totalLayanan;
      const catatanCheckout = `Check-out berhasil. Biaya Kamar: Rp${totalKamar.toLocaleString('id-ID')}, F&B Restoran: Rp${totalRestoran.toLocaleString('id-ID')}, Extra Services: Rp${totalLayanan.toLocaleString('id-ID')}, Total Billing: Rp${grandTotal.toLocaleString('id-ID')}`;

      // Insert ke tabel checkout (Ini akan men-trigger status_kamar -> Tersedia)
      await tx.$executeRaw`
        INSERT INTO checkout (id_reservasi, id_pegawai, biaya_tambahan, catatan)
        VALUES (${idReservasi}, 1, 0, ${catatanCheckout})
      `;

      // Catat aktivitas check-out ke log_aktivitas
      await tx.$executeRaw`
        INSERT INTO log_aktivitas (id_pegawai, aktivitas, keterangan)
        VALUES (1, 'Check-Out Tamu', ${`Checkout Reservasi ID ${idReservasi} sukses. Total Billing: Rp${grandTotal.toLocaleString('id-ID')} (Kamar: Rp${totalKamar.toLocaleString('id-ID')}, F&B: Rp${totalRestoran.toLocaleString('id-ID')}, Ekstra: Rp${totalLayanan.toLocaleString('id-ID')})`})
      `;

      return {
        id_reservasi: idReservasi,
        total_biaya_kamar: totalKamar,
        total_biaya_restoran: totalRestoran,
        total_biaya_layanan_tambahan: totalLayanan,
        grand_total_tagihan: grandTotal
      };
    });
    
    return res.status(200).json({ 
      success: true, 
      message: 'Check-Out berhasil. Kamar kini telah Tersedia.',
      data: checkoutSummary
    });
  } catch (error: any) {
    console.error('Error saat prosesCheckOut:', error);
    return res.status(500).json({ success: false, message: 'Gagal memproses Check-Out.', error: error.message });
  }
};
