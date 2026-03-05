package terceraunidad.front

class DashboardController {

    static namespace = 'front'

    def index() {
        // Solo renderiza la vista. La seguridad real (JWT) se valida en el frontend
        // y en las futuras llamadas a la API (Backend).
        render(view: 'index')
    }
}