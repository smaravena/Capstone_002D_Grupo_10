import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ESTADOS_PEDIDO } from '../lib/pedidoConstants'
import { EMAIL_REGEX, PHONE_REGEX } from '../lib/validators'
import { IconEye, IconPencil, IconTrash } from '../components/Icons'
import { useAuth } from '../hooks/useAuth'
import { ROLES } from '../lib/roles'

const ROLES_SOLO_PROPIOS = [ROLES.CORTADORA, ROLES.OPERARIA]

const TRABAJO_TIPOS = [
  { tipo: 'corte', field: 'id_usu_corte', label: 'Cortadora' },
  { tipo: 'armado', field: 'id_usu_armado', label: 'Operaria (armado)' },
]

const emptyDetalle = () => ({
  tipo_prenda: '',
  cant_prendas: 1,
  obs_detalle: '',
  id_usu_corte: '',
  id_usu_armado: '',
})

const emptyForm = () => ({
  clienteMode: 'existing',
  id_cli: '',
  nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
  fec_ini: '',
  fec_ter: '',
  estado_pedido: ESTADOS_PEDIDO[0],
  detalles: [emptyDetalle()],
})

const getResponsables = (pedido) => {
  const nombres = new Set()
  pedido.detalle_pedido?.forEach((d) => {
    d.trabajo?.forEach((t) => {
      if (t.usuario) nombres.add(`${t.usuario.nom_usuario} ${t.usuario.ape_usuario}`)
    })
  })
  return [...nombres]
}

