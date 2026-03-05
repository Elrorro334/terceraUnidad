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
        // Evita que un perfil tenga permisos duplicados para el mismo módulo
        modulo unique: 'perfil'
    }

    static mapping = {
        // Fuerza el nombre de las llaves foráneas
        modulo column: 'idModulo'
        perfil column: 'idPerfil'
    }
}