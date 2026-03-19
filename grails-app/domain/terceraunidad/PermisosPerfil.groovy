package terceraunidad

class PermisosPerfil {
    Boolean bitAgregar = false
    Boolean bitEditar = false
    Boolean bitConsulta = false
    Boolean bitEliminar = false
    Boolean bitDetalle = false

    Modulo modulo
    Perfil perfil

    static constraints = {
        modulo unique: 'perfil'
    }

    static mapping = {
        modulo column: 'idModulo'
        perfil column: 'idPerfil'
    }
}