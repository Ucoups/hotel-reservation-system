'use client';

import { useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import NeoSidebar from '@/components/NeoSidebar';
import NeoHeader from '@/components/NeoHeader';

interface TipeKamar {
  id_tipe_kamar: number;
  nama_tipe: string;
  harga_per_malam: number;
}

interface Kamar {
  id_kamar: number;
  id_tipe_kamar: number;
  nomor_kamar: string;
  lantai: string;
  status_kamar: 'Tersedia' | 'Dipesan' | 'Terisi' | 'Perawatan';
  tipe_kamar?: TipeKamar;
}

export default function ManajemenKamar() {
  const [kamarList, setKamarList] = useState<Kamar[]>([]);
  const [tipeKamarList, setTipeKamarList] = useState<TipeKamar[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [modalMode, setModalMode] = useState<'add' | 'edit'>('add');
  const [formError, setFormError] = useState('');

  // Form State
  const [idKamar, setIdKamar] = useState<number | null>(null);
  const [nomorKamar, setNomorKamar] = useState('');
  const [lantai, setLantai] = useState('1');
  const [idTipeKamar, setIdTipeKamar] = useState('');

  const [user, setUser] = useState<{nama_pegawai?: string, jabatan?: string}>({});

  useEffect(() => {
    const userCookie = Cookies.get('user');
    if (userCookie) {
      try { setUser(JSON.parse(userCookie)); } catch (e) {}
    }
  }, []);

  const getHeaders = () => {
    return {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${Cookies.get('token')}`
    };
  };

  const fetchData = async () => {
    setIsLoading(true);
    try {
      const [kamarRes, tipeRes] = await Promise.all([
        fetch('http://localhost:3002/api/admin/kamar', { headers: getHeaders() }),
        fetch('http://localhost:3002/api/admin/kamar/tipe', { headers: getHeaders() })
      ]);

      if (kamarRes.ok) {
        const kamarData = await kamarRes.json();
        setKamarList(kamarData.data || []);
      }
      
      if (tipeRes.ok) {
        const tipeData = await tipeRes.json();
        setTipeKamarList(tipeData.data || []);
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleOpenAddModal = () => {
    setModalMode('add');
    setIdKamar(null);
    setNomorKamar('');
    setLantai('1');
    setIdTipeKamar('');
    setFormError('');
    setIsModalOpen(true);
  };

  const handleOpenEditModal = (kamar: Kamar) => {
    setModalMode('edit');
    setIdKamar(kamar.id_kamar);
    setNomorKamar(kamar.nomor_kamar);
    setLantai(kamar.lantai);
    setIdTipeKamar(kamar.id_tipe_kamar.toString());
    setFormError('');
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setFormError('');

    if (!nomorKamar || !lantai || !idTipeKamar) {
      setFormError('Semua field harus diisi.');
      return;
    }

    const payload = {
      nomor_kamar: nomorKamar,
      lantai,
      id_tipe_kamar: Number(idTipeKamar)
    };

    try {
      const url = modalMode === 'add' 
        ? 'http://localhost:3002/api/admin/kamar' 
        : `http://localhost:3002/api/admin/kamar/${idKamar}`;
      
      const method = modalMode === 'add' ? 'POST' : 'PUT';

      const response = await fetch(url, {
        method,
        headers: getHeaders(),
        body: JSON.stringify(payload)
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Terjadi kesalahan.');
      }

      setIsModalOpen(false);
      fetchData();
    } catch (error: any) {
      setFormError(error.message);
    }
  };

  const handleDelete = async (kamar: Kamar) => {
    if (kamar.status_kamar === 'Terisi' || kamar.status_kamar === 'Dipesan') {
      alert(`Kamar tidak dapat dihapus karena berstatus '${kamar.status_kamar}'.`);
      return;
    }

    if (!window.confirm(`Apakah Anda yakin ingin menghapus Kamar ${kamar.nomor_kamar}?`)) {
      return;
    }

    try {
      const response = await fetch(`http://localhost:3002/api/admin/kamar/${kamar.id_kamar}`, {
        method: 'DELETE',
        headers: getHeaders()
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Gagal menghapus kamar.');
      }

      fetchData();
    } catch (error: any) {
      alert(error.message);
    }
  };

  return (
    <div className="flex h-screen bg-[#fdfbf7] text-black font-sans overflow-hidden">
      <NeoSidebar user={user} />

      <main className="flex-1 flex flex-col h-full relative overflow-hidden">
        <NeoHeader user={user} title="KAMAR CMS" />

        <div className="flex-1 overflow-y-auto p-6 md:p-8 relative">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
            <div>
              <h2 className="text-4xl md:text-5xl font-black tracking-tighter uppercase">MANAJEMEN KAMAR</h2>
              <p className="font-bold text-gray-700 mt-2">Kelola master data inventaris kamar hotel</p>
            </div>
            <button 
              onClick={handleOpenAddModal}
              className="bg-[#5ebdf7] border-4 border-black font-black px-6 py-3 shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-all flex items-center gap-2"
            >
              + TAMBAH KAMAR
            </button>
          </div>

          <div className="bg-white border-4 border-black shadow-[8px_8px_0_0_#000] overflow-x-auto">
            <table className="w-full text-left font-bold">
              <thead className="bg-[#ffcf00] border-b-4 border-black">
                <tr>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">NO. KAMAR</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">LANTAI</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">TIPE KAMAR</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">HARGA/MALAM</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">STATUS</th>
                  <th className="p-4 uppercase text-sm tracking-widest text-center">AKSI</th>
                </tr>
              </thead>
              <tbody>
                {isLoading ? (
                  <tr>
                    <td colSpan={6} className="p-8 text-center text-xl font-black bg-[#fdfbf7] animate-pulse">
                      MEMUAT DATA...
                    </td>
                  </tr>
                ) : kamarList.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="p-8 text-center text-xl font-black bg-[#fdfbf7]">
                      BELUM ADA DATA KAMAR.
                    </td>
                  </tr>
                ) : (
                  kamarList.map((kamar, index) => (
                    <tr key={kamar.id_kamar} className={`${index !== kamarList.length - 1 ? 'border-b-4 border-black' : ''} hover:bg-gray-100`}>
                      <td className="p-4 border-r-4 border-black text-xl font-black">{kamar.nomor_kamar}</td>
                      <td className="p-4 border-r-4 border-black">{kamar.lantai}</td>
                      <td className="p-4 border-r-4 border-black">{kamar.tipe_kamar?.nama_tipe || '-'}</td>
                      <td className="p-4 border-r-4 border-black text-[#2b65e3] font-black">
                        {new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(kamar.tipe_kamar?.harga_per_malam || 0)}
                      </td>
                      <td className="p-4 border-r-4 border-black">
                        <span className={`px-2 py-1 border-2 border-black text-xs font-black shadow-[2px_2px_0_0_#000] uppercase ${
                          kamar.status_kamar === 'Tersedia' ? 'bg-white' : 
                          kamar.status_kamar === 'Terisi' ? 'bg-[#2b65e3] text-white' : 
                          kamar.status_kamar === 'Dipesan' ? 'bg-[#5ebdf7]' : 'bg-[#ffcf00]'
                        }`}>
                          {kamar.status_kamar}
                        </span>
                      </td>
                      <td className="p-4 text-center">
                        <button 
                          onClick={() => handleOpenEditModal(kamar)}
                          className="bg-[#ffcf00] border-2 border-black text-xs font-black px-3 py-1 mr-2 shadow-[2px_2px_0_0_#000] hover:bg-yellow-400"
                        >
                          EDIT
                        </button>
                        <button 
                          onClick={() => handleDelete(kamar)}
                          className="bg-[#f0544f] border-2 border-black text-xs font-black px-3 py-1 text-black shadow-[2px_2px_0_0_#000] hover:bg-red-400"
                        >
                          HAPUS
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

        </div>
      </main>

      {/* Modal Form Neobrutalism */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-60 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
          <div className="bg-[#fdfbf7] border-4 border-black shadow-[12px_12px_0_0_#000] max-w-md w-full relative">
            <div className="bg-[#5ebdf7] border-b-4 border-black p-4 flex justify-between items-center">
              <h3 className="text-2xl font-black uppercase">
                {modalMode === 'add' ? 'TAMBAH KAMAR' : 'EDIT KAMAR'}
              </h3>
              <button onClick={handleCloseModal} className="text-3xl font-black hover:scale-110">&times;</button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6">
              {formError && (
                <div className="mb-4 bg-[#f0544f] border-4 border-black p-3 font-bold shadow-[2px_2px_0_0_#000]">
                  {formError}
                </div>
              )}
              
              <div className="space-y-4 font-bold">
                <div>
                  <label className="block mb-1 uppercase font-black text-sm">Nomor Kamar</label>
                  <input 
                    type="text" 
                    value={nomorKamar}
                    onChange={(e) => setNomorKamar(e.target.value)}
                    className="w-full border-4 border-black p-3 outline-none shadow-[2px_2px_0_0_#000]"
                    placeholder="Contoh: 101"
                    required
                  />
                </div>
                <div>
                  <label className="block mb-1 uppercase font-black text-sm">Lantai</label>
                  <input 
                    type="number" 
                    value={lantai}
                    onChange={(e) => setLantai(e.target.value)}
                    className="w-full border-4 border-black p-3 outline-none shadow-[2px_2px_0_0_#000]"
                    placeholder="Contoh: 1"
                    required
                  />
                </div>
                <div>
                  <label className="block mb-1 uppercase font-black text-sm">Tipe Kamar</label>
                  <select
                    value={idTipeKamar}
                    onChange={(e) => setIdTipeKamar(e.target.value)}
                    className="w-full border-4 border-black p-3 outline-none shadow-[2px_2px_0_0_#000] cursor-pointer bg-white"
                    required
                  >
                    <option value="" disabled>-- Pilih Tipe --</option>
                    {tipeKamarList.map(tipe => (
                      <option key={tipe.id_tipe_kamar} value={tipe.id_tipe_kamar}>
                        {tipe.nama_tipe} ({new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(tipe.harga_per_malam)})
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              
              <div className="mt-8 flex justify-end gap-3">
                <button 
                  type="button" 
                  onClick={handleCloseModal}
                  className="px-6 py-3 border-4 border-black font-black bg-white shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-transform"
                >
                  BATAL
                </button>
                <button 
                  type="submit"
                  className="px-6 py-3 border-4 border-black font-black bg-[#ffcf00] shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-transform"
                >
                  SIMPAN
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
}
