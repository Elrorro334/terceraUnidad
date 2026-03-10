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
    <g:layoutHead/>
</head>

<body class="bg-fondo text-oxford font-sans flex flex-col min-h-screen">

    <nav class="bg-cobalto shadow-md relative z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <a href="/" class="flex-shrink-0 flex items-center text-white font-bold text-xl tracking-wide">
                        <svg class="w-8 h-8 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                        EMPRESA Admin
                    </a>
                </div>
                
                <div class="hidden md:flex items-center space-x-1">
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

        <div id="mobile-menu" class="hidden md:hidden bg-blue-900 pb-4 pt-2 px-4 shadow-inner absolute w-full left-0">
            <ul class="flex flex-col space-y-2 text-white">
                <g:pageProperty name="page.nav-mobile"/>
            </ul>
        </div>
    </nav>

    <main class="flex-grow">
        <g:layoutBody/>
    </main>

    <footer class="bg-oxford text-white mt-auto py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <p class="text-sm text-gray-400">&copy; 2026 Sistema de Administración EMPRESA. Todos los derechos reservados.</p>
        </div>
    </footer>

</body>
</html>