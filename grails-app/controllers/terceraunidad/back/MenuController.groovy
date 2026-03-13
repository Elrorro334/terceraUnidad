package terceraunidad.back

import grails.converters.JSON
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys
import java.security.Key
import terceraunidad.MenuService

class MenuController {

    static namespace = 'back'
    static responseFormats = ['json']

    MenuService menuService
    
    private static final Key SECRET_KEY = Keys.hmacShaKeyFor("Rodnix_Platf0rm_S3cr3t_K3y_2026_JWT_Auth_Super_Safe".getBytes('UTF-8'))

    def obtener() {
        String authHeader = request.getHeader("Authorization")
        
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            render status: 401, text: 'Token no proporcionado o inválido'
            return
        }

        try {
            String token = authHeader.substring(7)
            
            def claims = Jwts.parserBuilder()
                             .setSigningKey(SECRET_KEY)
                             .build()
                             .parseClaimsJws(token)
                             .getBody()

            Long idUsuario = claims.get("idUsuario", Long.class)

            List<Map> menu = menuService.obtenerMenuDinamico(idUsuario)
            render menu as JSON

        } catch (Exception e) {
            log.error "Error procesando JWT en el menú: ${e.message}"
            render status: 401, text: 'Token expirado o corrupto'
        }
    }
}