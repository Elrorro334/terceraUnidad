package terceraunidad

class Usuario {
    String strNombreUsuario
    String strPwd
    String idEstadoUsuario = 'ACTIVO' 
    String strCorreo
    String strNumeroCelular
    byte[] imagenPerfil

    Perfil perfil 

    static constraints = {
        strNombreUsuario blank: false, unique: true
        strPwd password: true, blank: false
        idEstadoUsuario inList: ['ACTIVO', 'INACTIVO']
        strCorreo email: true, blank: false
        strNumeroCelular nullable: true, matches: /\d{10}/
        imagenPerfil nullable: true, maxSize: 2 * 1024 * 1024
    }

    static mapping = {
        perfil column: 'idPerfil'
    }
}