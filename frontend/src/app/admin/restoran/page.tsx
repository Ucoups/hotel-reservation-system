'use client';

import { useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import NeoSidebar from '@/components/NeoSidebar';
import NeoHeader from '@/components/NeoHeader';

interface MenuRestoran {
  id_menu: number;
  nama_menu: string;
  harga: number;
  kategori: 'MAKANAN' | 'MINUMAN' | 'DESSERT';
  isTersedia: boolean;
}

export default function ManajemenMenuRestoran() {
  const [menuList, setMenuList] = useState<MenuRestoran[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [modalMode, setModalMode] = useState<'add' | 'edit'>('add');
  const [formError, setFormError] = useState('');

  // Form State
  const [idMenu, setIdMenu] = useState<number | null>(null);
  const [namaMenu, setNamaMenu] = useState('');
  const [harga, setHarga] = useState('');
  const [kategori, setKategori] = useState<'MAKANAN' | 'MINUMAN' | 'DESSERT'>('MAKANAN');
  const [isTersedia, setIsTersedia] = useState(true);

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
      const response = await fetch('http://localhost:3002/api/admin/restoran/menu', { headers: getHeaders() });
      if (response.ok) {
        const data = await response.json();
        setMenuList(data.data || []);
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
    setIdMenu(null);
    setNamaMenu('');
    setHarga('');
    setKategori('MAKANAN');
    setIsTersedia(true);
    setFormError('');
    setIsModalOpen(true);
  };

  const handleOpenEditModal = (menu: MenuRestoran) => {
    setModalMode('edit');
    setIdMenu(menu.id_menu);
    setNamaMenu(menu.nama_menu);
    setHarga(menu.harga.toString());
    setKategori(menu.kategori);
    setIsTersedia(menu.isTersedia);
    setFormError('');
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setFormError('');

    if (!namaMenu || !harga) {
      setFormError('Nama menu dan harga harus diisi.');
      return;
    }

    const payload = {
      nama_menu: namaMenu,
      harga: Number(harga),
      kategori,
      isTersedia
    };

    try {
      const url = modalMode === 'add' 
        ? 'http://localhost:3002/api/admin/restoran/menu' 
        : `http://localhost:3002/api/admin/restoran/menu/${idMenu}`;
      
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

  const handleDelete = async (menu: MenuRestoran) => {
    if (!window.confirm(`Apakah Anda yakin ingin menghapus Menu ${menu.nama_menu}?`)) {
      return;
    }

    try {
      const response = await fetch(`http://localhost:3002/api/admin/restoran/menu/${menu.id_menu}`, {
        method: 'DELETE',
        headers: getHeaders()
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Gagal menghapus menu.');
      }

      fetchData();
    } catch (error: any) {
      alert(error.message);
    }
  };

  const formatCurrency = (amount: number | string) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(amount));
  };

  return (
    <div className="flex h-screen bg-[#fdfbf7] text-black font-sans overflow-hidden">
      
      <NeoSidebar user={user} />

      <main className="flex-1 flex flex-col h-full relative overflow-hidden">
        
        <NeoHeader user={user} title="RESTORAN CMS" />

        <div className="flex-1 overflow-y-auto p-6 md:p-8 relative">
          
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
            <div>
              <h2 className="text-4xl md:text-5xl font-black tracking-tighter uppercase">MANAJEMEN MENU</h2>
              <p className="font-bold text-gray-700 mt-2">Kelola master data ketersediaan makanan & minuman</p>
            </div>
            
            <button 
              onClick={handleOpenAddModal}
              className="bg-[#ffcf00] border-4 border-black font-black px-6 py-3 shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-all flex items-center gap-2"
            >
              + TAMBAH MENU
            </button>
          </div>

          <div className="bg-white border-4 border-black shadow-[8px_8px_0_0_#000] overflow-x-auto">
            <table className="w-full text-left font-bold">
              <thead className="bg-[#2b65e3] text-white border-b-4 border-black">
                <tr>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">NAMA MENU</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">KATEGORI</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">HARGA</th>
                  <th className="p-4 border-r-4 border-black uppercase text-sm tracking-widest">KETERSEDIAAN</th>
                  <th className="p-4 uppercase text-sm tracking-widest text-center">AKSI</th>
                </tr>
              </thead>
              <tbody>
                {isLoading ? (
                  <tr>
                    <td colSpan={5} className="p-8 text-center text-xl font-black bg-[#fdfbf7] animate-pulse">
                      MEMUAT DATA...
                    </td>
                  </tr>
                ) : menuList.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="p-8 text-center text-xl font-black bg-[#fdfbf7]">
                      BELUM ADA DATA MENU.
                    </td>
                  </tr>
                ) : (
                  menuList.map((menu, index) => (
                    <tr key={menu.id_menu} className={`${index !== menuList.length - 1 ? 'border-b-4 border-black' : ''} hover:bg-gray-100`}>
                      <td className="p-4 border-r-4 border-black text-xl font-black">{menu.nama_menu}</td>
                      <td className="p-4 border-r-4 border-black">
                        <span className={`px-2 py-1 border-2 border-black text-xs font-black shadow-[2px_2px_0_0_#000] uppercase ${
                          menu.kategori === 'MAKANAN' ? 'bg-[#f0544f] text-white' : 
                          menu.kategori === 'MINUMAN' ? 'bg-[#5ebdf7] text-black' : 'bg-[#ffcf00]'
                        }`}>
                          {menu.kategori}
                        </span>
                      </td>
                      <td className="p-4 border-r-4 border-black font-black">
                        {formatCurrency(menu.harga)}
                      </td>
                      <td className="p-4 border-r-4 border-black">
                        {menu.isTersedia ? (
                          <span className="bg-white border-2 border-black px-2 py-1 text-xs font-black shadow-[2px_2px_0_0_#000]">TERSEDIA</span>
                        ) : (
                          <span className="bg-black text-white border-2 border-black px-2 py-1 text-xs font-black shadow-[2px_2px_0_0_#fff]">HABIS</span>
                        )}
                      </td>
                      <td className="p-4 text-center">
                        <button 
                          onClick={() => handleOpenEditModal(menu)}
                          className="bg-[#5ebdf7] border-2 border-black text-xs font-black px-3 py-1 mr-2 shadow-[2px_2px_0_0_#000] hover:bg-blue-400"
                        >
                          EDIT
                        </button>
                        <button 
                          onClick={() => handleDelete(menu)}
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
            <div className="bg-[#ffcf00] border-b-4 border-black p-4 flex justify-between items-center">
              <h3 className="text-2xl font-black uppercase">
                {modalMode === 'add' ? 'TAMBAH MENU' : 'EDIT MENU'}
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
                  <label className="block mb-1 uppercase font-black text-sm">Nama Menu</label>
                  <input 
                    type="text" 
                    value={namaMenu}
                    onChange={(e) => setNamaMenu(e.target.value)}
                    className="w-full border-4 border-black p-3 outline-none shadow-[2px_2px_0_0_#000]"
                    placeholder="Contoh: Nasi Goreng"
                    required
                  />
                </div>
                <div>
                  <label className="block mb-1 uppercase font-black text-sm">Kategori</label>
                  <select
                    value={kategori}
                    onChange={(e) => setKategori(e.target.value as 'MAKANAN' | 'MINUMAN' | 'DESSERT')}
                    className="w-full border-4 border-black p-3 outline-none shadow-[2px_2px_0_0_#000] cursor-pointer bg-white"
                    required
                  >
                    <option value="MAKANAN">MAKANAN</option>
                    <option value="MINUMAN">MINUMAN</option>
                    <option value="DESSERT">DESSERT</option>
                  </select>
                </div>
                <div>
                  <label className="block mb-1 uppercase font-black text-sm">Harga (Rp)</label>
                  <input 
                    type="number" 
                    value={harga}
                    onChange={(e) => setHarga(e.target.value)}
                    className="w-full border-4 border-black p-3 outline-none shadow-[2px_2px_0_0_#000]"
                    placeholder="Contoh: 45000"
                    required
                  />
                </div>
                
                <div className="pt-2">
                  <label className="flex items-center p-3 bg-white border-4 border-black cursor-pointer shadow-[2px_2px_0_0_#000]">
                    <input
                      type="checkbox"
                      className="w-6 h-6 border-4 border-black accent-black"
                      checked={isTersedia}
                      onChange={(e) => setIsTersedia(e.target.checked)}
                    />
                    <span className="ml-3 font-black text-lg">STOK TERSEDIA</span>
                  </label>
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
                  className="px-6 py-3 border-4 border-black font-black bg-[#5ebdf7] shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-transform"
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
