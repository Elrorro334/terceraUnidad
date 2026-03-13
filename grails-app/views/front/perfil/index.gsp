<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gestión de Perfiles | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    
    <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50">
        <h2 class="text-xl font-bold text-oxford">Gestión de Perfiles</h2>
        <button id="btn-nuevo" onclick="abrirModal()" class="bg-cobalto hover:bg-blue-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm flex items-center">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            Nuevo Perfil
        </button>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-100 text-gray-600 text-sm uppercase tracking-wider">
                    <th class="p-4 border-b">Nombre del Perfil</th>
                    <th class="p-4 border-b">Es Administrador</th>
                    <th class="p-4 border-b text-right">Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-perfiles" class="text-sm text-gray-700 divide-y divide-gray-100">
            </tbody>
        </table>
    </div>

    <div class="p-4 border-t border-gray-200 flex items-center justify-between bg-gray-50">
        <span class="text-sm text-gray-500" id="info-paginacion">Mostrando 0 a 0 de 0 registros</span>
        <div class="flex space-x-1 md:space-x-2">
            <button onclick="cambiarPagina('inicio')" id="btn-inicio" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors" title="Ir a la primera página">&laquo; Inicio</button>
            <button onclick="cambiarPagina('prev')" id="btn-prev" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Anterior</button>
            <button onclick="cambiarPagina('next')" id="btn-next" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors">Siguiente</button>
            <button onclick="cambiarPagina('final')" id="btn-final" class="px-3 py-1 border border-gray-300 rounded-md hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm transition-colors" title="Ir a la última página">Final &raquo;</button>
        </div>
    </div>
</div>

