import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ROLES } from '../lib/roles'

const ROLE_OPTIONS = Object.values(ROLES)

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

const emptyForm = () => ({ nom_usuario: '', ape_usuario: '', rol_usu: ROLE_OPTIONS[0] ?? '', correo: '' })

const IconEye = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z" />
    <circle cx="12" cy="12" r="3" />
  </svg>
)

const IconPencil = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M12 20h9" />
    <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4Z" />
  </svg>
)

const IconTrash = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 6h18" />
    <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
    <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6" />
    <path d="M10 11v6" />
    <path d="M14 11v6" />
  </svg>
)

export default function Usuarios() {
  const [usuarios, setUsuarios] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'crear' | 'editar' | 'ver' | 'eliminar' | null
  const [usuarioActivo, setUsuarioActivo] = useState(null)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  const fetchUsuarios = async () => {
    const { data, error } = await supabase
      .from('usuario')
      .select('id_usu, nom_usuario, ape_usuario, rol_usu, correo')
      .order('id_usu', { ascending: true })

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setUsuarios(data)
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchUsuarios().then(() => setLoading(false))
  }, [])

  const abrirCrear = () => {
    setForm(emptyForm())
    setFormError(null)
    setUsuarioActivo(null)
    setModo('crear')
  }

  const abrirVer = (usuario) => {
    setUsuarioActivo(usuario)
    setModo('ver')
  }

  const abrirEditar = (usuario) => {
    setForm({
      nom_usuario: usuario.nom_usuario ?? '',
      ape_usuario: usuario.ape_usuario ?? '',
      rol_usu: usuario.rol_usu ?? ROLE_OPTIONS[0] ?? '',
      correo: usuario.correo ?? '',
    })
    setFormError(null)
    setUsuarioActivo(usuario)
    setModo('editar')
  }

  const abrirEliminar = (usuario) => {
    setUsuarioActivo(usuario)
    setDeleteError(null)
    setModo('eliminar')
  }

  const cerrarModal = () => {
    setModo(null)
    setUsuarioActivo(null)
    setFormError(null)
    setDeleteError(null)
  }

  const confirmarEliminar = async () => {
    if (!usuarioActivo) return

    setDeleting(true)
    setDeleteError(null)
    const { error } = await supabase.from('usuario').delete().eq('id_usu', usuarioActivo.id_usu)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    setUsuarios((prev) => prev.filter((u) => u.id_usu !== usuarioActivo.id_usu))
    cerrarModal()
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    const correo = form.correo.trim()

    if (!form.nom_usuario.trim() || !form.ape_usuario.trim() || !correo) {
      setFormError('Nombre, apellido y correo son obligatorios.')
      return
    }

    if (!EMAIL_REGEX.test(correo)) {
      setFormError('Ingresa un correo electrónico válido.')
      return
    }

    setSubmitting(true)
    try {
      const payload = { ...form, correo }

      if (modo === 'crear') {
        const { error } = await supabase.from('usuario').insert(payload)
        if (error) throw error

        // Crea la cuenta de acceso (si no existe) y envía un correo de invitación
        // para que el usuario defina su contraseña en /reset-password.
        const { error: inviteError } = await supabase.auth.signInWithOtp({
          email: correo,
          options: {
            shouldCreateUser: true,
            emailRedirectTo: `${window.location.origin}/reset-password`,
          },
        })
        if (inviteError) {
          setFormError(
            `El usuario se creó, pero no se pudo enviar el correo de invitación: ${inviteError.message}`,
          )
          await fetchUsuarios()
          setSubmitting(false)
          return
        }
      } else if (modo === 'editar' && usuarioActivo) {
        const { error } = await supabase.from('usuario').update(payload).eq('id_usu', usuarioActivo.id_usu)
        if (error) throw error
      }

      cerrarModal()
      await fetchUsuarios()
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el usuario.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="usuarios-page">
      <div className="usuarios-header">
        <h1>Módulo de Usuarios</h1>
        <button type="button" onClick={abrirCrear}>
          + Nuevo usuario
        </button>
      </div>

      {loading && <p>Cargando usuarios...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <table className="usuarios-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Nombre</th>
              <th>Apellido</th>
              <th>Correo</th>
              <th>Rol</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {usuarios.map((usuario) => (
              <tr key={usuario.id_usu}>
                <td>{usuario.id_usu}</td>
                <td>{usuario.nom_usuario}</td>
                <td>{usuario.ape_usuario}</td>
                <td>{usuario.correo ?? '—'}</td>
                <td>
                  <span className="rol-badge">{usuario.rol_usu ?? '—'}</span>
                </td>
                <td className="usuarios-actions">
                  <button
                    type="button"
                    className="icon-btn"
                    title="Ver"
                    aria-label="Ver usuario"
                    onClick={() => abrirVer(usuario)}
                  >
                    <IconEye />
                  </button>
                  <button
                    type="button"
                    className="icon-btn"
                    title="Editar"
                    aria-label="Editar usuario"
                    onClick={() => abrirEditar(usuario)}
                  >
                    <IconPencil />
                  </button>
                  <button
                    type="button"
                    className="icon-btn icon-btn-danger"
                    title="Eliminar"
                    aria-label="Eliminar usuario"
                    onClick={() => abrirEliminar(usuario)}
                  >
                    <IconTrash />
                  </button>
                </td>
              </tr>
            ))}
            {usuarios.length === 0 && (
              <tr>
                <td colSpan={6}>Todavía no hay usuarios registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nuevo usuario' : 'Editar usuario'}</h2>
            <form className="usuario-form" onSubmit={handleSubmit}>
              <label>
                Nombre
                <input
                  value={form.nom_usuario}
                  onChange={(e) => setForm((prev) => ({ ...prev, nom_usuario: e.target.value }))}
                  required
                />
              </label>
              <label>
                Apellido
                <input
                  value={form.ape_usuario}
                  onChange={(e) => setForm((prev) => ({ ...prev, ape_usuario: e.target.value }))}
                  required
                />
              </label>
              <label>
                Correo electrónico
                <input
                  type="email"
                  value={form.correo}
                  onChange={(e) => setForm((prev) => ({ ...prev, correo: e.target.value }))}
                  required
                />
              </label>
              <label>
                Rol
                <select
                  value={form.rol_usu}
                  onChange={(e) => setForm((prev) => ({ ...prev, rol_usu: e.target.value }))}
                >
                  {ROLE_OPTIONS.map((rol) => (
                    <option key={rol} value={rol}>
                      {rol}
                    </option>
                  ))}
                </select>
              </label>

              {formError && <p className="form-error">{formError}</p>}

              <div className="modal-actions">
                <button type="button" className="btn-secondary" onClick={cerrarModal}>
                  Cancelar
                </button>
                <button type="submit" disabled={submitting}>
                  {submitting ? 'Guardando...' : 'Guardar'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {modo === 'ver' && usuarioActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Detalle del usuario</h2>
            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">ID</span>
                <span className="detalle-value">{usuarioActivo.id_usu}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Nombre</span>
                <span className="detalle-value">{usuarioActivo.nom_usuario}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Apellido</span>
                <span className="detalle-value">{usuarioActivo.ape_usuario}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Correo</span>
                <span className="detalle-value">{usuarioActivo.correo ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Rol</span>
                <span className="detalle-value">{usuarioActivo.rol_usu ?? '—'}</span>
              </div>
            </div>
            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cerrarModal}>
                Cerrar
              </button>
            </div>
          </div>
        </div>
      )}

      {modo === 'eliminar' && usuarioActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar usuario</h2>
            <p>
              ¿Seguro que deseas eliminar al siguiente usuario?
              <br />
              <strong>
                {usuarioActivo.nom_usuario} {usuarioActivo.ape_usuario}
              </strong>
            </p>
            <p className="modal-hint">Esta acción no se puede deshacer.</p>

            {deleteError && <p className="form-error">{deleteError}</p>}

            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cerrarModal}>
                Cancelar
              </button>
              <button type="button" className="btn-danger" disabled={deleting} onClick={confirmarEliminar}>
                {deleting ? 'Eliminando...' : 'Eliminar'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
