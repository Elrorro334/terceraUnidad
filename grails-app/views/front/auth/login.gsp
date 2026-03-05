<!doctype html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Acceso al Sistema | Empresa</title>
    
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

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>

    <style>
        #toast-container > div {
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            opacity: 1 !important;
        }
    </style>
</head>

<body class="bg-gradient-to-br from-oxford to-cobalto flex items-center justify-center min-h-screen py-12 px-4 sm:px-6 lg:px-8 font-sans">

    <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-2xl shadow-2xl relative overflow-hidden">
        
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-blue-400 to-cobalto"></div>
        
        <div class="text-center pt-2">
            <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-blue-50 mb-6 shadow-inner">
                <svg class="h-8 w-8 text-cobalto" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                </svg>
            </div>
            <h2 class="text-3xl font-extrabold text-oxford tracking-tight">
                Empresa Platform
            </h2>
            <p class="mt-2 text-sm text-gray-500 font-medium">
                Acceso al Sistema Administrativo
            </p>
        </div>

        <form class="mt-8 space-y-6" id="loginForm">
            <div class="space-y-5">
                
                <div>
                    <label for="username" class="block text-sm font-semibold text-oxford mb-1">Usuario</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                        </div>
                        <input id="username" name="username" type="text" required class="pl-10 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-cobalto focus:border-transparent sm:text-sm transition-all duration-200" placeholder="Ej. admin_rodnix">
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-semibold text-oxford mb-1">Contraseña</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                            </svg>
                        </div>
                        <input id="password" name="password" type="password" required class="pl-10 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-cobalto focus:border-transparent sm:text-sm transition-all duration-200" placeholder="••••••••">
                    </div>
                </div>

                <div class="flex justify-center pt-2">
                    <div class="g-recaptcha" data-sitekey="6LdG8oAsAAAAAFPD5sSjjCgVtrT8qwBZc-9q7JoK"></div>
                </div>
            </div>

            <div class="pt-2">
                <button type="submit" id="submitBtn" class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-bold rounded-lg text-white bg-cobalto hover:bg-blue-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-cobalto shadow-lg transform transition-all duration-200 hover:-translate-y-0.5">
                    Ingresar al Sistema
                </button>
            </div>
        </form>
    </div>

    <script>
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "positionClass": "toast-top-right",
            "showDuration": "300",
            "hideDuration": "1000",
            "timeOut": "5000"
        };

        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();

            // 1. Obtener la respuesta del reCAPTCHA
            const recaptchaToken = grecaptcha.getResponse();
            
            // 2. Validar en el frontend antes de gastar recursos del servidor
            if (!recaptchaToken) {
                toastr.warning('Por favor, completa la verificación de seguridad.', 'reCAPTCHA requerido');
                return;
            }

            const btn = document.getElementById('submitBtn');
            const originalText = btn.innerText;

            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;

            btn.innerHTML = `<svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Validando...`;
            btn.disabled = true;
            btn.classList.add('opacity-80', 'cursor-not-allowed');

            try {
                // Se envía el recaptchaToken en el body
                const response = await fetch('/back/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ username, password, recaptchaToken })
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    toastr.success('Autenticación exitosa', 'Bienvenido');
                    localStorage.setItem('rodnix_jwt', data.token);
                    
                    setTimeout(() => {
                        window.location.href = data.redirectUrl || '/front/dashboard/index';
                    }, 1000);
                } else {
                    toastr.error(data.message || 'Credenciales incorrectas', 'Acceso denegado');
                    // Resetear el captcha si la validación falla
                    grecaptcha.reset(); 
                }
            } catch (error) {
                toastr.error('No se pudo conectar con el servidor', 'Error de red');
                grecaptcha.reset();
            } finally {
                btn.innerHTML = originalText;
                btn.disabled = false;
                btn.classList.remove('opacity-80', 'cursor-not-allowed');
            }
        });
    </script>
</body>
</html>