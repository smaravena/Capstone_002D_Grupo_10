import { useRef, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { descargarReportePdf } from '../lib/reportePdf'

// Botón flotante (esquina inferior derecha) que abre el reporte semanal
// generado por Gemini. Se muestra solo a los roles de ROLES_REPORTE_IA
// (ver Layout.jsx). La llamada a Gemini ocurre en la Edge Function
// `reporte-semanal`; la API key nunca llega al navegador.

const formatoCLP = new Intl.NumberFormat('es-CL', {
  style: 'currency',
  currency: 'CLP',
  maximumFractionDigits: 0,
})

// Días que se guarda cada reporte. Debe coincidir con el cron
// `limpiar-reportes-semanales` de Supabase, que borra los más antiguos.
const DIAS_RETENCION = 60

const fechaCorta = (iso) =>
  new Date(iso).toLocaleDateString('es-CL', { day: '2-digit', month: '2-digit' })

const etiquetaReporte = (r) =>
  `${fechaCorta(r.fecha_desde)} al ${fechaCorta(r.fecha_hasta)} · generado ${new Date(
    r.created_at,
  ).toLocaleString('es-CL', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' })}`

const sumarValores = (obj) => Object.values(obj ?? {}).reduce((acc, n) => acc + Number(n || 0), 0)

function indicadores(metricas) {
  const actual = metricas?.semana_actual ?? {}
  const anterior = metricas?.semana_anterior ?? {}
  const monto = (m) =>
    Number(m.pedidos?.monto_estimado || 0) + Number(m.servicios?.monto_estimado || 0)

  return [
    {
      label: 'Pedidos nuevos',
      valor: actual.pedidos?.creados ?? 0,
      previo: anterior.pedidos?.creados ?? 0,
    },
    {
      label: 'Monto estimado',
      valor: monto(actual),
      previo: monto(anterior),
      formato: (n) => formatoCLP.format(n),
    },
    {
      label: 'Trabajos terminados',
      valor: sumarValores(actual.produccion?.trabajos_terminados),
      previo: sumarValores(anterior.produccion?.trabajos_terminados),
    },
    {
      label: 'Pedidos atrasados',
      valor: actual.estado_actual?.pedidos_atrasados ?? 0,
    },
  ]
}

function Variacion({ valor, previo }) {
  if (previo === undefined) return <span className="reporte-ia-kpi-delta">hoy</span>
  const diff = valor - previo
  if (diff === 0) return <span className="reporte-ia-kpi-delta">= sem. anterior</span>
  return (
    <span className={`reporte-ia-kpi-delta ${diff > 0 ? 'sube' : 'baja'}`}>
      {diff > 0 ? '▲' : '▼'} vs {previo.toLocaleString('es-CL')}
    </span>
  )
}

async function mensajeDeError(error) {
  try {
    const body = await error.context?.json()
    if (body?.error) return body.error
  } catch {
    // La respuesta no era JSON; usamos el mensaje genérico
  }
  return error.message ?? 'No se pudo generar el reporte.'
}

export default function ReporteIA() {
  const [abierto, setAbierto] = useState(false)
  const [reporte, setReporte] = useState(null)
  const [historial, setHistorial] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [generando, setGenerando] = useState(false)
  const [error, setError] = useState(null)
  const [exportando, setExportando] = useState(false)
  const panelRef = useRef(null)

  const cargarReporte = async (id) => {
    setCargando(true)
    setError(null)
    const { data, error: err } = await supabase
      .from('reporte_semanal')
      .select('*')
      .eq('id_reporte', id)
      .single()
    if (err) setError(err.message)
    else setReporte(data)
    setCargando(false)
  }

  // Lista de reportes guardados (solo los de los últimos DIAS_RETENCION días;
  // los más antiguos los borra el cron de Supabase) y abre el más reciente.
  const cargarHistorial = async () => {
    setCargando(true)
    setError(null)
    const limite = new Date(Date.now() - DIAS_RETENCION * 24 * 60 * 60 * 1000).toISOString()
    const { data, error: err } = await supabase
      .from('reporte_semanal')
      .select('id_reporte, fecha_desde, fecha_hasta, created_at')
      .eq('estado', 'ok')
      .gte('created_at', limite)
      .order('created_at', { ascending: false })

    if (err) {
      setError(err.message)
      setCargando(false)
      return
    }
    setHistorial(data)
    if (data.length > 0) await cargarReporte(data[0].id_reporte)
    else setCargando(false)
  }

  const alternarPanel = () => {
    if (!abierto && !historial && !cargando) cargarHistorial()
    setAbierto((v) => !v)
  }

  const generar = async () => {
    setGenerando(true)
    setError(null)
    const { data, error: err } = await supabase.functions.invoke('reporte-semanal', { method: 'POST' })
    if (err) {
      setError(await mensajeDeError(err))
    } else {
      const { id_reporte, fecha_desde, fecha_hasta, created_at } = data.reporte
      setReporte(data.reporte)
      setHistorial((prev) => [{ id_reporte, fecha_desde, fecha_hasta, created_at }, ...(prev ?? [])])
    }
    setGenerando(false)
  }

  const descargarPdf = async () => {
    if (!panelRef.current) return
    setExportando(true)
    setError(null)
    try {
      await descargarReportePdf(panelRef.current, reporte)
    } catch (err) {
      setError(`No se pudo generar el PDF: ${err.message}`)
    } finally {
      setExportando(false)
    }
  }

  const contenido = reporte?.contenido

  return (
    <>
      <button
        type="button"
        className="reporte-ia-fab"
        onClick={alternarPanel}
        aria-label={abierto ? 'Cerrar reporte semanal' : 'Abrir reporte semanal con IA'}
        aria-expanded={abierto}
        title="Reporte semanal con IA"
      >
        {abierto ? (
          '✕'
        ) : (
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 3l1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9L12 3Z" />
            <path d="M19 15l.8 2.2L22 18l-2.2.8L19 21l-.8-2.2L16 18l2.2-.8L19 15Z" />
          </svg>
        )}
      </button>

      {abierto && (
        <section ref={panelRef} className="reporte-ia-panel" aria-label="Reporte semanal con IA">
          <header className="reporte-ia-header">
            <div>
              <h2>Reporte semanal</h2>
              {reporte && (
                <p className="reporte-ia-periodo">
                  {new Date(reporte.fecha_desde).toLocaleDateString('es-CL')} –{' '}
                  {new Date(reporte.fecha_hasta).toLocaleDateString('es-CL')} · generado{' '}
                  {new Date(reporte.created_at).toLocaleString('es-CL')}
                </p>
              )}
            </div>
            {/* Los botones no aparecen en el PDF */}
            <div className="reporte-ia-acciones" data-html2canvas-ignore="true">
              {reporte && !generando && (
                <button
                  type="button"
                  className="btn-secondary"
                  onClick={descargarPdf}
                  disabled={exportando || cargando}
                  title="Descargar este reporte en PDF"
                >
                  {exportando ? 'Creando PDF…' : 'PDF'}
                </button>
              )}
              <button
                type="button"
                className="btn-primary"
                onClick={generar}
                disabled={generando || exportando}
                title="Analiza los últimos 7 días y guarda un reporte nuevo"
              >
                {generando ? 'Analizando…' : reporte ? 'Nuevo' : 'Generar'}
              </button>
            </div>
          </header>

          {historial?.length > 0 && (
            <div className="reporte-ia-historial" data-html2canvas-ignore="true">
              <label htmlFor="reporte-ia-historial">Reportes guardados</label>
              <select
                id="reporte-ia-historial"
                value={reporte?.id_reporte ?? ''}
                onChange={(e) => cargarReporte(Number(e.target.value))}
                disabled={cargando || generando || exportando}
              >
                {historial.map((r) => (
                  <option key={r.id_reporte} value={r.id_reporte}>
                    {etiquetaReporte(r)}
                  </option>
                ))}
              </select>
              <span>Se conservan {DIAS_RETENCION} días.</span>
            </div>
          )}

          <div className="reporte-ia-body">
            {error && <p className="form-error">{error}</p>}
            {cargando && <p>Cargando reporte…</p>}
            {generando && <p>Gemini está analizando la semana del taller. Puede tardar unos segundos.</p>}

            {!cargando && !generando && !reporte && !error && (
              <p>
                Aún no hay reportes. Presiona <strong>Generar</strong> para analizar los últimos 7 días
                del taller.
              </p>
            )}

            {reporte && !generando && !cargando && (
              <>
                <div className="reporte-ia-kpis">
                  {indicadores(reporte.metricas).map((kpi) => (
                    <div key={kpi.label} className="reporte-ia-kpi">
                      <span className="reporte-ia-kpi-label">{kpi.label}</span>
                      <strong>{kpi.formato ? kpi.formato(kpi.valor) : kpi.valor.toLocaleString('es-CL')}</strong>
                      <Variacion valor={kpi.valor} previo={kpi.previo} />
                    </div>
                  ))}
                </div>

                {contenido?.resumen && <p className="reporte-ia-resumen">{contenido.resumen}</p>}

                {contenido?.hallazgos?.length > 0 && (
                  <>
                    <h3>Hallazgos</h3>
                    <ul className="reporte-ia-hallazgos">
                      {contenido.hallazgos.map((h, i) => (
                        <li key={i} className={`reporte-ia-hallazgo ${h.tipo}`}>
                          <strong>{h.titulo}</strong>
                          <span>{h.detalle}</span>
                        </li>
                      ))}
                    </ul>
                  </>
                )}

                {contenido?.recomendaciones?.length > 0 && (
                  <>
                    <h3>Recomendaciones</h3>
                    <ul>
                      {contenido.recomendaciones.map((r, i) => (
                        <li key={i}>{r}</li>
                      ))}
                    </ul>
                  </>
                )}

                {contenido?.riesgos?.length > 0 && (
                  <>
                    <h3>Riesgos</h3>
                    <ul>
                      {contenido.riesgos.map((r, i) => (
                        <li key={i}>{r}</li>
                      ))}
                    </ul>
                  </>
                )}

                <p className="reporte-ia-nota">
                  Los indicadores se calculan desde la base de datos; el análisis lo redacta IA
                  ({reporte.modelo}) y puede contener errores de interpretación.
                </p>
              </>
            )}
          </div>
        </section>
      )}
    </>
  )
}
