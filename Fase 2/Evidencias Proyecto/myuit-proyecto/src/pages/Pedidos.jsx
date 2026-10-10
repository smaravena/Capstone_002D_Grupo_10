import { useEffect, useMemo, useState } from 'react'
import { supabase } from '../lib/supabaseClient'
import { ESTADOS_PEDIDO } from '../lib/pedidoConstants'
import {
  MAX_DIGITOS_PRECIO,
  construirCelular,
  limpiarPrecio,
  soloErrores,
  validarCantidad,
  validarCelular,
  validarCorreo,
  validarPrecio,
  validarTexto,
} from '../lib/validators'
import { IconEye, IconPencil, IconTrash } from '../components/Icons'
import FieldError from '../components/FieldError'
import TelefonoInput from '../components/TelefonoInput'
import { useValidacion } from '../hooks/useValidacion'
import { useAuth } from '../hooks/useAuth'
import { ROLES } from '../lib/roles'
import iconoTaller from '../assets/icono.png'

const ROLES_SOLO_PROPIOS = [ROLES.CORTADORA, ROLES.OPERARIA]

const TRABAJO_TIPOS = [
  { tipo: 'corte', field: 'id_usu_corte', label: 'Cortadora' },
  { tipo: 'armado', field: 'id_usu_armado', label: 'Operaria (armado)' },
]

const emptyDetalle = () => ({
  tipo_prenda: '',
  talla: '',
  precio: '',
  cant_prendas: 1,
  obs_detalle: '',
  id_usu_corte: '',
  id_usu_armado: '',
})

const emptyForm = () => ({
  clienteMode: 'existing',
  id_cli: '',
  nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
  fec_ini: '',
  fec_ter: '',
  estado_pedido: ESTADOS_PEDIDO[0],
  abono: '',
  detalles: [emptyDetalle()],
})

const formatPrecio = (valor) =>
  new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }).format(valor)

const getResponsables = (pedido) => {
  const nombres = new Set()
  pedido.detalle_pedido?.forEach((d) => {
    d.trabajo?.forEach((t) => {
      if (t.usuario) nombres.add(`${t.usuario.nom_usuario} ${t.usuario.ape_usuario}`)
    })
  })
  return [...nombres]
}

