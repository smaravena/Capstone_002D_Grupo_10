import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { EMAIL_REGEX, PHONE_REGEX } from '../lib/validators'
import { IconEye, IconPencil, IconTrash } from '../components/Icons'

const emptyForm = () => ({ nom_cli: '', num_cli: '', correo_cli: '' })

export default function Clientes() {
  const [clientes, setClientes] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'crear' | 'editar' | 'ver' | 'eliminar' | null
  const [clienteActivo, setClienteActivo] = useState(null)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  const fetchClientes = async () => {
    const { data, error } = await supabase
      .from('cliente')
      .select('id_cli, nom_cli, num_cli, correo_cli')
      .order('nom_cli')

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setClientes(data)
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchClientes().then(() => setLoading(false))
  }, [])

  const abrirCrear = () => {
    setForm(emptyForm())
    setFormError(null)
    setClienteActivo(null)
    setModo('crear')
  }

  const abrirVer = (cliente) => {
    setClienteActivo(cliente)
    setModo('ver')
  }

  const abrirEditar = (cliente) => {
    setForm({
      nom_cli: cliente.nom_cli ?? '',
      num_cli: cliente.num_cli ?? '',
      correo_cli: cliente.correo_cli ?? '',
    })
    setFormError(null)
    setClienteActivo(cliente)
    setModo('editar')
  }

  const abrirEliminar = (cliente) => {
    setClienteActivo(cliente)
    setDeleteError(null)
    setModo('eliminar')
  }

  const cerrarModal = () => {
    setModo(null)
    setClienteActivo(null)
    setFormError(null)
    setDeleteError(null)
  }

  const confirmarEliminar = async () => {
    if (!clienteActivo) return

    setDeleting(true)
    setDeleteError(null)
    const { error } = await supabase.from('cliente').delete().eq('id_cli', clienteActivo.id_cli)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    setClientes((prev) => prev.filter((c) => c.id_cli !== clienteActivo.id_cli))
    cerrarModal()
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    const nom_cli = form.nom_cli.trim()
    const num_cli = form.num_cli.trim()
    const correo_cli = form.correo_cli.trim()

    if (!nom_cli || !num_cli) {
      setFormError('Nombre y teléfono son obligatorios.')
      return
    }

    if (!PHONE_REGEX.test(num_cli)) {
      setFormError('Ingresa un teléfono válido.')
      return
    }

    if (correo_cli && !EMAIL_REGEX.test(correo_cli)) {
      setFormError('Ingresa un correo electrónico válido.')
      return
    }

    setSubmitting(true)
    try {
      const payload = { nom_cli, num_cli, correo_cli: correo_cli || null }

      if (modo === 'crear') {
        const { error } = await supabase.from('cliente').insert(payload)
        if (error) throw error
      } else if (modo === 'editar' && clienteActivo) {
        const { error } = await supabase.from('cliente').update(payload).eq('id_cli', clienteActivo.id_cli)
        if (error) throw error
      }

      cerrarModal()
      await fetchClientes()
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el cliente.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="usuarios-page">
      <div className="usuarios-header">
        <h1>Módulo de Clientes</h1>
        <button type="button" onClick={abrirCrear}>
           Nuevo cliente
        </button>
      </div>

      {loading && <p>Cargando clientes...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <table className="usuarios-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Nombre</th>
              <th>Teléfono</th>
              <th>Correo</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {clientes.map((cliente) => (
              <tr key={cliente.id_cli}>
                <td>{cliente.id_cli}</td>
                <td>{cliente.nom_cli}</td>
                <td>{cliente.num_cli}</td>
                <td>{cliente.correo_cli ?? '—'}</td>
                <td className="usuarios-actions">
                  <button
                    type="button"
                    className="icon-btn"
                    title="Ver"
                    aria-label="Ver cliente"
                    onClick={() => abrirVer(cliente)}
                  >
                    <IconEye />
                  </button>
                  <button
                    type="button"
                    className="icon-btn"
                    title="Editar"
                    aria-label="Editar cliente"
                    onClick={() => abrirEditar(cliente)}
                  >
                    <IconPencil />
                  </button>
                  <button
                    type="button"
                    className="icon-btn icon-btn-danger"
                    title="Eliminar"
                    aria-label="Eliminar cliente"
                    onClick={() => abrirEliminar(cliente)}
                  >
                    <IconTrash />
                  </button>
                </td>
              </tr>
            ))}
            {clientes.length === 0 && (
              <tr>
                <td colSpan={5}>Todavía no hay clientes registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nuevo cliente' : 'Editar cliente'}</h2>
            <form className="usuario-form" onSubmit={handleSubmit}>
              <label>
                Nombre
                <input
                  value={form.nom_cli}
                  onChange={(e) => setForm((prev) => ({ ...prev, nom_cli: e.target.value }))}
                  required
                />
              </label>
              <label>
                Teléfono
                <input
                  value={form.num_cli}
                  onChange={(e) => setForm((prev) => ({ ...prev, num_cli: e.target.value }))}
                  required
                />
              </label>
              <label>
                Correo electrónico
                <input
                  type="email"
                  value={form.correo_cli}
                  onChange={(e) => setForm((prev) => ({ ...prev, correo_cli: e.target.value }))}
                />
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

      {modo === 'ver' && clienteActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Detalle del cliente</h2>
            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">ID</span>
                <span className="detalle-value">{clienteActivo.id_cli}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Nombre</span>
                <span className="detalle-value">{clienteActivo.nom_cli}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Teléfono</span>
                <span className="detalle-value">{clienteActivo.num_cli}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Correo</span>
                <span className="detalle-value">{clienteActivo.correo_cli ?? '—'}</span>
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

      {modo === 'eliminar' && clienteActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar cliente</h2>
            <p>
              ¿Seguro que deseas eliminar al siguiente cliente?
              <br />
              <strong>{clienteActivo.nom_cli}</strong>
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
