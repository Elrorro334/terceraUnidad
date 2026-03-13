<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Dashboard | EMPRESA Platform</title>
</head>
<body>

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
            Selecciona un módulo en el menú superior para comenzar.
        </p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) return; // Si no hay token, el main.gsp ya lo está expulsando
        try {
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));

            const payload = JSON.parse(jsonPayload);
            const userName = payload.sub || 'Usuario';
            const userRole = payload.perfil || 'Desconocido';

            document.getElementById('displayName').textContent = userName;
            document.getElementById('displayRole').textContent = userRole;
        } catch (e) {
            console.error("Error decodificando JWT en el dashboard", e);
        }
    });
</script>
</body>
</html>