document.addEventListener('DOMContentLoaded', () => {
    const navContainer = document.getElementById('menu-dinamico-container');
    if (navContainer) {
        cargarMenuDesdeBackend();
    }
    // Renderizar breadcrumbs inmediatamente en la carga de página
    renderizarBreadcrumbDOM(); 
});

async function cargarMenuDesdeBackend() {
    // Asumo que guardas tu token aquí tras el login exitoso
    const token = localStorage.getItem('rodnix_jwt'); 
    
    if (!token) {
        window.location.href = '/front/auth/login';
        return;
    }

    try {
        const response = await fetch('/back/menu/obtener', {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Accept': 'application/json'
            }
        });

        if (response.ok) {
            const data = await response.json();
            construirMenuDOM(data);
        } else {
            // Si el token falló, redireccionar al login [cite: 24]
            localStorage.removeItem('rodnix_jwt');
            window.location.href = '/front/auth/login';
        }
    } catch (error) {
        console.error('Error de red al cargar el menú:', error);
    }
}

function construirMenuDOM(menus) {
    const navContainer = document.getElementById('menu-dinamico-container');
    navContainer.innerHTML = ''; 

    const ulPrincipal = document.createElement('ul');
    ulPrincipal.className = 'flex space-x-1';

    menus.forEach(menuPadre => {
        const liPadre = document.createElement('li');
        liPadre.className = 'relative group px-4 py-3 hover:bg-[#102a43] cursor-pointer transition-colors z-50';

        const spanPadre = document.createElement('span');
        spanPadre.className = 'flex items-center text-white';
        spanPadre.innerHTML = `${menuPadre.nombreMenuPadre} 
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>`;
        
        const ulSubmenu = document.createElement('ul');
        ulSubmenu.className = 'absolute left-0 top-full mt-0 hidden group-hover:block bg-[#173a5e] min-w-[200px] shadow-lg border-t border-blue-800';

        menuPadre.modulos.forEach(modulo => {
            const liHijo = document.createElement('li');
            const aHijo = document.createElement('a');
            aHijo.href = modulo.url;
            aHijo.className = 'block px-6 py-3 hover:bg-[#244b7a] text-white transition-colors whitespace-nowrap';
            aHijo.textContent = modulo.nombre;
            
            // Guardar para el Breadcrumb al navegar
            aHijo.addEventListener('click', () => {
                sessionStorage.setItem('bc_padre', menuPadre.nombreMenuPadre);
                sessionStorage.setItem('bc_hijo', modulo.nombre);
            });

            liHijo.appendChild(aHijo);
            ulSubmenu.appendChild(liHijo);
        });

        liPadre.appendChild(spanPadre);
        liPadre.appendChild(ulSubmenu);
        ulPrincipal.appendChild(liPadre);
    });

    navContainer.appendChild(ulPrincipal);
}

function renderizarBreadcrumbDOM() {
    const breadcrumbContainer = document.getElementById('breadcrumb-container');
    if (!breadcrumbContainer) return;

    const padre = sessionStorage.getItem('bc_padre');
    const hijo = sessionStorage.getItem('bc_hijo');

    if (padre && hijo) {
        breadcrumbContainer.innerHTML = `
            <nav class="flex text-sm text-gray-500 mb-6 bg-gray-100 p-3 rounded-lg w-full">
              <ol class="inline-flex items-center space-x-2">
                <li><span class="text-gray-600 font-medium">${padre}</span></li>
                <li>
                  <div class="flex items-center">
                    <svg class="w-4 h-4 text-gray-400 mx-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path></svg>
                    <span class="text-blue-800 font-bold">${hijo}</span>
                  </div>
                </li>
              </ol>
            </nav>
        `;
    }
}