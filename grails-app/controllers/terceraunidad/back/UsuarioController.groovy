package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.Usuario
import terceraunidad.Perfil
import org.springframework.web.multipart.MultipartFile
import javax.imageio.ImageIO
import java.io.ByteArrayInputStream

class UsuarioController {

    static namespace = 'back'
    static responseFormats = ['json']

    def list() {
        try {
            int maxItems = params.int('max') ?: 5
            int offsetItems = params.int('offset') ?: 0
            String search = params.search?.trim() ?: null

            def criteria = Usuario.createCriteria()
            def resultados = criteria.list(max: maxItems, offset: offsetItems) {
                // CORRECCIÓN 1: Usamos 'join' en lugar de 'createAlias' para prevenir el N+1 
                // sin alterar la estructura de la entidad de retorno.
                join 'perfil'
                
                if (search) {
                    or {
                        ilike('strNombreUsuario', "%${search}%")
                        ilike('strCorreo', "%${search}%")
                    }
                }
                order('id', 'desc')
            }
            
            def data = resultados.collect { u ->
                // CORRECCIÓN 2: Generamos el Base64 como un String nativo estricto para no romper el convertidor JSON
                String imgBase64 = null
                if (u.imagenPerfil) {
                    imgBase64 = "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(u.imagenPerfil)
                }

                return [
                    id: u.id,
                    strNombreUsuario: u.strNombreUsuario,
                    strCorreo: u.strCorreo,
                    strNumeroCelular: u.strNumeroCelular,
                    idEstadoUsuario: u.idEstadoUsuario,
                    perfil: [
                        id: u.perfil?.id, 
                        strNombrePerfil: u.perfil?.strNombrePerfil
                    ],
                    imagenBase64: imgBase64
                ]
            }
            
            render([success: true, data: data, total: resultados.totalCount] as JSON)
            
        } catch (Exception e) {
            log.error("Error al listar usuarios: ${e.message}", e)
            render(status: 500, text: [success: false, message: "Error interno del servidor al procesar los datos"] as JSON)
        }
    }

    def show(Long id) {
        Usuario u = Usuario.get(id)
        if (!u) {
            render(status: 404, text: [success: false, message: "Usuario no encontrado"] as JSON)
            return
        }
        def data = [
            id: u.id,
            strNombreUsuario: u.strNombreUsuario,
            strCorreo: u.strCorreo,
            strNumeroCelular: u.strNumeroCelular,
            idEstadoUsuario: u.idEstadoUsuario,
            idPerfil: u.perfil?.id,
            imagenBase64: u.imagenPerfil ? "data:image/jpeg;base64,${u.imagenPerfil.encodeBase64()}" : null
        ]
        render([success: true, data: data] as JSON)
    }

    // --- FUNCIÓN PRIVADA DE SEGURIDAD PARA ARCHIVOS ---
    private boolean esImagenValida(MultipartFile archivo) {
        if (!archivo || archivo.empty) return true

        if (archivo.size > 2097152) return false

        def validMimeTypes = ['image/jpeg', 'image/png', 'image/jpg']
        if (!validMimeTypes.contains(archivo.contentType)) return false

        def filename = archivo.originalFilename?.toLowerCase()
        if (!filename || (!filename.endsWith('.jpg') && !filename.endsWith('.jpeg') && !filename.endsWith('.png'))) return false

        try {
            def image = ImageIO.read(new ByteArrayInputStream(archivo.bytes))
            if (image == null) return false 
        } catch (Exception e) {
            return false 
        }

        return true
    }
    // ----------------------------------------------------

    @Transactional
    def save() {
        try {
            Perfil perfil = Perfil.get(params.long('idPerfil'))
            if(!perfil) {
                render(status: 400, text: [success: false, message: "Perfil seleccionado inválido"] as JSON)
                return
            }

            MultipartFile archivoImagen = request.getFile('imagenPerfil')
            
            if (archivoImagen && !archivoImagen.empty && !esImagenValida(archivoImagen)) {
                render(status: 400, text: [success: false, message: "El archivo subido no es una imagen válida o excede los 2MB."] as JSON)
                return
            }

            Usuario usuario = new Usuario(
                strNombreUsuario: params.strNombreUsuario?.trim(),
                strPwd: params.strPwd?.trim(),
                strCorreo: params.strCorreo?.trim(),
                strNumeroCelular: params.strNumeroCelular?.trim(),
                idEstadoUsuario: params.idEstadoUsuario ?: 'ACTIVO',
                perfil: perfil
            )

            if (archivoImagen && !archivoImagen.empty) {
                usuario.imagenPerfil = archivoImagen.bytes
            }

            usuario.save(flush: true, failOnError: true)
            render([success: true, message: "Usuario creado exitosamente"] as JSON)
            
        } catch (Exception e) {
            log.error("Error al guardar usuario: ${e.message}", e)
            render(status: 400, text: [success: false, message: "Error de validación: Verifique que el usuario o correo no estén duplicados."] as JSON)
        }
    }

    @Transactional
    def update(Long id) {
        try {
            Usuario usuario = Usuario.get(id)
            if (!usuario) {
                render(status: 404, text: [success: false, message: "Usuario no encontrado"] as JSON)
                return
            }

            MultipartFile archivoImagen = request.getFile('imagenPerfil')
            
            if (archivoImagen && !archivoImagen.empty && !esImagenValida(archivoImagen)) {
                render(status: 400, text: [success: false, message: "El archivo subido no es una imagen válida o excede los 2MB."] as JSON)
                return
            }

            Perfil perfil = Perfil.get(params.long('idPerfil'))
            if (perfil) usuario.perfil = perfil
            
            usuario.strNombreUsuario = params.strNombreUsuario?.trim()
            usuario.strCorreo = params.strCorreo?.trim()
            usuario.strNumeroCelular = params.strNumeroCelular?.trim()
            usuario.idEstadoUsuario = params.idEstadoUsuario ?: 'ACTIVO'

            if (params.strPwd && params.strPwd.trim() != "") {
                usuario.strPwd = params.strPwd.trim()
            }

            if (archivoImagen && !archivoImagen.empty) {
                usuario.imagenPerfil = archivoImagen.bytes
            }

            usuario.save(flush: true, failOnError: true)
            render([success: true, message: "Usuario actualizado exitosamente"] as JSON)
            
        } catch (Exception e) {
            log.error("Error al actualizar usuario: ${e.message}", e)
            render(status: 400, text: [success: false, message: "Error al actualizar los datos del usuario."] as JSON)
        }
    }

    @Transactional
    def delete(Long id) {
        try {
            Usuario usuario = Usuario.get(id)
            if (!usuario) {
                render(status: 404, text: [success: false, message: "Usuario no encontrado"] as JSON)
                return
            }
            usuario.delete(flush: true, failOnError: true)
            render([success: true, message: "Usuario eliminado permanentemente"] as JSON)
        } catch (Exception e) {
            log.error("Error al eliminar usuario: ${e.message}", e)
            render(status: 409, text: [success: false, message: "Hubo un error al intentar eliminar el usuario."] as JSON)
        }
    }
}