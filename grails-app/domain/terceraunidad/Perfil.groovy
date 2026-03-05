package terceraunidad

class Perfil {
    String strNombrePerfil
    Boolean bitAdministrador = false

    static constraints = {
        strNombrePerfil blank: false, unique: true, maxSize: 50
    }
}