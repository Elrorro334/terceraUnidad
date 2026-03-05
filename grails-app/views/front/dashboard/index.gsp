<!doctype html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Dashboard | Empresa Platform</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        cobalto: '#1E3A8A',
                        oxford: '#334155',
                        fondo: '#F3F4F6'
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-fondo font-sans text-oxford h-screen flex overflow-hidden">

    <aside class="w-64 bg-oxford text-white flex flex-col shadow-2xl z-20 hidden md:flex">
        <div class="h-16 flex items-center px-6 bg-gray-900 border-b border-gray-800">
            <svg class="h-8 w-8 text-blue-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>
            <span class="text-xl font-bold tracking-wider">EMPRESA</span>
        </div>

        <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto" id="mainMenu">
            
            <div class="menu-group">
                <p class="px-2 text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Seguridad</p>
                <a href="/front/perfil/index" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Perfil</a>
                <a href="/front/modulo/index" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Módulo</a>
                <a href="/front/permisosPerfil/index" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Permisos-Perfil</a>
                <a href="/front/usuario/index" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Usuario</a>
            </div>

            <div class="menu-group mt-6">
                <p class="px-2 text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Principal 1</p>
                <a href="#" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Principal 1.1</a>
                <a href="#" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Principal 1.2</a>
            </div>

            <div class="menu-group mt-6">
                <p class="px-2 text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Principal 2</p>
                <a href="#" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Principal 2.1</a>
                <a href="#" class="flex items-center px-3 py-2 text-sm rounded-md hover:bg-gray-800 transition-colors">Principal 2.2</a>
            </div>
        </nav>

        <div class="p-4 border-t border-gray-800">
            <button onclick="logout()" class="w-full flex items-center justify-center px-4 py-2 bg-red-600 hover:bg-red-700 rounded text-sm font-medium transition-colors">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                Cerrar Sesión
            </button>
        </div>
    </aside>

    <div class="flex-1 flex flex-col h-full overflow-hidden">
        
        <header class="h-16 bg-white shadow-sm flex items-center justify-between px-6 z-10">
            <div class="flex items-center">
                <button class="md:hidden text-gray-500 hover:text-gray-700">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                </button>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-sm font-medium text-gray-700" id="userNameDisplay">Cargando...</span>
                <div class="h-8 w-8 rounded-full bg-cobalto text-white flex items-center justify-center font-bold">
                    U
                </div>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto p-6">
            
            <nav class="flex text-sm text-gray-500 mb-6" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-1 md:space-x-3">
                    <li class="inline-flex items-center">
                        <a href="/front/dashboard/index" class="inline-flex items-center hover:text-cobalto transition-colors">
                            <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20"><path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z"></path></svg>
                            Inicio
                        </a>
                    </li>
                    <li aria-current="page">
                        <div class="flex items-center">
                            <svg class="w-6 h-6 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg>
                            <span class="ml-1 md:ml-2 text-gray-400">Dashboard</span>
                        </div>
                    </li>
                </ol>
            </nav>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
                    <h3 class="text-lg font-bold text-oxford mb-2">Bienvenido al Sistema</h3>
                    <p class="text-gray-500 text-sm">Selecciona un módulo en el menú lateral para comenzar a operar. Tu sesión está asegurada mediante JWT.</p>
                </div>
            </div>

        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const token = localStorage.getItem('rodnix_jwt');
            
            if (!token) {
                window.location.href = '/front/auth/login';
                return;
            }

            try {
                const base64Url = token.split('.')[1];
                const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
                const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));

                const payload = JSON.parse(jsonPayload);
                
                document.getElementById('userNameDisplay').textContent = payload.sub || 'Usuario';

            } catch (e) {
                logout();
            }
        });

        function logout() {
            localStorage.removeItem('rodnix_jwt');
            window.location.href = '/front/auth/login';
        }
    </script>
</body>
</html>