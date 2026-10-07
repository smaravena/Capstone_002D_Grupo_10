--
-- PostgreSQL database dump
--

\restrict ATZXfUCIUXaeOfVThdBMp08jhOkNMKYPrml5BrIcfayGpL3hRQ8eILFqDUQeO3J

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: es_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.es_admin() RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select exists (
    select 1 from usuario
    where auth_user_id = auth.uid() and rol_usu = 'admin'
  )
$$;


ALTER FUNCTION public.es_admin() OWNER TO postgres;

--
-- Name: establecer_password_inicial(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.establecer_password_inicial(p_correo text, p_password text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth', 'extensions'
    AS $$
declare
  v_auth_id uuid;
  v_password_establecida boolean;
begin
  select u.auth_user_id, u.password_establecida
    into v_auth_id, v_password_establecida
  from public.usuario u
  where lower(u.correo) = lower(p_correo);

  if not found then
    raise exception 'Este correo no está registrado en el sistema.';
  end if;

  if v_password_establecida then
    raise exception 'Este correo ya tiene una contraseña definida.';
  end if;

  if v_auth_id is null then
    select au.id into v_auth_id from auth.users au where lower(au.email) = lower(p_correo);
  end if;

  if v_auth_id is null then
    raise exception 'No existe una cuenta de acceso para este correo.';
  end if;

  update auth.users
  set encrypted_password = crypt(p_password, gen_salt('bf')),
      email_confirmed_at = coalesce(email_confirmed_at, now()),
      updated_at = now()
  where id = v_auth_id;

  update public.usuario
  set auth_user_id = v_auth_id,
      password_establecida = true
  where lower(correo) = lower(p_correo);
end;
$$;


ALTER FUNCTION public.establecer_password_inicial(p_correo text, p_password text) OWNER TO postgres;

--
-- Name: rls_auto_enable(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_auto_enable() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.rls_auto_enable() OWNER TO postgres;

--
-- Name: usuario_actual_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_actual_id() RETURNS integer
    LANGUAGE sql STABLE
    AS $$
  select id_usu from usuario where auth_user_id = auth.uid()
$$;


ALTER FUNCTION public.usuario_actual_id() OWNER TO postgres;

--
-- Name: usuario_estado_login(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_estado_login(p_correo text) RETURNS TABLE(existe boolean, tiene_password boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  return query
  select
    exists(select 1 from public.usuario u where lower(u.correo) = lower(p_correo)) as existe,
    coalesce(
      (select u.password_establecida from public.usuario u where lower(u.correo) = lower(p_correo)),
      false
    ) as tiene_password;
end;
$$;


ALTER FUNCTION public.usuario_estado_login(p_correo text) OWNER TO postgres;

--
-- Name: usuario_existe(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_existe(p_correo text) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  select exists (
    select 1 from public.usuario
    where lower(correo) = lower(p_correo)
  );
$$;


ALTER FUNCTION public.usuario_existe(p_correo text) OWNER TO postgres;

--
-- Name: vincular_usuario_actual(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.vincular_usuario_actual() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  update public.usuario
  set auth_user_id = auth.uid()
  where lower(correo) = lower(auth.jwt() ->> 'email')
    and auth_user_id is null;
end;
$$;


ALTER FUNCTION public.vincular_usuario_actual() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categoria_prenda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_prenda (
    id_categoria bigint NOT NULL,
    nombre text NOT NULL,
    icono text DEFAULT 'shirt'::text NOT NULL,
    color text DEFAULT 'var(--accent)'::text NOT NULL
);


ALTER TABLE public.categoria_prenda OWNER TO postgres;

--
-- Name: categoria_prenda_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categoria_prenda ALTER COLUMN id_categoria ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categoria_prenda_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id_cli integer NOT NULL,
    nom_cli character varying(40) NOT NULL,
    num_cli character varying(9) NOT NULL,
    correo_cli character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_id_cli_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_id_cli_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_id_cli_seq OWNER TO postgres;

--
-- Name: cliente_id_cli_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_cli_seq OWNED BY public.cliente.id_cli;


--
-- Name: detalle_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_pedido (
    id_detalle integer NOT NULL,
    cant_prendas integer NOT NULL,
    tipo_prenda character varying(50) NOT NULL,
    obs_detalle character varying(200),
    id_pedido integer NOT NULL,
    talla text,
    precio numeric,
    CONSTRAINT detalle_pedido_cant_prendas_check CHECK ((cant_prendas > 0))
);


ALTER TABLE public.detalle_pedido OWNER TO postgres;

--
-- Name: detalle_pedido_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_pedido_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_pedido_id_detalle_seq OWNER TO postgres;

--
-- Name: detalle_pedido_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_pedido_id_detalle_seq OWNED BY public.detalle_pedido.id_detalle;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    id_pedido integer NOT NULL,
    fec_ini date NOT NULL,
    fec_ter date NOT NULL,
    id_cli integer NOT NULL,
    estado_pedido character varying(20) DEFAULT 'pendiente'::character varying NOT NULL,
    calendar_event_id character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id_usu_responsable integer,
    CONSTRAINT chk_fechas CHECK ((fec_ter >= fec_ini))
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_id_pedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_id_pedido_seq OWNER TO postgres;

--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_id_pedido_seq OWNED BY public.pedido.id_pedido;


--
-- Name: precio_prenda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.precio_prenda (
    id_precio bigint NOT NULL,
    talla text NOT NULL,
    precio numeric(10,0) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id_categoria bigint NOT NULL
);


ALTER TABLE public.precio_prenda OWNER TO postgres;

--
-- Name: TABLE precio_prenda; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.precio_prenda IS 'Precios fijos por talla de prendas escolares, mostrados en el landing público.';


--
-- Name: precio_prenda_id_precio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.precio_prenda ALTER COLUMN id_precio ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.precio_prenda_id_precio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: trabajo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trabajo (
    id_trabajo integer NOT NULL,
    id_usu integer NOT NULL,
    id_detalle integer NOT NULL,
    tipo_trabajo character varying(50) NOT NULL,
    estado character varying(20) DEFAULT 'pendiente'::character varying NOT NULL,
    fecha_asignacion timestamp with time zone DEFAULT now() NOT NULL,
    fecha_termino timestamp with time zone,
    CONSTRAINT trabajo_estado_check CHECK (((estado)::text = ANY ((ARRAY['pendiente'::character varying, 'en progreso'::character varying, 'terminado'::character varying])::text[]))),
    CONSTRAINT trabajo_tipo_trabajo_check CHECK (((tipo_trabajo)::text = ANY ((ARRAY['corte'::character varying, 'armado'::character varying])::text[])))
);


ALTER TABLE public.trabajo OWNER TO postgres;

--
-- Name: trabajo_id_trabajo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trabajo_id_trabajo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trabajo_id_trabajo_seq OWNER TO postgres;

--
-- Name: trabajo_id_trabajo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trabajo_id_trabajo_seq OWNED BY public.trabajo.id_trabajo;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usu integer NOT NULL,
    nom_usuario character varying(20) NOT NULL,
    ape_usuario character varying(20) NOT NULL,
    rol_usu character varying(20) NOT NULL,
    auth_user_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    correo text,
    password_establecida boolean DEFAULT false NOT NULL,
    CONSTRAINT usuario_rol_usu_check CHECK (((rol_usu)::text = ANY (ARRAY['admin'::text, 'trabajador'::text, 'Jefa de taller'::text, 'Cortadora'::text, 'Operaria'::text])))
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_usu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usu_seq OWNER TO postgres;

--
-- Name: usuario_id_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usu_seq OWNED BY public.usuario.id_usu;


--
-- Name: cliente id_cli; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id_cli SET DEFAULT nextval('public.cliente_id_cli_seq'::regclass);


--
-- Name: detalle_pedido id_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedido ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_pedido_id_detalle_seq'::regclass);


--
-- Name: pedido id_pedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN id_pedido SET DEFAULT nextval('public.pedido_id_pedido_seq'::regclass);


--
-- Name: trabajo id_trabajo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabajo ALTER COLUMN id_trabajo SET DEFAULT nextval('public.trabajo_id_trabajo_seq'::regclass);


--
-- Name: usuario id_usu; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usu SET DEFAULT nextval('public.usuario_id_usu_seq'::regclass);


--
-- Name: categoria_prenda categoria_prenda_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_prenda
    ADD CONSTRAINT categoria_prenda_nombre_key UNIQUE (nombre);


--
-- Name: categoria_prenda categoria_prenda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_prenda
    ADD CONSTRAINT categoria_prenda_pkey PRIMARY KEY (id_categoria);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cli);


--
-- Name: detalle_pedido detalle_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_pkey PRIMARY KEY (id_detalle);


--
-- Name: pedido pedido_estado_pedido_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.pedido
    ADD CONSTRAINT pedido_estado_pedido_check CHECK (((estado_pedido)::text = ANY ((ARRAY['pendiente'::character varying, 'en progreso'::character varying, 'por revisar'::character varying, 'listo'::character varying])::text[]))) NOT VALID;


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id_pedido);


--
-- Name: precio_prenda precio_prenda_categoria_talla_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.precio_prenda
    ADD CONSTRAINT precio_prenda_categoria_talla_key UNIQUE (id_categoria, talla);


--
-- Name: precio_prenda precio_prenda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.precio_prenda
    ADD CONSTRAINT precio_prenda_pkey PRIMARY KEY (id_precio);


--
-- Name: trabajo trabajo_detalle_usu_tipo_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_detalle_usu_tipo_unique UNIQUE (id_detalle, id_usu, tipo_trabajo);


--
-- Name: trabajo trabajo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_pkey PRIMARY KEY (id_trabajo);


--
-- Name: usuario usuario_auth_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_auth_user_id_key UNIQUE (auth_user_id);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usu);


--
-- Name: idx_detalle_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detalle_pedido ON public.detalle_pedido USING btree (id_pedido);


--
-- Name: idx_pedido_cliente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_cliente ON public.pedido USING btree (id_cli);


--
-- Name: idx_pedido_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_estado ON public.pedido USING btree (estado_pedido);


--
-- Name: idx_trabajo_detalle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trabajo_detalle ON public.trabajo USING btree (id_detalle);


--
-- Name: idx_trabajo_id_detalle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trabajo_id_detalle ON public.trabajo USING btree (id_detalle);


--
-- Name: idx_trabajo_id_usu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trabajo_id_usu ON public.trabajo USING btree (id_usu);


--
-- Name: idx_trabajo_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trabajo_usuario ON public.trabajo USING btree (id_usu);


--
-- Name: usuario_correo_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX usuario_correo_key ON public.usuario USING btree (lower(correo)) WHERE (correo IS NOT NULL);


--
-- Name: detalle_pedido detalle_pedido_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedido(id_pedido) ON DELETE CASCADE;


--
-- Name: pedido pedido_id_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_id_cli_fkey FOREIGN KEY (id_cli) REFERENCES public.cliente(id_cli) ON DELETE RESTRICT;


--
-- Name: pedido pedido_id_usu_responsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_id_usu_responsable_fkey FOREIGN KEY (id_usu_responsable) REFERENCES public.usuario(id_usu);


--
-- Name: precio_prenda precio_prenda_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.precio_prenda
    ADD CONSTRAINT precio_prenda_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria_prenda(id_categoria);


--
-- Name: trabajo trabajo_id_detalle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_id_detalle_fkey FOREIGN KEY (id_detalle) REFERENCES public.detalle_pedido(id_detalle) ON DELETE CASCADE;


--
-- Name: trabajo trabajo_id_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_id_usu_fkey FOREIGN KEY (id_usu) REFERENCES public.usuario(id_usu) ON DELETE RESTRICT;


--
-- Name: usuario usuario_auth_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: categoria_prenda Categorias editables por usuarios autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Categorias editables por usuarios autenticados" ON public.categoria_prenda TO authenticated USING (true) WITH CHECK (true);


--
-- Name: categoria_prenda Categorias visibles para todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Categorias visibles para todos" ON public.categoria_prenda FOR SELECT USING (true);


--
-- Name: cliente Usuarios autenticados pueden actualizar clientes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden actualizar clientes" ON public.cliente FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden actualizar detalle_pedido; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden actualizar detalle_pedido" ON public.detalle_pedido FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: pedido Usuarios autenticados pueden actualizar pedidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden actualizar pedidos" ON public.pedido FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: cliente Usuarios autenticados pueden eliminar clientes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden eliminar clientes" ON public.cliente FOR DELETE TO authenticated USING (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden eliminar detalle_pedido; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden eliminar detalle_pedido" ON public.detalle_pedido FOR DELETE TO authenticated USING (true);


--
-- Name: pedido Usuarios autenticados pueden eliminar pedidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden eliminar pedidos" ON public.pedido FOR DELETE TO authenticated USING (true);


--
-- Name: cliente Usuarios autenticados pueden insertar clientes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden insertar clientes" ON public.cliente FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden insertar detalle_pedido; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden insertar detalle_pedido" ON public.detalle_pedido FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: pedido Usuarios autenticados pueden insertar pedidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden insertar pedidos" ON public.pedido FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: cliente Usuarios autenticados pueden ver clientes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden ver clientes" ON public.cliente FOR SELECT TO authenticated USING (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden ver detalle_pedido; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden ver detalle_pedido" ON public.detalle_pedido FOR SELECT TO authenticated USING (true);


--
-- Name: pedido Usuarios autenticados pueden ver pedidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios autenticados pueden ver pedidos" ON public.pedido FOR SELECT TO authenticated USING (true);


--
-- Name: cliente admin gestiona clientes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admin gestiona clientes" ON public.cliente USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: detalle_pedido admin gestiona detalle_pedido; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admin gestiona detalle_pedido" ON public.detalle_pedido USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: pedido admin gestiona pedidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admin gestiona pedidos" ON public.pedido USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: trabajo admin gestiona trabajos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admin gestiona trabajos" ON public.trabajo USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: usuario admin gestiona usuarios; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admin gestiona usuarios" ON public.usuario USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: categoria_prenda; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.categoria_prenda ENABLE ROW LEVEL SECURITY;

--
-- Name: cliente; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.cliente ENABLE ROW LEVEL SECURITY;

--
-- Name: detalle_pedido; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.detalle_pedido ENABLE ROW LEVEL SECURITY;

--
-- Name: pedido; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.pedido ENABLE ROW LEVEL SECURITY;

--
-- Name: precio_prenda; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.precio_prenda ENABLE ROW LEVEL SECURITY;

--
-- Name: precio_prenda precio_prenda_select_public; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY precio_prenda_select_public ON public.precio_prenda FOR SELECT TO authenticated, anon USING (true);


--
-- Name: precio_prenda precio_prenda_write_jefa_taller; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY precio_prenda_write_jefa_taller ON public.precio_prenda TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: trabajo trabajador actualiza estado de su trabajo; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "trabajador actualiza estado de su trabajo" ON public.trabajo FOR UPDATE USING ((id_usu = public.usuario_actual_id())) WITH CHECK ((id_usu = public.usuario_actual_id()));


--
-- Name: detalle_pedido trabajador ve detalle de sus trabajos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "trabajador ve detalle de sus trabajos" ON public.detalle_pedido FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.id_detalle = detalle_pedido.id_detalle) AND (t.id_usu = public.usuario_actual_id())))));


--
-- Name: pedido trabajador ve pedidos asignados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "trabajador ve pedidos asignados" ON public.pedido FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.trabajo t
     JOIN public.detalle_pedido dp ON ((dp.id_detalle = t.id_detalle)))
  WHERE ((dp.id_pedido = pedido.id_pedido) AND (t.id_usu = public.usuario_actual_id())))));


