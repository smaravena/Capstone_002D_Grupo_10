// Roles tal como se guardan en la columna usuario.rol_usu.
// Ajusta estos valores para que coincidan EXACTAMENTE (mayúsculas/espacios
// incluidos) con los datos reales de tu tabla `usuario`.
export const ROLES = {
  JEFA_TALLER: 'Jefa de taller', // acceso a todos los módulos
  CORTADORA: 'Cortadora', // permisos aún sin definir
  OPERARIA: 'Operaria', // permisos aún sin definir
}

// Roles que pueden entrar al módulo de pedidos.
// Déjalo vacío ([]) para permitir el acceso a cualquier usuario autenticado.
// Cuando definan los permisos de cortadora/operaria, restringe así:
// export const ROLES_MODULO_PEDIDOS = [ROLES.JEFA_TALLER]
export const ROLES_MODULO_PEDIDOS = []

// Roles que pueden entrar al módulo de usuarios.
// Déjalo vacío ([]) para permitir el acceso a cualquier usuario autenticado.
export const ROLES_MODULO_USUARIOS = []
