<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Permisos por Perfil | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 bg-gray-50 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <h2 class="text-xl font-bold text-oxford">Matriz de Permisos</h2>
        
        <div class="flex items-center space-x-4 w-full md:w-auto">
            <label class="text-sm font-medium text-gray-700">Seleccionar Perfil:</label>
            <select id="select-perfil" onchange="cargarMatriz()" class="border border-gray-300 rounded-md py-2 px-4 focus:ring-cobalto focus:border-cobalto w-full md:w-64 bg-white text-sm">
                <option value="">-- Seleccione un Perfil --</option>
            </select>
        </div>
    </div>

    <div class="overflow-x-auto p-4">
        <form id="form-permisos" onsubmit="guardarMatriz(event)">
            <table class="w-full text-center border-collapse">
                <thead>
                    <tr class="bg-cobalto text-white text-sm uppercase tracking-wider">
                        <th class="p-3 text-left rounded-tl-lg">Módulo</th>
                        <th class="p-3">Consultar</th>
                        <th class="p-3">Agregar</th>
                        <th class="p-3">Editar</th>
                        <th class="p-3 rounded-tr-lg">Eliminar</th>
                    </tr>
                </thead>
                <tbody id="tabla-permisos" class="text-sm text-gray-700 divide-y divide-gray-200 border border-gray-200 border-t-0">
                    <tr><td colspan="5" class="p-8 text-gray-500">Seleccione un perfil para ver sus permisos</td></tr>
                </tbody>
            </table>
            
            <div class="mt-4 border-t border-gray-200 flex items-center justify-between pt-4 hidden" id="paginacion-container">
                <span class="text-sm text-gray-500" id="info-paginacion">Mostrando 0 a 0 de 0 módulos</span>
                <div class="flex space-x-1 md:space-x-2">
                    <button type="button" onclick="cambiarPagina('inicio')" id="btn-inicio" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">&laquo; Inicio</button>
                    <button type="button" onclick="cambiarPagina('prev')" id="btn-prev" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Anterior</button>
                    <button type="button" onclick="cambiarPagina('next')" id="btn-next" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Siguiente</button>
                    <button type="button" onclick="cambiarPagina('final')" id="btn-final" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Final &raquo;</button>
                </div>
            </div>
            
            <div class="mt-6 flex justify-end hidden" id="btn-guardar-container">
                <button type="submit" class="bg-cobalto hover:bg-blue-800 text-white px-6 py-2 rounded-lg text-sm font-bold shadow-md transition-colors">
                    Guardar Matriz de Permisos
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Variables globales para la paginación del cliente (Client-side Pagination)
    let permisosGlobales = [];
    let offsetActual = 0;
    const LIMITE = 5;

    // PROTECCIÓN TOASTR
    if(typeof toastr !== 'undefined') { toastr.options = { "escapeHtml": true }; }

    document.addEventListener('DOMContentLoaded', function() {
        cargarPerfilesSelect();
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) { window.location.href = '/front/auth/login'; return null; }
        return { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' };
    }

    async function cargarPerfilesSelect() {
        const headers = getAuthHeaders();
        if (!headers) return;
        try {
            const res = await fetch('/back/permisosPerfil/getPerfiles', { headers: headers });
            if (res.ok) {
                const perfiles = (await res.json()).data;
                const select = document.getElementById('select-perfil');
                perfiles.forEach(function(p) {
                    const opt = document.createElement('option');
                    opt.value = p.id;
                    opt.textContent = p.strNombrePerfil;
                    select.appendChild(opt);
                });
            } else if (res.status === 401) { window.location.href = '/front/auth/login'; }
        } catch (error) { console.error('Error cargando perfiles', error); }
    }

    async function cargarMatriz() {
        const idPerfil = document.getElementById('select-perfil').value;
        const tbody = document.getElementById('tabla-permisos');
        const btnContainer = document.getElementById('btn-guardar-container');
        const pagContainer = document.getElementById('paginacion-container');

        if (!idPerfil) {
            tbody.innerHTML = '<tr><td colspan="5" class="p-8 text-gray-500">Seleccione un perfil para ver sus permisos</td></tr>';
            btnContainer.classList.add('hidden');
            pagContainer.classList.add('hidden');
            permisosGlobales = [];
            return;
        }

        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const res = await fetch('/back/permisosPerfil/getMatriz?idPerfil=' + idPerfil, { headers: headers });
            if (res.ok) {
                // Descargamos TODOS los permisos en la variable global
                permisosGlobales = (await res.json()).data;
                offsetActual = 0; // Reiniciamos a la primera página
                
                renderizarMatrizPaginada();
                
                btnContainer.classList.remove('hidden');
                pagContainer.classList.remove('hidden');
            }
        } catch(error) { toastr.error('Fallo de red al cargar matriz', 'Error'); }
    }

    function renderizarMatrizPaginada() {
        const tbody = document.getElementById('tabla-permisos');
        tbody.innerHTML = '';
        
        // Cortamos el arreglo para mostrar solo los 5 correspondientes a la página
        const paginaData = permisosGlobales.slice(offsetActual, offsetActual + LIMITE);
        
        paginaData.forEach(function(m, indexLocal) {
            // Calculamos el índice real dentro del arreglo global para guardar los cambios
            const indexGlobal = offsetActual + indexLocal;
            
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-blue-50 transition-colors';
            
            tr.innerHTML = 
                '<td class="p-3 text-left font-semibold text-oxford border-r">' + m.strNombreModulo + '</td>' +
                '<td class="p-3 border-r"><input type="checkbox" onchange="actualizarEstadoPermiso(' + indexGlobal + ', \'bitConsulta\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitConsulta ? 'checked' : '') + '></td>' +
                '<td class="p-3 border-r"><input type="checkbox" onchange="actualizarEstadoPermiso(' + indexGlobal + ', \'bitAgregar\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitAgregar ? 'checked' : '') + '></td>' +
                '<td class="p-3 border-r"><input type="checkbox" onchange="actualizarEstadoPermiso(' + indexGlobal + ', \'bitEditar\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitEditar ? 'checked' : '') + '></td>' +
                '<td class="p-3"><input type="checkbox" onchange="actualizarEstadoPermiso(' + indexGlobal + ', \'bitEliminar\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitEliminar ? 'checked' : '') + '></td>';
            
            tbody.appendChild(tr);
        });

        actualizarPaginacion();
    }

    // Función que se ejecuta cada que el usuario hace click en un checkbox
    function actualizarEstadoPermiso(indexGlobal, campo, valor) {
        permisosGlobales[indexGlobal][campo] = valor;
    }

    function actualizarPaginacion() {
        const total = permisosGlobales.length;
        const spanInfo = document.getElementById('info-paginacion');
        const btnInicio = document.getElementById('btn-inicio');
        const btnPrev = document.getElementById('btn-prev');
        const btnNext = document.getElementById('btn-next');
        const btnFinal = document.getElementById('btn-final');

        let mostrandoHasta = offsetActual + LIMITE;
        if (mostrandoHasta > total) mostrandoHasta = total;
        let mostrandoDesde = total === 0 ? 0 : offsetActual + 1;

        spanInfo.textContent = 'Mostrando ' + mostrandoDesde + ' a ' + mostrandoHasta + ' de ' + total + ' módulos';

        const esPrimeraPagina = offsetActual === 0;
        const esUltimaPagina = (offsetActual + LIMITE) >= total;

        btnInicio.disabled = esPrimeraPagina;
        btnPrev.disabled = esPrimeraPagina;
        btnNext.disabled = esUltimaPagina || total === 0;
        btnFinal.disabled = esUltimaPagina || total === 0;
    }

    function cambiarPagina(accion) {
        const total = permisosGlobales.length;
        if (accion === 'inicio') {
            offsetActual = 0;
        } else if (accion === 'prev') {
            offsetActual -= LIMITE;
            if (offsetActual < 0) offsetActual = 0;
        } else if (accion === 'next') {
            offsetActual += LIMITE;
        } else if (accion === 'final') {
            if (total > 0) {
                offsetActual = Math.floor((total - 1) / LIMITE) * LIMITE;
            }
        }
        renderizarMatrizPaginada();
    }

    async function guardarMatriz(e) {
        e.preventDefault();
        const idPerfil = document.getElementById('select-perfil').value;
        
        if(!idPerfil) {
            toastr.warning('Debe seleccionar un perfil primero', 'Atención');
            return;
        }

        // En lugar de leer el HTML, mandamos directamente nuestra variable global que ya tiene los cambios
        const permisosPayload = permisosGlobales.map(function(m) {
            return {
                idModulo: m.idModulo,
                bitConsulta: m.bitConsulta,
                bitAgregar: m.bitAgregar,
                bitEditar: m.bitEditar,
                bitEliminar: m.bitEliminar,
                bitDetalle: false // Requisito de backend
            };
        });

        const payload = { idPerfil: idPerfil, permisos: permisosPayload };

        try {
            const res = await fetch('/back/permisosPerfil/saveMatriz', {
                method: 'POST',
                headers: getAuthHeaders(),
                body: JSON.stringify(payload)
            });
            
            const result = await res.json();
            
            if (res.ok && result.success) {
                toastr.success('Permisos guardados correctamente.', 'Éxito');
                if(typeof cargarMenuDesdeBackend === 'function') { cargarMenuDesdeBackend(); }
            } else {
                toastr.error(result.message || 'Error al guardar.', 'Error');
            }
        } catch(error) { 
            toastr.error('Error de comunicación con el servidor', 'Error Crítico');
        }
    }
</script>
</body>
</html>