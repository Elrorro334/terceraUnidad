<!doctype html>
<html lang="es" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title><g:layoutTitle default="Administración | EMPRESA"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    
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
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    
    <g:layoutHead/>
</head>

<body class="bg-fondo text-oxford font-sans flex flex-col min-h-screen">

    <nav class="bg-cobalto shadow-md relative z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <a href="${createLink(uri: '/')}" class="flex-shrink-0 flex items-center text-white font-bold text-xl tracking-wide">
                        <svg class="w-8 h-8 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                        EMPRESA
                    </a>
                </div>
                
                <div class="hidden md:flex items-center space-x-1" id="menu-desktop-container">
                    <ul class="flex items-center text-white space-x-2">
                        <g:pageProperty name="page.nav"/>
                    </ul>
                </div>

                <div class="flex items-center md:hidden">
                    <button type="button" onclick="document.getElementById('mobile-menu').classList.toggle('hidden')" class="text-white hover:text-blue-200 focus:outline-none">
                        <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <div id="mobile-menu" class="hidden md:hidden bg-blue-900 pb-4 pt-2 px-4 shadow-inner absolute w-full left-0 z-40">
            <ul class="flex flex-col space-y-2 text-white" id="menu-mobile-container">
                <g:pageProperty name="page.nav-mobile"/>
            </ul>
        </div>
    </nav>

    <main class="flex-grow max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-6">
        <div id="breadcrumb-container" class="mb-6"></div>
        
        <g:layoutBody/>
    </main>

    <footer class="bg-oxford text-white mt-auto py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <p class="text-sm text-gray-400">&copy; 2026 Sistema de Administración EMPRESA. Todos los derechos reservados.</p>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <script>
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "positionClass": "toast-bottom-right",
            "timeOut": "3000"
        };
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            cargarMenuDesdeBackend();
            renderizarBreadcrumbDOM();
        });

        async function cargarMenuDesdeBackend() {
            const token = localStorage.getItem('rodnix_jwt'); 
            const isPublicPage = window.location.pathname === '/' || window.location.pathname.includes('/auth/login');
            
            if (!token) {
                if (!isPublicPage) { window.location.href = '/front/auth/login'; }
                return;
            }

            try {
                const response = await fetch('/back/menu/obtener', {
                    method: 'GET',
                    headers: {
                        'Authorization': 'Bearer ' + token,
                        'Accept': 'application/json'
                    }
                });

                if (response.ok) {
                    const data = await response.json();
                    
                    // --- NUEVA LÓGICA DE PERMISOS ---
                    // Creamos un diccionario donde la URL es la llave y los permisos el valor
                    const mapPermisos = {};
                    data.forEach(function(menuPadre) {
                        menuPadre.modulos.forEach(function(mod) {
                            mapPermisos[mod.url] = mod.permisos;
                        });
                    });
                    sessionStorage.setItem('map_permisos', JSON.stringify(mapPermisos));
                    // ---------------------------------

                    construirMenuDesktop(data);
                    construirMenuMobile(data);

                    // Avisamos a las vistas hijas que los permisos ya están listos
                    document.dispatchEvent(new Event('permisosCargados'));

                } else if (response.status === 401 || response.status === 403) {
                    cerrarSesion();
                } else {
                    if (!isPublicPage) {
                        document.getElementById('menu-desktop-container').innerHTML = '<span class="text-red-300 text-sm font-medium">Error conectando con el servidor</span>';
                    }
                }
            } catch (error) {
                console.error('Error cargando menú:', error);
            }
        }

        function construirMenuDesktop(menus) {
            const container = document.getElementById('menu-desktop-container');
            container.innerHTML = ''; 

            const ul = document.createElement('ul');
            ul.className = 'flex items-center text-white space-x-2';

            menus.forEach(function(menuPadre) {
                const liPadre = document.createElement('li');
                liPadre.className = 'relative group px-3 py-2 rounded-md hover:bg-blue-800 cursor-pointer transition-colors z-50';

                const spanPadre = document.createElement('span');
                spanPadre.className = 'flex items-center text-sm font-medium';
                spanPadre.innerHTML = menuPadre.nombreMenuPadre + ' <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>';
                
                const ulSubmenu = document.createElement('ul');
                ulSubmenu.className = 'absolute left-0 top-full mt-1 hidden group-hover:block bg-white text-oxford min-w-[200px] shadow-lg rounded-md border border-gray-200 overflow-hidden';

                menuPadre.modulos.forEach(function(modulo) {
                    const liHijo = document.createElement('li');
                    const aHijo = document.createElement('a');
                    aHijo.href = modulo.url;
                    aHijo.className = 'block px-4 py-3 hover:bg-gray-100 transition-colors text-sm';
                    aHijo.textContent = modulo.nombre;
                    
                    aHijo.addEventListener('click', function() {
                        sessionStorage.setItem('bc_padre', menuPadre.nombreMenuPadre);
                        sessionStorage.setItem('bc_hijo', modulo.nombre);
                    });

                    liHijo.appendChild(aHijo);
                    ulSubmenu.appendChild(liHijo);
                });

                liPadre.appendChild(spanPadre);
                liPadre.appendChild(ulSubmenu);
                ul.appendChild(liPadre);
            });

            const liLogout = document.createElement('li');
            liLogout.innerHTML = '<button onclick="cerrarSesion()" class="ml-4 px-3 py-2 bg-red-600 hover:bg-red-700 rounded-md text-sm font-medium transition-colors shadow-sm">Salir</button>';
            ul.appendChild(liLogout);

            container.appendChild(ul);
        }

        function construirMenuMobile(menus) {
            const container = document.getElementById('menu-mobile-container');
            container.innerHTML = '';

            menus.forEach(function(menuPadre) {
                const liPadre = document.createElement('li');
                liPadre.className = 'block px-3 py-2 font-bold text-blue-200 border-b border-blue-800';
                liPadre.textContent = menuPadre.nombreMenuPadre;
                container.appendChild(liPadre);

                menuPadre.modulos.forEach(function(modulo) {
                    const liHijo = document.createElement('li');
                    const aHijo = document.createElement('a');
                    aHijo.href = modulo.url;
                    aHijo.className = 'block px-6 py-2 hover:bg-blue-800 rounded-md text-sm';
                    aHijo.textContent = modulo.nombre;
                    
                    aHijo.addEventListener('click', function() {
                        sessionStorage.setItem('bc_padre', menuPadre.nombreMenuPadre);
                        sessionStorage.setItem('bc_hijo', modulo.nombre);
                    });

                    liHijo.appendChild(aHijo);
                    container.appendChild(liHijo);
                });
            });

            const liLogout = document.createElement('li');
            liLogout.innerHTML = '<button onclick="cerrarSesion()" class="block w-full text-center px-3 py-3 mt-4 font-bold text-white bg-red-600 hover:bg-red-700 rounded-md transition-colors shadow-sm">Cerrar Sesión</button>';
            container.appendChild(liLogout);
        }

        function renderizarBreadcrumbDOM() {
            const container = document.getElementById('breadcrumb-container');
            if (!container) return;

            if (window.location.pathname === '/' || window.location.pathname.includes('/dashboard/index') || window.location.pathname.includes('/auth/login')) {
                return;
            }

            const padre = sessionStorage.getItem('bc_padre');
            const hijo = sessionStorage.getItem('bc_hijo');

            if (padre && hijo) {
                container.innerHTML = 
                    '<nav class="flex text-sm text-gray-500" aria-label="Breadcrumb">' +
                      '<ol class="inline-flex items-center space-x-1 md:space-x-3">' +
                        '<li class="inline-flex items-center">' +
                          '<a href="/front/dashboard/index" class="hover:text-cobalto transition-colors">Inicio</a>' +
                        '</li>' +
                        '<li>' +
                          '<div class="flex items-center">' +
                            '<svg class="w-4 h-4 text-gray-400 mx-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg>' +
                            '<span class="text-gray-600">' + padre + '</span>' +
                          '</div>' +
                        '</li>' +
                        '<li aria-current="page">' +
                          '<div class="flex items-center">' +
                            '<svg class="w-4 h-4 text-gray-400 mx-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg>' +
                            '<span class="text-cobalto font-bold">' + hijo + '</span>' +
                          '</div>' +
                        '</li>' +
                      '</ol>' +
                    '</nav>';
            }
        }

        function cerrarSesion() {
            localStorage.removeItem('rodnix_jwt');
            sessionStorage.removeItem('bc_padre');
            sessionStorage.removeItem('bc_hijo');
            window.location.href = '/front/auth/login';
        }
    </script>
</body>
</html>