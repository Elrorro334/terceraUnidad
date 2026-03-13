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
                extend: { colors: { cobalto: '#1E3A8A', oxford: '#334155' } }
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
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            opacity: 1 !important;
        }
    </style>
</head>

<body class="bg-gradient-to-br from-oxford to-cobalto flex items-center justify-center min-h-screen py-12 px-4 sm:px-6 lg:px-8 font-sans relative">

    <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-2xl shadow-2xl relative overflow-hidden z-10">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-blue-400 to-cobalto"></div>
        
        <div class="text-center pt-2">
            <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-blue-50 mb-6 shadow-inner">
                <svg class="h-8 w-8 text-cobalto" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                </svg>
            </div>
            <h2 class="text-3xl font-extrabold text-oxford tracking-tight">Empresa Platform</h2>
            <p class="mt-2 text-sm text-gray-500 font-medium">Acceso al Sistema Administrativo</p>
        </div>

        <form class="mt-8 space-y-6" id="loginForm">
            <div class="space-y-5">
                <div>
                    <label for="username" class="block text-sm font-semibold text-oxford mb-1">Usuario</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                        </div>
                        <input id="username" name="username" type="text" required maxlength="50" class="pl-10 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-cobalto sm:text-sm transition-all" placeholder="Ej. admin_rodnix">
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-semibold text-oxford mb-1">Contraseña</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" /></svg>
                        </div>
                        <input id="password" name="password" type="password" required maxlength="100" class="pl-10 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-cobalto sm:text-sm transition-all" placeholder="••••••••">
                    </div>
                </div>

                <div class="flex items-center justify-end">
                    <div class="text-sm">
                        <button type="button" onclick="abrirModalRecuperar()" class="font-medium text-cobalto hover:text-blue-600 transition-colors focus:outline-none">
                            ¿Olvidaste tu contraseña?
                        </button>
                    </div>
                </div>

                <div class="flex justify-center pt-2">
                    <div class="g-recaptcha" data-sitekey="6LdG8oAsAAAAAFPD5sSjjCgVtrT8qwBZc-9q7JoK"></div>
                </div>
            </div>

            <div class="pt-2">
                <button type="submit" id="submitBtn" class="w-full flex justify-center py-3 px-4 border border-transparent text-sm font-bold rounded-lg text-white bg-cobalto hover:bg-blue-800 shadow-md transition-all hover:-translate-y-0.5">
                    Ingresar al Sistema
                </button>
            </div>
        </form>
    </div>

    <div id="modal-recuperar" class="fixed inset-0 bg-gray-900 bg-opacity-70 hidden flex items-center justify-center z-50 p-4 transition-opacity">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gray-50">
                <h3 class="text-lg font-bold text-oxford flex items-center">
                    <svg class="w-5 h-5 mr-2 text-cobalto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                    Recuperar Contraseña
                </h3>
                <button type="button" onclick="cerrarModalRecuperar()" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            
            <div class="p-6">
                <p class="text-sm text-gray-500 mb-6">Ingresa el correo electrónico asociado a tu cuenta. Te enviaremos un enlace temporal seguro.</p>
                <form id="form-recuperar" onsubmit="enviarRecuperacion(event)">
                    <div class="mb-6">
                        <label for="recoveryEmail" class="block text-sm font-semibold text-gray-700 mb-1">Correo Electrónico</label>
                        <input type="email" id="recoveryEmail" required maxlength="100" class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:ring-2 focus:ring-cobalto">
                    </div>
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="cerrarModalRecuperar()" class="px-5 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 text-sm font-medium">Cancelar</button>
                        <button type="submit" id="btnRecuperar" class="px-5 py-2.5 bg-cobalto text-white rounded-lg hover:bg-blue-800 text-sm font-medium shadow-sm min-w-[120px]">
                            Enviar Correo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Opción escapeHtml: true para que si el servidor devuelve etiquetas <script>, Toastr solo muestre texto inofensivo
        toastr.options = { "closeButton": true, "progressBar": true, "positionClass": "toast-top-right", "timeOut": "5000", "escapeHtml": true };

        // Función Anti-XSS básica: elimina los picos < y > de cualquier texto para que no puedan formar etiquetas HTML
        function sanitizarEntrada(texto) {
            return texto ? texto.replace(/[<>]/g, '').trim() : '';
        }

        // LOGIN
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();

            const recaptchaToken = grecaptcha.getResponse();
            if (!recaptchaToken) {
                toastr.warning('Por favor, completa la verificación de seguridad.', 'reCAPTCHA requerido');
                return;
            }

            const btn = document.getElementById('submitBtn');
            const originalText = btn.innerText;

            // Aplicamos la limpieza solo al momento de enviar
            const username = sanitizarEntrada(document.getElementById('username').value);
            // La contraseña no se sanitiza para no borrarle al usuario símbolos válidos como < o >
            const password = document.getElementById('password').value; 

            btn.innerHTML = 'Validando...';
            btn.disabled = true;
            btn.classList.add('opacity-50', 'cursor-not-allowed');

            try {
                const response = await fetch('/back/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ username, password, recaptchaToken })
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    toastr.success('Autenticación exitosa', 'Bienvenido');
                    localStorage.setItem('rodnix_jwt', data.token);
                    setTimeout(() => { window.location.href = data.redirectUrl || '/front/dashboard/index'; }, 1000);
                } else {
                    toastr.error(data.message || 'Credenciales incorrectas', 'Acceso denegado');
                    grecaptcha.reset(); 
                }
            } catch (error) {
                toastr.error('No se pudo conectar con el servidor', 'Error de red');
                grecaptcha.reset();
            } finally {
                btn.innerHTML = originalText;
                btn.disabled = false;
                btn.classList.remove('opacity-50', 'cursor-not-allowed');
            }
        });

        // RECUPERACIÓN
        function abrirModalRecuperar() {
            document.getElementById('form-recuperar').reset();
            document.getElementById('modal-recuperar').classList.remove('hidden');
        }

        function cerrarModalRecuperar() {
            document.getElementById('modal-recuperar').classList.add('hidden');
        }

        async function enviarRecuperacion(e) {
            e.preventDefault();
            const btn = document.getElementById('btnRecuperar');
            const originalText = btn.innerText;
            
            // Sanitizamos el correo
            const correo = sanitizarEntrada(document.getElementById('recoveryEmail').value);

            btn.innerHTML = 'Enviando...';
            btn.disabled = true;
            btn.classList.add('opacity-50', 'cursor-not-allowed');

            try {
                const response = await fetch('/back/auth/recuperarContrasena', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ correo })
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    cerrarModalRecuperar();
                    toastr.success(data.message, 'Correo Enviado');
                } else {
                    toastr.error(data.message || 'Error al procesar solicitud', 'Error');
                }
            } catch (error) {
                toastr.error('Error de comunicación con el servidor', 'Fallo de Red');
            } finally {
                btn.innerHTML = originalText;
                btn.disabled = false;
                btn.classList.remove('opacity-50', 'cursor-not-allowed');
            }
        }
    </script>
</body>
</html>