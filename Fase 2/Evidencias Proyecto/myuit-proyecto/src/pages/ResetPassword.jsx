import { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabaseClient'
import Logo from '../components/Logo'

const MIN_PASSWORD_LENGTH = 6

export default function ResetPassword() {
  const [checkingSession, setCheckingSession] = useState(true)
  const [sessionReady, setSessionReady] = useState(false)

  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [error, setError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [success, setSuccess] = useState(false)

  const navigate = useNavigate()

  useEffect(() => {
    let active = true

    const marcarSesionLista = () => {
      if (!active) return
      setSessionReady(true)
      setCheckingSession(false)
    }

    supabase.auth.getSession().then(({ data }) => {
      if (!active) return
      if (data.session) {
        marcarSesionLista()
      } else {
        setCheckingSession(false)
      }
    })

    const { data: listener } = supabase.auth.onAuthStateChange((event, newSession) => {
      if (!active) return
      if (
        (event === 'PASSWORD_RECOVERY' || event === 'SIGNED_IN') &&
        newSession
      ) {
        marcarSesionLista()
      }
    })

    return () => {
      active = false
      listener.subscription.unsubscribe()
    }
  }, [])

  const vincularUsuario = async () => {
    try {
      const { error } = await supabase.rpc('vincular_usuario_actual')
      if (error) throw error
    } catch (err) {
      // No crítico: si falla, el administrador puede vincular auth_user_id manualmente.
      console.error('No se pudo vincular auth_user_id:', err)
    }
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError(null)

    if (password.length < MIN_PASSWORD_LENGTH) {
      setError(`La contraseña debe tener al menos ${MIN_PASSWORD_LENGTH} caracteres.`)
      return
    }

    if (password !== confirmPassword) {
      setError('Las contraseñas no coinciden.')
      return
    }

    setSubmitting(true)
    try {
      const { error: updateError } = await supabase.auth.updateUser({ password })
      if (updateError) throw updateError

      await vincularUsuario()

      setSuccess(true)
      await supabase.auth.signOut()
    } catch (err) {
      setError(err.message ?? 'No se pudo actualizar la contraseña.')
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
        <h1>Nueva contraseña</h1>

        {checkingSession && <p>Verificando enlace...</p>}

        {!checkingSession && !sessionReady && !success && (
          <>
            <p className="form-error">
              Este enlace no es válido o ya expiró. Solicita uno nuevo desde la pantalla de inicio de sesión.
            </p>
            <Link to="/login">Volver a iniciar sesión</Link>
          </>
        )}

        {sessionReady && !success && (
          <>
            <label htmlFor="new-password">Nueva contraseña</label>
            <input
              id="new-password"
              type="password"
              autoComplete="new-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />

            <label htmlFor="confirm-password">Confirmar contraseña</label>
            <input
              id="confirm-password"
              type="password"
              autoComplete="new-password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
            />

            {error && <p className="form-error">{error}</p>}

            <button type="submit" disabled={submitting}>
              {submitting ? 'Guardando...' : 'Guardar contraseña'}
            </button>
          </>
        )}

        {success && (
          <>
            <p>Tu contraseña se actualizó correctamente. Ya puedes iniciar sesión.</p>
            <button type="button" onClick={() => navigate('/login', { replace: true })}>
              Ir a iniciar sesión
            </button>
          </>
        )}
      </form>
    </div>
  )
}
