<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Gestión de Usuarios | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 flex flex-col md:flex-row justify-between items-center bg-gray-50 gap-4">
        <h2 class="text-xl font-bold text-oxford">Gestión de Usuarios</h2>
        
        <div class="flex flex-col sm:flex-row w-full md:w-auto space-y-3 sm:space-y-0 sm:space-x-3 items-center">
            <div class="flex w-full sm:w-80 relative">
                <input type="text" id="input-busqueda" placeholder="Buscar por usuario o correo..." 
                       class="w-full border border-gray-300 rounded-l-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-cobalto z-10" 
                       oninput="toggleBotonLimpiar()" onkeypress="ejecutarBusquedaEnter(event)">
                
                <button onclick="limpiarBusqueda()" id="btn-clear-input" class="hidden absolute right-12 top-2 text-gray-400 hover:text-red-500 z-20" title="Limpiar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>

                <button onclick="ejecutarBusqueda()" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-2 rounded-r-lg border-y border-r border-gray-300 transition-colors z-10" title="Buscar">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </button>
            </div>

            <button id="btn-nuevo" onclick="abrirModal()" class="w-full sm:w-auto bg-cobalto hover:bg-blue-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm whitespace-nowrap">
                + Nuevo Usuario
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-100 text-gray-600 text-sm uppercase tracking-wider">
                    <th class="p-4 border-b w-16 text-center">Img</th>
                    <th class="p-4 border-b">Usuario</th>
                    <th class="p-4 border-b">Correo</th>
                    <th class="p-4 border-b">Perfil</th>
                    <th class="p-4 border-b">Estado</th>
                    <th class="p-4 border-b text-right">Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-usuarios" class="text-sm text-gray-700 divide-y divide-gray-100"></tbody>
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

