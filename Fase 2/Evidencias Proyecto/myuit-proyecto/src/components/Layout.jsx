import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import Logo from './Logo'

export default function Layout() {
  const { usuario, role, signOut } = useAuth()
  const navigate = useNavigate()

  const handleSignOut = async () => {
    await signOut()
    navigate('/login', { replace: true })
  }

  return (
    <div className="app-shell">
      <header className="app-header">
        <span className="app-title">
          <Logo size={44} />
        </span>
        <nav className="app-nav">
          <NavLink to="/usuarios" className={({ isActive }) => (isActive ? 'active' : '')}>
            Usuarios
          </NavLink>
          <NavLink to="/pedidos" className={({ isActive }) => (isActive ? 'active' : '')}>
            Pedidos
          </NavLink>
        </nav>
        <div className="app-user">
          <span>
            {usuario ? `${usuario.nom_usuario} ${usuario.ape_usuario}` : 'Usuario'}
            {role ? ` · ${role}` : ''}
          </span>
          <button type="button" onClick={handleSignOut}>
            Cerrar sesión
          </button>
        </div>
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  )
}
