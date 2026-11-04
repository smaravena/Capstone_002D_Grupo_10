// Exporta los indicadores del dashboard a PDF (jsPDF + autotable) o Excel
// (ExcelJS). Ambos formatos se arman desde las mismas tablas (`armarTablas`),
// así siempre contienen la misma información. Las librerías se cargan recién
// al exportar para no agrandar la carga inicial de la app.

const clp = new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP', maximumFractionDigits: 0 })
const clpCompacto = new Intl.NumberFormat('es-CL', {
  style: 'currency',
  currency: 'CLP',
  notation: 'compact',
  maximumFractionDigits: 1,
})
const numero = new Intl.NumberFormat('es-CL')

const TINTA = [34, 26, 8]
const GRIS = [107, 99, 117]
const ACENTO = [255, 31, 143]
const AMARILLO = [255, 212, 0]

const fecha = (iso) =>
  iso
    ? new Date(iso.length === 10 ? `${iso}T12:00:00` : iso).toLocaleDateString('es-CL', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
      })
    : '—'

const nombreCompleto = (u) => (u ? `${u.nom_usuario ?? ''} ${u.ape_usuario ?? ''}`.trim() : 'Sin asignar')

const capitalizar = (texto) => (texto ? texto.charAt(0).toUpperCase() + texto.slice(1) : '—')

function variacionMes(actual, anterior) {
  if (anterior === 0) return actual === 0 ? 'Sin ventas ambos meses' : 'Mes anterior sin ventas'
  const pct = Math.round(((actual - anterior) / anterior) * 100)
  if (pct === 0) return 'Igual que el mes anterior'
  // Guion ASCII: la fuente estándar del PDF no tiene el signo menos tipográfico
  return `${pct > 0 ? '+' : '-'}${Math.abs(pct)}% vs mes anterior`
}

