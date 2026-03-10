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

        "/"(view: "/index")
        
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}