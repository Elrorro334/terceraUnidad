package terceraunidad

class UrlMappings {

    static mappings = {
        
        group("/front") {
            "/$controller/$action?/$id?(.$format)?"(namespace: 'front')
        }

        group("/back") {
            "/$controller/$action?/$id?(.$format)?"(namespace: 'back')
            
            parseRequest: true 
        }

        "/"(controller: 'auth', action: 'login', namespace: 'front')
        
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}