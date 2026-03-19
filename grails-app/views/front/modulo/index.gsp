<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gestión de Módulos | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 flex flex-col md:flex-row justify-between items-center bg-gray-50 gap-4">
        <h2 class="text-xl font-bold text-oxford">Gestión de Módulos</h2>
        
        <div class="flex flex-col sm:flex-row w-full md:w-auto space-y-3 sm:space-y-0 sm:space-x-3 items-center">
            
            <div class="flex w-full sm:w-72 relative">
                <input type="text" id="input-busqueda" placeholder="Buscar por nombre..." 
                       class="w-full border border-gray-300 rounded-l-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-cobalto z-10" 
                       onkeypress="if(event.key === 'Enter') buscarModulos()">
                
                <button onclick="limpiarBusqueda()" id="btn-limpiar" class="hidden absolute right-12 top-2 text-gray-400 hover:text-red-500 z-20" title="Limpiar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>

                <button onclick="buscarModulos()" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-2 rounded-r-lg border-y border-r border-gray-300 transition-colors z-10" title="Buscar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </button>
            </div>

            <button id="btn-nuevo" onclick="abrirModal()" class="w-full sm:w-auto bg-cobalto hover:bg-blue-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm whitespace-nowrap">
                + Nuevo Módulo
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-100 text-gray-600 text-sm uppercase tracking-wider">
                    <th class="p-4 border-b">Nombre del Módulo</th>
                    <th class="p-4 border-b">Menú Asignado</th>
                    <th class="p-4 border-b text-right">Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-modulos" class="text-sm text-gray-700 divide-y divide-gray-100"></tbody>
        </table>
    </div>

    <div class="p-4 border-t border-gray-200 flex flex-col sm:flex-row items-center justify-between bg-gray-50 gap-4">
        <span class="text-sm text-gray-500" id="info-paginacion">Mostrando 0 a 0 de 0 registros</span>
        <div class="flex space-x-1 md:space-x-2">
            <button onclick="cambiarPagina('inicio')" id="btn-inicio" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors" title="Ir a la primera página">&laquo; Inicio</button>
            <button onclick="cambiarPagina('prev')" id="btn-prev" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Anterior</button>
            <button onclick="cambiarPagina('next')" id="btn-next" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Siguiente</button>
            <button onclick="cambiarPagina('final')" id="btn-final" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors" title="Ir a la última página">Final &raquo;</button>
        </div>
    </div>
</div>

