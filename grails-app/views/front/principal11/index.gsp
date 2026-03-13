<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Empleados | EMPRESA</title>
</head>
<body>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-6 border-b border-gray-200 flex justify-between items-center bg-gray-50">
        <h2 class="text-xl font-bold text-oxford">Directorio de Empleados (Local)</h2>
        <button id="btn-nuevo" onclick="abrirModal()" class="bg-cobalto hover:bg-blue-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm">
            + Nuevo Empleado
        </button>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-100 text-gray-600 text-sm uppercase tracking-wider">
                    <th class="p-4 border-b">ID Empleado</th>
                    <th class="p-4 border-b">Nombre Completo</th>
                    <th class="p-4 border-b">Departamento</th>
                    <th class="p-4 border-b">Puesto</th>
                    <th class="p-4 border-b text-right">Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-datos" class="text-sm text-gray-700 divide-y divide-gray-100"></tbody>
        </table>
    </div>
</div>

<div id="modal-estatico" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-bold text-oxford" id="modal-titulo">Nuevo Empleado</h3>
            <button onclick="cerrarModal()" class="text-gray-400 hover:text-gray-600">X</button>
        </div>
        <div class="p-6">
            <form id="form-estatico" onsubmit="guardarRegistro(event)">
                <input type="hidden" id="reg-id">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre Completo</label>
                    <input type="text" id="reg-nombre" required class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-cobalto">
                </div>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Departamento</label>
                    <input type="text" id="reg-depto" required class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-cobalto">
                </div>
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Puesto</label>
                    <input type="text" id="reg-puesto" required class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-cobalto">
                </div>
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="cerrarModal()" class="px-4 py-2 border rounded-lg">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-cobalto text-white rounded-lg">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let datos = [
        { id: 101, nombre: 'Ana García', depto: 'Ventas', puesto: 'Gerente Regional' },
        { id: 102, nombre: 'Carlos López', depto: 'TI', puesto: 'Desarrollador Backend' },
        { id: 103, nombre: 'María Rodríguez', depto: 'Recursos Humanos', puesto: 'Reclutadora' }
    ];

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
            document.getElementById('tabla-datos').innerHTML = '<tr><td colspan="5" class="p-4 text-center text-red-500 font-medium">No tiene permisos para consultar datos.</td></tr>';
        }
    });
    // ------------------------------------

    function renderizarTabla() {
        const tbody = document.getElementById('tabla-datos');
        tbody.innerHTML = '';
        datos.forEach(function(d) {
            
            // --- SEGURIDAD: BOTONES DE FILA ---
            let botonesAccion = '';
            if (misPermisos.editar) {
                botonesAccion += '<button onclick="editarRegistro(' + d.id + ')" class="text-blue-600 hover:underline text-sm font-medium mr-2">Editar</button> ';
            }
            if (misPermisos.eliminar) {
                botonesAccion += '<button onclick="eliminarRegistro(' + d.id + ')" class="text-red-600 hover:underline text-sm font-medium">Eliminar</button>';
            }
            if (!misPermisos.editar && !misPermisos.eliminar) {
                botonesAccion = '<span class="text-gray-400 text-xs italic">Sin permisos</span>';
            }

            tbody.innerHTML += '<tr class="hover:bg-gray-50">' +
                '<td class="p-4 font-semibold text-cobalto">EMP-' + d.id + '</td>' +
                '<td class="p-4 font-medium text-oxford">' + d.nombre + '</td>' +
                '<td class="p-4">' + d.depto + '</td>' +
                '<td class="p-4 text-gray-500">' + d.puesto + '</td>' +
                '<td class="p-4 text-right">' + botonesAccion + '</td></tr>';
        });
    }

    function abrirModal() {
        document.getElementById('form-estatico').reset();
        document.getElementById('reg-id').value = '';
        document.getElementById('modal-titulo').textContent = 'Nuevo Empleado';
        document.getElementById('modal-estatico').classList.remove('hidden');
    }

    function cerrarModal() { document.getElementById('modal-estatico').classList.add('hidden'); }

    function guardarRegistro(e) {
        e.preventDefault();
        const id = document.getElementById('reg-id').value;
        const nombre = document.getElementById('reg-nombre').value;
        const depto = document.getElementById('reg-depto').value;
        const puesto = document.getElementById('reg-puesto').value;

        if (id) {
            const obj = datos.find(function(d) { return d.id == id; });
            obj.nombre = nombre; obj.depto = depto; obj.puesto = puesto;
            toastr.success('Empleado actualizado en memoria', 'Éxito');
        } else {
            const nuevoId = datos.length > 0 ? Math.max.apply(null, datos.map(function(d) { return d.id; })) + 1 : 101;
            datos.push({ id: nuevoId, nombre: nombre, depto: depto, puesto: puesto });
            toastr.success('Empleado creado temporalmente', 'Éxito');
        }
        cerrarModal();
        renderizarTabla();
    }

    function editarRegistro(id) {
        const obj = datos.find(function(d) { return d.id == id; });
        document.getElementById('reg-id').value = obj.id;
        document.getElementById('reg-nombre').value = obj.nombre;
        document.getElementById('reg-depto').value = obj.depto;
        document.getElementById('reg-puesto').value = obj.puesto;
        document.getElementById('modal-titulo').textContent = 'Editar Empleado';
        document.getElementById('modal-estatico').classList.remove('hidden');
    }

    function eliminarRegistro(id) {
        if(confirm('¿Eliminar registro estático?')) {
            datos = datos.filter(function(d) { return d.id != id; });
            renderizarTabla();
            toastr.info('Registro borrado de la memoria local', 'Eliminado');
        }
    }
</script>
</body>
</html>