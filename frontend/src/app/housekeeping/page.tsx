'use client';

import { useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import { useRouter } from 'next/navigation';
import NeoSidebar from '@/components/NeoSidebar';
import NeoHeader from '@/components/NeoHeader';

interface TipeKamar {
  nama_tipe: string;
}

interface Kamar {
  id_kamar: number;
  nomor_kamar: string;
  lantai: string;
  tipe_kamar: TipeKamar;
}

interface TugasHousekeeping {
  id_tugas: number;
  id_kamar: number;
  id_pegawai: number | null;
  status_tugas: 'Pending' | 'In_Progress' | 'Completed';
  waktu_dibuat: string;
  waktu_mulai: string | null;
  kamar: Kamar;
  pegawai?: {
    nama_pegawai: string;
  };
}

export default function HousekeepingPortal() {
  const [tugasList, setTugasList] = useState<TugasHousekeeping[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [actionLoading, setActionLoading] = useState<number | null>(null);
  const [user, setUser] = useState<{ id_pegawai?: number; nama_pegawai?: string; jabatan?: string }>({});
  const router = useRouter();

  useEffect(() => {
    const userCookie = Cookies.get('user');
    if (userCookie) {
      try { setUser(JSON.parse(userCookie)); } catch (e) {}
    } else {
      router.push('/login');
    }
  }, [router]);

  const getHeaders = () => {
    return {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${Cookies.get('token')}`
    };
  };

  const fetchTugas = async () => {
    try {
      const response = await fetch('http://localhost:3002/api/housekeeping/tugas', {
        headers: getHeaders()
      });
      if (!response.ok) throw new Error('Gagal mengambil daftar tugas kebersihan.');
      const data = await response.json();
      if (data.success) {
        setTugasList(data.data);
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTugas();
    const interval = setInterval(fetchTugas, 10000);
    return () => clearInterval(interval);
  }, []);

  const handleMulaiTugas = async (id_tugas: number) => {
    setActionLoading(id_tugas);
    try {
      const response = await fetch(`http://localhost:3002/api/housekeeping/mulai/${id_tugas}`, {
        method: 'PATCH',
        headers: getHeaders()
      });
      const data = await response.json();
      if (data.success) {
        fetchTugas();
      } else {
        alert(data.message);
      }
    } catch (err: any) {
      alert('Terjadi kesalahan jaringan.');
    } finally {
      setActionLoading(null);
    }
  };

  const handleSelesaiTugas = async (id_tugas: number) => {
    setActionLoading(id_tugas);
    try {
      const response = await fetch(`http://localhost:3002/api/housekeeping/selesai/${id_tugas}`, {
        method: 'PATCH',
        headers: getHeaders()
      });
      const data = await response.json();
      if (data.success) {
        alert('Kamar berhasil ditandai bersih dan kembali tersedia!');
        fetchTugas();
      } else {
        alert(data.message);
      }
    } catch (err: any) {
      alert('Terjadi kesalahan jaringan.');
    } finally {
      setActionLoading(null);
    }
  };

  return (
    <div className="flex h-screen bg-[#fdfbf7] text-black font-sans overflow-hidden">
      
      <NeoSidebar user={user} />

      <main className="flex-1 flex flex-col h-full relative overflow-hidden">
        
        <NeoHeader user={user} title="HOUSEKEEPING PORTAL" />

        <div className="flex-1 overflow-y-auto p-6 md:p-8 relative">
          
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
            <div>
              <h2 className="text-4xl md:text-5xl font-black tracking-tighter uppercase">ANTREAN KAMAR KOTOR</h2>
              <p className="font-bold text-gray-700 mt-2">Sistem Penugasan Kebersihan Kamar Terpadu</p>
            </div>
            
            <div className="bg-white border-4 border-black font-black px-4 py-2 shadow-[4px_4px_0_0_#000]">
              UPDATE: {new Date().toLocaleTimeString()}
            </div>
          </div>

          {error && (
            <div className="text-2xl font-black text-[#f0544f] py-4 px-6 border-4 border-black bg-white shadow-[4px_4px_0_0_#000] mb-8 inline-block">
              ERROR: {error}
            </div>
          )}

          {loading && tugasList.length === 0 ? (
            <div className="text-2xl font-black animate-pulse py-10">MEMUAT TUGAS...</div>
          ) : tugasList.length === 0 ? (
            <div className="bg-[#5ebdf7] border-4 border-black shadow-[8px_8px_0_0_#000] p-16 text-center max-w-2xl mx-auto mt-10 transform -rotate-1 hover:rotate-0 transition-transform">
              <div className="text-8xl mb-6">✨</div>
              <h3 className="text-4xl font-black text-black mb-4 uppercase">Semua Kamar Bersih!</h3>
              <p className="text-xl font-bold text-black">Tidak ada antrean tugas kebersihan saat ini. Pekerjaan yang luar biasa!</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 pb-10">
              {tugasList.map((tugas) => (
                <div 
                  key={tugas.id_tugas} 
                  className={`border-4 border-black shadow-[8px_8px_0_0_#000] flex flex-col transition-transform hover:-translate-y-1 ${
                    tugas.status_tugas === 'In_Progress' ? 'bg-[#ffcf00]' : 'bg-[#f0544f]'
                  }`}
                >
                  <div className="p-4 border-b-4 border-black bg-white flex justify-between items-start">
                    <div>
                      <span className="text-sm font-black tracking-widest uppercase">KAMAR</span>
                      <h3 className="text-5xl font-black leading-none mt-1">{tugas.kamar.nomor_kamar}</h3>
                    </div>
                    <span className={`px-3 py-1 border-4 border-black text-sm font-black shadow-[2px_2px_0_0_#000] ${
                      tugas.status_tugas === 'In_Progress' ? 'bg-[#5ebdf7] text-black' : 'bg-white text-black'
                    }`}>
                      {tugas.status_tugas === 'In_Progress' ? 'ON PROGRESS' : 'PENDING'}
                    </span>
                  </div>
                  
                  <div className="p-5 flex-1 flex flex-col">
                    <div className="space-y-4 mb-6 font-bold text-lg">
                      <div className="flex justify-between border-b-2 border-black border-dashed pb-1">
                        <span>LANTAI:</span>
                        <span>{tugas.kamar.lantai}</span>
                      </div>
                      <div className="flex justify-between border-b-2 border-black border-dashed pb-1">
                        <span>TIPE:</span>
                        <span>{tugas.kamar.tipe_kamar.nama_tipe}</span>
                      </div>
                      <div className="flex justify-between border-b-2 border-black border-dashed pb-1">
                        <span>KOTOR SEJAK:</span>
                        <span>{new Date(tugas.waktu_dibuat).toLocaleTimeString('id-ID', {hour: '2-digit', minute:'2-digit'})}</span>
                      </div>
                      
                      {tugas.status_tugas === 'In_Progress' && (
                        <div className="bg-white border-4 border-black p-3 mt-4 shadow-[4px_4px_0_0_#000]">
                          <div className="text-sm font-black mb-1 uppercase">PETUGAS:</div>
                          <div className="text-xl font-black text-[#2b65e3] uppercase">
                            {tugas.pegawai?.nama_pegawai || 'ANDA'}
                          </div>
                          <div className="text-sm font-bold mt-1">Mulai: {new Date(tugas.waktu_mulai!).toLocaleTimeString('id-ID', {hour: '2-digit', minute:'2-digit'})}</div>
                        </div>
                      )}
                    </div>
                    
                    <div className="mt-auto pt-4 border-t-4 border-black border-dotted">
                      {tugas.status_tugas === 'Pending' ? (
                        <button
                          onClick={() => handleMulaiTugas(tugas.id_tugas)}
                          disabled={actionLoading === tugas.id_tugas}
                          className="w-full py-4 px-4 bg-black text-white text-lg font-black uppercase transition-colors hover:bg-gray-800 disabled:opacity-50 shadow-[4px_4px_0_0_#fff] border-2 border-black"
                        >
                          {actionLoading === tugas.id_tugas ? 'MEMPROSES...' : 'MULAI BERSIHKAN'}
                        </button>
                      ) : (
                        <button
                          onClick={() => handleSelesaiTugas(tugas.id_tugas)}
                          disabled={actionLoading === tugas.id_tugas || (tugas.id_pegawai !== user.id_pegawai && user.jabatan !== 'Admin')}
                          className="w-full py-4 px-4 bg-white text-black border-4 border-black text-lg font-black uppercase transition-colors hover:bg-gray-200 shadow-[4px_4px_0_0_#000] disabled:opacity-50"
                        >
                          {actionLoading === tugas.id_tugas ? 'MEMPROSES...' : 'TANDAI BERSIH ✅'}
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
