'use client';

import { useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import NeoSidebar from '@/components/NeoSidebar';
import NeoHeader from '@/components/NeoHeader';

interface MenuItem {
  id_menu: number;
  nama_menu: string;
  harga: number;
  kategori: 'MAKANAN' | 'MINUMAN' | 'DESSERT';
  isTersedia: boolean;
}

interface RoomItem {
  id_kamar: number;
  nomor_kamar: string;
  status_kamar: string;
  nama_tamu_sekarang: string | null;
}

export default function RestoranMenu() {
  const [menuList, setMenuList] = useState<MenuItem[]>([]);
  const [roomList, setRoomList] = useState<RoomItem[]>([]);
  const [cart, setCart] = useState<{ [key: number]: number }>({});
  const [selectedKamarId, setSelectedKamarId] = useState<string>('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
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
    try {
      const menuRes = await fetch('http://localhost:3002/api/restoran/menu', { headers: getHeaders() });
      if (!menuRes.ok) throw new Error('Gagal mengambil menu makanan.');
      const menuData = await menuRes.json();

      const roomRes = await fetch('http://localhost:3002/api/dashboard/status-kamar', { headers: getHeaders() });
      if (!roomRes.ok) throw new Error('Gagal mengambil daftar kamar.');
      const roomData = await roomRes.json();

      if (menuData.success && roomData.success) {
        setMenuList(menuData.data.filter((m: MenuItem) => m.isTersedia));
        const occupiedRooms = roomData.data.filter((r: RoomItem) => r.status_kamar === 'Terisi');
        setRoomList(occupiedRooms);
        if (occupiedRooms.length > 0) {
          setSelectedKamarId(occupiedRooms[0].id_kamar.toString());
        }
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const addToCart = (menu: MenuItem) => {
    setCart((prev) => ({
      ...prev,
      [menu.id_menu]: (prev[menu.id_menu] || 0) + 1
    }));
  };

  const removeFromCart = (menuId: number) => {
    setCart((prev) => {
      const updated = { ...prev };
      if (updated[menuId] > 1) {
        updated[menuId] -= 1;
      } else {
        delete updated[menuId];
      }
      return updated;
    });
  };

  const clearCart = () => setCart({});

  const getCartTotal = () => {
    return Object.keys(cart).reduce((total, menuId) => {
      const menu = menuList.find((m) => m.id_menu === Number(menuId));
      return total + (menu ? Number(menu.harga) * cart[Number(menuId)] : 0);
    }, 0);
  };

  const handleCheckout = async () => {
    if (Object.keys(cart).length === 0) return alert('Keranjang belanja masih kosong!');
    if (!selectedKamarId) return alert('Pilih nomor kamar terisi untuk melakukan charge-to-room!');

    setIsSubmitting(true);
    try {
      const items = Object.keys(cart).map((menuId) => ({
        id_menu: Number(menuId),
        jumlah: cart[Number(menuId)]
      }));

      const payload = {
        id_kamar: Number(selectedKamarId),
        items
      };

      const response = await fetch('http://localhost:3002/api/restoran/order-to-room', {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify(payload)
      });

      const resData = await response.json();
      if (resData.success) {
        alert(`Sukses: ${resData.message}`);
        clearCart();
        fetchData();
      } else {
        alert(`Gagal: ${resData.message}`);
      }
    } catch (err: any) {
      alert(`Terjadi kesalahan jaringan: ${err.message}`);
    } finally {
      setIsSubmitting(false);
    }
  };

  const getMenuEmoji = (nama: string) => {
    if (nama.includes('Nasi')) return '🍛';
    if (nama.includes('Mie')) return '🍜';
    if (nama.includes('Sup')) return '🍲';
    if (nama.includes('Teh')) return '🍹';
    if (nama.includes('Jus')) return '🍊';
    if (nama.includes('Cake') || nama.includes('Kue') || nama.includes('Es Krim')) return '🍰';
    return '🍽️';
  };

  const formatIDR = (num: number) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(num);
  };

  return (
    <div className="flex h-screen bg-[#fdfbf7] text-black font-sans overflow-hidden">
      
      <NeoSidebar user={user} />

      <main className="flex-1 flex flex-col h-full relative overflow-hidden">
        
        <NeoHeader user={user} title="RESTORAN POS" />

        <div className="flex-1 overflow-y-auto p-6 md:p-8 flex flex-col lg:flex-row gap-8 relative">
          
          <div className="flex-1 flex flex-col">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
              <div>
                <h2 className="text-4xl md:text-5xl font-black tracking-tighter uppercase">DAFTAR MENU</h2>
                <p className="font-bold text-gray-700 mt-2">Pesan antar makanan langsung dimasukkan ke tagihan kamar</p>
              </div>
            </div>

            {loading && <div className="text-2xl font-black animate-pulse py-10">MEMUAT HIDANGAN...</div>}
            {error && <div className="text-2xl font-black text-[#f0544f] py-4 px-6 border-4 border-black bg-white shadow-[4px_4px_0_0_#000] mb-8 inline-block">ERROR: {error}</div>}

            {!loading && !error && (
              <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 pb-10">
                {menuList.map((menu) => {
                  const quantityInCart = cart[menu.id_menu] || 0;
                  return (
                    <div 
                      key={menu.id_menu}
                      className="bg-white border-4 border-black p-4 shadow-[4px_4px_0_0_#000] flex flex-col justify-between transition-transform hover:-translate-y-1 hover:shadow-[6px_6px_0_0_#000]"
                    >
                      <div className="flex gap-4">
                        <div className="text-5xl bg-[#ffcf00] border-4 border-black w-20 h-20 flex items-center justify-center shadow-[2px_2px_0_0_#000]">
                          {getMenuEmoji(menu.nama_menu)}
                        </div>
                        <div className="flex-1">
                          <span className={`text-xs font-black px-2 py-1 uppercase tracking-widest border-2 border-black inline-block mb-2 shadow-[2px_2px_0_0_#000] ${
                            menu.kategori === 'MAKANAN' ? 'bg-[#f0544f] text-white' : 
                            menu.kategori === 'MINUMAN' ? 'bg-[#5ebdf7] text-black' :
                            'bg-[#ffcf00] text-black'
                          }`}>
                            {menu.kategori}
                          </span>
                          <h3 className="font-black text-xl leading-tight">{menu.nama_menu}</h3>
                          <div className="text-[#2b65e3] font-black text-lg mt-1">{formatIDR(Number(menu.harga))}</div>
                        </div>
                      </div>

                      <div className="mt-6">
                        {quantityInCart === 0 ? (
                          <button 
                            onClick={() => addToCart(menu)}
                            className="w-full bg-black text-white font-black py-2 border-4 border-black shadow-[2px_2px_0_0_#ffcf00] hover:bg-gray-800 transition-colors"
                          >
                            + TAMBAH
                          </button>
                        ) : (
                          <div className="flex items-center justify-between bg-white border-4 border-black shadow-[2px_2px_0_0_#000]">
                            <button 
                              onClick={() => removeFromCart(menu.id_menu)}
                              className="w-12 h-10 flex items-center justify-center bg-[#f0544f] text-black font-black text-xl border-r-4 border-black hover:bg-red-400"
                            >
                              -
                            </button>
                            <span className="font-black text-xl">{quantityInCart}</span>
                            <button 
                              onClick={() => addToCart(menu)}
                              className="w-12 h-10 flex items-center justify-center bg-[#5ebdf7] text-black font-black text-xl border-l-4 border-black hover:bg-blue-400"
                            >
                              +
                            </button>
                          </div>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>

          {/* RIGHT PANEL - CART */}
          <div className="w-full lg:w-[400px] shrink-0">
            <div className="bg-[#f0544f] border-4 border-black rounded-2xl shadow-[8px_8px_0_0_#000] p-6 text-black sticky top-6">
              
              <h3 className="text-3xl font-black leading-tight mb-6 uppercase text-white">
                KERANJANG PESANAN
              </h3>

              <div className="bg-white border-4 border-black p-4 shadow-[4px_4px_0_0_#000] mb-6">
                <label className="block font-black mb-2 uppercase">CHARGE-TO-ROOM:</label>
                <select
                  value={selectedKamarId}
                  onChange={(e) => setSelectedKamarId(e.target.value)}
                  className="w-full p-3 bg-white border-4 border-black font-black text-lg outline-none shadow-[2px_2px_0_0_#000] cursor-pointer"
                >
                  <option value="" disabled>-- PILIH KAMAR TAMU --</option>
                  {roomList.map((room) => (
                    <option key={room.id_kamar} value={room.id_kamar}>
                      KAMAR {room.nomor_kamar} ({room.nama_tamu_sekarang})
                    </option>
                  ))}
                </select>
                {roomList.length === 0 && !loading && (
                  <p className="text-sm font-bold text-red-600 mt-2">Tidak ada kamar berstatus Terisi saat ini.</p>
                )}
              </div>

              {Object.keys(cart).length === 0 ? (
                <div className="bg-white border-4 border-black p-8 text-center shadow-[4px_4px_0_0_#000]">
                  <div className="text-5xl mb-4">🛒</div>
                  <p className="font-black text-xl uppercase">Keranjang Kosong</p>
                </div>
              ) : (
                <div className="bg-white border-4 border-black shadow-[4px_4px_0_0_#000] flex flex-col">
                  <div className="p-4 border-b-4 border-black bg-gray-100 flex justify-between items-center">
                    <h4 className="font-black text-lg">ITEM PESANAN</h4>
                    <button onClick={clearCart} className="text-xs font-black bg-red-600 text-white px-2 py-1 border-2 border-black hover:bg-red-700">CLEAR</button>
                  </div>
                  
                  <div className="max-h-64 overflow-y-auto p-4 space-y-4">
                    {Object.keys(cart).map((menuId) => {
                      const menu = menuList.find((m) => m.id_menu === Number(menuId));
                      if (!menu) return null;
                      return (
                        <div key={menuId} className="flex justify-between items-start border-b-2 border-black border-dashed pb-2">
                          <div>
                            <div className="font-black">{menu.nama_menu}</div>
                            <div className="text-sm font-bold text-gray-600">{formatIDR(Number(menu.harga))} x {cart[Number(menuId)]}</div>
                          </div>
                          <div className="font-black text-lg">
                            {formatIDR(Number(menu.harga) * cart[Number(menuId)])}
                          </div>
                        </div>
                      );
                    })}
                  </div>

                  <div className="p-4 bg-black text-[#ffcf00] border-t-4 border-black flex justify-between items-center">
                    <span className="font-black text-xl">TOTAL:</span>
                    <span className="font-black text-2xl">{formatIDR(getCartTotal())}</span>
                  </div>
                </div>
              )}

              <button
                onClick={handleCheckout}
                disabled={isSubmitting || Object.keys(cart).length === 0}
                className="w-full mt-6 bg-[#ffcf00] border-4 border-black text-black font-black text-2xl py-4 uppercase shadow-[4px_4px_0_0_#000] hover:bg-yellow-400 hover:translate-y-1 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isSubmitting ? 'MEMPROSES...' : 'CONFIRM ORDER 🛎️'}
              </button>

            </div>
          </div>
          
        </div>
      </main>
    </div>
  );
}
