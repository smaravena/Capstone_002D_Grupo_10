import { Fragment, useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ESTADOS_TRABAJO, TIPOS_TRABAJO, TIPO_TRABAJO_LABELS } from '../lib/trabajoConstants'
import { IconEye, IconTicket } from '../components/Icons'
import { useAuth } from '../hooks/useAuth'
import { ROLES } from '../lib/roles'
import iconoTaller from '../assets/icono.png'

// Convierte una fecha ISO a "dd/mm/aaaa HH:mm" en hora de Chile (America/Santiago),
// sin depender del separador por defecto del navegador/locale.
const formatFechaChile = (iso) => {
  if (!iso) return '—'
  const partes = new Intl.DateTimeFormat('es-CL', {
    timeZone: 'America/Santiago',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  }).formatToParts(new Date(iso))
  const obtener = (tipo) => partes.find((p) => p.type === tipo)?.value ?? ''
  return `${obtener('day')}/${obtener('month')}/${obtener('year')} ${obtener('hour')}:${obtener('minute')}`
}

// Agrupa las tareas por pedido para que la jefa vea un solo registro por
// pedido. Se mantiene el orden de llegada (asignación más reciente primero) y
// dentro de cada pedido las tareas quedan por prenda y luego corte → armado.
const agruparPorPedido = (trabajos) => {
  const grupos = new Map()
  trabajos.forEach((t) => {
    const pedido = t.detalle?.pedido
    const clave = pedido?.id_pedido ?? `sin-pedido-${t.id_trabajo}`
    if (!grupos.has(clave)) grupos.set(clave, { clave, pedido, trabajos: [] })
    grupos.get(clave).trabajos.push(t)
  })

  return [...grupos.values()].map((grupo) => ({
    ...grupo,
    trabajos: [...grupo.trabajos].sort(
      (a, b) =>
        (a.detalle?.id_detalle ?? 0) - (b.detalle?.id_detalle ?? 0) ||
        TIPOS_TRABAJO.indexOf(a.tipo_trabajo) - TIPOS_TRABAJO.indexOf(b.tipo_trabajo),
    ),
  }))
}

// Estado general del pedido según sus tareas.
const estadoDelGrupo = (trabajos) => {
  if (trabajos.every((t) => t.estado === 'terminado')) return 'terminado'
  if (trabajos.every((t) => t.estado === 'pendiente')) return 'pendiente'
  return 'en progreso'
}

