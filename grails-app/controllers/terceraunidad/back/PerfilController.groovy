package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.Perfil

class PerfilController {

    static namespace = 'back'
    static responseFormats = ['json']

    def list() {
        try {
            int maxItems = params.int('max') ?: 5
            int offsetItems = params.int('offset') ?: 0
            String search = params.search?.trim() ?: null

            def criteria = Perfil.createCriteria()
            def resultados = criteria.list(max: maxItems, offset: offsetItems) {
                if (search) {
                    ilike('strNombrePerfil', "%${search}%")
                }
                order('id', 'desc')
            }
            
            def data = resultados.collect { p ->
                [
                    id: p.id,
                    strNombrePerfil: p.strNombrePerfil,
                    bitAdministrador: p.bitAdministrador
                ]
            }
            
            render([success: true, data: data, total: resultados.totalCount] as JSON)
        } catch (Exception e) {
            log.error("Error al listar perfiles: ${e.message}", e)
            render(status: 500, text: [success: false, message: "Error interno del servidor al listar"] as JSON)
        }
    }

    def show(Long id) {
        Perfil perfil = Perfil.get(id)
        if (!perfil) {
            render(status: 404, text: [success: false, message: "Perfil no encontrado"] as JSON)
            return
        }
        
        render([success: true, data: [id: perfil.id, strNombrePerfil: perfil.strNombrePerfil, bitAdministrador: perfil.bitAdministrador]] as JSON)
    }

    @Transactional
    def save() {
        def json = request.JSON
        Perfil perfil = new Perfil(
            strNombrePerfil: json.strNombrePerfil?.trim(),
            bitAdministrador: false // Forzado a 0 (false)
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
        perfil.bitAdministrador = false // Forzado a 0 (false)

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
            render(status: 409, text: [success: false, message: "No se puede eliminar porque está en uso por otros registros"] as JSON)
        } catch (Exception e) {
            render(status: 500, text: [success: false, message: "Error interno al intentar eliminar"] as JSON)
        }
    }
}