export const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

export const MIN_LARGO_TEXTO = 2
export const MIN_LARGO_PASSWORD = 6
export const MAX_DIGITOS_PRECIO = 9

const capitalizar = (texto) => texto.charAt(0).toUpperCase() + texto.slice(1)

// Cada validador devuelve un mensaje de error, o null si el valor es válido.
// `campo` va con artículo y en minúscula, ej: 'el nombre', 'la talla'.

export const validarRequerido = (valor, campo) => (String(valor ?? '').trim() ? null : `Falta ${campo}.`)

export const validarTexto = (valor, campo) => {
  const texto = String(valor ?? '').trim()
  if (!texto) return `Falta ${campo}.`
  if (texto.length < MIN_LARGO_TEXTO) {
    return `${capitalizar(campo)} debe tener al menos ${MIN_LARGO_TEXTO} caracteres.`
  }
  return null
}

export const validarCorreo = (valor, { obligatorio = true } = {}) => {
  const correo = String(valor ?? '').trim()
  if (!correo) return obligatorio ? 'Falta el correo electrónico.' : null
  if (!EMAIL_REGEX.test(correo)) return 'El correo electrónico no es válido.'
  return null
}

// `conMinimo: false` solo exige que no esté vacía (ej: al iniciar sesión con una cuenta existente).
export const validarPassword = (valor, { conMinimo = true } = {}) => {
  if (!valor) return 'Falta la contraseña.'
  if (conMinimo && valor.length < MIN_LARGO_PASSWORD) {
    return `La contraseña debe tener al menos ${MIN_LARGO_PASSWORD} caracteres.`
  }
  return null
}

export const validarConfirmacion = (password, confirmacion) => {
  if (!confirmacion) return 'Confirma la contraseña.'
  if (password !== confirmacion) return 'Las contraseñas no coinciden.'
  return null
}

export const validarPrecio = (valor) => {
  const precio = String(valor ?? '').trim()
  if (!precio) return 'Falta el precio.'
  if (!/^\d+$/.test(precio)) return 'El precio debe ser un número entero, sin puntos ni símbolos.'
  if (precio.length > MAX_DIGITOS_PRECIO) {
    return `El precio no puede tener más de ${MAX_DIGITOS_PRECIO} dígitos.`
  }
  if (Number(precio) <= 0) return 'El precio debe ser mayor a 0.'
  return null
}

export const validarCantidad = (valor) => {
  const cantidad = String(valor ?? '').trim()
  if (!cantidad) return 'Falta la cantidad de prendas.'
  if (!/^\d+$/.test(cantidad) || Number(cantidad) <= 0) {
    return 'La cantidad de prendas debe ser un número entero mayor a 0.'
  }
  return null
}

// Deja solo dígitos y corta al máximo permitido; para usar en onChange de inputs de precio.
export const limpiarPrecio = (valor) => valor.replace(/\D/g, '').slice(0, MAX_DIGITOS_PRECIO)

// Celular chileno: el prefijo se muestra fijo y el usuario solo escribe los 8 dígitos restantes.
export const PREFIJO_CELULAR = '+56 9'
export const DIGITOS_CELULAR = 8

export const limpiarCelular = (valor) => valor.replace(/\D/g, '').slice(0, DIGITOS_CELULAR)

// Arma el valor que se guarda en la BD: solo "9" + los 8 dígitos (9 caracteres,
// el límite de la columna num_cli). El prefijo "+56 " es solo visual, no se guarda.
export const construirCelular = (digitos) => `9${digitos}`

// Convierte un teléfono guardado (ej: '+56 912345678') a los dígitos que van después de "+56 9".
export const extraerCelular = (telefono) => {
  const digitos = String(telefono ?? '').replace(/\D/g, '')
  if (digitos.startsWith('569')) return digitos.slice(3, 3 + DIGITOS_CELULAR)
  if (digitos.startsWith('9') && digitos.length === DIGITOS_CELULAR + 1) return digitos.slice(1)
  return digitos.slice(-DIGITOS_CELULAR)
}

export const validarCelular = (digitos) => {
  const valor = String(digitos ?? '').trim()
  if (!valor) return 'Falta el teléfono.'
  if (valor.length !== DIGITOS_CELULAR) {
    return `El teléfono debe tener ${DIGITOS_CELULAR} dígitos después de ${PREFIJO_CELULAR}.`
  }
  return null
}

// Recibe { campo: mensaje | null } y deja solo los campos con error.
export const soloErrores = (errores) => Object.fromEntries(Object.entries(errores).filter(([, msg]) => msg))
