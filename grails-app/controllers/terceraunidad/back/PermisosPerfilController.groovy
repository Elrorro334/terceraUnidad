package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.*

class PermisosPerfilController {

    static namespace = 'back'
    static responseFormats = ['json']

    // Devuelve todos los perfiles para llenar el <select>
    def getPerfiles() {
        render([success: true, data: Perfil.list(sort: 'strNombrePerfil')] as JSON)
    }

    // Devuelve la matriz de permisos para un perfil específico
    def getMatriz(Long idPerfil) {
        Perfil perfil = Perfil.get(idPerfil)
        def modulos = Modulo.list(sort: 'id')
        
        def matriz = modulos.collect { mod ->
            PermisosPerfil permiso = PermisosPerfil.findByPerfilAndModulo(perfil, mod)
            return [
                idModulo: mod.id,
                strNombreModulo: mod.strNombreModulo,
                bitAgregar: permiso?.bitAgregar ?: false,
                bitEditar: permiso?.bitEditar ?: false,
                bitConsulta: permiso?.bitConsulta ?: false,
                bitEliminar: permiso?.bitEliminar ?: false,
                bitDetalle: permiso?.bitDetalle ?: false
            ]
        }
        render([success: true, data: matriz] as JSON)
    }

    // AÑADIMOS @Transactional PARA QUE HAGA COMMIT EN LA BD
    @Transactional
    def saveMatriz() {
        def json = request.JSON
        Long idPerfil = json.idPerfil as Long
        Perfil perfil = Perfil.get(idPerfil)

        if (!perfil) {
            render(status: 404, text: [success: false, message: "Perfil no encontrado"] as JSON)
            return
        }

        try {
            // Iteramos el arreglo de módulos que mandó el frontend
            json.permisos.each { row ->
                Modulo mod = Modulo.get(row.idModulo as Long)
                if (mod) {
                    PermisosPerfil permiso = PermisosPerfil.findByPerfilAndModulo(perfil, mod)
                    
                    if (!permiso) {
                        permiso = new PermisosPerfil(perfil: perfil, modulo: mod)
                    }
                    
                    // Asignamos los valores (forzando a false si vienen nulos)
                    permiso.bitAgregar = row.bitAgregar ?: false
                    permiso.bitEditar = row.bitEditar ?: false
                    permiso.bitConsulta = row.bitConsulta ?: false
                    permiso.bitEliminar = row.bitEliminar ?: false
                    permiso.bitDetalle = row.bitDetalle ?: false
                    
                    // failOnError: true lanza una excepción si algo impide el guardado
                    permiso.save(flush: true, failOnError: true)
                }
            }
            render([success: true, message: "Permisos actualizados exitosamente"] as JSON)
            
        } catch (Exception e) {
            log.error("Error guardando matriz de permisos: ${e.message}")
            // Rollback automático gracias a @Transactional
            render(status: 500, text: [success: false, message: "Error interno al guardar los permisos"] as JSON)
        }
    }
}