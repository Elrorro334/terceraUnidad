<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Permisos por Perfil | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 bg-gray-50 flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <h2 class="text-xl font-bold text-oxford">Matriz de Permisos</h2>
        
        <div class="flex flex-col sm:flex-row w-full lg:w-auto space-y-3 sm:space-y-0 sm:space-x-4 items-center">
            
            <div class="flex items-center space-x-2 w-full sm:w-auto">
                <label class="text-sm font-medium text-gray-700 whitespace-nowrap">Perfil:</label>
                <select id="select-perfil" onchange="cargarMatriz()" class="border border-gray-300 rounded-lg py-2 px-4 focus:ring-cobalto focus:border-cobalto w-full sm:w-56 bg-white text-sm">
                    <option value="">-- Seleccione --</option>
                </select>
            </div>

            <div id="contenedor-busqueda" class="hidden w-full sm:w-72 relative transition-all">
                <input type="text" id="input-busqueda" placeholder="Buscar módulo..." 
                       class="w-full border border-gray-300 rounded-l-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-cobalto z-10" 
                       oninput="toggleBotonLimpiar()" onkeypress="if(event.key === 'Enter') { event.preventDefault(); ejecutarBusquedaLocal(); }">
                
                <button type="button" onclick="limpiarBusqueda()" id="btn-limpiar" class="hidden absolute right-12 top-2 text-gray-400 hover:text-red-500 z-20" title="Limpiar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>

                <button type="button" onclick="ejecutarBusquedaLocal()" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-2 rounded-r-lg border-y border-r border-gray-300 transition-colors z-10" title="Buscar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </button>
            </div>

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
            
            <div class="mt-4 border-t border-gray-200 flex flex-col sm:flex-row items-center justify-between pt-4 hidden gap-4" id="paginacion-container">
                <span class="text-sm text-gray-500" id="info-paginacion">Mostrando 0 a 0 de 0 módulos</span>
                <div class="flex space-x-1 md:space-x-2">
                    <button type="button" onclick="cambiarPagina('inicio')" id="btn-inicio" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">&laquo; Inicio</button>
                    <button type="button" onclick="cambiarPagina('prev')" id="btn-prev" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Anterior</button>
                    <button type="button" onclick="cambiarPagina('next')" id="btn-next" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Siguiente</button>
                    <button type="button" onclick="cambiarPagina('final')" id="btn-final" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Final &raquo;</button>
                </div>
            </div>
            
            <div class="mt-6 flex justify-end hidden" id="btn-guardar-container">
                <button type="submit" id="btn-guardar" class="bg-cobalto hover:bg-blue-800 text-white px-6 py-2 rounded-lg text-sm font-bold shadow-md transition-colors">
                    Guardar Matriz de Permisos
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let permisosGlobales = [];
    let permisosFiltrados = [];
    let offsetActual = 0;
    const LIMITE = 5;

    if(typeof toastr !== 'undefined') { toastr.options = { "escapeHtml": true }; }

    function sanitizarEntrada(texto) { return texto ? texto.replace(/[<>'"=;]/g, '').trim() : ''; }

    document.addEventListener('DOMContentLoaded', function() {
        cargarPerfilesSelect();
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) { window.location.href = '/front/auth/login'; return null; }
        return { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' };
    }

    // --- FUNCIONES DE BÚSQUEDA ---
    function toggleBotonLimpiar() {
        const input = document.getElementById('input-busqueda');
        const btn = document.getElementById('btn-limpiar');
        if (input.value.length > 0) btn.classList.remove('hidden');
        else btn.classList.add('hidden');
    }

    function limpiarBusqueda() {
        document.getElementById('input-busqueda').value = '';
        toggleBotonLimpiar();
        permisosFiltrados = [...permisosGlobales];
        offsetActual = 0;
        renderizarMatrizPaginada();
    }

    function ejecutarBusquedaLocal() {
        const inputVal = document.getElementById('input-busqueda').value;
        const termino = sanitizarEntrada(inputVal).toLowerCase();
        
        if (termino === '') {
            permisosFiltrados = [...permisosGlobales];
        } else {
            permisosFiltrados = permisosGlobales.filter(p => p.strNombreModulo.toLowerCase().includes(termino));
        }
        offsetActual = 0;
        renderizarMatrizPaginada();
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
        } catch (error) { toastr.error('Fallo al cargar la lista de perfiles', 'Error'); }
    }

    async function cargarMatriz() {
        const idPerfil = document.getElementById('select-perfil').value;
        const tbody = document.getElementById('tabla-permisos');
        const btnContainer = document.getElementById('btn-guardar-container');
        const pagContainer = document.getElementById('paginacion-container');
        const busqContainer = document.getElementById('contenedor-busqueda');

        if (!idPerfil) {
            tbody.innerHTML = '<tr><td colspan="5" class="p-8 text-gray-500">Seleccione un perfil para ver sus permisos</td></tr>';
            btnContainer.classList.add('hidden');
            pagContainer.classList.add('hidden');
            busqContainer.classList.remove('flex');
            busqContainer.classList.add('hidden');
            permisosGlobales = [];
            permisosFiltrados = [];
            return;
        }

        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const res = await fetch('/back/permisosPerfil/getMatriz?idPerfil=' + idPerfil, { headers: headers });
            if (res.ok) {
                permisosGlobales = (await res.json()).data;
                permisosFiltrados = [...permisosGlobales];
                offsetActual = 0; 
                document.getElementById('input-busqueda').value = '';
                toggleBotonLimpiar();
                
                renderizarMatrizPaginada();
                
                btnContainer.classList.remove('hidden');
                pagContainer.classList.remove('hidden');
                pagContainer.classList.add('flex');
                
                // Mostramos el buscador cambiándolo a flex
                busqContainer.classList.remove('hidden');
                busqContainer.classList.add('flex');
            } else {
                const resultError = await res.json().catch(() => ({}));
                toastr.error(resultError.message || 'Error al obtener la matriz', 'Error ' + res.status);
            }
        } catch(error) { toastr.error('Fallo de red al cargar matriz', 'Error Crítico'); }
    }

    function renderizarMatrizPaginada() {
        const tbody = document.getElementById('tabla-permisos');
        tbody.innerHTML = '';
        
        if (permisosFiltrados.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="p-8 text-gray-500">No se encontraron módulos con ese nombre.</td></tr>';
            actualizarPaginacion();
            return;
        }

        const paginaData = permisosFiltrados.slice(offsetActual, offsetActual + LIMITE);
        
        paginaData.forEach(function(m) {
            const idMod = m.idModulo;
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-blue-50 transition-colors';
            
            tr.innerHTML = 
                '<td class="p-3 text-left font-semibold text-oxford border-r">' + m.strNombreModulo + '</td>' +
                '<td class="p-3 border-r"><input type="checkbox" onchange="actualizarEstadoPermiso(' + idMod + ', \'bitConsulta\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitConsulta ? 'checked' : '') + '></td>' +
                '<td class="p-3 border-r"><input type="checkbox" onchange="actualizarEstadoPermiso(' + idMod + ', \'bitAgregar\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitAgregar ? 'checked' : '') + '></td>' +
                '<td class="p-3 border-r"><input type="checkbox" onchange="actualizarEstadoPermiso(' + idMod + ', \'bitEditar\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitEditar ? 'checked' : '') + '></td>' +
                '<td class="p-3"><input type="checkbox" onchange="actualizarEstadoPermiso(' + idMod + ', \'bitEliminar\', this.checked)" class="w-4 h-4 text-cobalto focus:ring-cobalto" ' + (m.bitEliminar ? 'checked' : '') + '></td>';
            
            tbody.appendChild(tr);
        });

        actualizarPaginacion();
    }

    function actualizarEstadoPermiso(idModulo, campo, valor) {
        const index = permisosGlobales.findIndex(p => p.idModulo === idModulo);
        if(index !== -1) {
            permisosGlobales[index][campo] = valor;
            
            const indexFiltrado = permisosFiltrados.findIndex(p => p.idModulo === idModulo);
            if(indexFiltrado !== -1) permisosFiltrados[indexFiltrado][campo] = valor;
        }
    }

    function actualizarPaginacion() {
        const total = permisosFiltrados.length;
        const spanInfo = document.getElementById('info-paginacion');
        
        let mostrandoHasta = offsetActual + LIMITE;
        if (mostrandoHasta > total) mostrandoHasta = total;
        let mostrandoDesde = total === 0 ? 0 : offsetActual + 1;

        spanInfo.textContent = 'Mostrando ' + mostrandoDesde + ' a ' + mostrandoHasta + ' de ' + total + ' módulos';

        const esPrimeraPagina = offsetActual === 0;
        const esUltimaPagina = (offsetActual + LIMITE) >= total;

        document.getElementById('btn-inicio').disabled = esPrimeraPagina;
        document.getElementById('btn-prev').disabled = esPrimeraPagina;
        document.getElementById('btn-next').disabled = esUltimaPagina || total === 0;
        document.getElementById('btn-final').disabled = esUltimaPagina || total === 0;
    }

    function cambiarPagina(accion) {
        const total = permisosFiltrados.length;
        if (accion === 'inicio') offsetActual = 0;
        else if (accion === 'prev') offsetActual = Math.max(0, offsetActual - LIMITE);
        else if (accion === 'next') offsetActual += LIMITE;
        else if (accion === 'final') offsetActual = Math.max(0, Math.floor((total - 1) / LIMITE) * LIMITE);
        renderizarMatrizPaginada();
    }

    async function guardarMatriz(e) {
        e.preventDefault();
        const idPerfil = document.getElementById('select-perfil').value;
        
        if(!idPerfil) {
            toastr.warning('Debe seleccionar un perfil primero', 'Atención');
            return;
        }

        const btnGuardar = document.getElementById('btn-guardar');
        const textOrig = btnGuardar.innerText;
        btnGuardar.innerText = 'Guardando...';
        btnGuardar.disabled = true;

        const permisosPayload = permisosGlobales.map(function(m) {
            return {
                idModulo: m.idModulo,
                bitConsulta: m.bitConsulta,
                bitAgregar: m.bitAgregar,
                bitEditar: m.bitEditar,
                bitEliminar: m.bitEliminar,
                bitDetalle: false 
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
        } finally {
            btnGuardar.innerText = textOrig;
            btnGuardar.disabled = false;
        }
    }
</script>
</body>
</html>