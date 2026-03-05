<%@ page import="grails.util.Environment; org.springframework.core.SpringVersion; org.springframework.boot.SpringBootVersion" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Inicio | Panel de Control</title>
</head>
<body>

<content tag="nav">
    <li><a href="#" class="hover:text-blue-200 transition-colors px-3 py-2 rounded-md text-sm font-medium">Perfil</a></li>
    <li><a href="#" class="hover:text-blue-200 transition-colors px-3 py-2 rounded-md text-sm font-medium">Seguridad</a></li>
    <li><a href="#" class="bg-blue-700 hover:bg-blue-600 transition-colors px-4 py-2 rounded-md text-sm font-medium ml-4 shadow-sm">Salir</a></li>
</content>

<div id="content" role="main" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-12 border border-gray-100">
        <div class="bg-gradient-to-r from-cobalto to-blue-800 px-6 py-16 sm:p-20 text-center">
            <h1 class="text-4xl font-extrabold text-white sm:text-5xl mb-6 tracking-tight">
                Bienvenido al sistema de administración de nuestra empresa
            </h1>
            <p class="mt-4 text-lg text-blue-100 max-w-3xl mx-auto leading-relaxed">
                Gestión corporativa integral. Controla usuarios, configura módulos y administra los niveles de seguridad desde un entorno centralizado y responsivo.
            </p>
        </div>
    </div>

    <section class="mb-12">
        <div class="flex items-center mb-8 pb-4 border-b border-gray-200">
            <h2 class="text-2xl font-bold text-oxford">Módulos del Sistema</h2>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <g:each var="c" in="${grailsApplication.controllerClasses.sort { it.fullName } }">
                <div class="bg-white rounded-xl shadow-sm hover:shadow-xl transition-all duration-300 border border-gray-100 overflow-hidden group">
                    <div class="p-6">
                        <div class="flex items-center justify-center w-14 h-14 bg-blue-50 text-cobalto rounded-lg mb-6 group-hover:scale-110 transition-transform duration-300">
                            <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4"></path>
                            </svg>
                        </div>
                        <h3 class="text-xl font-semibold text-oxford mb-2 capitalize">${c.logicalPropertyName}</h3>
                        <p class="text-gray-500 text-sm mb-6 line-clamp-2">
                            Accede a la configuración y gestión de datos correspondientes a esta entidad del sistema.
                        </p>
                        <g:link controller="${c.logicalPropertyName}" class="inline-flex items-center text-cobalto hover:text-blue-700 font-semibold text-sm group-hover:underline">
                            Ingresar al módulo
                            <svg class="ml-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </g:link>
                    </div>
                </div>
            </g:each>
        </div>
    </section>

</div>

</body>
</html>