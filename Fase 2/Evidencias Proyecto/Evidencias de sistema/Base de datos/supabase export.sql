--
-- PostgreSQL database dump
--

\restrict 7rMV5Rtz2mi5LeUhBwq9j7xccWUrTsWoGMi70bx17UkuGIyhI6hc3mi3YH64Gmt

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

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
DROP EVENT TRIGGER IF EXISTS issue_pg_net_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_graphql_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_cron_access;
DROP EVENT TRIGGER IF EXISTS issue_graphql_placeholder;
DROP EVENT TRIGGER IF EXISTS ensure_rls;
DROP PUBLICATION IF EXISTS supabase_realtime;
DROP POLICY IF EXISTS usuario_update_authenticated ON public.usuario;
DROP POLICY IF EXISTS usuario_select_authenticated ON public.usuario;
DROP POLICY IF EXISTS usuario_insert_authenticated ON public.usuario;
DROP POLICY IF EXISTS usuario_delete_authenticated ON public.usuario;
DROP POLICY IF EXISTS "usuario ve su propio perfil" ON public.usuario;
DROP POLICY IF EXISTS trabajo_update_propio ON public.trabajo;
DROP POLICY IF EXISTS trabajo_select_propio ON public.trabajo;
DROP POLICY IF EXISTS trabajo_select_jefa ON public.trabajo;
DROP POLICY IF EXISTS trabajo_all_jefa ON public.trabajo;
DROP POLICY IF EXISTS "trabajador ve sus trabajos" ON public.trabajo;
DROP POLICY IF EXISTS "trabajador ve pedidos asignados" ON public.pedido;
DROP POLICY IF EXISTS "trabajador ve detalle de sus trabajos" ON public.detalle_pedido;
DROP POLICY IF EXISTS "trabajador actualiza estado de su trabajo" ON public.trabajo;
DROP POLICY IF EXISTS precio_prenda_write_jefa_taller ON public.precio_prenda;
DROP POLICY IF EXISTS precio_prenda_select_public ON public.precio_prenda;
DROP POLICY IF EXISTS "admin gestiona usuarios" ON public.usuario;
DROP POLICY IF EXISTS "admin gestiona trabajos" ON public.trabajo;
DROP POLICY IF EXISTS "admin gestiona pedidos" ON public.pedido;
DROP POLICY IF EXISTS "admin gestiona detalle_pedido" ON public.detalle_pedido;
DROP POLICY IF EXISTS "admin gestiona clientes" ON public.cliente;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver trabajo_historial" ON public.trabajo_historial;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver servicios" ON public.servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver pedidos" ON public.pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver detalle_servicio" ON public.detalle_servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver detalle_pedido" ON public.detalle_pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver clientes" ON public.cliente;
DROP POLICY IF EXISTS "Usuarios autenticados pueden insertar trabajo_historial" ON public.trabajo_historial;
DROP POLICY IF EXISTS "Usuarios autenticados pueden insertar servicios" ON public.servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden insertar pedidos" ON public.pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden insertar detalle_servicio" ON public.detalle_servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden insertar detalle_pedido" ON public.detalle_pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden insertar clientes" ON public.cliente;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar servicios" ON public.servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar pedidos" ON public.pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar detalle_servicio" ON public.detalle_servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar detalle_pedido" ON public.detalle_pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar clientes" ON public.cliente;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar servicios" ON public.servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar pedidos" ON public.pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar detalle_servicio" ON public.detalle_servicio;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar detalle_pedido" ON public.detalle_pedido;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar clientes" ON public.cliente;
DROP POLICY IF EXISTS "Jefa de taller lee reportes" ON public.reporte_semanal;
DROP POLICY IF EXISTS "Categorias visibles para todos" ON public.categoria_prenda;
DROP POLICY IF EXISTS "Categorias editables por usuarios autenticados" ON public.categoria_prenda;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY storage.bucket_lifecycle_states DROP CONSTRAINT IF EXISTS bucket_lifecycle_states_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_auth_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.trabajo DROP CONSTRAINT IF EXISTS trabajo_id_usu_fkey;
ALTER TABLE IF EXISTS ONLY public.trabajo DROP CONSTRAINT IF EXISTS trabajo_id_detalle_fkey;
ALTER TABLE IF EXISTS ONLY public.trabajo_historial DROP CONSTRAINT IF EXISTS trabajo_historial_id_usu_fkey;
ALTER TABLE IF EXISTS ONLY public.trabajo_historial DROP CONSTRAINT IF EXISTS trabajo_historial_id_trabajo_fkey;
ALTER TABLE IF EXISTS ONLY public.servicio DROP CONSTRAINT IF EXISTS servicio_id_cli_fkey;
ALTER TABLE IF EXISTS ONLY public.reporte_semanal DROP CONSTRAINT IF EXISTS reporte_semanal_generado_por_fkey;
ALTER TABLE IF EXISTS ONLY public.precio_prenda DROP CONSTRAINT IF EXISTS precio_prenda_id_categoria_fkey;
ALTER TABLE IF EXISTS ONLY public.pedido DROP CONSTRAINT IF EXISTS pedido_id_usu_responsable_fkey;
ALTER TABLE IF EXISTS ONLY public.pedido DROP CONSTRAINT IF EXISTS pedido_id_cli_fkey;
ALTER TABLE IF EXISTS ONLY public.detalle_servicio DROP CONSTRAINT IF EXISTS detalle_servicio_id_servicio_fkey;
ALTER TABLE IF EXISTS ONLY public.detalle_pedido DROP CONSTRAINT IF EXISTS detalle_pedido_id_pedido_fkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_credentials DROP CONSTRAINT IF EXISTS webauthn_credentials_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_challenges DROP CONSTRAINT IF EXISTS webauthn_challenges_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_oauth_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.scim_users DROP CONSTRAINT IF EXISTS scim_users_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.scim_users DROP CONSTRAINT IF EXISTS scim_users_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.scim_tokens DROP CONSTRAINT IF EXISTS scim_tokens_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_flow_state_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_codes DROP CONSTRAINT IF EXISTS mfa_recovery_codes_mfa_recovery_code_set_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_code_sets DROP CONSTRAINT IF EXISTS mfa_recovery_code_sets_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_code_sets DROP CONSTRAINT IF EXISTS mfa_recovery_code_sets_mfa_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_auth_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_user_id_fkey;
DROP TRIGGER IF EXISTS wake_lifecycle_on_versioning_enable ON storage.buckets;
DROP TRIGGER IF EXISTS wake_lifecycle_on_policy_write ON storage.buckets;
DROP TRIGGER IF EXISTS update_objects_updated_at ON storage.objects;
DROP TRIGGER IF EXISTS protect_objects_delete ON storage.objects;
DROP TRIGGER IF EXISTS protect_buckets_delete ON storage.buckets;
DROP TRIGGER IF EXISTS protect_bucket_control_update_role ON storage.buckets;
DROP TRIGGER IF EXISTS protect_bucket_control_update ON storage.buckets;
DROP TRIGGER IF EXISTS protect_bucket_control_insert ON storage.buckets;
DROP TRIGGER IF EXISTS protect_active_lifecycle_states ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_versioning_status_transition ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP INDEX IF EXISTS storage.vector_indexes_name_bucket_id_idx;
DROP INDEX IF EXISTS storage.objects_bucket_id_name_version_key;
DROP INDEX IF EXISTS storage.objects_archived_order_uq;
DROP INDEX IF EXISTS storage.objects_archived_due_idx;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.lifecycle_abandoned_artifacts_attempted_at_idx;
DROP INDEX IF EXISTS storage.idx_objects_null_version;
DROP INDEX IF EXISTS storage.idx_objects_delete_markers;
DROP INDEX IF EXISTS storage.idx_objects_current_version;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name_lower;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.buckets_analytics_unique_name_idx;
DROP INDEX IF EXISTS storage.bucket_lifecycle_states_due_idx;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_hash_key;
DROP INDEX IF EXISTS realtime.messages_replay_index;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
DROP INDEX IF EXISTS public.usuario_correo_key;
DROP INDEX IF EXISTS public.idx_trabajo_usuario;
DROP INDEX IF EXISTS public.idx_trabajo_id_usu;
DROP INDEX IF EXISTS public.idx_trabajo_id_detalle;
DROP INDEX IF EXISTS public.idx_trabajo_detalle;
DROP INDEX IF EXISTS public.idx_pedido_estado;
DROP INDEX IF EXISTS public.idx_pedido_cliente;
DROP INDEX IF EXISTS public.idx_detalle_pedido;
DROP INDEX IF EXISTS auth.webauthn_credentials_user_id_idx;
DROP INDEX IF EXISTS auth.webauthn_credentials_credential_id_key;
DROP INDEX IF EXISTS auth.webauthn_challenges_user_id_idx;
DROP INDEX IF EXISTS auth.webauthn_challenges_expires_at_idx;
DROP INDEX IF EXISTS auth.users_is_anonymous_idx;
DROP INDEX IF EXISTS auth.users_instance_id_idx;
DROP INDEX IF EXISTS auth.users_instance_id_email_idx;
DROP INDEX IF EXISTS auth.users_email_partial_key;
DROP INDEX IF EXISTS auth.user_id_created_at_idx;
DROP INDEX IF EXISTS auth.unique_phone_factor_per_user;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_pattern_idx;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_domain_idx;
DROP INDEX IF EXISTS auth.sessions_user_id_idx;
DROP INDEX IF EXISTS auth.sessions_oauth_client_id_idx;
DROP INDEX IF EXISTS auth.sessions_not_after_idx;
DROP INDEX IF EXISTS auth.scim_users_user_name_key;
DROP INDEX IF EXISTS auth.scim_users_user_name_idx;
DROP INDEX IF EXISTS auth.scim_users_user_id_idx;
DROP INDEX IF EXISTS auth.scim_users_updated_at_idx;
DROP INDEX IF EXISTS auth.scim_users_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.scim_users_id_idx;
DROP INDEX IF EXISTS auth.scim_users_external_id_key;
DROP INDEX IF EXISTS auth.scim_users_deleted_at_idx;
DROP INDEX IF EXISTS auth.scim_users_created_at_idx;
DROP INDEX IF EXISTS auth.scim_tokens_token_hash_key;
DROP INDEX IF EXISTS auth.scim_tokens_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.scim_tokens_revoked_at_idx;
DROP INDEX IF EXISTS auth.scim_tokens_expires_at_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_for_email_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_created_at_idx;
DROP INDEX IF EXISTS auth.saml_providers_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_updated_at_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_parent_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_idx;
DROP INDEX IF EXISTS auth.recovery_token_idx;
DROP INDEX IF EXISTS auth.reauthentication_token_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_user_id_token_type_key;
DROP INDEX IF EXISTS auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_link_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.oauth_consents_user_order_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_user_client_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_client_idx;
DROP INDEX IF EXISTS auth.oauth_clients_deleted_at_idx;
DROP INDEX IF EXISTS auth.oauth_auth_pending_exp_idx;
DROP INDEX IF EXISTS auth.mfa_recovery_codes_set_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_friendly_name_unique;
DROP INDEX IF EXISTS auth.mfa_challenge_created_at_idx;
DROP INDEX IF EXISTS auth.idx_users_name;
DROP INDEX IF EXISTS auth.idx_users_last_sign_in_at_desc;
DROP INDEX IF EXISTS auth.idx_users_email;
DROP INDEX IF EXISTS auth.idx_users_created_at_desc;
DROP INDEX IF EXISTS auth.idx_user_id_auth_method;
DROP INDEX IF EXISTS auth.idx_oauth_client_states_created_at;
DROP INDEX IF EXISTS auth.idx_auth_code;
DROP INDEX IF EXISTS auth.identities_user_id_idx;
DROP INDEX IF EXISTS auth.identities_email_idx;
DROP INDEX IF EXISTS auth.flow_state_created_at_idx;
DROP INDEX IF EXISTS auth.factor_id_created_at_idx;
DROP INDEX IF EXISTS auth.email_change_token_new_idx;
DROP INDEX IF EXISTS auth.email_change_token_current_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_provider_type_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_identifier_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_enabled_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_created_at_idx;
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS objects_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_name_key;
ALTER TABLE IF EXISTS ONLY storage.lifecycle_abandoned_artifacts DROP CONSTRAINT IF EXISTS lifecycle_abandoned_artifacts_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_vectors DROP CONSTRAINT IF EXISTS buckets_vectors_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets DROP CONSTRAINT IF EXISTS buckets_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_analytics DROP CONSTRAINT IF EXISTS buckets_analytics_pkey;
ALTER TABLE IF EXISTS ONLY storage.bucket_lifecycle_states DROP CONSTRAINT IF EXISTS bucket_lifecycle_states_pkey;
ALTER TABLE IF EXISTS ONLY realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY realtime.subscription DROP CONSTRAINT IF EXISTS pk_subscription;
ALTER TABLE IF EXISTS ONLY realtime.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS realtime.messages DROP CONSTRAINT IF EXISTS messages_payload_exclusive;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_auth_user_id_key;
ALTER TABLE IF EXISTS ONLY public.trabajo DROP CONSTRAINT IF EXISTS trabajo_pkey;
ALTER TABLE IF EXISTS ONLY public.trabajo_historial DROP CONSTRAINT IF EXISTS trabajo_historial_pkey;
ALTER TABLE IF EXISTS ONLY public.trabajo DROP CONSTRAINT IF EXISTS trabajo_detalle_usu_tipo_unique;
ALTER TABLE IF EXISTS ONLY public.servicio DROP CONSTRAINT IF EXISTS servicio_pkey;
ALTER TABLE IF EXISTS ONLY public.reporte_semanal DROP CONSTRAINT IF EXISTS reporte_semanal_pkey;
ALTER TABLE IF EXISTS ONLY public.precio_prenda DROP CONSTRAINT IF EXISTS precio_prenda_pkey;
ALTER TABLE IF EXISTS ONLY public.precio_prenda DROP CONSTRAINT IF EXISTS precio_prenda_categoria_talla_key;
ALTER TABLE IF EXISTS ONLY public.pedido DROP CONSTRAINT IF EXISTS pedido_pkey;
ALTER TABLE IF EXISTS public.pedido DROP CONSTRAINT IF EXISTS pedido_estado_pedido_check;
ALTER TABLE IF EXISTS ONLY public.detalle_servicio DROP CONSTRAINT IF EXISTS detalle_servicio_pkey;
ALTER TABLE IF EXISTS ONLY public.detalle_pedido DROP CONSTRAINT IF EXISTS detalle_pedido_pkey;
ALTER TABLE IF EXISTS ONLY public.cliente DROP CONSTRAINT IF EXISTS cliente_pkey;
ALTER TABLE IF EXISTS ONLY public.categoria_prenda DROP CONSTRAINT IF EXISTS categoria_prenda_pkey;
ALTER TABLE IF EXISTS ONLY public.categoria_prenda DROP CONSTRAINT IF EXISTS categoria_prenda_nombre_key;
ALTER TABLE IF EXISTS ONLY auth.webauthn_credentials DROP CONSTRAINT IF EXISTS webauthn_credentials_pkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_challenges DROP CONSTRAINT IF EXISTS webauthn_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE IF EXISTS ONLY auth.sso_providers DROP CONSTRAINT IF EXISTS sso_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_pkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY auth.scim_users DROP CONSTRAINT IF EXISTS scim_users_pkey;
ALTER TABLE IF EXISTS ONLY auth.scim_tokens DROP CONSTRAINT IF EXISTS scim_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_entity_id_key;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_client_unique;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_clients DROP CONSTRAINT IF EXISTS oauth_clients_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_client_states DROP CONSTRAINT IF EXISTS oauth_client_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_id_key;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_code_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_codes DROP CONSTRAINT IF EXISTS mfa_recovery_codes_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_code_sets DROP CONSTRAINT IF EXISTS mfa_recovery_code_sets_user_id_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_code_sets DROP CONSTRAINT IF EXISTS mfa_recovery_code_sets_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_recovery_code_sets DROP CONSTRAINT IF EXISTS mfa_recovery_code_sets_mfa_factor_id_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_last_challenged_at_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE IF EXISTS ONLY auth.instances DROP CONSTRAINT IF EXISTS instances_pkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_provider_id_provider_unique;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_pkey;
ALTER TABLE IF EXISTS ONLY auth.flow_state DROP CONSTRAINT IF EXISTS flow_state_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_identifier_key;
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS public.usuario ALTER COLUMN id_usu DROP DEFAULT;
ALTER TABLE IF EXISTS public.trabajo_historial ALTER COLUMN id_historial DROP DEFAULT;
ALTER TABLE IF EXISTS public.trabajo ALTER COLUMN id_trabajo DROP DEFAULT;
ALTER TABLE IF EXISTS public.servicio ALTER COLUMN id_servicio DROP DEFAULT;
ALTER TABLE IF EXISTS public.pedido ALTER COLUMN id_pedido DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_servicio ALTER COLUMN id_detalle DROP DEFAULT;
ALTER TABLE IF EXISTS public.detalle_pedido ALTER COLUMN id_detalle DROP DEFAULT;
ALTER TABLE IF EXISTS public.cliente ALTER COLUMN id_cli DROP DEFAULT;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS storage.vector_indexes;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.objects;
DROP TABLE IF EXISTS storage.migrations;
DROP TABLE IF EXISTS storage.lifecycle_abandoned_artifacts;
DROP TABLE IF EXISTS storage.buckets_vectors;
DROP TABLE IF EXISTS storage.buckets_analytics;
DROP TABLE IF EXISTS storage.buckets;
DROP TABLE IF EXISTS storage.bucket_lifecycle_states;
DROP TABLE IF EXISTS realtime.subscription;
DROP TABLE IF EXISTS realtime.schema_migrations;
DROP TABLE IF EXISTS realtime.messages;
DROP SEQUENCE IF EXISTS public.usuario_id_usu_seq;
DROP TABLE IF EXISTS public.usuario;
DROP SEQUENCE IF EXISTS public.trabajo_id_trabajo_seq;
DROP SEQUENCE IF EXISTS public.trabajo_historial_id_historial_seq;
DROP TABLE IF EXISTS public.trabajo_historial;
DROP TABLE IF EXISTS public.trabajo;
DROP SEQUENCE IF EXISTS public.servicio_id_servicio_seq;
DROP TABLE IF EXISTS public.servicio;
DROP TABLE IF EXISTS public.reporte_semanal;
DROP TABLE IF EXISTS public.precio_prenda;
DROP SEQUENCE IF EXISTS public.pedido_id_pedido_seq;
DROP TABLE IF EXISTS public.pedido;
DROP SEQUENCE IF EXISTS public.detalle_servicio_id_detalle_seq;
DROP TABLE IF EXISTS public.detalle_servicio;
DROP SEQUENCE IF EXISTS public.detalle_pedido_id_detalle_seq;
DROP TABLE IF EXISTS public.detalle_pedido;
DROP SEQUENCE IF EXISTS public.cliente_id_cli_seq;
DROP TABLE IF EXISTS public.cliente;
DROP TABLE IF EXISTS public.categoria_prenda;
DROP TABLE IF EXISTS auth.webauthn_credentials;
DROP TABLE IF EXISTS auth.webauthn_challenges;
DROP TABLE IF EXISTS auth.users;
DROP TABLE IF EXISTS auth.sso_providers;
DROP TABLE IF EXISTS auth.sso_domains;
DROP TABLE IF EXISTS auth.sessions;
DROP TABLE IF EXISTS auth.scim_users;
DROP TABLE IF EXISTS auth.scim_tokens;
DROP TABLE IF EXISTS auth.schema_migrations;
DROP TABLE IF EXISTS auth.saml_relay_states;
DROP TABLE IF EXISTS auth.saml_providers;
DROP SEQUENCE IF EXISTS auth.refresh_tokens_id_seq;
DROP TABLE IF EXISTS auth.refresh_tokens;
DROP TABLE IF EXISTS auth.one_time_tokens;
DROP TABLE IF EXISTS auth.oauth_consents;
DROP TABLE IF EXISTS auth.oauth_clients;
DROP TABLE IF EXISTS auth.oauth_client_states;
DROP TABLE IF EXISTS auth.oauth_authorizations;
DROP TABLE IF EXISTS auth.mfa_recovery_codes;
DROP TABLE IF EXISTS auth.mfa_recovery_code_sets;
DROP TABLE IF EXISTS auth.mfa_factors;
DROP TABLE IF EXISTS auth.mfa_challenges;
DROP TABLE IF EXISTS auth.mfa_amr_claims;
DROP TABLE IF EXISTS auth.instances;
DROP TABLE IF EXISTS auth.identities;
DROP TABLE IF EXISTS auth.flow_state;
DROP TABLE IF EXISTS auth.custom_oauth_providers;
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP FUNCTION IF EXISTS storage.wake_lifecycle_state();
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text, noncurrent_versions text, delete_markers text, start_after_archived_at timestamp with time zone, start_after_version text, start_after_is_continuation boolean);
DROP FUNCTION IF EXISTS storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text, delete_markers text, p_start_after_version text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text, noncurrent_versions text, delete_markers text);
DROP FUNCTION IF EXISTS storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean);
DROP FUNCTION IF EXISTS storage.protect_delete();
DROP FUNCTION IF EXISTS storage.protect_bucket_control_columns();
DROP FUNCTION IF EXISTS storage.protect_active_lifecycle_states();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text, noncurrent_versions text, delete_markers text, next_token_archived_at timestamp with time zone, next_token_version text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text, raw_prefix_param text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket(noncurrent_versions text, delete_markers text);
DROP FUNCTION IF EXISTS storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_versioning_status_transition();
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.enforce_bucket_lifecycle_service_role();
DROP FUNCTION IF EXISTS storage.delete_lifecycle_objects(object_ids uuid[]);
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS storage.allow_only_operation(expected_operation text);
DROP FUNCTION IF EXISTS storage.allow_any_operation(expected_operations text[]);
DROP FUNCTION IF EXISTS realtime.wal2json_escape_identifier(name text);
DROP FUNCTION IF EXISTS realtime.topic();
DROP FUNCTION IF EXISTS realtime.to_regrole(role_name text);
DROP FUNCTION IF EXISTS realtime.subscription_check_filters();
DROP FUNCTION IF EXISTS realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]);
DROP FUNCTION IF EXISTS realtime.send_binary(payload bytea, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.quote_wal2json(entity regclass);
DROP FUNCTION IF EXISTS realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.filters_hash(filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION IF EXISTS realtime."cast"(val text, type_ regtype);
DROP FUNCTION IF EXISTS realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION IF EXISTS realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION IF EXISTS realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]);
DROP FUNCTION IF EXISTS realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION IF EXISTS public.vincular_usuario_actual();
DROP FUNCTION IF EXISTS public.usuario_existe(p_correo text);
DROP FUNCTION IF EXISTS public.usuario_estado_login(p_correo text);
DROP FUNCTION IF EXISTS public.usuario_actual_id();
DROP FUNCTION IF EXISTS public.rls_auto_enable();
DROP FUNCTION IF EXISTS public.metricas_semanales(p_desde timestamp with time zone, p_hasta timestamp with time zone);
DROP FUNCTION IF EXISTS public.establecer_password_inicial(p_correo text, p_password text);
DROP FUNCTION IF EXISTS public.es_admin();
DROP FUNCTION IF EXISTS public.correos_jefa_taller();
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
DROP FUNCTION IF EXISTS graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb);
DROP FUNCTION IF EXISTS extensions.set_graphql_placeholder();
DROP FUNCTION IF EXISTS extensions.pgrst_drop_watch();
DROP FUNCTION IF EXISTS extensions.pgrst_ddl_watch();
DROP FUNCTION IF EXISTS extensions.grant_pg_net_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_graphql_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_cron_access();
DROP FUNCTION IF EXISTS auth.uid();
DROP FUNCTION IF EXISTS auth.role();
DROP FUNCTION IF EXISTS auth.jwt();
DROP FUNCTION IF EXISTS auth.email();
DROP TYPE IF EXISTS storage.buckettype;
DROP TYPE IF EXISTS realtime.wal_rls;
DROP TYPE IF EXISTS realtime.wal_column;
DROP TYPE IF EXISTS realtime.user_defined_filter;
DROP TYPE IF EXISTS realtime.equality_op;
DROP TYPE IF EXISTS realtime.action;
DROP TYPE IF EXISTS auth.one_time_token_type;
DROP TYPE IF EXISTS auth.oauth_response_type;
DROP TYPE IF EXISTS auth.oauth_registration_type;
DROP TYPE IF EXISTS auth.oauth_client_type;
DROP TYPE IF EXISTS auth.oauth_authorization_status;
DROP TYPE IF EXISTS auth.factor_type;
DROP TYPE IF EXISTS auth.factor_status;
DROP TYPE IF EXISTS auth.code_challenge_method;
DROP TYPE IF EXISTS auth.aal_level;
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS supabase_vault;
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS pg_stat_statements;
DROP SCHEMA IF EXISTS vault;
DROP SCHEMA IF EXISTS storage;
DROP SCHEMA IF EXISTS realtime;
DROP SCHEMA IF EXISTS pgbouncer;
DROP EXTENSION IF EXISTS pg_net;
DROP SCHEMA IF EXISTS graphql_public;
DROP SCHEMA IF EXISTS graphql;
DROP SCHEMA IF EXISTS extensions;
DROP EXTENSION IF EXISTS pg_cron;
DROP SCHEMA IF EXISTS auth;
--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA public;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone',
    'recovery_code'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
    revoke trigger on cron.job_run_details from postgres;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