export default function Pedidos() {
  const { usuario, role } = useAuth()
  const soloPropios = ROLES_SOLO_PROPIOS.includes(role)

  const [pedidos, setPedidos] = useState([])
  const [clientes, setClientes] = useState([])
  const [usuarios, setUsuarios] = useState([])
  const [categoriasPrecio, setCategoriasPrecio] = useState([])
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState(null)

  const [modo, setModo] = useState(null) // 'crear' | 'editar' | 'ver' | 'eliminar' | null
  const [pedidoActivo, setPedidoActivo] = useState(null)
  const [form, setForm] = useState(emptyForm())
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [deleteError, setDeleteError] = useState(null)
  const [deleting, setDeleting] = useState(false)

  const cortadoras = usuarios.filter((u) => u.rol_usu === ROLES.CORTADORA || u.rol_usu === ROLES.JEFA_TALLER)
  const operarias = usuarios.filter((u) => u.rol_usu === ROLES.OPERARIA || u.rol_usu === ROLES.JEFA_TALLER)

  // Clientes ordenados por cantidad de pedidos (el más frecuente primero).
  const clientesOrdenados = useMemo(() => {
    const conteo = new Map()
    pedidos.forEach((p) => {
      if (p.cliente?.id_cli) conteo.set(p.cliente.id_cli, (conteo.get(p.cliente.id_cli) ?? 0) + 1)
    })
    return [...clientes].sort((a, b) => {
      const diff = (conteo.get(b.id_cli) ?? 0) - (conteo.get(a.id_cli) ?? 0)
      return diff !== 0 ? diff : a.nom_cli.localeCompare(b.nom_cli)
    })
  }, [clientes, pedidos])

  const fetchPedidoIdsAsignados = async () => {
    if (!usuario?.id_usu) return []

    const { data, error } = await supabase
      .from('trabajo')
      .select('detalle:id_detalle ( id_pedido )')
      .eq('id_usu', usuario.id_usu)

    if (error) {
      setLoadError(error.message)
      return []
    }

    const ids = new Set()
    data?.forEach((t) => {
      if (t.detalle?.id_pedido) ids.add(t.detalle.id_pedido)
    })
    return [...ids]
  }

  const fetchPedidos = async () => {
    let query = supabase
      .from('pedido')
      .select(
        'id_pedido, fec_ini, fec_ter, estado_pedido, abono, created_at, cliente:id_cli ( id_cli, nom_cli, num_cli, correo_cli ), detalle_pedido ( id_detalle, tipo_prenda, talla, precio, cant_prendas, obs_detalle, trabajo ( id_trabajo, tipo_trabajo, id_usu, estado, usuario:id_usu ( nom_usuario, ape_usuario ) ) )',
      )
      .order('created_at', { ascending: false })

    if (soloPropios) {
      const idsAsignados = await fetchPedidoIdsAsignados()
      if (idsAsignados.length === 0) {
        setLoadError(null)
        setPedidos([])
        return
      }
      query = query.in('id_pedido', idsAsignados)
    }

    const { data, error } = await query

    if (error) {
      setLoadError(error.message)
    } else {
      setLoadError(null)
      setPedidos(data)
    }
  }

  const fetchClientes = async () => {
    const { data, error } = await supabase
      .from('cliente')
      .select('id_cli, nom_cli, num_cli, correo_cli')
      .order('nom_cli')

    if (!error) setClientes(data)
  }

  const fetchUsuarios = async () => {
    const { data, error } = await supabase
      .from('usuario')
      .select('id_usu, nom_usuario, ape_usuario, rol_usu')
      .order('nom_usuario')

    if (!error) setUsuarios(data)
  }

  const fetchCategoriasPrecio = async () => {
    const { data, error } = await supabase
      .from('precio_prenda')
      .select('talla, precio, categoria_prenda ( nombre )')
      .order('id_precio', { ascending: true })

    if (error) return

    const grupos = []
    data?.forEach((fila) => {
      const nombre = fila.categoria_prenda?.nombre
      if (!nombre) return
      const grupo = grupos.find((g) => g.nombre === nombre)
      const talla = { talla: fila.talla, precio: fila.precio }
      if (grupo) {
        if (!grupo.tallas.some((t) => t.talla === fila.talla)) grupo.tallas.push(talla)
      } else {
        grupos.push({ nombre, tallas: [talla] })
      }
    })
    setCategoriasPrecio(grupos)
  }

  const getTallasDisponibles = (tipoPrenda) =>
    categoriasPrecio.find((c) => c.nombre === tipoPrenda)?.tallas.map((t) => t.talla) ?? []

  const getPrecioBase = (tipoPrenda, talla) => {
    const categoria = categoriasPrecio.find((c) => c.nombre === tipoPrenda)
    return categoria?.tallas.find((t) => t.talla === talla)?.precio ?? null
  }

  useEffect(() => {
    // Carga inicial de datos: el setState ocurre dentro de fetchPedidos/fetchClientes/fetchUsuarios
    // después del await a Supabase, no de forma síncrona.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    Promise.all([fetchPedidos(), fetchClientes(), fetchUsuarios(), fetchCategoriasPrecio()]).then(() =>
      setLoading(false),
    )
  }, [])

  const handleDetalleChange = (index, field, value) => {
    tocar(`detalles.${index}.${field}`)
    setForm((prev) => {
      const detalles = [...prev.detalles]
      detalles[index] = { ...detalles[index], [field]: value }
      return { ...prev, detalles }
    })
  }

  const handleTipoPrendaChange = (index, tipoPrenda) => {
    tocar(`detalles.${index}.tipo_prenda`)
    setForm((prev) => {
      const detalles = [...prev.detalles]
      const anterior = detalles[index]
      // Solo autocompletamos talla/precio cuando el texto coincide exactamente con
      // una categoría existente (elegida de la lista); si es un tipo nuevo escrito a
      // mano (ej: "Mochila"), dejamos que la persona ingrese talla y precio libremente.
      const coincideCategoria = categoriasPrecio.some((c) => c.nombre === tipoPrenda)
      const talla = coincideCategoria ? (getTallasDisponibles(tipoPrenda)[0] ?? '') : anterior.talla
      const precioBase = coincideCategoria ? getPrecioBase(tipoPrenda, talla) : null
      detalles[index] = {
        ...anterior,
        tipo_prenda: tipoPrenda,
        talla,
        precio: precioBase !== null ? String(precioBase) : anterior.precio,
      }
      return { ...prev, detalles }
    })
  }

  const handleTallaChange = (index, talla) => {
    tocar(`detalles.${index}.talla`)
    setForm((prev) => {
      const detalles = [...prev.detalles]
      const precioBase = getPrecioBase(detalles[index].tipo_prenda, talla)
      detalles[index] = {
        ...detalles[index],
        talla,
        precio: precioBase !== null ? String(precioBase) : detalles[index].precio,
      }
      return { ...prev, detalles }
    })
  }

  const addDetalle = () => {
    setForm((prev) => ({ ...prev, detalles: [...prev.detalles, emptyDetalle()] }))
  }

  const removeDetalle = (index) => {
    setForm((prev) => ({
      ...prev,
      detalles: prev.detalles.filter((_, i) => i !== index),
    }))
  }

  const abrirCrear = () => {
    if (soloPropios) return
    setForm(emptyForm())
    setFormError(null)
    reiniciar()
    setPedidoActivo(null)
    setModo('crear')
  }

  const abrirVer = (pedido) => {
    setPedidoActivo(pedido)
    setModo('ver')
  }

  const abrirEditar = (pedido) => {
    if (soloPropios) return
    setForm({
      clienteMode: 'existing',
      id_cli: pedido.cliente?.id_cli ? String(pedido.cliente.id_cli) : '',
      nuevoCliente: { nom_cli: '', num_cli: '', correo_cli: '' },
      fec_ini: pedido.fec_ini ?? '',
      fec_ter: pedido.fec_ter ?? '',
      estado_pedido: ESTADOS_PEDIDO.includes(pedido.estado_pedido) ? pedido.estado_pedido : ESTADOS_PEDIDO[0],
      abono: pedido.abono != null ? String(pedido.abono) : '',
      detalles: pedido.detalle_pedido?.length
        ? pedido.detalle_pedido.map((d) => {
            const trabajoCorte = d.trabajo?.find((t) => t.tipo_trabajo === 'corte')
            const trabajoArmado = d.trabajo?.find((t) => t.tipo_trabajo === 'armado')
            return {
              id_detalle: d.id_detalle,
              tipo_prenda: d.tipo_prenda,
              talla: d.talla ?? '',
              precio: d.precio != null ? String(d.precio) : '',
              cant_prendas: d.cant_prendas,
              obs_detalle: d.obs_detalle ?? '',
              id_usu_corte: trabajoCorte?.id_usu ? String(trabajoCorte.id_usu) : '',
              id_usu_armado: trabajoArmado?.id_usu ? String(trabajoArmado.id_usu) : '',
            }
          })
        : [emptyDetalle()],
    })
    setFormError(null)
    reiniciar()
    setPedidoActivo(pedido)
    setModo('editar')
  }

  const abrirEliminar = (pedido) => {
    if (soloPropios) return
    setPedidoActivo(pedido)
    setDeleteError(null)
    setModo('eliminar')
  }

  const cerrarModal = () => {
    setModo(null)
    setPedidoActivo(null)
    setForm(emptyForm())
    setFormError(null)
    setDeleteError(null)
  }

  const validarPedido = (valores) => {
    const errores = {}

    if (valores.clienteMode === 'existing') {
      if (!valores.id_cli) errores.id_cli = 'Selecciona un cliente.'
    } else {
      const { nom_cli, num_cli, correo_cli } = valores.nuevoCliente
      errores.nom_cli = validarTexto(nom_cli, 'el nombre del cliente')
      errores.num_cli = validarCelular(num_cli)
      errores.correo_cli = validarCorreo(correo_cli, { obligatorio: false })
    }

    if (!valores.fec_ini) errores.fec_ini = 'Falta la fecha de inicio.'
    if (!valores.fec_ter) {
      errores.fec_ter = 'Falta la fecha de término.'
    } else if (valores.fec_ini && valores.fec_ter < valores.fec_ini) {
      errores.fec_ter = 'La fecha de término no puede ser anterior a la fecha de inicio.'
    }

    if (valores.abono !== '' && (!Number.isFinite(Number(valores.abono)) || Number(valores.abono) < 0)) {
      errores.abono = 'Ingresa un abono válido.'
    }

    if (!ESTADOS_PEDIDO.includes(valores.estado_pedido)) {
      errores.estado_pedido = 'Selecciona un estado válido de la lista.'
    }

    valores.detalles.forEach((detalle, index) => {
      const campo = (nombre) => `detalles.${index}.${nombre}`
      if (!detalle.tipo_prenda.trim()) errores[campo('tipo_prenda')] = 'Indica el tipo de prenda.'
      // La talla es obligatoria solo cuando el tipo de prenda es uno existente (elegido
      // de la lista); si la prenda fue escrita a mano (no existe en Precios), la talla
      // queda opcional porque esa prenda no tiene tallas predefinidas.
      const coincideCategoria = categoriasPrecio.some((c) => c.nombre === detalle.tipo_prenda)
      if (coincideCategoria && !detalle.talla.trim()) errores[campo('talla')] = 'Indica la talla.'
      errores[campo('cant_prendas')] = validarCantidad(detalle.cant_prendas)
      errores[campo('precio')] = validarPrecio(detalle.precio)
      if (!detalle.id_usu_corte) errores[campo('id_usu_corte')] = 'Selecciona una cortadora.'
      if (!detalle.id_usu_armado) errores[campo('id_usu_armado')] = 'Selecciona una operaria.'
    })

    return soloErrores(errores)
  }

  const { errorDe, tocar, validarEnvio, reiniciar } = useValidacion(validarPedido, form)

  const cambiarNuevoCliente = (campo, valor) => {
    setForm((prev) => ({ ...prev, nuevoCliente: { ...prev.nuevoCliente, [campo]: valor } }))
    tocar(campo)
  }

  const syncTrabajoAsignaciones = async (id_detalle, detalle, trabajosExistentes = []) => {
    for (const { tipo, field } of TRABAJO_TIPOS) {
      const selectedUsu = detalle[field]
      const existente = trabajosExistentes.find((t) => t.tipo_trabajo === tipo)

      if (selectedUsu) {
        if (existente) {
          if (String(existente.id_usu) !== String(selectedUsu)) {
            const { error } = await supabase
              .from('trabajo')
              .update({ id_usu: selectedUsu })
              .eq('id_trabajo', existente.id_trabajo)
            if (error) throw error
          }
        } else {
          const { error } = await supabase
            .from('trabajo')
            .insert({ id_detalle, id_usu: selectedUsu, tipo_trabajo: tipo })
          if (error) throw error
        }
      } else if (existente) {
        const { error } = await supabase.from('trabajo').delete().eq('id_trabajo', existente.id_trabajo)
        if (error) throw error
      }
    }
  }

  const guardarDetallesEdicion = async (id_pedido) => {
    const originalIds = pedidoActivo.detalle_pedido?.map((d) => d.id_detalle) ?? []
    const currentIds = form.detalles.filter((d) => d.id_detalle).map((d) => d.id_detalle)
    const idsToDelete = originalIds.filter((id) => !currentIds.includes(id))

    if (idsToDelete.length > 0) {
      const { error } = await supabase.from('detalle_pedido').delete().in('id_detalle', idsToDelete)
      if (error) throw error
    }

    const toUpdate = form.detalles.filter((d) => d.id_detalle)
    for (const detalle of toUpdate) {
      const { error } = await supabase
        .from('detalle_pedido')
        .update({
          tipo_prenda: detalle.tipo_prenda,
          talla: detalle.talla || null,
          precio: detalle.precio !== '' ? Number(detalle.precio) : null,
          cant_prendas: Number(detalle.cant_prendas) || 0,
          obs_detalle: detalle.obs_detalle || null,
        })
        .eq('id_detalle', detalle.id_detalle)
      if (error) throw error

      const original = pedidoActivo.detalle_pedido.find((d) => d.id_detalle === detalle.id_detalle)
      await syncTrabajoAsignaciones(detalle.id_detalle, detalle, original?.trabajo ?? [])
    }

    const toInsert = form.detalles.filter((d) => !d.id_detalle)
    if (toInsert.length > 0) {
      const { data: nuevosDetalles, error } = await supabase
        .from('detalle_pedido')
        .insert(
          toInsert.map((detalle) => ({
            id_pedido,
            tipo_prenda: detalle.tipo_prenda,
            talla: detalle.talla || null,
            precio: detalle.precio !== '' ? Number(detalle.precio) : null,
            cant_prendas: Number(detalle.cant_prendas) || 0,
            obs_detalle: detalle.obs_detalle || null,
          })),
        )
        .select('id_detalle')
      if (error) throw error

      for (let i = 0; i < toInsert.length; i += 1) {
        await syncTrabajoAsignaciones(nuevosDetalles[i].id_detalle, toInsert[i], [])
      }
    }
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setFormError(null)

    if (!validarEnvio()) {
      setFormError('Revisa los campos marcados en rojo.')
      return
    }

    setSubmitting(true)
    try {
      let id_cli = form.id_cli

      if (form.clienteMode === 'new') {
        const { data: nuevoCliente, error: clienteError } = await supabase
          .from('cliente')
          .insert({
            nom_cli: form.nuevoCliente.nom_cli.trim(),
            num_cli: construirCelular(form.nuevoCliente.num_cli),
            correo_cli: form.nuevoCliente.correo_cli.trim() || null,
          })
          .select('id_cli')
          .single()

        if (clienteError) throw clienteError
        id_cli = nuevoCliente.id_cli
      }

      if (!id_cli) {
        throw new Error('Selecciona o crea un cliente para el pedido.')
      }

      const pedidoPayload = {
        id_cli,
        fec_ini: form.fec_ini || null,
        fec_ter: form.fec_ter || null,
        estado_pedido: form.estado_pedido,
        abono: form.abono !== '' ? Number(form.abono) : null,
      }

      if (modo === 'editar' && pedidoActivo) {
        const { error: pedidoError } = await supabase
          .from('pedido')
          .update(pedidoPayload)
          .eq('id_pedido', pedidoActivo.id_pedido)
        if (pedidoError) throw pedidoError

        await guardarDetallesEdicion(pedidoActivo.id_pedido)
      } else {
        const { data: nuevoPedido, error: pedidoError } = await supabase
          .from('pedido')
          .insert(pedidoPayload)
          .select('id_pedido')
          .single()

        if (pedidoError) throw pedidoError

        const detallesPayload = form.detalles.map((d) => ({
          id_pedido: nuevoPedido.id_pedido,
          tipo_prenda: d.tipo_prenda,
          talla: d.talla || null,
          precio: d.precio !== '' ? Number(d.precio) : null,
          cant_prendas: Number(d.cant_prendas) || 0,
          obs_detalle: d.obs_detalle || null,
        }))

        const { data: nuevosDetalles, error: detalleError } = await supabase
          .from('detalle_pedido')
          .insert(detallesPayload)
          .select('id_detalle')
        if (detalleError) throw detalleError

        for (let i = 0; i < form.detalles.length; i += 1) {
          await syncTrabajoAsignaciones(nuevosDetalles[i].id_detalle, form.detalles[i], [])
        }
      }

      cerrarModal()
      await Promise.all([fetchPedidos(), fetchClientes(), fetchUsuarios()])
    } catch (err) {
      setFormError(err.message ?? 'No se pudo guardar el pedido.')
    } finally {
      setSubmitting(false)
    }
  }

  const confirmarEliminar = async () => {
    if (!pedidoActivo || soloPropios) return

    setDeleting(true)
    setDeleteError(null)

    const { error: detalleError } = await supabase
      .from('detalle_pedido')
      .delete()
      .eq('id_pedido', pedidoActivo.id_pedido)

    if (detalleError) {
      setDeleteError(detalleError.message)
      setDeleting(false)
      return
    }

    const { error } = await supabase.from('pedido').delete().eq('id_pedido', pedidoActivo.id_pedido)
    setDeleting(false)

    if (error) {
      setDeleteError(error.message)
      return
    }
    setPedidos((prev) => prev.filter((p) => p.id_pedido !== pedidoActivo.id_pedido))
    cerrarModal()
  }

  const handleEstadoChange = async (id_pedido, estado_pedido) => {
    const { error } = await supabase.from('pedido').update({ estado_pedido }).eq('id_pedido', id_pedido)
    if (error) {
      setLoadError(error.message)
      return
    }
    setPedidos((prev) => prev.map((p) => (p.id_pedido === id_pedido ? { ...p, estado_pedido } : p)))
  }

  return (
    <div className="pedidos-page">
      <div className="pedidos-header">
        <h1 className="page-title">
          Ingreso y Control de Pedidos
          <img src={iconoTaller} alt="" className="page-title-icon" />
        </h1>
        {!soloPropios && (
          <button type="button" onClick={abrirCrear}>
            Nuevo pedido
          </button>
        )}
      </div>

      {loading && <p>Cargando pedidos...</p>}
      {loadError && <p className="form-error">{loadError}</p>}

      {!loading && !loadError && (
        <table className="pedidos-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Cliente</th>
              <th>Inicio</th>
              <th>Término</th>
              <th>Prendas</th>
              <th>Responsable</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {pedidos.map((pedido) => (
              <tr key={pedido.id_pedido}>
                <td data-label="#">{pedido.id_pedido}</td>
                <td data-label="Cliente">{pedido.cliente?.nom_cli ?? '—'}</td>
                <td data-label="Inicio">{pedido.fec_ini ?? '—'}</td>
                <td data-label="Término">{pedido.fec_ter ?? '—'}</td>
                <td data-label="Prendas">{pedido.detalle_pedido?.length ?? 0}</td>
                <td data-label="Responsable">
                  {getResponsables(pedido).length ? getResponsables(pedido).join(', ') : '—'}
                </td>
                <td data-label="Estado">
                  <select
                    className="estado-select"
                    value={pedido.estado_pedido ?? ''}
                    onChange={(e) => handleEstadoChange(pedido.id_pedido, e.target.value)}
                  >
                    {!ESTADOS_PEDIDO.includes(pedido.estado_pedido) && (
                      <option value={pedido.estado_pedido ?? ''} disabled>
                        {pedido.estado_pedido || 'Sin estado'}
                      </option>
                    )}
                    {ESTADOS_PEDIDO.map((estado) => (
                      <option key={estado} value={estado}>
                        {estado}
                      </option>
                    ))}
                  </select>
                </td>
                <td className="usuarios-actions" data-label="Acciones">
                  <button
                    type="button"
                    className="icon-btn"
                    title="Ver"
                    aria-label="Ver pedido"
                    onClick={() => abrirVer(pedido)}
                  >
                    <IconEye />
                  </button>
                  {!soloPropios && (
                    <>
                      <button
                        type="button"
                        className="icon-btn"
                        title="Editar"
                        aria-label="Editar pedido"
                        onClick={() => abrirEditar(pedido)}
                      >
                        <IconPencil />
                      </button>
                      <button
                        type="button"
                        className="icon-btn icon-btn-danger"
                        title="Eliminar"
                        aria-label="Eliminar pedido"
                        onClick={() => abrirEliminar(pedido)}
                      >
                        <IconTrash />
                      </button>
                    </>
                  )}
                </td>
              </tr>
            ))}
            {pedidos.length === 0 && (
              <tr>
                <td colSpan={8} className="table-empty">Todavía no hay pedidos registrados.</td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {(modo === 'crear' || modo === 'editar') && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>{modo === 'crear' ? 'Nuevo pedido' : 'Editar pedido'}</h2>
            <form className="pedido-form" onSubmit={handleSubmit} noValidate>
              <fieldset>
                <legend>Cliente</legend>
                <div className="cliente-mode-toggle">
                  <label className="radio-label">
                    <input
                      type="radio"
                      name="clienteMode"
                      checked={form.clienteMode === 'existing'}
                      onChange={() => setForm((prev) => ({ ...prev, clienteMode: 'existing' }))}
                    />
                    Cliente existente
                  </label>
                  <label className="radio-label">
                    <input
                      type="radio"
                      name="clienteMode"
                      checked={form.clienteMode === 'new'}
                      onChange={() => setForm((prev) => ({ ...prev, clienteMode: 'new' }))}
                    />
                    Cliente nuevo
                  </label>
                </div>

                {form.clienteMode === 'existing' ? (
                  <>
                    <select
                      value={form.id_cli}
                      onChange={(e) => {
                        setForm((prev) => ({ ...prev, id_cli: e.target.value }))
                        tocar('id_cli')
                      }}
                      aria-invalid={Boolean(errorDe('id_cli'))}
                    >
                      <option value="">Selecciona un cliente</option>
                      {clientesOrdenados.map((c) => (
                        <option key={c.id_cli} value={c.id_cli}>
                          {c.nom_cli}
                        </option>
                      ))}
                    </select>
                    <FieldError mensaje={errorDe('id_cli')} />
                  </>
                ) : (
                  <div className="cliente-nuevo-fields">
                    <div>
                      <input
                        placeholder="Nombre"
                        value={form.nuevoCliente.nom_cli}
                        onChange={(e) => cambiarNuevoCliente('nom_cli', e.target.value)}
                        aria-invalid={Boolean(errorDe('nom_cli'))}
                      />
                      <FieldError mensaje={errorDe('nom_cli')} />
                    </div>
                    <div>
                      <TelefonoInput
                        value={form.nuevoCliente.num_cli}
                        onChange={(valor) => cambiarNuevoCliente('num_cli', valor)}
                        invalid={Boolean(errorDe('num_cli'))}
                      />
                      <FieldError mensaje={errorDe('num_cli')} />
                    </div>
                    <div>
                      <input
                        placeholder="Correo"
                        type="email"
                        value={form.nuevoCliente.correo_cli}
                        onChange={(e) => cambiarNuevoCliente('correo_cli', e.target.value)}
                        aria-invalid={Boolean(errorDe('correo_cli'))}
                      />
                      <FieldError mensaje={errorDe('correo_cli')} />
                    </div>
                  </div>
                )}
              </fieldset>

              <fieldset>
                <legend>Pedido</legend>
                <label>
                  Fecha inicio
                  <div className="date-field">
                    <input
                      type="date"
                      value={form.fec_ini}
                      max={form.fec_ter || undefined}
                      onChange={(e) => {
                        const fec_ini = e.target.value
                        setForm((prev) => ({
                          ...prev,
                          fec_ini,
                          fec_ter: prev.fec_ter && prev.fec_ter < fec_ini ? '' : prev.fec_ter,
                        }))
                        tocar('fec_ini')
                      }}
                      aria-invalid={Boolean(errorDe('fec_ini'))}
                    />
                    {form.fec_ini && (
                      <button
                        type="button"
                        className="date-clear-btn"
                        aria-label="Borrar fecha de inicio"
                        onClick={() => setForm((prev) => ({ ...prev, fec_ini: '' }))}
                      >
                        ×
                      </button>
                    )}
                  </div>
                  <FieldError mensaje={errorDe('fec_ini')} />
                </label>
                <label>
                  Fecha término
                  <div className="date-field">
                    <input
                      type="date"
                      value={form.fec_ter}
                      min={form.fec_ini || undefined}
                      onChange={(e) => {
                        setForm((prev) => ({ ...prev, fec_ter: e.target.value }))
                        tocar('fec_ter')
                      }}
                      aria-invalid={Boolean(errorDe('fec_ter'))}
                    />
                    {form.fec_ter && (
                      <button
                        type="button"
                        className="date-clear-btn"
                        aria-label="Borrar fecha de término"
                        onClick={() => setForm((prev) => ({ ...prev, fec_ter: '' }))}
                      >
                        ×
                      </button>
                    )}
                  </div>
                  <FieldError mensaje={errorDe('fec_ter')} />
                </label>
                <label>
                  Estado
                  <select
                    className="estado-select"
                    value={form.estado_pedido}
                    onChange={(e) => setForm((prev) => ({ ...prev, estado_pedido: e.target.value }))}
                  >
                    {ESTADOS_PEDIDO.map((estado) => (
                      <option key={estado} value={estado}>
                        {estado}
                      </option>
                    ))}
                  </select>
                  <FieldError mensaje={errorDe('estado_pedido')} />
                </label>
                <label>
                  Abono (CLP) <span className="campo-opcional">(opcional)</span>
                  <input
                    type="number"
                    min="0"
                    step="100"
                    placeholder="Abono"
                    value={form.abono}
                    onChange={(e) => setForm((prev) => ({ ...prev, abono: e.target.value }))}
                    aria-invalid={Boolean(errorDe('abono'))}
                  />
                  <FieldError mensaje={errorDe('abono')} />
                </label>
              </fieldset>

              <fieldset>
                <legend>Detalle de prendas</legend>
                <datalist id="datalist-tipos-prenda">
                  {categoriasPrecio.map((c) => (
                    <option key={c.nombre} value={c.nombre} />
                  ))}
                </datalist>
                {form.detalles.map((detalle, index) => (
                  <div className="detalle-item" key={detalle.id_detalle ?? index}>
                    <div className="detalle-row">
                      <div>
                        <input
                          list="datalist-tipos-prenda"
                          value={detalle.tipo_prenda}
                          onChange={(e) => handleTipoPrendaChange(index, e.target.value)}
                          placeholder="Tipo de prenda"
                          aria-label="Tipo de prenda"
                          aria-invalid={Boolean(errorDe(`detalles.${index}.tipo_prenda`))}
                        />
                        <FieldError mensaje={errorDe(`detalles.${index}.tipo_prenda`)} />
                      </div>
                      <div>
                        <input
                          list={`datalist-tallas-${index}`}
                          value={detalle.talla}
                          onChange={(e) => handleTallaChange(index, e.target.value)}
                          placeholder={
                            categoriasPrecio.some((c) => c.nombre === detalle.tipo_prenda)
                              ? 'Talla'
                              : 'Talla (opcional)'
                          }
                          aria-label="Talla"
                          aria-invalid={Boolean(errorDe(`detalles.${index}.talla`))}
                        />
                        <datalist id={`datalist-tallas-${index}`}>
                          {getTallasDisponibles(detalle.tipo_prenda).map((talla) => (
                            <option key={talla} value={talla} />
                          ))}
                        </datalist>
                        <FieldError mensaje={errorDe(`detalles.${index}.talla`)} />
                      </div>
                      <div>
                        <input
                          inputMode="numeric"
                          placeholder="Cantidad"
                          aria-label="Cantidad"
                          value={detalle.cant_prendas}
                          onChange={(e) => handleDetalleChange(index, 'cant_prendas', e.target.value.replace(/\D/g, ''))}
                          aria-invalid={Boolean(errorDe(`detalles.${index}.cant_prendas`))}
                        />
                        <FieldError mensaje={errorDe(`detalles.${index}.cant_prendas`)} />
                      </div>
                      <button
                        type="button"
                        className="link-btn"
                        onClick={() => removeDetalle(index)}
                        disabled={form.detalles.length === 1}
                      >
                        Quitar
                      </button>
                    </div>
                    <div className="detalle-asignacion">
                      <label>
                        Cortadora
                        <select
                          value={detalle.id_usu_corte}
                          onChange={(e) => handleDetalleChange(index, 'id_usu_corte', e.target.value)}
                          aria-invalid={Boolean(errorDe(`detalles.${index}.id_usu_corte`))}
                        >
                          <option value="">Selecciona una cortadora</option>
                          {cortadoras.map((u) => (
                            <option key={u.id_usu} value={u.id_usu}>
                              {u.nom_usuario} {u.ape_usuario}
                            </option>
                          ))}
                        </select>
                        <FieldError mensaje={errorDe(`detalles.${index}.id_usu_corte`)} />
                      </label>
                      <label>
                        Operaria (armado)
                        <select
                          value={detalle.id_usu_armado}
                          onChange={(e) => handleDetalleChange(index, 'id_usu_armado', e.target.value)}
                          aria-invalid={Boolean(errorDe(`detalles.${index}.id_usu_armado`))}
                        >
                          <option value="">Selecciona una operaria</option>
                          {operarias.map((u) => (
                            <option key={u.id_usu} value={u.id_usu}>
                              {u.nom_usuario} {u.ape_usuario}
                            </option>
                          ))}
                        </select>
                        <FieldError mensaje={errorDe(`detalles.${index}.id_usu_armado`)} />
                      </label>
                    </div>
                    <label className="detalle-precio-label">
                      Precio (CLP)
                      <input
                        inputMode="numeric"
                        maxLength={MAX_DIGITOS_PRECIO}
                        placeholder="Precio (CLP)"
                        value={detalle.precio}
                        onChange={(e) => handleDetalleChange(index, 'precio', limpiarPrecio(e.target.value))}
                        aria-invalid={Boolean(errorDe(`detalles.${index}.precio`))}
                      />
                      <FieldError mensaje={errorDe(`detalles.${index}.precio`)} />
                    </label>
                    <textarea
                      className="detalle-observaciones"
                      placeholder="Observaciones"
                      rows={2}
                      value={detalle.obs_detalle}
                      onChange={(e) => {
                        handleDetalleChange(index, 'obs_detalle', e.target.value)
                        e.target.style.height = 'auto'
                        e.target.style.height = `${e.target.scrollHeight}px`
                      }}
                    />
                  </div>
                ))}
                <button type="button" className="link-btn" onClick={addDetalle}>
                  + Agregar prenda
                </button>
              </fieldset>

              {formError && <p className="form-error">{formError}</p>}

              <div className="modal-actions">
                <button type="button" className="btn-secondary" onClick={cerrarModal}>
                  Cancelar
                </button>
                <button type="submit" disabled={submitting}>
                  {submitting ? 'Guardando...' : 'Guardar pedido'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {modo === 'ver' && pedidoActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card modal-card-lg" onClick={(e) => e.stopPropagation()}>
            <h2>Detalle del pedido</h2>
            <div className="usuario-detalle">
              <div className="detalle-field">
                <span className="detalle-label">ID</span>
                <span className="detalle-value">{pedidoActivo.id_pedido}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Cliente</span>
                <span className="detalle-value">
                  {pedidoActivo.cliente
                    ? `${pedidoActivo.cliente.nom_cli} (${pedidoActivo.cliente.num_cli})`
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha inicio</span>
                <span className="detalle-value">{pedidoActivo.fec_ini ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Fecha término</span>
                <span className="detalle-value">{pedidoActivo.fec_ter ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Estado</span>
                <span className="detalle-value">{pedidoActivo.estado_pedido ?? '—'}</span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Abono</span>
                <span className="detalle-value">
                  {pedidoActivo.abono != null ? formatPrecio(pedidoActivo.abono) : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Responsable(s)</span>
                <span className="detalle-value">
                  {getResponsables(pedidoActivo).length
                    ? getResponsables(pedidoActivo).join(', ')
                    : '—'}
                </span>
              </div>
              <div className="detalle-field">
                <span className="detalle-label">Prendas</span>
                <span className="detalle-value">
                  {pedidoActivo.detalle_pedido?.length ? (
                    <ul className="detalle-prendas-list">
                      {pedidoActivo.detalle_pedido.map((d) => {
                        const trabajoCorte = d.trabajo?.find((t) => t.tipo_trabajo === 'corte')
                        const trabajoArmado = d.trabajo?.find((t) => t.tipo_trabajo === 'armado')
                        return (
                          <li key={d.id_detalle}>
                            {d.cant_prendas}x {d.tipo_prenda}
                            {d.talla ? ` (Talla ${d.talla})` : ''}
                            {d.precio != null ? ` — ${formatPrecio(d.precio)}` : ''}
                            {d.obs_detalle ? ` — ${d.obs_detalle}` : ''}
                            <br />
                            <small>
                              Corte:{' '}
                              {trabajoCorte?.usuario
                                ? `${trabajoCorte.usuario.nom_usuario} ${trabajoCorte.usuario.ape_usuario} (${trabajoCorte.estado})`
                                : 'sin asignar'}
                              {' · '}
                              Armado:{' '}
                              {trabajoArmado?.usuario
                                ? `${trabajoArmado.usuario.nom_usuario} ${trabajoArmado.usuario.ape_usuario} (${trabajoArmado.estado})`
                                : 'sin asignar'}
                            </small>
                          </li>
                        )
                      })}
                    </ul>
                  ) : (
                    '—'
                  )}
                </span>
              </div>
            </div>
            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cerrarModal}>
                Cerrar
              </button>
            </div>
          </div>
        </div>
      )}

      {modo === 'eliminar' && pedidoActivo && (
        <div className="modal-overlay" onClick={cerrarModal}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>Eliminar pedido</h2>
            <p>
              ¿Seguro que deseas eliminar el pedido #{pedidoActivo.id_pedido}
              {pedidoActivo.cliente ? ` de ` : ''}
              {pedidoActivo.cliente && <strong>{pedidoActivo.cliente.nom_cli}</strong>}?
            </p>
            <p className="modal-hint">Esta acción no se puede deshacer y eliminará también su detalle de prendas.</p>

            {deleteError && <p className="form-error">{deleteError}</p>}

            <div className="modal-actions">
              <button type="button" className="btn-secondary" onClick={cerrarModal}>
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