<div id="modal-perfil" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center z-50">
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
                
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Perfil <span class="text-red-500">*</span></label>
                    <input type="text" id="strNombrePerfil" required minlength="3" maxlength="50" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto focus:border-transparent" placeholder="Ej. Recursos Humanos">
                </div>

                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="cerrarModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-cobalto text-white rounded-lg hover:bg-blue-800 transition-colors text-sm font-medium shadow-sm">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let offsetActual = 0;
    const LIMITE = 5;
    let totalRegistros = 0; // Variable global para saber dónde está el final

    if(typeof toastr !== 'undefined') { toastr.options = { "escapeHtml": true }; }

    function sanitizarEntrada(texto) { return texto ? texto.replace(/[<>]/g, '').trim() : ''; }

    let misPermisos = { agregar: false, editar: false, eliminar: false, consulta: false };

    document.addEventListener('permisosCargados', function() {
        const mapaStr = sessionStorage.getItem('map_permisos');
        if (mapaStr) {
            const mapa = JSON.parse(mapaStr);
            const pathActual = window.location.pathname;
            if (mapa[pathActual]) { misPermisos = mapa[pathActual]; }
        }
        
        if (!misPermisos.agregar) { document.getElementById('btn-nuevo').style.display = 'none'; }

        if (misPermisos.consulta) {
            cargarPerfiles();
        } else {
            document.getElementById('tabla-perfiles').innerHTML = '<tr><td colspan="3" class="p-4 text-center text-red-500 font-medium">No tiene permisos para consultar los registros.</td></tr>';
        }
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) { window.location.href = '/front/auth/login'; return null; }
        return { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' };
    }

    async function cargarPerfiles() {
        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const response = await fetch('/back/perfil/list?offset=' + offsetActual + '&max=' + LIMITE, {
                method: 'GET',
                headers: headers
            });

            if (response.ok) {
                const result = await response.json();
                totalRegistros = result.total; // Guardamos el total devuelto por el backend
                renderizarTabla(result.data);
                actualizarPaginacion();
            } else if(response.status === 401 || response.status === 403) {
                localStorage.removeItem('rodnix_jwt');
                window.location.href = '/front/auth/login';
            } else {
                toastr.error('Error al cargar los datos. Status: ' + response.status, 'Error');
            }
        } catch (error) {
            toastr.error('Fallo de red al cargar perfiles', 'Error Crítico');
        }
    }

    function renderizarTabla(perfiles) {
        const tbody = document.getElementById('tabla-perfiles');
        tbody.innerHTML = '';

        if (perfiles.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" class="p-4 text-center text-gray-500">No hay perfiles registrados</td></tr>';
            return;
        }

        perfiles.forEach(function(perfil) {
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-gray-50 transition-colors';
            
            const badgeAdmin = perfil.bitAdministrador 
                ? '<span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">SI</span>' 
                : '<span class="px-2 py-1 bg-gray-100 text-gray-600 rounded-full text-xs font-semibold">NO</span>';

            let botonesAccion = '';
            if (misPermisos.editar) {
                botonesAccion += '<button onclick="editarPerfil(' + perfil.id + ')" class="text-blue-600 hover:text-blue-800 text-sm font-medium mr-2">Editar</button>';
            }
            if (misPermisos.eliminar) {
                botonesAccion += '<button onclick="eliminarPerfil(' + perfil.id + ')" class="text-red-600 hover:text-red-800 text-sm font-medium">Eliminar</button>';
            }
            if (!misPermisos.editar && !misPermisos.eliminar) {
                botonesAccion = '<span class="text-gray-400 text-xs italic">Sin permisos</span>';
            }

            // Ya no imprimimos el ID en el HTML
            tr.innerHTML = 
                '<td class="p-4 font-medium text-oxford">' + perfil.strNombrePerfil + '</td>' +
                '<td class="p-4">' + badgeAdmin + '</td>' +
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

        // Lógica de deshabilitación de botones
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
            // Calcula el offset de la última página matemáticamente
            if (totalRegistros > 0) {
                offsetActual = Math.floor((totalRegistros - 1) / LIMITE) * LIMITE;
            } else {
                offsetActual = 0;
            }
        }
        cargarPerfiles();
    }

    function abrirModal() {
        document.getElementById('form-perfil').reset();
        document.getElementById('perfil-id').value = '';
        document.getElementById('modal-titulo').textContent = 'Nuevo Perfil';
        document.getElementById('modal-perfil').classList.remove('hidden');
    }

    function cerrarModal() {
        document.getElementById('modal-perfil').classList.add('hidden');
    }

    async function guardarPerfil(event) {
        event.preventDefault();
        const headers = getAuthHeaders();
        if (!headers) return;

        const id = document.getElementById('perfil-id').value;
        const nombre = sanitizarEntrada(document.getElementById('strNombrePerfil').value);

        const payload = {
            strNombrePerfil: nombre,
            bitAdministrador: false // Sigue forzado por seguridad
        };

        const url = id ? '/back/perfil/update/' + id : '/back/perfil/save';
        
        try {
            const response = await fetch(url, {
                method: id ? 'PUT' : 'POST',
                headers: headers,
                body: JSON.stringify(payload)
            });

            const result = await response.json();

            if (response.ok && result.success) {
                cerrarModal();
                cargarPerfiles();
                toastr.success(result.message || 'Perfil guardado correctamente', 'Éxito');
            } else {
                toastr.error(result.message || 'Error al guardar el perfil', 'Error');
            }
        } catch (error) {
            toastr.error('Error de comunicación con el servidor', 'Error Crítico');
        }
    }

    async function editarPerfil(id) {
        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const response = await fetch('/back/perfil/show/' + id, {
                method: 'GET',
                headers: headers
            });

            if (response.ok) {
                const result = await response.json();
                const perfil = result.data;
                
                // Mantenemos el ID oculto para poder hacer el PUT, pero no se lo enseñamos al usuario
                document.getElementById('perfil-id').value = perfil.id;
                document.getElementById('strNombrePerfil').value = perfil.strNombrePerfil;
                
                document.getElementById('modal-titulo').textContent = 'Editar Perfil';
                document.getElementById('modal-perfil').classList.remove('hidden');
            } else {
                toastr.warning('No se pudo obtener la información del perfil.', 'Atención');
            }
        } catch (error) {
            toastr.error('Error al cargar el detalle', 'Error Crítico');
        }
    }

    async function eliminarPerfil(id) {
        if (!confirm('¿Estás seguro de que deseas eliminar este perfil permanentemente?')) return;

        const headers = getAuthHeaders();
        if (!headers) return;

        try {
            const response = await fetch('/back/perfil/delete/' + id, {
                method: 'DELETE',
                headers: headers
            });

            const result = await response.json();

            if (response.ok && result.success) {
                const tbody = document.getElementById('tabla-perfiles');
                // Si es el último elemento de la página, retrocede una automáticamente
                if (tbody.children.length === 1 && offsetActual > 0) {
                    offsetActual -= LIMITE;
                }
                cargarPerfiles();
                toastr.success('Perfil eliminado permanentemente', 'Éxito');
            } else {
                toastr.error(result.message || 'No se pudo eliminar el registro (Podría estar en uso).', 'Denegado');
            }
        } catch (error) {
            toastr.error('Error de red al intentar eliminar', 'Error Crítico');
        }
    }
</script>

</body>
</html>