package terceraunidad

class Modulo {
    String strNombreModulo

    static constraints = {
        strNombreModulo blank: false, unique: true
    }
}