// Tipos de columna: 'texto' | 'numero' | 'clp'
function armarTablas(kpis) {
  const estados = kpis.trabajosPorEstado
  return [
    {
      titulo: 'Indicadores principales',
      hoja: 'Resumen',
      columnas: [
        { titulo: 'Indicador', tipo: 'texto', ancho: 34 },
        { titulo: 'Valor', tipo: 'mixto', ancho: 22 },
        { titulo: 'Detalle', tipo: 'texto', ancho: 40 },
      ],
      filas: [
        ['Ventas totales del taller', { clp: kpis.ventasTotales }, `${numero.format(kpis.totalOrdenes)} pedidos y servicios registrados`],
        ['Abonos recibidos', { clp: kpis.abonos }, ''],
        ['Ventas de este mes', { clp: kpis.mesActual.monto }, variacionMes(kpis.mesActual.monto, kpis.mesAnterior.monto)],
        ['Ventas del mes anterior', { clp: kpis.mesAnterior.monto }, ''],
        ['Órdenes activas', { numero: kpis.activas }, 'Pedidos y servicios que no están listos'],
        ['Entregas atrasadas', { numero: kpis.atrasadas }, kpis.atrasadas > 0 ? 'Requieren atención' : 'Todo al día'],
        ['Clientes registrados', { numero: kpis.totalClientes }, ''],
        ['Trabajos pendientes', { numero: estados.pendiente ?? 0 }, ''],
        ['Trabajos en progreso', { numero: estados['en progreso'] ?? 0 }, ''],
        ['Trabajos terminados', { numero: estados.terminado ?? 0 }, ''],
      ],
    },
    {
      titulo: 'Ventas por mes',
      hoja: 'Ventas por mes',
      grafico: true,
      columnas: [
        { titulo: 'Mes', tipo: 'texto', ancho: 22 },
        { titulo: 'Órdenes', tipo: 'numero', ancho: 12 },
        { titulo: 'Ventas', tipo: 'clp', ancho: 18 },
      ],
      filas: kpis.meses.map((m) => [capitalizar(m.etiquetaLarga), m.ordenes, m.monto]),
    },
    {
      titulo: 'Clientes con más pedidos',
      hoja: 'Clientes con más pedidos',
      columnas: [
        { titulo: '#', tipo: 'numero', ancho: 6 },
        { titulo: 'Cliente', tipo: 'texto', ancho: 34 },
        { titulo: 'Pedidos y servicios', tipo: 'numero', ancho: 20 },
        { titulo: 'Monto total', tipo: 'clp', ancho: 18 },
      ],
      filas: kpis.topPorOrdenes.map((c, i) => [i + 1, c.nombre, c.ordenes, c.gasto]),
    },
    {
      titulo: 'Clientes que más han gastado',
      hoja: 'Clientes que más gastan',
      columnas: [
        { titulo: '#', tipo: 'numero', ancho: 6 },
        { titulo: 'Cliente', tipo: 'texto', ancho: 34 },
        { titulo: 'Monto total', tipo: 'clp', ancho: 18 },
        { titulo: 'Pedidos y servicios', tipo: 'numero', ancho: 20 },
      ],
      filas: kpis.topPorGasto.map((c, i) => [i + 1, c.nombre, c.gasto, c.ordenes]),
    },
    {
      titulo: 'Carga por trabajadora',
      hoja: 'Carga por trabajadora',
      columnas: [
        { titulo: 'Trabajadora', tipo: 'texto', ancho: 30 },
        { titulo: 'Trabajos pendientes y en progreso', tipo: 'numero', ancho: 32 },
      ],
      filas: kpis.cargaPorTrabajadora.map((c) => [c.nombre, c.activos]),
    },
    {
      titulo: 'Trabajos en progreso',
      hoja: 'Trabajos en progreso',
      columnas: [
        { titulo: 'Pedido', tipo: 'texto', ancho: 10 },
        { titulo: 'Cliente', tipo: 'texto', ancho: 26 },
        { titulo: 'Tarea', tipo: 'texto', ancho: 12 },
        { titulo: 'Prenda', tipo: 'texto', ancho: 22 },
        { titulo: 'Cantidad', tipo: 'numero', ancho: 10 },
        { titulo: 'Asignado a', tipo: 'texto', ancho: 24 },
        { titulo: 'Desde', tipo: 'texto', ancho: 12 },
        { titulo: 'Entrega', tipo: 'texto', ancho: 12 },
      ],
      filas: kpis.enProgreso.map((t) => [
        t.detalle?.pedido?.id_pedido ? `#${t.detalle.pedido.id_pedido}` : '—',
        t.detalle?.pedido?.cliente?.nom_cli ?? '—',
        capitalizar(t.tipo_trabajo),
        t.detalle?.tipo_prenda ?? '—',
        t.detalle?.cant_prendas ?? 0,
        nombreCompleto(t.usuario),
        fecha(t.fecha_asignacion),
        fecha(t.detalle?.pedido?.fec_ter),
      ]),
    },
    {
      titulo: 'Próximas entregas',
      hoja: 'Próximas entregas',
      columnas: [
        { titulo: 'Orden', tipo: 'texto', ancho: 16 },
        { titulo: 'Cliente', tipo: 'texto', ancho: 26 },
        { titulo: 'Estado', tipo: 'texto', ancho: 14 },
        { titulo: 'Entrega', tipo: 'texto', ancho: 12 },
        { titulo: 'Atrasada', tipo: 'texto', ancho: 10 },
        { titulo: 'Monto', tipo: 'clp', ancho: 16 },
      ],
      filas: kpis.proximasEntregas.map((o) => [
        `${o.tipo} #${o.numero}`,
        o.cliente,
        capitalizar(o.estado),
        fecha(o.fec_ter),
        o.atrasada ? 'Sí' : 'No',
        o.monto,
      ]),
    },
  ]
}

const nombreArchivo = (ext) => `dashboard-taller-${new Date().toISOString().slice(0, 10)}.${ext}`

function textoCelda(valor, tipo) {
  if (valor && typeof valor === 'object') {
    return valor.clp !== undefined ? clp.format(valor.clp) : numero.format(valor.numero)
  }
  if (tipo === 'clp') return clp.format(valor)
  if (tipo === 'numero') return numero.format(valor)
  return String(valor ?? '')
}

// ---------------------------------------------------------------- PDF ---

