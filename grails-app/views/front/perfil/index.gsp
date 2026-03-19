<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gestión de Perfiles | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 flex flex-col md:flex-row justify-between items-center bg-gray-50 gap-4">
        <h2 class="text-xl font-bold text-oxford">Gestión de Perfiles</h2>
        
        <div class="flex flex-col sm:flex-row w-full md:w-auto space-y-3 sm:space-y-0 sm:space-x-3 items-center">
            
            <div class="flex w-full sm:w-72 relative">
                <input type="text" id="input-busqueda" placeholder="Buscar por nombre..." 
                       class="w-full border border-gray-300 rounded-l-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-cobalto z-10" 
                       onkeypress="if(event.key === 'Enter') buscarPerfiles()">
                
                <button onclick="limpiarBusqueda()" id="btn-limpiar" class="hidden absolute right-12 top-2 text-gray-400 hover:text-red-500 z-20" title="Limpiar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>

                <button onclick="buscarPerfiles()" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-2 rounded-r-lg border-y border-r border-gray-300 transition-colors z-10" title="Buscar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </button>
            </div>

            <button id="btn-nuevo" onclick="abrirModal()" class="w-full sm:w-auto bg-cobalto hover:bg-blue-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm whitespace-nowrap">
                + Nuevo Perfil
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-100 text-gray-600 text-sm uppercase tracking-wider">
                    <th class="p-4 border-b">Nombre del Perfil</th>
                    <th class="p-4 border-b text-right">Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-perfiles" class="text-sm text-gray-700 divide-y divide-gray-100"></tbody>
        </table>
    </div>

    <div class="p-4 border-t border-gray-200 flex flex-col sm:flex-row items-center justify-between bg-gray-50 gap-4">
        <span class="text-sm text-gray-500" id="info-paginacion">Mostrando 0 a 0 de 0 registros</span>
        <div class="flex space-x-1 md:space-x-2">
            <button type="button" onclick="cambiarPagina('inicio')" id="btn-inicio" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">&laquo; Inicio</button>
            <button type="button" onclick="cambiarPagina('prev')" id="btn-prev" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Anterior</button>
            <button type="button" onclick="cambiarPagina('next')" id="btn-next" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Siguiente</button>
            <button type="button" onclick="cambiarPagina('final')" id="btn-final" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Final &raquo;</button>
        </div>
    </div>
</div>

