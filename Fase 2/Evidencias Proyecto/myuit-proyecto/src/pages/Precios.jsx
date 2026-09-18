import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { IconPencil, IconTrash } from '../components/Icons'

const emptyForm = () => ({ tipo_prenda: '', talla: '', precio: '' })

const formatPrecio = (valor) =>
  new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }).format(valor)

export default function Precios() {
  const [precios, setPrecios] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'crear' | 'editar' | 'eliminar' | null
  const [precioActivo, setPrecioActivo] = useState(null)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  const fetchPrecios = async () => {
    const { data, error } = await supabase
      .from('precio_prenda')
      .select('id_precio, tipo_prenda, talla, precio')
      .order('id_precio', { ascending: true })

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setPrecios(data)
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchPrecios().then(() => setLoading(false))
  }, [])

  const abrirCrear = () => {
    setForm(emptyForm())
    setFormError(null)
    setPrecioActivo(null)
    setModo('crear')
  }

  const abrirEditar = (precio) => {
    setForm({
      tipo_prenda: precio.tipo_prenda ?? '',
      talla: precio.talla ?? '',
      precio: precio.precio ?? '',
    })
    setFormError(null)
    setPrecioActivo(precio)
    setModo('editar')
  }

  const abrirEliminar = (precio) => {
    setPrecioActivo(precio)
    setDeleteError(null)
    setModo('eliminar')
  }

  const cerrarModal = () => {
    setModo(null)
    setPrecioActivo(null)
    setFormError(null)
    setDeleteError(null)
  }

  const confirmarEliminar = async () => {
    if (!precioActivo) return

    setDeleting(true)
    setDeleteError(null)
    const { error } = await supabase.from('precio_prenda').delete().eq('id_precio', precioActivo.id_precio)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    setPrecios((prev) => prev.filter((p) => p.id_precio !== precioActivo.id_precio))
    cerrarModal()
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    const tipo_prenda = form.tipo_prenda.trim()
    const talla = form.talla.trim()
    const precio = Number(form.precio)

    if (!tipo_prenda || !talla) {
      setFormError('El tipo de prenda y la talla son obligatorios.')
      return
    }

    if (!Number.isFinite(precio) || precio <= 0) {
      setFormError('Ingresa un precio válido, mayor a 0.')
      return
    }

    setSubmitting(true)
    try {
      const payload = { tipo_prenda, talla, precio }

      if (modo === 'crear') {
        const { error } = await supabase.from('precio_prenda').insert(payload)
        if (error) throw error
      } else if (modo === 'editar' && precioActivo) {
        const { error } = await supabase
          .from('precio_prenda')
          .update(payload)
          .eq('id_precio', precioActivo.id_precio)
        if (error) throw error
      }

      cerrarModal()
      await fetchPrecios()
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el precio.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="precios-page">
      <div className="usuarios-header">
        <h1>Lista de precios</h1>
        <button type="button" onClick={abrirCrear}>
          Nueva línea de precio
        </button>
      </div>

      {loading && <p>Cargando precios...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <table className="usuarios-table">
          <thead>
            <tr>
              <th>Tipo de prenda</th>
              <th>Talla</th>
              <th>Precio</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {precios.map((precio) => (
              <tr key={precio.id_precio}>
                <td>{precio.tipo_prenda}</td>
                <td>{precio.talla}</td>
                <td>{formatPrecio(precio.precio)}</td>
                <td className="usuarios-actions">
                  <button
                    type="button"
                    className="icon-btn"
                    title="Editar"
                    aria-label="Editar precio"
                    onClick={() => abrirEditar(precio)}
                  >
                    <IconPencil />
                  </button>
                  <button
                    type="button"
                    className="icon-btn icon-btn-danger"
                    title="Eliminar"
                    aria-label="Eliminar precio"
                    onClick={() => abrirEliminar(precio)}
                  >
                    <IconTrash />
                  </button>
                </td>
              </tr>
            ))}
            {precios.length === 0 && (
              <tr>
                <td colSpan={4}>Todavía no hay precios registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nueva línea de precio' : 'Editar precio'}</h2>
            <form className="usuario-form" onSubmit={handleSubmit}>
              <label>
                Tipo de prenda
                <input
                  list="tipos-prenda"
                  value={form.tipo_prenda}
                  onChange={(e) => setForm((prev) => ({ ...prev, tipo_prenda: e.target.value }))}
                  placeholder="Ej: Buzos Escolares"
                  required
                />
                <datalist id="tipos-prenda">
                  {[...new Set(precios.map((p) => p.tipo_prenda))].map((tipo) => (
                    <option key={tipo} value={tipo} />
                  ))}
                </datalist>
              </label>
              <label>
                Talla
                <input
                  value={form.talla}
                  onChange={(e) => setForm((prev) => ({ ...prev, talla: e.target.value }))}
                  placeholder="Ej: Talla 10 y 12"
                  required
                />
              </label>
              <label>
                Precio (CLP)
                <input
                  type="number"
                  min="1"
                  step="1"
                  value={form.precio}
                  onChange={(e) => setForm((prev) => ({ ...prev, precio: e.target.value }))}
                  required
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

      {modo === 'eliminar' && precioActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar precio</h2>
            <p>
              ¿Seguro que deseas eliminar el siguiente precio?
              <br />
              <strong>
                {precioActivo.tipo_prenda} — {precioActivo.talla}
              </strong>
            </p>
            <p className="modal-hint">Esta acción no se puede deshacer y dejará de mostrarse en el landing.</p>

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
