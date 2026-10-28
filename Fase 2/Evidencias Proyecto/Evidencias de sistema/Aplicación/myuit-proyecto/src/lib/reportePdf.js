// Genera el PDF del reporte semanal a partir del panel que se ve en pantalla.
//
// Se captura el panel una sola vez con html2canvas (en una copia más ancha y
// sin scroll), se recorta cada bloque (indicadores, resumen, cada hallazgo,
// cada recomendación...) y se ubican uno a uno en hojas A4 con encabezado y
// "Página X de Y". Un bloque nunca se parte entre dos hojas y los títulos de
// sección siempre quedan junto a su primer elemento.
//
// html2canvas y jsPDF se cargan recién aquí para no agrandar la carga inicial.

const BLOQUES = '.reporte-ia-kpis, .reporte-ia-resumen, .reporte-ia-body h3, .reporte-ia-body li'

const TINTA = [34, 26, 8]
const GRIS = [107, 99, 117]
const ACENTO = [255, 31, 143]

const MARGEN_X = 15
const INICIO_PRIMERA = 42 // mm: debajo del título grande de la primera hoja
const INICIO_RESTO = 26 // mm: debajo del encabezado chico
const FIN_CONTENIDO = 297 - 20 // mm: sobre el pie de página

const fechaCorta = (iso) => new Date(iso).toLocaleDateString('es-CL')

// Mide, dentro de la copia que genera html2canvas, el área de contenido y la
// posición vertical de cada bloque (en px CSS relativos al panel).
function medirBloques(doc) {
  const panel = doc.querySelector('.reporte-ia-panel')
  const body = doc.querySelector('.reporte-ia-body')
  if (!panel || !body) return null

  panel.classList.add('reporte-ia-exportando')

  const base = panel.getBoundingClientRect()
  const cajaBody = body.getBoundingClientRect()
  const estilo = doc.defaultView.getComputedStyle(body)
  const izquierda = cajaBody.left - base.left + parseFloat(estilo.paddingLeft)
  const ancho = cajaBody.width - parseFloat(estilo.paddingLeft) - parseFloat(estilo.paddingRight)

  const bloques = [...body.querySelectorAll(BLOQUES)].map((el) => {
    const caja = el.getBoundingClientRect()
    return {
      top: caja.top - base.top,
      bottom: caja.bottom - base.top,
      titulo: el.tagName === 'H3',
    }
  })

  return { anchoPanel: base.width, izquierda, ancho, bloques }
}

function recortar(canvas, escala, medidas, bloque) {
  const x = Math.round(medidas.izquierda * escala)
  const y = Math.round(bloque.top * escala)
  const w = Math.round(medidas.ancho * escala)
  const h = Math.max(1, Math.round((bloque.bottom - bloque.top) * escala))

  const recorte = document.createElement('canvas')
  recorte.width = w
  recorte.height = h
  recorte.getContext('2d').drawImage(canvas, x, y, w, h, 0, 0, w, h)
  return recorte.toDataURL('image/png')
}

function dibujarEncabezado(pdf, reporte, pagina) {
  const ancho = pdf.internal.pageSize.getWidth()
  const periodo = `${fechaCorta(reporte.fecha_desde)} – ${fechaCorta(reporte.fecha_hasta)}`

  if (pagina === 1) {
    pdf.setFont('helvetica', 'bold')
    pdf.setFontSize(20)
    pdf.setTextColor(...TINTA)
    pdf.text('Reporte semanal del taller', MARGEN_X, 20)

    pdf.setFont('helvetica', 'normal')
    pdf.setFontSize(10)
    pdf.setTextColor(...GRIS)
    pdf.text('Mil y Una Ideas', MARGEN_X, 27)
    pdf.text(
      `Período: ${periodo}  ·  Generado: ${new Date(reporte.created_at).toLocaleString('es-CL')}`,
      MARGEN_X,
      32,
    )

    pdf.setDrawColor(...ACENTO)
    pdf.setLineWidth(0.8)
    pdf.line(MARGEN_X, 36, ancho - MARGEN_X, 36)
    return
  }

  pdf.setFont('helvetica', 'normal')
  pdf.setFontSize(9)
  pdf.setTextColor(...GRIS)
  pdf.text('Reporte semanal del taller · Mil y Una Ideas', MARGEN_X, 14)
  pdf.text(`Período: ${periodo}`, ancho - MARGEN_X, 14, { align: 'right' })

  pdf.setDrawColor(...ACENTO)
  pdf.setLineWidth(0.4)
  pdf.line(MARGEN_X, 18, ancho - MARGEN_X, 18)
}

