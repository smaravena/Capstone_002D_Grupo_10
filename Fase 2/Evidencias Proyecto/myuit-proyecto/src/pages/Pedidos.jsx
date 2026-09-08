import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ESTADOS_PEDIDO } from '../lib/pedidoConstants'

const emptyDetalle = () => ({ tipo_prenda: '', cant_prendas: 1, obs_detalle: '' })

const emptyForm = () => ({
  clienteMode: 'existing',
  id_cli: '',
  nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
  fec_ini: '',
  fec_ter: '',
  estado_pedido: ESTADOS_PEDIDO[0],
  detalles: [emptyDetalle()],
})

export default function Pedidos() {
  const [pedidos, setPedidos] = useState([])
  const [clientes, setClientes] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [showForm, setShowForm] = useState(false)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  const fetchPedidos = async () => {
    const { data, error } = await supabase
      .from('pedido')
      .select(
        'id_pedido, fec_ini, fec_ter, estado_pedido, created_at, cliente:id_cli ( id_cli, nom_cli, num_cli, correo_cli ), detalle_pedido ( id_detalle, tipo_prenda, cant_prendas, obs_detalle )',
      )
      .order('created_at', { ascending: false })

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setPedidos(data)
    }
  }

  const fetchClientes = async () => {
    const { data, error } = await supabase
      .from('cliente')
      .select('id_cli, nom_cli, num_cli, correo_cli')
      .order('nom_cli')

    if (!error) setClientes(data)
  }

  useEffect(() => {
    // Carga inicial de datos: el setState ocurre dentro de fetchPedidos/fetchClientes
    // después del await a Supabase, no de forma síncrona.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    Promise.all([fetchPedidos(), fetchClientes()]).then(() => setLoading(false))
  }, [])

  const handleDetalleChange = (index, field, value) => {
    setForm((prev) => {
      const detalles = [...prev.detalles]
      detalles[index] = { ...detalles[index], [field]: value }
      return { ...prev, detalles }
    })
  }

  const addDetalle = () => {
    setForm((prev) => ({ ...prev, detalles: [...prev.detalles, emptyDetalle()] }))
  }

  const removeDetalle = (index) => {
    setForm((prev) => ({
      ...prev,
      detalles: prev.detalles.filter((_, i) => i !== index),
    }))
  }

  const resetForm = () => {
    setForm(emptyForm())
    setFormError(null)
    setShowForm(false)
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    if (form.detalles.length === 0) {
      setFormError('Agrega al menos una línea de detalle.')
      return
    }

    setSubmitting(true)
    try {
      let id_cli = form.id_cli

      if (form.clienteMode === 'new') {
        const { data: nuevoCliente, error: clienteError } = await supabase
          .from('cliente')
          .insert(form.nuevoCliente)
          .select('id_cli')
          .single()

        if (clienteError) throw clienteError
        id_cli = nuevoCliente.id_cli
      }

      if (!id_cli) {
        throw new Error('Selecciona o crea un cliente para el pedido.')
      }

      const { data: nuevoPedido, error: pedidoError } = await supabase
        .from('pedido')
        .insert({
          id_cli,
          fec_ini: form.fec_ini || null,
          fec_ter: form.fec_ter || null,
          estado_pedido: form.estado_pedido,
        })
        .select('id_pedido')
        .single()

      if (pedidoError) throw pedidoError

      const detallesPayload = form.detalles.map((d) => ({
        id_pedido: nuevoPedido.id_pedido,
        tipo_prenda: d.tipo_prenda,
        cant_prendas: Number(d.cant_prendas) || 0,
        obs_detalle: d.obs_detalle || null,
      }))

      const { error: detalleError } = await supabase.from('detalle_pedido').insert(detallesPayload)
      if (detalleError) throw detalleError

      resetForm()
      await Promise.all([fetchPedidos(), fetchClientes()])
    } catch (err) {
      setFormError(err.message ?? 'No se pudo crear el pedido.')
    } finally {
      setSubmitting(false)
    }
  }

  const handleEstadoChange = async (id_pedido, estado_pedido) => {
    const { error } = await supabase.from('pedido').update({ estado_pedido }).eq('id_pedido', id_pedido)
    if (error) {
      setLoadError(error.message)
      return
    }
    setPedidos((prev) => prev.map((p) => (p.id_pedido === id_pedido ? { ...p, estado_pedido } : p)))
  }

  return (
    <div className="pedidos-page">
      <div className="pedidos-header">
        <h1>Ingreso y Control de Pedidos</h1>
        <button type="button" onClick={() => setShowForm((v) => !v)}>
          {showForm ? 'Cancelar' : 'Nuevo pedido'}
        </button>
      </div>

      {showForm && (
        <form className="pedido-form" onSubmit={handleSubmit}>
          <fieldset>
            <legend>Cliente</legend>
            <label>
              <input
                type="radio"
                name="clienteMode"
                checked={form.clienteMode === 'existing'}
                onChange={() => setForm((prev) => ({ ...prev, clienteMode: 'existing' }))}
              />
              Cliente existente
            </label>
            <label>
              <input
                type="radio"
                name="clienteMode"
                checked={form.clienteMode === 'new'}
                onChange={() => setForm((prev) => ({ ...prev, clienteMode: 'new' }))}
              />
              Cliente nuevo
            </label>

            {form.clienteMode === 'existing' ? (
              <select
                value={form.id_cli}
                onChange={(e) => setForm((prev) => ({ ...prev, id_cli: e.target.value }))}
                required
              >
                <option value="">Selecciona un cliente</option>
                {clientes.map((c) => (
                  <option key={c.id_cli} value={c.id_cli}>
                    {c.nom_cli} ({c.num_cli})
                  </option>
                ))}
              </select>
            ) : (
              <div className="cliente-nuevo-fields">
                <input
                  placeholder="Nombre"
                  value={form.nuevoCliente.nom_cli}
                  onChange={(e) =>
                    setForm((prev) => ({
                      ...prev,
                      nuevoCliente: { ...prev.nuevoCliente, nom_cli: e.target.value },
                    }))
                  }
                  required
                />
                <input
                  placeholder="Teléfono"
                  value={form.nuevoCliente.num_cli}
                  onChange={(e) =>
                    setForm((prev) => ({
                      ...prev,
                      nuevoCliente: { ...prev.nuevoCliente, num_cli: e.target.value },
                    }))
                  }
                />
                <input
                  placeholder="Correo"
                  type="email"
                  value={form.nuevoCliente.correo_cli}
                  onChange={(e) =>
                    setForm((prev) => ({
                      ...prev,
                      nuevoCliente: { ...prev.nuevoCliente, correo_cli: e.target.value },
                    }))
                  }
                />
              </div>
            )}
          </fieldset>

          <fieldset>
            <legend>Pedido</legend>
            <label>
              Fecha inicio
              <input
                type="date"
                value={form.fec_ini}
                onChange={(e) => setForm((prev) => ({ ...prev, fec_ini: e.target.value }))}
              />
            </label>
            <label>
              Fecha término
              <input
                type="date"
                value={form.fec_ter}
                onChange={(e) => setForm((prev) => ({ ...prev, fec_ter: e.target.value }))}
              />
            </label>
            <label>
              Estado
              <input
                list="estados-pedido"
                value={form.estado_pedido}
                onChange={(e) => setForm((prev) => ({ ...prev, estado_pedido: e.target.value }))}
              />
            </label>
          </fieldset>

          <fieldset>
            <legend>Detalle de prendas</legend>
            {form.detalles.map((detalle, index) => (
              <div className="detalle-row" key={index}>
                <input
                  placeholder="Tipo de prenda"
                  value={detalle.tipo_prenda}
                  onChange={(e) => handleDetalleChange(index, 'tipo_prenda', e.target.value)}
                  required
                />
                <input
                  type="number"
                  min="1"
                  placeholder="Cantidad"
                  value={detalle.cant_prendas}
                  onChange={(e) => handleDetalleChange(index, 'cant_prendas', e.target.value)}
                  required
                />
                <input
                  placeholder="Observaciones"
                  value={detalle.obs_detalle}
                  onChange={(e) => handleDetalleChange(index, 'obs_detalle', e.target.value)}
                />
                <button
                  type="button"
                  className="link-btn"
                  onClick={() => removeDetalle(index)}
                  disabled={form.detalles.length === 1}
                >
                  Quitar
                </button>
              </div>
            ))}
            <button type="button" className="link-btn" onClick={addDetalle}>
              + Agregar línea
            </button>
          </fieldset>

          {formError && <p className="form-error">{formError}</p>}

          <button type="submit" disabled={submitting}>
            {submitting ? 'Guardando...' : 'Guardar pedido'}
          </button>
        </form>
      )}

      {loading && <p>Cargando pedidos...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <table className="pedidos-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Cliente</th>
              <th>Inicio</th>
              <th>Término</th>
              <th>Prendas</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            {pedidos.map((pedido) => (
              <tr key={pedido.id_pedido}>
                <td>{pedido.id_pedido}</td>
                <td>{pedido.cliente?.nom_cli ?? '—'}</td>
                <td>{pedido.fec_ini ?? '—'}</td>
                <td>{pedido.fec_ter ?? '—'}</td>
                <td>{pedido.detalle_pedido?.length ?? 0}</td>
                <td>
                  <input
                    list="estados-pedido"
                    value={pedido.estado_pedido ?? ''}
                    onChange={(e) => handleEstadoChange(pedido.id_pedido, e.target.value)}
                  />
                </td>
              </tr>
            ))}
            {pedidos.length === 0 && (
              <tr>
                <td colSpan={6}>Todavía no hay pedidos registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      <datalist id="estados-pedido">
        {ESTADOS_PEDIDO.map((estado) => (
          <option key={estado} value={estado} />
        ))}
      </datalist>
    </div>
  )
}