function graficoVentas(pdf, meses, x, y, ancho, alto) {
  const maximo = Math.max(1, ...meses.map((m) => m.monto))
  const ranura = ancho / meses.length
  const anchoBarra = Math.min(12, ranura * 0.5)
  const base = y + alto - 6

  pdf.setDrawColor(230, 222, 190)
  pdf.setLineWidth(0.3)
  pdf.line(x, base, x + ancho, base)

  meses.forEach((m, i) => {
    const centro = x + ranura * i + ranura / 2
    const h = (m.monto / maximo) * (alto - 14)
    if (h > 0) {
      pdf.setFillColor(...ACENTO)
      pdf.roundedRect(centro - anchoBarra / 2, base - h, anchoBarra, h, 1, 1, 'F')
      pdf.rect(centro - anchoBarra / 2, base - Math.min(h, 1), anchoBarra, Math.min(h, 1), 'F') // base recta
    }

    pdf.setFont('helvetica', 'bold')
    pdf.setFontSize(8)
    pdf.setTextColor(...TINTA)
    pdf.text(clpCompacto.format(m.monto), centro, base - h - 2, { align: 'center' })

    pdf.setFont('helvetica', 'normal')
    pdf.setTextColor(...GRIS)
    pdf.text(capitalizar(m.etiqueta), centro, base + 4.5, { align: 'center' })
  })
}

export async function exportarDashboardPdf(kpis) {
  const [{ jsPDF }, { autoTable }] = await Promise.all([import('jspdf'), import('jspdf-autotable')])

  const pdf = new jsPDF({ unit: 'mm', format: 'a4' })
  const anchoPagina = pdf.internal.pageSize.getWidth()
  const altoPagina = pdf.internal.pageSize.getHeight()
  const margen = 15
  const anchoUtil = anchoPagina - margen * 2
  const generado = new Date().toLocaleString('es-CL')

  // Título
  pdf.setFont('helvetica', 'bold')
  pdf.setFontSize(20)
  pdf.setTextColor(...TINTA)
  pdf.text('Dashboard del taller', margen, 20)
  pdf.setFont('helvetica', 'normal')
  pdf.setFontSize(10)
  pdf.setTextColor(...GRIS)
  pdf.text(`Mil y Una Ideas  ·  Generado: ${generado}`, margen, 27)
  pdf.setDrawColor(...ACENTO)
  pdf.setLineWidth(0.8)
  pdf.line(margen, 31, anchoPagina - margen, 31)

  let y = 40

  const asegurarEspacio = (necesario) => {
    if (y + necesario > altoPagina - 22) {
      pdf.addPage()
      y = 24
    }
  }

  armarTablas(kpis).forEach((tabla) => {
    asegurarEspacio(tabla.grafico ? 80 : 24)

    pdf.setFont('helvetica', 'bold')
    pdf.setFontSize(13)
    pdf.setTextColor(...TINTA)
    pdf.text(tabla.titulo, margen, y)
    y += 4

    if (tabla.grafico) {
      graficoVentas(pdf, kpis.meses, margen, y + 2, anchoUtil, 55)
      y += 60
    }

    if (tabla.filas.length === 0) {
      pdf.setFont('helvetica', 'normal')
      pdf.setFontSize(10)
      pdf.setTextColor(...GRIS)
      pdf.text('Sin datos para mostrar.', margen, y + 5)
      y += 14
      return
    }

    autoTable(pdf, {
      startY: y,
      margin: { left: margen, right: margen, top: 24, bottom: 22 },
      head: [tabla.columnas.map((c) => c.titulo)],
      body: tabla.filas.map((fila) => fila.map((v, i) => textoCelda(v, tabla.columnas[i].tipo))),
      styles: { font: 'helvetica', fontSize: 9, cellPadding: 2, textColor: TINTA, lineColor: [240, 227, 172] },
      headStyles: { fillColor: AMARILLO, textColor: TINTA, fontStyle: 'bold' },
      alternateRowStyles: { fillColor: [255, 251, 235] },
      columnStyles: Object.fromEntries(
        tabla.columnas.map((c, i) => [i, c.tipo === 'texto' ? {} : { halign: 'right' }]),
      ),
      // El título de las columnas numéricas se alinea igual que sus valores
      didParseCell: (data) => {
        if (data.section === 'head' && tabla.columnas[data.column.index].tipo !== 'texto') {
          data.cell.styles.halign = 'right'
        }
      },
      theme: 'grid',
    })
    y = pdf.lastAutoTable.finalY + 12
  })

  // Encabezado chico y pie con número de página en todas las hojas
  const total = pdf.getNumberOfPages()
  for (let p = 1; p <= total; p += 1) {
    pdf.setPage(p)
    if (p > 1) {
      pdf.setFont('helvetica', 'normal')
      pdf.setFontSize(9)
      pdf.setTextColor(...GRIS)
      pdf.text('Dashboard del taller · Mil y Una Ideas', margen, 14)
      pdf.text(`Generado: ${generado}`, anchoPagina - margen, 14, { align: 'right' })
      pdf.setDrawColor(...ACENTO)
      pdf.setLineWidth(0.4)
      pdf.line(margen, 17, anchoPagina - margen, 17)
    }

    pdf.setDrawColor(230, 222, 190)
    pdf.setLineWidth(0.3)
    pdf.line(margen, altoPagina - 14, anchoPagina - margen, altoPagina - 14)
    pdf.setFont('helvetica', 'normal')
    pdf.setFontSize(8)
    pdf.setTextColor(...GRIS)
    pdf.text('Montos de pedidos: precio unitario × cantidad de prendas.', margen, altoPagina - 9)
    pdf.setFont('helvetica', 'bold')
    pdf.setTextColor(...TINTA)
    pdf.text(`Página ${p} de ${total}`, anchoPagina - margen, altoPagina - 9, { align: 'right' })
  }

  pdf.save(nombreArchivo('pdf'))
}

