<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Dashboard | EMPRESA Platform</title>
</head>
<body>

<content tag="nav">
    <li class="relative group px-3 py-2">
        <button class="flex items-center text-sm font-medium hover:text-blue-200 transition-colors focus:outline-none">
            Seguridad
            <svg class="ml-1 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
        </button>
        <div class="absolute left-0 mt-2 w-48 bg-white text-oxford rounded-md shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 border border-gray-100">
            <a href="/front/perfil/index" class="block px-4 py-2 text-sm hover:bg-gray-100">Perfil</a>
            <a href="/front/modulo/index" class="block px-4 py-2 text-sm hover:bg-gray-100">Módulo</a>
            <a href="/front/permisosPerfil/index" class="block px-4 py-2 text-sm hover:bg-gray-100">Permisos-Perfil</a>
            <a href="/front/usuario/index" class="block px-4 py-2 text-sm hover:bg-gray-100">Usuario</a>
        </div>
    </li>

    <li class="relative group px-3 py-2">
        <button class="flex items-center text-sm font-medium hover:text-blue-200 transition-colors focus:outline-none">
            Principal 1
            <svg class="ml-1 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
        </button>
        <div class="absolute left-0 mt-2 w-48 bg-white text-oxford rounded-md shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 border border-gray-100">
            <a href="#" class="block px-4 py-2 text-sm hover:bg-gray-100">Principal 1.1</a>
            <a href="#" class="block px-4 py-2 text-sm hover:bg-gray-100">Principal 1.2</a>
        </div>
    </li>

    <li class="relative group px-3 py-2">
        <button class="flex items-center text-sm font-medium hover:text-blue-200 transition-colors focus:outline-none">
            Principal 2
            <svg class="ml-1 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
        </button>
        <div class="absolute left-0 mt-2 w-48 bg-white text-oxford rounded-md shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 border border-gray-100">
            <a href="#" class="block px-4 py-2 text-sm hover:bg-gray-100">Principal 2.1</a>
            <a href="#" class="block px-4 py-2 text-sm hover:bg-gray-100">Principal 2.2</a>
        </div>
    </li>

    <li class="ml-4 pl-4 border-l border-blue-700 flex items-center space-x-3">
        <span class="text-sm font-semibold text-blue-100 truncate max-w-[150px]" id="userNameDisplayDesktop"></span>
        <button onclick="logout()" class="bg-red-600 hover:bg-red-700 transition-colors px-4 py-2 rounded-md text-sm font-medium shadow-sm">Salir</button>
    </li>
</content>

<content tag="nav-mobile">
    <li><p class="px-2 text-xs font-semibold text-blue-300 uppercase tracking-wider mt-2 mb-1">Seguridad</p></li>
    <li><a href="/front/perfil/index" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Perfil</a></li>
    <li><a href="/front/modulo/index" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Módulo</a></li>
    <li><a href="/front/permisosPerfil/index" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Permisos-Perfil</a></li>
    <li><a href="/front/usuario/index" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Usuario</a></li>

    <li><p class="px-2 text-xs font-semibold text-blue-300 uppercase tracking-wider mt-4 mb-1">Principal 1</p></li>
    <li><a href="#" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Principal 1.1</a></li>
    <li><a href="#" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Principal 1.2</a></li>

    <li><p class="px-2 text-xs font-semibold text-blue-300 uppercase tracking-wider mt-4 mb-1">Principal 2</p></li>
    <li><a href="#" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Principal 2.1</a></li>
    <li><a href="#" class="block px-4 py-2 text-sm hover:bg-blue-800 rounded">Principal 2.2</a></li>

    <li class="border-t border-blue-800 mt-4 pt-4">
        <span class="block px-2 text-sm font-semibold text-blue-100 mb-3" id="userNameDisplayMobile"></span>
        <button onclick="logout()" class="w-full bg-red-600 hover:bg-red-700 transition-colors px-4 py-2 rounded-md text-sm font-medium shadow-sm">Cerrar Sesión</button>
    </li>
</content>


<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    
    <div class="bg-white rounded-xl shadow-sm p-8 border border-gray-200 text-center max-w-2xl mx-auto">
        <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-blue-50 text-cobalto mb-4">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
        </div>
        <h2 class="text-2xl md:text-3xl font-bold text-oxford mb-2">
            Bienvenido al Sistema <br>
            <span class="text-cobalto" id="displayName"></span> - <span class="text-gray-500 text-xl" id="displayRole"></span>
        </h2>
        <p class="text-gray-500 mt-4">
            Selecciona un módulo en el menú superior para comenzar a operar. Tu sesión está asegurada mediante JWT.
        </p>
    </div>

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
            
            // Inyectamos el nombre de usuario y su rol en la vista
            const userName = payload.sub || 'Usuario';
            const userRole = payload.perfil || 'Desconocido';

            document.getElementById('userNameDisplayDesktop').textContent = userName;
            document.getElementById('userNameDisplayMobile').textContent = userName;
            document.getElementById('displayName').textContent = userName;
            document.getElementById('displayRole').textContent = userRole;

        } catch (e) {
            logout();
        }
    });

    function logout() {
        localStorage.removeItem('rodnix_jwt');
        window.location.href = '/';
    }
</script>
</body>
</html>