import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import apiRoutes from './routes/api.routes';

const app: Application = express();

// Middleware Global
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routing API
app.use('/api', apiRoutes);

// Healthcheck Route
app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({ status: 'OK', timestamp: new Date() });
});

// Middleware penanganan route tidak ditemukan (404)
app.use((_req: Request, res: Response) => {
  res.status(404).json({ success: false, message: 'Endpoint tidak ditemukan.' });
});

// Middleware penanganan error global
app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  console.error('Unhandled Server Error:', err);
  res.status(500).json({
    success: false,
    message: 'Terjadi kesalahan internal pada server.',
    error: err.message || err
  });
});

export default app;
