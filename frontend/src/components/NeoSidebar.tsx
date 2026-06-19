'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import Cookies from 'js-cookie';

interface NeoSidebarProps {
  user: { nama_pegawai?: string, jabatan?: string };
}

export default function NeoSidebar({ user }: NeoSidebarProps) {
  const router = useRouter();

  const handleLogout = () => {
    Cookies.remove('token');
    Cookies.remove('user');
    router.push('/login');
  };

  return (
    <aside className="w-20 lg:w-24 bg-[#ffcf00] border-r-4 border-black flex flex-col items-center py-6 flex-shrink-0 z-20">
      <div className="bg-black text-[#ffcf00] w-12 h-12 flex items-center justify-center font-black text-xl mb-8 border-4 border-black shadow-[4px_4px_0_0_#000] rounded-lg cursor-pointer transform hover:-translate-y-1 transition-transform">
        H
      </div>
      
      <div className="flex flex-col gap-6 w-full px-4">
        {/* Dashboard Resepsionis */}
        <Link href="/" className="w-full aspect-square bg-[#2b65e3] rounded-xl border-4 border-black flex items-center justify-center shadow-[4px_4px_0_0_#000] transform -translate-y-1 group hover:bg-blue-700 transition-colors">
          <svg className="w-6 h-6 text-white group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zm10 0a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zm10 0a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" /></svg>
        </Link>
        {/* Restoran */}
        <Link href="/restoran" className="w-full aspect-square bg-white rounded-xl border-4 border-black flex items-center justify-center hover:shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-all group">
          <span className="text-xl group-hover:scale-110 transition-transform">🍽️</span>
        </Link>
        {/* Housekeeping */}
        <Link href="/housekeeping" className="w-full aspect-square bg-white rounded-xl border-4 border-black flex items-center justify-center hover:shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-all group">
          <span className="text-xl group-hover:scale-110 transition-transform">🧹</span>
        </Link>
        {/* Admin Dashboard */}
        {user.jabatan === 'Admin' && (
          <Link href="/admin" className="w-full aspect-square bg-white rounded-xl border-4 border-black flex items-center justify-center hover:shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-all group">
            <span className="text-xl group-hover:scale-110 transition-transform">📊</span>
          </Link>
        )}
      </div>

      <div className="mt-auto w-full px-4">
        <button 
          onClick={handleLogout}
          className="w-full aspect-square bg-[#f0544f] rounded-xl border-4 border-black flex items-center justify-center hover:shadow-[4px_4px_0_0_#000] hover:-translate-y-1 transition-all group"
        >
          <svg className="w-6 h-6 text-black group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
        </button>
      </div>
    </aside>
  );
}