--
-- Name: trabajo trabajador ve sus trabajos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "trabajador ve sus trabajos" ON public.trabajo FOR SELECT USING ((id_usu = public.usuario_actual_id()));


--
-- Name: trabajo; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.trabajo ENABLE ROW LEVEL SECURITY;

--
-- Name: trabajo trabajo_all_jefa; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY trabajo_all_jefa ON public.trabajo USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: trabajo trabajo_select_jefa; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY trabajo_select_jefa ON public.trabajo FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: trabajo trabajo_select_propio; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY trabajo_select_propio ON public.trabajo FOR SELECT USING ((id_usu = ( SELECT u.id_usu
   FROM public.usuario u
  WHERE (u.auth_user_id = auth.uid()))));


--
-- Name: trabajo trabajo_update_propio; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY trabajo_update_propio ON public.trabajo FOR UPDATE USING ((id_usu = ( SELECT u.id_usu
   FROM public.usuario u
  WHERE (u.auth_user_id = auth.uid())))) WITH CHECK ((id_usu = ( SELECT u.id_usu
   FROM public.usuario u
  WHERE (u.auth_user_id = auth.uid()))));


--
-- Name: usuario; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario ENABLE ROW LEVEL SECURITY;

--
-- Name: usuario usuario ve su propio perfil; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "usuario ve su propio perfil" ON public.usuario FOR SELECT USING ((auth_user_id = auth.uid()));