<div id="modal-modulo" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all">
        <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-bold text-oxford" id="modal-titulo">Nuevo Módulo</h3>
            <button onclick="cerrarModal()" class="text-gray-400 hover:text-gray-600 focus:outline-none">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <div class="p-6">
            <form id="form-modulo" onsubmit="guardarModulo(event)" autocomplete="off">
                <input type="hidden" id="modulo-id">
                
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Módulo <span class="text-red-500">*</span></label>
                    <input type="text" id="strNombreModulo" required minlength="3" maxlength="50" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                </div>

                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Agrupar en Menú</label>
                    
                    <div class="flex items-center space-x-2">
                        <select id="idMenu" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto bg-white">
                        </select>
                        <button type="button" id="btn-toggle-menu" onclick="toggleNuevoMenu()" class="bg-gray-200 hover:bg-gray-300 text-gray-800 px-3 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap">
                            Crear Nuevo
                        </button>
                    </div>

                    <div id="nuevo-menu-container" class="hidden mt-2">
                        <input type="text" id="nuevoNombreMenu" maxlength="50" placeholder="Escribe el nombre del nuevo menú..." class="w-full border border-blue-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto bg-blue-50">
                        <p class="text-xs text-gray-500 mt-1">Este menú se creará automáticamente y el módulo se le asignará.</p>
                    </div>
                </div>

                <div class="flex justify-end space-x-3 border-t pt-4">
                    <button type="button" onclick="cerrarModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-cobalto hover:bg-blue-800 text-white rounded-lg transition-colors text-sm font-medium shadow-sm">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let offsetActual = 0;
    const LIMITE = 5;
    let totalRegistros = 0; 
    let isNuevoMenu = false; 
    let terminoBusqueda = ''; // Nueva variable de estado para la búsqueda

    if(typeof toastr !== 'undefined') { toastr.options = { "escapeHtml": true }; }

    function sanitizarEntrada(texto) { return texto ? texto.replace(/[<>]/g, '').trim() : ''; }

    let misPermisos = { agregar: false, editar: false, eliminar: false, consulta: false };

    document.addEventListener('permisosCargados', function() { 
        const mapaStr = sessionStorage.getItem('map_permisos');
        if (mapaStr) {
            const mapa = JSON.parse(mapaStr);
            const pathActual = window.location.pathname;
            if (mapa[pathActual]) {
                misPermisos = mapa[pathActual];
            }
        }
        
        if (!misPermisos.agregar) {
            document.getElementById('btn-nuevo').style.display = 'none';
        }

        if (misPermisos.consulta) {
            cargarModulos(); 
            cargarGruposMenu();
        } else {
            document.getElementById('tabla-modulos').innerHTML = '<tr><td colspan="3" class="p-4 text-center text-red-500 font-medium">No tiene permisos para consultar datos.</td></tr>';
        }
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) { window.location.href = '/front/auth/login'; return null; }
        return { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' };
    }

    // --- NUEVAS FUNCIONES DE BÚSQUEDA ---
    function buscarModulos() {
        const input = document.getElementById('input-busqueda');
        terminoBusqueda = sanitizarEntrada(input.value);
        offsetActual = 0; // Reiniciar paginación al buscar
        
        const btnLimpiar = document.getElementById('btn-limpiar');
        if (terminoBusqueda !== '') {
            btnLimpiar.classList.remove('hidden');
        } else {
            btnLimpiar.classList.add('hidden');
        }
        
        cargarModulos();
    }

    function limpiarBusqueda() {
        document.getElementById('input-busqueda').value = '';
        terminoBusqueda = '';
        offsetActual = 0;
        document.getElementById('btn-limpiar').classList.add('hidden');
        cargarModulos();
    }
    // ------------------------------------

    async function cargarGruposMenu() {
        const headers = getAuthHeaders();
        if (!headers) return;
        try {
            const res = await fetch('/back/modulo/getGruposMenu', { headers: headers });
            if (res.ok) {
                const grupos = (await res.json()).data;
                const select = document.getElementById('idMenu');
                select.innerHTML = '<option value="">-- Sin asignar --</option>';
                
                grupos.forEach(function(g) {
                    const opt = document.createElement('option');
                    opt.value = g.idMenu;
                    opt.textContent = g.strNombreMenu;
                    select.appendChild(opt);
                });
            }
        } catch (error) { console.error('Error cargando grupos de menú'); }
    }

    async function cargarModulos() {
        const headers = getAuthHeaders();
        if (!headers) return;
        
        let url = '/back/modulo/list?offset=' + offsetActual + '&max=' + LIMITE;
        if (terminoBusqueda) {
            url += '&search=' + encodeURIComponent(terminoBusqueda);
        }

        try {
            const response = await fetch(url, { headers: headers });
            
            if (response.ok) {
                const result = await response.json();
                totalRegistros = result.total; 
                renderizarTabla(result.data);
                actualizarPaginacion();
            } else if (response.status === 401 || response.status === 403) { 
                localStorage.removeItem('rodnix_jwt');
                window.location.href = '/front/auth/login'; 
            } else {
                // Ahora capturará correctamente los errores 400 y 500
                const resultError = await response.json().catch(() => ({}));
                toastr.error(resultError.message || 'Error interno en el servidor', 'Error ' + response.status);
            }
        } catch (error) { 
            toastr.error('Fallo de conexión al servidor', 'Error Crítico'); 
        }
    }

    function renderizarTabla(modulos) {
        const tbody = document.getElementById('tabla-modulos');
        tbody.innerHTML = '';
        
        // Pequeño ajuste en caso de que una búsqueda no retorne datos
        if(modulos.length === 0) { 
            const msg = terminoBusqueda ? 'No se encontraron resultados para "' + terminoBusqueda + '"' : 'Sin datos registrados';
            tbody.innerHTML = '<tr><td colspan="3" class="p-8 text-center text-gray-500">' + msg + '</td></tr>'; 
            return; 
        }
        
        modulos.forEach(function(m) {
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-gray-50 transition-colors';
            
            const badgeMenu = m.menuAsignado === 'Sin asignar' 
                ? '<span class="text-gray-400 italic">Sin asignar</span>' 
                : '<span class="px-2 py-1 bg-blue-50 text-cobalto border border-blue-100 rounded text-xs font-semibold">' + m.menuAsignado + '</span>';

            let botonesAccion = '';
            if (misPermisos.editar) {
                botonesAccion += '<button onclick="editarModulo(' + m.id + ')" class="text-blue-600 hover:text-blue-800 text-sm font-medium mr-2">Editar</button>';
            }
            if (misPermisos.eliminar) {
                botonesAccion += '<button onclick="eliminarModulo(' + m.id + ')" class="text-red-600 hover:text-red-800 text-sm font-medium">Eliminar</button>';
            }
            if (!misPermisos.editar && !misPermisos.eliminar) {
                botonesAccion = '<span class="text-gray-400 text-xs italic">Sin permisos</span>';
            }

            tr.innerHTML = 
                '<td class="p-4 font-medium text-oxford">' + m.strNombreModulo + '</td>' +
                '<td class="p-4">' + badgeMenu + '</td>' +
                '<td class="p-4 text-right">' + botonesAccion + '</td>';
            tbody.appendChild(tr);
        });
    }

    function actualizarPaginacion() {
        const spanInfo = document.getElementById('info-paginacion');
        const btnInicio = document.getElementById('btn-inicio');
        const btnPrev = document.getElementById('btn-prev');
        const btnNext = document.getElementById('btn-next');
        const btnFinal = document.getElementById('btn-final');

        let mostrandoHasta = offsetActual + LIMITE;
        if (mostrandoHasta > totalRegistros) mostrandoHasta = totalRegistros;
        let mostrandoDesde = totalRegistros === 0 ? 0 : offsetActual + 1;

        spanInfo.textContent = 'Mostrando ' + mostrandoDesde + ' a ' + mostrandoHasta + ' de ' + totalRegistros + ' registros';

        const esPrimeraPagina = offsetActual === 0;
        const esUltimaPagina = (offsetActual + LIMITE) >= totalRegistros;

        btnInicio.disabled = esPrimeraPagina;
        btnPrev.disabled = esPrimeraPagina;
        btnNext.disabled = esUltimaPagina || totalRegistros === 0;
        btnFinal.disabled = esUltimaPagina || totalRegistros === 0;
    }

    function cambiarPagina(accion) {
        if (accion === 'inicio') {
            offsetActual = 0;
        } else if (accion === 'prev') {
            offsetActual -= LIMITE;
            if (offsetActual < 0) offsetActual = 0;
        } else if (accion === 'next') {
            offsetActual += LIMITE;
        } else if (accion === 'final') {
            if (totalRegistros > 0) {
                offsetActual = Math.floor((totalRegistros - 1) / LIMITE) * LIMITE;
            } else {
                offsetActual = 0;
            }
        }
        cargarModulos();
    }

    function toggleNuevoMenu() {
        isNuevoMenu = !isNuevoMenu;
        const select = document.getElementById('idMenu');
        const container = document.getElementById('nuevo-menu-container');
        const btn = document.getElementById('btn-toggle-menu');

        if(isNuevoMenu) {
            select.disabled = true;
            select.classList.add('opacity-50');
            container.classList.remove('hidden');
            document.getElementById('nuevoNombreMenu').required = true;
            btn.textContent = 'Cancelar Nuevo';
            btn.classList.replace('bg-gray-200', 'bg-red-100');
            btn.classList.replace('text-gray-800', 'text-red-700');
        } else {
            select.disabled = false;
            select.classList.remove('opacity-50');
            container.classList.add('hidden');
            document.getElementById('nuevoNombreMenu').required = false;
            document.getElementById('nuevoNombreMenu').value = '';
            btn.textContent = 'Crear Nuevo';
            btn.classList.replace('bg-red-100', 'bg-gray-200');
            btn.classList.replace('text-red-700', 'text-gray-800');
        }
    }

    function abrirModal() { 
        document.getElementById('form-modulo').reset(); 
        document.getElementById('modulo-id').value = ''; 
        if(isNuevoMenu) toggleNuevoMenu(); 
        document.getElementById('modal-titulo').textContent = 'Nuevo Módulo'; 
        document.getElementById('modal-modulo').classList.remove('hidden'); 
    }
    
    function cerrarModal() { document.getElementById('modal-modulo').classList.add('hidden'); }

    async function guardarModulo(e) {
        e.preventDefault();
        const headers = getAuthHeaders();
        if (!headers) return;

        const id = document.getElementById('modulo-id').value;
        const nombreMod = sanitizarEntrada(document.getElementById('strNombreModulo').value);
        
        let idMenuVal = null;
        let nombreMenuVal = null;

        if (isNuevoMenu) {
            nombreMenuVal = sanitizarEntrada(document.getElementById('nuevoNombreMenu').value);
        } else {
            const selectMenu = document.getElementById('idMenu');
            idMenuVal = selectMenu.value;
            nombreMenuVal = idMenuVal ? selectMenu.options[selectMenu.selectedIndex].text : null;
        }

        const payload = { 
            strNombreModulo: nombreMod,
            idMenu: idMenuVal,
            strNombreMenu: nombreMenuVal
        };

        const url = id ? '/back/modulo/update/' + id : '/back/modulo/save';
        
        try {
            const res = await fetch(url, { method: id ? 'PUT' : 'POST', headers: headers, body: JSON.stringify(payload) });
            const result = await res.json();
            
            if (res.ok && result.success) { 
                cerrarModal(); 
                cargarModulos(); 
                cargarGruposMenu(); 
                toastr.success(result.message, 'Éxito');
                
                if(typeof cargarMenuDesdeBackend === 'function') cargarMenuDesdeBackend();
            } else { 
                toastr.error(result.message || 'Error al procesar la solicitud', 'Error'); 
            }
        } catch (error) { toastr.error('Fallo de conexión', 'Error Crítico'); }
    }

    async function editarModulo(id) {
        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const res = await fetch('/back/modulo/show/' + id, { headers: headers });
            if (res.ok) {
                const data = (await res.json()).data;
                document.getElementById('modulo-id').value = data.id;
                document.getElementById('strNombreModulo').value = data.strNombreModulo;
                
                if(isNuevoMenu) toggleNuevoMenu();
                document.getElementById('idMenu').value = data.idMenu || '';
                
                document.getElementById('modal-titulo').textContent = 'Editar Módulo';
                document.getElementById('modal-modulo').classList.remove('hidden');
            } else {
                toastr.warning('No se encontraron los datos del módulo', 'Atención');
            }
        } catch(error) { toastr.error('Fallo al cargar datos', 'Error'); }
    }

    async function eliminarModulo(id) {
        if(!confirm('¿Eliminar módulo permanentemente? (Esto también borrará sus permisos)')) return;
        
        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const res = await fetch('/back/modulo/delete/' + id, { method: 'DELETE', headers: headers });
            const result = await res.json();
            
            if(res.ok && result.success) { 
                if (document.getElementById('tabla-modulos').children.length === 1 && offsetActual > 0) {
                    offsetActual -= LIMITE;
                }
                cargarModulos(); 
                cargarGruposMenu(); 
                toastr.success(result.message, 'Éxito');
                if(typeof cargarMenuDesdeBackend === 'function') cargarMenuDesdeBackend();
            } else { 
                toastr.error(result.message || 'No se pudo eliminar.', 'Denegado'); 
            }
        } catch(error) { toastr.error('Fallo de conexión al eliminar', 'Error'); }
    }
</script>
</body>
</html>