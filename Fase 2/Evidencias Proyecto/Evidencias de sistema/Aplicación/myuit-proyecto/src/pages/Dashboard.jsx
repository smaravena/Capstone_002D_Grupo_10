import { useEffect, useRef, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import iconoTaller from '../assets/icono.png'

// Dashboard de la Jefa de taller: KPIs del negocio calculados en el navegador
// a partir de pedidos, servicios, clientes y trabajos. Los montos de pedidos
// se calculan como precio unitario × cantidad de prendas de cada detalle.

const MESES_GRAFICO = 6
const TOP_CLIENTES = 5

const clp = new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP', maximumFractionDigits: 0 })
const clpCompacto = new Intl.NumberFormat('es-CL', {
  style: 'currency',
  currency: 'CLP',
  notation: 'compact',
  maximumFractionDigits: 1,
})
const numero = new Intl.NumberFormat('es-CL')

const hoyIso = () => {
  const d = new Date()
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

const claveMes = (fecha) => `${fecha.getFullYear()}-${String(fecha.getMonth() + 1).padStart(2, '0')}`

const fechaCorta = (iso) =>
  iso ? new Date(`${iso.slice(0, 10)}T12:00:00`).toLocaleDateString('es-CL', { day: '2-digit', month: 'short' }) : '—'

const nombreCompleto = (u) => (u ? `${u.nom_usuario ?? ''} ${u.ape_usuario ?? ''}`.trim() : 'Sin asignar')

// Redondea el máximo del eje a un número "limpio" (1, 2, 2.5 o 5 × 10^n)
function maximoLimpio(valor) {
  if (valor <= 0) return 1
  const potencia = 10 ** Math.floor(Math.log10(valor))
  const paso = [1, 2, 2.5, 5, 10].find((m) => m * potencia >= valor)
  return paso * potencia
}

async function cargarDatos() {
  const [pedidos, servicios, clientes, trabajos] = await Promise.all([
    supabase
      .from('pedido')
      .select('id_pedido, fec_ter, estado_pedido, abono, created_at, id_cli, detalle_pedido ( precio, cant_prendas )'),
    supabase
      .from('servicio')
      .select('id_servicio, fec_ter, estado_servicio, abono, created_at, id_cli, detalle_servicio ( precio )'),
    supabase.from('cliente').select('id_cli, nom_cli'),
    supabase
      .from('trabajo')
      .select(
        'id_trabajo, tipo_trabajo, estado, fecha_asignacion, usuario:id_usu ( nom_usuario, ape_usuario ), detalle:id_detalle ( tipo_prenda, cant_prendas, pedido:id_pedido ( id_pedido, fec_ter, cliente:id_cli ( nom_cli ) ) )',
      ),
  ])

  const fallo = [pedidos, servicios, clientes, trabajos].find((r) => r.error)
  if (fallo) throw fallo.error

  return {
    pedidos: pedidos.data,
    servicios: servicios.data,
    clientes: clientes.data,
    trabajos: trabajos.data,
  }
}

function calcularKpis({ pedidos, servicios, clientes, trabajos }) {
  const nombres = new Map(clientes.map((c) => [c.id_cli, c.nom_cli]))

  // Pedidos y servicios se tratan juntos como "órdenes" del taller
  const ordenes = [
    ...pedidos.map((p) => ({
      clave: `P${p.id_pedido}`,
      tipo: 'Pedido',
      numero: p.id_pedido,
      id_cli: p.id_cli,
      estado: p.estado_pedido,
      fec_ter: p.fec_ter,
      created_at: p.created_at,
      abono: Number(p.abono || 0),
      monto: (p.detalle_pedido ?? []).reduce(
        (acc, d) => acc + Number(d.precio || 0) * Number(d.cant_prendas || 0),
        0,
      ),
    })),
    ...servicios.map((s) => ({
      clave: `S${s.id_servicio}`,
      tipo: 'Servicio',
      numero: s.id_servicio,
      id_cli: s.id_cli,
      estado: s.estado_servicio,
      fec_ter: s.fec_ter,
      created_at: s.created_at,
      abono: Number(s.abono || 0),
      monto: (s.detalle_servicio ?? []).reduce((acc, d) => acc + Number(d.precio || 0), 0),
    })),
  ]

  const hoy = hoyIso()
  const ventasTotales = ordenes.reduce((acc, o) => acc + o.monto, 0)
  const abonos = ordenes.reduce((acc, o) => acc + o.abono, 0)

  // Ventas por mes (últimos MESES_GRAFICO meses, incluido el actual)
  const ahora = new Date()
  const meses = Array.from({ length: MESES_GRAFICO }, (_, i) => {
    const fecha = new Date(ahora.getFullYear(), ahora.getMonth() - (MESES_GRAFICO - 1 - i), 1)
    return {
      clave: claveMes(fecha),
      etiqueta: fecha.toLocaleDateString('es-CL', { month: 'short' }).replace('.', ''),
      etiquetaLarga: fecha.toLocaleDateString('es-CL', { month: 'long', year: 'numeric' }),
      monto: 0,
      ordenes: 0,
    }
  })
  const porClave = new Map(meses.map((m) => [m.clave, m]))
  ordenes.forEach((o) => {
    const mes = porClave.get(claveMes(new Date(o.created_at)))
    if (mes) {
      mes.monto += o.monto
      mes.ordenes += 1
    }
  })
  const mesActual = meses[meses.length - 1]
  const mesAnterior = meses[meses.length - 2]

  // Clientes: cantidad de órdenes y gasto total
  const porCliente = new Map()
  ordenes.forEach((o) => {
    if (o.id_cli == null) return
    const c = porCliente.get(o.id_cli) ?? { nombre: nombres.get(o.id_cli) ?? `Cliente #${o.id_cli}`, ordenes: 0, gasto: 0 }
    c.ordenes += 1
    c.gasto += o.monto
    porCliente.set(o.id_cli, c)
  })
  const listaClientes = [...porCliente.values()]
  const topPorOrdenes = [...listaClientes].sort((a, b) => b.ordenes - a.ordenes || b.gasto - a.gasto).slice(0, TOP_CLIENTES)
  const topPorGasto = [...listaClientes].sort((a, b) => b.gasto - a.gasto).slice(0, TOP_CLIENTES)

  // Órdenes activas y entregas
  const activas = ordenes.filter((o) => o.estado !== 'listo')
  const atrasadas = activas.filter((o) => o.fec_ter && o.fec_ter.slice(0, 10) < hoy)
  const proximasEntregas = activas
    .filter((o) => o.fec_ter)
    .sort((a, b) => a.fec_ter.localeCompare(b.fec_ter))
    .slice(0, 8)
    .map((o) => ({ ...o, cliente: nombres.get(o.id_cli) ?? '—', atrasada: o.fec_ter.slice(0, 10) < hoy }))

  // Trabajos
  const trabajosPorEstado = { pendiente: 0, 'en progreso': 0, terminado: 0 }
  trabajos.forEach((t) => {
    trabajosPorEstado[t.estado] = (trabajosPorEstado[t.estado] ?? 0) + 1
  })
  const enProgreso = trabajos
    .filter((t) => t.estado === 'en progreso')
    .sort((a, b) => (a.fecha_asignacion ?? '').localeCompare(b.fecha_asignacion ?? ''))

  const carga = new Map()
  trabajos
    .filter((t) => t.estado !== 'terminado')
    .forEach((t) => {
      const nombre = nombreCompleto(t.usuario)
      carga.set(nombre, (carga.get(nombre) ?? 0) + 1)
    })
  const cargaPorTrabajadora = [...carga.entries()]
    .map(([nombre, activos]) => ({ nombre, activos }))
    .sort((a, b) => b.activos - a.activos)

  return {
    ventasTotales,
    abonos,
    totalOrdenes: ordenes.length,
    meses,
    mesActual,
    mesAnterior,
    totalClientes: clientes.length,
    topPorOrdenes,
    topPorGasto,
    activas: activas.length,
    atrasadas: atrasadas.length,
    proximasEntregas,
    trabajosPorEstado,
    enProgreso,
    cargaPorTrabajadora,
  }
}

// Botón "Exportar" con menú: PDF o Excel con todos los indicadores
function MenuExportar({ kpis }) {
  const [abierto, setAbierto] = useState(false)
  const [exportando, setExportando] = useState(null)
  const [error, setError] = useState(null)
  const menuRef = useRef(null)

  useEffect(() => {
    if (!abierto) return
    const cerrarSiAfuera = (e) => {
      if (!menuRef.current?.contains(e.target)) setAbierto(false)
    }
    const cerrarConEscape = (e) => {
      if (e.key === 'Escape') setAbierto(false)
    }
    document.addEventListener('mousedown', cerrarSiAfuera)
    document.addEventListener('keydown', cerrarConEscape)
    return () => {
      document.removeEventListener('mousedown', cerrarSiAfuera)
      document.removeEventListener('keydown', cerrarConEscape)
    }
  }, [abierto])

  const exportar = async (formato) => {
    setAbierto(false)
    setExportando(formato)
    setError(null)
    try {
      const { exportarDashboardPdf, exportarDashboardExcel } = await import('../lib/dashboardExport')
      if (formato === 'pdf') await exportarDashboardPdf(kpis)
      else await exportarDashboardExcel(kpis)
    } catch (err) {
      setError(`No se pudo exportar: ${err.message}`)
    } finally {
      setExportando(null)
    }
  }

  return (
    <div className="dash-exportar" ref={menuRef}>
      <button
        type="button"
        onClick={() => setAbierto((v) => !v)}
        disabled={exportando !== null}
        aria-haspopup="menu"
        aria-expanded={abierto}
      >
        {exportando ? `Exportando ${exportando === 'pdf' ? 'PDF' : 'Excel'}…` : 'Exportar ▾'}
      </button>
      {abierto && (
        <div className="dash-exportar-menu" role="menu">
          <button type="button" role="menuitem" onClick={() => exportar('pdf')}>
            PDF <span>Documento para imprimir o enviar</span>
          </button>
          <button type="button" role="menuitem" onClick={() => exportar('excel')}>
            Excel (.xlsx) <span>Una hoja por indicador</span>
          </button>
        </div>
      )}
      {error && <p className="form-error dash-exportar-error">{error}</p>}
    </div>
  )
}

function StatTile({ label, valor, detalle, delta }) {
  return (
    <div className="dash-tile">
      <span className="dash-tile-label">{label}</span>
      <strong className="dash-tile-valor">{valor}</strong>
      {delta}
      {detalle && <span className="dash-tile-detalle">{detalle}</span>}
    </div>
  )
}

function DeltaMes({ actual, anterior }) {
  if (anterior === 0 && actual === 0) return <span className="dash-delta">Sin ventas el mes pasado ni este</span>
  if (anterior === 0) return <span className="dash-delta sube">▲ Mes anterior sin ventas</span>
  const pct = Math.round(((actual - anterior) / anterior) * 100)
  if (pct === 0) return <span className="dash-delta">= igual que el mes anterior</span>
  return (
    <span className={`dash-delta ${pct > 0 ? 'sube' : 'baja'}`}>
      {pct > 0 ? '▲' : '▼'} {Math.abs(pct)}% vs mes anterior
    </span>
  )
}

// Columnas de ventas por mes: una sola serie (sin leyenda), eje con números
// limpios, tooltip al pasar el mouse o enfocar con teclado, y tabla accesible.
function GraficoVentasMes({ meses }) {
  const [activo, setActivo] = useState(null)
  const maximo = maximoLimpio(Math.max(...meses.map((m) => m.monto)))
  const ticks = [0, 0.25, 0.5, 0.75, 1].map((f) => f * maximo)
  const ultimo = meses.length - 1

  return (
    <div className="dash-card dash-card-ancha">
      <h2>Ventas por mes</h2>
      <p className="dash-card-sub">Monto de pedidos y servicios según su fecha de creación</p>

      <div className="dash-columnas" role="img" aria-label="Gráfico de ventas de los últimos meses; detalle en la tabla">
        <div className="dash-eje">
          {ticks
            .slice()
            .reverse()
            .map((t) => (
              <span key={t}>{clpCompacto.format(t)}</span>
            ))}
        </div>
        <div className="dash-plot">
          <div className="dash-grid-capa" aria-hidden="true">
            {ticks.map((t) => (
              <div key={t} className="dash-grid" style={{ bottom: `${(t / maximo) * 100}%` }} />
            ))}
          </div>
          {meses.map((m, i) => (
            <div
              key={m.clave}
              className="dash-col"
              tabIndex={0}
              onMouseEnter={() => setActivo(i)}
              onMouseLeave={() => setActivo(null)}
              onFocus={() => setActivo(i)}
              onBlur={() => setActivo(null)}
            >
              <div className="dash-col-area">
                <div
                  className={`dash-col-barra ${activo !== null && activo !== i ? 'atenuada' : ''}`}
                  style={{ height: `${(m.monto / maximo) * 100}%` }}
                >
                  {i === ultimo && m.monto > 0 && activo === null && (
                    <span className="dash-col-valor">{clpCompacto.format(m.monto)}</span>
                  )}
                </div>
                {activo === i && (
                  <div className="dash-tooltip" role="tooltip">
                    <strong>{m.etiquetaLarga}</strong>
                    <span>{clp.format(m.monto)}</span>
                    <span>
                      {m.ordenes} {m.ordenes === 1 ? 'orden' : 'órdenes'}
                    </span>
                  </div>
                )}
              </div>
              <span className="dash-col-etiqueta">{m.etiqueta}</span>
            </div>
          ))}
        </div>
      </div>

      <details className="dash-tabla-datos">
        <summary>Ver como tabla</summary>
        <table>
          <thead>
            <tr>
              <th>Mes</th>
              <th>Órdenes</th>
              <th>Ventas</th>
            </tr>
          </thead>
          <tbody>
            {meses.map((m) => (
              <tr key={m.clave}>
                <td>{m.etiquetaLarga}</td>
                <td>{m.ordenes}</td>
                <td>{clp.format(m.monto)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </details>
    </div>
  )
}

// Barras horizontales ordenadas (una sola serie). El valor va en la punta.
function Ranking({ titulo, sub, filas, valor, formato, vacio }) {
  const maximo = Math.max(1, ...filas.map(valor))
  return (
    <div className="dash-card">
      <h2>{titulo}</h2>
      {sub && <p className="dash-card-sub">{sub}</p>}
      {filas.length === 0 ? (
        <p className="dash-vacio">{vacio}</p>
      ) : (
        <ol className="dash-ranking">
          {filas.map((f, i) => (
            <li key={`${i}-${f.nombre}`} title={`${f.nombre}: ${formato(valor(f))}`}>
              <span className="dash-ranking-nombre">{f.nombre}</span>
              <div className="dash-ranking-fila">
                <div className="dash-ranking-barra" style={{ width: `${(valor(f) / maximo) * 100}%` }} />
                <span className="dash-ranking-valor">{formato(valor(f))}</span>
              </div>
            </li>
          ))}
        </ol>
      )}
    </div>
  )
}

export default function Dashboard() {
  const [kpis, setKpis] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    let activo = true
    cargarDatos()
      .then((datos) => {
        if (activo) setKpis(calcularKpis(datos))
      })
      .catch((err) => {
        if (activo) setError(err.message)
      })
    return () => {
      activo = false
    }
  }, [])

  return (
    <div className="dashboard">
      <div className="usuarios-header">
        <h1 className="page-title">
          Dashboard
          <img src={iconoTaller} alt="" className="page-title-icon" />
        </h1>
        {kpis && <MenuExportar kpis={kpis} />}
      </div>

      {error && <p className="form-error">No se pudo cargar el dashboard: {error}</p>}
      {!kpis && !error && <p>Cargando indicadores…</p>}

      {kpis && (
        <>
          <section className="dash-hero">
            <div>
              <span className="dash-tile-label">Ventas totales del taller</span>
              <strong className="dash-hero-valor">{clp.format(kpis.ventasTotales)}</strong>
              <span className="dash-tile-detalle">
                {numero.format(kpis.totalOrdenes)} pedidos y servicios registrados
              </span>
            </div>
            <div className="dash-hero-partes">
              <div>
                <span className="dash-tile-label">Abonos recibidos</span>
                <strong>{clp.format(kpis.abonos)}</strong>
              </div>
            </div>
          </section>

          <section className="dash-tiles">
            <StatTile
              label="Ventas de este mes"
              valor={clp.format(kpis.mesActual.monto)}
              delta={<DeltaMes actual={kpis.mesActual.monto} anterior={kpis.mesAnterior.monto} />}
            />
            <StatTile
              label="Órdenes activas"
              valor={numero.format(kpis.activas)}
              detalle="Pedidos y servicios que no están listos"
            />
            <StatTile
              label="Entregas atrasadas"
              valor={numero.format(kpis.atrasadas)}
              delta={
                kpis.atrasadas > 0 ? (
                  <span className="dash-estado alerta">⚠ Requieren atención</span>
                ) : (
                  <span className="dash-estado ok">✓ Todo al día</span>
                )
              }
            />
            <StatTile label="Clientes registrados" valor={numero.format(kpis.totalClientes)} />
            <StatTile
              label="Trabajos en progreso"
              valor={numero.format(kpis.trabajosPorEstado['en progreso'] ?? 0)}
              detalle={`${numero.format(kpis.trabajosPorEstado.pendiente ?? 0)} pendientes · ${numero.format(kpis.trabajosPorEstado.terminado ?? 0)} terminados`}
            />
          </section>

          <section className="dash-grid-cards">
            <GraficoVentasMes meses={kpis.meses} />

            <Ranking
              titulo="Clientes con más pedidos"
              sub="Pedidos y servicios encargados"
              filas={kpis.topPorOrdenes}
              valor={(f) => f.ordenes}
              formato={(n) => numero.format(n)}
              vacio="Aún no hay pedidos registrados."
            />
            <Ranking
              titulo="Clientes que más han gastado"
              sub="Monto total de sus pedidos y servicios"
              filas={kpis.topPorGasto}
              valor={(f) => f.gasto}
              formato={(n) => clp.format(n)}
              vacio="Aún no hay pedidos registrados."
            />
            <Ranking
              titulo="Carga por trabajadora"
              sub="Trabajos pendientes y en progreso"
              filas={kpis.cargaPorTrabajadora}
              valor={(f) => f.activos}
              formato={(n) => numero.format(n)}
              vacio="No hay trabajos activos."
            />

            <div className="dash-card dash-card-ancha">
              <h2>Trabajos en progreso</h2>
              {kpis.enProgreso.length === 0 ? (
                <p className="dash-vacio">No hay trabajos en progreso.</p>
              ) : (
                <div className="dash-tabla-scroll">
                  <table className="dash-tabla">
                    <thead>
                      <tr>
                        <th>Pedido</th>
                        <th>Cliente</th>
                        <th>Tarea</th>
                        <th>Prenda</th>
                        <th>Asignado a</th>
                        <th>Desde</th>
                        <th>Entrega</th>
                      </tr>
                    </thead>
                    <tbody>
                      {kpis.enProgreso.map((t) => (
                        <tr key={t.id_trabajo}>
                          <td>#{t.detalle?.pedido?.id_pedido ?? '—'}</td>
                          <td>{t.detalle?.pedido?.cliente?.nom_cli ?? '—'}</td>
                          <td className="dash-capital">{t.tipo_trabajo}</td>
                          <td>
                            {t.detalle?.tipo_prenda ?? '—'}
                            {t.detalle?.cant_prendas ? ` × ${t.detalle.cant_prendas}` : ''}
                          </td>
                          <td>{nombreCompleto(t.usuario)}</td>
                          <td>{fechaCorta(t.fecha_asignacion)}</td>
                          <td>{fechaCorta(t.detalle?.pedido?.fec_ter)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

            <div className="dash-card dash-card-ancha">
              <h2>Próximas entregas</h2>
              <p className="dash-card-sub">Pedidos y servicios no terminados, por fecha de entrega</p>
              {kpis.proximasEntregas.length === 0 ? (
                <p className="dash-vacio">No hay entregas pendientes.</p>
              ) : (
                <div className="dash-tabla-scroll">
                  <table className="dash-tabla">
                    <thead>
                      <tr>
                        <th>Orden</th>
                        <th>Cliente</th>
                        <th>Estado</th>
                        <th>Entrega</th>
                        <th>Monto</th>
                      </tr>
                    </thead>
                    <tbody>
                      {kpis.proximasEntregas.map((o) => (
                        <tr key={o.clave}>
                          <td>
                            {o.tipo} #{o.numero}
                          </td>
                          <td>{o.cliente}</td>
                          <td className="dash-capital">{o.estado}</td>
                          <td>
                            {fechaCorta(o.fec_ter)}
                            {o.atrasada && <span className="dash-estado alerta"> ⚠ Atrasada</span>}
                          </td>
                          <td>{clp.format(o.monto)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          </section>
        </>
      )}
    </div>
  )
}
