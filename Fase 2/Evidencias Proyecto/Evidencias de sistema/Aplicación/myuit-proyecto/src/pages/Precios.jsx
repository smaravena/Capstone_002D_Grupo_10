import { useEffect, useMemo, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ICONOS_CATEGORIA, COLORES_CATEGORIA, getIconoCategoria } from '../lib/preciosCategorias'
import {
  MAX_DIGITOS_PRECIO,
  limpiarPrecio,
  soloErrores,
  validarPrecio,
  validarRequerido,
  validarTexto,
} from '../lib/validators'
import FieldError from '../components/FieldError'
import { useValidacion } from '../hooks/useValidacion'
import iconoTaller from '../assets/icono.png'

const NUEVA_TALLA = '__nueva_talla__'

const emptyNuevaCategoria = () => ({
  nombre: '',
  icono: Object.keys(ICONOS_CATEGORIA)[0],
  color: Object.keys(COLORES_CATEGORIA)[0],
  talla: '',
  precio: '',
})

const validarPrecioCategoria = ({ esNueva, tallaNueva, precio }) =>
  soloErrores({
    tallaNueva: esNueva ? validarRequerido(tallaNueva, 'la talla') : null,
    precio: validarPrecio(precio),
  })

const validarNuevaCategoria = (form) =>
  soloErrores({
    nombre: validarTexto(form.nombre, 'el nombre de la categoría'),
    talla: validarRequerido(form.talla, 'la talla'),
    precio: validarPrecio(form.precio),
  })

const formatPrecio = (valor) =>
  new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }).format(valor)