function dibujarPie(pdf, reporte, pagina, total) {
  const ancho = pdf.internal.pageSize.getWidth()
  const alto = pdf.internal.pageSize.getHeight()

  pdf.setDrawColor(230, 222, 190)
  pdf.setLineWidth(0.3)
  pdf.line(MARGEN_X, alto - 14, ancho - MARGEN_X, alto - 14)

  pdf.setFont('helvetica', 'normal')
  pdf.setFontSize(8)
  pdf.setTextColor(...GRIS)
  pdf.text(
    `Indicadores calculados desde la base de datos · Análisis redactado con IA (${reporte.modelo ?? 'Gemini'})`,
    MARGEN_X,
    alto - 9,
  )

  pdf.setFont('helvetica', 'bold')
  pdf.setTextColor(...TINTA)
  pdf.text(`Página ${pagina} de ${total}`, ancho - MARGEN_X, alto - 9, { align: 'right' })
}

export async function descargarReportePdf(panel, reporte) {
  const [{ default: html2canvas }, { jsPDF }] = await Promise.all([
    import('html2canvas'),
    import('jspdf'),
  ])

  let medidas = null
  const canvas = await html2canvas(panel, {
    scale: 2,
    backgroundColor: '#ffffff',
    onclone: (doc) => {
      medidas = medirBloques(doc)
    },
  })
  if (!medidas || medidas.bloques.length === 0) throw new Error('No hay contenido para exportar.')

  const pdf = new jsPDF({ unit: 'mm', format: 'a4' })
  const anchoMm = pdf.internal.pageSize.getWidth() - MARGEN_X * 2
  const escala = canvas.width / medidas.anchoPanel // px del canvas por px CSS
  const mmPorCss = anchoMm / medidas.ancho

  const { bloques } = medidas
  const altoMm = (b) => (b.bottom - b.top) * mmPorCss
  const espacioMm = (anterior, b) => (anterior ? Math.max(0, b.top - anterior.bottom) * mmPorCss : 0)

  let pagina = 1
  let inicio = INICIO_PRIMERA
  let cursor = inicio
  let anterior = null

  bloques.forEach((bloque, i) => {
    let espacio = espacioMm(anterior, bloque)
    let necesario = espacio + altoMm(bloque)

    // Un título de sección solo se ubica si su primer elemento cabe con él
    const siguiente = bloques[i + 1]
    if (bloque.titulo && siguiente) necesario += espacioMm(bloque, siguiente) + altoMm(siguiente)

    if (cursor + necesario > FIN_CONTENIDO && cursor > inicio) {
      pdf.addPage()
      pagina += 1
      inicio = INICIO_RESTO
      cursor = inicio
      espacio = 0
    }

    // Un bloque más alto que una hoja completa se reduce para que quepa
    const disponible = FIN_CONTENIDO - cursor - espacio
    const factor = Math.min(1, disponible / altoMm(bloque))

    pdf.addImage(
      recortar(canvas, escala, medidas, bloque),
      'PNG',
      MARGEN_X,
      cursor + espacio,
      anchoMm * factor,
      altoMm(bloque) * factor,
    )

    cursor += espacio + altoMm(bloque) * factor
    anterior = bloque
  })

  for (let p = 1; p <= pagina; p += 1) {
    pdf.setPage(p)
    dibujarEncabezado(pdf, reporte, p)
    dibujarPie(pdf, reporte, p, pagina)
  }

  const fecha = new Date(reporte.created_at).toISOString().slice(0, 10)
  pdf.save(`reporte-semanal-${fecha}.pdf`)
}
