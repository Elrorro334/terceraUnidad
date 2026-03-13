package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.Perfil

class PerfilController {

    static namespace = 'back'
    static responseFormats = ['json']

    def list() {
        try {
            int maxItems = 5
            int offsetItems = params.int('offset') ?: 0
            
            def perfilesList = Perfil.list(max: maxItems, offset: offsetItems, sort: 'id', order: 'desc')
            def totalCount = Perfil.count()
            
            render([success: true, data: perfilesList, total: totalCount] as JSON)
        } catch (Exception e) {
            log.error("Error al listar perfiles: ${e.message}")
            render(status: 500, text: [success: false, message: "Error interno del servidor"] as JSON)
        }
    }

    def show(Long id) {
        Perfil perfil = Perfil.get(id)
        if (!perfil) {
            render(status: 404, text: [success: false, message: "Perfil no encontrado"] as JSON)
            return
        }
        render([success: true, data: perfil] as JSON)
    }

    @Transactional
    def save() {
        def json = request.JSON
        Perfil perfil = new Perfil(
            strNombrePerfil: json.strNombrePerfil?.trim(),
            bitAdministrador: json.bitAdministrador ? true : false
        )

        try {
            perfil.save(flush: true, failOnError: true)
            render([success: true, message: "Perfil creado exitosamente"] as JSON)
        } catch (Exception e) {
            render(status: 400, text: [success: false, message: "El nombre del perfil ya existe o es inválido"] as JSON)
        }
    }

    @Transactional
    def update(Long id) {
        Perfil perfil = Perfil.get(id)
        if (!perfil) {
            render(status: 404, text: [success: false, message: "Perfil no encontrado"] as JSON)
            return
        }

        def json = request.JSON
        perfil.strNombrePerfil = json.strNombrePerfil?.trim()
        perfil.bitAdministrador = json.bitAdministrador ? true : false

        try {
            perfil.save(flush: true, failOnError: true)
            render([success: true, message: "Perfil actualizado exitosamente"] as JSON)
        } catch (Exception e) {
            render(status: 400, text: [success: false, message: "Error al actualizar (Nombre duplicado o inválido)"] as JSON)
        }
    }

    @Transactional
    def delete(Long id) {
        Perfil perfil = Perfil.get(id)
        if (!perfil) {
            render(status: 404, text: [success: false, message: "Perfil no encontrado"] as JSON)
            return
        }

        try {
            perfil.delete(flush: true, failOnError: true)
            render([success: true, message: "Perfil eliminado exitosamente"] as JSON)
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            render(status: 409, text: [success: false, message: "No se puede eliminar porque está en uso por otros registros (Ej. Usuarios o Permisos)"] as JSON)
        }
    }
}