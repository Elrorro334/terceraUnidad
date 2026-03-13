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
            int maxItems = 5
            int offsetItems = params.int('offset') ?: 0
            def usuarios = Usuario.list(max: maxItems, offset: offsetItems, sort: 'id', order: 'desc')
            
            def data = usuarios.collect { u ->
                [
                    id: u.id,
                    strNombreUsuario: u.strNombreUsuario,
                    strCorreo: u.strCorreo,
                    strNumeroCelular: u.strNumeroCelular,
                    idEstadoUsuario: u.idEstadoUsuario,
                    perfil: [id: u.perfil?.id, strNombrePerfil: u.perfil?.strNombrePerfil],
                    imagenBase64: u.imagenPerfil ? "data:image/jpeg;base64,${u.imagenPerfil.encodeBase64()}" : null
                ]
            }
            render([success: true, data: data, total: Usuario.count()] as JSON)
        } catch (Exception e) {
            log.error("Error al listar usuarios: ${e.message}")
            render(status: 500, text: [success: false, message: "Error interno del servidor"] as JSON)
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
        if (!archivo || archivo.empty) return true // Es opcional, así que si no hay archivo, pasa la validación.

        // 1. Validar tamaño en el servidor (Ej: 2MB = 2097152 bytes)
        if (archivo.size > 2097152) return false

        // 2. Validar tipo MIME reportado
        def validMimeTypes = ['image/jpeg', 'image/png', 'image/jpg']
        if (!validMimeTypes.contains(archivo.contentType)) return false

        // 3. Validar extensión del archivo
        def filename = archivo.originalFilename?.toLowerCase()
        if (!filename || (!filename.endsWith('.jpg') && !filename.endsWith('.jpeg') && !filename.endsWith('.png'))) return false

        // 4. DEEP SCAN: Intentar leer los bytes como imagen real (Previene ejecutables disfrazados .exe.png)
        try {
            def image = ImageIO.read(new ByteArrayInputStream(archivo.bytes))
            if (image == null) return false // No es una imagen decodificable
        } catch (Exception e) {
            return false // Falló al intentar procesar la imagen
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
            
            // Validamos seguridad del archivo antes de armar el objeto
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
            log.error("Error al guardar usuario: ${e.message}")
            render(status: 400, text: [success: false, message: "Error de validación: Verifique que el usuario no esté duplicado."] as JSON)
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
            
            // Validación estricta del archivo
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
            log.error("Error al actualizar usuario: ${e.message}")
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
            log.error("Error al eliminar usuario: ${e.message}")
            render(status: 409, text: [success: false, message: "Hubo un error al intentar eliminar el usuario."] as JSON)
        }
    }
}