begin
    if not exists (
        select 1
        from pg_catalog.pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
            set search_path to ''
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: -
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: correos_jefa_taller(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.correos_jefa_taller() RETURNS SETOF text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select u.correo
  from public.usuario as u
  where u.rol_usu = 'Jefa de taller'
    and u.correo is not null
$$;


--
-- Name: es_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.es_admin() RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select exists (
    select 1 from usuario
    where auth_user_id = auth.uid() and rol_usu = 'admin'
  )
$$;


--
-- Name: establecer_password_inicial(text, text); Type: FUNCTION; Schema: public; Owner: -
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


--
-- Name: metricas_semanales(timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.metricas_semanales(p_desde timestamp with time zone, p_hasta timestamp with time zone) RETURNS jsonb
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  with
  ped as (
    select * from pedido where created_at >= p_desde and created_at < p_hasta
  ),
  det as (
    select d.* from detalle_pedido d join ped p on p.id_pedido = d.id_pedido
  ),
  serv as (
    select * from servicio where created_at >= p_desde and created_at < p_hasta
  ),
  dserv as (
    select d.* from detalle_servicio d join serv s on s.id_servicio = d.id_servicio
  ),
  trab_term as (
    select * from trabajo where fecha_termino >= p_desde and fecha_termino < p_hasta
  )
  select jsonb_build_object(
    'pedidos', jsonb_build_object(
      'creados',           (select count(*) from ped),
      'prendas_encargadas',(select coalesce(sum(cant_prendas), 0) from det),
      'monto_estimado',    (select coalesce(sum(coalesce(precio, 0) * coalesce(cant_prendas, 0)), 0) from det),
      'abonos_recibidos',  (select coalesce(sum(abono), 0) from ped),
      'top_prendas', (
        select coalesce(jsonb_agg(t order by t.cantidad desc), '[]'::jsonb)
        from (
          select tipo_prenda, sum(cant_prendas) as cantidad
          from det group by tipo_prenda order by 2 desc limit 5
        ) t
      )
    ),
    'servicios', jsonb_build_object(
      'creados',        (select count(*) from serv),
      'monto_estimado', (select coalesce(sum(precio), 0) from dserv),
      'abonos_recibidos',(select coalesce(sum(abono), 0) from serv),
      'top_servicios', (
        select coalesce(jsonb_agg(t order by t.cantidad desc), '[]'::jsonb)
        from (
          select tipo_servicio, count(*) as cantidad
          from dserv group by tipo_servicio order by 2 desc limit 5
        ) t
      )
    ),
    'clientes', jsonb_build_object(
      'con_pedidos', (select count(distinct id_cli) from ped),
      'recurrentes', (
        select count(distinct p.id_cli) from ped p
        where exists (
          select 1 from pedido x where x.id_cli = p.id_cli and x.created_at < p_desde
        )
      )
    ),
    'produccion', jsonb_build_object(
      'trabajos_terminados', (
        select coalesce(jsonb_object_agg(tipo_trabajo, n), '{}'::jsonb)
        from (select tipo_trabajo, count(*) as n from trab_term group by tipo_trabajo) t
      ),
      'horas_promedio_por_trabajo', (
        select coalesce(jsonb_object_agg(tipo_trabajo, horas), '{}'::jsonb)
        from (
          select tipo_trabajo,
                 round(avg(extract(epoch from (fecha_termino - fecha_asignacion)) / 3600)::numeric, 1) as horas
          from trab_term
          where fecha_asignacion is not null
          group by tipo_trabajo
        ) t
      ),
      'cambios_de_estado', (
        select count(*) from trabajo_historial
        where fecha_cambio >= p_desde and fecha_cambio < p_hasta
      ),
      'por_trabajadora', (
        select coalesce(jsonb_agg(t order by t.terminados desc), '[]'::jsonb)
        from (
          select u.nom_usuario as nombre,
                 u.rol_usu as rol,
                 count(*) filter (where tr.fecha_termino >= p_desde and tr.fecha_termino < p_hasta) as terminados,
                 count(*) filter (where tr.estado <> 'terminado') as pendientes_actuales
          from trabajo tr
          join usuario u on u.id_usu = tr.id_usu
          group by u.id_usu, u.nom_usuario, u.rol_usu
        ) t
      )
    ),
    -- Foto del estado actual del taller (no depende del período)
    'estado_actual', jsonb_build_object(
      'pedidos_por_estado', (
        select coalesce(jsonb_object_agg(estado_pedido, n), '{}'::jsonb)
        from (select estado_pedido, count(*) as n from pedido group by estado_pedido) t
      ),
      'pedidos_atrasados', (
        select count(*) from pedido
        where estado_pedido <> 'listo' and fec_ter is not null and fec_ter < current_date
      ),
      'trabajos_por_estado', (
        select coalesce(jsonb_object_agg(estado, n), '{}'::jsonb)
        from (select estado, count(*) as n from trabajo group by estado) t
      )
    )
  );
$$;


--
-- Name: rls_auto_enable(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- Name: usuario_actual_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.usuario_actual_id() RETURNS integer
    LANGUAGE sql STABLE
    AS $$
  select id_usu from usuario where auth_user_id = auth.uid()
$$;


--
-- Name: usuario_estado_login(text); Type: FUNCTION; Schema: public; Owner: -
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


--
-- Name: usuario_existe(text); Type: FUNCTION; Schema: public; Owner: -
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


--
-- Name: vincular_usuario_actual(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    -- the same values as wal2json sent them, which is what filters compare against
    raw_columns realtime.wal_column[] =
        array_agg((x->>'name', x->>'type', x->>'typeoid', x->'value', null, null)::realtime.wal_column)
        from jsonb_array_elements(wal -> 'columns') x;
    raw_old_columns realtime.wal_column[] =
        array_agg((x->>'name', x->>'type', x->>'typeoid', x->'value', null, null)::realtime.wal_column)
        from jsonb_array_elements(wal -> 'identity') x;

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(raw_columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(raw_old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


--
-- Name: authorize(text, text, text, text, text, text[], text[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
  probe_ids uuid[];
  probe_inserted_at timestamp := now() at time zone 'utc';
  visible_ids uuid[];
  ext text;
  allowed boolean;
begin
  -- The probe inserts are rolled back, but they still give the transaction an xid, so it ends
  -- in a commit. Nothing durable was written, so skip waiting on the WAL flush and sync standbys.
  -- Set outside the block below, whose rollback would undo it.
  perform set_config('synchronous_commit', 'off', true);

  -- The RAISE at the end of this block rolls back everything in it.
  begin
    probe_ids := array(select gen_random_uuid() from unnest(read_extensions));

    insert into realtime.messages (id, topic, extension, inserted_at, updated_at)
    select p.id, topic_name, p.extension, probe_inserted_at, probe_inserted_at
    from unnest(probe_ids, read_extensions) as p(id, extension);

    perform set_config('role', role_name, true),
            set_config('realtime.topic', topic_name, true),
            set_config('request.jwt.claims', claims, true),
            set_config('request.jwt.claim.sub', sub, true),
            set_config('request.jwt.claim.role', role_name, true),
            set_config('request.headers', headers, true);

    -- One lookup for every probe, by the full primary key. Skipped without probes, so the
    -- SELECT policies are not planned for a write.
    if cardinality(probe_ids) > 0 then
      visible_ids := array(
        select m.id
        from realtime.messages m
        where m.inserted_at = probe_inserted_at
          and m.id = any(probe_ids));
    end if;

    read_allowed := array(
      select p.id = any(visible_ids)
      from unnest(probe_ids) with ordinality as p(id, n)
      order by p.n);

    write_allowed := '{}';

    foreach ext in array write_extensions loop
      begin
        insert into realtime.messages (topic, extension, inserted_at, updated_at)
        values (topic_name, ext, now() at time zone 'utc', now() at time zone 'utc');

        allowed := true;
      exception when insufficient_privilege then
        allowed := false;
      end;

      write_allowed := write_allowed || allowed;
    end loop;

    raise sqlstate 'RTA01';
  exception when sqlstate 'RTA01' then
    null;
  end;
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
/*
Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
*/
declare
    op_symbol text = (
        case
            when op = 'eq' then '='
            when op = 'neq' then '!='
            when op = 'lt' then '<'
            when op = 'lte' then '<='
            when op = 'gt' then '>'
            when op = 'gte' then '>='
            when op = 'in' then '= any'
            else 'UNKNOWN OP'
        end
    );
    res boolean;
begin
    execute format(
        'select %L::'|| type_::text || ' ' || op_symbol
        || ' ( %L::'
        || (
            case
                when op = 'in' then type_::text || '[]'
                else type_::text end
        )
        || ')', val_1, val_2) into res;
    return res;
end;
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


--
-- Name: filters_hash(realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.filters_hash(filters realtime.user_defined_filter[]) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $$
  select pg_catalog.int8send(pg_catalog.hash_array_extended(filters, 0))
      || pg_catalog.int8send(pg_catalog.hash_array_extended(filters, 1))
$$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- Name: list_changes_sync(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures the slot is read exactly once.
  consumed AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         realtime.settled_changes(
           slot_name, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM consumed
    WHERE consumed.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM consumed,
         realtime.apply_rls(
           wal := consumed.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE consumed.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: settled_changes(name, integer, text[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]) RETURNS TABLE(lsn pg_lsn, xid xid, data text)
    LANGUAGE plpgsql
    AS $$
declare
  upto pg_lsn;
  total bigint;
  xids xid[];
  starts bigint[];
  snapshot pg_snapshot;
  running_xids xid[];
  xmax_age int;
  cut bigint;
begin
  -- Each statement in a volatile function takes its own snapshot, which is what lets the
  -- check below see a writer that was still in flight when the peek ran. Under REPEATABLE
  -- READ the snapshot never advances, so a deferred change would never be released.
  if current_setting('transaction_isolation') <> 'read committed' then
    raise exception 'realtime.settled_changes requires READ COMMITTED';
  end if;

  -- The peek and the read below cover the same WAL, so the read cannot reach a commit the
  -- check never saw.
  upto := pg_current_wal_flush_lsn();

  -- One entry per transaction, in commit order: its xid and the position of its first
  -- change. The peek uses the caller's own options, so max_changes counts exactly what the
  -- read counts. A non-transactional logical message is emitted as soon as it is decoded,
  -- tagged with the xid of whatever transaction wrote it, so it does not mark where that
  -- transaction starts.
  select coalesce(sum(g.n), 0),
         array_agg(g.x order by g.first) filter (where g.first is not null),
         array_agg(g.first order by g.first) filter (where g.first is not null)
    into total, xids, starts
    from (
      select p.xid as x, count(*) as n,
             min(p.ord) filter (where not case
               when starts_with(p.data, '{"action":"M"') then (p.data::jsonb->>'transactional')::boolean is false
               else false
             end) as first
      from pg_logical_slot_peek_changes(slot_name, upto, max_changes, variadic opts)
           with ordinality as p(lsn, xid, data, ord)
      group by p.xid
    ) g;

  -- Nothing for the caller, but the slot still has to move past what the peek covered.
  if total = 0 then
    perform pg_replication_slot_advance(slot_name, upto);
    return;
  end if;

  if xids is not null then
    -- Taken after the peek is materialized, so a writer that was still in flight during
    -- decoding is guaranteed to show up here.
    snapshot := pg_current_snapshot();

    -- A commit record reaches the WAL before the writer leaves the proc array, so a change
    -- can be decoded while its row is invisible. apply_rls would resolve a policy against a
    -- row it cannot see and authorize it for nobody, while the read consumed it regardless.
    --
    -- xip lists transactions running when the snapshot was taken. It does not cover a writer
    -- whose xid sits at or beyond xmax, which never appears there, so the horizon is checked
    -- too. age() counts backwards from the current xid and so compares correctly across
    -- wraparound.
    select coalesce(array_agg(running.x::xid), array[]::xid[])
      into running_xids
      from pg_snapshot_xip(snapshot) running(x);
    xmax_age := age(pg_snapshot_xmax(snapshot)::xid);

    select min(u.s) into cut
      from unnest(xids, starts) as u(x, s)
      where u.x = any(running_xids) or age(u.x) <= xmax_age;
  end if;

  -- The read stops right after the commit that brings its count to upto_nchanges, so the
  -- count of changes in front of the first unsettled transaction stops it just before that
  -- transaction.
  if cut is null then
    return query
      select p.* from pg_logical_slot_get_changes(slot_name, upto, max_changes, variadic opts) p;
  elsif cut > 1 then
    return query
      select p.* from pg_logical_slot_get_changes(slot_name, upto, (cut - 1)::int, variadic opts) p;
  end if;
end;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    -- Normalize selected_columns order so ARRAY['a','b'] and ARRAY['b','a'] are treated
    -- as the same subscription group in apply_rls. Preserve an empty array as '{}'
    -- ("primary keys only") so it stays distinct from NULL ("all columns"); array_agg
    -- over an empty set would otherwise collapse '{}' back to NULL.
    if new.selected_columns is not null then
        new.selected_columns = coalesce(
            (
                select array_agg(c order by c)
                from unnest(new.selected_columns) c
            ),
            '{}'::text[]
        );
    end if;

    return new;
end;
$$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: delete_lifecycle_objects(uuid[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_lifecycle_objects(object_ids uuid[]) RETURNS TABLE(id uuid, is_delete_marker boolean, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    object_id uuid;
    deleted_row storage.objects%ROWTYPE;
    deleted_ids uuid[];
    deleted_markers boolean[];
    deleted_metadata jsonb[];
    bulk_deleted boolean := false;
BEGIN
    -- Surface pre-existing deferred violations instead of treating them as blocked rows.
    SET CONSTRAINTS ALL IMMEDIATE;
    PERFORM set_config('storage.allow_delete_query', 'true', true);

    -- One subxact keeps the subxid cache from overflowing; rows return only once it commits.
    BEGIN
        WITH deleted AS (
            DELETE FROM storage.objects AS object_row
              WHERE object_row.id = ANY(object_ids) AND object_row.archived_at IS NOT NULL
              RETURNING object_row.id, object_row.is_delete_marker, object_row.metadata
        )
        SELECT array_agg(deleted.id), array_agg(deleted.is_delete_marker), array_agg(deleted.metadata)
          INTO deleted_ids, deleted_markers, deleted_metadata
          FROM deleted;
        bulk_deleted := true;
    EXCEPTION
        WHEN OTHERS THEN
            -- User triggers may use insufficient_privilege to block a row.
            IF SQLSTATE <> '42501' AND left(SQLSTATE, 2) IN ('08', '40', '42', '53', '55', '57', '58', 'XX') THEN
                RAISE;
            END IF;
    END;
    IF bulk_deleted THEN
        RETURN QUERY SELECT * FROM unnest(deleted_ids, deleted_markers, deleted_metadata);
        RETURN;
    END IF;

    FOREACH object_id IN ARRAY object_ids LOOP
        BEGIN
            DELETE FROM storage.objects AS object_row
              WHERE object_row.id = object_id AND object_row.archived_at IS NOT NULL
              RETURNING object_row.* INTO deleted_row;
            IF FOUND THEN
                id := deleted_row.id;
                is_delete_marker := deleted_row.is_delete_marker;
                metadata := deleted_row.metadata;
                RETURN NEXT;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLSTATE <> '42501' AND left(SQLSTATE, 2) IN ('08', '40', '42', '53', '55', '57', '58', 'XX') THEN
                    RAISE;
                END IF;
        END;
    END LOOP;
END;
$$;


--
-- Name: enforce_bucket_lifecycle_service_role(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_lifecycle_service_role() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
  IF current_user::text IS DISTINCT FROM TG_ARGV[0] THEN
    -- Keep this check AFTER caller RLS accepts the proposed row. The API
    -- recognizes this exact signal after rolling back its permission probe.
    RAISE EXCEPTION 'bucket control columns may only be changed by the configured storage service role'
      USING ERRCODE = 'PST01',
            SCHEMA = TG_TABLE_SCHEMA,
            TABLE = TG_TABLE_NAME,
            CONSTRAINT = TG_NAME;
  END IF;

  RETURN NULL;
END;
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: enforce_versioning_status_transition(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_versioning_status_transition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.versioning_status = OLD.versioning_status THEN
        RETURN NEW;
    END IF;

    IF NEW.versioning_status = 'DISABLED' OR
       (OLD.versioning_status = 'DISABLED' AND NEW.versioning_status = 'SUSPENDED') THEN
        RAISE EXCEPTION 'Cannot transition bucket versioning status from % to %',
            OLD.versioning_status, NEW.versioning_status;
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    RETURN _parts[array_length(_parts, 1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN p_delimiter <> ''
         AND position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(
        p_key,
        length(p_prefix)
            + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1))
            + length(p_delimiter) - 1
    )
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket(noncurrent_versions text DEFAULT 'include'::text, delete_markers text DEFAULT 'include'::text) RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'include');
    delete_markers := COALESCE(delete_markers, 'include');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'include';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'include';
    END IF;

    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        where (noncurrent_versions != 'exclude' OR obj.archived_at IS NULL)
          and (noncurrent_versions != 'only' OR obj.archived_at IS NOT NULL)
          and (delete_markers != 'exclude' OR NOT obj.is_delete_marker)
          and (delete_markers != 'only' OR obj.is_delete_marker)
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text, raw_prefix_param text DEFAULT NULL::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE sql STABLE
    AS $_$
WITH candidates AS (
    SELECT
        upload.key AS object_key,
        CASE
            WHEN position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0
            THEN left(
                upload.key,
                length(coalesce($7, $2))
                    + position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1))
                    + length($3) - 1
            )
            ELSE upload.key
        END AS result_key,
        upload.id,
        upload.created_at,
        position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0 AS is_common_prefix
    FROM storage.s3_multipart_uploads AS upload
    WHERE upload.bucket_id = $1
      AND upload.key COLLATE "C" LIKE $2 || '%'
), filtered AS (
    SELECT candidate.*
    FROM candidates AS candidate
    WHERE $5 = ''
       OR candidate.result_key COLLATE "C" > $5
       OR (
           candidate.result_key COLLATE "C" = $5
           AND NOT candidate.is_common_prefix
           AND $6 <> ''
           -- A completed or aborted marker repeats the remaining same-key uploads.
           AND COALESCE(
               (candidate.created_at, candidate.id COLLATE "C") > (
                   SELECT marker.created_at, marker.id COLLATE "C"
                   FROM storage.s3_multipart_uploads AS marker
                   WHERE marker.bucket_id = $1
                     AND marker.key COLLATE "C" = $5
                     AND marker.id = $6
               ),
               TRUE
           )
       )
), ranked AS (
    SELECT
        filtered.*,
        row_number() OVER (
            PARTITION BY filtered.result_key COLLATE "C"
            ORDER BY filtered.created_at, filtered.id COLLATE "C"
        ) AS prefix_rank
    FROM filtered
)
SELECT ranked.result_key, ranked.id, ranked.created_at
FROM ranked
WHERE NOT ranked.is_common_prefix OR ranked.prefix_rank = 1
ORDER BY ranked.result_key COLLATE "C", ranked.created_at, ranked.id COLLATE "C"
LIMIT $4;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text, text, text, timestamp with time zone, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, next_token_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, next_token_version text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_start_relative TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;

    -- true when noncurrent_versions can return >1 row per name; keeps them
    -- ordered most-recent-first and lets pagination resume mid-key
    v_multi_row BOOLEAN;
    v_name_order TEXT;
    v_exact_range_predicate TEXT;
    v_strict_range_predicate TEXT;
    v_inclusive_range_predicate TEXT;

    -- Seek state for the current name. archived_at is normalized to JavaScript's
    -- millisecond precision and version breaks ties within the same millisecond.
    -- Current rows use 'infinity'; NULL means no tiebreak has been established.
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_cursor_is_folder BOOLEAN;
    v_count INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_batch_query_strict TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');
    v_name_order := CASE WHEN v_is_asc THEN 'ASC' ELSE 'DESC' END;

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Keep caller-provided cursors inside the requested prefix range.
    IF v_start <> '' AND v_upper_bound IS NOT NULL THEN
        IF v_is_asc THEN
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                v_start := '';
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                RETURN;
            END IF;
        ELSE
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                RETURN;
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                v_start := '';
            END IF;
        END IF;
    END IF;

    v_start_relative := substring(v_start FROM length(v_prefix) + 1);

    -- Direction affects only the indexed name range and its ordering. Cursor
    -- state transitions and within-key version ordering stay shared.
    IF v_is_asc THEN
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" > $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" >= $2';
        IF v_upper_bound IS NOT NULL THEN
            v_exact_range_predicate := 'o.name COLLATE "C" < $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" < $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" < $3';
        END IF;
    ELSE
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" < $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" < $2';
        IF v_prefix <> '' THEN
            v_exact_range_predicate := 'o.name COLLATE "C" >= $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" >= $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" >= $3';
        END IF;
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    -- The multi-row order matches the externally serialized cursor exactly:
    -- archived_at at millisecond precision, then version as the final tiebreak.
    --
    -- When v_multi_row, the seek is a keyset tuple comparison ("name > $2 OR
    -- (name = $2 AND tiebreak)") - Postgres won't split that OR into indexable
    -- form (confirmed even with fully literal values), so as one WHERE clause
    -- it forces a full bucket scan filtered row-by-row. Splitting it into two
    -- independently-indexable branches (exact name match with the tiebreak
    -- filter, vs. strictly-past names) combined with UNION ALL lets each
    -- branch keep name as a real index condition; the outer ORDER BY/LIMIT
    -- re-merges them into the same page the single query used to produce.
    IF v_multi_row THEN
        v_batch_query := format(
            $sql$
            SELECT *
            FROM (
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND o.name COLLATE "C" = $2
                      AND %s
                      AND NOT $7::boolean
                      AND (
                          $5::timestamptz IS NULL
                          OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < $5
                          OR (
                              COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = $5
                              AND COALESCE(o.version, '') > $6
                          )
                      )
                      %s
                    ORDER BY
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
                UNION ALL
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND %s
                      %s
                    ORDER BY
                        o.name COLLATE "C" %s,
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
            ) sub
            ORDER BY
                sub.name COLLATE "C" %s,
                COALESCE(date_trunc('milliseconds', sub.archived_at), 'infinity'::timestamptz) DESC,
                COALESCE(sub.version, '') ASC
            LIMIT $4
            $sql$,
            v_exact_range_predicate,
            v_version_filter,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order,
            v_name_order
        );
    ELSE
        v_batch_query := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_inclusive_range_predicate,
            v_version_filter,
            v_name_order
        );

        -- Strict counterpart of the query above: used once the single-row
        -- ASC batch advance (below) has left v_next_seek pointing at the
        -- last row already emitted, so an inclusive predicate would
        -- re-match it forever. Only single-row mode ever sets strict mode,
        -- so this variant is never needed when v_multi_row.
        v_batch_query_strict := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order
        );
    END IF;

    -- The static peek predicates cannot use the partial delete-marker index
    -- once PL/pgSQL switches to a generic plan because whether
    -- is_delete_marker is required remains parameter-dependent. Reuse the
    -- already-specialized batch query with a one-row limit for this sparse
    -- filter so the plan sees a literal `o.is_delete_marker` predicate.
    IF delete_markers = 'only' THEN
        v_delete_marker_peek_query :=
            'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        IF NOT v_multi_row THEN
            v_delete_marker_peek_query_strict :=
                'SELECT marker_page.name FROM (' || v_batch_query_strict || ') marker_page LIMIT 1';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor performs one specialized initial seek so
            -- partial current-version and delete-marker indexes remain available.
            EXECUTE format(
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY o.name COLLATE "C" DESC LIMIT 1',
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND o.name COLLATE "C" >= $2 AND o.name COLLATE "C" < $3'
                    ELSE ''
                END,
                v_version_filter
            )
            INTO v_next_seek
            USING _bucket_id, v_prefix, v_upper_bound;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Folder continuation tokens retain their trailing delimiter. A
        -- delimiter-less startAfter is always a literal key boundary.
        v_cursor_is_folder := delimiter_param <> ''
            AND v_start_relative <> ''
            AND right(v_start_relative, length(delimiter_param)) = delimiter_param;

        IF v_cursor_is_folder THEN
            v_next_seek := CASE
                WHEN right(v_start, length(delimiter_param)) = delimiter_param
                    THEN v_start
                ELSE v_start || delimiter_param
            END;
            IF v_is_asc THEN
                v_next_seek := left(v_next_seek, -1)
                    || chr(ascii(right(v_next_seek, 1)) + 1);
            END IF;
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- leaf object: when v_multi_row, stay on v_start with the
            -- caller-supplied tiebreak so a page boundary mid-key resumes
            -- that key's remaining rows instead of skipping them. Truncate
            -- to milliseconds like every other v_next_seek_at assignment -
            -- harmless today since object.ts's cursor always round-trips
            -- through JS Date first, but this shouldn't rely on that.
            IF v_multi_row THEN
                v_next_seek := v_start;
                v_next_seek_at := date_trunc('milliseconds', next_token_archived_at);
                v_next_seek_version := coalesce(next_token_version, '');
                v_next_seek_strict := coalesce(next_token, '') = '';
            ELSIF v_is_asc THEN
                v_next_seek := v_start;
                v_next_seek_strict := true;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        -- v_multi_row is branched here (rather than folded into the WHERE
        -- clause as a bound parameter) so each concrete query keeps an
        -- unconditional seek predicate - once PL/pgSQL switches to its
        -- cached generic plan (after 5 calls), a parameter-gated
        -- "(NOT v_multi_row AND name >= $x) OR (v_multi_row AND ...)"
        -- predicate stops the planner from using name as an index
        -- condition at all, degrading every subsequent peek to a full
        -- index scan filtered row-by-row instead of a bounded range scan.
        -- v_multi_row's seek predicate is a keyset tuple comparison
        -- ("name > x OR (name = x AND tiebreak)") - Postgres does not
        -- split this OR into indexable form even with fully literal
        -- values, so it falls back to a full scan filtered row-by-row.
        -- Splitting it into two independently-indexable branches (exact
        -- name match with the tiebreak filter, vs. strictly-past name)
        -- combined with UNION ALL lets each branch keep name as a real
        -- index condition; the outer ORDER BY/LIMIT picks whichever of
        -- the (at most 2) rows sorts first.
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING _bucket_id, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END,
                    1, v_next_seek_at, v_next_seek_version, v_next_seek_strict;
        ELSIF v_multi_row THEN
            IF v_is_asc THEN
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" < v_upper_bound
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek AND o.name COLLATE "C" < v_upper_bound
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" >= v_prefix
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        ELSE
            -- Single-row mode is always noncurrent_versions='exclude'. Keep
            -- this predicate literal so generic plans use the current index.
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.name COLLATE "C" >= v_prefix
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := v_common_prefix;
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            version := NULL;
            archived_at := NULL;
            is_delete_marker := NULL;
            is_versioned := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1)
                    || chr(ascii(right(v_common_prefix, 1)) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row THEN v_batch_query_strict ELSE v_batch_query END
                USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size, v_next_seek_at, v_next_seek_version,
                v_next_seek_strict
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN v_current.name
                        ELSE v_current.name || delimiter_param
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                version := v_current.version;
                archived_at := v_current.archived_at;
                is_delete_marker := v_current.is_delete_marker;
                is_versioned := v_current.is_versioned;
                RETURN NEXT;
                v_count := v_count + 1;

                -- when v_multi_row, stay on this name and record its
                -- archived_at as the new tiebreak so remaining rows for the
                -- same key are picked up before moving to the next name
                IF v_multi_row THEN
                    v_next_seek := v_current.name;
                    v_next_seek_at := COALESCE(date_trunc('milliseconds', v_current.archived_at), 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                    v_next_seek_strict := false;
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor
                    -- would skip a real key like `name || '!'` (or any
                    -- character sorting below the delimiter), which sorts
                    -- between `name` and `name || delimiter`. Track the real
                    -- name and mark the next comparison strict instead.
                    v_next_seek := v_current.name;
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.list_objects_with_delimiter made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_active_lifecycle_states(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_active_lifecycle_states() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM storage.bucket_lifecycle_states
        WHERE bucket_id = OLD.id
          AND NOT (
              continuation IS NULL
              OR (continuation @> '{"continuationVersion": 1}' AND continuation #> '{batch,inFlight}' IS NULL)
          )
    ) THEN
        RAISE EXCEPTION 'update or delete on table "buckets" violates foreign key constraint "bucket_lifecycle_states_bucket_id_fkey" on table "bucket_lifecycle_states"'
            USING ERRCODE = 'foreign_key_violation',
                  DETAIL = format('Key (id)=(%s) is still referenced from table "bucket_lifecycle_states".', OLD.id),
                  SCHEMA = 'storage',
                  TABLE = 'bucket_lifecycle_states',
                  CONSTRAINT = 'bucket_lifecycle_states_bucket_id_fkey';
    END IF;
    RETURN OLD;
END;
$$;


--
-- Name: protect_bucket_control_columns(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_bucket_control_columns() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  configuration_changed boolean;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.lifecycle_configuration IS NOT NULL
       OR NEW.lifecycle_configuration_generation IS NOT NULL THEN
      IF NOT pg_has_role(current_user, TG_ARGV[0], 'MEMBER') THEN
        RAISE EXCEPTION 'only members of the configured storage service role may insert lifecycle policy state'
          USING ERRCODE = '42501',
                HINT = format(
                  'Insert with both lifecycle columns NULL and configure lifecycle through the Storage API afterward, or insert as a member of %I.',
                  TG_ARGV[0]
                );
      END IF;
    END IF;

    RETURN NEW;
  END IF;

  configuration_changed =
    OLD.lifecycle_configuration IS DISTINCT FROM NEW.lifecycle_configuration
    OR OLD.lifecycle_configuration_generation IS DISTINCT FROM NEW.lifecycle_configuration_generation;

  IF NOT configuration_changed THEN
    RETURN NEW;
  END IF;

  IF NEW.type IS DISTINCT FROM 'STANDARD' THEN
    RAISE EXCEPTION 'bucket versioning and lifecycle controls require a Standard bucket'
      USING ERRCODE = '0A000';
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     AND NEW.lifecycle_configuration_generation IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     OR NEW.lifecycle_configuration_generation IS NULL
     OR OLD.lifecycle_configuration IS NOT DISTINCT FROM NEW.lifecycle_configuration
     OR OLD.lifecycle_configuration_generation IS NOT DISTINCT FROM NEW.lifecycle_configuration_generation THEN
    RAISE EXCEPTION 'a changed lifecycle policy requires a new non-null generation'
      USING ERRCODE = '22023';
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: reconcile_lifecycle_state(text, boolean); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
    bucket storage.buckets%ROWTYPE;
    active boolean;
    idle boolean;
    state_generation uuid;
BEGIN
    SELECT * INTO bucket FROM storage.buckets WHERE id = target_bucket_id FOR NO KEY UPDATE;
    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT continuation IS NULL OR (
               continuation @> '{"continuationVersion": 1}'
               AND continuation #> '{batch,inFlight}' IS NULL
           ), generation
    INTO idle, state_generation
    FROM storage.bucket_lifecycle_states
    WHERE bucket_id = target_bucket_id
    FOR UPDATE;

    IF bucket.lifecycle_configuration IS NULL THEN
        DELETE FROM storage.bucket_lifecycle_states
        WHERE bucket_id = target_bucket_id
          AND idle IS TRUE;

        UPDATE storage.bucket_lifecycle_states
        SET next_run_at = clock_timestamp(), updated_at = clock_timestamp()
        WHERE bucket_id = target_bucket_id
          AND idle IS NOT TRUE;
        RETURN;
    END IF;

    active := bucket.versioning_status <> 'DISABLED'
        AND bucket.lifecycle_configuration @> '{"rules":[{"status":"Enabled"}]}'::jsonb;

    -- The state row records the generation it was reconciled with so callers need not detect
    -- policy changes. Rows without a recorded generation keep their work.
    policy_changed := policy_changed OR (
        state_generation IS NOT NULL AND state_generation <> bucket.lifecycle_configuration_generation
    );

    INSERT INTO storage.bucket_lifecycle_states AS state (bucket_id, generation, next_run_at)
    VALUES (bucket.id, bucket.lifecycle_configuration_generation, CASE WHEN active THEN clock_timestamp() END)
    ON CONFLICT (bucket_id) DO UPDATE
    SET next_run_at = CASE
            WHEN policy_changed THEN
                CASE WHEN active OR idle IS NOT TRUE THEN clock_timestamp() END
            ELSE EXCLUDED.next_run_at
        END,
        generation = EXCLUDED.generation,
        claim_id = CASE WHEN policy_changed AND idle IS TRUE
                        THEN NULL ELSE state.claim_id END,
        claim_until = CASE WHEN policy_changed AND idle IS TRUE
                           THEN NULL ELSE state.claim_until END,
        continuation = CASE WHEN policy_changed AND idle IS TRUE
                            THEN NULL ELSE state.continuation END,
        failure_count = CASE WHEN policy_changed AND idle IS TRUE
                             THEN 0 ELSE state.failure_count END,
        last_error = CASE WHEN policy_changed AND idle IS TRUE
                          THEN NULL ELSE state.last_error END,
        updated_at = clock_timestamp()
    WHERE policy_changed OR (state.next_run_at IS NULL AND EXCLUDED.next_run_at IS NOT NULL);
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_prefix_len INT;
    v_prefix_start INT;
    v_combined_levels INT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;
    v_multi_row BOOLEAN;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_count INT := 0;
    v_skipped INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;
    v_previous_skipped INT;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_prefix_len := length(coalesce(prefix, ''));
    v_prefix_start := coalesce(array_length(string_to_array(coalesce(prefix, ''), v_delimiter), 1), 1);
    v_combined_levels := coalesce(array_length(string_to_array(v_prefix, v_delimiter), 1), 1);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT array_to_string(path_tokens[$1:$2], '/') AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $3 || '%%'
                  AND bucket_id = $4
                  AND array_length(objects.path_tokens, 1) <> $2
                  AND ($7 != 'exclude' OR objects.archived_at IS NULL)
                  AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
                  AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
                  AND ($8 != 'only' OR objects.is_delete_marker)
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata,
                   NULL::text AS version,
                   NULL::timestamptz AS archived_at,
                   NULL::boolean AS is_delete_marker,
                   NULL::boolean AS is_versioned FROM folders)
            UNION ALL
            (SELECT array_to_string(path_tokens[$1:$2], '/') AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata,
                   version, archived_at, is_delete_marker, is_versioned
             FROM storage.objects
             WHERE objects.name ILIKE $3 || '%%'
               AND bucket_id = $4
               AND array_length(objects.path_tokens, 1) = $2
               AND ($7 != 'exclude' OR objects.archived_at IS NULL)
               AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
               AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
               AND ($8 != 'only' OR objects.is_delete_marker)
             -- name, then version, as tiebreaks so two versions of the same
             -- key tying on the sort column still sort deterministically
             ORDER BY %I %s, name COLLATE "C" %s, COALESCE(version, '') %s)
            LIMIT $5 OFFSET $6
            $sql$, v_sort_order, v_order_by, v_sort_order, v_sort_order, v_sort_order
        ) USING v_prefix_start, v_combined_levels, v_prefix, bucketname, v_limit, offsets, noncurrent_versions, delete_markers;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build a resume-safe batch query. The exact-name branch returns remaining
    -- versions after the current (archived_at, version) boundary; the strict
    -- name branch returns subsequent keys. UNION ALL keeps both predicates
    -- independently indexable.
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2 AND lower(o.name) COLLATE "C" < $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 AND lower(o.name) COLLATE "C" >= $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    END IF;

    -- Keep the delete-marker predicate literal so the cached generic
    -- plan can use idx_objects_delete_markers during the main-loop peek.
    IF delete_markers = 'only' THEN
        IF v_multi_row THEN
            v_delete_marker_peek_query :=
                'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        ELSIF v_is_asc THEN
            -- Two separate literal query strings, not one gated by a bound
            -- boolean: folding "$n AND op1 OR NOT $n AND op2" into a single
            -- query defeats the generic plan's ability to push either
            -- comparison into the index. Branching in PL/pgSQL control flow
            -- instead keeps each query's index condition intact.
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" >= $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
            -- Strict variant: used once the single-row ASC batch advance
            -- (below) has left v_next_seek pointing at the last row already
            -- emitted, so a plain >= would re-match it forever.
            v_delete_marker_peek_query_strict :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" > $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
        ELSE
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" < $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" >= $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC performs one specialized initial seek so partial current-version
        -- and delete-marker indexes remain available.
        EXECUTE format(
            'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1',
            CASE WHEN v_upper_bound IS NOT NULL
                THEN ' AND lower(o.name) COLLATE "C" >= $2 AND lower(o.name) COLLATE "C" < $3'
                ELSE ''
            END,
            v_version_filter
        )
        INTO v_peek_name
        USING bucketname, v_prefix_lower, v_upper_bound;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch and
    -- the delete-marker-only path
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;
        v_previous_skipped := v_skipped;

        -- STEP 1: PEEK
        v_peek_name := NULL;
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END,
                    1, v_next_seek_at, v_next_seek_version;
        ELSIF v_multi_row AND v_next_seek_at IS NOT NULL THEN
            SELECT o.name INTO v_peek_name
            FROM storage.objects o
            WHERE o.bucket_id = bucketname
              AND lower(o.name) COLLATE "C" = v_next_seek
              AND (COALESCE(o.archived_at, 'infinity'::timestamptz) < v_next_seek_at
                   OR (COALESCE(o.archived_at, 'infinity'::timestamptz) = v_next_seek_at
                       AND COALESCE(o.version, '') > v_next_seek_version))
              AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
              AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
              AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
              AND (delete_markers != 'only' OR o.is_delete_marker)
            ORDER BY COALESCE(o.archived_at, 'infinity'::timestamptz) DESC,
                     COALESCE(o.version, '') ASC
            LIMIT 1;

            -- The current key is exhausted. Clear its version boundary and
            -- make the following ASC name peek strict. Appending '/' is not a
            -- valid lexical successor because keys ending in characters such
            -- as '!' sort between the exhausted name and name || '/'.
            IF v_peek_name IS NULL THEN
                IF v_is_asc THEN
                    v_next_seek_strict := true;
                END IF;
                v_next_seek_at := NULL;
                v_next_seek_version := '';
            END IF;
        END IF;

        -- Single-row mode is always noncurrent_versions='exclude'. Keep the
        -- current-row predicate literal so generic plans use the current index.
        IF delete_markers != 'only' AND v_peek_name IS NULL AND NOT v_multi_row THEN
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL AND v_is_asc THEN
            IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_next_seek_strict THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- If the peek landed on a different key than we were tracking, any
        -- version boundary belongs to the OLD key and must not leak into the
        -- new one - e.g. the deleteMarkers='only' peek doesn't know or care
        -- whether it's continuing the same key or jumping to a new one, so
        -- it never clears these itself.
        IF lower(v_peek_name) IS DISTINCT FROM v_next_seek THEN
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        END IF;

        -- The peek is authoritative for the next key to process. This is
        -- especially important after exhausting a multi-version key: the
        -- version boundary has been cleared, so executing the batch against
        -- a stale v_next_seek would replay every version of that old key.
        v_next_seek := lower(v_peek_name);
        v_next_seek_strict := false;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := substring(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter) from v_prefix_len + 1);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                version := NULL;
                archived_at := NULL;
                is_delete_marker := NULL;
                is_versioned := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size,
                    v_next_seek_at, v_next_seek_version
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too - it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN lower(v_current.name)
                        ELSE lower(v_current.name) || v_delimiter
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := substring(v_current.name from v_prefix_len + 1);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    version := v_current.version;
                    archived_at := v_current.archived_at;
                    is_delete_marker := v_current.is_delete_marker;
                    is_versioned := v_current.is_versioned;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Multi-row mode must remain on this key until all of its
                -- versions have crossed the internal batch boundary.
                IF v_multi_row THEN
                    v_next_seek := lower(v_current.name);
                    v_next_seek_at := COALESCE(v_current.archived_at, 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor would
                    -- skip a real key like `name || '!'` (or any character
                    -- sorting below the delimiter), which sorts between `name`
                    -- and `name || delimiter`. Track the real name and mark the
                    -- next comparison strict instead - same fix as the
                    -- exhausted-key case above.
                    v_next_seek := lower(v_current.name);
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_skipped = v_previous_skipped
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.search made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, p_start_after_version text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
    v_prefix_pattern text;
    v_sort_order text;
    v_sort_column text;
    v_version_tiebreak text;
BEGIN
    v_prefix := coalesce(p_prefix, '');
    -- Keep the raw prefix for common-prefix calculations and escape only LIKE metacharacters.
    v_prefix_pattern := replace(v_prefix, chr(92), chr(92) || chr(92));
    v_prefix_pattern := replace(v_prefix_pattern, '%', chr(92) || '%');
    v_prefix_pattern := replace(v_prefix_pattern, '_', chr(92) || '_');

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    -- $9 is only populated in multi-row mode; it's always '' otherwise, so
    -- only use each row's real version as a tiebreak in multi-row mode.
    v_version_tiebreak := CASE WHEN noncurrent_versions IN ('only', 'include') THEN 'COALESCE(version, '''')' ELSE '''''' END;

    -- Defense-in-depth: this function is independently reachable and must
    -- not trust p_sort_order/p_sort_column to already be validated by a
    -- caller. Normalize to the same strict allow-list storage.search_v2
    -- uses before interpolating anything into dynamic SQL below.
    v_sort_order := lower(coalesce(p_sort_order, 'asc'));
    IF v_sort_order NOT IN ('asc', 'desc') THEN
        v_sort_order := 'asc';
    END IF;

    v_sort_column := lower(coalesce(p_sort_column, 'updated_at'));
    IF v_sort_column NOT IN ('updated_at', 'created_at') THEN
        v_sort_column := 'updated_at';
    END IF;

    IF v_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                o.version AS obj_version,
                o.archived_at AS obj_archived_at,
                o.is_delete_marker AS obj_is_delete_marker,
                o.is_versioned AS obj_is_versioned,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $10 || '%%'
              AND ($7 != 'exclude' OR o.archived_at IS NULL)
              AND ($7 != 'only' OR o.archived_at IS NOT NULL)
              AND ($8 != 'exclude' OR NOT o.is_delete_marker)
              AND ($8 != 'only' OR o.is_delete_marker)
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                common_prefix AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                NULL::text AS version,
                NULL::timestamptz AS archived_at,
                NULL::boolean AS is_delete_marker,
                NULL::boolean AS is_versioned,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                obj_version AS version,
                obj_archived_at AS archived_at,
                obj_is_delete_marker AS is_delete_marker,
                obj_is_versioned AS is_versioned,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz),
                    name COLLATE "C",
                    %s
                ) %s ROW(
                    -- truncated the same way as the stored value above
                    date_trunc('milliseconds', COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz)),
                    $5,
                    $9
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata,
            version,
            archived_at,
            is_delete_marker,
            is_versioned
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s,
            COALESCE(version, '') %s
        LIMIT $4
    $sql$,
        v_sort_column,
        v_version_tiebreak,
        v_cursor_op,
        v_sort_column,
        v_sort_order,
        v_sort_order,
        v_sort_order
    );

    -- version is the third tiebreak component for two versions of the same
    -- key tying on both timestamp and name (see filtered CTE / ORDER BY above)
    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after, noncurrent_versions, delete_markers, coalesce(p_start_after_version, ''), v_prefix_pattern;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text, text, text, timestamp with time zone, text, boolean); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, start_after_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, start_after_version text DEFAULT ''::text, start_after_is_continuation boolean DEFAULT false) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata,
            l.version,
            l.archived_at,
            l.is_delete_marker,
            l.is_versioned
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            CASE WHEN start_after_is_continuation THEN '' ELSE start_after END,
            CASE WHEN start_after_is_continuation THEN start_after ELSE '' END,
            v_sort_ord,
            noncurrent_versions,
            delete_markers,
            start_after_archived_at,
            start_after_version
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after,
            noncurrent_versions, delete_markers, start_after_version
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- Name: wake_lifecycle_state(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.wake_lifecycle_state() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.lifecycle_configuration IS NULL THEN
        RETURN NEW;
    END IF;

    PERFORM storage.reconcile_lifecycle_state(NEW.id, false);
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: mfa_recovery_code_sets; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_recovery_code_sets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    mfa_factor_id uuid NOT NULL,
    failed_verification_count integer DEFAULT 0 NOT NULL,
    verification_locked_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mfa_recovery_code_sets_failed_verification_count_check CHECK ((failed_verification_count >= 0))
);


--
-- Name: mfa_recovery_codes; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_recovery_codes (
    id uuid NOT NULL,
    mfa_recovery_code_set_id uuid NOT NULL,
    code_hash text NOT NULL,
    consumed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    link_token_hash text,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    dedicated_scope boolean,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: scim_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.scim_tokens (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    token_hash text NOT NULL,
    prefix text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    revoked_at timestamp with time zone,
    last_used_at timestamp with time zone,
    CONSTRAINT scim_tokens_expires_at_future CHECK (((expires_at IS NULL) OR (expires_at > created_at))),
    CONSTRAINT scim_tokens_revoked_after_created CHECK (((revoked_at IS NULL) OR (revoked_at >= created_at))),
    CONSTRAINT scim_tokens_token_hash_check CHECK ((token_hash ~ '^[0-9a-f]{64}$'::text))
);


--
-- Name: scim_users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.scim_users (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    user_id uuid,
    resource jsonb NOT NULL,
    user_name text GENERATED ALWAYS AS (lower((resource ->> 'userName'::text))) STORED NOT NULL,
    external_id text GENERATED ALWAYS AS ((resource ->> 'externalId'::text)) STORED,
    active boolean GENERATED ALWAYS AS (COALESCE(((resource ->> 'active'::text))::boolean, true)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- Name: categoria_prenda; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria_prenda (
    id_categoria bigint NOT NULL,
    nombre text NOT NULL,
    icono text DEFAULT 'shirt'::text NOT NULL,
    color text DEFAULT 'var(--accent)'::text NOT NULL
);


--
-- Name: categoria_prenda_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: -
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
-- Name: cliente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cliente (
    id_cli integer NOT NULL,
    nom_cli character varying(40) NOT NULL,
    num_cli character varying(9) NOT NULL,
    correo_cli character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: cliente_id_cli_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cliente_id_cli_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cliente_id_cli_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cliente_id_cli_seq OWNED BY public.cliente.id_cli;


--
-- Name: detalle_pedido; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: detalle_pedido_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_pedido_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_pedido_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_pedido_id_detalle_seq OWNED BY public.detalle_pedido.id_detalle;


--
-- Name: detalle_servicio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_servicio (
    id_detalle integer NOT NULL,
    id_servicio integer NOT NULL,
    tipo_servicio text NOT NULL,
    precio numeric,
    obs_detalle text
);


--
-- Name: detalle_servicio_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_servicio_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_servicio_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_servicio_id_detalle_seq OWNED BY public.detalle_servicio.id_detalle;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: -
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
    abono numeric,
    CONSTRAINT chk_fechas CHECK ((fec_ter >= fec_ini))
);


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pedido_id_pedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pedido_id_pedido_seq OWNED BY public.pedido.id_pedido;


--
-- Name: precio_prenda; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.precio_prenda (
    id_precio bigint NOT NULL,
    talla text NOT NULL,
    precio numeric(10,0) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    id_categoria bigint NOT NULL
);


--
-- Name: TABLE precio_prenda; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.precio_prenda IS 'Precios fijos por talla de prendas escolares, mostrados en el landing público.';


--
-- Name: precio_prenda_id_precio_seq; Type: SEQUENCE; Schema: public; Owner: -
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
-- Name: reporte_semanal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reporte_semanal (
    id_reporte bigint NOT NULL,
    fecha_desde timestamp with time zone NOT NULL,
    fecha_hasta timestamp with time zone NOT NULL,
    metricas jsonb NOT NULL,
    contenido jsonb,
    modelo text,
    estado text DEFAULT 'ok'::text NOT NULL,
    error text,
    generado_por uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT reporte_semanal_estado_check CHECK ((estado = ANY (ARRAY['ok'::text, 'error'::text])))
);


--
-- Name: reporte_semanal_id_reporte_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.reporte_semanal ALTER COLUMN id_reporte ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.reporte_semanal_id_reporte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: servicio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servicio (
    id_servicio integer NOT NULL,
    id_cli integer NOT NULL,
    fec_ini date,
    fec_ter date,
    estado_servicio text,
    abono numeric,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: servicio_id_servicio_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.servicio_id_servicio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: servicio_id_servicio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.servicio_id_servicio_seq OWNED BY public.servicio.id_servicio;


--
-- Name: trabajo; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: trabajo_historial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trabajo_historial (
    id_historial integer NOT NULL,
    id_trabajo integer NOT NULL,
    id_usu integer,
    estado_anterior text,
    estado_nuevo text NOT NULL,
    fecha_cambio timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: trabajo_historial_id_historial_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trabajo_historial_id_historial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trabajo_historial_id_historial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trabajo_historial_id_historial_seq OWNED BY public.trabajo_historial.id_historial;


--
-- Name: trabajo_id_trabajo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trabajo_id_trabajo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trabajo_id_trabajo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trabajo_id_trabajo_seq OWNED BY public.trabajo.id_trabajo;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: usuario_id_usu_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_id_usu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario_id_usu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuario_id_usu_seq OWNED BY public.usuario.id_usu;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    expires_at timestamp without time zone
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone DEFAULT now()
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bucket_lifecycle_states; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.bucket_lifecycle_states (
    bucket_id text NOT NULL,
    generation uuid,
    next_run_at timestamp with time zone,
    claim_id uuid,
    claim_until timestamp with time zone,
    continuation jsonb,
    last_started_at timestamp with time zone,
    last_completed_at timestamp with time zone,
    last_success_at timestamp with time zone,
    last_result jsonb,
    failure_count integer DEFAULT 0 NOT NULL,
    last_error jsonb,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT bucket_lifecycle_continuation_object_check CHECK (((continuation IS NULL) OR (jsonb_typeof(continuation) = 'object'::text))),
    CONSTRAINT bucket_lifecycle_failure_count_check CHECK ((failure_count >= 0)),
    CONSTRAINT bucket_lifecycle_last_result_object_check CHECK (((last_result IS NULL) OR (jsonb_typeof(last_result) = 'object'::text))),
    CONSTRAINT bucket_lifecycle_recovery_due_check CHECK (((next_run_at IS NOT NULL) OR (NOT jsonb_path_exists(COALESCE(continuation, '{}'::jsonb), '$."batch"."inFlight"'::jsonpath))))
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL,
    versioning_status text DEFAULT 'DISABLED'::text NOT NULL,
    lifecycle_configuration jsonb,
    lifecycle_configuration_generation uuid,
    CONSTRAINT buckets_lifecycle_configuration_pair_check CHECK (((lifecycle_configuration IS NULL) = (lifecycle_configuration_generation IS NULL))),
    CONSTRAINT buckets_lifecycle_configuration_shape_check CHECK (((lifecycle_configuration IS NULL) OR ((jsonb_typeof(lifecycle_configuration) = 'object'::text) AND (lifecycle_configuration ? 'rules'::text) AND
CASE
    WHEN (jsonb_typeof((lifecycle_configuration -> 'rules'::text)) = 'array'::text) THEN ((jsonb_array_length((lifecycle_configuration -> 'rules'::text)) >= 1) AND (jsonb_array_length((lifecycle_configuration -> 'rules'::text)) <= 1000))
    ELSE false
END))),
    CONSTRAINT buckets_lifecycle_configuration_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR ((lifecycle_configuration IS NULL) AND (lifecycle_configuration_generation IS NULL)))),
    CONSTRAINT buckets_versioning_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR (versioning_status = 'DISABLED'::text))),
    CONSTRAINT buckets_versioning_status_check CHECK ((versioning_status = ANY (ARRAY['DISABLED'::text, 'ENABLED'::text, 'SUSPENDED'::text])))
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: lifecycle_abandoned_artifacts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.lifecycle_abandoned_artifacts (
    bucket_id text NOT NULL,
    key text NOT NULL,
    name text NOT NULL,
    version text,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    archived_at timestamp with time zone,
    is_delete_marker boolean DEFAULT false NOT NULL,
    is_versioned boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: cliente id_cli; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id_cli SET DEFAULT nextval('public.cliente_id_cli_seq'::regclass);


--
-- Name: detalle_pedido id_detalle; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_pedido ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_pedido_id_detalle_seq'::regclass);


--
-- Name: detalle_servicio id_detalle; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_servicio ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_servicio_id_detalle_seq'::regclass);


--
-- Name: pedido id_pedido; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pedido ALTER COLUMN id_pedido SET DEFAULT nextval('public.pedido_id_pedido_seq'::regclass);


--
-- Name: servicio id_servicio; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicio ALTER COLUMN id_servicio SET DEFAULT nextval('public.servicio_id_servicio_seq'::regclass);


--
-- Name: trabajo id_trabajo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo ALTER COLUMN id_trabajo SET DEFAULT nextval('public.trabajo_id_trabajo_seq'::regclass);


--
-- Name: trabajo_historial id_historial; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo_historial ALTER COLUMN id_historial SET DEFAULT nextval('public.trabajo_historial_id_historial_seq'::regclass);


--
-- Name: usuario id_usu; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usu SET DEFAULT nextval('public.usuario_id_usu_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at, custom_claims_allowlist) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
7b37fc5f-78f3-47bb-81d3-b6d230ba5184	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	{"sub": "7b37fc5f-78f3-47bb-81d3-b6d230ba5184", "email": "yeanleyton6@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-09-10 11:42:57.259198+00	2026-09-10 11:42:57.259269+00	2026-09-10 11:42:57.259269+00	bb015d27-6aa9-44ad-99f3-f9403c2edeed
ad266a98-359d-402b-8a93-639a1aaef47f	ad266a98-359d-402b-8a93-639a1aaef47f	{"sub": "ad266a98-359d-402b-8a93-639a1aaef47f", "email": "sm.aravena@duocuc.cl", "email_verified": true, "phone_verified": false}	email	2026-09-10 11:47:41.853618+00	2026-09-10 11:47:41.853667+00	2026-09-10 11:47:41.853667+00	97aa3f01-28d4-4a56-9e8a-55c25473288a
339c3590-377f-46c1-8d50-6944c77fb60a	339c3590-377f-46c1-8d50-6944c77fb60a	{"sub": "339c3590-377f-46c1-8d50-6944c77fb60a", "email": "matiasgonzalezpizarro@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-09-14 19:54:56.64289+00	2026-09-14 19:54:56.64295+00	2026-09-14 19:54:56.64295+00	62f42d9e-f310-4df0-b304-831d078158d0
f8225130-fa68-4794-a288-dd849c9ab26b	f8225130-fa68-4794-a288-dd849c9ab26b	{"sub": "f8225130-fa68-4794-a288-dd849c9ab26b", "email": "mregonzalezp@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-09-15 14:28:55.046293+00	2026-09-15 14:28:55.046362+00	2026-09-15 14:28:55.046362+00	9dc4201a-a53e-458d-9a50-7785d2a0369f
10c6b0e2-faab-4f09-9b4c-aed86db47c7d	10c6b0e2-faab-4f09-9b4c-aed86db47c7d	{"sub": "10c6b0e2-faab-4f09-9b4c-aed86db47c7d", "email": "pablo@pablo.cl", "email_verified": false, "phone_verified": false}	email	2026-09-19 14:37:46.812821+00	2026-09-19 14:37:46.813461+00	2026-09-19 14:37:46.813461+00	2848bdc6-ffcd-4e71-a98e-2a06169b04e1
b000e35f-e415-4935-a7cd-bdfe74db24c4	b000e35f-e415-4935-a7cd-bdfe74db24c4	{"sub": "b000e35f-e415-4935-a7cd-bdfe74db24c4", "email": "jea.leyton@duocuc.cl", "email_verified": true, "phone_verified": false}	email	2026-10-07 17:21:30.439736+00	2026-10-07 17:21:30.440402+00	2026-10-07 17:21:30.440402+00	fee9a05e-6dbb-4bd1-854d-a21cd292f3dc
c6e673f9-5c8b-40d2-8d45-f731187eb9d4	c6e673f9-5c8b-40d2-8d45-f731187eb9d4	{"sub": "c6e673f9-5c8b-40d2-8d45-f731187eb9d4", "email": "mr.gonzalez@duocuc.cl", "email_verified": false, "phone_verified": false}	email	2026-11-08 14:22:49.872299+00	2026-11-08 14:22:49.872915+00	2026-11-08 14:22:49.872915+00	274b0e2c-6da9-49e7-b1ac-1d4f93311917
5d0b78e1-faa1-4d29-a2f7-892a6bd61351	5d0b78e1-faa1-4d29-a2f7-892a6bd61351	{"sub": "5d0b78e1-faa1-4d29-a2f7-892a6bd61351", "email": "milyunaideasentela@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-11-18 00:47:34.128605+00	2026-11-18 00:47:34.128658+00	2026-11-18 00:47:34.128658+00	5fa95d95-b643-489b-a334-ad11ccd68022
8394e6ea-f3b3-4089-bba5-4b5a655426a7	8394e6ea-f3b3-4089-bba5-4b5a655426a7	{"sub": "8394e6ea-f3b3-4089-bba5-4b5a655426a7", "email": "gonzalezpizarrom98@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-11-18 13:03:28.827309+00	2026-11-18 13:03:28.827374+00	2026-11-18 13:03:28.827374+00	3e7d80c2-8346-4ca6-998f-ccbba30adab9
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
d839a5f4-54a3-4df2-a9dd-13ca3105dd90	2026-11-18 13:04:26.582597+00	2026-11-18 13:04:26.582597+00	password	55e5067f-d3e1-4d12-a782-9d2c08cdcc7f
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: mfa_recovery_code_sets; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_recovery_code_sets (id, user_id, mfa_factor_id, failed_verification_count, verification_locked_until, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_recovery_codes; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_recovery_codes (id, mfa_recovery_code_set_id, code_hash, consumed_at, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at, expires_at, link_token_hash) FROM stdin;
a4ae2610-b243-4a3e-bbbe-2a2286f26413	339c3590-377f-46c1-8d50-6944c77fb60a	recovery_token	ffc20ec9eb87b0f788df2ef6c18ed4282b2ceccb7af89c88fa1a76a9	matiasgonzalezpizarro@gmail.com	2026-09-14 19:55:27.906159	2026-09-14 19:55:27.906159	\N	\N
1f03cd7c-b26f-423f-a43e-f5eff0bb4423	10c6b0e2-faab-4f09-9b4c-aed86db47c7d	confirmation_token	21b66b944ac828824c3c0fb8490294633d45cd3d6e4ff3988ef70a52	pablo@pablo.cl	2026-09-19 14:37:48.060965	2026-09-19 14:37:48.060965	\N	\N
b49be36f-8b09-4d8c-8c7e-561b0df75e9b	c6e673f9-5c8b-40d2-8d45-f731187eb9d4	confirmation_token	08a9329dce5cdf0b06405db4b8c39e958765bc3f0d1f383c90366006	mr.gonzalez@duocuc.cl	2026-11-08 14:22:51.361437	2026-11-08 14:22:51.361437	\N	\N
2fa01643-d631-49a0-8e81-174f2ca5fa9a	5d0b78e1-faa1-4d29-a2f7-892a6bd61351	confirmation_token	0204cef60d7bbb06949d39684a59c8ab43aa2a25292fda77f3a8d7d3	milyunaideasentela@gmail.com	2026-11-18 00:47:35.866527	2026-11-18 00:47:35.866527	\N	\N
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	135	odj5sir65g67	8394e6ea-f3b3-4089-bba5-4b5a655426a7	f	2026-11-18 13:04:26.5773+00	2026-11-18 13:04:26.5773+00	\N	d839a5f4-54a3-4df2-a9dd-13ca3105dd90
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format, dedicated_scope) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
20260625000000
20260821000000
20260821010000
20260824000000
20260824000001
20260831180000
20260911120000
20261030120000
\.


--
-- Data for Name: scim_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.scim_tokens (id, sso_provider_id, token_hash, prefix, created_at, expires_at, revoked_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: scim_users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.scim_users (id, sso_provider_id, user_id, resource, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
d839a5f4-54a3-4df2-a9dd-13ca3105dd90	8394e6ea-f3b3-4089-bba5-4b5a655426a7	2026-11-18 13:04:26.566975+00	2026-11-18 13:04:26.566975+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:160.0) Gecko/20100101 Firefox/160.0	181.43.149.252	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	b000e35f-e415-4935-a7cd-bdfe74db24c4	authenticated	authenticated	jea.leyton@duocuc.cl	$2a$10$Rs0IFnn3WfS0wRIy5MXAEOaaullxpCsDfCIQDybfr5vWar9lVxJVS	2026-10-07 17:21:38.87077+00	\N		\N		\N			\N	2026-10-07 17:21:58.113566+00	{"provider": "email", "providers": ["email"]}	{"sub": "b000e35f-e415-4935-a7cd-bdfe74db24c4", "email": "jea.leyton@duocuc.cl", "email_verified": true, "phone_verified": false}	\N	2026-10-07 17:21:30.402204+00	2026-10-07 17:21:58.117041+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	339c3590-377f-46c1-8d50-6944c77fb60a	authenticated	authenticated	matiasgonzalezpizarro@gmail.com	$2a$10$JscE30mSFG2Rjnwe4AmMeut0a9G2A9BE5ErX1HK2PoLsYpxpSpGxy	2026-09-14 19:54:56.647112+00	\N		\N	ffc20ec9eb87b0f788df2ef6c18ed4282b2ceccb7af89c88fa1a76a9	2026-09-14 19:55:26.623043+00			\N	2026-10-23 00:03:07.143038+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-09-14 19:54:56.638145+00	2026-10-23 00:03:07.162497+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	10c6b0e2-faab-4f09-9b4c-aed86db47c7d	authenticated	authenticated	pablo@pablo.cl	$2a$06$yc42sgJ4WR.pT0CyEYDnrOoobFANd4agJ1sC1ntolZj3iUvRoQVCm	2026-09-19 14:44:12.101016+00	\N	21b66b944ac828824c3c0fb8490294633d45cd3d6e4ff3988ef70a52	2026-09-19 14:37:46.823149+00		\N			\N	2026-09-19 14:44:24.173332+00	{"provider": "email", "providers": ["email"]}	{"sub": "10c6b0e2-faab-4f09-9b4c-aed86db47c7d", "email": "pablo@pablo.cl", "email_verified": false, "phone_verified": false}	\N	2026-09-19 14:37:46.780478+00	2026-09-19 14:44:24.191419+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ad266a98-359d-402b-8a93-639a1aaef47f	authenticated	authenticated	sm.aravena@duocuc.cl	$2a$10$NxslOaLZ6HYve17z//4.DOnQHu2NfrPQHEgYhb06AE.9Ap2IM1GQi	2026-09-10 11:48:41.374239+00	\N		\N		\N			\N	2026-11-17 23:18:25.119287+00	{"provider": "email", "providers": ["email"]}	{"sub": "ad266a98-359d-402b-8a93-639a1aaef47f", "email": "sm.aravena@duocuc.cl", "email_verified": true, "phone_verified": false}	\N	2026-09-10 11:47:41.845731+00	2026-11-17 23:18:25.12928+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c6e673f9-5c8b-40d2-8d45-f731187eb9d4	authenticated	authenticated	mr.gonzalez@duocuc.cl	$2a$10$j8FeE1I1TAtP9UyhQfdLmeb0zKLIJIaKcyFQjZnWiQ2FO.kjFB8S.	\N	\N	08a9329dce5cdf0b06405db4b8c39e958765bc3f0d1f383c90366006	2026-11-08 14:22:49.885794+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "c6e673f9-5c8b-40d2-8d45-f731187eb9d4", "email": "mr.gonzalez@duocuc.cl", "email_verified": false, "phone_verified": false}	\N	2026-11-08 14:22:49.845876+00	2026-11-08 14:22:51.35097+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f8225130-fa68-4794-a288-dd849c9ab26b	authenticated	authenticated	mregonzalezp@gmail.com	$2a$10$iV9RI4wppeN1TBC.PlE9kurZsefTfSggYFoFkF2rubkuhoM03.6jS	2026-09-15 14:28:55.05527+00	\N		\N		\N			\N	2026-09-15 14:42:06.95996+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-09-15 14:28:55.030022+00	2026-09-15 14:42:06.971442+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8394e6ea-f3b3-4089-bba5-4b5a655426a7	authenticated	authenticated	gonzalezpizarrom98@gmail.com	$2a$10$sFHgCg/ceCl7.I0XnvqGLO6RxxCyBWk9CE/pQON.kjFfIF1hxRmxi	2026-11-18 13:03:51.196539+00	\N		\N		\N			\N	2026-11-18 13:04:26.566146+00	{"provider": "email", "providers": ["email"]}	{"sub": "8394e6ea-f3b3-4089-bba5-4b5a655426a7", "email": "gonzalezpizarrom98@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-11-18 13:03:28.793235+00	2026-11-18 13:04:26.581173+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	5d0b78e1-faa1-4d29-a2f7-892a6bd61351	authenticated	authenticated	milyunaideasentela@gmail.com	$2a$10$K4bns3mU/yYl2A.txDXbZO9dzel5JLbWcqnnfOX3ChkUiVRpmdBJy	\N	\N	0204cef60d7bbb06949d39684a59c8ab43aa2a25292fda77f3a8d7d3	2026-11-18 00:47:34.143604+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "5d0b78e1-faa1-4d29-a2f7-892a6bd61351", "email": "milyunaideasentela@gmail.com", "email_verified": false, "phone_verified": false}	\N	2026-11-18 00:47:34.114922+00	2026-11-18 00:47:35.855249+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	authenticated	authenticated	yeanleyton6@gmail.com	$2a$10$0N/VoPoRtSAw8UNmFTRIheFq9K3DolQcsN.IMP8W4TXMDJ/auISXy	2026-09-10 11:45:40.003256+00	\N		\N		\N			\N	2026-11-18 13:02:33.387872+00	{"provider": "email", "providers": ["email"]}	{}	\N	2026-09-10 11:42:57.23697+00	2026-11-18 13:02:33.437071+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: cron; Owner: -
--

COPY cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) FROM stdin;
1	0 4 * * *	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	localhost	5432	postgres	postgres	t	limpiar-reportes-semanales
5	0 12 * * *	\r\n  select net.http_post(\r\n    url := 'https://skfrensubuiglhlsbvqx.supabase.co/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'x-cron-secret', (\r\n        select decrypted_secret\r\n        from vault.decrypted_secrets\r\n        where name = 'CRON_SECRET'\r\n        limit 1\r\n      )\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	localhost	5432	postgres	postgres	t	aviso-entrega-diario
\.


--
-- Data for Name: job_run_details; Type: TABLE DATA; Schema: cron; Owner: -
--

COPY cron.job_run_details (jobid, runid, job_pid, database, username, command, status, return_message, start_time, end_time) FROM stdin;
3	10	2484378	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-10 12:00:00.19074+00	2026-11-10 12:00:00.285669+00
3	8	2378303	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-09 12:00:00.204468+00	2026-11-09 12:00:00.319381+00
1	1	1707468	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-03 04:00:00.231516+00	2026-11-03 04:00:00.261159+00
1	17	2873253	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-14 04:00:00.190514+00	2026-11-14 04:00:00.243641+00
3	16	2802664	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-13 12:00:00.201169+00	2026-11-13 12:00:00.305037+00
1	2	1812352	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-04 04:00:00.189788+00	2026-11-04 04:00:00.246897+00
1	9	2448913	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-10 04:00:00.187649+00	2026-11-10 04:00:00.236566+00
1	3	1917260	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-05 04:00:00.190461+00	2026-11-05 04:00:00.239724+00
1	11	2554963	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-11 04:00:00.191127+00	2026-11-11 04:00:00.246287+00
1	13	2661191	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-12 04:00:00.187985+00	2026-11-12 04:00:00.243703+00
1	4	2022707	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-06 04:00:00.17003+00	2026-11-06 04:00:00.221917+00
1	15	2767174	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-13 04:00:00.200599+00	2026-11-13 04:00:00.25018+00
1	5	2128949	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-07 04:00:00.183978+00	2026-11-07 04:00:00.23947+00
3	12	2590415	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-11 12:00:00.190077+00	2026-11-11 12:00:00.300819+00
1	6	2235108	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-08 04:00:00.198776+00	2026-11-08 04:00:00.252783+00
3	14	2696633	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-12 12:00:00.205393+00	2026-11-12 12:00:00.320666+00
1	7	2342842	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-09 04:00:00.235105+00	2026-11-09 04:00:00.275087+00
3	20	3014990	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-15 12:00:00.195022+00	2026-11-15 12:00:00.299921+00
3	18	2908687	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-14 12:00:00.214342+00	2026-11-14 12:00:00.322547+00
1	19	2979431	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-15 04:00:00.188761+00	2026-11-15 04:00:00.238076+00
1	21	3085592	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-16 04:00:00.199277+00	2026-11-16 04:00:00.250593+00
1	25	3303773	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-18 04:00:00.192022+00	2026-11-18 04:00:00.244611+00
3	22	3121047	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-16 12:00:00.220808+00	2026-11-16 12:00:00.341921+00
1	23	3193081	postgres	postgres	 delete from public.reporte_semanal where created_at < now() - interval '60 days' 	succeeded	DELETE 0	2026-11-17 04:00:00.211234+00	2026-11-17 04:00:00.264349+00
3	26	3340615	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-18 12:00:00.205116+00	2026-11-18 12:00:00.319166+00
3	24	3229927	postgres	postgres	\r\n  select net.http_post(\r\n    url := (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_project_url')\r\n           || '/functions/v1/aviso-entrega',\r\n    headers := jsonb_build_object(\r\n      'Content-Type', 'application/json',\r\n      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_anon_key'),\r\n      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'aviso_entrega_cron_secret')\r\n    ),\r\n    body := '{}'::jsonb\r\n  );\r\n  	succeeded	1 row	2026-11-17 12:00:00.204742+00	2026-11-17 12:00:00.309834+00
\.


--
-- Data for Name: categoria_prenda; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categoria_prenda (id_categoria, nombre, icono, color) FROM stdin;
1	Poleras Deportivas	shirt	var(--blue)
2	Poleras de Piqué	shirt	var(--purple)
3	Buzos Escolares	jacket	var(--orange)
13	Poleron	shirt	var(--pink)
14	Polerón	jacket	var(--purple)
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cliente (id_cli, nom_cli, num_cli, correo_cli, created_at) FROM stdin;
9	Matias González	935201773	\N	2026-11-17 22:43:17.67674+00
\.


--
-- Data for Name: detalle_pedido; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_pedido (id_detalle, cant_prendas, tipo_prenda, obs_detalle, id_pedido, talla, precio) FROM stdin;
17	1	Polera	\N	14	L	20000
\.


--
-- Data for Name: detalle_servicio; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_servicio (id_detalle, id_servicio, tipo_servicio, precio, obs_detalle) FROM stdin;
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pedido (id_pedido, fec_ini, fec_ter, id_cli, estado_pedido, calendar_event_id, created_at, id_usu_responsable, abono) FROM stdin;
14	2026-11-18	2026-11-20	9	pendiente	\N	2026-11-18 13:08:17.73147+00	\N	0
\.


--
-- Data for Name: precio_prenda; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.precio_prenda (id_precio, talla, precio, created_at, id_categoria) FROM stdin;
1	Talla 4	8000	2026-09-18 20:06:03.808441+00	1
2	Talla 6 y 8	10000	2026-09-18 20:06:03.808441+00	1
3	Talla 10 y 12	11000	2026-09-18 20:06:03.808441+00	1
4	Talla 14 y 16	12500	2026-09-18 20:06:03.808441+00	1
5	Talla S y M	13000	2026-09-18 20:06:03.808441+00	1
6	Talla L y XL	13500	2026-09-18 20:06:03.808441+00	1
7	Talla 2XL	15000	2026-09-18 20:06:03.808441+00	1
8	Talla 4	10000	2026-09-18 20:06:03.808441+00	2
9	Talla 6 y 8	11500	2026-09-18 20:06:03.808441+00	2
10	Talla 10 y 12	12500	2026-09-18 20:06:03.808441+00	2
11	Talla 14 y 16	13000	2026-09-18 20:06:03.808441+00	2
12	Talla S y M	14000	2026-09-18 20:06:03.808441+00	2
13	Talla L y XL	15000	2026-09-18 20:06:03.808441+00	2
14	Talla 2XL	16000	2026-09-18 20:06:03.808441+00	2
16	Talla 6-8	20000	2026-09-18 20:06:03.808441+00	3
17	Talla 10-12	22000	2026-09-18 20:06:03.808441+00	3
18	Talla 14-16	25000	2026-09-18 20:06:03.808441+00	3
19	Talla S-M	26000	2026-09-18 20:06:03.808441+00	3
20	Talla L-XL	28000	2026-09-18 20:06:03.808441+00	3
21	Talla 2XL	30000	2026-09-18 20:06:03.808441+00	3
15	Talla 4	17000	2026-09-18 20:06:03.808441+00	3
\.


--
-- Data for Name: reporte_semanal; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reporte_semanal (id_reporte, fecha_desde, fecha_hasta, metricas, contenido, modelo, estado, error, generado_por, created_at) FROM stdin;
1	2026-10-21 12:09:23.706+00	2026-10-28 12:09:23.706+00	{"periodo": {"desde": "2026-10-21T12:09:23.706Z", "hasta": "2026-10-28T12:09:23.706Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Operaria", "nombre": "Matias", "terminados": 1, "pendientes_actuales": 7}, {"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 1, "trabajos_terminados": {"armado": 1}, "horas_promedio_por_trabajo": {"armado": 194.7}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 7, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 18, "terminado": 6}}}, "semana_anterior": {"pedidos": {"creados": 1, "top_prendas": [{"cantidad": 1, "tipo_prenda": "Buzos Escolares"}, {"cantidad": 1, "tipo_prenda": "Poleras Deportivas"}], "monto_estimado": 29500, "abonos_recibidos": 0, "prendas_encargadas": 2}, "clientes": {"con_pedidos": 1, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 2, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}}}	\N	\N	error	Gemini respondió 404: {\n  "error": {\n    "code": 404,\n    "message": "This model models/gemini-2.5-flash is no longer available to new users. Please update your code to use models/gemini-3.8-flash for the latest features and improvements. We recommend you to use the Interactions API (https://ai.google.dev/gemini-api/docs	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-10-28 12:09:25.052654+00
2	2026-10-21 12:11:58.569+00	2026-10-28 12:11:58.569+00	{"periodo": {"desde": "2026-10-21T12:11:58.569Z", "hasta": "2026-10-28T12:11:58.569Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Operaria", "nombre": "Matias", "terminados": 1, "pendientes_actuales": 7}, {"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 1, "trabajos_terminados": {"armado": 1}, "horas_promedio_por_trabajo": {"armado": 194.7}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 7, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 18, "terminado": 6}}}, "semana_anterior": {"pedidos": {"creados": 1, "top_prendas": [{"cantidad": 1, "tipo_prenda": "Buzos Escolares"}, {"cantidad": 1, "tipo_prenda": "Poleras Deportivas"}], "monto_estimado": 29500, "abonos_recibidos": 0, "prendas_encargadas": 2}, "clientes": {"con_pedidos": 1, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 2, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}}}	{"resumen": "Durante la semana no se registraron nuevos pedidos ni ingresos, cayendo respecto al pedido de $29.500 CLP de la semana anterior. El taller mantiene un alto nivel de atraso con 6 pedidos fuera de plazo y 18 trabajos pendientes en total. La producción avanzó solo con 1 trabajo de armado terminado en la semana.", "riesgos": ["Pérdida de clientes o reclamos formales por la acumulación de 6 pedidos con retraso.", "Falta de liquidez a corto plazo debido a nula entrada de pedidos y $0 CLP recaudados en abonos durante el período.", "Cuello de botella operativo severo si no se destraban los 18 trabajos pendientes frente al bajo ritmo de entrega semanal."], "hallazgos": [{"tipo": "alerta", "titulo": "Sin nuevos pedidos ni ingresos", "detalle": "Se crearon 0 pedidos y 0 servicios en la semana actual, recaudando $0 CLP en abonos frente a los $29.500 CLP estimados de la semana anterior."}, {"tipo": "alerta", "titulo": "Alto volumen de pedidos atrasados", "detalle": "La foto actual del taller muestra 6 pedidos atrasados de un total de 9 pedidos activos (7 pendientes, 1 en progreso y 1 listo)."}, {"tipo": "alerta", "titulo": "Bajo avance de producción", "detalle": "Se registró solo 1 trabajo terminado en armado a cargo de Matias, registrando un promedio de 194,7 horas, mientras se mantienen 18 trabajos pendientes en el equipo."}, {"tipo": "neutral", "titulo": "Distribución de tareas pendientes", "detalle": "Matias acumula 7 trabajos pendientes, smolenks 6, Trabajador 4 y Jean Paul 1, sumando los 18 trabajos pendientes reportados."}], "recomendaciones": ["Concentrar el trabajo del taller de forma urgente en despachar los 6 pedidos atrasados antes de iniciar nuevas tareas.", "Revisar el flujo del proceso de armado para reducir los tiempos, que promediaron 194,7 horas esta semana.", "Redistribuir los trabajos pendientes entre el personal de corte y confección para equilibrar la carga de Matias y smolenks.", "Gestionar acciones comerciales con clientes de uniformes y servicios de costura para reactivar la entrada de pedidos y abonos."]}	gemini-3.8-flash	ok	\N	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-10-28 12:12:31.525052+00
3	2026-10-24 15:23:21.983+00	2026-10-31 15:23:21.983+00	{"periodo": {"desde": "2026-10-24T15:23:21.983Z", "hasta": "2026-10-31T15:23:21.983Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 7, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 18, "terminado": 6}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Operaria", "nombre": "Matias", "terminados": 1, "pendientes_actuales": 7}, {"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 3, "trabajos_terminados": {"armado": 1}, "horas_promedio_por_trabajo": {"armado": 194.7}}}}	\N	\N	error	Gemini respondió 503: {\n  "error": {\n    "code": 503,\n    "message": "This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.",\n    "status": "UNAVAILABLE"\n  }\n}\n	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-10-31 15:23:24.785878+00
4	2026-10-24 15:23:42.134+00	2026-10-31 15:23:42.134+00	{"periodo": {"desde": "2026-10-24T15:23:42.134Z", "hasta": "2026-10-31T15:23:42.134Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 7, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 18, "terminado": 6}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Operaria", "nombre": "Matias", "terminados": 1, "pendientes_actuales": 7}, {"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 3, "trabajos_terminados": {"armado": 1}, "horas_promedio_por_trabajo": {"armado": 194.7}}}}	{"resumen": "Durante la última semana no se registraron nuevos pedidos ni servicios, manteniéndose los ingresos en $0 CLP al igual que la semana anterior. La actividad productiva se detuvo por completo, pasando de 1 trabajo terminado y 3 cambios de estado la semana pasada a 0 avances en este periodo. Actualmente el taller enfrenta una situación crítica con 6 pedidos atrasados y 18 trabajos pendientes acumulados.", "riesgos": ["Incumplimiento grave de plazos con clientes debido a los 6 pedidos actualmente atrasados y sin avance productivo en la semana.", "Problemas de liquidez operativa en el taller al acumular dos semanas consecutivas sin nuevos abonos ni ventas."], "hallazgos": [{"tipo": "alerta", "titulo": "Detención de la producción semanal", "detalle": "Durante la semana no se registró ningún trabajo terminado ni cambios de estado en el taller, a diferencia de la semana previa donde se completó 1 trabajo de armado."}, {"tipo": "alerta", "titulo": "Alto volumen de pedidos atrasados", "detalle": "En el estado actual del taller hay 6 pedidos atrasados sobre un total de 9 registrados (7 pendientes, 1 en progreso y 1 listo)."}, {"tipo": "neutral", "titulo": "Carga acumulada en el equipo", "detalle": "Existen 18 trabajos pendientes repartidos entre las operarias: Matias concentra 7, smolenks 6, Trabajador 4 y Jean Paul 1."}, {"tipo": "alerta", "titulo": "Sin captación de ventas ni abonos", "detalle": "Tanto en la semana actual como en la anterior no hubo creación de pedidos ni servicios, con $0 CLP en abonos recibidos."}], "recomendaciones": ["Organizar una reunión de piso urgente para revisar las trabas en los 6 pedidos atrasados y fijar fechas de entrega inmediatas.", "Redistribuir los trabajos pendientes concentrados en Matias (7) y smolenks (6) para reactivar el flujo de confección.", "Despachar y gestionar el cobro final del pedido que ya figura en estado 'listo'.", "Hacer seguimiento comercial para reactivar la entrada de nuevos pedidos de uniformes o servicios de costura."]}	gemini-3.8-flash	ok	\N	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-10-31 15:25:18.520097+00
5	2026-10-24 15:25:20.576+00	2026-10-31 15:25:20.576+00	{"periodo": {"desde": "2026-10-24T15:25:20.576Z", "hasta": "2026-10-31T15:25:20.576Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 7, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 18, "terminado": 6}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Operaria", "nombre": "Matias", "terminados": 1, "pendientes_actuales": 7}, {"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 3, "trabajos_terminados": {"armado": 1}, "horas_promedio_por_trabajo": {"armado": 194.7}}}}	{"resumen": "Durante esta semana no se registraron nuevos pedidos ni servicios, manteniéndose los ingresos en $0 CLP al igual que la semana previa. La producción estuvo completamente detenida, pasando de 1 trabajo terminado la semana anterior a 0 en este período. El taller mantiene una situación crítica con 6 pedidos atrasados y 18 trabajos pendientes acumulados.", "riesgos": ["Reclamos y daño a la reputación del taller debido a que dos tercios de los pedidos activos están atrasados.", "Problemas de flujo de caja inmediato por la falta de nuevos abonos o cobros en las últimas dos semanas.", "Cuello de botella operativo en las estaciones de Matias y smolenks por sobrecarga de tareas pendientes."], "hallazgos": [{"tipo": "alerta", "titulo": "Sin ingresos comerciales en dos semanas", "detalle": "No se generaron pedidos ni servicios durante la semana actual ni la anterior, registrando $0 CLP en ventas y abonos."}, {"tipo": "alerta", "titulo": "Producción detenida sin avances", "detalle": "Hubo 0 cambios de estado y 0 trabajos terminados en la semana, a diferencia de la semana anterior donde se finalizó 1 armado."}, {"tipo": "alerta", "titulo": "Alto volumen de pedidos atrasados", "detalle": "De los 9 pedidos vigentes en el taller (7 pendientes, 1 en progreso y 1 listo), 6 se encuentran atrasados."}, {"tipo": "neutral", "titulo": "Concentración de carga laboral", "detalle": "Existen 18 trabajos pendientes distribuidos en el equipo: Matias tiene 7, smolenks 6, Trabajador 4 y Jean Paul 1."}], "recomendaciones": ["Concentrar la capacidad del taller en despachar prioritariamente los 6 pedidos que se encuentran atrasados.", "Gestionar la entrega y cobro final del pedido que ya se encuentra en estado 'listo'.", "Rebalancear la carga de trabajo de Matias y smolenks, quienes concentran 13 de los 18 trabajos pendientes.", "Revisar con el equipo el registro diario en el sistema para evitar que los avances de producción queden sin registrar."]}	gemini-3.8-flash	ok	\N	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-10-31 15:26:27.306049+00
6	2026-10-26 17:08:09.166+00	2026-11-02 17:08:09.166+00	{"periodo": {"desde": "2026-10-26T17:08:09.166Z", "hasta": "2026-11-02T17:08:09.166Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 6, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 18, "terminado": 6}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Operaria", "nombre": "Matias", "terminados": 1, "pendientes_actuales": 7}, {"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 1, "trabajos_terminados": {"armado": 1}, "horas_promedio_por_trabajo": {"armado": 194.7}}}}	{"resumen": "Durante esta semana no se registraron nuevos pedidos ni ingresos monetarios, manteniendo la misma nula actividad comercial que la semana anterior. En el taller la producción se detuvo por completo, registrando cero trabajos terminados y cero cambios de estado. El estado actual es crítico, con 6 pedidos atrasados de un total de 8 y 18 trabajos pendientes acumulados en el equipo.", "riesgos": ["Pérdida de clientes y daño a la reputación del taller por mantener 6 pedidos fuera de plazo sin avance productivo.", "Compromiso de la liquidez del taller debido a dos semanas consecutivas sin ingresos por abonos ni nuevos encargos."], "hallazgos": [{"tipo": "alerta", "titulo": "Paralización total de la producción semanal", "detalle": "Durante la semana actual se registraron 0 trabajos finalizados y 0 cambios de estado, frente a 1 trabajo de armado terminado por Matias la semana previa."}, {"tipo": "alerta", "titulo": "Alta concentración de pedidos atrasados", "detalle": "La foto actual del taller muestra 6 pedidos atrasados sobre un total de 8 registrados (6 pendientes, 1 en progreso y 1 listo)."}, {"tipo": "alerta", "titulo": "Acumulación de trabajos pendientes por operaria", "detalle": "Existen 18 trabajos pendientes distribuidos principalmente entre Matias (7), smolenks (6) y Trabajador (4), mientras que Jean Paul mantiene 1."}, {"tipo": "neutral", "titulo": "Sin movimiento comercial ni cobranzas", "detalle": "Tanto pedidos de confección como servicios sumaron $0 en montos estimados y $0 en abonos recibidos, repitiendo el comportamiento de la semana anterior."}], "recomendaciones": ["Reunir al equipo para redistribuir y dar máxima prioridad a los 6 pedidos atrasados antes de iniciar cualquier otra labor.", "Revisar directamente con Matias y smolenks los bloqueos que mantienen detenidos sus 13 trabajos pendientes.", "Gestionar la entrega y cobro final del único pedido que figura en estado 'listo'.", "Establecer metas diarias de corte y armado para reactivar el flujo de cambios de estado en el taller."]}	gemini-3.8-flash	ok	\N	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-11-02 17:09:31.160493+00
7	2026-10-30 20:53:41.323+00	2026-11-06 20:53:41.323+00	{"periodo": {"desde": "2026-10-30T20:53:41.323Z", "hasta": "2026-11-06T20:53:41.323Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 1, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 6, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 17, "terminado": 6, "en progreso": 1}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}}}	\N	\N	error	Gemini respondió 503: {\n  "error": {\n    "code": 503,\n    "message": "This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.",\n    "status": "UNAVAILABLE"\n  }\n}\n	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-11-06 20:53:45.306219+00
8	2026-10-30 20:55:16.449+00	2026-11-06 20:55:16.449+00	{"periodo": {"desde": "2026-10-30T20:55:16.449Z", "hasta": "2026-11-06T20:55:16.449Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 1, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 6, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 17, "terminado": 6, "en progreso": 1}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}}}	\N	\N	error	Gemini respondió 503: {\n  "error": {\n    "code": 503,\n    "message": "This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.",\n    "status": "UNAVAILABLE"\n  }\n}\n	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-11-06 20:55:19.954214+00
9	2026-10-30 21:00:47.683+00	2026-11-06 21:00:47.683+00	{"periodo": {"desde": "2026-10-30T21:00:47.683Z", "hasta": "2026-11-06T21:00:47.683Z"}, "semana_actual": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 1, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 6, "pedidos_por_estado": {"listo": 1, "pendiente": 6, "en progreso": 1}, "trabajos_por_estado": {"pendiente": 17, "terminado": 6, "en progreso": 1}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "Jean Paul", "terminados": 0, "pendientes_actuales": 1}, {"rol": "Cortadora", "nombre": "Trabajador", "terminados": 0, "pendientes_actuales": 4}, {"rol": "Operaria", "nombre": "Matias", "terminados": 0, "pendientes_actuales": 7}, {"rol": "Cortadora", "nombre": "smolenks", "terminados": 0, "pendientes_actuales": 6}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}}}	\N	\N	error	Gemini respondió 503: {\n  "error": {\n    "code": 503,\n    "message": "This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.",\n    "status": "UNAVAILABLE"\n  }\n}\n	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-11-06 21:00:50.706113+00
10	2026-11-10 23:17:35.592+00	2026-11-17 23:17:35.592+00	{"periodo": {"desde": "2026-11-10T23:17:35.592Z", "hasta": "2026-11-17T23:17:35.592Z"}, "semana_actual": {"pedidos": {"creados": 1, "top_prendas": [{"cantidad": 1, "tipo_prenda": "Polera"}], "monto_estimado": 15000, "abonos_recibidos": 0, "prendas_encargadas": 1}, "clientes": {"con_pedidos": 1, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "jean", "terminados": 0, "pendientes_actuales": 2}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}, "estado_actual": {"pedidos_atrasados": 0, "pedidos_por_estado": {"pendiente": 1}, "trabajos_por_estado": {"pendiente": 2}}}, "semana_anterior": {"pedidos": {"creados": 0, "top_prendas": [], "monto_estimado": 0, "abonos_recibidos": 0, "prendas_encargadas": 0}, "clientes": {"con_pedidos": 0, "recurrentes": 0}, "servicios": {"creados": 0, "top_servicios": [], "monto_estimado": 0, "abonos_recibidos": 0}, "produccion": {"por_trabajadora": [{"rol": "Jefa de taller", "nombre": "jean", "terminados": 0, "pendientes_actuales": 2}], "cambios_de_estado": 0, "trabajos_terminados": {}, "horas_promedio_por_trabajo": {}}}}	\N	\N	error	Gemini respondió 503: {\n  "error": {\n    "code": 503,\n    "message": "This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.",\n    "status": "UNAVAILABLE"\n  }\n}\n	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-11-17 23:17:40.133613+00
\.


--
-- Data for Name: servicio; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.servicio (id_servicio, id_cli, fec_ini, fec_ter, estado_servicio, abono, created_at) FROM stdin;
\.


--
-- Data for Name: trabajo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trabajo (id_trabajo, id_usu, id_detalle, tipo_trabajo, estado, fecha_asignacion, fecha_termino) FROM stdin;
31	13	17	corte	pendiente	2026-11-18 13:08:18.1816+00	\N
32	13	17	armado	pendiente	2026-11-18 13:08:18.403375+00	\N
\.


--
-- Data for Name: trabajo_historial; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trabajo_historial (id_historial, id_trabajo, id_usu, estado_anterior, estado_nuevo, fecha_cambio) FROM stdin;
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuario (id_usu, nom_usuario, ape_usuario, rol_usu, auth_user_id, created_at, correo, password_establecida) FROM stdin;
4	jean	paul	Jefa de taller	7b37fc5f-78f3-47bb-81d3-b6d230ba5184	2026-09-09 18:56:18.735128+00	yeanleyton6@gmail.com	t
11	Smolenks	Aravena	Jefa de taller	ad266a98-359d-402b-8a93-639a1aaef47f	2026-11-17 23:16:10.049172+00	sm.aravena@duocuc.cl	f
12	Carolina	Palma	Jefa de taller	\N	2026-11-18 00:47:33.524802+00	milyunaideasentela@gmail.com	f
13	Matias	Gonzalez	Jefa de taller	8394e6ea-f3b3-4089-bba5-4b5a655426a7	2026-11-18 13:03:28.286984+00	gonzalezpizarrom98@gmail.com	f
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-09-07 14:49:02
20211116045059	2026-09-07 14:49:02
20211116050929	2026-09-07 14:49:02
20211116051442	2026-09-07 14:49:02
20211116212300	2026-09-07 14:49:02
20211116213355	2026-09-07 14:49:02
20211116213934	2026-09-07 14:49:02
20211116214523	2026-09-07 14:49:02
20211122062447	2026-09-07 14:49:02
20211124070109	2026-09-07 14:49:02
20211202204204	2026-09-07 14:49:02
20211202204605	2026-09-07 14:49:02
20211210212804	2026-09-07 14:49:02
20211228014915	2026-09-07 14:49:02
20220107221237	2026-09-07 14:49:02
20220228202821	2026-09-07 14:49:02
20220312004840	2026-09-07 14:49:02
20220603231003	2026-09-07 14:49:02
20220603232444	2026-09-07 14:49:02
20220615214548	2026-09-07 14:49:02
20220712093339	2026-09-07 14:49:02
20220908172859	2026-09-07 14:49:02
20220916233421	2026-09-07 14:49:02
20230119133233	2026-09-07 14:49:02
20230128025114	2026-09-07 14:49:02
20230128025212	2026-09-07 14:49:02
20230227211149	2026-09-07 14:49:02
20230228184745	2026-09-07 14:49:02
20230308225145	2026-09-07 14:49:02
20230328144023	2026-09-07 14:49:02
20231018144023	2026-09-07 14:49:02
20231204144023	2026-09-07 14:49:02
20231204144024	2026-09-07 14:49:02
20231204144025	2026-09-07 14:49:02
20240108234812	2026-09-07 14:49:02
20240109165339	2026-09-07 14:49:02
20240227174441	2026-09-07 14:49:02
20240311171622	2026-09-07 14:49:02
20240321100241	2026-09-07 14:49:02
20240401105812	2026-09-07 14:49:02
20240418121054	2026-09-07 14:49:02
20240523004032	2026-09-07 14:49:02
20240618124746	2026-09-07 14:49:02
20240801235015	2026-09-07 14:49:02
20240805133720	2026-09-07 14:49:02
20240827160934	2026-09-07 14:49:02
20240919163303	2026-09-07 14:49:02
20240919163305	2026-09-07 14:49:02
20241019105805	2026-09-07 14:49:02
20241030150047	2026-09-07 14:49:02
20241108114728	2026-09-07 14:49:02
20241121104152	2026-09-07 14:49:02
20241130184212	2026-09-07 14:49:02
20241220035512	2026-09-07 14:49:02
20241220123912	2026-09-07 14:49:02
20241224161212	2026-09-07 14:49:02
20250107150512	2026-09-07 14:49:02
20250110162412	2026-09-07 14:49:02
20250123174212	2026-09-07 14:49:02
20250128220012	2026-09-07 14:49:02
20250506224012	2026-09-07 14:49:02
20250523164012	2026-09-07 14:49:02
20250714121412	2026-09-07 14:49:02
20250905041441	2026-09-07 14:49:02
20251103001201	2026-09-07 14:49:02
20251120212548	2026-09-07 14:49:02
20251120215549	2026-09-07 14:49:02
20260218120000	2026-09-07 14:49:02
20260326120000	2026-09-07 14:49:02
20260514120000	2026-09-07 14:49:02
20260527120000	2026-09-07 14:49:02
20260528120000	2026-09-07 14:49:02
20260603120000	2026-09-07 14:49:02
20260605120000	2026-09-07 14:49:02
20260606110000	2026-09-07 14:49:02
20260616120000	2026-09-07 14:49:02
20260624120000	2026-09-07 14:49:02
20260626120000	2026-09-07 14:49:02
20260706120000	2026-09-07 14:49:02
20260707120000	2026-09-07 14:49:02
20260709120000	2026-09-07 14:49:02
20260714120000	2026-09-07 14:49:02
20260827120000	2026-09-16 18:50:54
20260914120000	2026-09-27 14:19:01
20260916120000	2026-09-27 14:19:01
20260922120000	2026-09-27 14:19:01
20260925120000	2026-09-30 20:46:56
20260928120000	2026-10-06 12:34:05
20261002120000	2026-10-10 14:16:21
20261008120000	2026-10-28 11:48:10
20261009120000	2026-10-28 11:48:11
20261007120000	2026-11-14 15:27:37
20261022120000	2026-11-14 15:27:38
20261027120000	2026-11-14 15:27:38
20261029120000	2026-11-14 15:27:38
20261103130000	2026-11-14 15:27:39
20261111120000	2026-11-17 22:12:20
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- Data for Name: bucket_lifecycle_states; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.bucket_lifecycle_states (bucket_id, generation, next_run_at, claim_id, claim_until, continuation, last_started_at, last_completed_at, last_success_at, last_result, failure_count, last_error, updated_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type, versioning_status, lifecycle_configuration, lifecycle_configuration_generation) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: lifecycle_abandoned_artifacts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.lifecycle_abandoned_artifacts (bucket_id, key, name, version, attempted_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-09-07 14:49:07.193046
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-09-07 14:49:07.201844
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-09-07 14:49:07.233095
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-09-07 14:49:07.2531
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-09-07 14:49:07.257732
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-09-07 14:49:07.263329
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-09-07 14:49:07.268358
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-09-07 14:49:07.272951
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-09-07 14:49:07.278913
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-09-07 14:49:07.283605
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-09-07 14:49:07.289014
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-09-07 14:49:07.294301
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-09-07 14:49:07.299296
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-09-07 14:49:07.304255
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-09-07 14:49:07.335885
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-09-07 14:49:07.340824
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-09-07 14:49:07.345305
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-09-07 14:49:07.349765
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-09-07 14:49:07.35593
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-09-07 14:49:07.360612
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-09-07 14:49:07.367008
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-09-07 14:49:07.381776
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-09-07 14:49:07.395404
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-09-07 14:49:07.40027
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-09-07 14:49:07.404999
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-09-07 14:49:07.409755
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-09-07 14:49:07.413888
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-09-07 14:49:07.419775
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-09-07 14:49:07.423925
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-09-07 14:49:07.427813
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-09-07 14:49:07.431936
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-09-07 14:49:07.435929
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-09-07 14:49:07.439842
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-09-07 14:49:07.44375
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-09-07 14:49:07.44769
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-09-07 14:49:07.451612
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-09-07 14:49:07.455608
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-09-07 14:49:07.460585
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-09-07 14:49:07.472597
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-09-07 14:49:07.476637
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-09-07 14:49:07.480587
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-09-07 14:49:07.484533
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-09-07 14:49:07.488466
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-09-07 14:49:07.492318
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-09-07 14:49:07.497125
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-09-07 14:49:07.507832
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-09-07 14:49:07.512437
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-09-07 14:49:07.516543
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-09-07 14:49:07.538184
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-09-07 14:49:07.54334
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-09-07 14:49:07.705075
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-09-07 14:49:07.707134
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-09-07 14:49:07.717784
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-09-07 14:49:07.720709
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-09-07 14:49:07.722636
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-09-07 14:49:07.727662
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-09-07 14:49:07.734015
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-09-07 14:49:07.73834
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-09-07 14:49:07.7441
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-09-07 14:49:07.748922
61	mark-filename-immutable	fe0096517ae9d60aaec1d110172ba9036dc66bb7	2026-09-07 14:49:07.753821
63	fix-search-name-relative-to-prefix	c7485e417624f795ce8bb2da21927f48e088904d	2026-09-07 14:49:07.766389
64	fix-search-by-timestamp-sqli	0af424ecd388a39bb1645184b222185a12149675	2026-09-07 14:49:07.772229
66	objects-current-version-index	191466c93aa2c46a00e36505577c5fcab8d7cb4b	2026-09-07 14:49:07.79112
67	objects-null-version-index	15bfe8c35b66642b6c78ba60060fa8793bd2207a	2026-09-07 14:49:07.799076
65	objects-key-version-index	da319c4b89ba800ce795d1b699f3a70675138058	2026-09-07 14:49:07.783358
68	bucket-lifecycle-configuration	3c08f6f889922f399519722a932b51007c11bebc	2026-09-21 18:34:29.77466
69	validate-bucket-lifecycle-constraints	4febacaaaa0e61e2b783bef081fe03a287e65eb3	2026-09-21 18:34:29.822512
70	list-objects-with-versions	5c17c3777616cd8d7b18b82835525fa3205af57b	2026-09-21 18:34:29.828593
71	objects-delete-marker-index	6d14858e66c66f8d6accf8a2630aefd1527fddba	2026-09-21 18:34:29.871071
2	storage-schema	cdc19a79b298ce37cc730487821a1a7b06b98105	2026-09-07 14:49:07.20694
62	object-versioning-core	c6567e688f8c4a76887e7c1b117b2d58f4feccba	2026-09-07 14:49:07.758303
72	drop-bucketid-objname-index	302beb09e1b469d7d4db19566f2389d280b64aa3	2026-09-21 18:34:30.022067
73	revoke-grants-to-unused-operations	ba9244051be09f22f714fc0170a2539f8b5f0e68	2026-10-18 13:03:11.241011
74	unlock-object-versioning	dacb58ecb37678de855505b3e1c5aec0d5df7894	2026-11-02 13:10:08.768513
75	enforce-bucket-lifecycle-update-role	8454a556116c985db857d3b99de94a31a68ad273	2026-11-08 13:34:11.500958
76	noncurrent-lifecycle	052cbe11956fd14b85861fc19537c0303b73010e	2026-11-08 13:34:11.515188
77	noncurrent-lifecycle-archived-order-index	d68b03438a987aa1324a0fca68f7078cb2ffb849	2026-11-08 13:34:11.580115
78	noncurrent-lifecycle-archived-due-index	c82ba0e577ec5c3496b1077ff385ce4645497698	2026-11-08 13:34:11.586448
79	lifecycle-writer-coordination	3b38458424d2099e6b2e3cb4233590060f527fe1	2026-11-08 13:34:11.587885
80	revoke-extra-lifecycle-postgres-grants	18cfbf5c5b356469e1e95f3aa1b59ba111d82a06	2026-11-14 15:27:43.167021
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, archived_at, is_delete_marker, is_versioned) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
d1d55381-9afe-4742-b775-ccc337f88a9f	aviso_entrega_project_url		1eswBPlZC1QILVnDQ8cAFFXAGUE+x405DDuqNSw6p+HK8fh37oQJPJvM/X0EO50phCvcw6wtVQnu\nGoehsgYnV9Np1m7h/757eg==	\N	\\x47fde08f00ec8bb0c1bcb71895e416ce	2026-11-08 13:48:47.595614+00	2026-11-08 13:48:47.595614+00
b7cd52d0-19bb-4d50-8e62-b1481fc47325	aviso_entrega_anon_key		dzpAFRvH5QZ+vtFVh1ZjRyfxxZ/KiZRIWN30877GANUmsX7gI563tfWf3bRT/kQeeXhqI6A3RcfE\n9To+2VCkHVqGHHDyowFq/0qjqzTy	\N	\\xbd9e2c66434b5f086a62a8041b0c48b9	2026-11-08 13:48:47.595614+00	2026-11-08 13:48:47.595614+00
dd4aaf92-df5a-49a2-bbe2-c213d40cd0f8	aviso_entrega_cron_secret		834DhlD7PYkIljqJl++caouZRFDsyBsFlCtIkUXxJkp3+24vnajW6i+R	\N	\\x36083dafcd7e6139eead883a5d3d960b	2026-11-08 13:48:47.595614+00	2026-11-08 13:48:47.595614+00
65746410-3ba1-4698-9d1f-04f2a92ee7ac	CRON_SECRET		oa3ql/TTjPGC71kJBO+E1BdRfDKYkveMM1t3n9Tvh7Rl7sYA0TQ5yhSwOmD9IxnCdh2x2qwr5JwW\njsUUKyurjt2AV8JX6fOWqqbGdotmCUuOYlzmFQIe980AGdplXjx1	\N	\\x907981c6cf1f67e1ff081b2590558db6	2026-11-08 14:55:02.186936+00	2026-11-08 15:08:23.406016+00
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 135, true);


--
-- Name: jobid_seq; Type: SEQUENCE SET; Schema: cron; Owner: -
--

SELECT pg_catalog.setval('cron.jobid_seq', 5, true);


--
-- Name: runid_seq; Type: SEQUENCE SET; Schema: cron; Owner: -
--

SELECT pg_catalog.setval('cron.runid_seq', 26, true);


--
-- Name: categoria_prenda_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categoria_prenda_id_categoria_seq', 14, true);


--
-- Name: cliente_id_cli_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cliente_id_cli_seq', 9, true);


--
-- Name: detalle_pedido_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_pedido_id_detalle_seq', 17, true);


--
-- Name: detalle_servicio_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_servicio_id_detalle_seq', 2, true);


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pedido_id_pedido_seq', 14, true);


--
-- Name: precio_prenda_id_precio_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.precio_prenda_id_precio_seq', 25, true);


--
-- Name: reporte_semanal_id_reporte_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reporte_semanal_id_reporte_seq', 10, true);


--
-- Name: servicio_id_servicio_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servicio_id_servicio_seq', 2, true);


--
-- Name: trabajo_historial_id_historial_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.trabajo_historial_id_historial_seq', 4, true);


--
-- Name: trabajo_id_trabajo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.trabajo_id_trabajo_seq', 32, true);


--
-- Name: usuario_id_usu_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_usu_seq', 13, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_key UNIQUE (mfa_factor_id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_pkey PRIMARY KEY (id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_key UNIQUE (user_id);


--
-- Name: mfa_recovery_codes mfa_recovery_codes_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scim_tokens scim_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_pkey PRIMARY KEY (id);


--
-- Name: scim_users scim_users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: categoria_prenda categoria_prenda_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_prenda
    ADD CONSTRAINT categoria_prenda_nombre_key UNIQUE (nombre);


--
-- Name: categoria_prenda categoria_prenda_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_prenda
    ADD CONSTRAINT categoria_prenda_pkey PRIMARY KEY (id_categoria);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cli);


--
-- Name: detalle_pedido detalle_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_pkey PRIMARY KEY (id_detalle);


--
-- Name: detalle_servicio detalle_servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_servicio
    ADD CONSTRAINT detalle_servicio_pkey PRIMARY KEY (id_detalle);


--
-- Name: pedido pedido_estado_pedido_check; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.pedido
    ADD CONSTRAINT pedido_estado_pedido_check CHECK (((estado_pedido)::text = ANY ((ARRAY['pendiente'::character varying, 'en progreso'::character varying, 'por revisar'::character varying, 'listo'::character varying])::text[]))) NOT VALID;


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id_pedido);


--
-- Name: precio_prenda precio_prenda_categoria_talla_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.precio_prenda
    ADD CONSTRAINT precio_prenda_categoria_talla_key UNIQUE (id_categoria, talla);


--
-- Name: precio_prenda precio_prenda_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.precio_prenda
    ADD CONSTRAINT precio_prenda_pkey PRIMARY KEY (id_precio);


--
-- Name: reporte_semanal reporte_semanal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporte_semanal
    ADD CONSTRAINT reporte_semanal_pkey PRIMARY KEY (id_reporte);


--
-- Name: servicio servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_pkey PRIMARY KEY (id_servicio);


--
-- Name: trabajo trabajo_detalle_usu_tipo_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_detalle_usu_tipo_unique UNIQUE (id_detalle, id_usu, tipo_trabajo);


--
-- Name: trabajo_historial trabajo_historial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo_historial
    ADD CONSTRAINT trabajo_historial_pkey PRIMARY KEY (id_historial);


--
-- Name: trabajo trabajo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_pkey PRIMARY KEY (id_trabajo);


--
-- Name: usuario usuario_auth_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_auth_user_id_key UNIQUE (auth_user_id);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usu);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: bucket_lifecycle_states bucket_lifecycle_states_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.bucket_lifecycle_states
    ADD CONSTRAINT bucket_lifecycle_states_pkey PRIMARY KEY (bucket_id);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: lifecycle_abandoned_artifacts lifecycle_abandoned_artifacts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.lifecycle_abandoned_artifacts
    ADD CONSTRAINT lifecycle_abandoned_artifacts_pkey PRIMARY KEY (bucket_id, key);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: mfa_recovery_codes_set_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_recovery_codes_set_id_idx ON auth.mfa_recovery_codes USING btree (mfa_recovery_code_set_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_link_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_link_token_hash_hash_idx ON auth.one_time_tokens USING hash (link_token_hash);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: scim_tokens_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_tokens_expires_at_idx ON auth.scim_tokens USING btree (expires_at);


--
-- Name: scim_tokens_revoked_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_tokens_revoked_at_idx ON auth.scim_tokens USING btree (revoked_at);


--
-- Name: scim_tokens_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_tokens_sso_provider_id_idx ON auth.scim_tokens USING btree (sso_provider_id);


--
-- Name: scim_tokens_token_hash_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX scim_tokens_token_hash_key ON auth.scim_tokens USING btree (token_hash);


--
-- Name: scim_users_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_created_at_idx ON auth.scim_users USING btree (sso_provider_id, created_at, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_deleted_at_idx ON auth.scim_users USING btree (deleted_at);


--
-- Name: scim_users_external_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX scim_users_external_id_key ON auth.scim_users USING btree (sso_provider_id, external_id) WHERE ((external_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: scim_users_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_id_idx ON auth.scim_users USING btree (sso_provider_id, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_sso_provider_id_idx ON auth.scim_users USING btree (sso_provider_id);


--
-- Name: scim_users_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_updated_at_idx ON auth.scim_users USING btree (sso_provider_id, updated_at, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_user_id_idx ON auth.scim_users USING btree (user_id);


--
-- Name: scim_users_user_name_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_user_name_idx ON auth.scim_users USING btree (sso_provider_id, user_name COLLATE "C", id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_user_name_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX scim_users_user_name_key ON auth.scim_users USING btree (sso_provider_id, user_name) WHERE (deleted_at IS NULL);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_detalle_pedido; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_detalle_pedido ON public.detalle_pedido USING btree (id_pedido);


--
-- Name: idx_pedido_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pedido_cliente ON public.pedido USING btree (id_cli);


--
-- Name: idx_pedido_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pedido_estado ON public.pedido USING btree (estado_pedido);


--
-- Name: idx_trabajo_detalle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trabajo_detalle ON public.trabajo USING btree (id_detalle);


--
-- Name: idx_trabajo_id_detalle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trabajo_id_detalle ON public.trabajo USING btree (id_detalle);


--
-- Name: idx_trabajo_id_usu; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trabajo_id_usu ON public.trabajo USING btree (id_usu);


--
-- Name: idx_trabajo_usuario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trabajo_usuario ON public.trabajo USING btree (id_usu);


--
-- Name: usuario_correo_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX usuario_correo_key ON public.usuario USING btree (lower(correo)) WHERE (correo IS NOT NULL);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_replay_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_replay_index ON ONLY realtime.messages USING btree (topic, inserted_at DESC, COALESCE(expires_at, 'infinity'::timestamp without time zone)) WHERE ((extension = 'broadcast'::text) AND (private = true));


--
-- Name: subscription_subscription_id_entity_filters_hash_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_hash_key ON realtime.subscription USING btree (subscription_id, entity, realtime.filters_hash(filters), action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucket_lifecycle_states_due_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX bucket_lifecycle_states_due_idx ON storage.bucket_lifecycle_states USING btree (next_run_at, bucket_id) WHERE (next_run_at IS NOT NULL);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: idx_objects_current_version; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_objects_current_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (archived_at IS NULL);


--
-- Name: idx_objects_delete_markers; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_delete_markers ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE is_delete_marker;


--
-- Name: idx_objects_null_version; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_objects_null_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (NOT is_versioned);


--
-- Name: lifecycle_abandoned_artifacts_attempted_at_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX lifecycle_abandoned_artifacts_attempted_at_idx ON storage.lifecycle_abandoned_artifacts USING btree (attempted_at);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_archived_due_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX objects_archived_due_idx ON storage.objects USING btree (bucket_id, archived_at, name COLLATE "C") INCLUDE (id, version, is_delete_marker) WHERE (archived_at IS NOT NULL);


--
-- Name: objects_archived_order_uq; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_archived_order_uq ON storage.objects USING btree (bucket_id, name COLLATE "C", archived_at) WHERE (archived_at IS NOT NULL);


--
-- Name: objects_bucket_id_name_version_key; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_name_version_key ON storage.objects USING btree (bucket_id, name COLLATE "C", version) NULLS NOT DISTINCT;


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets enforce_versioning_status_transition; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_versioning_status_transition BEFORE UPDATE OF versioning_status ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_versioning_status_transition();


--
-- Name: buckets protect_active_lifecycle_states; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_active_lifecycle_states BEFORE DELETE ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_active_lifecycle_states();


--
-- Name: buckets protect_bucket_control_insert; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_bucket_control_insert BEFORE INSERT ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns('service_role');


--
-- Name: buckets protect_bucket_control_update; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_bucket_control_update BEFORE UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns();


--
-- Name: buckets protect_bucket_control_update_role; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_bucket_control_update_role AFTER UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_lifecycle_service_role('service_role');


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: buckets wake_lifecycle_on_policy_write; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER wake_lifecycle_on_policy_write AFTER INSERT OR UPDATE OF lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.wake_lifecycle_state();


--
-- Name: buckets wake_lifecycle_on_versioning_enable; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER wake_lifecycle_on_versioning_enable AFTER UPDATE OF versioning_status ON storage.buckets FOR EACH ROW WHEN ((new.lifecycle_configuration IS NOT NULL)) EXECUTE FUNCTION storage.wake_lifecycle_state();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_fkey FOREIGN KEY (mfa_factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_codes mfa_recovery_codes_mfa_recovery_code_set_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_mfa_recovery_code_set_id_fkey FOREIGN KEY (mfa_recovery_code_set_id) REFERENCES auth.mfa_recovery_code_sets(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_tokens scim_tokens_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_users scim_users_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_users scim_users_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: detalle_pedido detalle_pedido_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedido(id_pedido) ON DELETE CASCADE;


--
-- Name: detalle_servicio detalle_servicio_id_servicio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_servicio
    ADD CONSTRAINT detalle_servicio_id_servicio_fkey FOREIGN KEY (id_servicio) REFERENCES public.servicio(id_servicio) ON DELETE CASCADE;


--
-- Name: pedido pedido_id_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_id_cli_fkey FOREIGN KEY (id_cli) REFERENCES public.cliente(id_cli) ON DELETE RESTRICT;


--
-- Name: pedido pedido_id_usu_responsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_id_usu_responsable_fkey FOREIGN KEY (id_usu_responsable) REFERENCES public.usuario(id_usu);


--
-- Name: precio_prenda precio_prenda_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.precio_prenda
    ADD CONSTRAINT precio_prenda_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria_prenda(id_categoria);


--
-- Name: reporte_semanal reporte_semanal_generado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporte_semanal
    ADD CONSTRAINT reporte_semanal_generado_por_fkey FOREIGN KEY (generado_por) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: servicio servicio_id_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_id_cli_fkey FOREIGN KEY (id_cli) REFERENCES public.cliente(id_cli);


--
-- Name: trabajo_historial trabajo_historial_id_trabajo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo_historial
    ADD CONSTRAINT trabajo_historial_id_trabajo_fkey FOREIGN KEY (id_trabajo) REFERENCES public.trabajo(id_trabajo) ON DELETE CASCADE;


--
-- Name: trabajo_historial trabajo_historial_id_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo_historial
    ADD CONSTRAINT trabajo_historial_id_usu_fkey FOREIGN KEY (id_usu) REFERENCES public.usuario(id_usu);


--
-- Name: trabajo trabajo_id_detalle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_id_detalle_fkey FOREIGN KEY (id_detalle) REFERENCES public.detalle_pedido(id_detalle) ON DELETE CASCADE;


--
-- Name: trabajo trabajo_id_usu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trabajo
    ADD CONSTRAINT trabajo_id_usu_fkey FOREIGN KEY (id_usu) REFERENCES public.usuario(id_usu) ON DELETE RESTRICT;


--
-- Name: usuario usuario_auth_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: bucket_lifecycle_states bucket_lifecycle_states_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.bucket_lifecycle_states
    ADD CONSTRAINT bucket_lifecycle_states_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: categoria_prenda Categorias editables por usuarios autenticados; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Categorias editables por usuarios autenticados" ON public.categoria_prenda TO authenticated USING (true) WITH CHECK (true);


--
-- Name: categoria_prenda Categorias visibles para todos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Categorias visibles para todos" ON public.categoria_prenda FOR SELECT USING (true);


--
-- Name: reporte_semanal Jefa de taller lee reportes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Jefa de taller lee reportes" ON public.reporte_semanal FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: cliente Usuarios autenticados pueden actualizar clientes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden actualizar clientes" ON public.cliente FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden actualizar detalle_pedido; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden actualizar detalle_pedido" ON public.detalle_pedido FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: detalle_servicio Usuarios autenticados pueden actualizar detalle_servicio; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden actualizar detalle_servicio" ON public.detalle_servicio FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: pedido Usuarios autenticados pueden actualizar pedidos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden actualizar pedidos" ON public.pedido FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: servicio Usuarios autenticados pueden actualizar servicios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden actualizar servicios" ON public.servicio FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: cliente Usuarios autenticados pueden eliminar clientes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden eliminar clientes" ON public.cliente FOR DELETE TO authenticated USING (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden eliminar detalle_pedido; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden eliminar detalle_pedido" ON public.detalle_pedido FOR DELETE TO authenticated USING (true);


--
-- Name: detalle_servicio Usuarios autenticados pueden eliminar detalle_servicio; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden eliminar detalle_servicio" ON public.detalle_servicio FOR DELETE TO authenticated USING (true);


--
-- Name: pedido Usuarios autenticados pueden eliminar pedidos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden eliminar pedidos" ON public.pedido FOR DELETE TO authenticated USING (true);


--
-- Name: servicio Usuarios autenticados pueden eliminar servicios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden eliminar servicios" ON public.servicio FOR DELETE TO authenticated USING (true);


--
-- Name: cliente Usuarios autenticados pueden insertar clientes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden insertar clientes" ON public.cliente FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden insertar detalle_pedido; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden insertar detalle_pedido" ON public.detalle_pedido FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: detalle_servicio Usuarios autenticados pueden insertar detalle_servicio; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden insertar detalle_servicio" ON public.detalle_servicio FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: pedido Usuarios autenticados pueden insertar pedidos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden insertar pedidos" ON public.pedido FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: servicio Usuarios autenticados pueden insertar servicios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden insertar servicios" ON public.servicio FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: trabajo_historial Usuarios autenticados pueden insertar trabajo_historial; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden insertar trabajo_historial" ON public.trabajo_historial FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: cliente Usuarios autenticados pueden ver clientes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden ver clientes" ON public.cliente FOR SELECT TO authenticated USING (true);


--
-- Name: detalle_pedido Usuarios autenticados pueden ver detalle_pedido; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden ver detalle_pedido" ON public.detalle_pedido FOR SELECT TO authenticated USING (true);


--
-- Name: detalle_servicio Usuarios autenticados pueden ver detalle_servicio; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden ver detalle_servicio" ON public.detalle_servicio FOR SELECT TO authenticated USING (true);


--
-- Name: pedido Usuarios autenticados pueden ver pedidos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden ver pedidos" ON public.pedido FOR SELECT TO authenticated USING (true);


--
-- Name: servicio Usuarios autenticados pueden ver servicios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden ver servicios" ON public.servicio FOR SELECT TO authenticated USING (true);


--
-- Name: trabajo_historial Usuarios autenticados pueden ver trabajo_historial; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Usuarios autenticados pueden ver trabajo_historial" ON public.trabajo_historial FOR SELECT TO authenticated USING (true);


--
-- Name: cliente admin gestiona clientes; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "admin gestiona clientes" ON public.cliente USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: detalle_pedido admin gestiona detalle_pedido; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "admin gestiona detalle_pedido" ON public.detalle_pedido USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: pedido admin gestiona pedidos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "admin gestiona pedidos" ON public.pedido USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: trabajo admin gestiona trabajos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "admin gestiona trabajos" ON public.trabajo USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: usuario admin gestiona usuarios; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "admin gestiona usuarios" ON public.usuario USING (public.es_admin()) WITH CHECK (public.es_admin());


--
-- Name: categoria_prenda; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.categoria_prenda ENABLE ROW LEVEL SECURITY;

--
-- Name: cliente; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.cliente ENABLE ROW LEVEL SECURITY;

--
-- Name: detalle_pedido; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.detalle_pedido ENABLE ROW LEVEL SECURITY;

--
-- Name: detalle_servicio; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.detalle_servicio ENABLE ROW LEVEL SECURITY;

--
-- Name: pedido; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.pedido ENABLE ROW LEVEL SECURITY;

--
-- Name: precio_prenda; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.precio_prenda ENABLE ROW LEVEL SECURITY;

--
-- Name: precio_prenda precio_prenda_select_public; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY precio_prenda_select_public ON public.precio_prenda FOR SELECT TO authenticated, anon USING (true);


--
-- Name: precio_prenda precio_prenda_write_jefa_taller; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY precio_prenda_write_jefa_taller ON public.precio_prenda TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: reporte_semanal; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.reporte_semanal ENABLE ROW LEVEL SECURITY;

--
-- Name: servicio; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.servicio ENABLE ROW LEVEL SECURITY;

--
-- Name: trabajo trabajador actualiza estado de su trabajo; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "trabajador actualiza estado de su trabajo" ON public.trabajo FOR UPDATE USING ((id_usu = public.usuario_actual_id())) WITH CHECK ((id_usu = public.usuario_actual_id()));


--
-- Name: detalle_pedido trabajador ve detalle de sus trabajos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "trabajador ve detalle de sus trabajos" ON public.detalle_pedido FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.id_detalle = detalle_pedido.id_detalle) AND (t.id_usu = public.usuario_actual_id())))));


--
-- Name: pedido trabajador ve pedidos asignados; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "trabajador ve pedidos asignados" ON public.pedido FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.trabajo t
     JOIN public.detalle_pedido dp ON ((dp.id_detalle = t.id_detalle)))
  WHERE ((dp.id_pedido = pedido.id_pedido) AND (t.id_usu = public.usuario_actual_id())))));


--
-- Name: trabajo trabajador ve sus trabajos; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "trabajador ve sus trabajos" ON public.trabajo FOR SELECT USING ((id_usu = public.usuario_actual_id()));


--
-- Name: trabajo; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.trabajo ENABLE ROW LEVEL SECURITY;

--
-- Name: trabajo trabajo_all_jefa; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY trabajo_all_jefa ON public.trabajo USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: trabajo_historial; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.trabajo_historial ENABLE ROW LEVEL SECURITY;

--
-- Name: trabajo trabajo_select_jefa; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY trabajo_select_jefa ON public.trabajo FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.auth_user_id = auth.uid()) AND ((u.rol_usu)::text = 'Jefa de taller'::text)))));


--
-- Name: trabajo trabajo_select_propio; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY trabajo_select_propio ON public.trabajo FOR SELECT USING ((id_usu = ( SELECT u.id_usu
   FROM public.usuario u
  WHERE (u.auth_user_id = auth.uid()))));


--
-- Name: trabajo trabajo_update_propio; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY trabajo_update_propio ON public.trabajo FOR UPDATE USING ((id_usu = ( SELECT u.id_usu
   FROM public.usuario u
  WHERE (u.auth_user_id = auth.uid())))) WITH CHECK ((id_usu = ( SELECT u.id_usu
   FROM public.usuario u
  WHERE (u.auth_user_id = auth.uid()))));


--
-- Name: usuario; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.usuario ENABLE ROW LEVEL SECURITY;

--
-- Name: usuario usuario ve su propio perfil; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "usuario ve su propio perfil" ON public.usuario FOR SELECT USING ((auth_user_id = auth.uid()));


--
-- Name: usuario usuario_delete_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY usuario_delete_authenticated ON public.usuario FOR DELETE TO authenticated USING (true);


--
-- Name: usuario usuario_insert_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY usuario_insert_authenticated ON public.usuario FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: usuario usuario_select_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY usuario_select_authenticated ON public.usuario FOR SELECT TO authenticated USING (true);


--
-- Name: usuario usuario_update_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY usuario_update_authenticated ON public.usuario FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: bucket_lifecycle_states; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.bucket_lifecycle_states ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: lifecycle_abandoned_artifacts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.lifecycle_abandoned_artifacts ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: ensure_rls; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER ensure_rls ON ddl_command_end
         WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
   EXECUTE FUNCTION public.rls_auto_enable();


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict 7rMV5Rtz2mi5LeUhBwq9j7xccWUrTsWoGMi70bx17UkuGIyhI6hc3mi3YH64Gmt

