package terceraunidad

import grails.gorm.transactions.Transactional

@Transactional(readOnly = true)
class MenuService {

    List<Map> obtenerMenuDinamico(Long idUsuario) {
        if (!idUsuario) return []

        // Añadimos los campos bit a la consulta SELECT
        def resultados = Menu.executeQuery("""
            SELECT m.idMenu, m.strNombreMenu, mod.strNombreModulo, 
                   pp.bitAgregar, pp.bitEditar, pp.bitEliminar, pp.bitConsulta, pp.bitDetalle
            FROM Menu m
            INNER JOIN m.modulo mod
            INNER JOIN PermisosPerfil pp ON pp.modulo = mod
            INNER JOIN Usuario u ON u.perfil = pp.perfil
            WHERE u.id = :idUsuario
            AND (pp.bitConsulta = true OR pp.bitAgregar = true OR pp.bitEditar = true OR pp.bitEliminar = true OR pp.bitDetalle = true)
            ORDER BY m.idMenu, mod.id
        """, [idUsuario: idUsuario])

        Map<Integer, Map> menuAgrupado = [:]
        
        resultados.each { fila ->
            Integer idMenu = fila[0] as Integer
            String nombreMenuPadre = fila[1] as String
            String nombreModulo = fila[2] as String
            
            if (!menuAgrupado.containsKey(idMenu)) {
                menuAgrupado[idMenu] = [nombre: nombreMenuPadre, modulos: []]
            }
            
            // Guardamos los permisos por cada módulo
            menuAgrupado[idMenu].modulos.add([
                nombre: nombreModulo,
                permisos: [
                    agregar: fila[3] ?: false,
                    editar: fila[4] ?: false,
                    eliminar: fila[5] ?: false,
                    consulta: fila[6] ?: false,
                    detalle: fila[7] ?: false
                ]
            ])
        }

        return menuAgrupado.collect { key, valorMap ->
            [
                idMenu: key,
                nombreMenuPadre: valorMap.nombre,
                modulos: valorMap.modulos.collect { mod ->
                    [
                        nombre: mod.nombre,
                        url: "/front/${mod.nombre.toLowerCase().replaceAll('[ .-]', '')}/index",
                        permisos: mod.permisos
                    ]
                }
            ]
        }
    }
}