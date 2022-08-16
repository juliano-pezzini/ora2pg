-- PROCEDURE: public.psa_subject_insert(usuario)

-- DROP PROCEDURE IF EXISTS public.psa_subject_insert(usuario);

CREATE OR REPLACE PROCEDURE public.psa_subject_insert(
	IN rc_usuario_p usuario)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE

    v_id_subject       subject.id%TYPE;
    v_id_application   application.id%TYPE;
    v_id_client        client.id%TYPE;
    v_id_datasource    datasource.id%TYPE;

BEGIN
    v_id_application := psa_is_configured();
    v_id_client := psa_is_configured_client();
    v_id_datasource := psa_is_configured_datasource();
    IF
        (v_id_application IS NOT NULL AND v_id_application::text <> '') AND (v_id_client IS NOT NULL AND v_id_client::text <> '') AND (v_id_datasource IS NOT NULL AND v_id_datasource::text <> '')
    THEN
        /* Generate the relative subject */

        INSERT INTO subject(
            id,
            dt_creation,
            dt_modification,
            ds_email,
            ds_login,
            nm_subject,
            ds_password,
            ds_salt,
            dt_password_modification,
            vl_auth_type,
            ds_alternative_login,
            ds_ad_server,
            ds_ad_domain,
            ds_user_f2a_secret,
            vl_user_f2a_status,
            cd_barcode,
			cd_establishment
        ) VALUES (
            psa_uuid_generator(),
            rc_usuario_p.dt_atualizacao,
            rc_usuario_p.dt_atualizacao,
            psa_email_from_tasy_user_email(rc_usuario_p.ds_email),
            rc_usuario_p.nm_usuario,
            rc_usuario_p.ds_usuario,
            coalesce(rc_usuario_p.ds_senha,'*'),
            rc_usuario_p.ds_tec,
            coalesce(rc_usuario_p.dt_alteracao_senha,rc_usuario_p.dt_atualizacao),
            least(coalesce(obter_valor_param_usuario(0,87,0,rc_usuario_p.nm_usuario,rc_usuario_p.cd_estabelecimento) - 1,0),999),
            rc_usuario_p.ds_login,
            obter_valor_param_usuario(0,104,0,rc_usuario_p.nm_usuario,rc_usuario_p.cd_estabelecimento),
            obter_valor_param_usuario(0,116,0,rc_usuario_p.nm_usuario,rc_usuario_p.cd_estabelecimento),
            rc_usuario_p.user_2fa_secret,
            rc_usuario_p.user_2fa_status,
            rc_usuario_p.cd_barras,
            rc_usuario_p.cd_estabelecimento
        ) RETURNING id INTO v_id_subject;

        /* Links the subject to the application */

        INSERT INTO application_subject(
            id_application,
            id_subject
        ) VALUES (
            v_id_application,
            v_id_subject
        );

        /* Links the subject to the datasource */

        INSERT INTO subject_datasource(
            id,
            dt_creation,
            dt_modification,
            id_subject,
            id_datasource,
            vl_activation_status,
            vl_attempts_so_far
        ) VALUES (
            psa_uuid_generator(),
            clock_timestamp(),
            clock_timestamp(),
            v_id_subject,
            v_id_datasource,
            coalesce(CASE WHEN rc_usuario_p.ie_situacao='A' THEN 0 WHEN rc_usuario_p.ie_situacao='I' THEN 1 WHEN rc_usuario_p.ie_situacao='B' THEN 2 END ,0),
            coalesce(rc_usuario_p.qt_acesso_invalido,0)
        );

        /* Links the subject to the client */

        INSERT INTO subject_client(
            id,
            id_subject,
            id_client,
            dt_creation,
            dt_modification,
            vl_activation_status,
            vl_attempts_so_far
        ) VALUES (
            psa_uuid_generator(),
            v_id_subject,
            v_id_client,
            clock_timestamp(),
            clock_timestamp(),
            coalesce(CASE WHEN rc_usuario_p.ie_situacao='A' THEN 0 WHEN rc_usuario_p.ie_situacao='I' THEN 1 WHEN rc_usuario_p.ie_situacao='B' THEN 2 END ,0),
            coalesce(rc_usuario_p.qt_acesso_invalido,0)
        );

    END IF;

END;
$BODY$;
ALTER PROCEDURE public.psa_subject_insert(usuario)
    OWNER TO postgres;

