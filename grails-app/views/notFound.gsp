<!doctype html>
<html lang="es">
<head>
    <title>Página No Encontrada | EMPRESA</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.3/dist/dotlottie-wc.js" type="module"></script>
    
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
<body class="bg-fondo font-sans text-oxford flex items-center justify-center min-h-screen p-4">

    <div class="max-w-2xl w-full bg-white rounded-2xl shadow-xl overflow-hidden text-center p-10 border border-gray-100">
        
        <div class="flex justify-center mb-6">
            <dotlottie-wc 
                src="https://lottie.host/1b716831-b53e-4347-b3de-c2eaf2e08dd9/ZNoyjKemGC.lottie" 
                style="width: 250px; height: 250px" 
                autoplay 
                loop>
            </dotlottie-wc>
        </div>

        <h1 class="text-4xl font-extrabold text-oxford mb-2">Error 404</h1>
        <h2 class="text-xl font-semibold text-gray-500 mb-6">Página no encontrada</h2>
        
        <p class="text-gray-500 mb-8 max-w-md mx-auto leading-relaxed">
            Lo sentimos, el recurso que intentas consultar no existe, ha sido movido o temporalmente no está disponible en el sistema.
        </p>

        <div class="bg-gray-50 border border-gray-200 rounded-lg p-3 inline-block mb-8 text-sm text-gray-500 font-mono">
            Ruta solicitada: <span class="text-red-500 font-semibold">${request.forwardURI}</span>
        </div>

        <div>
            <a href="${createLink(uri: '/')}" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-lg text-white bg-cobalto hover:bg-blue-800 transition-colors shadow-md">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                </svg>
                Volver al Inicio
            </a>
        </div>
        
    </div>

</body>
</html>