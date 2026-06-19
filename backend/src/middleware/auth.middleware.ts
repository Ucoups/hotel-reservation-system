import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'supersecretjwtkey_hotel_2026';

// Extend Express Request type to include user
declare global {
  namespace Express {
    interface Request {
      user?: {
        id_pegawai: number;
        email: string;
        jabatan: string;
      };
    }
  }
}

export const verifyToken = (req: Request, res: Response, next: NextFunction): void => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    res.status(401).json({ success: false, message: 'Akses ditolak. Token tidak ditemukan atau tidak valid.' });
    return;
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET) as any;
    req.user = decoded;
    next();
  } catch (error) {
    res.status(403).json({ success: false, message: 'Token tidak valid atau sudah kedaluwarsa.' });
    return;
  }
};

export const roleCheck = (allowedRoles: string[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({ success: false, message: 'Akses ditolak. Pengguna belum terautentikasi.' });
      return;
    }

    if (!allowedRoles.includes(req.user.jabatan)) {
      res.status(403).json({ 
        success: false, 
        message: `Akses ditolak. Role '${req.user.jabatan}' tidak memiliki izin mengakses endpoint ini.` 
      });
      return;
    }

    next();
  };
};