export default function Precios() {
  const [precios, setPrecios] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'categoria' | 'nuevaCategoria' | 'eliminar' | null

  // Modal de categoría
  const [categoriaActiva, setCategoriaActiva] = useState(null)
  const [tallaSeleccionada, setTallaSeleccionada] = useState('')
  const [tallaNueva, setTallaNueva] = useState('')
  const [precioInput, setPrecioInput] = useState('')
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  // Modal de nueva categoría
  const [nuevaCategoriaForm, setNuevaCategoriaForm] = useState(emptyNuevaCategoria())

  // Modal de eliminar
  const [precioActivo, setPrecioActivo] = useState(null)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  const valCategoria = useValidacion(validarPrecioCategoria, {
    esNueva: tallaSeleccionada === NUEVA_TALLA,
    tallaNueva,
    precio: precioInput,
  })
  const valNueva = useValidacion(validarNuevaCategoria, nuevaCategoriaForm)

  const cambiarNuevaCategoria = (campo, valor) => {
    setNuevaCategoriaForm((prev) => ({ ...prev, [campo]: valor }))
    valNueva.tocar(campo)
  }

  const fetchPrecios = async () => {
    const { data, error } = await supabase
      .from('precio_prenda')
      .select('id_precio, talla, precio, categoria_prenda(id_categoria, nombre, icono, color)')
      .order('id_precio', { ascending: true })

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setPrecios(data)
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchPrecios().then(() => setLoading(false))
  }, [])

  const categorias = useMemo(() => {
    const grupos = []
    precios.forEach((fila) => {
      const categoria = fila.categoria_prenda
      if (!categoria) return
      const grupo = grupos.find((g) => g.id_categoria === categoria.id_categoria)
      const talla = { id_precio: fila.id_precio, talla: fila.talla, precio: fila.precio }
      if (grupo) {
        grupo.tallas.push(talla)
      } else {
        grupos.push({ ...categoria, tallas: [talla] })
      }
    })
    return grupos
  }, [precios])

  const cerrarModal = () => {
    setModo(null)
    setCategoriaActiva(null)
    setTallaSeleccionada('')
    setTallaNueva('')
    setPrecioInput('')
    setFormError(null)
    setPrecioActivo(null)
    setDeleteError(null)
  }

  const abrirCategoria = (categoria) => {
    setCategoriaActiva(categoria)
    const primera = categoria.tallas[0]
    setTallaSeleccionada(primera ? primera.talla : NUEVA_TALLA)
    setTallaNueva('')
    setPrecioInput(primera ? String(primera.precio) : '')
    setFormError(null)
    valCategoria.reiniciar()
    setModo('categoria')
  }

  const abrirNuevaCategoria = () => {
    setNuevaCategoriaForm(emptyNuevaCategoria())
    setFormError(null)
    valNueva.reiniciar()
    setModo('nuevaCategoria')
  }

  const handleSeleccionTalla = (value) => {
    setTallaSeleccionada(value)
    setTallaNueva('')
    setFormError(null)
    valCategoria.reiniciar()
    if (value === NUEVA_TALLA) {
      setPrecioInput('')
    } else {
      const fila = categoriaActiva?.tallas.find((t) => t.talla === value)
      setPrecioInput(fila ? String(fila.precio) : '')
    }
  }

  const filaSeleccionada = useMemo(() => {
    if (!categoriaActiva || tallaSeleccionada === NUEVA_TALLA) return null
    return categoriaActiva.tallas.find((t) => t.talla === tallaSeleccionada) ?? null
  }, [categoriaActiva, tallaSeleccionada])

  const guardarPrecioCategoria = async (event) => {
    event.preventDefault()
    setFormError(null)

    const esNueva = tallaSeleccionada === NUEVA_TALLA
    const talla = (esNueva ? tallaNueva : tallaSeleccionada).trim()
    const precio = Number(precioInput)

    if (!valCategoria.validarEnvio()) return

    setSubmitting(true)
    try {
      if (esNueva) {
        const { error } = await supabase
          .from('precio_prenda')
          .insert({ id_categoria: categoriaActiva.id_categoria, talla, precio })
        if (error) throw error
      } else {
        const { error } = await supabase
          .from('precio_prenda')
          .update({ precio })
          .eq('id_precio', filaSeleccionada.id_precio)
        if (error) throw error
      }

      await fetchPrecios()
      cerrarModal()
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el precio.')
    } finally {
      setSubmitting(false)
    }
  }

  const handleSubmitNuevaCategoria = async (event) => {
    event.preventDefault()
    setFormError(null)

    const nombre = nuevaCategoriaForm.nombre.trim()
    const talla = nuevaCategoriaForm.talla.trim()
    const precio = Number(nuevaCategoriaForm.precio)

    if (!valNueva.validarEnvio()) return

    setSubmitting(true)
    try {
      const { data: nuevaCategoria, error: errorCategoria } = await supabase
        .from('categoria_prenda')
        .insert({
          nombre,
          icono: nuevaCategoriaForm.icono,
          color: COLORES_CATEGORIA[nuevaCategoriaForm.color].value,
        })
        .select('id_categoria')
        .single()
      if (errorCategoria) throw errorCategoria

      const { error: errorPrecio } = await supabase
        .from('precio_prenda')
        .insert({ id_categoria: nuevaCategoria.id_categoria, talla, precio })
      if (errorPrecio) throw errorPrecio

      await fetchPrecios()
      cerrarModal()
    } catch (err) {
      setFormError(err.message ?? 'No se pudo crear la categoría.')
    } finally {
      setSubmitting(false)
    }
  }

  const abrirEliminar = (precio) => {
    setPrecioActivo(precio)
    setDeleteError(null)
    setModo('eliminar')
  }

  const confirmarEliminar = async () => {
    if (!precioActivo) return

    setDeleting(true)
    setDeleteError(null)
    const { error } = await supabase.from('precio_prenda').delete().eq('id_precio', precioActivo.id_precio)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    await fetchPrecios()
    cerrarModal()
  }

  return (
    <div className="precios-page">
      <div className="usuarios-header">
        <h1 className="page-title">
          Lista de precios
          <img src={iconoTaller} alt="" className="page-title-icon" />
        </h1>
        <button type="button" onClick={abrirNuevaCategoria}>
          Nueva categoría
        </button>
      </div>

      {loading && <p>Cargando precios...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <div className="precios-admin-grid">
          {categorias.map((categoria) => {
            const Icono = getIconoCategoria(categoria.icono)
            const montos = categoria.tallas.map((t) => t.precio)
            const min = Math.min(...montos)
            const max = Math.max(...montos)
            return (
              <button
                type="button"
                key={categoria.id_categoria}
                className="precio-card precio-card-admin"
                style={{ '--card-color': categoria.color ?? 'var(--accent)' }}
                onClick={() => abrirCategoria(categoria)}
              >
                <div className="precio-card-header">
                  <Icono />
                  <h3>{categoria.nombre}</h3>
                </div>
                <p className="precio-card-resumen">
                  {categoria.tallas.length} {categoria.tallas.length === 1 ? 'talla' : 'tallas'} ·{' '}
                  {min === max ? formatPrecio(min) : `${formatPrecio(min)} – ${formatPrecio(max)}`}
                </p>
              </button>
            )
          })}
          {categorias.length === 0 && <p>Todavía no hay precios registrados.</p>}
        </div>
      )}

      {modo === 'categoria' && categoriaActiva && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>{categoriaActiva.nombre}</h2>
            <form className="usuario-form" onSubmit={guardarPrecioCategoria} noValidate>
              <label>
                Talla
                <select value={tallaSeleccionada} onChange={(e) => handleSeleccionTalla(e.target.value)}>
                  {categoriaActiva.tallas.map((fila) => (
                    <option key={fila.talla} value={fila.talla}>
                      {fila.talla}
                    </option>
                  ))}
                  <option value={NUEVA_TALLA}>+ Agregar nueva talla...</option>
                </select>
              </label>

              {tallaSeleccionada === NUEVA_TALLA && (
                <label>
                  Nombre de la nueva talla
                  <input
                    value={tallaNueva}
                    onChange={(e) => {
                      setTallaNueva(e.target.value)
                      valCategoria.tocar('tallaNueva')
                    }}
                    placeholder="Ej: Talla 14 y 16"
                    aria-invalid={Boolean(valCategoria.errorDe('tallaNueva'))}
                  />
                  <FieldError mensaje={valCategoria.errorDe('tallaNueva')} />
                </label>
              )}

              <label>
                Precio actual (CLP)
                <input
                  inputMode="numeric"
                  maxLength={MAX_DIGITOS_PRECIO}
                  value={precioInput}
                  onChange={(e) => {
                    setPrecioInput(limpiarPrecio(e.target.value))
                    valCategoria.tocar('precio')
                  }}
                  aria-invalid={Boolean(valCategoria.errorDe('precio'))}
                />
                <FieldError mensaje={valCategoria.errorDe('precio')} />
              </label>

              {formError && <p className="form-error">{formError}</p>}

              <div className="modal-actions modal-actions-split">
                {filaSeleccionada && (
                  <button
                    type="button"
                    className="btn-danger"
                    onClick={() => abrirEliminar(filaSeleccionada)}
                  >
                    Eliminar talla
                  </button>
                )}
                <div className="modal-actions">
                  <button type="button" className="btn-secondary" onClick={cerrarModal}>
                    Cerrar
                  </button>
                  <button type="submit" disabled={submitting}>
                    {submitting ? 'Guardando...' : 'Guardar'}
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      )}

      {modo === 'nuevaCategoria' && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Nueva categoría</h2>
            <form className="usuario-form" onSubmit={handleSubmitNuevaCategoria} noValidate>
              <label>
                Nombre de la categoría
                <input
                  value={nuevaCategoriaForm.nombre}
                  onChange={(e) => cambiarNuevaCategoria('nombre', e.target.value)}
                  placeholder="Ej: Buzos Escolares"
                  aria-invalid={Boolean(valNueva.errorDe('nombre'))}
                />
                <FieldError mensaje={valNueva.errorDe('nombre')} />
              </label>
              <label>
                Icono
                <select
                  value={nuevaCategoriaForm.icono}
                  onChange={(e) => setNuevaCategoriaForm((prev) => ({ ...prev, icono: e.target.value }))}
                >
                  {Object.entries(ICONOS_CATEGORIA).map(([key, { label }]) => (
                    <option key={key} value={key}>
                      {label}
                    </option>
                  ))}
                </select>
              </label>
              <label>
                Color
                <select
                  value={nuevaCategoriaForm.color}
                  onChange={(e) => setNuevaCategoriaForm((prev) => ({ ...prev, color: e.target.value }))}
                >
                  {Object.entries(COLORES_CATEGORIA).map(([key, { label }]) => (
                    <option key={key} value={key}>
                      {label}
                    </option>
                  ))}
                </select>
              </label>
              <label>
                Talla
                <input
                  value={nuevaCategoriaForm.talla}
                  onChange={(e) => cambiarNuevaCategoria('talla', e.target.value)}
                  placeholder="Ej: Talla 10 y 12"
                  aria-invalid={Boolean(valNueva.errorDe('talla'))}
                />
                <FieldError mensaje={valNueva.errorDe('talla')} />
              </label>
              <label>
                Precio (CLP)
                <input
                  inputMode="numeric"
                  maxLength={MAX_DIGITOS_PRECIO}
                  value={nuevaCategoriaForm.precio}
                  onChange={(e) => cambiarNuevaCategoria('precio', limpiarPrecio(e.target.value))}
                  aria-invalid={Boolean(valNueva.errorDe('precio'))}
                />
                <FieldError mensaje={valNueva.errorDe('precio')} />
              </label>

              {formError && <p className="form-error">{formError}</p>}

              <div className="modal-actions">
                <button type="button" className="btn-secondary" onClick={cerrarModal}>
                  Cancelar
                </button>
                <button type="submit" disabled={submitting}>
                  {submitting ? 'Guardando...' : 'Guardar'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {modo === 'eliminar' && precioActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar talla</h2>
            <p>
              ¿Seguro que deseas eliminar el siguiente precio?
              <br />
              <strong>
                {categoriaActiva?.nombre} — {precioActivo.talla}
              </strong>
            </p>
            <p className="modal-hint">Esta acción no se puede deshacer y dejará de mostrarse en el landing.</p>

            {deleteError && <p className="form-error">{deleteError}</p>}

            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={() => setModo('categoria')}>
                Cancelar
              </button>
              <button type="button" className="btn-danger" disabled={deleting} onClick={confirmarEliminar}>
                {deleting ? 'Eliminando...' : 'Eliminar'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
