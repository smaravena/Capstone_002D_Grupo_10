// Roles tal como se guardan en la columna usuario.rol_usu.
// Ajusta estos valores para que coincidan EXACTAMENTE (mayúsculas/espacios
// incluidos) con los datos reales de tu tabla `usuario`.
export const ROLES = {
  JEFA_TALLER: 'Jefa de taller', // acceso a todos los módulos
  CORTADORA: 'Cortadora', // permisos aún sin definir
  OPERARIA: 'Operaria', // permisos aún sin definir
}

// Roles que pueden entrar al módulo de pedidos.
// Cortadora y Operaria solo trabajan desde "Mis trabajos".
export const ROLES_MODULO_PEDIDOS = [ROLES.JEFA_TALLER]

// Roles que pueden entrar al módulo de usuarios.
// Cortadora y Operaria no tienen acceso a usuarios registrados.
export const ROLES_MODULO_USUARIOS = [ROLES.JEFA_TALLER]

// Roles que pueden entrar al módulo de clientes.
// Cortadora y Operaria no tienen acceso a clientes.
export const ROLES_MODULO_CLIENTES = [ROLES.JEFA_TALLER]

// Roles que pueden entrar al módulo de precios (lista de precios fija de
// prendas escolares que se muestra en el landing público).
export const ROLES_MODULO_PRECIOS = [ROLES.JEFA_TALLER]

// Roles que pueden entrar a "Mis trabajos" (tareas de corte/armado
// asignadas de forma individual en la tabla `trabajo`).
export const ROLES_MODULO_MIS_TRABAJOS = [ROLES.CORTADORA, ROLES.OPERARIA]

// Ruta a la que se redirige a cada rol justo después de iniciar sesión.
export function getHomeRoute(role) {
  if (ROLES_MODULO_MIS_TRABAJOS.includes(role)) return '/mis-trabajos'
  if (ROLES_MODULO_PEDIDOS.includes(role)) return '/pedidos'
  return '/'
}
