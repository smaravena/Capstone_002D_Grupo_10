import { IconShirt, IconJacket } from '../components/Icons'

export const ICONOS_CATEGORIA = {
  shirt: { label: 'Polera', Icon: IconShirt },
  jacket: { label: 'Buzo / Chaqueta', Icon: IconJacket },
}

export const COLORES_CATEGORIA = {
  pink: { label: 'Rosado', value: 'var(--pink)' },
  purple: { label: 'Morado', value: 'var(--purple)' },
  blue: { label: 'Azul', value: 'var(--blue)' },
  green: { label: 'Verde', value: 'var(--green)' },
  orange: { label: 'Naranjo', value: 'var(--orange)' },
}

export const getIconoCategoria = (icono) => ICONOS_CATEGORIA[icono]?.Icon ?? IconShirt