<div id="modal-perfil" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center z-50 p-4">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all">
        <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-bold text-oxford" id="modal-titulo">Nuevo Perfil</h3>
            <button onclick="cerrarModal()" class="text-gray-400 hover:text-gray-600 focus:outline-none">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <div class="p-6">
            <form id="form-perfil" onsubmit="guardarPerfil(event)" autocomplete="off">
                <input type="hidden" id="perfil-id">
                
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Perfil <span class="text-red-500">*</span></label>
                    <input type="text" id="strNombrePerfil" required minlength="4" maxlength="50" oninput="this.value = this.value.replace(/[^a-zA-Z0-9\s]/g, '')" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto" placeholder="Ej. Recursos Humanos">
                </div>

                <div class="flex justify-end space-x-3 mt-6 pt-4 border-t border-gray-200">
                    <button type="button" onclick="cerrarModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium">Cancelar</button>
                    <button type="submit" id="btnGuardar" class="px-4 py-2 bg-cobalto hover:bg-blue-800 text-white rounded-lg shadow-sm text-sm font-medium">Guardar Perfil</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let offsetActual = 0;
    const LIMITE = 5;
    let totalRegistros = 0;
    let terminoBusquedaActual = '';

    if(typeof toastr !== 'undefined') { toastr.options = { "escapeHtml": true, "timeOut": "6000" }; }

    function sanitizarEntrada(texto) { return texto ? texto.replace(/[<>'"=;]/g, '').trim() : ''; }

    function esEntradaPeligrosa(texto) {
        if(!texto) return false;
        const regexPeligro = /(<|>|;|--|\/\*|\*\/|union\s|select\s|insert\s|drop\s|delete\s|update\s|script|onload|onerror|eval)/i;
        const regexGroserias = /(sex|puto|puta|pendej|mierd|cabron|verga|culo|bitch|fuck|dick|ass)/i;
        return regexPeligro.test(texto) || regexGroserias.test(texto);
    }

    function buscarPerfiles() {
        const input = document.getElementById('input-busqueda');
        const limpio = sanitizarEntrada(input.value);
        if (esEntradaPeligrosa(limpio)) {
            toastr.error('Término de búsqueda no permitido.', 'Seguridad');
            return;
        }
        
        terminoBusquedaActual = limpio;
        offsetActual = 0;
        
        const btnLimpiar = document.getElementById('btn-limpiar');
        if (terminoBusquedaActual !== '') {
            btnLimpiar.classList.remove('hidden');
        } else {
            btnLimpiar.classList.add('hidden');
        }
        
        cargarPerfiles();
    }

    function limpiarBusqueda() {
        document.getElementById('input-busqueda').value = '';
        terminoBusquedaActual = '';
        offsetActual = 0;
        document.getElementById('btn-limpiar').classList.add('hidden');
        cargarPerfiles();
    }

    let misPermisos = { agregar: false, editar: false, eliminar: false, consulta: false };

    document.addEventListener('permisosCargados', function() {
        const mapaStr = sessionStorage.getItem('map_permisos');
        if (mapaStr) {
            const mapa = JSON.parse(mapaStr);
            const pathActual = window.location.pathname;
            if (mapa[pathActual]) { misPermisos = mapa[pathActual]; }
        }
        if (!misPermisos.agregar) { document.getElementById('btn-nuevo').style.display = 'none'; }
        if (misPermisos.consulta) { cargarPerfiles(); }
        else { document.getElementById('tabla-perfiles').innerHTML = '<tr><td colspan="2" class="p-4 text-center text-red-500 font-medium">No tiene permisos.</td></tr>'; }
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) { window.location.href = '/front/auth/login'; return null; }
        return { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' };
    }

    async function cargarPerfiles() {
        const headers = getAuthHeaders();
        if (!headers) return;
        let url = '/back/perfil/list?offset=' + offsetActual + '&max=' + LIMITE;
        if (terminoBusquedaActual) url += '&search=' + encodeURIComponent(terminoBusquedaActual);

        try {
            const res = await fetch(url, { headers: headers });
            if (res.ok) {
                const result = await res.json();
                totalRegistros = result.total;
                renderizarTabla(result.data);
                actualizarPaginacion();
            } else {
                const resultError = await res.json().catch(() => ({}));
                toastr.error(resultError.message || 'Error interno en el servidor', 'Error ' + res.status);
            }
        } catch (error) { toastr.error('Error de red al conectar con el servidor', 'Error'); }
    }

    function renderizarTabla(perfiles) {
        const tbody = document.getElementById('tabla-perfiles');
        tbody.innerHTML = '';
        
        if(perfiles.length === 0) {
            const msg = terminoBusquedaActual ? 'No hay resultados para "' + terminoBusquedaActual + '"' : 'Sin datos registrados';
            tbody.innerHTML = '<tr><td colspan="2" class="p-8 text-center text-gray-500">' + msg + '</td></tr>';
            return;
        }
        
        perfiles.forEach(p => {
            let btns = '';
            if (misPermisos.editar) btns += '<button onclick="editarPerfil(' + p.id + ')" class="text-blue-600 hover:text-blue-800 text-sm font-medium mr-3">Editar</button>';
            if (misPermisos.eliminar) btns += '<button onclick="eliminarPerfil(' + p.id + ')" class="text-red-600 hover:text-red-800 text-sm font-medium">Eliminar</button>';
            
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-gray-50 transition-colors';
            tr.innerHTML = '<td class="p-4 font-medium text-oxford">' + p.strNombrePerfil + '</td>' + 
                           '<td class="p-4 text-right">' + (btns || '<span class="text-gray-400 italic">Sin permisos</span>') + '</td>';
            tbody.appendChild(tr);
        });
    }

    function actualizarPaginacion() {
        const spanInfo = document.getElementById('info-paginacion');
        let hasta = Math.min(offsetActual + LIMITE, totalRegistros);
        spanInfo.textContent = 'Mostrando ' + (totalRegistros === 0 ? 0 : offsetActual + 1) + ' a ' + hasta + ' de ' + totalRegistros;
        document.getElementById('btn-inicio').disabled = offsetActual === 0;
        document.getElementById('btn-prev').disabled = offsetActual === 0;
        document.getElementById('btn-next').disabled = (offsetActual + LIMITE) >= totalRegistros || totalRegistros === 0;
        document.getElementById('btn-final').disabled = (offsetActual + LIMITE) >= totalRegistros || totalRegistros === 0;
    }

    function cambiarPagina(accion) {
        if (accion === 'inicio') offsetActual = 0;
        else if (accion === 'prev') offsetActual = Math.max(0, offsetActual - LIMITE);
        else if (accion === 'next') offsetActual += LIMITE;
        else if (accion === 'final') offsetActual = Math.max(0, Math.floor((totalRegistros - 1) / LIMITE) * LIMITE);
        cargarPerfiles();
    }

    function abrirModal() {
        document.getElementById('form-perfil').reset();
        document.getElementById('perfil-id').value = '';
        document.getElementById('modal-titulo').textContent = 'Nuevo Perfil';
        document.getElementById('modal-perfil').classList.remove('hidden');
    }

    function cerrarModal() { document.getElementById('modal-perfil').classList.add('hidden'); }

    async function guardarPerfil(e) {
        e.preventDefault();
        const headers = getAuthHeaders();
        const id = document.getElementById('perfil-id').value;
        const nombre = document.getElementById('strNombrePerfil').value.trim();

        if (nombre.length < 4 || esEntradaPeligrosa(nombre)) {
            toastr.error('Entrada inválida, inapropiada o muy corta (mínimo 4).', 'Seguridad');
            return;
        }

        const btn = document.getElementById('btnGuardar');
        const originalText = btn.innerText;
        btn.innerHTML = 'Guardando...';
        btn.disabled = true;

        const url = id ? '/back/perfil/update/' + id : '/back/perfil/save';
        
        const payload = { 
            strNombrePerfil: nombre, 
            bitAdministrador: false // Siempre falso desde el frontend también
        };

        try {
            const res = await fetch(url, { method: id ? 'PUT' : 'POST', headers: headers, body: JSON.stringify(payload) });
            const result = await res.json();
            if (res.ok && result.success) { 
                cerrarModal(); 
                cargarPerfiles(); 
                toastr.success(result.message || 'Perfil guardado'); 
            } else { 
                toastr.error(result.message || 'Error al guardar'); 
            }
        } catch (error) { toastr.error('Fallo de red al conectar con el servidor'); }
        finally { btn.innerHTML = originalText; btn.disabled = false; }
    }

    async function editarPerfil(id) {
        try {
            const res = await fetch('/back/perfil/show/' + id, { headers: getAuthHeaders() });
            if (res.ok) {
                const p = (await res.json()).data;
                document.getElementById('perfil-id').value = p.id;
                document.getElementById('strNombrePerfil').value = p.strNombrePerfil;
                
                document.getElementById('modal-titulo').textContent = 'Editar Perfil';
                document.getElementById('modal-perfil').classList.remove('hidden');
            } else {
                toastr.error('No se pudieron obtener los detalles del perfil.');
            }
        } catch (error) { toastr.error('Error de red al cargar el detalle'); }
    }

    async function eliminarPerfil(id) {
        if(!confirm('¿Estás seguro de eliminar este perfil?')) return;
        try {
            const res = await fetch('/back/perfil/delete/' + id, { method: 'DELETE', headers: getAuthHeaders() });
            const result = await res.json();
            if(res.ok && result.success) { 
                if (document.getElementById('tabla-perfiles').children.length === 1 && offsetActual > 0) offsetActual -= LIMITE;
                cargarPerfiles(); 
                toastr.success(result.message || 'Perfil eliminado'); 
            } else { 
                toastr.error(result.message || 'No se pudo eliminar el registro.'); 
            }
        } catch (error) { toastr.error('Error de red al intentar eliminar'); }
    }
</script>
</body>
</html>