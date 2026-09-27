import { useState } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabaseClient'
import Logo from '../components/Logo'
import FieldError from '../components/FieldError'
import { useValidacion } from '../hooks/useValidacion'
import { soloErrores, validarConfirmacion, validarPassword } from '../lib/validators'

const validarNuevaPassword = ({ password, confirmPassword }) =>
  soloErrores({
    password: validarPassword(password),
    confirmPassword: validarConfirmacion(password, confirmPassword),
  })

export default function EstablecerPassword() {
  const location = useLocation()
  const navigate = useNavigate()

  const correo = location.state?.correo ?? new URLSearchParams(location.search).get('correo') ?? ''

  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [error, setError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [success, setSuccess] = useState(false)
  const { errorDe, tocar, validarEnvio } = useValidacion(validarNuevaPassword, { password, confirmPassword })

  if (!correo) {
    return <Navigate to="/login" replace />
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError(null)
    if (!validarEnvio()) return

    setSubmitting(true)
    try {
      const { error: rpcError } = await supabase.rpc('establecer_password_inicial', {
        p_correo: correo,
        p_password: password,
      })
      if (rpcError) throw rpcError

      setSuccess(true)
    } catch (err) {
      setError(err.message ?? 'No se pudo establecer la contraseña.')
      console.error(err)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="login-screen">
      <form className="login-card" onSubmit={handleSubmit} noValidate>
        <Link to="/" className="login-brand">
          <Logo size={80} />
        </Link>
        <h1>Establecer contraseña</h1>

        {!success && (
          <>
            <p className="subtitle">
              Este es tu primer inicio de sesión con <strong>{correo}</strong>. Crea una contraseña para
              continuar.
            </p>

            <label htmlFor="new-password">Nueva contraseña</label>
            <input
              id="new-password"
              type="password"
              autoComplete="new-password"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value)
                tocar('password')
              }}
              aria-invalid={Boolean(errorDe('password'))}
            />
            <FieldError mensaje={errorDe('password')} />

            <label htmlFor="confirm-password">Confirmar contraseña</label>
            <input
              id="confirm-password"
              type="password"
              autoComplete="new-password"
              value={confirmPassword}
              onChange={(e) => {
                setConfirmPassword(e.target.value)
                tocar('confirmPassword')
              }}
              aria-invalid={Boolean(errorDe('confirmPassword'))}
            />
            <FieldError mensaje={errorDe('confirmPassword')} />

            {error && <p className="form-error">{error}</p>}

            <button type="submit" disabled={submitting}>
              {submitting ? 'Guardando...' : 'Guardar contraseña'}
            </button>
          </>
        )}

        {success && (
          <>
            <p>Tu contraseña se estableció correctamente. Ya puedes iniciar sesión.</p>
            <button type="button" onClick={() => navigate('/login', { replace: true })}>
              Ir a iniciar sesión
            </button>
          </>
        )}
      </form>
    </div>
  )
}
