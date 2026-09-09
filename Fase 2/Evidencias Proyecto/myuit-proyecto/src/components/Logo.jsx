import logoImg from '../assets/logo_milyunaideas.jpeg'

export default function Logo({ size = 40, className = '' }) {
  return (
    <img
      src={logoImg}
      alt="Mil y Una Ideas"
      className={className}
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: 'contain' }}
    />
  )
}
