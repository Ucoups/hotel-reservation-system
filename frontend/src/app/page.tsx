'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import Cookies from 'js-cookie';
import NeoSidebar from '@/components/NeoSidebar';
import NeoHeader from '@/components/NeoHeader';

// Tipe Data sesuai dari Backend (View vw_status_kamar_opsional)
interface Kamar {
  id_kamar: number;
  nomor_kamar: string;
  lantai: string;
  nama_tipe: string;
  harga_per_malam: number;
  status_kamar: 'Tersedia' | 'Dipesan' | 'Terisi' | 'Perawatan' | 'Kotor';
  nama_tamu_sekarang: string | null;
  tagihan_restoran?: number;
  tagihan_layanan_tambahan?: number;
}

export default function DashboardResepsionis() {
  const [kamarList, setKamarList] = useState<Kamar[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // State untuk Filter Horizontal
  const [filterLantai, setFilterLantai] = useState<string>('');
  const [filterJenis, setFilterJenis] = useState<string>('');
  const [filterStatus, setFilterStatus] = useState<string>('');

  // State untuk Form Check-In Walk-In
  const [showCheckInForm, setShowCheckInForm] = useState(false);
  const [selectedKamar, setSelectedKamar] = useState<Kamar | null>(null);
  const [formData, setFormData] = useState({ nama_tamu: '', email: '', durasi_menginap: 1 });
  
  // State untuk Layanan Tambahan
  const [layananMaster, setLayananMaster] = useState<{id_layanan: number, nama_layanan: string, harga: number, tipe_charge: 'PER_JAM' | 'PER_HARI' | 'PER_SEKALI_AKSI'}[]>([]);
  const [selectedLayanan, setSelectedLayanan] = useState('');
  const [jumlahLayanan, setJumlahLayanan] = useState(1);
  const [isOrderingLayanan, setIsOrderingLayanan] = useState(false);

  const router = useRouter();
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

  const fetchStatusKamar = async () => {
    try {
      const response = await fetch('http://localhost:3002/api/dashboard/status-kamar', {
        headers: getHeaders()
      });
      if (!response.ok) throw new Error('Gagal mengambil data dari server');
      
      const data = await response.json();
      if (data.success) {
        setKamarList(data.data);
        setSelectedKamar((prevSelected) => {
          if (!prevSelected) return null;
          const updated = data.data.find((k: Kamar) => k.id_kamar === prevSelected.id_kamar);
          return updated || null;
        });
      } else {
        setError(data.message);
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchLayananMaster = async () => {
    try {
      const response = await fetch('http://localhost:3002/api/reservasi/layanan-tambahan/master', {
        headers: getHeaders()
      });
      if (response.ok) {
        const data = await response.json();
        setLayananMaster(data.data || []);
      }
    } catch (e) {}
  };

  useEffect(() => {
    fetchStatusKamar();
    fetchLayananMaster();
    const interval = setInterval(() => {
      fetchStatusKamar();
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  // Handlers
  const handleCheckIn = async () => {
    if (!selectedKamar) return;
    if (!formData.nama_tamu) return alert('Nama tamu wajib diisi!');

    try {
      const payload = {
        id_kamar: selectedKamar.id_kamar,
        nama_tamu: formData.nama_tamu,
        email: formData.email,
        durasi_menginap: formData.durasi_menginap
      };

      const response = await fetch(`http://localhost:3002/api/kamar/checkin`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify(payload)
      });
      
      const data = await response.json();
      if (data.success) {
        alert(`Sukses: ${data.message}`);
        setShowCheckInForm(false);
        setFormData({ nama_tamu: '', email: '', durasi_menginap: 1 });
        fetchStatusKamar(); 
      } else {
        alert(`Peringatan: ${data.message}`);
      }
    } catch (err: any) {
      alert(`Terjadi kesalahan jaringan: ${err.message}`);
    }
  };

  const handlePesanLayanan = async () => {
    if (!selectedKamar || !selectedLayanan) return;
    setIsOrderingLayanan(true);

    try {
      const payload = {
        id_kamar: selectedKamar.id_kamar,
        id_layanan: Number(selectedLayanan),
        jumlah: jumlahLayanan
      };

      const response = await fetch(`http://localhost:3002/api/reservasi/layanan-tambahan`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify(payload)
      });
      
      const data = await response.json();
      if (data.success) {
        setSelectedLayanan('');
        setJumlahLayanan(1);
        fetchStatusKamar(); 
      } else {
        alert(`Peringatan: ${data.message}`);
      }
    } catch (err: any) {
      alert(`Terjadi kesalahan jaringan: ${err.message}`);
    } finally {
      setIsOrderingLayanan(false);
    }
  };

  const handleCheckOut = async () => {
    if (!selectedKamar) return;
    if (!confirm(`Apakah Anda yakin ingin memproses Check-Out untuk Kamar ${selectedKamar.nomor_kamar}?`)) return;

    try {
      const response = await fetch(`http://localhost:3002/api/kamar/checkout`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify({ id_kamar: selectedKamar.id_kamar })
      });
      
      const data = await response.json();
      if (data.success) {
        const detail = data.data;
        const formatCurrency = (val: number) => 
          new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(val);
        
        alert(
          `Sukses Check-Out Kamar ${selectedKamar.nomor_kamar}!\n\n` +
          `Rincian Invoice Akhir:\n` +
          `-------------------------------\n` +
          `• Biaya Sewa Kamar     : ${formatCurrency(detail.total_biaya_kamar || 0)}\n` +
          `• Biaya Restoran (F&B) : ${formatCurrency(detail.total_biaya_restoran || 0)}\n` +
          `• Layanan Tambahan     : ${formatCurrency(detail.total_biaya_layanan_tambahan || 0)}\n` +
          `-------------------------------\n` +
          `Grand Total Tagihan    : ${formatCurrency(detail.grand_total_tagihan || 0)}\n\n` +
          `Status kamar kini telah diubah kembali menjadi 'Tersedia'.`
        );
        fetchStatusKamar();
        setSelectedKamar(null);
      } else {
        alert(`Peringatan: ${data.message}`);
      }
    } catch (err: any) {
      alert(`Terjadi kesalahan jaringan: ${err.message}`);
    }
  };

  const formatCurrency = (amount: number | string) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(amount));
  };

  // Neobrutalism Styles Logic
  const getCardStyle = (status: string, isSelected: boolean) => {
    let baseStyle = "border-4 border-black p-4 flex flex-col justify-between transition-transform duration-200 cursor-pointer ";
    baseStyle += isSelected ? "shadow-[8px_8px_0_0_#000] -translate-y-1 -translate-x-1 " : "shadow-[4px_4px_0_0_#000] hover:shadow-[6px_6px_0_0_#000] hover:-translate-y-0.5 hover:-translate-x-0.5 ";
    
    switch (status) {
      case 'Tersedia': 
        return baseStyle + "bg-white text-black rounded-2xl";
      case 'Terisi': 
        return baseStyle + "bg-[#2b65e3] text-white rounded-2xl";
      case 'Dipesan': 
        return baseStyle + "bg-[#5ebdf7] text-black rounded-2xl";
      case 'Kotor': 
        return baseStyle + "bg-[#f0544f] text-black rounded-2xl";
      case 'Perawatan': 
        return baseStyle + "bg-[#ffcf00] text-black rounded-2xl";
      default: 
        return baseStyle + "bg-white text-black rounded-2xl";
    }
  };

  // Data turunan untuk Filter
  const uniqueLantai = Array.from(new Set(kamarList.map(k => k.lantai))).sort();
  const uniqueJenis = Array.from(new Set(kamarList.map(k => k.nama_tipe))).sort();
  const uniqueStatus = Array.from(new Set(kamarList.map(k => k.status_kamar))).sort();

  const filteredKamarList = kamarList.filter(kamar => {
    if (filterLantai && kamar.lantai !== filterLantai) return false;
    if (filterJenis && kamar.nama_tipe !== filterJenis) return false;
    if (filterStatus && kamar.status_kamar !== filterStatus) return false;
    return true;
  });

  return (
    <div className="flex h-screen bg-[#fdfbf7] text-black font-sans overflow-hidden">
      
      {/* SIDEBAR */}
      <NeoSidebar user={user} />

      {/* MAIN CONTENT AREA */}
      <main className="flex-1 flex flex-col h-full relative overflow-hidden">
        
        {/* HEADER */}
        <NeoHeader user={user} title="NEO-HOTEL PMS" />

        {/* DASHBOARD CONTENT */}
        <div className="flex-1 overflow-y-auto p-6 md:p-8 flex flex-col lg:flex-row gap-8 relative">
          
          {/* DECORATION */}
          <div className="absolute top-2 left-[35%] opacity-80 pointer-events-none hidden md:block">
            <svg width="60" height="60" viewBox="0 0 24 24" fill="white" stroke="black" strokeWidth="2">
               <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
               <circle cx="9" cy="10" r="1.5" fill="black"></circle>
               <circle cx="15" cy="10" r="1.5" fill="black"></circle>
               <circle cx="12" cy="10" r="1.5" fill="black"></circle>
            </svg>
          </div>

          <div className="flex-1 flex flex-col">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-6 gap-4">
              <h2 className="text-4xl md:text-5xl font-black tracking-tighter">ROOM AVAILABILITY</h2>
              <div className="bg-black text-[#ffcf00] font-bold px-4 py-2 border-2 border-black rounded-lg shadow-[4px_4px_0_0_#ffcf00]">
                RESERVASI AKTIF
              </div>
            </div>

            {/* FILTER HORIZONTAL NEOBRUTALISM */}
            <div className="flex flex-row gap-4 flex-wrap mb-6">
              <select 
                className="w-full md:w-auto px-4 py-2 border-4 border-black font-bold bg-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] focus:outline-none cursor-pointer appearance-none pr-10"
                style={{ backgroundImage: 'url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23000%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E")', backgroundRepeat: 'no-repeat', backgroundPosition: 'right 1rem top 50%', backgroundSize: '0.65rem auto' }}
                value={filterLantai}
                onChange={(e) => setFilterLantai(e.target.value)}
              >
                <option value="">Semua Lantai</option>
                {uniqueLantai.map(l => <option key={l} value={l}>Lantai {l}</option>)}
              </select>

              <select 
                className="w-full md:w-auto px-4 py-2 border-4 border-black font-bold bg-[#ffcf00] shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] focus:outline-none cursor-pointer appearance-none pr-10"
                style={{ backgroundImage: 'url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23000%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E")', backgroundRepeat: 'no-repeat', backgroundPosition: 'right 1rem top 50%', backgroundSize: '0.65rem auto' }}
                value={filterJenis}
                onChange={(e) => setFilterJenis(e.target.value)}
              >
                <option value="">Semua Tipe Kamar</option>
                {uniqueJenis.map(j => <option key={j} value={j}>{j}</option>)}
              </select>

              <select 
                className="w-full md:w-auto px-4 py-2 border-4 border-black font-bold bg-[#5ebdf7] shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] focus:outline-none cursor-pointer appearance-none pr-10"
                style={{ backgroundImage: 'url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23000%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E")', backgroundRepeat: 'no-repeat', backgroundPosition: 'right 1rem top 50%', backgroundSize: '0.65rem auto' }}
                value={filterStatus}
                onChange={(e) => setFilterStatus(e.target.value)}
              >
                <option value="">Semua Status</option>
                {uniqueStatus.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>

            {/* TABLE HEADER */}
            <div className="bg-[#2b65e3] border-4 border-black text-white font-black px-6 py-3 text-lg md:text-xl rounded-xl shadow-[4px_4px_0_0_#000] mb-6 flex justify-between tracking-widest hidden md:flex">
              <span className="w-1/4">ROOM</span>
              <span className="w-1/4 text-center">| STATUS</span>
              <span className="w-1/4 text-center">| RESERVATION</span>
              <span className="w-1/4 text-right">| ACTION</span>
            </div>

            {/* ERROR/LOADING */}
            {loading && <div className="text-xl font-bold py-10 animate-pulse">Memuat data kamar...</div>}
            {error && <div className="text-xl font-bold py-10 text-[#f0544f]">Error: {error}</div>}

            {/* ROOM GRID */}
            {!loading && !error && (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 pb-10">
                {filteredKamarList.length === 0 ? (
                  <div className="col-span-full py-10 text-center border-4 border-dashed border-black bg-white rounded-xl shadow-[4px_4px_0_0_#000]">
                    <h3 className="text-2xl font-black">⚠️ TIDAK ADA KAMAR YANG COCOK</h3>
                    <p className="font-bold text-gray-600 mt-2">Silakan ubah kriteria filter Anda.</p>
                  </div>
                ) : (
                  filteredKamarList.map((kamar) => (
                  <div 
                    key={kamar.id_kamar} 
                    onClick={() => { setSelectedKamar(kamar); setShowCheckInForm(false); }}
                    className={getCardStyle(kamar.status_kamar, selectedKamar?.id_kamar === kamar.id_kamar)}
                  >
                    <div>
                      <h3 className="text-2xl font-black mb-1">
                        {kamar.status_kamar === 'Terisi' ? 'OCCUPIED' : 
                         kamar.status_kamar === 'Kotor' ? 'DIRTY' : 
                         kamar.status_kamar === 'Perawatan' ? 'VIP' : kamar.nomor_kamar}
                      </h3>
                      {kamar.status_kamar === 'Terisi' && (
                        <>
                          <p className="font-bold text-lg">{kamar.nama_tamu_sekarang}</p>
                          <p className="font-bold text-xs opacity-80">(Room: {kamar.nomor_kamar})</p>
                        </>
                      )}
                      {kamar.status_kamar === 'Tersedia' && (
                        <>
                          <p className="font-bold text-lg text-gray-600">{kamar.nama_tipe}</p>
                          <p className="font-bold text-xs opacity-80">(Role: Resepsionis)</p>
                        </>
                      )}
                      {(kamar.status_kamar === 'Kotor' || kamar.status_kamar === 'Perawatan') && (
                        <p className="font-bold text-lg">Room {kamar.nomor_kamar}</p>
                      )}
                    </div>
                    
                    <div className="mt-6 flex justify-between items-end">
                      {kamar.status_kamar === 'Tersedia' ? (
                        <div className="w-full text-center font-black">
                          <p className="mb-2">AVAILABLE</p>
                          <button 
                            className="bg-black text-white w-full py-2 border-2 border-black rounded shadow-[2px_2px_0_0_#ffcf00] hover:bg-gray-800 transition-colors"
                            onClick={(e) => { e.stopPropagation(); setSelectedKamar(kamar); setShowCheckInForm(true); }}
                          >
                            BOOK NOW
                          </button>
                        </div>
                      ) : kamar.status_kamar === 'Perawatan' ? (
                        <div className="w-full flex justify-center text-5xl">
                          ★
                        </div>
                      ) : kamar.status_kamar === 'Kotor' ? (
                        <div className="w-full flex justify-center">
                          <span className="text-3xl">🧹</span>
                        </div>
                      ) : null}
                    </div>
                    
                    {/* Smiley decoration on some cards */}
                    {kamar.id_kamar % 5 === 0 && (
                      <div className="absolute -left-3 -top-3 bg-[#ffcf00] border-2 border-black rounded-full p-1 shadow-[2px_2px_0_0_#000]">
                        🙂
                      </div>
                    )}
                  </div>
                )))}
              </div>
            )}
          </div>

          {/* RIGHT PANEL - SUITE DETAILS */}
          <div className="w-full lg:w-[400px] shrink-0">
            <div className="bg-[#2b65e3] border-4 border-black rounded-2xl shadow-[8px_8px_0_0_#000] p-6 text-white sticky top-6">
              
              {!selectedKamar ? (
                <div className="h-64 flex flex-col items-center justify-center text-center opacity-80">
                  <div className="text-6xl mb-4">👈</div>
                  <h3 className="text-2xl font-black">PILIH KAMAR</h3>
                  <p className="font-bold mt-2">Klik salah satu kartu kamar di area kiri untuk melihat detail.</p>
                </div>
              ) : (
                <>
                  <h3 className="text-3xl font-black leading-tight mb-8">
                    COBALT SUITE DETAILS - ROOM {selectedKamar.nomor_kamar}
                  </h3>

                  {/* ACTIONS BOXES */}
                  <div className="flex gap-4 mb-8 text-black">
                    {selectedKamar.status_kamar === 'Terisi' ? (
                      <>
                        <button 
                          onClick={handleCheckOut}
                          className="flex-1 bg-white border-4 border-black p-3 rounded-xl shadow-[4px_4px_0_0_#000] flex flex-col items-center justify-center gap-2 hover:-translate-y-1 hover:shadow-[6px_6px_0_0_#000] transition-all"
                        >
                          <svg className="w-8 h-8" fill="none" stroke="currentColor" strokeWidth="3" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                          <span className="font-black text-center text-sm leading-tight">PROSES<br/>CHECK-OUT</span>
                        </button>
                        
                        <div className="flex-1 flex flex-col gap-2">
                          <select 
                            className="w-full text-xs bg-white border-4 border-black rounded p-2 outline-none font-black text-black shadow-[2px_2px_0_0_#000]"
                            value={selectedLayanan}
                            onChange={(e) => setSelectedLayanan(e.target.value)}
                          >
                            <option value="">-- LAYANAN --</option>
                            {layananMaster.map(ly => (
                              <option key={ly.id_layanan} value={ly.id_layanan}>{ly.nama_layanan}</option>
                            ))}
                          </select>
                          <div className="flex gap-1">
                            <input 
                              type="number" min="1" value={jumlahLayanan} 
                              onChange={(e) => setJumlahLayanan(parseInt(e.target.value) || 1)}
                              className="w-12 text-xs bg-white border-4 border-black rounded p-1 outline-none text-center font-black shadow-[2px_2px_0_0_#000]"
                            />
                            <button 
                              onClick={handlePesanLayanan}
                              disabled={!selectedLayanan || isOrderingLayanan}
                              className="flex-1 bg-[#ffcf00] border-4 border-black text-black text-xs font-black rounded shadow-[2px_2px_0_0_#000] disabled:opacity-50 hover:bg-yellow-300 transition-colors"
                            >
                              + ADD
                            </button>
                          </div>
                        </div>
                      </>
                    ) : (showCheckInForm || selectedKamar.status_kamar === 'Tersedia' || selectedKamar.status_kamar === 'Dipesan') ? (
                      <div className="w-full bg-white border-4 border-black p-4 rounded-xl shadow-[4px_4px_0_0_#000]">
                         <h4 className="font-black mb-3">DATA TAMU (WALK-IN)</h4>
                         <input type="text" placeholder="NAMA LENGKAP" className="w-full border-4 border-black p-2 mb-2 font-bold outline-none" value={formData.nama_tamu} onChange={e => setFormData({...formData, nama_tamu: e.target.value})} />
                         <input type="email" placeholder="EMAIL" className="w-full border-4 border-black p-2 mb-2 font-bold outline-none" value={formData.email} onChange={e => setFormData({...formData, email: e.target.value})} />
                         <div className="flex gap-2 items-center mb-4">
                            <span className="font-black text-sm">MALAM:</span>
                            <input type="number" min="1" className="w-16 border-4 border-black p-1 font-bold outline-none text-center" value={formData.durasi_menginap} onChange={e => setFormData({...formData, durasi_menginap: parseInt(e.target.value) || 1})} />
                         </div>
                         <button onClick={handleCheckIn} className="w-full bg-[#f0544f] text-black border-4 border-black p-2 font-black shadow-[2px_2px_0_0_#000] hover:bg-red-400">
                           CONFIRM CHECK-IN
                         </button>
                      </div>
                    ) : (
                      <div className="w-full bg-[#ffcf00] border-4 border-black p-4 rounded-xl shadow-[4px_4px_0_0_#000] text-center font-black">
                        KAMAR SEDANG TIDAK TERSEDIA UNTUK CHECK-IN
                      </div>
                    )}
                  </div>

                  {/* BILLING SUMMARY TABLE */}
                  <div className="bg-white text-black border-4 border-black shadow-[4px_4px_0_0_#000]">
                    <div className="border-b-4 border-black p-3 bg-gray-100">
                      <h4 className="font-black text-lg">BILLING SUMMARY</h4>
                    </div>
                    
                    <div className="p-0">
                      <table className="w-full text-sm font-bold">
                        <tbody>
                          {selectedKamar.status_kamar === 'Terisi' ? (
                            <>
                              <tr className="border-b-2 border-black">
                                <td className="p-3 border-r-2 border-black w-2/3">Kamar (Sewa Base)</td>
                                <td className="p-3 text-right">{formatCurrency(selectedKamar.harga_per_malam)}</td>
                              </tr>
                              <tr className="border-b-2 border-black">
                                <td className="p-3 border-r-2 border-black">Restoran<br/><span className="text-xs font-normal">(Charge-to-Room)</span></td>
                                <td className="p-3 text-right">{formatCurrency(selectedKamar.tagihan_restoran || 0)}</td>
                              </tr>
                              <tr className="border-b-4 border-black">
                                <td className="p-3 border-r-2 border-black">Layanan Ekstra<br/><span className="text-xs font-normal">({selectedKamar.tagihan_layanan_tambahan ? 'Active' : 'None'})</span></td>
                                <td className="p-3 text-right">{formatCurrency(selectedKamar.tagihan_layanan_tambahan || 0)}</td>
                              </tr>
                            </>
                          ) : (
                             <tr className="border-b-4 border-black">
                                <td className="p-3 border-r-2 border-black w-2/3">Base Rate per Malam</td>
                                <td className="p-3 text-right">{formatCurrency(selectedKamar.harga_per_malam)}</td>
                              </tr>
                          )}
                        </tbody>
                      </table>
                    </div>

                    <div className="bg-[#2b65e3] text-white p-3 font-black text-lg flex justify-between">
                      <span>GRAND TOTAL:</span>
                      <span>
                        {selectedKamar.status_kamar === 'Terisi' 
                          ? formatCurrency(
                              (selectedKamar.harga_per_malam /* Assuming 1 night for preview, backend does real math */) + 
                              (selectedKamar.tagihan_restoran || 0) + 
                              (selectedKamar.tagihan_layanan_tambahan || 0)
                            )
                          : formatCurrency(selectedKamar.harga_per_malam)
                        }
                      </span>
                    </div>
                  </div>
                </>
              )}
              
              {/* DECORATIVE ARROW */}
              <div className="absolute -right-6 -top-6 text-black z-30">
                 <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M12 19V5"></path>
                    <path d="M5 12l7-7 7 7"></path>
                 </svg>
              </div>
            </div>
          </div>
          
        </div>
      </main>
    </div>
  );
}
