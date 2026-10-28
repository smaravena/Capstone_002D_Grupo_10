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
  const [cargando, setCargando] = useState(false)
  const [generando, setGenerando] = useState(false)
  const [error, setError] = useState(null)
  const [exportando, setExportando] = useState(false)
  const panelRef = useRef(null)

  const cargarUltimo = async () => {
    setCargando(true)
    setError(null)
    const { data, error: err } = await supabase
      .from('reporte_semanal')
      .select('*')
      .eq('estado', 'ok')
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()
    if (err) setError(err.message)
    else setReporte(data)
    setCargando(false)
  }

  const alternarPanel = () => {
    if (!abierto && !reporte && !cargando) cargarUltimo()
    setAbierto((v) => !v)
  }

  const generar = async () => {
    setGenerando(true)
    setError(null)
    const { data, error: err } = await supabase.functions.invoke('reporte-semanal', { method: 'POST' })
    if (err) setError(await mensajeDeError(err))
    else setReporte(data.reporte)
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
                  disabled={exportando}
                  title="Descargar este reporte en PDF"
                >
                  {exportando ? 'Creando PDF…' : 'PDF'}
                </button>
              )}
              <button type="button" className="btn-primary" onClick={generar} disabled={generando || exportando}>
                {generando ? 'Analizando…' : reporte ? 'Actualizar' : 'Generar'}
              </button>
            </div>
          </header>

          <div className="reporte-ia-body">
            {error && <p className="form-error">{error}</p>}
            {cargando && <p>Cargando último reporte…</p>}
            {generando && <p>Gemini está analizando la semana del taller. Puede tardar unos segundos.</p>}

            {!cargando && !generando && !reporte && !error && (
              <p>
                Aún no hay reportes. Presiona <strong>Generar</strong> para analizar los últimos 7 días
                del taller.
              </p>
            )}

            {reporte && !generando && (
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
