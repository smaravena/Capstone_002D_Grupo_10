import { useEffect, useMemo, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ESTADOS_PEDIDO } from '../lib/pedidoConstants'
import {
  MAX_DIGITOS_PRECIO,
  construirCelular,
  limpiarPrecio,
  soloErrores,
  validarCelular,
  validarCorreo,
  validarPrecio,
  validarTexto,
} from '../lib/validators'
import { IconEye, IconPencil, IconTrash } from '../components/Icons'
import FieldError from '../components/FieldError'
import TelefonoInput from '../components/TelefonoInput'
import { useValidacion } from '../hooks/useValidacion'
import iconoTaller from '../assets/icono.png'

const emptyDetalle = () => ({
  tipo_servicio: '',
  precio: '',
  obs_detalle: '',
})

const emptyForm = () => ({
  clienteMode: 'existing',
  id_cli: '',
  nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
  fec_ini: '',
  fec_ter: '',
  estado_servicio: ESTADOS_PEDIDO[0],
  abono: '',
  detalles: [emptyDetalle()],
})

const formatPrecio = (valor) =>
  new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }).format(valor)

export default function Servicios() {
  const [servicios, setServicios] = useState([])
  const [clientes, setClientes] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'crear' | 'editar' | 'ver' | 'eliminar' | null
  const [servicioActivo, setServicioActivo] = useState(null)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  // Clientes ordenados por cantidad de servicios (el más frecuente primero).
  const clientesOrdenados = useMemo(() => {
    const conteo = new Map()
    servicios.forEach((s) => {
      if (s.cliente?.id_cli) conteo.set(s.cliente.id_cli, (conteo.get(s.cliente.id_cli) ?? 0) + 1)
    })
    return [...clientes].sort((a, b) => {
      const diff = (conteo.get(b.id_cli) ?? 0) - (conteo.get(a.id_cli) ?? 0)
      return diff !== 0 ? diff : a.nom_cli.localeCompare(b.nom_cli)
    })
  }, [clientes, servicios])

  const fetchServicios = async () => {
    const { data, error } = await supabase
      .from('servicio')
      .select(
        'id_servicio, fec_ini, fec_ter, estado_servicio, abono, created_at, cliente:id_cli ( id_cli, nom_cli, num_cli, correo_cli ), detalle_servicio ( id_detalle, tipo_servicio, precio, obs_detalle )',
      )
      .order('created_at', { ascending: false })

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setServicios(data)
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
    // Carga inicial de datos: el setState ocurre dentro de fetchServicios/fetchClientes
    // después del await a Supabase, no de forma síncrona.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    Promise.all([fetchServicios(), fetchClientes()]).then(() => setLoading(false))
  }, [])

  const handleDetalleChange = (index, field, value) => {
    tocar(`detalles.${index}.${field}`)
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
    setForm(emptyForm())
    setFormError(null)
    reiniciar()
    setServicioActivo(null)
    setModo('crear')
  }

  const abrirVer = (servicio) => {
    setServicioActivo(servicio)
    setModo('ver')
  }

  const abrirEditar = (servicio) => {
    setForm({
      clienteMode: 'existing',
      id_cli: servicio.cliente?.id_cli ? String(servicio.cliente.id_cli) : '',
      nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
      fec_ini: servicio.fec_ini ?? '',
      fec_ter: servicio.fec_ter ?? '',
      estado_servicio: ESTADOS_PEDIDO.includes(servicio.estado_servicio)
        ? servicio.estado_servicio
        : ESTADOS_PEDIDO[0],
      abono: servicio.abono != null ? String(servicio.abono) : '',
      detalles: servicio.detalle_servicio?.length
        ? servicio.detalle_servicio.map((d) => ({
            id_detalle: d.id_detalle,
            tipo_servicio: d.tipo_servicio,
            precio: d.precio != null ? String(d.precio) : '',
            obs_detalle: d.obs_detalle ?? '',
          }))
        : [emptyDetalle()],
    })
    setFormError(null)
    reiniciar()
    setServicioActivo(servicio)
    setModo('editar')
  }

  const abrirEliminar = (servicio) => {
    setServicioActivo(servicio)
    setDeleteError(null)
    setModo('eliminar')
  }

  const cerrarModal = () => {
    setModo(null)
    setServicioActivo(null)
    setForm(emptyForm())
    setFormError(null)
    setDeleteError(null)
  }

  const validarServicio = (valores) => {
    const errores = {}

    if (valores.clienteMode === 'existing') {
      if (!valores.id_cli) errores.id_cli = 'Selecciona un cliente.'
    } else {
      const { nom_cli, num_cli, correo_cli } = valores.nuevoCliente
      errores.nom_cli = validarTexto(nom_cli, 'el nombre del cliente')
      errores.num_cli = validarCelular(num_cli)
      errores.correo_cli = validarCorreo(correo_cli, { obligatorio: false })
    }

    if (!valores.fec_ini) errores.fec_ini = 'Falta la fecha de inicio.'
    if (!valores.fec_ter) {
      errores.fec_ter = 'Falta la fecha de término.'
    } else if (valores.fec_ini && valores.fec_ter < valores.fec_ini) {
      errores.fec_ter = 'La fecha de término no puede ser anterior a la fecha de inicio.'
    }

    if (valores.abono !== '' && (!Number.isFinite(Number(valores.abono)) || Number(valores.abono) < 0)) {
      errores.abono = 'Ingresa un abono válido.'
    }

    if (!ESTADOS_PEDIDO.includes(valores.estado_servicio)) {
      errores.estado_servicio = 'Selecciona un estado válido de la lista.'
    }

    valores.detalles.forEach((detalle, index) => {
      const campo = (nombre) => `detalles.${index}.${nombre}`
      if (!detalle.tipo_servicio.trim()) errores[campo('tipo_servicio')] = 'Indica el tipo de servicio.'
      errores[campo('precio')] = validarPrecio(detalle.precio)
    })

    return soloErrores(errores)
  }

  const { errorDe, tocar, validarEnvio, reiniciar } = useValidacion(validarServicio, form)

  const cambiarNuevoCliente = (campo, valor) => {
    setForm((prev) => ({ ...prev, nuevoCliente: { ...prev.nuevoCliente, [campo]: valor } }))
    tocar(campo)
  }

  const guardarDetallesEdicion = async (id_servicio) => {
    const originalIds = servicioActivo.detalle_servicio?.map((d) => d.id_detalle) ?? []
    const currentIds = form.detalles.filter((d) => d.id_detalle).map((d) => d.id_detalle)
    const idsToDelete = originalIds.filter((id) => !currentIds.includes(id))

    if (idsToDelete.length > 0) {
      const { error } = await supabase.from('detalle_servicio').delete().in('id_detalle', idsToDelete)
      if (error) throw error
    }

    const toUpdate = form.detalles.filter((d) => d.id_detalle)
    for (const detalle of toUpdate) {
      const { error } = await supabase
        .from('detalle_servicio')
        .update({
          tipo_servicio: detalle.tipo_servicio,
          precio: detalle.precio !== '' ? Number(detalle.precio) : null,
          obs_detalle: detalle.obs_detalle || null,
        })
        .eq('id_detalle', detalle.id_detalle)
      if (error) throw error
    }

    const toInsert = form.detalles.filter((d) => !d.id_detalle)
    if (toInsert.length > 0) {
      const { error } = await supabase.from('detalle_servicio').insert(
        toInsert.map((detalle) => ({
          id_servicio,
          tipo_servicio: detalle.tipo_servicio,
          precio: detalle.precio !== '' ? Number(detalle.precio) : null,
          obs_detalle: detalle.obs_detalle || null,
        })),
      )
      if (error) throw error
    }
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    if (!validarEnvio()) {
      setFormError('Revisa los campos marcados en rojo.')
      return
    }

    setSubmitting(true)
    try {
      let id_cli = form.id_cli

      if (form.clienteMode === 'new') {
        const { data: nuevoCliente, error: clienteError } = await supabase
          .from('cliente')
          .insert({
            nom_cli: form.nuevoCliente.nom_cli.trim(),
            num_cli: construirCelular(form.nuevoCliente.num_cli),
            correo_cli: form.nuevoCliente.correo_cli.trim() || null,
          })
          .select('id_cli')
          .single()

        if (clienteError) throw clienteError
        id_cli = nuevoCliente.id_cli
      }

      if (!id_cli) {
        throw new Error('Selecciona o crea un cliente para el servicio.')
      }

      const servicioPayload = {
        id_cli,
        fec_ini: form.fec_ini || null,
        fec_ter: form.fec_ter || null,
        estado_servicio: form.estado_servicio,
        abono: form.abono !== '' ? Number(form.abono) : null,
      }

      if (modo === 'editar' && servicioActivo) {
        const { error: servicioError } = await supabase
          .from('servicio')
          .update(servicioPayload)
          .eq('id_servicio', servicioActivo.id_servicio)
        if (servicioError) throw servicioError

        await guardarDetallesEdicion(servicioActivo.id_servicio)
      } else {
        const { data: nuevoServicio, error: servicioError } = await supabase
          .from('servicio')
          .insert(servicioPayload)
          .select('id_servicio')
          .single()

        if (servicioError) throw servicioError

        const detallesPayload = form.detalles.map((d) => ({
          id_servicio: nuevoServicio.id_servicio,
          tipo_servicio: d.tipo_servicio,
          precio: d.precio !== '' ? Number(d.precio) : null,
          obs_detalle: d.obs_detalle || null,
        }))

        const { error: detalleError } = await supabase.from('detalle_servicio').insert(detallesPayload)
        if (detalleError) throw detalleError
      }

      cerrarModal()
      await Promise.all([fetchServicios(), fetchClientes()])
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el servicio.')
    } finally {
      setSubmitting(false)
    }
  }

  const confirmarEliminar = async () => {
    if (!servicioActivo) return

    setDeleting(true)
    setDeleteError(null)

    const { error: detalleError } = await supabase
      .from('detalle_servicio')
      .delete()
      .eq('id_servicio', servicioActivo.id_servicio)

    if (detalleError) {
      setDeleteError(detalleError.message)
      setDeleting(false)
      return
    }

    const { error } = await supabase.from('servicio').delete().eq('id_servicio', servicioActivo.id_servicio)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    setServicios((prev) => prev.filter((s) => s.id_servicio !== servicioActivo.id_servicio))
    cerrarModal()
  }

  const handleEstadoChange = async (id_servicio, estado_servicio) => {
    const { error } = await supabase.from('servicio').update({ estado_servicio }).eq('id_servicio', id_servicio)
    if (error) {
      setLoadError(error.message)
      return
    }
    setServicios((prev) =>
      prev.map((s) => (s.id_servicio === id_servicio ? { ...s, estado_servicio } : s)),
    )
  }

  return (
    <div className="pedidos-page">
      <div className="pedidos-header">
        <h1 className="page-title">
          Ingreso y Control de Servicios
          <img src={iconoTaller} alt="" className="page-title-icon" />
        </h1>
        <button type="button" onClick={abrirCrear}>
          Nuevo servicio
        </button>
      </div>

      {loading && <p>Cargando servicios...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <table className="pedidos-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Cliente</th>
              <th>Inicio</th>
              <th>Término</th>
              <th>Servicios</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {servicios.map((servicio) => (
              <tr key={servicio.id_servicio}>
                <td data-label="#">{servicio.id_servicio}</td>
                <td data-label="Cliente">{servicio.cliente?.nom_cli ?? '—'}</td>
                <td data-label="Inicio">{servicio.fec_ini ?? '—'}</td>
                <td data-label="Término">{servicio.fec_ter ?? '—'}</td>
                <td data-label="Servicios">{servicio.detalle_servicio?.length ?? 0}</td>
                <td data-label="Estado">
                  <select
                    className="estado-select"
                    value={servicio.estado_servicio ?? ''}
                    onChange={(e) => handleEstadoChange(servicio.id_servicio, e.target.value)}
                  >
                    {!ESTADOS_PEDIDO.includes(servicio.estado_servicio) && (
                      <option value={servicio.estado_servicio ?? ''} disabled>
                        {servicio.estado_servicio || 'Sin estado'}
                      </option>
                    )}
                    {ESTADOS_PEDIDO.map((estado) => (
                      <option key={estado} value={estado}>
                        {estado}
                      </option>
                    ))}
                  </select>
                </td>
                <td className="usuarios-actions" data-label="Acciones">
                  <button
                    type="button"
                    className="icon-btn"
                    title="Ver"
                    aria-label="Ver servicio"
                    onClick={() => abrirVer(servicio)}
                  >
                    <IconEye />
                  </button>
                  <button
                    type="button"
                    className="icon-btn"
                    title="Editar"
                    aria-label="Editar servicio"
                    onClick={() => abrirEditar(servicio)}
                  >
                    <IconPencil />
                  </button>
                  <button
                    type="button"
                    className="icon-btn icon-btn-danger"
                    title="Eliminar"
                    aria-label="Eliminar servicio"
                    onClick={() => abrirEliminar(servicio)}
                  >
                    <IconTrash />
                  </button>
                </td>
              </tr>
            ))}
            {servicios.length === 0 && (
              <tr>
                <td colSpan={7} className="table-empty">Todavía no hay servicios registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nuevo servicio' : 'Editar servicio'}</h2>
            <form className="pedido-form" onSubmit={handleSubmit} noValidate>
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
                  <>
                    <select
                      value={form.id_cli}
                      onChange={(e) => {
                        setForm((prev) => ({ ...prev, id_cli: e.target.value }))
                        tocar('id_cli')
                      }}
                      aria-invalid={Boolean(errorDe('id_cli'))}
                    >
                      <option value="">Selecciona un cliente</option>
                      {clientesOrdenados.map((c) => (
                        <option key={c.id_cli} value={c.id_cli}>
                          {c.nom_cli}
                        </option>
                      ))}
                    </select>
                    <FieldError mensaje={errorDe('id_cli')} />
                  </>
                ) : (
                  <div className="cliente-nuevo-fields">
                    <div>
                      <input
                        placeholder="Nombre"
                        value={form.nuevoCliente.nom_cli}
                        onChange={(e) => cambiarNuevoCliente('nom_cli', e.target.value)}
                        aria-invalid={Boolean(errorDe('nom_cli'))}
                      />
                      <FieldError mensaje={errorDe('nom_cli')} />
                    </div>
                    <div>
                      <TelefonoInput
                        value={form.nuevoCliente.num_cli}
                        onChange={(valor) => cambiarNuevoCliente('num_cli', valor)}
                        invalid={Boolean(errorDe('num_cli'))}
                      />
                      <FieldError mensaje={errorDe('num_cli')} />
                    </div>
                    <div>
                      <input
                        placeholder="Correo"
                        type="email"
                        value={form.nuevoCliente.correo_cli}
                        onChange={(e) => cambiarNuevoCliente('correo_cli', e.target.value)}
                        aria-invalid={Boolean(errorDe('correo_cli'))}
                      />
                      <FieldError mensaje={errorDe('correo_cli')} />
                    </div>
                  </div>
                )}
              </fieldset>

              <fieldset>
                <legend>Servicio</legend>
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
                        tocar('fec_ini')
                      }}
                      aria-invalid={Boolean(errorDe('fec_ini'))}
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
                  <FieldError mensaje={errorDe('fec_ini')} />
                </label>
                <label>
                  Fecha término
                  <div className="date-field">
                    <input
                      type="date"
                      value={form.fec_ter}
                      min={form.fec_ini || undefined}
                      onChange={(e) => {
                        setForm((prev) => ({ ...prev, fec_ter: e.target.value }))
                        tocar('fec_ter')
                      }}
                      aria-invalid={Boolean(errorDe('fec_ter'))}
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
                  <FieldError mensaje={errorDe('fec_ter')} />
                </label>
                <label>
                  Estado
                  <select
                    className="estado-select"
                    value={form.estado_servicio}
                    onChange={(e) => setForm((prev) => ({ ...prev, estado_servicio: e.target.value }))}
                  >
                    {ESTADOS_PEDIDO.map((estado) => (
                      <option key={estado} value={estado}>
                        {estado}
                      </option>
                    ))}
                  </select>
                  <FieldError mensaje={errorDe('estado_servicio')} />
                </label>
                <label>
                  Abono (CLP) <span className="campo-opcional">(opcional)</span>
                  <input
                    type="number"
                    min="0"
                    step="100"
                    placeholder="Abono"
                    value={form.abono}
                    onChange={(e) => setForm((prev) => ({ ...prev, abono: e.target.value }))}
                    aria-invalid={Boolean(errorDe('abono'))}
                  />
                  <FieldError mensaje={errorDe('abono')} />
                </label>
              </fieldset>

              <fieldset>
                <legend>Detalle del servicio</legend>
                {form.detalles.map((detalle, index) => (
                  <div className="detalle-item" key={detalle.id_detalle ?? index}>
                    <div className="detalle-row">
                      <div>
                        <input
                          value={detalle.tipo_servicio}
                          onChange={(e) => handleDetalleChange(index, 'tipo_servicio', e.target.value)}
                          placeholder="Tipo de servicio"
                          aria-label="Tipo de servicio"
                          aria-invalid={Boolean(errorDe(`detalles.${index}.tipo_servicio`))}
                        />
                        <FieldError mensaje={errorDe(`detalles.${index}.tipo_servicio`)} />
                      </div>
                      <div>
                        <input
                          inputMode="numeric"
                          maxLength={MAX_DIGITOS_PRECIO}
                          placeholder="Precio (CLP)"
                          aria-label="Precio"
                          value={detalle.precio}
                          onChange={(e) => handleDetalleChange(index, 'precio', limpiarPrecio(e.target.value))}
                          aria-invalid={Boolean(errorDe(`detalles.${index}.precio`))}
                        />
                        <FieldError mensaje={errorDe(`detalles.${index}.precio`)} />
                      </div>
                      <button
                        type="button"
                        className="link-btn"
                        onClick={() => removeDetalle(index)}
                        disabled={form.detalles.length === 1}
                      >
                        Quitar
                      </button>
                    </div>
                    <textarea
                      className="detalle-observaciones"
                      placeholder="Observaciones (opcional)"
                      rows={2}
                      value={detalle.obs_detalle}
                      onChange={(e) => {
                        handleDetalleChange(index, 'obs_detalle', e.target.value)
                        e.target.style.height = 'auto'
                        e.target.style.height = `${e.target.scrollHeight}px`
                      }}
                    />
                  </div>
                ))}
                <button type="button" className="link-btn" onClick={addDetalle}>
                  + Agregar servicio
                </button>
              </fieldset>

              {formError && <p className="form-error">{formError}</p>}

              <div className="modal-actions">
                <button type="button" className="btn-secondary" onClick={cerrarModal}>
                  Cancelar
                </button>
                <button type="submit" disabled={submitting}>
                  {submitting ? 'Guardando...' : 'Guardar servicio'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {modo === 'ver' && servicioActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>Detalle del servicio</h2>
            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">ID</span>
                <span className="detalle-value">{servicioActivo.id_servicio}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Cliente</span>
                <span className="detalle-value">
                  {servicioActivo.cliente
                    ? `${servicioActivo.cliente.nom_cli} (${servicioActivo.cliente.num_cli})`
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha inicio</span>
                <span className="detalle-value">{servicioActivo.fec_ini ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha término</span>
                <span className="detalle-value">{servicioActivo.fec_ter ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Estado</span>
                <span className="detalle-value">{servicioActivo.estado_servicio ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Abono</span>
                <span className="detalle-value">
                  {servicioActivo.abono != null ? formatPrecio(servicioActivo.abono) : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Servicios</span>
                <span className="detalle-value">
                  {servicioActivo.detalle_servicio?.length ? (
                    <ul className="detalle-prendas-list">
                      {servicioActivo.detalle_servicio.map((d) => (
                        <li key={d.id_detalle}>
                          {d.tipo_servicio}
                          {d.precio != null ? ` — ${formatPrecio(d.precio)}` : ''}
                          {d.obs_detalle ? ` — ${d.obs_detalle}` : ''}
                        </li>
                      ))}
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

      {modo === 'eliminar' && servicioActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar servicio</h2>
            <p>
              ¿Seguro que deseas eliminar el servicio #{servicioActivo.id_servicio}
              {servicioActivo.cliente ? ` de ` : ''}
              {servicioActivo.cliente && <strong>{servicioActivo.cliente.nom_cli}</strong>}?
            </p>
            <p className="modal-hint">Esta acción no se puede deshacer y eliminará también su detalle.</p>

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
