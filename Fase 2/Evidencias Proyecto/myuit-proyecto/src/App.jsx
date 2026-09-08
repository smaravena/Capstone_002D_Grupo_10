import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext'
import ProtectedRoute from './components/ProtectedRoute'
import Layout from './components/Layout'
import Login from './pages/Login'
import Unauthorized from './pages/Unauthorized'
import Pedidos from './pages/Pedidos'
import { ROLES_MODULO_PEDIDOS } from './lib/roles'
import './App.css'

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/no-autorizado" element={<Unauthorized />} />

          <Route
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/pedidos" replace />} />
            <Route
              path="/pedidos"
              element={
                <ProtectedRoute allowedRoles={ROLES_MODULO_PEDIDOS}>
                  <Pedidos />
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
