'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import Cookies from 'js-cookie';
import NeoSidebar from '@/components/NeoSidebar';
import NeoHeader from '@/components/NeoHeader';
import {
  ResponsiveContainer,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  PieChart,
  Pie,
  Cell,
  Legend
} from 'recharts';

interface LaporanOmsetRow {
  periode: string;
  total_transaksi: number;
  total_omset: number;
  omset_bersih_bulanan: string;
}

interface KPIData {
  total_omset: number;
  kamar_terlaris: string;
  rasio_okupansi: number;
}

interface PerformaStaf {
  id_pegawai: number;
  nama_pegawai: string;
  jabatan: string;
  jumlah_handle_reservasi: number;
  jumlah_handle_checkin: number;
  jumlah_handle_checkout: number;
}

interface LogAktivitas {
  id_log: number;
  id_pegawai: number | null;
  aktivitas: string;
  waktu_aktivitas: string;
  keterangan: string | null;
  pegawai?: {
    nama_pegawai: string;
    jabatan: string;
  } | null;
}

interface NightAuditResult {
  roomRevenue: number;
  restaurantRevenue: number;
  servicesRevenue: number;
  totalRevenue: number;
  keterangan: string;
}

export default function AdminAnalytics() {
  const [kpi, setKpi] = useState<KPIData | null>(null);
  const [omsetList, setOmsetList] = useState<LaporanOmsetRow[]>([]);
  const [stafList, setStafList] = useState<PerformaStaf[]>([]);
  const [auditLogs, setAuditLogs] = useState<LogAktivitas[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [isMounted, setIsMounted] = useState(false);

  // Night Audit State
  const [isNightAuditing, setIsNightAuditing] = useState(false);
  const [nightAuditResult, setNightAuditResult] = useState<NightAuditResult | null>(null);
  const [showNightAuditModal, setShowNightAuditModal] = useState(false);

  const [user, setUser] = useState<{ nama_pegawai?: string; jabatan?: string }>({});

  useEffect(() => {
    setIsMounted(true);
    const userCookie = Cookies.get('user');
    if (userCookie) {
      try {
        setUser(JSON.parse(userCookie));
      } catch (e) {}
    }
  }, []);

  const getHeaders = () => {
    return {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${Cookies.get('token')}`
    };
  };

  const fetchData = async () => {
    setIsRefreshing(true);
    try {
      // 1. Fetch Omset
      const omsetRes = await fetch('http://localhost:3002/api/admin/laporan-omset', { headers: getHeaders() });
      if (!omsetRes.ok) throw new Error('Gagal mengambil data laporan omset');
      const omsetData = await omsetRes.json();

      // 2. Fetch Staf Performa
      const stafRes = await fetch('http://localhost:3002/api/admin/performa-staf', { headers: getHeaders() });
      if (!stafRes.ok) throw new Error('Gagal mengambil data performa staf');
      const stafData = await stafRes.json();

      // 3. Fetch Audit Logs
      const logsRes = await fetch('http://localhost:3002/api/admin/logs', { headers: getHeaders() });
      if (!logsRes.ok) throw new Error('Gagal mengambil data audit logs');
      const logsData = await logsRes.json();

      if (omsetData.success && stafData.success && logsData.success) {
        setKpi(omsetData.kpi);
        setOmsetList(omsetData.data);
        setStafList(stafData.data);
        setAuditLogs(logsData.data);
        setError(null);
      } else {
        setError(omsetData.message || stafData.message || logsData.message);
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
      setIsRefreshing(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  // Handler for Night Audit Execution
  const handleRunNightAudit = async () => {
    if (!confirm('Apakah Anda yakin ingin melakukan penutupan buku harian (Night Audit)? Tindakan ini akan membekukan transaksi hari ini.')) {
      return;
    }
    setIsNightAuditing(true);
    try {
      const res = await fetch('http://localhost:3002/api/admin/night-audit', {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify({ id_pegawai: 1 }) // admin system
      });
      const data = await res.json();
      if (data.success) {
        setNightAuditResult(data.data);
        setShowNightAuditModal(true);
        // Refresh dashboard data
        fetchData();
      } else {
        alert('Gagal menjalankan Night Audit: ' + data.message);
      }
    } catch (err: any) {
      alert('Error: ' + err.message);
    } finally {
      setIsNightAuditing(false);
    }
  };

  const filteredStaf = stafList.filter(
    (staf) =>
      staf.nama_pegawai.toLowerCase().includes(searchTerm.toLowerCase()) ||
      staf.jabatan.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const formatIDR = (num: number) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(num);
  };

  // Mock daily trend occupancy data for last 7 days as requested
  const dailyTrends = [
    { day: 'Senin', revenue: 4200000, occupancy: 65 },
    { day: 'Selasa', revenue: 3800000, occupancy: 58 },
    { day: 'Rabu', revenue: 5100000, occupancy: 70 },
    { day: 'Kamis', revenue: 4900000, occupancy: 68 },
    { day: 'Jumat', revenue: 7500000, occupancy: 85 },
    { day: 'Sabtu', revenue: 9200000, occupancy: 95 },
    { day: 'Minggu', revenue: 8000000, occupancy: 88 },
  ];

  // Pie Chart Data mapping
  const pieData = kpi
    ? [
        { name: 'Kamar (Room)', value: kpi.total_omset * 0.65 },
        { name: 'Restoran (F&B)', value: kpi.total_omset * 0.2 },
        { name: 'Extra Services', value: kpi.total_omset * 0.15 }
      ]
    : [
        { name: 'Kamar (Room)', value: 6500000 },
        { name: 'Restoran (F&B)', value: 2000000 },
        { name: 'Extra Services', value: 1500000 }
      ];

  const PIE_COLORS = ['#ffcf00', '#f0544f', '#2b65e3']; // Yellow, Red, Blue

  const getLogStyle = (aktivitas: string) => {
    const act = aktivitas.toUpperCase();
    if (act.includes('CHECK-IN') || act.includes('CHECKIN')) {
      return {
        bg: 'bg-[#e2f9f0] hover:bg-[#c2f3de]',
        border: 'border-[#3ecf8e]',
        badge: 'bg-[#3ecf8e] text-black border-2 border-black',
        text: 'text-black'
      };
    } else if (act.includes('CHECK-OUT') || act.includes('CHECKOUT') || act.includes('SELESAI')) {
      return {
        bg: 'bg-[#feebeb] hover:bg-[#fdd5d5]',
        border: 'border-[#f0544f]',
        badge: 'bg-[#f0544f] text-white border-2 border-black',
        text: 'text-black'
      };
    } else if (act.includes('NIGHT AUDIT')) {
      return {
        bg: 'bg-[#f5e6ff] hover:bg-[#ecd1ff]',
        border: 'border-[#b14bf0]',
        badge: 'bg-[#b14bf0] text-white border-2 border-black',
        text: 'text-black'
      };
    } else {
      // Default: Extra Services or others
      return {
        bg: 'bg-[#fffbeb] hover:bg-[#fff0c2]',
        border: 'border-[#ffcf00]',
        badge: 'bg-[#ffcf00] text-black border-2 border-black',
        text: 'text-black'
      };
    }
  };

  return (
    <div className="flex h-screen bg-[#fdfbf7] text-black font-sans overflow-hidden">
      <NeoSidebar user={user} />

      <main className="flex-1 flex flex-col h-full relative overflow-hidden">
        <NeoHeader user={user} title="LAPORAN & ANALITIK" />

        <div className="flex-1 overflow-y-auto p-6 md:p-8 relative">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
            <div>
              <h2 className="text-4xl md:text-5xl font-black tracking-tighter uppercase">EXECUTIVE DASHBOARD</h2>
              <p className="font-bold text-gray-700 mt-2">Wawasan pendapatan hotel dan evaluasi KPI staf operasional</p>
            </div>

            <div className="flex flex-wrap items-center gap-3 w-full sm:w-auto">
              <Link
                href="/admin/kamar"
                className="bg-[#5ebdf7] border-4 border-black font-black px-4 py-2 hover:-translate-y-1 hover:shadow-[4px_4px_0_0_#000] transition-all"
              >
                KAMAR CMS
              </Link>
              <Link
                href="/admin/restoran"
                className="bg-[#ffcf00] border-4 border-black font-black px-4 py-2 hover:-translate-y-1 hover:shadow-[4px_4px_0_0_#000] transition-all"
              >
                RESTORAN CMS
              </Link>
              <button
                onClick={fetchData}
                disabled={isRefreshing}
                className="bg-white border-4 border-black font-black px-4 py-2 hover:-translate-y-1 hover:shadow-[4px_4px_0_0_#000] transition-all disabled:opacity-50 flex items-center gap-2"
              >
                <span className={isRefreshing ? 'animate-spin inline-block' : ''}>↻</span> REFRESH
              </button>
            </div>
          </div>

          {loading && <div className="text-2xl font-black animate-pulse py-10">LOADING ANALYTICS...</div>}
          {error && <div className="text-2xl font-black text-[#f0544f] py-10">ERROR: {error}</div>}

          {!loading && !error && (
            <div className="space-y-8 pb-10">
              {/* KPI CARDS */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-[#2b65e3] text-white p-6 border-4 border-black shadow-[8px_8px_0_0_#000] transform transition hover:-translate-y-1">
                  <h3 className="font-black text-sm mb-2">TOTAL PENDAPATAN (OMSET)</h3>
                  <div className="text-4xl md:text-5xl font-black break-words">
                    {kpi ? formatIDR(kpi.total_omset) : '-'}
                  </div>
                  <div className="mt-4 font-bold text-sm bg-black text-white inline-block px-2 py-1">
                    *Pembayaran lunas
                  </div>
                </div>

                <div className="bg-[#ffcf00] text-black p-6 border-4 border-black shadow-[8px_8px_0_0_#000] transform transition hover:-translate-y-1">
                  <h3 className="font-black text-sm mb-2">KAMAR TERPOPULER</h3>
                  <div className="text-4xl md:text-5xl font-black break-words">{kpi?.kamar_terlaris}</div>
                  <div className="mt-4 font-bold text-sm border-2 border-black inline-block px-2 py-1 bg-white">
                    ★ Terbanyak di-booking
                  </div>
                </div>

                <div className="bg-[#f0544f] text-black p-6 border-4 border-black shadow-[8px_8px_0_0_#000] transform transition hover:-translate-y-1">
                  <h3 className="font-black text-sm mb-2">RASIO OKUPANSI</h3>
                  <div className="text-4xl md:text-5xl font-black break-words">{kpi?.rasio_okupansi}%</div>

                  {/* Progress bar Neobrutalism */}
                  <div className="mt-4 h-6 border-4 border-black bg-white w-full relative">
                    <div
                      className="absolute top-0 left-0 h-full bg-black"
                      style={{ width: `${kpi?.rasio_okupansi || 0}%` }}
                    ></div>
                  </div>
                </div>
              </div>

              {/* CHARTS SECTION */}
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* LINE CHART: DAILY OCCUPANCY TREND */}
                <div className="lg:col-span-2 bg-white p-6 border-4 border-black shadow-[8px_8px_0_0_#000] flex flex-col justify-between">
                  <div>
                    <h3 className="text-2xl font-black mb-1 uppercase">OKUPANSI & PENDAPATAN HARIAN</h3>
                    <p className="text-sm font-bold text-gray-600 mb-6">Tren okupansi harian (%) & omset 7 hari terakhir</p>
                  </div>

                  <div className="h-72 w-full pr-4">
                    {isMounted ? (
                      <ResponsiveContainer width="100%" height="100%">
                        <LineChart data={dailyTrends}>
                          <CartesianGrid strokeDasharray="4 4" stroke="#000" strokeWidth={1} />
                          <XAxis dataKey="day" tick={{ fill: '#000', fontWeight: 'bold' }} stroke="#000" strokeWidth={2} />
                          <YAxis yAxisId="left" tick={{ fill: '#000', fontWeight: 'bold' }} stroke="#000" strokeWidth={2} />
                          <YAxis yAxisId="right" orientation="right" tick={{ fill: '#000', fontWeight: 'bold' }} stroke="#000" strokeWidth={2} />
                          <Tooltip
                            contentStyle={{
                              backgroundColor: '#fff',
                              border: '4px solid #000',
                              fontWeight: 'bold',
                              boxShadow: '4px 4px 0 0 #000'
                            }}
                          />
                          <Legend wrapperStyle={{ fontWeight: 'bold', paddingTop: '10px' }} />
                          <Line
                            yAxisId="left"
                            type="monotone"
                            dataKey="occupancy"
                            name="Okupansi (%)"
                            stroke="#f0544f"
                            strokeWidth={4}
                            dot={{ r: 6, stroke: '#000', strokeWidth: 2, fill: '#f0544f' }}
                            activeDot={{ r: 8, stroke: '#000', strokeWidth: 3 }}
                          />
                          <Line
                            yAxisId="right"
                            type="monotone"
                            dataKey="revenue"
                            name="Omset (Rp)"
                            stroke="#2b65e3"
                            strokeWidth={4}
                            dot={{ r: 6, stroke: '#000', strokeWidth: 2, fill: '#2b65e3' }}
                            activeDot={{ r: 8, stroke: '#000', strokeWidth: 3 }}
                          />
                        </LineChart>
                      </ResponsiveContainer>
                    ) : (
                      <div className="h-full flex items-center justify-center font-bold">Memuat Grafik...</div>
                    )}
                  </div>
                </div>

                {/* PIE CHART: REVENUE DISTRIBUTION */}
                <div className="bg-white p-6 border-4 border-black shadow-[8px_8px_0_0_#000] flex flex-col justify-between">
                  <div>
                    <h3 className="text-2xl font-black mb-1 uppercase">DISTRIBUSI OMSET</h3>
                    <p className="text-sm font-bold text-gray-600 mb-6">Pecahan omset berdasarkan kategori pengeluaran</p>
                  </div>

                  <div className="h-64 w-full relative flex items-center justify-center">
                    {isMounted ? (
                      <ResponsiveContainer width="100%" height="100%">
                        <PieChart>
                          <Pie
                            data={pieData}
                            cx="50%"
                            cy="50%"
                            labelLine={false}
                            outerRadius={80}
                            fill="#8884d8"
                            dataKey="value"
                            stroke="#000"
                            strokeWidth={3}
                          >
                            {pieData.map((entry, index) => (
                              <Cell key={`cell-${index}`} fill={PIE_COLORS[index % PIE_COLORS.length]} />
                            ))}
                          </Pie>
                          <Tooltip
                            formatter={(value: any) => formatIDR(Number(value))}
                            contentStyle={{
                              backgroundColor: '#fff',
                              border: '4px solid #000',
                              fontWeight: 'bold',
                              boxShadow: '4px 4px 0 0 #000'
                            }}
                          />
                        </PieChart>
                      </ResponsiveContainer>
                    ) : (
                      <div className="h-full flex items-center justify-center font-bold">Memuat Grafik...</div>
                    )}
                  </div>

                  <div className="mt-4 flex flex-col gap-2">
                    {pieData.map((item, idx) => (
                      <div key={idx} className="flex items-center gap-2 font-bold text-sm">
                        <span
                          className="inline-block w-4 h-4 border-2 border-black"
                          style={{ backgroundColor: PIE_COLORS[idx] }}
                        ></span>
                        <span className="flex-1">{item.name}</span>
                        <span>{formatIDR(item.value)}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* NIGHT AUDIT UTILITY CARD */}
              <div className="bg-[#b14bf0] text-white p-8 border-4 border-black shadow-[8px_8px_0_0_#000] flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                <div className="max-w-2xl">
                  <h3 className="text-3xl font-black uppercase mb-2 tracking-tight">UTILITAS NIGHT AUDIT HARIAN</h3>
                  <p className="font-bold text-purple-100">
                    Jalankan fungsi audit malam hari untuk membekukan seluruh catatan transaksi hari ini, merekonsiliasi total
                    billing (Kamar, Restoran, & Ekstra), serta menyimpannya dalam log aktivitas forensik staf secara resmi.
                  </p>
                </div>
                <button
                  onClick={handleRunNightAudit}
                  disabled={isNightAuditing}
                  className="bg-black text-[#ffcf00] border-4 border-black font-black text-lg px-6 py-4 hover:-translate-y-1 hover:shadow-[4px_4px_0_0_#fff] transition-all disabled:opacity-50 flex-shrink-0 cursor-pointer shadow-[2px_2px_0_0_#000]"
                >
                  {isNightAuditing ? 'SEDANG AUDIT...' : 'JALANKAN NIGHT AUDIT'}
                </button>
              </div>

              {/* LIVE AUDIT TRAIL FORENSIC TIMELINE */}
              <div className="bg-white p-6 border-4 border-black shadow-[8px_8px_0_0_#000]">
                <div className="flex justify-between items-center mb-6">
                  <div>
                    <h3 className="text-2xl font-black uppercase mb-1">LIVE AUDIT TRAIL</h3>
                    <p className="text-sm font-bold text-gray-600">Pelacakan forensik 50 aktivitas staf operasional terbaru</p>
                  </div>
                  <span className="bg-[#ffcf00] border-2 border-black px-3 py-1 font-black text-xs">
                    REAL-TIME SYNC
                  </span>
                </div>

                <div className="border-4 border-black max-h-[400px] overflow-y-auto bg-[#fdfbf7] p-4 space-y-4">
                  {auditLogs.length === 0 ? (
                    <div className="text-center py-10 font-bold text-gray-500">Tidak ada log aktivitas tersimpan.</div>
                  ) : (
                    auditLogs.map((log) => {
                      const style = getLogStyle(log.aktivitas);
                      return (
                        <div
                          key={log.id_log}
                          className={`flex flex-col sm:flex-row justify-between items-start sm:items-center p-4 border-4 border-black shadow-[4px_4px_0_0_#000] transition-all ${style.bg} ${style.text}`}
                        >
                          <div className="space-y-1 flex-1">
                            <div className="flex items-center gap-3">
                              <span className={`px-2 py-0.5 text-xs font-black uppercase ${style.badge}`}>
                                {log.aktivitas}
                              </span>
                              <span className="text-xs font-bold text-gray-700">
                                {new Date(log.waktu_aktivitas).toLocaleString('id-ID')}
                              </span>
                            </div>
                            <p className="font-bold text-sm">{log.keterangan}</p>
                          </div>

                          <div className="mt-2 sm:mt-0 flex flex-col items-end flex-shrink-0">
                            <span className="font-black text-xs border-2 border-black bg-white px-2 py-0.5 text-black">
                              👤 {log.pegawai?.nama_pegawai || 'Sistem'}
                            </span>
                            <span className="text-[10px] font-bold text-gray-600 mt-1">
                              {log.pegawai?.jabatan || 'Sistem Otomatis'}
                            </span>
                          </div>
                        </div>
                      );
                    })
                  )}
                </div>
              </div>

              {/* STAFF PERFORMANCE */}
              <div className="bg-white p-6 border-4 border-black shadow-[8px_8px_0_0_#000]">
                <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
                  <h3 className="text-2xl font-black uppercase">EVALUASI KINERJA STAF</h3>
                  <input
                    type="text"
                    placeholder="CARI STAF..."
                    className="border-4 border-black p-2 font-bold outline-none shadow-[2px_2px_0_0_#000] w-full md:w-64"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                  />
                </div>

                <div className="overflow-x-auto border-4 border-black">
                  <table className="w-full text-left font-bold">
                    <thead className="bg-[#ffcf00] border-b-4 border-black">
                      <tr>
                        <th className="p-4 border-r-4 border-black">STAF / JABATAN</th>
                        <th className="p-4 border-r-4 border-black text-center">CHECK-IN</th>
                        <th className="p-4 border-r-4 border-black text-center">CHECK-OUT</th>
                        <th className="p-4 text-center bg-black text-white">TOTAL SKOR</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredStaf.length === 0 ? (
                        <tr>
                          <td colSpan={4} className="p-8 text-center text-gray-500 font-bold bg-[#fdfbf7]">
                            Tidak ada data staf ditemukan.
                          </td>
                        </tr>
                      ) : (
                        filteredStaf.map((staf, index) => {
                          const total = staf.jumlah_handle_reservasi + staf.jumlah_handle_checkin + staf.jumlah_handle_checkout;
                          return (
                            <tr
                              key={staf.id_pegawai}
                              className={`${index !== filteredStaf.length - 1 ? 'border-b-4 border-black' : ''} hover:bg-gray-100`}
                            >
                              <td className="p-4 border-r-4 border-black">
                                <div className="font-black text-lg">{staf.nama_pegawai}</div>
                                <div className="text-sm bg-gray-200 inline-block px-2 border-2 border-black mt-1">
                                  {staf.jabatan}
                                </div>
                              </td>
                              <td className="p-4 border-r-4 border-black text-center text-xl">
                                {staf.jumlah_handle_checkin}
                              </td>
                              <td className="p-4 border-r-4 border-black text-center text-xl">
                                {staf.jumlah_handle_checkout}
                              </td>
                              <td className="p-4 text-center text-2xl font-black text-[#2b65e3]">{total}</td>
                            </tr>
                          );
                        })
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}
        </div>
      </main>

      {/* NIGHT AUDIT RESULT MODAL */}
      {showNightAuditModal && nightAuditResult && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
          <div className="bg-white border-4 border-black shadow-[8px_8px_0_0_#000] max-w-lg w-full p-6 relative">
            <div className="bg-[#b14bf0] text-white -mx-6 -mt-6 p-4 border-b-4 border-black mb-6">
              <h4 className="text-2xl font-black uppercase">✨ NIGHT AUDIT SUKSES!</h4>
              <p className="font-bold text-xs text-purple-100">Buku harian finansial hotel hari ini telah resmi dibekukan</p>
            </div>

            <div className="space-y-4 font-bold text-sm text-black">
              <div className="flex justify-between border-b-2 border-black/10 pb-2">
                <span>Pendapatan Sewa Kamar:</span>
                <span className="font-black">{formatIDR(nightAuditResult.roomRevenue)}</span>
              </div>
              <div className="flex justify-between border-b-2 border-black/10 pb-2">
                <span>Pendapatan Restoran (F&B):</span>
                <span className="font-black">{formatIDR(nightAuditResult.restaurantRevenue)}</span>
              </div>
              <div className="flex justify-between border-b-2 border-black/10 pb-2">
                <span>Pendapatan Layanan Ekstra:</span>
                <span className="font-black">{formatIDR(nightAuditResult.servicesRevenue)}</span>
              </div>
              <div className="flex justify-between text-lg font-black bg-[#ffcf00] p-3 border-4 border-black">
                <span>TOTAL REKONSILIASI:</span>
                <span>{formatIDR(nightAuditResult.totalRevenue)}</span>
              </div>

              <div className="bg-gray-100 p-3 border-2 border-black text-xs font-bold text-gray-700 italic">
                {nightAuditResult.keterangan}
              </div>
            </div>

            <div className="mt-6 flex justify-end">
              <button
                onClick={() => setShowNightAuditModal(false)}
                className="bg-black text-white border-4 border-black font-black px-6 py-2 hover:-translate-y-1 hover:shadow-[4px_4px_0_0_#ffcf00] transition-all cursor-pointer"
              >
                TUTUP & REFRESH
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
