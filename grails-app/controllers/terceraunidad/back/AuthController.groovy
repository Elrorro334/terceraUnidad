package terceraunidad.back

import grails.converters.JSON
import terceraunidad.Usuario
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import java.security.Key
import groovy.json.JsonSlurper

class AuthController {
    
    static namespace = 'back'
    static responseFormats = ['json']

    private static final Key SECRET_KEY = Keys.hmacShaKeyFor("Rodnix_Platf0rm_S3cr3t_K3y_2026_JWT_Auth_Super_Safe".getBytes('UTF-8'))
    
    private static final String RECAPTCHA_SECRET = "6LdG8oAsAAAAAKoWaX52ga0Gi-YXI1zXoHk53pjK" 

    def login() {
        def data = request.JSON
        String username = data?.username
        String password = data?.password
        String recaptchaToken = data?.recaptchaToken

        // 1. Validaciones de inputs vacíos
        if (!username || !password) {
            render([success: false, message: "Usuario y contraseña son requeridos"] as JSON, status: 400)
            return
        }
        
        if (!recaptchaToken) {
            render([success: false, message: "La verificación reCAPTCHA es obligatoria"] as JSON, status: 400)
            return
        }

        // 2. Validación REAL contra la API de Google reCAPTCHA
        boolean isHuman = verifyRecaptcha(recaptchaToken)
        if (!isHuman) {
            render([success: false, message: "Verificación de seguridad fallida. Intenta nuevamente."] as JSON, status: 401)
            return
        }

        // 3. Lógica de Base de Datos (Solo llega aquí si es un humano real)
        Usuario usuario = Usuario.findByStrNombreUsuario(username)

        if (!usuario) {
            render([success: false, message: "El usuario no existe"] as JSON, status: 404)
            return
        }

        if (usuario.idEstadoUsuario != 'ACTIVO') {
            render([success: false, message: "El estado del usuario es inactivo"] as JSON, status: 403)
            return
        }

        if (usuario.strPwd != password) {
            render([success: false, message: "La contraseña es incorrecta"] as JSON, status: 401)
            return
        }

        // 4. Generación del JWT
        String token = Jwts.builder()
                .setSubject(usuario.strNombreUsuario)
                .claim("idUsuario", usuario.id)
                .claim("perfil", usuario.perfil.strNombrePerfil)
                .claim("admin", usuario.perfil.bitAdministrador)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 3600000)) // 1 hora
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact()

        render([
            success: true,
            token: token,
            redirectUrl: "/front/dashboard/index"
        ] as JSON)
    }

    /**
     * Se conecta por HTTP POST a Google para validar el token
     */
    private boolean verifyRecaptcha(String userToken) {
        try {
            String url = "https://www.google.com/recaptcha/api/siteverify"
            String postParameters = "secret=${RECAPTCHA_SECRET}&response=${userToken}"

            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection()
            connection.setRequestMethod("POST")
            connection.setDoOutput(true)
            
            connection.outputStream.withWriter("UTF-8") { writer ->
                writer.write(postParameters)
            }

            def responseJson = new JsonSlurper().parseText(connection.inputStream.text)
            
            return responseJson.success == true
            
        } catch (Exception e) {
            log.error("Error validando reCAPTCHA: ${e.message}")
            return false
        }
    }
}