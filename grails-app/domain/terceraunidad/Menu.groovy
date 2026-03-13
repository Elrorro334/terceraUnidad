package terceraunidad

class Menu {
    Integer idMenu
    Modulo modulo
    String strNombreMenu

    static constraints = {
        idMenu nullable: false
        modulo nullable: false
        strNombreMenu blank: false, maxSize: 50
    }

    static mapping = {
        modulo column: 'idModulo'
    }
}