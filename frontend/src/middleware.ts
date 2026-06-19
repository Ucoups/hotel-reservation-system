import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value;
  const userCookie = request.cookies.get('user')?.value;

  const isLoginPage = request.nextUrl.pathname.startsWith('/login');
  
  // Jika belum login dan mencoba akses selain login
  if (!token && !isLoginPage) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // Jika sudah login dan mencoba akses login
  if (token && isLoginPage) {
    return NextResponse.redirect(new URL('/', request.url));
  }

  // RBAC Frontend: Proteksi route admin
  if (token && userCookie && request.nextUrl.pathname.startsWith('/admin')) {
    try {
      const user = JSON.parse(userCookie);
      if (user.jabatan !== 'Admin') {
        // Redirect resepsionis jika mencoba akses admin
        return NextResponse.redirect(new URL('/', request.url));
      }
    } catch (e) {
      // Abaikan error parse
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    '/((?!api|_next/static|_next/image|favicon.ico).*)',
  ],
};
