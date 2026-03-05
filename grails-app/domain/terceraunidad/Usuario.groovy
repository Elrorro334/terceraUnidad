package terceraunidad

class Usuario {
    String strNombreUsuario
    String strPwd
    String idEstadoUsuario = 'ACTIVO' 
    String strCorreo
    String strNumeroCelular
    byte[] imagenPerfil // Campo para guardar la imagen del usuario

    Perfil perfil 

    static constraints = {
        strNombreUsuario blank: false, unique: true
        strPwd password: true, blank: false
        idEstadoUsuario inList: ['ACTIVO', 'INACTIVO']
        strCorreo email: true, blank: false
        strNumeroCelular nullable: true, matches: /\d{10}/
        imagenPerfil nullable: true, maxSize: 2 * 1024 * 1024 // Límite de 2MB
    }

    static mapping = {
        // Fuerza a que la columna en la BD se llame idPerfil como pide el documento
        perfil column: 'idPerfil'
    }
}