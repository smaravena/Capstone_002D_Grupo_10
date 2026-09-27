import { useState } from 'react'

// Validación por campo: `validar(valores)` devuelve { campo: mensaje }.
// Un error se muestra cuando el campo ya fue editado o cuando se intentó enviar el formulario.
export function useValidacion(validar, valores) {
  const [tocados, setTocados] = useState({})
  const [intentoEnvio, setIntentoEnvio] = useState(false)

  const errores = validar(valores)

  const errorDe = (campo) => (intentoEnvio || tocados[campo] ? errores[campo] : undefined)

  const tocar = (campo) => setTocados((prev) => (prev[campo] ? prev : { ...prev, [campo]: true }))

  // Marca el intento de envío y devuelve true si no hay errores.
  const validarEnvio = () => {
    setIntentoEnvio(true)
    return Object.keys(errores).length === 0
  }

  const reiniciar = () => {
    setTocados({})
    setIntentoEnvio(false)
  }

  return { errorDe, tocar, validarEnvio, reiniciar }
}
