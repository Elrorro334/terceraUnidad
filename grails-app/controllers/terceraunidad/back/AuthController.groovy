package terceraunidad.back

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import terceraunidad.Usuario
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import java.security.Key
import groovy.json.JsonSlurper
import org.springframework.beans.factory.annotation.Autowired

// Importaciones nativas de Spring Boot para correo
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import jakarta.mail.internet.MimeMessage

class AuthController {
    
    static namespace = 'back'
    static responseFormats = ['json']

    @Autowired
    JavaMailSender javaMailSender

    private static final Key SECRET_KEY = Keys.hmacShaKeyFor("Rodnix_Platf0rm_S3cr3t_K3y_2026_JWT_Auth_Super_Safe".getBytes('UTF-8'))
    private static final String RECAPTCHA_SECRET = "6LdG8oAsAAAAAKoWaX52ga0Gi-YXI1zXoHk53pjK" 

    def login() {
        def data = request.JSON
        String username = data?.username
        String password = data?.password
        String recaptchaToken = data?.recaptchaToken

        if (!username || !password) {
            render([success: false, message: "Usuario y contraseña son requeridos"] as JSON, status: 400)
            return
        }
        
        if (!recaptchaToken) {
            render([success: false, message: "La verificación reCAPTCHA es obligatoria"] as JSON, status: 400)
            return
        }

        boolean isHuman = verifyRecaptcha(recaptchaToken)
        if (!isHuman) {
            render([success: false, message: "Error de conexión o seguridad (reCAPTCHA). Revisa tu internet."] as JSON, status: 401)
            return
        }

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

    @Transactional
    def recuperarContrasena() {
        def data = request.JSON
        String correo = data?.correo?.trim()

        if (!correo) {
            render([success: false, message: "El correo es requerido"] as JSON, status: 400)
            return
        }

        Usuario usuario = Usuario.findByStrCorreo(correo)

        if (!usuario) {
            render([success: false, message: "No existe ninguna cuenta asociada a este correo."] as JSON, status: 404)
            return
        }

        try {
            // 1. Generamos un JWT de recuperación válido solo por 15 minutos
            String tokenRecuperacion = Jwts.builder()
                .setSubject(usuario.strCorreo)
                .claim("idUsuario", usuario.id)
                .claim("tipo", "RECOVERY")
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 900000)) // 15 mins en milisegundos
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact()

            // 2. Construimos la URL dinámica hacia la nueva vista
            String baseUrl = request.scheme + "://" + request.serverName + ":" + request.serverPort
            String enlaceReset = "${baseUrl}/front/auth/resetPassword?token=${tokenRecuperacion}"

            // 3. Enviamos el correo con diseño corporativo
            MimeMessage message = javaMailSender.createMimeMessage()
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8")
            
            helper.setFrom("sanxcruro122@gmail.com") 
            helper.setTo(correo)
            helper.setSubject("Restablecer Contraseña | Empresa Platform")
            
            String htmlContent = """
                <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8fafc; padding: 40px 20px; text-align: center;">
                    <div style="max-width: 500px; margin: 0 auto; background-color: #ffffff; padding: 40px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); text-align: left;">
                        <div style="text-align: center; margin-bottom: 30px;">
                            <h1 style="color: #1E3A8A; margin: 0; font-size: 26px; font-weight: 800;">Empresa Platform</h1>
                            <p style="color: #64748b; font-size: 14px; margin-top: 5px;">Seguridad de la Cuenta</p>
                        </div>
                        <h2 style="color: #334155; font-size: 18px; margin-bottom: 15px;">Hola, <strong>${usuario.strNombreUsuario}</strong></h2>
                        <p style="color: #475569; line-height: 1.6; font-size: 15px;">Hemos recibido una solicitud para restablecer la contraseña de tu cuenta. Para continuar con el proceso, haz clic en el botón de abajo.</p>
                        <div style="text-align: center; margin: 35px 0;">
                            <a href="${enlaceReset}" style="background-color: #1E3A8A; color: #ffffff; padding: 14px 32px; text-decoration: none; border-radius: 8px; font-weight: bold; font-size: 15px; display: inline-block;">Restablecer mi Contraseña</a>
                        </div>
                        <p style="color: #ef4444; font-size: 13px; text-align: center;"><em>Este enlace expirará en 15 minutos por tu seguridad.</em></p>
                        <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 30px 0 20px;">
                        <p style="font-size: 12px; color: #94a3b8; text-align: center;">Si no solicitaste este cambio, puedes ignorar este correo de forma segura. Tu cuenta no será modificada.</p>
                    </div>
                </div>
            """
            
            helper.setText(htmlContent, true)
            javaMailSender.send(message)

            render([success: true, message: "Se ha enviado un enlace de recuperación a tu correo."] as JSON)

        } catch (Exception e) {
            log.error("Error enviando correo de recuperación: ${e.message}")
            render([success: false, message: "Ocurrió un error al enviar el correo. Intente más tarde."] as JSON, status: 500)
        }
    }

    @Transactional
    def doResetPassword() {
        def data = request.JSON
        String token = data?.token
        String nuevaContrasena = data?.password

        if (!token || !nuevaContrasena) {
            render([success: false, message: "Faltan datos para completar la operación"] as JSON, status: 400)
            return
        }

        try {
            // Validamos que el token sea nuestro, no esté expirado y sea tipo RECOVERY
            def claims = Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody()

            if (claims.get("tipo") != "RECOVERY") {
                render([success: false, message: "Token inválido para esta operación."] as JSON, status: 403)
                return
            }

            Long idUsuario = claims.get("idUsuario", Long.class)
            Usuario usuario = Usuario.get(idUsuario)

            if (!usuario) {
                render([success: false, message: "El usuario asociado al token ya no existe."] as JSON, status: 404)
                return
            }

            // Aplicamos la nueva contraseña
            usuario.strPwd = nuevaContrasena
            usuario.save(flush: true, failOnError: true)

            render([success: true, message: "Contraseña actualizada exitosamente. Ya puedes iniciar sesión."] as JSON)

        } catch (io.jsonwebtoken.ExpiredJwtException e) {
            render([success: false, message: "El enlace ha expirado. Por favor, solicita uno nuevo."] as JSON, status: 401)
        } catch (Exception e) {
            log.error("Intento de manipulación de token de reseteo: ${e.message}")
            render([success: false, message: "El enlace de seguridad es inválido o está corrupto."] as JSON, status: 400)
        }
    }

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
            // Este error salta si no hay internet o el firewall bloquea Java
            log.error("Fallo de red al validar reCAPTCHA: ${e.message}")
            return false
        }
    }
}