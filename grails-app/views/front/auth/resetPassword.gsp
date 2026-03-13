<!doctype html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Crear Nueva Contraseña | Empresa</title>
    
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
    
    <style>
        #toast-container > div {
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            opacity: 1 !important;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-oxford to-cobalto flex items-center justify-center min-h-screen py-12 px-4 sm:px-6 lg:px-8 font-sans">

    <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-2xl shadow-2xl relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-blue-400 to-cobalto"></div>
        
        <div class="text-center pt-2">
            <h2 class="text-2xl font-extrabold text-oxford tracking-tight">Crear Nueva Contraseña</h2>
            <p class="mt-2 text-sm text-gray-500 font-medium">
                Ingresa y confirma tu nueva credencial de acceso.
            </p>
        </div>

        <form class="mt-6 space-y-6" id="resetForm">
            <div class="space-y-5">
                <div>
                    <label for="newPassword" class="block text-sm font-semibold text-oxford mb-1">Nueva Contraseña</label>
                    <input id="newPassword" type="password" required minlength="6" class="block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-cobalto transition-all" placeholder="••••••••">
                </div>
                <div>
                    <label for="confirmPassword" class="block text-sm font-semibold text-oxford mb-1">Confirmar Contraseña</label>
                    <input id="confirmPassword" type="password" required minlength="6" class="block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-cobalto transition-all" placeholder="••••••••">
                </div>
            </div>

            <div class="pt-4">
                <button type="submit" id="submitBtn" class="w-full flex justify-center py-3 px-4 border border-transparent text-sm font-bold rounded-lg text-white bg-cobalto hover:bg-blue-800 shadow-md transition-all hover:-translate-y-0.5">
                    Guardar Contraseña
                </button>
            </div>
            
            <div class="text-center mt-4">
                <a href="/front/auth/login" class="text-sm font-medium text-gray-500 hover:text-cobalto transition-colors">Volver al Login</a>
            </div>
        </form>
    </div>

    <script>
        toastr.options = { "closeButton": true, "progressBar": true, "positionClass": "toast-top-right", "timeOut": "3000" };

        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const urlParams = new URLSearchParams(window.location.search);
            const token = urlParams.get('token');

            if (!token) {
                toastr.error('No se encontró el token de seguridad en la URL.', 'Enlace Inválido');
                return;
            }

            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (newPassword !== confirmPassword) {
                toastr.warning('Las contraseñas no coinciden.', 'Verifique los datos');
                return;
            }

            const btn = document.getElementById('submitBtn');
            const originalText = btn.innerText;
            btn.innerHTML = 'Procesando...';
            btn.disabled = true;
            btn.classList.add('opacity-80', 'cursor-not-allowed');

            try {
                const response = await fetch('/back/auth/doResetPassword', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ token: token, password: newPassword })
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    toastr.success(data.message, 'Operación Exitosa');
                    document.getElementById('resetForm').reset();
                    setTimeout(() => {
                        window.location.href = '/front/auth/login';
                    }, 2000);
                } else {
                    toastr.error(data.message || 'Error al restablecer la contraseña', 'Error');
                }
            } catch (error) {
                toastr.error('No se pudo conectar con el servidor', 'Fallo de Red');
            } finally {
                btn.innerHTML = originalText;
                btn.disabled = false;
                btn.classList.remove('opacity-80', 'cursor-not-allowed');
            }
        });
    </script>
</body>
</html>