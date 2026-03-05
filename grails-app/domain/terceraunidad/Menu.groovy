package terceraunidad

class Menu {
    Integer idMenu
    Modulo modulo

    static constraints = {
        idMenu nullable: false
        modulo nullable: false
    }

    static mapping = {
        modulo column: 'idModulo'
    }
}