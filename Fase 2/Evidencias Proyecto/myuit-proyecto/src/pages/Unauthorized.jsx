import { Link } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import { getHomeRoute } from '../lib/roles'

export default function Unauthorized() {
  const { role } = useAuth()

  return (
    <div className="login-screen">
      <div className="login-card">
        <h1>Acceso no autorizado</h1>
        <p className="subtitle">Tu rol no tiene permiso para ver esta sección.</p>
        <Link to={getHomeRoute(role)}>Volver</Link>
      </div>
    </div>
  )
}