export default function Pedidos() {
  const { usuario, role } = useAuth()
  const soloPropios = ROLES_SOLO_PROPIOS.includes(role)

  const [pedidos, setPedidos] = useState([])
  const [clientes, setClientes] = useState([])
  const [usuarios, setUsuarios] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'crear' | 'editar' | 'ver' | 'eliminar' | null
  const [pedidoActivo, setPedidoActivo] = useState(null)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  const cortadoras = usuarios.filter((u) => u.rol_usu === ROLES.CORTADORA)
  const operarias = usuarios.filter((u) => u.rol_usu === ROLES.OPERARIA)

  const fetchPedidoIdsAsignados = async () => {
    if (!usuario?.id_usu) return []

    const { data, error } = await supabase
      .from('trabajo')
      .select('detalle:id_detalle ( id_pedido )')
      .eq('id_usu', usuario.id_usu)

    if (error) {
      setLoadError(error.message)
      return []
    }

    const ids = new Set()
    data?.forEach((t) => {
      if (t.detalle?.id_pedido) ids.add(t.detalle.id_pedido)
    })
    return [...ids]
  }

  const fetchPedidos = async () => {
    let query = supabase
      .from('pedido')
      .select(
        'id_pedido, fec_ini, fec_ter, estado_pedido, created_at, cliente:id_cli ( id_cli, nom_cli, num_cli, correo_cli ), detalle_pedido ( id_detalle, tipo_prenda, cant_prendas, obs_detalle, trabajo ( id_trabajo, tipo_trabajo, id_usu, estado, usuario:id_usu ( nom_usuario, ape_usuario ) ) )',
      )
      .order('created_at', { ascending: false })

    if (soloPropios) {
      const idsAsignados = await fetchPedidoIdsAsignados()
      if (idsAsignados.length === 0) {
        setLoadError(null)
        setPedidos([])
        return
      }
      query = query.in('id_pedido', idsAsignados)
    }

    const { data, error } = await query

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

  const fetchUsuarios = async () => {
    const { data, error } = await supabase
      .from('usuario')
      .select('id_usu, nom_usuario, ape_usuario, rol_usu')
      .order('nom_usuario')

    if (!error) setUsuarios(data)
  }

  useEffect(() => {
    // Carga inicial de datos: el setState ocurre dentro de fetchPedidos/fetchClientes/fetchUsuarios
    // después del await a Supabase, no de forma síncrona.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    Promise.all([fetchPedidos(), fetchClientes(), fetchUsuarios()]).then(() => setLoading(false))
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

  const abrirCrear = () => {
    if (soloPropios) return
    setForm(emptyForm())
    setFormError(null)
    setPedidoActivo(null)
    setModo('crear')
  }

  const abrirVer = (pedido) => {
    setPedidoActivo(pedido)
    setModo('ver')
  }

  const abrirEditar = (pedido) => {
    if (soloPropios) return
    setForm({
      clienteMode: 'existing',
      id_cli: pedido.cliente?.id_cli ? String(pedido.cliente.id_cli) : '',
      nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
      fec_ini: pedido.fec_ini ?? '',
      fec_ter: pedido.fec_ter ?? '',
      estado_pedido: ESTADOS_PEDIDO.includes(pedido.estado_pedido) ? pedido.estado_pedido : ESTADOS_PEDIDO[0],
      detalles: pedido.detalle_pedido?.length
        ? pedido.detalle_pedido.map((d) => {
            const trabajoCorte = d.trabajo?.find((t) => t.tipo_trabajo === 'corte')
            const trabajoArmado = d.trabajo?.find((t) => t.tipo_trabajo === 'armado')
            return {
              id_detalle: d.id_detalle,
              tipo_prenda: d.tipo_prenda,
              cant_prendas: d.cant_prendas,
              obs_detalle: d.obs_detalle ?? '',
              id_usu_corte: trabajoCorte?.id_usu ? String(trabajoCorte.id_usu) : '',
              id_usu_armado: trabajoArmado?.id_usu ? String(trabajoArmado.id_usu) : '',
            }
          })
        : [emptyDetalle()],
    })
    setFormError(null)
    setPedidoActivo(pedido)
    setModo('editar')
  }

  const abrirEliminar = (pedido) => {
    if (soloPropios) return
    setPedidoActivo(pedido)
    setDeleteError(null)
    setModo('eliminar')
  }

  const cerrarModal = () => {
    setModo(null)
    setPedidoActivo(null)
    setForm(emptyForm())
    setFormError(null)
    setDeleteError(null)
  }

  const validateForm = () => {
    if (form.clienteMode === 'existing') {
      if (!form.id_cli) return 'Selecciona un cliente.'
    } else {
      const { nom_cli, num_cli, correo_cli } = form.nuevoCliente
      if (!nom_cli.trim()) return 'Ingresa el nombre del cliente.'
      if (!num_cli.trim()) return 'Ingresa el teléfono del cliente.'
      if (!PHONE_REGEX.test(num_cli.trim())) return 'Ingresa un teléfono válido.'
      if (correo_cli.trim() && !EMAIL_REGEX.test(correo_cli.trim())) {
        return 'Ingresa un correo electrónico válido para el cliente.'
      }
    }

    if (form.fec_ini && form.fec_ter && form.fec_ter < form.fec_ini) {
      return 'La fecha de término no puede ser anterior a la fecha de inicio.'
    }

    if (!ESTADOS_PEDIDO.includes(form.estado_pedido)) {
      return 'Selecciona un estado válido de la lista.'
    }

    if (form.detalles.length === 0) {
      return 'Agrega al menos una línea de detalle.'
    }

    for (const detalle of form.detalles) {
      if (!detalle.tipo_prenda.trim()) return 'Indica el tipo de prenda en cada línea de detalle.'
      const cantidad = Number(detalle.cant_prendas)
      if (!Number.isInteger(cantidad) || cantidad <= 0) {
        return 'La cantidad de prendas debe ser un número entero mayor a 0.'
      }
    }

    return null
  }

  const syncTrabajoAsignaciones = async (id_detalle, detalle, trabajosExistentes = []) => {
    for (const { tipo, field } of TRABAJO_TIPOS) {
      const selectedUsu = detalle[field]
      const existente = trabajosExistentes.find((t) => t.tipo_trabajo === tipo)

      if (selectedUsu) {
        if (existente) {
          if (String(existente.id_usu) !== String(selectedUsu)) {
            const { error } = await supabase
              .from('trabajo')
              .update({ id_usu: selectedUsu })
              .eq('id_trabajo', existente.id_trabajo)
            if (error) throw error
          }
        } else {
          const { error } = await supabase
            .from('trabajo')
            .insert({ id_detalle, id_usu: selectedUsu, tipo_trabajo: tipo })
          if (error) throw error
        }
      } else if (existente) {
        const { error } = await supabase.from('trabajo').delete().eq('id_trabajo', existente.id_trabajo)
        if (error) throw error
      }
    }
  }

  const guardarDetallesEdicion = async (id_pedido) => {
    const originalIds = pedidoActivo.detalle_pedido?.map((d) => d.id_detalle) ?? []
    const currentIds = form.detalles.filter((d) => d.id_detalle).map((d) => d.id_detalle)
    const idsToDelete = originalIds.filter((id) => !currentIds.includes(id))

    if (idsToDelete.length > 0) {
      const { error } = await supabase.from('detalle_pedido').delete().in('id_detalle', idsToDelete)
      if (error) throw error
    }

    const toUpdate = form.detalles.filter((d) => d.id_detalle)
    for (const detalle of toUpdate) {
      const { error } = await supabase
        .from('detalle_pedido')
        .update({
          tipo_prenda: detalle.tipo_prenda,
          cant_prendas: Number(detalle.cant_prendas) || 0,
          obs_detalle: detalle.obs_detalle || null,
        })
        .eq('id_detalle', detalle.id_detalle)
      if (error) throw error

      const original = pedidoActivo.detalle_pedido.find((d) => d.id_detalle === detalle.id_detalle)
      await syncTrabajoAsignaciones(detalle.id_detalle, detalle, original?.trabajo ?? [])
    }

    const toInsert = form.detalles.filter((d) => !d.id_detalle)
    if (toInsert.length > 0) {
      const { data: nuevosDetalles, error } = await supabase
        .from('detalle_pedido')
        .insert(
          toInsert.map((detalle) => ({
            id_pedido,
            tipo_prenda: detalle.tipo_prenda,
            cant_prendas: Number(detalle.cant_prendas) || 0,
            obs_detalle: detalle.obs_detalle || null,
          })),
        )
        .select('id_detalle')
      if (error) throw error

      for (let i = 0; i < toInsert.length; i += 1) {
        await syncTrabajoAsignaciones(nuevosDetalles[i].id_detalle, toInsert[i], [])
      }
    }
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    const validationError = validateForm()
    if (validationError) {
      setFormError(validationError)
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

      const pedidoPayload = {
        id_cli,
        fec_ini: form.fec_ini || null,
        fec_ter: form.fec_ter || null,
        estado_pedido: form.estado_pedido,
      }

      if (modo === 'editar' && pedidoActivo) {
        const { error: pedidoError } = await supabase
          .from('pedido')
          .update(pedidoPayload)
          .eq('id_pedido', pedidoActivo.id_pedido)
        if (pedidoError) throw pedidoError

        await guardarDetallesEdicion(pedidoActivo.id_pedido)
      } else {
        const { data: nuevoPedido, error: pedidoError } = await supabase
          .from('pedido')
          .insert(pedidoPayload)
          .select('id_pedido')
          .single()

        if (pedidoError) throw pedidoError

        const detallesPayload = form.detalles.map((d) => ({
          id_pedido: nuevoPedido.id_pedido,
          tipo_prenda: d.tipo_prenda,
          cant_prendas: Number(d.cant_prendas) || 0,
          obs_detalle: d.obs_detalle || null,
        }))

        const { data: nuevosDetalles, error: detalleError } = await supabase
          .from('detalle_pedido')
          .insert(detallesPayload)
          .select('id_detalle')
        if (detalleError) throw detalleError

        for (let i = 0; i < form.detalles.length; i += 1) {
          await syncTrabajoAsignaciones(nuevosDetalles[i].id_detalle, form.detalles[i], [])
        }
      }

      cerrarModal()
      await Promise.all([fetchPedidos(), fetchClientes(), fetchUsuarios()])
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el pedido.')
    } finally {
      setSubmitting(false)
    }
  }

  const confirmarEliminar = async () => {
    if (!pedidoActivo || soloPropios) return

    setDeleting(true)
    setDeleteError(null)

    const { error: detalleError } = await supabase
      .from('detalle_pedido')
      .delete()
      .eq('id_pedido', pedidoActivo.id_pedido)

    if (detalleError) {
      setDeleteError(detalleError.message)
      setDeleting(false)
      return
    }

    const { error } = await supabase.from('pedido').delete().eq('id_pedido', pedidoActivo.id_pedido)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    setPedidos((prev) => prev.filter((p) => p.id_pedido !== pedidoActivo.id_pedido))
    cerrarModal()
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
        {!soloPropios && (
          <button type="button" onClick={abrirCrear}>
            Nuevo pedido
          </button>
        )}
      </div>

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
              <th>Responsable</th>
              <th>Estado</th>
              <th>Acciones</th>
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
                  {getResponsables(pedido).length ? getResponsables(pedido).join(', ') : '—'}
                </td>
                <td>
                  <select
                    className="estado-select"
                    value={pedido.estado_pedido ?? ''}
                    onChange={(e) => handleEstadoChange(pedido.id_pedido, e.target.value)}
                  >
                    {!ESTADOS_PEDIDO.includes(pedido.estado_pedido) && (
                      <option value={pedido.estado_pedido ?? ''} disabled>
                        {pedido.estado_pedido || 'Sin estado'}
                      </option>
                    )}
                    {ESTADOS_PEDIDO.map((estado) => (
                      <option key={estado} value={estado}>
                        {estado}
                      </option>
                    ))}
                  </select>
                </td>
                <td className="usuarios-actions">
                  <button
                    type="button"
                    className="icon-btn"
                    title="Ver"
                    aria-label="Ver pedido"
                    onClick={() => abrirVer(pedido)}
                  >
                    <IconEye />
                  </button>
                  {!soloPropios && (
                    <>
                      <button
                        type="button"
                        className="icon-btn"
                        title="Editar"
                        aria-label="Editar pedido"
                        onClick={() => abrirEditar(pedido)}
                      >
                        <IconPencil />
                      </button>
                      <button
                        type="button"
                        className="icon-btn icon-btn-danger"
                        title="Eliminar"
                        aria-label="Eliminar pedido"
                        onClick={() => abrirEliminar(pedido)}
                      >
                        <IconTrash />
                      </button>
                    </>
                  )}
                </td>
              </tr>
            ))}
            {pedidos.length === 0 && (
              <tr>
                <td colSpan={8}>Todavía no hay pedidos registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nuevo pedido' : 'Editar pedido'}</h2>
            <form className="pedido-form" onSubmit={handleSubmit}>
              <fieldset>
                <legend>Cliente</legend>
                <div className="cliente-mode-toggle">
                  <label className="radio-label">
                    <input
                      type="radio"
                      name="clienteMode"
                      checked={form.clienteMode === 'existing'}
                      onChange={() => setForm((prev) => ({ ...prev, clienteMode: 'existing' }))}
                    />
                    Cliente existente
                  </label>
                  <label className="radio-label">
                    <input
                      type="radio"
                      name="clienteMode"
                      checked={form.clienteMode === 'new'}
                      onChange={() => setForm((prev) => ({ ...prev, clienteMode: 'new' }))}
                    />
                    Cliente nuevo
                  </label>
                </div>

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
                      required
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
                  <div className="date-field">
                    <input
                      type="date"
                      value={form.fec_ini}
                      max={form.fec_ter || undefined}
                      onChange={(e) => {
                        const fec_ini = e.target.value
                        setForm((prev) => ({
                          ...prev,
                          fec_ini,
                          fec_ter: prev.fec_ter && prev.fec_ter < fec_ini ? '' : prev.fec_ter,
                        }))
                      }}
                    />
                    {form.fec_ini && (
                      <button
                        type="button"
                        className="date-clear-btn"
                        aria-label="Borrar fecha de inicio"
                        onClick={() => setForm((prev) => ({ ...prev, fec_ini: '' }))}
                      >
                        ×
                      </button>
                    )}
                  </div>
                </label>
                <label>
                  Fecha término
                  <div className="date-field">
                    <input
                      type="date"
                      value={form.fec_ter}
                      min={form.fec_ini || undefined}
                      onChange={(e) => setForm((prev) => ({ ...prev, fec_ter: e.target.value }))}
                    />
                    {form.fec_ter && (
                      <button
                        type="button"
                        className="date-clear-btn"
                        aria-label="Borrar fecha de término"
                        onClick={() => setForm((prev) => ({ ...prev, fec_ter: '' }))}
                      >
                        ×
                      </button>
                    )}
                  </div>
                </label>
                <label>
                  Estado
                  <select
                    className="estado-select"
                    value={form.estado_pedido}
                    onChange={(e) => setForm((prev) => ({ ...prev, estado_pedido: e.target.value }))}
                  >
                    {ESTADOS_PEDIDO.map((estado) => (
                      <option key={estado} value={estado}>
                        {estado}
                      </option>
                    ))}
                  </select>
                </label>
              </fieldset>

              <fieldset>
                <legend>Detalle de prendas</legend>
                {form.detalles.map((detalle, index) => (
                  <div className="detalle-item" key={detalle.id_detalle ?? index}>
                    <div className="detalle-row">
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
                    <div className="detalle-asignacion">
                      <label>
                        Cortadora
                        <select
                          value={detalle.id_usu_corte}
                          onChange={(e) => handleDetalleChange(index, 'id_usu_corte', e.target.value)}
                        >
                          <option value="">Sin asignar</option>
                          {cortadoras.map((u) => (
                            <option key={u.id_usu} value={u.id_usu}>
                              {u.nom_usuario} {u.ape_usuario}
                            </option>
                          ))}
                        </select>
                      </label>
                      <label>
                        Operaria (armado)
                        <select
                          value={detalle.id_usu_armado}
                          onChange={(e) => handleDetalleChange(index, 'id_usu_armado', e.target.value)}
                        >
                          <option value="">Sin asignar</option>
                          {operarias.map((u) => (
                            <option key={u.id_usu} value={u.id_usu}>
                              {u.nom_usuario} {u.ape_usuario}
                            </option>
                          ))}
                        </select>
                      </label>
                    </div>
                  </div>
                ))}
                <button type="button" className="link-btn" onClick={addDetalle}>
                  + Agregar línea
                </button>
              </fieldset>

              {formError && <p className="form-error">{formError}</p>}

              <div className="modal-actions">
                <button type="button" className="btn-secondary" onClick={cerrarModal}>
                  Cancelar
                </button>
                <button type="submit" disabled={submitting}>
                  {submitting ? 'Guardando...' : 'Guardar pedido'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {modo === 'ver' && pedidoActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>Detalle del pedido</h2>
            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">ID</span>
                <span className="detalle-value">{pedidoActivo.id_pedido}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Cliente</span>
                <span className="detalle-value">
                  {pedidoActivo.cliente
                    ? `${pedidoActivo.cliente.nom_cli} (${pedidoActivo.cliente.num_cli})`
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha inicio</span>
                <span className="detalle-value">{pedidoActivo.fec_ini ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha término</span>
                <span className="detalle-value">{pedidoActivo.fec_ter ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Estado</span>
                <span className="detalle-value">{pedidoActivo.estado_pedido ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Responsable(s)</span>
                <span className="detalle-value">
                  {getResponsables(pedidoActivo).length
                    ? getResponsables(pedidoActivo).join(', ')
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Prendas</span>
                <span className="detalle-value">
                  {pedidoActivo.detalle_pedido?.length ? (
                    <ul className="detalle-prendas-list">
                      {pedidoActivo.detalle_pedido.map((d) => {
                        const trabajoCorte = d.trabajo?.find((t) => t.tipo_trabajo === 'corte')
                        const trabajoArmado = d.trabajo?.find((t) => t.tipo_trabajo === 'armado')
                        return (
                          <li key={d.id_detalle}>
                            {d.cant_prendas}x {d.tipo_prenda}
                            {d.obs_detalle ? ` — ${d.obs_detalle}` : ''}
                            <br />
                            <small>
                              Corte:{' '}
                              {trabajoCorte?.usuario
                                ? `${trabajoCorte.usuario.nom_usuario} ${trabajoCorte.usuario.ape_usuario} (${trabajoCorte.estado})`
                                : 'sin asignar'}
                              {' · '}
                              Armado:{' '}
                              {trabajoArmado?.usuario
                                ? `${trabajoArmado.usuario.nom_usuario} ${trabajoArmado.usuario.ape_usuario} (${trabajoArmado.estado})`
                                : 'sin asignar'}
                            </small>
                          </li>
                        )
                      })}
                    </ul>
                  ) : (
                    '—'
                  )}
                </span>
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

      {modo === 'eliminar' && pedidoActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar pedido</h2>
            <p>
              ¿Seguro que deseas eliminar el pedido #{pedidoActivo.id_pedido}
              {pedidoActivo.cliente ? ` de ` : ''}
              {pedidoActivo.cliente && <strong>{pedidoActivo.cliente.nom_cli}</strong>}?
            </p>
            <p className="modal-hint">Esta acción no se puede deshacer y eliminará también su detalle de prendas.</p>

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