export default function MisTrabajos() {
  const { usuario, role } = useAuth()
  const esJefa = role === ROLES.JEFA_TALLER

  const [trabajos, setTrabajos] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)
  const [trabajoActivo, setTrabajoActivo] = useState(null)
  const [trabajoAFinalizar, setTrabajoAFinalizar] = useState(null)
  const [finalizando, setFinalizando] = useState(false)
  const [ticketTrabajo, setTicketTrabajo] = useState(null)
  const [historialTrabajo, setHistorialTrabajo] = useState(null)
  const [historial, setHistorial] = useState([])
  const [cargandoHistorial, setCargandoHistorial] = useState(false)
  const [errorHistorial, setErrorHistorial] = useState(null)
  const [pedidosAbiertos, setPedidosAbiertos] = useState(() => new Set())

  const fetchTrabajos = async () => {
    if (!usuario?.id_usu) return

    let query = supabase
      .from('trabajo')
      .select(
        'id_trabajo, tipo_trabajo, estado, fecha_asignacion, fecha_termino, id_usu, usuario:id_usu ( nom_usuario, ape_usuario ), detalle:id_detalle ( id_detalle, tipo_prenda, cant_prendas, obs_detalle, pedido:id_pedido ( id_pedido, fec_ini, fec_ter, estado_pedido, cliente:id_cli ( nom_cli, num_cli ) ) )',
      )
      .order('fecha_asignacion', { ascending: false })

    // La jefa trae todas las tareas para calcular el avance completo de cada
    // pedido; los pedidos ya cerrados se filtran al agrupar.
    if (!esJefa) query = query.eq('id_usu', usuario.id_usu)

    const { data, error } = await query

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setTrabajos(data)
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchTrabajos().then(() => setLoading(false))
  }, [usuario?.id_usu, esJefa])

  // No bloqueamos el cambio de estado si el registro de historial falla: es
  // información auxiliar, no debe impedir que la tarea avance.
  const registrarHistorial = async (id_trabajo, estadoAnterior, estadoNuevo) => {
    const { error } = await supabase.from('trabajo_historial').insert({
      id_trabajo,
      id_usu: usuario?.id_usu ?? null,
      estado_anterior: estadoAnterior,
      estado_nuevo: estadoNuevo,
    })
    if (error) console.error('No se pudo registrar el historial del trabajo:', error)
  }

  const handleEstadoChange = async (trabajo, estado) => {
    const estadoAnterior = trabajo.estado
    const payload = { estado, fecha_termino: null }

    const { error } = await supabase.from('trabajo').update(payload).eq('id_trabajo', trabajo.id_trabajo)
    if (error) {
      setLoadError(error.message)
      return
    }

    await registrarHistorial(trabajo.id_trabajo, estadoAnterior, estado)

    setTrabajos((prev) =>
      prev.map((t) => (t.id_trabajo === trabajo.id_trabajo ? { ...t, ...payload } : t)),
    )
  }

  const onEstadoSelect = (trabajo, estado) => {
    if (estado === 'terminado') {
      setTrabajoAFinalizar(trabajo)
      return
    }
    handleEstadoChange(trabajo, estado)
  }

  const cancelarFinalizar = () => setTrabajoAFinalizar(null)

  const confirmarFinalizar = async () => {
    if (!trabajoAFinalizar) return

    setFinalizando(true)
    const estadoAnterior = trabajoAFinalizar.estado
    const payload = { estado: 'terminado', fecha_termino: new Date().toISOString() }

    const { error } = await supabase
      .from('trabajo')
      .update(payload)
      .eq('id_trabajo', trabajoAFinalizar.id_trabajo)

    if (error) {
      setFinalizando(false)
      setLoadError(error.message)
      setTrabajoAFinalizar(null)
      return
    }

    await registrarHistorial(trabajoAFinalizar.id_trabajo, estadoAnterior, 'terminado')
    setFinalizando(false)

    const trabajoFinalizado = { ...trabajoAFinalizar, ...payload }
    setTrabajos((prev) =>
      prev.map((t) => (t.id_trabajo === trabajoFinalizado.id_trabajo ? trabajoFinalizado : t)),
    )
    setTrabajoAFinalizar(null)
    setTicketTrabajo(trabajoFinalizado)
  }

  const abrirVer = (trabajo) => setTrabajoActivo(trabajo)
  const cerrarModal = () => setTrabajoActivo(null)
  const cerrarTicket = () => setTicketTrabajo(null)

  const abrirHistorial = async (trabajo) => {
    setHistorialTrabajo(trabajo)
    setCargandoHistorial(true)
    setErrorHistorial(null)

    const { data, error } = await supabase
      .from('trabajo_historial')
      .select(
        'id_historial, estado_anterior, estado_nuevo, fecha_cambio, usuario:id_usu ( nom_usuario, ape_usuario, rol_usu )',
      )
      .eq('id_trabajo', trabajo.id_trabajo)
      .order('fecha_cambio', { ascending: false })

    setCargandoHistorial(false)

    if (error) {
      setErrorHistorial(error.message)
      return
    }
    setHistorial(data ?? [])
  }

  const cerrarHistorial = () => {
    setHistorialTrabajo(null)
    setHistorial([])
    setErrorHistorial(null)
  }

  const togglePedido = (clave) =>
    setPedidosAbiertos((prev) => {
      const siguiente = new Set(prev)
      if (siguiente.has(clave)) siguiente.delete(clave)
      else siguiente.add(clave)
      return siguiente
    })

  // Igual que antes: la jefa ve los pedidos con tareas pendientes y aquellos
  // donde ella misma tiene tareas asignadas.
  const gruposVisibles = esJefa
    ? agruparPorPedido(trabajos).filter((g) =>
        g.trabajos.some((t) => t.estado !== 'terminado' || t.id_usu === usuario?.id_usu),
      )
    : []

  const nombreResponsable = (trabajo) =>
    trabajo.usuario ? `${trabajo.usuario.nom_usuario} ${trabajo.usuario.ape_usuario}` : '—'

  const renderEstado = (trabajo) =>
    trabajo.estado === 'terminado' ? (
      <span className="estado-badge estado-badge-terminado">Terminado</span>
    ) : (
      <select
        className="estado-select"
        value={trabajo.estado ?? ''}
        onChange={(e) => onEstadoSelect(trabajo, e.target.value)}
      >
        {!ESTADOS_TRABAJO.includes(trabajo.estado) && (
          <option value={trabajo.estado ?? ''} disabled>
            {trabajo.estado || 'Sin estado'}
          </option>
        )}
        {ESTADOS_TRABAJO.map((estado) => (
          <option key={estado} value={estado}>
            {estado}
          </option>
        ))}
      </select>
    )

  const renderAcciones = (trabajo) => (
    <>
      <button
        type="button"
        className="icon-btn"
        title="Ver"
        aria-label="Ver trabajo"
        onClick={() => abrirVer(trabajo)}
      >
        <IconEye />
      </button>
      {trabajo.estado === 'terminado' && (
        <button
          type="button"
          className="icon-btn"
          title="Ver ticket"
          aria-label="Ver ticket de finalización"
          onClick={() => setTicketTrabajo(trabajo)}
        >
          <IconTicket />
        </button>
      )}
    </>
  )

  return (
    <div className="pedidos-page">
      <div className="pedidos-header">
        <h1 className="page-title">
          {esJefa ? 'Trabajos' : 'Mis trabajos'}
          <img src={iconoTaller} alt="" className="page-title-icon" />
        </h1>
      </div>

      {loading && <p>Cargando trabajos...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && esJefa && (
        <table className="pedidos-table">
          <thead>
            <tr>
              <th>Pedido</th>
              <th>Cliente</th>
              <th>Prendas</th>
              <th>Entrega</th>
              <th>Avance</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            {gruposVisibles.map((grupo) => {
              const { clave, pedido } = grupo
              const abierto = pedidosAbiertos.has(clave)
              const terminadas = grupo.trabajos.filter((t) => t.estado === 'terminado').length
              const prendas = new Set(grupo.trabajos.map((t) => t.detalle?.id_detalle)).size
              const estado = estadoDelGrupo(grupo.trabajos)
              return (
                <Fragment key={clave}>
                  <tr className="trabajo-grupo-row" onClick={() => togglePedido(clave)}>
                    <td data-label="Pedido">
                      <button
                        type="button"
                        className="trabajo-grupo-toggle"
                        aria-expanded={abierto}
                        aria-label={`${abierto ? 'Ocultar' : 'Ver'} tareas del pedido ${pedido?.id_pedido ?? ''}`}
                        onClick={(e) => {
                          e.stopPropagation()
                          togglePedido(clave)
                        }}
                      >
                        <span className="trabajo-grupo-chevron" aria-hidden="true">
                          {abierto ? '▾' : '▸'}
                        </span>
                        #{pedido?.id_pedido ?? '—'}
                      </button>
                    </td>
                    <td data-label="Cliente">{pedido?.cliente?.nom_cli ?? '—'}</td>
                    <td data-label="Prendas">
                      {prendas} {prendas === 1 ? 'prenda' : 'prendas'}
                    </td>
                    <td data-label="Entrega">{pedido?.fec_ter ?? '—'}</td>
                    <td data-label="Avance">
                      {terminadas}/{grupo.trabajos.length} tareas
                    </td>
                    <td data-label="Estado">
                      <span className={`estado-badge estado-badge-${estado.replace(' ', '-')}`}>{estado}</span>
                    </td>
                  </tr>
                  {abierto && (
                    <tr className="trabajo-tareas-row">
                      <td colSpan={6}>
                        <ul className="trabajo-tareas">
                          {grupo.trabajos.map((trabajo) => (
                            <li key={trabajo.id_trabajo} className="trabajo-tarea">
                              <span className="trabajo-tarea-prenda">
                                {trabajo.detalle
                                  ? `${trabajo.detalle.cant_prendas}x ${trabajo.detalle.tipo_prenda}`
                                  : '—'}
                              </span>
                              <span className="trabajo-tarea-tipo">
                                {TIPO_TRABAJO_LABELS[trabajo.tipo_trabajo] ?? trabajo.tipo_trabajo}
                              </span>
                              <span className="trabajo-tarea-responsable">{nombreResponsable(trabajo)}</span>
                              <span className="trabajo-tarea-estado">{renderEstado(trabajo)}</span>
                              <span className="trabajo-tarea-acciones usuarios-actions">
                                {renderAcciones(trabajo)}
                              </span>
                            </li>
                          ))}
                        </ul>
                      </td>
                    </tr>
                  )}
                </Fragment>
              )
            })}
            {gruposVisibles.length === 0 && (
              <tr>
                <td colSpan={6} className="table-empty">
                  No hay trabajos activos en este momento.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {!loading && !loadError && !esJefa && (
        <table className="pedidos-table">
          <thead>
            <tr>
              <th>Pedido</th>
              <th>Cliente</th>
              <th>Prenda</th>
              <th>Tarea</th>
              <th>Asignado</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {trabajos.map((trabajo) => {
              const detalle = trabajo.detalle
              const pedido = detalle?.pedido
              return (
                <tr key={trabajo.id_trabajo}>
                  <td data-label="Pedido">{pedido?.id_pedido ?? '—'}</td>
                  <td data-label="Cliente">{pedido?.cliente?.nom_cli ?? '—'}</td>
                  <td data-label="Prenda">
                    {detalle ? `${detalle.cant_prendas}x ${detalle.tipo_prenda}` : '—'}
                  </td>
                  <td data-label="Tarea">{TIPO_TRABAJO_LABELS[trabajo.tipo_trabajo] ?? trabajo.tipo_trabajo}</td>
                  <td data-label="Asignado">
                    {trabajo.fecha_asignacion
                      ? new Date(trabajo.fecha_asignacion).toLocaleDateString()
                      : '—'}
                  </td>
                  <td data-label="Estado">{renderEstado(trabajo)}</td>
                  <td className="usuarios-actions" data-label="Acciones">
                    {renderAcciones(trabajo)}
                  </td>
                </tr>
              )
            })}
            {trabajos.length === 0 && (
              <tr>
                <td colSpan={7} className="table-empty">
                  No tienes trabajos asignados por el momento.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {trabajoActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>Detalle del trabajo</h2>
            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">Pedido</span>
                <span className="detalle-value">
                  #{trabajoActivo.detalle?.pedido?.id_pedido ?? '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Cliente</span>
                <span className="detalle-value">
                  {trabajoActivo.detalle?.pedido?.cliente
                    ? `${trabajoActivo.detalle.pedido.cliente.nom_cli} (${trabajoActivo.detalle.pedido.cliente.num_cli})`
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha inicio pedido</span>
                <span className="detalle-value">{trabajoActivo.detalle?.pedido?.fec_ini ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha término pedido</span>
                <span className="detalle-value">{trabajoActivo.detalle?.pedido?.fec_ter ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Prenda</span>
                <span className="detalle-value">
                  {trabajoActivo.detalle
                    ? `${trabajoActivo.detalle.cant_prendas}x ${trabajoActivo.detalle.tipo_prenda}`
                    : '—'}
                </span>
              </div>
              {esJefa && (
                <div className="detalle-field">
                  <span className="detalle-label">Responsable</span>
                  <span className="detalle-value">
                    {trabajoActivo.usuario
                      ? `${trabajoActivo.usuario.nom_usuario} ${trabajoActivo.usuario.ape_usuario}`
                      : '—'}
                  </span>
                </div>
              )}
              <div className="detalle-field">
                <span className="detalle-label">Observaciones</span>
                <span className="detalle-value">{trabajoActivo.detalle?.obs_detalle || '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Tarea</span>
                <span className="detalle-value">
                  {TIPO_TRABAJO_LABELS[trabajoActivo.tipo_trabajo] ?? trabajoActivo.tipo_trabajo}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Estado</span>
                <span className="detalle-value">{trabajoActivo.estado ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha asignación</span>
                <span className="detalle-value">
                  {trabajoActivo.fecha_asignacion
                    ? new Date(trabajoActivo.fecha_asignacion).toLocaleString()
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha término tarea</span>
                <span className="detalle-value">
                  {trabajoActivo.fecha_termino
                    ? new Date(trabajoActivo.fecha_termino).toLocaleString()
                    : '—'}
                </span>
              </div>
            </div>
            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={() => abrirHistorial(trabajoActivo)}>
                Historial de edición
              </button>
              <button type="button" className="btn-secondary" onClick={cerrarModal}>
                Cerrar
              </button>
            </div>
          </div>
        </div>
      )}

      {historialTrabajo && (
        <div className="modal-overlay" onClick={cerrarHistorial}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>Historial de edición</h2>
            <p className="modal-hint">
              Trabajo #{historialTrabajo.id_trabajo} —{' '}
              {TIPO_TRABAJO_LABELS[historialTrabajo.tipo_trabajo] ?? historialTrabajo.tipo_trabajo}
            </p>

            {cargandoHistorial && <p>Cargando historial...</p>}
            {errorHistorial && <p className="form-error">{errorHistorial}</p>}

            {!cargandoHistorial && !errorHistorial && (
              <ul className="historial-list">
                {historial.map((h) => (
                  <li key={h.id_historial} className="historial-item">
                    <div className="historial-cambio">
                      <strong>{h.estado_anterior ?? 'sin estado'}</strong>
                      <span aria-hidden="true"> → </span>
                      <strong>{h.estado_nuevo}</strong>
                    </div>
                    <div className="historial-meta">
                      {h.usuario
                        ? `${h.usuario.nom_usuario} ${h.usuario.ape_usuario} (${h.usuario.rol_usu ?? 'sin rol'})`
                        : 'Usuario desconocido'}
                      {' · '}
                      {formatFechaChile(h.fecha_cambio)}
                    </div>
                  </li>
                ))}
                {historial.length === 0 && <li className="historial-item">Todavía no hay cambios registrados.</li>}
              </ul>
            )}

            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cerrarHistorial}>
                Cerrar
              </button>
            </div>
          </div>
        </div>
      )}

      {trabajoAFinalizar && (
        <div className="modal-overlay" onClick={cancelarFinalizar}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Finalizar trabajo</h2>
            <p>¿Estás seguro de finalizar el trabajo?</p>
            <p className="modal-hint">
              Una vez finalizado no podrás volver a cambiar su estado.
            </p>

            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cancelarFinalizar}>
                Cancelar
              </button>
              <button
                type="button"
                className="btn-primary"
                disabled={finalizando}
                onClick={confirmarFinalizar}
              >
                {finalizando ? 'Finalizando...' : 'Finalizar'}
              </button>
            </div>
          </div>
        </div>
      )}

      {ticketTrabajo && (
        <div className="modal-overlay" onClick={cerrarTicket}>
          <div className="modal-card ticket-card" onClick={(e) => e.stopPropagation()}>
            <div className="ticket-check">✓</div>
            <h2>Trabajo finalizado</h2>
            <p className="ticket-numero">Ticket #{ticketTrabajo.id_trabajo}</p>

            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">Pedido</span>
                <span className="detalle-value">
                  #{ticketTrabajo.detalle?.pedido?.id_pedido ?? '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Cliente</span>
                <span className="detalle-value">
                  {ticketTrabajo.detalle?.pedido?.cliente?.nom_cli ?? '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Prenda</span>
                <span className="detalle-value">
                  {ticketTrabajo.detalle
                    ? `${ticketTrabajo.detalle.cant_prendas}x ${ticketTrabajo.detalle.tipo_prenda}`
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Tarea</span>
                <span className="detalle-value">
                  {TIPO_TRABAJO_LABELS[ticketTrabajo.tipo_trabajo] ?? ticketTrabajo.tipo_trabajo}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha finalización</span>
                <span className="detalle-value">
                  {ticketTrabajo.fecha_termino
                    ? new Date(ticketTrabajo.fecha_termino).toLocaleString()
                    : '—'}
                </span>
              </div>
            </div>

            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cerrarTicket}>
                Cerrar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
