package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.*
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys

class PermisosPerfilController {

    static namespace = 'back'
    static responseFormats = ['json']

    private static final String SECRET_KEY = "Rodnix_Platf0rm_S3cr3t_K3y_2026_JWT_Auth_Super_Safe"

    def beforeInterceptor = [action: this.&verificarPrivilegiosAdmin]

    private boolean verificarPrivilegiosAdmin() {
        try {
            String header = request.getHeader("Authorization")
            if (!header || !header.startsWith("Bearer ")) {
                render(status: 401, text: [success: false, message: "No autorizado: Token ausente"] as JSON)
                return false
            }

            String token = header.substring(7)
            def key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes("UTF-8"))

            def claims = Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody()

            Boolean isAdmin = claims.get("admin", Boolean.class)

            if (!isAdmin) {
                render(status: 403, text: [success: false, message: "Acceso denegado: Se requieren privilegios de Administrador"] as JSON)
                return false
            }

            return true
            
        } catch (Exception e) {
            log.error("Violación de seguridad o token inválido en PermisosPerfilController: ${e.message}")
            render(status: 401, text: [success: false, message: "Sesión inválida o expirada"] as JSON)
            return false
        }
    }

    def getPerfiles() {
        try {
            def perfiles = Perfil.list(sort: 'strNombrePerfil').collect { p ->
                [id: p.id, strNombrePerfil: p.strNombrePerfil]
            }
            render([success: true, data: perfiles] as JSON)
        } catch (Exception e) {
            render(status: 500, text: [success: false, message: "Error al cargar perfiles"] as JSON)
        }
    }

    def getMatriz(Long idPerfil) {
        Perfil perfil = Perfil.get(idPerfil)
        if (!perfil) {
            render(status: 404, text: [success: false, message: "Perfil no encontrado"] as JSON)
            return
        }

        try {
            def modulos = Modulo.list(sort: 'strNombreModulo')
            
            def permisosExistentes = PermisosPerfil.findAllByPerfil(perfil)
            def permisosMap = permisosExistentes.collectEntries { [(it.modulo.id): it] }
            
            def matriz = modulos.collect { mod ->
                PermisosPerfil permiso = permisosMap[mod.id]
                [
                    idModulo: mod.id,
                    strNombreModulo: mod.strNombreModulo,
                    bitConsulta: permiso?.bitConsulta ?: false,
                    bitAgregar: permiso?.bitAgregar ?: false,
                    bitEditar: permiso?.bitEditar ?: false,
                    bitEliminar: permiso?.bitEliminar ?: false,
                    bitDetalle: permiso?.bitDetalle ?: false
                ]
            }
            render([success: true, data: matriz] as JSON)
        } catch (Exception e) {
            log.error("Error cargando matriz", e)
            render(status: 500, text: [success: false, message: "Error interno al procesar la matriz"] as JSON)
        }
    }

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
            def permisosExistentes = PermisosPerfil.findAllByPerfil(perfil).collectEntries { [(it.modulo.id): it] }

            json.permisos.each { row ->
                Long modId = row.idModulo as Long
                Modulo mod = Modulo.load(modId) 
                
                if (mod) {
                    PermisosPerfil permiso = permisosExistentes[modId] ?: new PermisosPerfil(perfil: perfil, modulo: mod)
                    
                    permiso.bitConsulta = row.bitConsulta ?: false
                    permiso.bitAgregar = row.bitAgregar ?: false
                    permiso.bitEditar = row.bitEditar ?: false
                    permiso.bitEliminar = row.bitEliminar ?: false
                    permiso.bitDetalle = row.bitDetalle ?: false
                    
                    permiso.save(failOnError: true)
                }
            }
            render([success: true, message: "Permisos actualizados exitosamente"] as JSON)
            
        } catch (Exception e) {
            log.error("Error guardando matriz de permisos: ${e.message}", e)
            render(status: 500, text: [success: false, message: "Error interno al guardar los permisos"] as JSON)
        }
    }
}