--
-- Name: usuario usuario_delete_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY usuario_delete_authenticated ON public.usuario FOR DELETE TO authenticated USING (true);


--
-- Name: usuario usuario_insert_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY usuario_insert_authenticated ON public.usuario FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: usuario usuario_select_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY usuario_select_authenticated ON public.usuario FOR SELECT TO authenticated USING (true);


--
-- Name: usuario usuario_update_authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY usuario_update_authenticated ON public.usuario FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION establecer_password_inicial(p_correo text, p_password text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.establecer_password_inicial(p_correo text, p_password text) TO anon;
GRANT ALL ON FUNCTION public.establecer_password_inicial(p_correo text, p_password text) TO authenticated;


--
-- Name: FUNCTION usuario_estado_login(p_correo text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.usuario_estado_login(p_correo text) TO anon;
GRANT ALL ON FUNCTION public.usuario_estado_login(p_correo text) TO authenticated;


--
-- Name: FUNCTION usuario_existe(p_correo text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.usuario_existe(p_correo text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.usuario_existe(p_correo text) TO anon;
GRANT ALL ON FUNCTION public.usuario_existe(p_correo text) TO authenticated;


--
-- Name: FUNCTION vincular_usuario_actual(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.vincular_usuario_actual() FROM PUBLIC;
GRANT ALL ON FUNCTION public.vincular_usuario_actual() TO authenticated;


--
-- Name: TABLE categoria_prenda; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.categoria_prenda TO anon;
GRANT ALL ON TABLE public.categoria_prenda TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.categoria_prenda TO service_role;


--
-- Name: SEQUENCE categoria_prenda_id_categoria_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.categoria_prenda_id_categoria_seq TO authenticated;


--
-- Name: TABLE cliente; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.cliente TO anon;
GRANT ALL ON TABLE public.cliente TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.cliente TO service_role;


--
-- Name: SEQUENCE cliente_id_cli_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cliente_id_cli_seq TO authenticated;


--
-- Name: TABLE detalle_pedido; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.detalle_pedido TO anon;
GRANT ALL ON TABLE public.detalle_pedido TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.detalle_pedido TO service_role;


--
-- Name: SEQUENCE detalle_pedido_id_detalle_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.detalle_pedido_id_detalle_seq TO authenticated;


--
-- Name: TABLE pedido; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.pedido TO anon;
GRANT ALL ON TABLE public.pedido TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.pedido TO service_role;


--
-- Name: SEQUENCE pedido_id_pedido_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.pedido_id_pedido_seq TO authenticated;


--
-- Name: TABLE precio_prenda; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.precio_prenda TO anon;
GRANT ALL ON TABLE public.precio_prenda TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.precio_prenda TO service_role;


--
-- Name: TABLE trabajo; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.trabajo TO anon;
GRANT ALL ON TABLE public.trabajo TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.trabajo TO service_role;


--
-- Name: SEQUENCE trabajo_id_trabajo_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.trabajo_id_trabajo_seq TO authenticated;


--
-- Name: TABLE usuario; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.usuario TO anon;
GRANT ALL ON TABLE public.usuario TO authenticated;
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.usuario TO service_role;


--
-- Name: SEQUENCE usuario_id_usu_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.usuario_id_usu_seq TO authenticated;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- PostgreSQL database dump complete
--

\unrestrict ATZXfUCIUXaeOfVThdBMp08jhOkNMKYPrml5BrIcfayGpL3hRQ8eILFqDUQeO3J

