import { Link, NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import {
  ROLES_MODULO_USUARIOS,
  ROLES_MODULO_CLIENTES,
  ROLES_MODULO_PEDIDOS,
  ROLES_MODULO_MIS_TRABAJOS,
  getHomeRoute,
} from '../lib/roles'
import Logo from './Logo'

export default function Layout() {
  const { usuario, role, signOut } = useAuth()
  const navigate = useNavigate()

  const puedeVerUsuarios =
    ROLES_MODULO_USUARIOS.length === 0 || ROLES_MODULO_USUARIOS.includes(role)
  const puedeVerClientes =
    ROLES_MODULO_CLIENTES.length === 0 || ROLES_MODULO_CLIENTES.includes(role)
  const puedeVerPedidos =
    ROLES_MODULO_PEDIDOS.length === 0 || ROLES_MODULO_PEDIDOS.includes(role)
  const puedeVerMisTrabajos = ROLES_MODULO_MIS_TRABAJOS.includes(role)

  const handleSignOut = async () => {
    await signOut()
    navigate('/login', { replace: true })
  }

  return (
    <div className="app-shell">
      <header className="app-header">
        <Link to={getHomeRoute(role)} className="app-title" title="Ir a la página de inicio">
          <Logo size={44} />
        </Link>
        <nav className="app-nav">
          {puedeVerUsuarios && (
            <NavLink to="/usuarios" className={({ isActive }) => (isActive ? 'active' : '')}>
              Usuarios
            </NavLink>
          )}
          {puedeVerClientes && (
            <NavLink to="/clientes" className={({ isActive }) => (isActive ? 'active' : '')}>
              Clientes
            </NavLink>
          )}
          {puedeVerPedidos && (
            <NavLink to="/pedidos" className={({ isActive }) => (isActive ? 'active' : '')}>
              Pedidos
            </NavLink>
          )}
          {puedeVerMisTrabajos && (
            <NavLink to="/mis-trabajos" className={({ isActive }) => (isActive ? 'active' : '')}>
              Mis trabajos
            </NavLink>
          )}
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
