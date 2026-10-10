export default function FieldError({ mensaje }) {
  if (!mensaje) return null
  return (
    <small className="field-error" role="alert">
      {mensaje}
    </small>
  )
}
