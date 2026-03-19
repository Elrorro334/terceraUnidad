<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Inventario | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 flex flex-col md:flex-row justify-between items-center bg-gray-50 gap-4">
        <h2 class="text-xl font-bold text-oxford">Control de Inventario (Local)</h2>
        
        <div class="flex flex-col sm:flex-row w-full md:w-auto space-y-3 sm:space-y-0 sm:space-x-3 items-center">
            <div class="flex w-full sm:w-80 relative">
                <input type="text" id="input-busqueda" placeholder="Buscar producto o SKU..." 
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
                + Nuevo Producto
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-100 text-gray-600 text-sm uppercase tracking-wider">
                    <th class="p-4 border-b">SKU</th>
                    <th class="p-4 border-b">Producto</th>
                    <th class="p-4 border-b">Stock</th>
                    <th class="p-4 border-b">Precio Unitario</th>
                    <th class="p-4 border-b text-right">Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-datos" class="text-sm text-gray-700 divide-y divide-gray-100"></tbody>
        </table>
    </div>
</div>

<div id="modal-estatico" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all">
        <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-bold text-oxford" id="modal-titulo">Nuevo Producto</h3>
            <button onclick="cerrarModal()" class="text-gray-400 hover:text-gray-600 focus:outline-none">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>
        <div class="p-6">
            <form id="form-estatico" onsubmit="guardarRegistro(event)">
                <input type="hidden" id="reg-id">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Producto <span class="text-red-500">*</span></label>
                    <input type="text" id="reg-nombre" required class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                </div>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Stock Disponible <span class="text-red-500">*</span></label>
                    <input type="number" id="reg-stock" required min="0" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                </div>
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Precio ($) <span class="text-red-500">*</span></label>
                    <input type="number" id="reg-precio" required step="0.01" min="0" class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-cobalto">
                </div>
                <div class="flex justify-end space-x-3 border-t border-gray-200 pt-4">
                    <button type="button" onclick="cerrarModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-cobalto hover:bg-blue-800 text-white rounded-lg shadow-sm text-sm font-medium transition-colors">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let datos = [
        { id: 5001, nombre: 'Laptop ThinkPad T14', stock: 15, precio: 24500.00 },
        { id: 5002, nombre: 'Monitor Dell 27"', stock: 42, precio: 6200.50 },
        { id: 5003, nombre: 'Teclado Mecánico Keychron', stock: 8, precio: 1850.00 }
    ];

    let terminoBusquedaActual = '';

    if(typeof toastr !== 'undefined') { toastr.options = { "escapeHtml": true }; }

    // --- SEGURIDAD: LÓGICA DE PERMISOS ---
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
            renderizarTabla();
        } else {
            document.getElementById('tabla-datos').innerHTML = '<tr><td colspan="5" class="p-8 text-center text-red-500 font-medium">No tiene permisos para consultar datos.</td></tr>';
        }
    });
    // ------------------------------------

    // --- FUNCIONES DE BÚSQUEDA LOCAL ---
    function sanitizarEntrada(texto) { return texto ? texto.replace(/[<>'"=;]/g, '').trim() : ''; }

    function toggleBotonLimpiar() {
        const input = document.getElementById('input-busqueda');
        const btn = document.getElementById('btn-clear-input');
        if (input.value.length > 0) btn.classList.remove('hidden');
        else btn.classList.add('hidden');
    }

    function limpiarBusqueda() {
        document.getElementById('input-busqueda').value = '';
        terminoBusquedaActual = '';
        toggleBotonLimpiar();
        renderizarTabla();
    }

    function ejecutarBusquedaEnter(event) { if (event.key === "Enter") ejecutarBusqueda(); }

    function ejecutarBusqueda() {
        const inputVal = document.getElementById('input-busqueda').value;
        terminoBusquedaActual = sanitizarEntrada(inputVal).toLowerCase();
        
        const btnLimpiar = document.getElementById('btn-clear-input');
        if (terminoBusquedaActual !== '') btnLimpiar.classList.remove('hidden');
        else btnLimpiar.classList.add('hidden');
        
        renderizarTabla();
    }
    // ------------------------------------

    function renderizarTabla() {
        const tbody = document.getElementById('tabla-datos');
        tbody.innerHTML = '';
        
        // Filtrado local en base al término de búsqueda
        let datosFiltrados = datos;
        if (terminoBusquedaActual) {
            datosFiltrados = datos.filter(function(d) {
                return d.nombre.toLowerCase().includes(terminoBusquedaActual) ||
                       d.id.toString().includes(terminoBusquedaActual);
            });
        }

        if (datosFiltrados.length === 0) {
            const msg = terminoBusquedaActual ? 'No se encontraron resultados para "' + terminoBusquedaActual + '"' : 'Sin datos registrados';
            tbody.innerHTML = '<tr><td colspan="5" class="p-8 text-center text-gray-500">' + msg + '</td></tr>';
            return;
        }

        datosFiltrados.forEach(function(d) {
            const badgeClass = d.stock < 10 ? 'bg-red-100 text-red-800 border-red-200' : 'bg-green-100 text-green-800 border-green-200';

            // --- SEGURIDAD: BOTONES DE FILA ---
            let botonesAccion = '';
            if (misPermisos.editar) {
                botonesAccion += '<button onclick="editarRegistro(' + d.id + ')" class="text-blue-600 hover:text-blue-800 text-sm font-medium mr-3 transition-colors">Editar</button> ';
            }
            if (misPermisos.eliminar) {
                botonesAccion += '<button onclick="eliminarRegistro(' + d.id + ')" class="text-red-600 hover:text-red-800 text-sm font-medium transition-colors">Eliminar</button>';
            }
            if (!misPermisos.editar && !misPermisos.eliminar) {
                botonesAccion = '<span class="text-gray-400 text-xs italic">Sin permisos</span>';
            }

            tbody.innerHTML += '<tr class="hover:bg-gray-50 transition-colors">' +
                '<td class="p-4 font-semibold text-gray-500">SKU-' + d.id + '</td>' +
                '<td class="p-4 font-medium text-oxford">' + d.nombre + '</td>' +
                '<td class="p-4"><span class="px-2 py-1 rounded-full text-xs font-semibold border ' + badgeClass + '">' + d.stock + ' u.</span></td>' +
                '<td class="p-4">$' + parseFloat(d.precio).toFixed(2) + '</td>' +
                '<td class="p-4 text-right">' + botonesAccion + '</td></tr>';
        });
    }

    function abrirModal() {
        document.getElementById('form-estatico').reset();
        document.getElementById('reg-id').value = '';
        document.getElementById('modal-titulo').textContent = 'Nuevo Producto';
        document.getElementById('modal-estatico').classList.remove('hidden');
    }

    function cerrarModal() { document.getElementById('modal-estatico').classList.add('hidden'); }

    function guardarRegistro(e) {
        e.preventDefault();
        const id = document.getElementById('reg-id').value;
        const nombre = sanitizarEntrada(document.getElementById('reg-nombre').value);
        const stock = document.getElementById('reg-stock').value;
        const precio = document.getElementById('reg-precio').value;

        if (id) {
            const obj = datos.find(function(d) { return d.id == id; });
            if (obj) {
                obj.nombre = nombre; 
                obj.stock = parseInt(stock); 
                obj.precio = parseFloat(precio);
                if(typeof toastr !== 'undefined') toastr.success('Producto actualizado en memoria', 'Éxito');
            }
        } else {
            const nuevoId = datos.length > 0 ? Math.max.apply(null, datos.map(function(d) { return d.id; })) + 1 : 5001;
            datos.push({ id: nuevoId, nombre: nombre, stock: parseInt(stock), precio: parseFloat(precio) });
            if(typeof toastr !== 'undefined') toastr.success('Producto creado temporalmente', 'Éxito');
        }
        cerrarModal();
        renderizarTabla();
    }

    function editarRegistro(id) {
        const obj = datos.find(function(d) { return d.id == id; });
        if (obj) {
            document.getElementById('reg-id').value = obj.id;
            document.getElementById('reg-nombre').value = obj.nombre;
            document.getElementById('reg-stock').value = obj.stock;
            document.getElementById('reg-precio').value = obj.precio;
            document.getElementById('modal-titulo').textContent = 'Editar Producto';
            document.getElementById('modal-estatico').classList.remove('hidden');
        }
    }

    function eliminarRegistro(id) {
        if(confirm('¿Eliminar producto del inventario estático?')) {
            datos = datos.filter(function(d) { return d.id != id; });
            renderizarTabla();
            if(typeof toastr !== 'undefined') toastr.info('Producto borrado de la memoria local', 'Eliminado');
        }
    }
</script>
</body>
</html>