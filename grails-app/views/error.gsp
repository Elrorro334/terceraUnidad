<!doctype html>
<html lang="es">
<head>
    <title><g:if env="development">Excepción del Sistema</g:if><g:else>Error Interno | EMPRESA</g:else></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="layout" content="null">
    
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

    <style>
        /* Animación Glitch para el texto 500 */
        .glitch-text {
            animation: glitch 3s infinite;
        }
        @keyframes glitch {
            0%, 90%, 100% { transform: translate(0); text-shadow: none; }
            92% { transform: translate(-2px, 2px); text-shadow: 2px 0 #EF4444, -2px 0 #3B82F6; }
            94% { transform: translate(2px, -2px); text-shadow: -2px 0 #EF4444, 2px 0 #3B82F6; }
            96% { transform: translate(-2px, 0); text-shadow: 2px 0 #EF4444, -2px 0 #3B82F6; }
            98% { transform: translate(2px, 2px); text-shadow: -2px 0 #EF4444, 2px 0 #3B82F6; }
        }
        /* Estilos inyectados para formatear el tag g:renderException de Grails en desarrollo */
        .grails-error-container h2 { @apply text-xl font-bold text-red-600 mb-4 border-b border-red-200 pb-2; }
        .grails-error-container .alert-danger { @apply bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-4 rounded-r-md shadow-sm break-words; }
        .grails-error-container .message { @apply font-semibold; }
        .grails-error-container .snippet { @apply bg-gray-900 text-gray-300 p-4 rounded-lg overflow-x-auto font-mono text-sm my-4 shadow-inner leading-relaxed; }
        .grails-error-container .snippet .lineErrorClass, .grails-error-container .snippet .bg-danger { @apply bg-red-900 text-white block w-full px-2 rounded-sm; }
        .grails-error-container .stack { @apply bg-gray-100 p-4 rounded-lg overflow-x-auto font-mono text-xs text-gray-600 mt-4 border border-gray-200 h-64 shadow-inner; }
        .grails-error-container dt { @apply font-bold text-oxford mt-2; }
        .grails-error-container dd { @apply text-gray-600 ml-4 mb-2; }
    </style>
</head>

<body class="bg-fondo font-sans text-oxford min-h-screen p-4 flex flex-col items-center justify-center relative overflow-hidden">

    <canvas id="errorCanvas" class="absolute inset-0 w-full h-full z-0 opacity-40 pointer-events-none"></canvas>

    <div class="max-w-5xl w-full bg-white/90 backdrop-blur-md rounded-2xl shadow-2xl overflow-hidden border border-gray-100 z-10 my-8">
        
        <div class="p-8 md:p-12 text-center relative overflow-hidden">
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-red-500 rounded-full blur-3xl opacity-10"></div>
            
            <h1 class="text-6xl md:text-8xl font-black text-oxford tracking-tighter mb-2 glitch-text relative z-10">
                500
            </h1>
            <h2 class="text-2xl font-bold text-red-600 mb-4 relative z-10">Fallo Interno del Servidor</h2>
            
            <p class="text-gray-500 max-w-lg mx-auto mb-8 relative z-10">
                Nuestros sistemas han detectado un problema técnico procesando tu solicitud. El equipo de ingeniería de <strong>EMPRESA</strong> ha sido notificado automáticamente.
            </p>

            <div class="relative z-10">
                <a href="${createLink(uri: '/')}" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-lg text-white bg-cobalto hover:bg-blue-800 transition-colors shadow-lg hover:shadow-xl transform hover:-translate-y-0.5">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    Regresar al Dashboard
                </a>
            </div>
        </div>

        <g:if env="development">
            <div class="bg-gray-50 border-t border-gray-200 p-8 grails-error-container">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-bold text-oxford">Modo Desarrollador: Detalles de la Excepción</h3>
                    <span class="px-3 py-1 bg-yellow-100 text-yellow-800 text-xs font-bold rounded-full uppercase tracking-wide">Development Only</span>
                </div>
                
                <g:if test="${Throwable.isInstance(exception)}">
                    <g:renderException exception="${exception}" 
                                     detailsClass="alert-danger" 
                                     stackClass="stack" 
                                     snippetClass="snippet" 
                                     lineErrorClass="lineErrorClass" />
                </g:if>
                <g:elseif test="${request.getAttribute('javax.servlet.error.exception')}">
                    <g:renderException exception="${request.getAttribute('javax.servlet.error.exception')}" 
                                     detailsClass="alert-danger" 
                                     stackClass="stack" 
                                     snippetClass="snippet" 
                                     lineErrorClass="lineErrorClass" />
                </g:elseif>
                <g:else>
                    <ul class="list-disc pl-5 text-red-600 bg-red-50 p-4 rounded-lg">
                        <li class="font-semibold">Ha ocurrido un error genérico.</li>
                        <li><strong>Excepción:</strong> ${exception}</li>
                        <li><strong>Mensaje:</strong> ${message}</li>
                        <li><strong>Ruta:</strong> ${path}</li>
                    </ul>
                </g:else>
            </div>
        </g:if>
    </div>

    <script>
        const canvas = document.getElementById('errorCanvas');
        const ctx = canvas.getContext('2d');
        let width, height;
        let particles = [];

        function resize() {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
        }

        class Particle {
            constructor() {
                this.x = Math.random() * width;
                this.y = Math.random() * height;
                this.vx = (Math.random() - 0.5) * 1.5;
                this.vy = (Math.random() - 0.5) * 1.5;
                this.radius = Math.random() * 2 + 1;
                // La mayoría son azules (cobalto), algunas fallan y son rojas
                this.isError = Math.random() > 0.85; 
                this.color = this.isError ? 'rgba(239, 68, 68, 0.7)' : 'rgba(30, 58, 138, 0.4)';
            }

            update() {
                this.x += this.vx;
                this.y += this.vy;

                // Rebote en bordes
                if (this.x < 0 || this.x > width) this.vx *= -1;
                if (this.y < 0 || this.y > height) this.vy *= -1;

                // Comportamiento de "Fallo" errático
                if (this.isError && Math.random() > 0.95) {
                    this.vx = (Math.random() - 0.5) * 4;
                    this.vy = (Math.random() - 0.5) * 4;
                }
            }

            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
                ctx.fillStyle = this.color;
                ctx.fill();
            }
        }

        function init() {
            resize();
            window.addEventListener('resize', resize);
            particles = [];
            let particleCount = Math.floor((width * height) / 10000); // Densidad adaptable
            for (let i = 0; i < particleCount; i++) {
                particles.push(new Particle());
            }
            animate();
        }

        function animate() {
            ctx.clearRect(0, 0, width, height);

            // Dibujar líneas de conexión
            for (let i = 0; i < particles.length; i++) {
                for (let j = i + 1; j < particles.length; j++) {
                    let dx = particles[i].x - particles[j].x;
                    let dy = particles[i].y - particles[j].y;
                    let dist = Math.sqrt(dx * dx + dy * dy);

                    if (dist < 120) {
                        ctx.beginPath();
                        ctx.moveTo(particles[i].x, particles[i].y);
                        ctx.lineTo(particles[j].x, particles[j].y);
                        
                        // Si una de las partículas es un error, el enlace se vuelve rojo simulando un corto circuito
                        if (particles[i].isError || particles[j].isError) {
                            ctx.strokeStyle = `rgba(239, 68, 68, ${0.4 - dist/300})`; // Rojo
                        } else {
                            ctx.strokeStyle = `rgba(30, 58, 138, ${0.2 - dist/600})`; // Azul
                        }
                        
                        ctx.lineWidth = 1;
                        ctx.stroke();
                    }
                }
            }

            particles.forEach(p => {
                p.update();
                p.draw();
            });

            requestAnimationFrame(animate);
        }

        init();
    </script>
</body>
</html>