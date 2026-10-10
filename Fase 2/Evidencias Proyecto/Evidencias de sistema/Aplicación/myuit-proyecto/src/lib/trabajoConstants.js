// Estados válidos para una tarea de la tabla `trabajo`. Se edita siempre
// mediante una lista desplegable con estos valores, nunca como texto libre.
export const ESTADOS_TRABAJO = ['pendiente', 'en progreso', 'terminado']

// Tipos de tarea sobre una línea de detalle de un pedido.
export const TIPOS_TRABAJO = ['corte', 'armado']

export const TIPO_TRABAJO_LABELS = {
  corte: 'Corte',
  armado: 'Armado',
}
