import { useState } from 'react'
import { Link, NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import {
  ROLES,
  ROLES_MODULO_USUARIOS,
  ROLES_MODULO_CLIENTES,
  ROLES_MODULO_PEDIDOS,
  ROLES_MODULO_MIS_TRABAJOS,
  ROLES_MODULO_PRECIOS,
  ROLES_MODULO_SERVICIOS,
} from '../lib/roles'
import Logo from './Logo'

export default function Layout() {
  const { usuario, role, signOut } = useAuth()
  const navigate = useNavigate()
  const { pathname } = useLocation()
  const [menuAbierto, setMenuAbierto] = useState(false)
  const [rutaMenu, setRutaMenu] = useState(pathname)

  // Cierra el menú móvil al cambiar de página
  if (rutaMenu !== pathname) {
    setRutaMenu(pathname)
    setMenuAbierto(false)
  }

  const puedeVerUsuarios =
    ROLES_MODULO_USUARIOS.length === 0 || ROLES_MODULO_USUARIOS.includes(role)
  const puedeVerClientes =
    ROLES_MODULO_CLIENTES.length === 0 || ROLES_MODULO_CLIENTES.includes(role)
  const puedeVerPedidos =
    ROLES_MODULO_PEDIDOS.length === 0 || ROLES_MODULO_PEDIDOS.includes(role)
  const puedeVerMisTrabajos = ROLES_MODULO_MIS_TRABAJOS.includes(role)
  const puedeVerPrecios =
    ROLES_MODULO_PRECIOS.length === 0 || ROLES_MODULO_PRECIOS.includes(role)
  const puedeVerServicios =
    ROLES_MODULO_SERVICIOS.length === 0 || ROLES_MODULO_SERVICIOS.includes(role)

  const handleSignOut = async () => {
    await signOut()
    navigate('/login', { replace: true })
  }

  return (
    <div className="app-shell">
      <header className={`app-header ${menuAbierto ? 'menu-open' : ''}`}>
        <Link to="/" className="app-title" title="Ir a la página de inicio">
          <Logo size={44} />
        </Link>
        <button
          type="button"
          className="menu-toggle"
          aria-label={menuAbierto ? 'Cerrar menú' : 'Abrir menú'}
          aria-expanded={menuAbierto}
          onClick={() => setMenuAbierto((v) => !v)}
        >
          <span />
          <span />
          <span />
        </button>
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
          {puedeVerServicios && (
            <NavLink to="/servicios" className={({ isActive }) => (isActive ? 'active' : '')}>
              Servicios
            </NavLink>
          )}
          {puedeVerMisTrabajos && (
            <NavLink to="/mis-trabajos" className={({ isActive }) => (isActive ? 'active' : '')}>
              {role === ROLES.JEFA_TALLER ? 'Trabajos' : 'Mis trabajos'}
            </NavLink>
          )}
          {puedeVerPrecios && (
            <NavLink to="/precios" className={({ isActive }) => (isActive ? 'active' : '')}>
              Precios
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
