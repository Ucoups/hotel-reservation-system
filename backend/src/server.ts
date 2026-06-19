import app from './app';
import dotenv from 'dotenv';

// Muat variabel lingkungan dari .env
dotenv.config();

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
  console.log(`===================================================`);
  console.log(`🚀 Server berjalan di: http://localhost:${PORT}`);
  console.log(`🔧 Mode Pengembangan Aktif`);
  console.log(`===================================================`);
});

// Penanganan anggun pemutusan server (Graceful Shutdown)
process.on('SIGTERM', () => {
  console.log('Menerima SIGTERM. Menutup server backend secara anggun...');
  server.close(() => {
    console.log('Server ditutup.');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('Menerima SIGINT. Menutup server backend secara anggun...');
  server.close(() => {
    console.log('Server ditutup.');
    process.exit(0);
  });
});
