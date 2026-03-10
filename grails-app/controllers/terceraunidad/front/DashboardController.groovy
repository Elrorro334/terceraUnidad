package terceraunidad.front

class DashboardController {

    static namespace = 'front'

    def index() {
        render(view: 'index')
    }

    def probarError() {
        throw new RuntimeException("Error de prueba")
    }
}