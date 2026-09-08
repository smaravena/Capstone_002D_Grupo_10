import { Link } from 'react-router-dom'

export default function Unauthorized() {
  return (
    <div className="login-screen">
      <div className="login-card">
        <h1>Acceso no autorizado</h1>
        <p className="subtitle">Tu rol no tiene permiso para ver esta sección.</p>
        <Link to="/pedidos">Volver</Link>
      </div>
    </div>
  )
}
