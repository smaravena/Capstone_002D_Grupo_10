import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { SITE_URL } from '../lib/siteUrl'
import { ROLES } from '../lib/roles'
import { soloErrores, validarCorreo, validarTexto } from '../lib/validators'
import { IconEye, IconPencil, IconTrash } from '../components/Icons'
import FieldError from '../components/FieldError'
import { useValidacion } from '../hooks/useValidacion'
import iconoTaller from '../assets/icono.png'

const ROLE_OPTIONS = Object.values(ROLES)

const emptyForm = () => ({ nom_usuario: '', ape_usuario: '', rol_usu: ROLE_OPTIONS[0] ?? '', correo: '' })

const validarUsuario = (form) =>
  soloErrores({
    nom_usuario: validarTexto(form.nom_usuario, 'el nombre'),
    ape_usuario: validarTexto(form.ape_usuario, 'el apellido'),
    correo: validarCorreo(form.correo),
  })

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
  const { errorDe, tocar, validarEnvio, reiniciar } = useValidacion(validarUsuario, form)

  const cambiarCampo = (campo, valor) => {
    setForm((prev) => ({ ...prev, [campo]: valor }))
    tocar(campo)
  }

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
    reiniciar()
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
    reiniciar()
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
      if (error.code === '23503') {
        setDeleteError(
          'No se puede eliminar este usuario porque tiene trabajos asignados. Reasigna o elimina esos trabajos antes de eliminarlo.',
        )
      } else {
        setDeleteError(error.message)
      }
      return
    }
    setUsuarios((prev) => prev.filter((u) => u.id_usu !== usuarioActivo.id_usu))
    cerrarModal()
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    if (!validarEnvio()) return

    const correo = form.correo.trim()

    setSubmitting(true)
    try {
      const payload = {
        ...form,
        nom_usuario: form.nom_usuario.trim(),
        ape_usuario: form.ape_usuario.trim(),
        correo,
      }

      if (modo === 'crear') {
        const { error } = await supabase.from('usuario').insert(payload)
        if (error) throw error

        // Crea la cuenta de acceso (si no existe) y envía un correo de invitación
        // para que el usuario defina su contraseña en /reset-password.
        const { error: inviteError } = await supabase.auth.signInWithOtp({
          email: correo,
          options: {
            shouldCreateUser: true,
            emailRedirectTo: `${SITE_URL}/reset-password`,
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
        <h1 className="page-title">
          Módulo de Usuarios
          <img src={iconoTaller} alt="" className="page-title-icon" />
        </h1>
        <button type="button" onClick={abrirCrear}>
           Nuevo usuario
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
                <td data-label="#">{usuario.id_usu}</td>
                <td data-label="Nombre">{usuario.nom_usuario}</td>
                <td data-label="Apellido">{usuario.ape_usuario}</td>
                <td data-label="Correo">{usuario.correo ?? '—'}</td>
                <td data-label="Rol">
                  <span className="rol-badge">{usuario.rol_usu ?? '—'}</span>
                </td>
                <td className="usuarios-actions" data-label="Acciones">
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
                <td colSpan={6} className="table-empty">Todavía no hay usuarios registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nuevo usuario' : 'Editar usuario'}</h2>
            <form className="usuario-form" onSubmit={handleSubmit} noValidate>
              <label>
                Nombre
                <input
                  value={form.nom_usuario}
                  onChange={(e) => cambiarCampo('nom_usuario', e.target.value)}
                  aria-invalid={Boolean(errorDe('nom_usuario'))}
                />
                <FieldError mensaje={errorDe('nom_usuario')} />
              </label>
              <label>
                Apellido
                <input
                  value={form.ape_usuario}
                  onChange={(e) => cambiarCampo('ape_usuario', e.target.value)}
                  aria-invalid={Boolean(errorDe('ape_usuario'))}
                />
                <FieldError mensaje={errorDe('ape_usuario')} />
              </label>
              <label>
                Correo electrónico
                <input
                  type="email"
                  value={form.correo}
                  onChange={(e) => cambiarCampo('correo', e.target.value)}
                  aria-invalid={Boolean(errorDe('correo'))}
                />
                <FieldError mensaje={errorDe('correo')} />
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
