package terceraunidad.front

class AuthController {
    
    static namespace = 'front'

    def login() {
        render(view: 'login')
    }

    def resetPassword() {
        render(view: 'resetPassword')
    }
}