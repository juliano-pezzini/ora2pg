-- PROCEDURE: public.psa_subject_update(text, usuario, boolean)

-- DROP PROCEDURE IF EXISTS public.psa_subject_update(text, usuario, boolean);

CREATE OR REPLACE PROCEDURE public.psa_subject_update(
	IN nm_usuario_p text,
	IN rc_usuario_p usuario,
	IN p_alterou_senha boolean)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE

    v_id_application         application.id%TYPE;
    v_id_datasource          datasource.id%TYPE;
    v_id_subject             subject.id%TYPE;
    v_id_client              client.id%TYPE;
    v_id_application_check   application.id%TYPE;
    v_id_datasource_check    datasource.id%TYPE;
    v_id_client_check        client.id%TYPE;
    v_alterou_senha          bigint;
    v_id_password_style      subject.vl_password_style%TYPE;
    v_id_tp_consistencia     bigint;

BEGIN
    v_id_application := psa_is_configured();
    v_id_datasource := psa_is_configured_datasource();
    v_id_client := psa_is_configured_client();
    IF
        (v_id_application IS NOT NULL AND v_id_application::text <> '') AND (v_id_client IS NOT NULL AND v_id_client::text <> '') AND (v_id_datasource IS NOT NULL AND v_id_datasource::text <> '')
    THEN
        v_id_tp_consistencia := OBTER_VALOR_PARAM_USUARIO(6001,29,coalesce(wheb_usuario_pck.get_cd_perfil(),0),nm_usuario_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento(),0));
        v_id_password_style := 0;

        IF
            p_alterou_senha
        THEN
            v_alterou_senha := 1;
            IF (v_id_tp_consistencia = 5)
            THEN
                  v_id_password_style := 1;
            END IF;
        ELSE
            v_alterou_senha := 0;
        END IF;
        UPDATE subject
        SET
            dt_creation = rc_usuario_p.dt_atualizacao,
            dt_modification = rc_usuario_p.dt_atualizacao,
            ds_email = psa_email_from_tasy_user_email(rc_usuario_p.ds_email),
            ds_login = rc_usuario_p.nm_usuario,
            nm_subject = rc_usuario_p.ds_usuario,
            ds_password = coalesce(rc_usuario_p.ds_senha,'*'), /* Active Directory - Tasy password could be null */
            ds_salt = rc_usuario_p.ds_tec,
            dt_password_modification = coalesce(rc_usuario_p.dt_alteracao_senha,rc_usuario_p.dt_atualizacao),
            vl_auth_type = least(coalesce(obter_valor_param_usuario(0,87,0,rc_usuario_p.nm_usuario,rc_usuario_p.cd_estabelecimento)::integer - 1,0),999),
            ds_alternative_login = rc_usuario_p.ds_login,
            vl_password_style =
                CASE v_alterou_senha
                    WHEN 1   THEN v_id_password_style
                    ELSE vl_password_style
                END,
            ds_ad_server = obter_valor_param_usuario(0,104,0,rc_usuario_p.nm_usuario,rc_usuario_p.cd_estabelecimento),
            ds_ad_domain = obter_valor_param_usuario(0,116,0,rc_usuario_p.nm_usuario,rc_usuario_p.cd_estabelecimento),
            ds_user_f2a_secret = rc_usuario_p.user_2fa_secret,
            vl_user_f2a_status = rc_usuario_p.user_2fa_status,
            cd_barcode = rc_usuario_p.cd_barras,
            cd_establishment = rc_usuario_p.cd_estabelecimento
        WHERE
            ds_login = nm_usuario_p
        RETURNING id into v_id_subject;
        

        SELECT
            MAX(id_application)
        INTO STRICT v_id_application_check
        FROM
            application_subject sd
        WHERE
            id_subject = v_id_subject
            AND id_application = v_id_application;

        IF
            coalesce(v_id_application_check::text, '') = '' AND (v_id_subject IS NOT NULL AND v_id_subject::text <> '')
        THEN
            INSERT INTO application_subject(
                id_application,
                id_subject
            ) VALUES (
                v_id_application,
                v_id_subject
            );

        END IF;

        SELECT
            MAX(id_datasource)
        INTO STRICT v_id_datasource_check
        FROM
            subject_datasource sd
        WHERE
            id_subject = v_id_subject
            AND id_datasource = v_id_datasource;

        IF
            coalesce(v_id_datasource_check::text, '') = '' AND (v_id_subject IS NOT NULL AND v_id_subject::text <> '')
        THEN
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

        ELSE
            UPDATE subject_datasource
            SET
                vl_activation_status = coalesce(CASE WHEN rc_usuario_p.ie_situacao='A' THEN 0 WHEN rc_usuario_p.ie_situacao='I' THEN 1 WHEN rc_usuario_p.ie_situacao='B' THEN 2 END ,0),
                vl_attempts_so_far = coalesce(rc_usuario_p.qt_acesso_invalido,0)
            WHERE
                id_subject = v_id_subject
                AND id_datasource = v_id_datasource;

        END IF;

        SELECT
            MAX(id)
        INTO STRICT v_id_client_check
        FROM
            subject_client sc
        WHERE
            id_subject = v_id_subject
            AND id_client = v_id_client;

        IF
            coalesce(v_id_client_check::text, '') = '' AND (v_id_subject IS NOT NULL AND v_id_subject::text <> '')
        THEN
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

        ELSE
            UPDATE subject_client
            SET
                vl_activation_status = coalesce(CASE WHEN rc_usuario_p.ie_situacao='A' THEN 0 WHEN rc_usuario_p.ie_situacao='I' THEN 1 WHEN rc_usuario_p.ie_situacao='B' THEN 2 END ,0),
                vl_attempts_so_far = coalesce(rc_usuario_p.qt_acesso_invalido,0)
            WHERE
                id_subject = v_id_subject
                AND id_client = v_id_client;

        END IF;

    END IF;

END;
$BODY$;
ALTER PROCEDURE public.psa_subject_update(text, usuario, boolean)
    OWNER TO postgres;

