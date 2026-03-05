<!doctype html>
<html lang="es" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title><g:layoutTitle default="Administración | Empresa"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>
    <asset:stylesheet src="application.css"/>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        cobalto: '#1E3A8A',
                        oxford: '#334155',
                    }
                }
            }
        }
    </script>
    <g:layoutHead/>
</head>

<body class="bg-gray-50 text-oxford font-sans flex flex-col min-h-screen">

    <nav class="bg-cobalto shadow-md">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <a href="/" class="flex-shrink-0 flex items-center text-white font-bold text-xl tracking-wide">
                        <svg class="w-8 h-8 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                        Empresa Admin
                    </a>
                </div>
                <div class="flex items-center space-x-4">
                    <ul class="flex space-x-4 text-white">
                        <g:pageProperty name="page.nav"/>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <main class="flex-grow">
        <g:layoutBody/>
    </main>

    <footer class="bg-oxford text-white mt-auto py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <p class="text-sm text-gray-400">&copy; 2026 Sistema de Administración Empresa. Todos los derechos reservados.</p>
        </div>
    </footer>

    <div id="spinner" class="fixed top-4 right-4 z-50" style="display:none;">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-cobalto"></div>
    </div>

    <asset:javascript src="application.js"/>
</body>
</html>