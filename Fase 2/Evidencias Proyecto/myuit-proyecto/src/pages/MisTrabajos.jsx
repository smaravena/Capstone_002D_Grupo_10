import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ESTADOS_TRABAJO, TIPO_TRABAJO_LABELS } from '../lib/trabajoConstants'
import { IconEye } from '../components/Icons'
import { useAuth } from '../hooks/useAuth'

export default function MisTrabajos() {
  const { usuario } = useAuth()

  const [trabajos, setTrabajos] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)
  const [trabajoActivo, setTrabajoActivo] = useState(null)

  const fetchTrabajos = async () => {
    if (!usuario?.id_usu) return

    const { data, error } = await supabase
      .from('trabajo')
      .select(
        'id_trabajo, tipo_trabajo, estado, fecha_asignacion, fecha_termino, detalle:id_detalle ( id_detalle, tipo_prenda, cant_prendas, obs_detalle, pedido:id_pedido ( id_pedido, fec_ini, fec_ter, estado_pedido, cliente:id_cli ( nom_cli, num_cli ) ) )',
      )
      .eq('id_usu', usuario.id_usu)
      .order('fecha_asignacion', { ascending: false })

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
  }, [usuario?.id_usu])

  const handleEstadoChange = async (id_trabajo, estado) => {
    const payload = {
      estado,
      fecha_termino: estado === 'terminado' ? new Date().toISOString() : null,
    }

    const { error } = await supabase.from('trabajo').update(payload).eq('id_trabajo', id_trabajo)
    if (error) {
      setLoadError(error.message)
      return
    }

    setTrabajos((prev) =>
      prev.map((t) => (t.id_trabajo === id_trabajo ? { ...t, ...payload } : t)),
    )
  }

  const abrirVer = (trabajo) => setTrabajoActivo(trabajo)
  const cerrarModal = () => setTrabajoActivo(null)

  return (
    <div className="pedidos-page">
      <div className="pedidos-header">
        <h1>Mis trabajos</h1>
      </div>

      {loading && <p>Cargando trabajos...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
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
                  <td>{pedido?.id_pedido ?? '—'}</td>
                  <td>{pedido?.cliente?.nom_cli ?? '—'}</td>
                  <td>
                    {detalle ? `${detalle.cant_prendas}x ${detalle.tipo_prenda}` : '—'}
                  </td>
                  <td>{TIPO_TRABAJO_LABELS[trabajo.tipo_trabajo] ?? trabajo.tipo_trabajo}</td>
                  <td>
                    {trabajo.fecha_asignacion
                      ? new Date(trabajo.fecha_asignacion).toLocaleDateString()
                      : '—'}
                  </td>
                  <td>
                    <select
                      className="estado-select"
                      value={trabajo.estado ?? ''}
                      onChange={(e) => handleEstadoChange(trabajo.id_trabajo, e.target.value)}
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
                  </td>
                  <td className="usuarios-actions">
                    <button
                      type="button"
                      className="icon-btn"
                      title="Ver"
                      aria-label="Ver trabajo"
                      onClick={() => abrirVer(trabajo)}
                    >
                      <IconEye />
                    </button>
                  </td>
                </tr>
              )
            })}
            {trabajos.length === 0 && (
              <tr>
                <td colSpan={7}>No tienes trabajos asignados por el momento.</td>
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
              <button type="button" className="btn-secondary" onClick={cerrarModal}>
                Cerrar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