<div id="modal-usuario" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center z-50 p-4 overflow-y-auto">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl overflow-hidden transform transition-all my-8">
        <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-bold text-oxford" id="modal-titulo">Nuevo Usuario</h3>
            <button onclick="cerrarModal()" class="text-gray-400 hover:text-gray-600 focus:outline-none">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <div class="p-6">
            <form id="form-usuario" onsubmit="guardarUsuario(event)" autocomplete="off" enctype="multipart/form-data">
                <input type="hidden" id="usuario-id">
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="mb-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nombre de Usuario <span class="text-red-500">*</span></label>
                        <input type="text" id="strNombreUsuario" required minlength="4" maxlength="50" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                    </div>

                    <div class="mb-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Correo Electrónico <span class="text-red-500">*</span></label>
                        <input type="email" id="strCorreo" required maxlength="100" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                    </div>

                    <div class="mb-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Contraseña <span id="req-pwd" class="text-red-500">*</span></label>
                        <input type="password" id="strPwd" minlength="6" maxlength="50" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                    </div>

                    <div class="mb-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Número Celular</label>
                        <input type="text" id="strNumeroCelular" maxlength="20" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                    </div>

                    <div class="mb-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Perfil <span class="text-red-500">*</span></label>
                        <select id="idPerfil" required class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto bg-white">
                            <option value="">-- Seleccione un Perfil --</option>
                        </select>
                    </div>

                    <div class="mb-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Estado</label>
                        <select id="idEstadoUsuario" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto bg-white">
                            <option value="ACTIVO">Activo</option>
                            <option value="INACTIVO">Inactivo</option>
                        </select>
                    </div>
                </div>

                <div class="mt-4 border-t border-gray-200 pt-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Fotografía de Perfil (Opcional, max 2MB)</label>
                    <div class="flex items-center space-x-4">
                        <input type="file" id="imagenPerfil" accept=".jpg,.jpeg,.png" onchange="previsualizarImagenSegura(event)" class="text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-cobalto hover:file:bg-blue-100 transition-colors">
                        <div id="preview-container" class="hidden">
                            <img id="img-preview" src="" alt="Vista previa" class="h-16 w-16 object-cover rounded-full border border-gray-300 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="flex justify-end space-x-3 mt-6 pt-4 border-t border-gray-200">
                    <button type="button" onclick="cerrarModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium">Cancelar</button>
                    <button type="submit" id="btnGuardar" class="px-4 py-2 bg-cobalto hover:bg-blue-800 text-white rounded-lg shadow-sm text-sm font-medium">Guardar Usuario</button>
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

    function toggleBotonLimpiar() {
        const input = document.getElementById('input-busqueda');
        const btn = document.getElementById('btn-clear-input');
        if (input.value.length > 0) btn.classList.remove('hidden');
        else btn.classList.add('hidden');
    }

    function limpiarBusqueda() {
        document.getElementById('input-busqueda').value = '';
        terminoBusquedaActual = '';
        offsetActual = 0;
        document.getElementById('btn-clear-input').classList.add('hidden');
        cargarUsuarios();
    }

    function ejecutarBusquedaEnter(event) { if (event.key === "Enter") ejecutarBusqueda(); }

    function ejecutarBusqueda() {
        const inputVal = document.getElementById('input-busqueda').value;
        const limpio = sanitizarEntrada(inputVal);
        
        if (esEntradaPeligrosa(limpio)) {
            toastr.error('Término de búsqueda no permitido.', 'Seguridad');
            return;
        }

        terminoBusquedaActual = limpio;
        offsetActual = 0;
        
        const btnLimpiar = document.getElementById('btn-clear-input');
        if (terminoBusquedaActual !== '') btnLimpiar.classList.remove('hidden');
        else btnLimpiar.classList.add('hidden');
        
        cargarUsuarios();
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
        if (misPermisos.consulta) { cargarUsuarios(); cargarPerfilesSelect(); }
    });

    function getAuthHeaders(isFormData = false) {
        const token = localStorage.getItem('rodnix_jwt');
        if (!token) { window.location.href = '/front/auth/login'; return null; }
        let headers = { 'Authorization': 'Bearer ' + token };
        if (!isFormData) { headers['Content-Type'] = 'application/json'; headers['Accept'] = 'application/json'; }
        return headers;
    }

    async function cargarPerfilesSelect() {
        try {
            const res = await fetch('/back/permisosPerfil/getPerfiles', { headers: getAuthHeaders() });
            if (res.ok) {
                const perfiles = (await res.json()).data;
                const select = document.getElementById('idPerfil');
                select.innerHTML = '<option value="">-- Seleccione un Perfil --</option>';
                perfiles.forEach(p => { select.innerHTML += '<option value="' + p.id + '">' + p.strNombrePerfil + '</option>'; });
            }
        } catch(e) {}
    }

    async function cargarUsuarios() {
        const headers = getAuthHeaders();
        if (!headers) return;
        let url = '/back/usuario/list?offset=' + offsetActual + '&max=' + LIMITE;
        if (terminoBusquedaActual) url += '&search=' + encodeURIComponent(terminoBusquedaActual);

        try {
            const response = await fetch(url, { headers: headers });
            if (response.ok) {
                const result = await response.json();
                totalRegistros = result.total;
                renderizarTabla(result.data);
                actualizarPaginacion();
            } else {
                const resultError = await response.json().catch(() => ({}));
                toastr.error(resultError.message || 'Error interno en el servidor', 'Error ' + response.status);
            }
        } catch (e) { toastr.error('Error de red al conectar con el servidor', 'Error'); }
    }

    function renderizarTabla(usuarios) {
        const tbody = document.getElementById('tabla-usuarios');
        tbody.innerHTML = '';
        
        if(usuarios.length === 0) { 
            const msg = terminoBusquedaActual ? 'No se encontraron resultados para "' + terminoBusquedaActual + '"' : 'Sin datos registrados';
            tbody.innerHTML = '<tr><td colspan="6" class="p-8 text-center text-gray-500">' + msg + '</td></tr>'; 
            return; 
        }
        
        usuarios.forEach(u => {
            const imgHtml = u.imagenBase64 
                ? '<img src="' + u.imagenBase64 + '" class="h-10 w-10 rounded-full object-cover border mx-auto">' 
                : '<div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-cobalto font-bold mx-auto">' + u.strNombreUsuario.charAt(0).toUpperCase() + '</div>';
            
            const badge = u.idEstadoUsuario === 'ACTIVO' 
                ? '<span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">ACTIVO</span>' 
                : '<span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs font-semibold">INACTIVO</span>';
            
            let btns = '';
            if (misPermisos.editar) btns += '<button onclick="editarUsuario(' + u.id + ')" class="text-blue-600 hover:text-blue-800 text-sm font-medium mr-3">Editar</button>';
            if (misPermisos.eliminar) btns += '<button onclick="eliminarUsuario(' + u.id + ')" class="text-red-600 hover:text-red-800 text-sm font-medium">Eliminar</button>';
            
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-gray-50 transition-colors';
            tr.innerHTML = 
                '<td class="p-4 align-middle">' + imgHtml + '</td>' +
                '<td class="p-4 font-medium text-oxford">' + u.strNombreUsuario + '</td>' +
                '<td class="p-4 text-gray-600">' + u.strCorreo + '</td>' +
                '<td class="p-4 text-gray-600">' + (u.perfil?.strNombrePerfil || '<span class="italic">N/A</span>') + '</td>' +
                '<td class="p-4">' + badge + '</td>' +
                '<td class="p-4 text-right">' + (btns || '<span class="text-gray-400 italic">Sin permisos</span>') + '</td>';
            
            tbody.appendChild(tr);
        });
    }

    function actualizarPaginacion() {
        const spanInfo = document.getElementById('info-paginacion');
        let hasta = Math.min(offsetActual + LIMITE, totalRegistros);
        spanInfo.textContent = 'Mostrando ' + (totalRegistros === 0 ? 0 : offsetActual + 1) + ' a ' + hasta + ' de ' + totalRegistros;
        
        const esUltima = (offsetActual + LIMITE) >= totalRegistros || totalRegistros === 0;
        
        document.getElementById('btn-inicio').disabled = offsetActual === 0;
        document.getElementById('btn-prev').disabled = offsetActual === 0;
        document.getElementById('btn-next').disabled = esUltima;
        document.getElementById('btn-final').disabled = esUltima;
    }

    function cambiarPagina(accion) {
        if (accion === 'inicio') offsetActual = 0;
        else if (accion === 'prev') offsetActual = Math.max(0, offsetActual - LIMITE);
        else if (accion === 'next') offsetActual += LIMITE;
        else if (accion === 'final') offsetActual = Math.max(0, Math.floor((totalRegistros - 1) / LIMITE) * LIMITE);
        cargarUsuarios();
    }

    function abrirModal() { 
        document.getElementById('form-usuario').reset(); 
        document.getElementById('usuario-id').value = ''; 
        document.getElementById('strPwd').required = true;
        document.getElementById('req-pwd').style.display = 'inline';
        document.getElementById('preview-container').classList.add('hidden');
        document.getElementById('img-preview').src = '';
        document.getElementById('modal-titulo').textContent = 'Nuevo Usuario'; 
        document.getElementById('modal-usuario').classList.remove('hidden'); 
    }
    
    function cerrarModal() { document.getElementById('modal-usuario').classList.add('hidden'); }

    function previsualizarImagenSegura(event) {
        const file = event.target.files[0];
        const previewContainer = document.getElementById('preview-container');
        const imgPreview = document.getElementById('img-preview');
        const inputImagen = document.getElementById('imagenPerfil');
        
        if (!file) {
            previewContainer.classList.add('hidden');
            return;
        }

        if (file.size > 2097152) {
            toastr.error('La imagen excede el límite de 2MB.', 'Archivo muy pesado');
            inputImagen.value = '';
            previewContainer.classList.add('hidden');
            return;
        }

        const fileName = file.name.toLowerCase();
        const dotsCount = (fileName.match(/\./g) || []).length;
        if(dotsCount > 1) {
            toastr.error('El nombre del archivo contiene extensiones múltiples prohibidas.', 'Alerta de Seguridad');
            inputImagen.value = '';
            previewContainer.classList.add('hidden');
            return;
        }

        if (file.type !== 'image/jpeg' && file.type !== 'image/png') {
            toastr.error('Solo se permiten archivos JPG o PNG reales.', 'Formato Prohibido');
            inputImagen.value = '';
            previewContainer.classList.add('hidden');
            return;
        }

        const reader = new FileReader();
        reader.onloadend = function(e) {
            const arr = (new Uint8Array(e.target.result)).subarray(0, 4);
            let header = "";
            for(let i = 0; i < arr.length; i++) { header += arr[i].toString(16); }

            const magicNumbers = ['89504e47', 'ffd8ffe0', 'ffd8ffe1', 'ffd8ffe2', 'ffd8ffe3', 'ffd8ffe8'];
            let isValid = false;
            
            for (let x = 0; x < magicNumbers.length; x++) {
                if (header.startsWith(magicNumbers[x])) {
                    isValid = true;
                    break;
                }
            }

            if (!isValid) {
                toastr.error('El archivo está corrupto o es un programa malicioso disfrazado de imagen.', 'Violación de Seguridad');
                inputImagen.value = '';
                previewContainer.classList.add('hidden');
            } else {
                const renderReader = new FileReader();
                renderReader.onload = function(re) {
                    imgPreview.src = re.target.result;
                    previewContainer.classList.remove('hidden');
                }
                renderReader.readAsDataURL(file);
            }
        };
        reader.readAsArrayBuffer(file.slice(0, 4));
    }

    async function guardarUsuario(e) {
        e.preventDefault();
        const headers = getAuthHeaders(true); 
        if (!headers) return;

        const id = document.getElementById('usuario-id').value;
        const nombreUsr = document.getElementById('strNombreUsuario').value.trim();
        const correoUsr = document.getElementById('strCorreo').value.trim();
        const pwdUsr = document.getElementById('strPwd').value.trim();

        if (nombreUsr.length < 4) {
            toastr.warning('El usuario debe tener al menos 4 caracteres reales.', 'Validación Fallida');
            return;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(correoUsr) || correoUsr.endsWith('.sex')) {
            toastr.warning('Ingresa un correo electrónico corporativo válido.', 'Validación Fallida');
            return;
        }

        if (esEntradaPeligrosa(nombreUsr) || esEntradaPeligrosa(correoUsr)) {
            toastr.error('Entrada inválida o detectada como contenido inapropiado.', 'Bloqueo de Seguridad');
            return;
        }

        const formData = new FormData();
        formData.append('strNombreUsuario', sanitizarEntrada(nombreUsr));
        formData.append('strCorreo', sanitizarEntrada(correoUsr));
        formData.append('strNumeroCelular', sanitizarEntrada(document.getElementById('strNumeroCelular').value));
        formData.append('idPerfil', document.getElementById('idPerfil').value);
        formData.append('idEstadoUsuario', document.getElementById('idEstadoUsuario').value);
        
        if (pwdUsr) formData.append('strPwd', pwdUsr);

        const fileInput = document.getElementById('imagenPerfil');
        if (fileInput.files.length > 0) {
            formData.append('imagenPerfil', fileInput.files[0]);
        }

        const btn = document.getElementById('btnGuardar');
        const originalText = btn.innerText;
        btn.innerHTML = 'Guardando...';
        btn.disabled = true;

        const url = id ? '/back/usuario/update/' + id : '/back/usuario/save';
        
        try {
            const res = await fetch(url, { method: 'POST', headers: headers, body: formData });
            const result = await res.json();
            
            if (res.ok && result.success) { 
                cerrarModal(); 
                cargarUsuarios(); 
                toastr.success(result.message, 'Éxito');
            } else { 
                toastr.error(result.message || 'Error al guardar usuario', 'Denegado'); 
            }
        } catch (error) { 
            toastr.error('Fallo de red al enviar formulario', 'Error Crítico'); 
        } finally {
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    }

    async function editarUsuario(id) {
        try {
            const res = await fetch('/back/usuario/show/' + id, { headers: getAuthHeaders() });
            if (res.ok) {
                const data = (await res.json()).data;
                document.getElementById('usuario-id').value = data.id;
                document.getElementById('strNombreUsuario').value = data.strNombreUsuario;
                document.getElementById('strCorreo').value = data.strCorreo;
                document.getElementById('strNumeroCelular').value = data.strNumeroCelular || '';
                document.getElementById('idPerfil').value = data.idPerfil || '';
                document.getElementById('idEstadoUsuario').value = data.idEstadoUsuario;
                
                document.getElementById('strPwd').value = '';
                document.getElementById('strPwd').required = false;
                document.getElementById('req-pwd').style.display = 'none';
                document.getElementById('imagenPerfil').value = ''; 

                if (data.imagenBase64) {
                    document.getElementById('img-preview').src = data.imagenBase64;
                    document.getElementById('preview-container').classList.remove('hidden');
                } else {
                    document.getElementById('preview-container').classList.add('hidden');
                }

                document.getElementById('modal-titulo').textContent = 'Editar Usuario';
                document.getElementById('modal-usuario').classList.remove('hidden');
            } else {
                toastr.warning('No se encontraron los datos de este usuario', 'Atención');
            }
        } catch(error) { toastr.error('Error al cargar detalle del usuario', 'Error'); }
    }

    async function eliminarUsuario(id) {
        if(!confirm('¿Estás seguro de que deseas eliminar este usuario permanentemente?')) return;
        try {
            const res = await fetch('/back/usuario/delete/' + id, { method: 'DELETE', headers: getAuthHeaders() });
            const result = await res.json();
            if(res.ok && result.success) { 
                if (document.getElementById('tabla-usuarios').children.length === 1 && offsetActual > 0) {
                    offsetActual -= LIMITE;
                }
                cargarUsuarios(); 
                toastr.success(result.message, 'Éxito');
            } else { 
                toastr.error(result.message || 'No se pudo eliminar el usuario', 'Denegado'); 
            }
        } catch(error) { toastr.error('Fallo de red al intentar eliminar', 'Error Crítico'); }
    }
</script>
</body>
</html>