// -------------------------------------------------------------- Excel ---

const FORMATO_CLP = '"$"#,##0'

export async function exportarDashboardExcel(kpis) {
  const { default: ExcelJS } = await import('exceljs')

  const libro = new ExcelJS.Workbook()
  libro.creator = 'Mil y Una Ideas'
  libro.created = new Date()

  armarTablas(kpis).forEach((tabla) => {
    const hoja = libro.addWorksheet(tabla.hoja.slice(0, 31))

    hoja.addRow([tabla.titulo]).font = { bold: true, size: 14 }
    hoja.addRow([`Generado: ${new Date().toLocaleString('es-CL')}`]).font = { italic: true, color: { argb: 'FF6B6375' } }
    hoja.addRow([])

    const encabezado = hoja.addRow(tabla.columnas.map((c) => c.titulo))
    encabezado.eachCell((celda) => {
      celda.font = { bold: true, color: { argb: 'FF221A08' } }
      celda.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFD400' } }
      celda.border = { bottom: { style: 'thin', color: { argb: 'FF221A08' } } }
    })

    tabla.filas.forEach((fila) => {
      const valores = fila.map((v) => (v && typeof v === 'object' ? (v.clp ?? v.numero) : v))
      const filaExcel = hoja.addRow(valores)
      fila.forEach((v, i) => {
        const tipo = v && typeof v === 'object' ? (v.clp !== undefined ? 'clp' : 'numero') : tabla.columnas[i].tipo
        if (tipo === 'clp') filaExcel.getCell(i + 1).numFmt = FORMATO_CLP
        if (tipo === 'numero') filaExcel.getCell(i + 1).numFmt = '#,##0'
      })
    })

    if (tabla.filas.length === 0) hoja.addRow(['Sin datos para mostrar.'])

    tabla.columnas.forEach((c, i) => {
      hoja.getColumn(i + 1).width = c.ancho
    })

    if (tabla.filas.length > 0) {
      hoja.autoFilter = { from: { row: 4, column: 1 }, to: { row: 4, column: tabla.columnas.length } }
    }
    hoja.views = [{ state: 'frozen', ySplit: 4 }]
  })

  const buffer = await libro.xlsx.writeBuffer()
  const blob = new Blob([buffer], {
    type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  })
  const url = URL.createObjectURL(blob)
  const enlace = document.createElement('a')
  enlace.href = url
  enlace.download = nombreArchivo('xlsx')
  enlace.click()
  URL.revokeObjectURL(url)
}
