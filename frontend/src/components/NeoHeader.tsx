'use client';

interface NeoHeaderProps {
  user: { nama_pegawai?: string, jabatan?: string };
  title?: string;
}

export default function NeoHeader({ user, title = "NEO-HOTEL PMS" }: NeoHeaderProps) {
  return (
    <header className="h-20 bg-[#fdfbf7] border-b-4 border-black flex items-center justify-between px-8 shrink-0 z-10">
      <div className="flex items-center gap-3">
        <span className="text-3xl">🏢</span>
        <h1 className="text-2xl font-black tracking-tighter uppercase">{title}</h1>
        <svg className="w-10 h-10 ml-4 hidden md:block" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
           <path d="M10 50 L40 50 L40 20 L70 20 L70 50 L90 50 L90 70 L70 70 L70 90 L40 90 L40 70 L10 70 Z" fill="white" stroke="black" strokeWidth="4"/>
           <circle cx="35" cy="45" r="5" fill="black"/>
           <circle cx="65" cy="45" r="5" fill="black"/>
        </svg>
      </div>
      <div className="flex items-center gap-6">
        <div className="relative cursor-pointer hover:scale-110 transition-transform">
          <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
          <div className="absolute -top-1 -right-1 w-4 h-4 bg-[#f0544f] border-2 border-black rounded-full flex items-center justify-center text-[8px] font-bold text-white">1</div>
        </div>
        <div className="flex items-center gap-3 cursor-pointer group">
          <div className="w-10 h-10 bg-[#f0544f] border-2 border-black rounded-full shadow-[2px_2px_0_0_#000] flex items-center justify-center text-white group-hover:shadow-[4px_4px_0_0_#000] group-hover:-translate-y-0.5 transition-all">
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
          </div>
          <div className="hidden md:flex items-center gap-1 font-black text-sm tracking-wide group-hover:text-gray-700">
            {user.jabatan ? user.jabatan.toUpperCase() : 'USER'} <span className="text-xl">⌄</span>
          </div>
        </div>
      </div>
    </header>
  );
}
