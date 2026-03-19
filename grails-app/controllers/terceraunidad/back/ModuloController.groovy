package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.Modulo
import terceraunidad.Menu
import terceraunidad.PermisosPerfil

class ModuloController {

    static namespace = 'back'
    static responseFormats = ['json']

    def getGruposMenu() {
        def grupos = Menu.executeQuery("SELECT DISTINCT m.idMenu, m.strNombreMenu FROM Menu m ORDER BY m.idMenu")
        def data = grupos.collect { [ idMenu: it[0], strNombreMenu: it[1] ] }
        render([success: true, data: data] as JSON)
    }

    def list() {
        try {
            int maxItems = params.int('max') ?: 5
            int offsetItems = params.int('offset') ?: 0
            String search = params.search?.trim() ?: null

            def criteria = Modulo.createCriteria()
            def resultados = criteria.list(max: maxItems, offset: offsetItems) {
                if (search) {
                    ilike('strNombreModulo', "%${search}%")
                }
                order('id', 'desc')
            }
            
            // Extraemos los menús solo para los módulos obtenidos en esta página (Mejora de performance)
            def menusMap = [:]
            if (!resultados.isEmpty()) {
                def menus = Menu.withCriteria {
                    'in'('modulo', resultados)
                }
                menus.each { mn ->
                    menusMap[mn.modulo.id] = mn
                }
            }
            
            def data = resultados.collect { m ->
                def menuRelacionado = menusMap[m.id]
                [
                    id: m.id,
                    strNombreModulo: m.strNombreModulo,
                    menuAsignado: menuRelacionado?.strNombreMenu ?: 'Sin asignar',
                    idMenu: menuRelacionado?.idMenu
                ]
            }
            
            render([success: true, data: data, total: resultados.totalCount] as JSON)
        } catch (Exception e) {
            // Imprimimos la traza real en la consola para no debuguear a ciegas en el futuro
            e.printStackTrace()
            render(status: 500, text: [success: false, message: "Error interno del servidor al listar"] as JSON)
        }
    }

    def show(Long id) {
        Modulo modulo = Modulo.get(id)
        if (!modulo) {
            render(status: 404, text: [success: false] as JSON)
            return
        }
        Menu menu = Menu.findByModulo(modulo)
        render([success: true, data: [id: modulo.id, strNombreModulo: modulo.strNombreModulo, idMenu: menu?.idMenu]] as JSON)
    }

    @Transactional
    def save() {
        def json = request.JSON
        Modulo modulo = new Modulo(strNombreModulo: json.strNombreModulo?.trim())

        if (!modulo.save(flush: true, failOnError: true)) {
            render(status: 400, text: [success: false, message: "Error al guardar o nombre duplicado"] as JSON)
            return
        }

        if (json.strNombreMenu) {
            Integer targetIdMenu = json.idMenu ? (json.idMenu as Integer) : null
            
            // Si es un menú nuevo, calculamos el ID más alto y le sumamos 1
            if (!targetIdMenu) {
                def maxId = Menu.createCriteria().get { projections { max('idMenu') } } as Integer
                targetIdMenu = (maxId ?: 0) + 1
            }

            Menu menu = new Menu(idMenu: targetIdMenu, strNombreMenu: json.strNombreMenu.trim(), modulo: modulo)
            menu.save(flush: true, failOnError: true)
        }

        render([success: true, message: "Módulo guardado exitosamente"] as JSON)
    }

    @Transactional
    def update(Long id) {
        def json = request.JSON
        Modulo modulo = Modulo.get(id)
        if (!modulo) {
            render(status: 404, text: [success: false] as JSON)
            return
        }
        
        modulo.strNombreModulo = json.strNombreModulo?.trim()
        modulo.save(flush: true, failOnError: true)

        Menu menu = Menu.findByModulo(modulo)
        
        if (json.strNombreMenu) {
            Integer targetIdMenu = json.idMenu ? (json.idMenu as Integer) : null
            if (!targetIdMenu) {
                def maxId = Menu.createCriteria().get { projections { max('idMenu') } } as Integer
                targetIdMenu = (maxId ?: 0) + 1
            }

            if (menu) {
                menu.idMenu = targetIdMenu
                menu.strNombreMenu = json.strNombreMenu.trim()
                menu.save(flush: true, failOnError: true)
            } else {
                menu = new Menu(idMenu: targetIdMenu, strNombreMenu: json.strNombreMenu.trim(), modulo: modulo)
                menu.save(flush: true, failOnError: true)
            }
        } else if (menu) {
            menu.delete(flush: true)
        }

        render([success: true, message: "Módulo actualizado exitosamente"] as JSON)
    }

    @Transactional
    def delete(Long id) {
        try {
            Modulo modulo = Modulo.get(id)
            if (modulo) {
                Menu.executeUpdate("DELETE FROM Menu m WHERE m.modulo = :mod", [mod: modulo])
                PermisosPerfil.executeUpdate("DELETE FROM PermisosPerfil p WHERE p.modulo = :mod", [mod: modulo])
                modulo.delete(flush: true, failOnError: true)
            }
            render([success: true, message: "Módulo eliminado permanentemente"] as JSON)
        } catch (Exception e) {
            render(status: 409, text: [success: false, message: "Error al eliminar el módulo"] as JSON)
        }
    }
}