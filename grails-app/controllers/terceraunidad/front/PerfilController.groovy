package terceraunidad.front

class PerfilController {
    
    static namespace = 'front'

    def index() {
        // Simplemente renderiza la vista grails-app/views/front/perfil/index.gsp
        render view: 'index'
    }
}