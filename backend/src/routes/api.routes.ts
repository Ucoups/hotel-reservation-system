import { Router } from 'express';
import { prosesPembayaran, prosesCheckIn, prosesCheckOut } from '../controllers/reservasi.controller';
import { getStatusKamar } from '../controllers/dashboard.controller';
import { getLaporanOmset, getPerformaStaf, getAuditLogs, runNightAudit } from '../controllers/admin.controller';
import { verifyToken, roleCheck } from '../middleware/auth.middleware';
import { login } from '../controllers/auth.controller';

const router = Router();

// Endpoint Autentikasi
router.post('/auth/login', login);

// Endpoint untuk memproses pembayaran menggunakan Stored Procedure
router.post('/reservasi/pembayaran', prosesPembayaran);

// Endpoint integrasi tombol Check-In dan Check-Out
router.post('/kamar/checkin', prosesCheckIn);
router.post('/kamar/checkout', prosesCheckOut);

// Endpoint untuk mendapatkan peta status kamar real-time dari View
router.get('/dashboard/status-kamar', getStatusKamar);

// Endpoint untuk laporan administrasi dan kinerja (Dilindungi untuk Admin)
router.get('/admin/laporan-omset', verifyToken, roleCheck(['Admin']), getLaporanOmset);
router.get('/admin/performa-staf', verifyToken, roleCheck(['Admin']), getPerformaStaf);
router.get('/admin/logs', verifyToken, roleCheck(['Admin']), getAuditLogs);
router.post('/admin/night-audit', verifyToken, roleCheck(['Admin']), runNightAudit);

// Endpoint untuk modul CRUD Manajemen Kamar (Dilindungi untuk Admin)
import { getSemuaKamar, getTipeKamar, tambahKamar, updateKamar, hapusKamar } from '../controllers/admin.kamar.controller';
router.get('/admin/kamar', verifyToken, roleCheck(['Admin']), getSemuaKamar);
router.get('/admin/kamar/tipe', verifyToken, roleCheck(['Admin']), getTipeKamar);
router.post('/admin/kamar', verifyToken, roleCheck(['Admin']), tambahKamar);
router.put('/admin/kamar/:id', verifyToken, roleCheck(['Admin']), updateKamar);
router.delete('/admin/kamar/:id', verifyToken, roleCheck(['Admin']), hapusKamar);

// Endpoint untuk modul restoran
import { getMenu, orderToRoom } from '../controllers/restoran.controller';
router.get('/restoran/menu', verifyToken, getMenu);
router.post('/restoran/order-to-room', verifyToken, orderToRoom);

// Endpoint untuk modul CRUD Manajemen Menu Restoran (Dilindungi untuk Admin)
import { getSemuaMenu, tambahMenu, updateMenu, hapusMenu } from '../controllers/admin.restoran.controller';
router.get('/admin/restoran/menu', verifyToken, roleCheck(['Admin']), getSemuaMenu);
router.post('/admin/restoran/menu', verifyToken, roleCheck(['Admin']), tambahMenu);
router.put('/admin/restoran/menu/:id', verifyToken, roleCheck(['Admin']), updateMenu);
router.delete('/admin/restoran/menu/:id', verifyToken, roleCheck(['Admin']), hapusMenu);

// Endpoint untuk modul Layanan Tambahan (Extra Services)
import { getMasterLayanan, pesanLayanan } from '../controllers/reservasi.layanan.controller';
router.get('/reservasi/layanan-tambahan/master', verifyToken, getMasterLayanan);
router.post('/reservasi/layanan-tambahan', verifyToken, pesanLayanan);

// Endpoint untuk modul Housekeeping
import { getTugasAktif, mulaiTugas, selesaikanTugas } from '../controllers/housekeeping.controller';
router.get('/housekeeping/tugas', verifyToken, getTugasAktif);
router.patch('/housekeeping/mulai/:id', verifyToken, mulaiTugas);
router.patch('/housekeeping/selesai/:id', verifyToken, selesaikanTugas);

export default router;
