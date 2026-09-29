// URL pública a la que apuntan los enlaces de los correos (invitación y recuperación de contraseña).
// Se fija con VITE_SITE_URL para que un correo enviado mientras se trabaja en localhost
// igual lleve al sitio desplegado.
export const SITE_URL = (import.meta.env.VITE_SITE_URL || window.location.origin).replace(/\/+$/, '')
