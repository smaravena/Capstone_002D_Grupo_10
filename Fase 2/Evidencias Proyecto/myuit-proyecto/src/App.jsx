import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext'
import ProtectedRoute from './components/ProtectedRoute'
import Layout from './components/Layout'
import Landing from './pages/Landing'
import Login from './pages/Login'
import ResetPassword from './pages/ResetPassword'
import EstablecerPassword from './pages/EstablecerPassword'
import Unauthorized from './pages/Unauthorized'
import Pedidos from './pages/Pedidos'
import Usuarios from './pages/Usuarios'
import Clientes from './pages/Clientes'
import MisTrabajos from './pages/MisTrabajos'
import Precios from './pages/Precios'
import {
  ROLES_MODULO_PEDIDOS,
  ROLES_MODULO_USUARIOS,
  ROLES_MODULO_CLIENTES,
  ROLES_MODULO_MIS_TRABAJOS,
  ROLES_MODULO_PRECIOS,
} from './lib/roles'
import './App.css'

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Landing />} />
          <Route path="/login" element={<Login />} />
          <Route path="/reset-password" element={<ResetPassword />} />
          <Route path="/establecer-password" element={<EstablecerPassword />} />
          <Route path="/no-autorizado" element={<Unauthorized />} />

          <Route
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route
              path="/usuarios"
              element={
                <ProtectedRoute allowedRoles={ROLES_MODULO_USUARIOS}>
                  <Usuarios />
                </ProtectedRoute>
              }
            />
            <Route
              path="/pedidos"
              element={
                <ProtectedRoute allowedRoles={ROLES_MODULO_PEDIDOS}>
                  <Pedidos />
                </ProtectedRoute>
              }
            />
            <Route
              path="/clientes"
              element={
                <ProtectedRoute allowedRoles={ROLES_MODULO_CLIENTES}>
                  <Clientes />
                </ProtectedRoute>
              }
            />
            <Route
              path="/mis-trabajos"
              element={
                <ProtectedRoute allowedRoles={ROLES_MODULO_MIS_TRABAJOS}>
                  <MisTrabajos />
                </ProtectedRoute>
              }
            />
            <Route
              path="/precios"
              element={
                <ProtectedRoute allowedRoles={ROLES_MODULO_PRECIOS}>
                  <Precios />
                </ProtectedRoute>
              }
            />
          </Route>

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
