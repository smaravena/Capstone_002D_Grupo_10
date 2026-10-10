import { DIGITOS_CELULAR, PREFIJO_CELULAR, limpiarCelular } from '../lib/validators'

// Celular chileno: "+56 9" va fijo dentro del campo y `value` son solo los 8 dígitos restantes.
export default function TelefonoInput({ value, onChange, invalid = false, placeholder = 'Teléfono' }) {
  return (
    <div className={`telefono-field${invalid ? ' telefono-field-invalid' : ''}`}>
      <span className="telefono-prefijo" aria-hidden="true">
        {PREFIJO_CELULAR}
      </span>
      <input
        inputMode="numeric"
        autoComplete="tel-national"
        maxLength={DIGITOS_CELULAR}
        placeholder={placeholder}
        aria-label={`Teléfono (${PREFIJO_CELULAR})`}
        value={value}
        onChange={(e) => onChange(limpiarCelular(e.target.value))}
        aria-invalid={invalid}
      />
    </div>
  )
}
