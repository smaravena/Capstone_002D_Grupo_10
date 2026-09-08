import { useCallback, useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { AuthContext } from './auth-context'

export function AuthProvider({ children }) {
  const [session, setSession] = useState(null)
  const [usuario, setUsuario] = useState(null)
  const [loading, setLoading] = useState(true)

  const loadUsuario = useCallback(async (authUserId) => {
    if (!authUserId) {
      setUsuario(null)
      return
    }

    const { data, error } = await supabase
      .from('usuario')
      .select('id_usu, nom_usuario, ape_usuario, rol_usu, auth_user_id')
      .eq('auth_user_id', authUserId)
      .maybeSingle()

    if (error) {
      console.error('Error cargando perfil de usuario:', error.message)
      setUsuario(null)
      return
    }

    setUsuario(data)
  }, [])

  useEffect(() => {
    let active = true

    supabase.auth.getSession().then(async ({ data }) => {
      if (!active) return
      setSession(data.session)
      await loadUsuario(data.session?.user?.id)
      if (active) setLoading(false)
    })

    const { data: listener } = supabase.auth.onAuthStateChange(async (_event, newSession) => {
      setSession(newSession)
      await loadUsuario(newSession?.user?.id)
    })

    return () => {
      active = false
      listener.subscription.unsubscribe()
    }
  }, [loadUsuario])

  const signIn = useCallback(async (email, password) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw error
  }, [])

  const signOut = useCallback(async () => {
    await supabase.auth.signOut()
  }, [])

  const value = {
    session,
    usuario,
    loading,
    isAuthenticated: Boolean(session),
    role: usuario?.rol_usu ?? null,
    signIn,
    signOut,
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
