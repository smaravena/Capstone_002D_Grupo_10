import { useState } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import Logo from '../components/Logo'

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

export default function Login() {
  const { signIn, isAuthenticated, loading } = useAuth()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  const [showForgotModal, setShowForgotModal] = useState(false)
  const [forgotEmail, setForgotEmail] = useState('')
  const [forgotSent, setForgotSent] = useState(false)

  const navigate = useNavigate()
  const location = useLocation()
  const from = location.state?.from?.pathname ?? '/usuarios'

  if (!loading && isAuthenticated) {
    return <Navigate to={from} replace />
  }

  const validate = () => {
    if (!email.trim()) return 'Ingresa tu correo electrónico.'
    if (!EMAIL_REGEX.test(email.trim())) return 'Ingresa un correo electrónico válido.'
    if (!password) return 'Ingresa tu contraseña.'
    return null
  }

  const handleSubmit = async (event) => {
    event.preventDefault()

    const validationError = validate()
    if (validationError) {
      setError(validationError)
      return
    }

    setError(null)
    setSubmitting(true)
    try {
      await signIn(email, password)
      navigate(from, { replace: true })
    } catch (err) {
      setError('Correo o contraseña incorrectos.')
      console.error(err)
    } finally {
      setSubmitting(false)
    }
  }

  const abrirModalOlvido = () => {
    setForgotEmail(email)
    setForgotSent(false)
    setShowForgotModal(true)
  }

  const cerrarModalOlvido = () => {
    setShowForgotModal(false)
  }

  const handleForgotSubmit = (event) => {
    event.preventDefault()
    // Por el momento no se envía ningún correo, solo se muestra la confirmación.
    setForgotSent(true)
  }

  return (
    <div className="login-screen">
      <form className="login-card" onSubmit={handleSubmit} noValidate>
        <Link to="/" className="login-brand">
          <Logo size={80} />
        </Link>
        <h1>Iniciar sesión</h1>

        <label htmlFor="email">Correo electrónico</label>
        <input
          id="email"
          type="email"
          autoComplete="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <label htmlFor="password">Contraseña</label>
        <input
          id="password"
          type="password"
          autoComplete="current-password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />

        <button type="button" className="forgot-password" onClick={abrirModalOlvido}>
          ¿Olvidaste tu contraseña?
        </button>

        {error && <p className="form-error">{error}</p>}

        <button type="submit" disabled={submitting}>
          {submitting ? 'Ingresando...' : 'Ingresar'}
        </button>
      </form>

      {showForgotModal && (
        <div className="modal-overlay" onClick={cerrarModalOlvido}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Recuperar contraseña</h2>

            {forgotSent ? (
              <>
                <p>Si el correo ingresado existe, recibirás instrucciones para recuperar tu contraseña.</p>
                <div className="modal-actions">
                  <button type="button" onClick={cerrarModalOlvido}>
                    Cerrar
                  </button>
                </div>
              </>
            ) : (
              <form className="usuario-form" onSubmit={handleForgotSubmit} noValidate>
                <label htmlFor="forgot-email">Correo electrónico</label>
                <input
                  id="forgot-email"
                  type="email"
                  autoComplete="email"
                  value={forgotEmail}
                  onChange={(e) => setForgotEmail(e.target.value)}
                />
                <div className="modal-actions">
                  <button type="button" className="btn-secondary" onClick={cerrarModalOlvido}>
                    Cancelar
                  </button>
                  <button type="submit">Enviar</button>
                </div>
              </form>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
