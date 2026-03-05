<!doctype html>
<html>
    <head>
        <title>Page Not Found</title>
        <meta name="layout" content="main">
        <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
        
        <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.3/dist/dotlottie-wc.js" type="module"></script>
    </head>
    <body>
        <div id="content" role="main">
            <div class="container text-center mt-5">
                <section class="row justify-content-center">
                    <div class="col-md-8">
                        
                        <div class="d-flex justify-content-center mb-4">
                            <dotlottie-wc 
                                src="https://lottie.host/1b716831-b53e-4347-b3de-c2eaf2e08dd9/ZNoyjKemGC.lottie" 
                                style="width: 300px; height: 300px" 
                                autoplay 
                                loop>
                            </dotlottie-wc>
                        </div>

                        <div class="alert alert-danger shadow-sm" role="alert">
                            <h1>Error: Page Not Found (404)</h1>
                            <div class="mt-2">
                                <i class="bi-exclamation-circle"></i> Path: <strong>${request.forwardURI}</strong>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <a href="${createLink(uri: '/')}" class="btn btn-outline-secondary">Return to Home</a>
                        </div>
                        
                    </div>
                </section>
            </div>
        </div>
    </body>
</html>