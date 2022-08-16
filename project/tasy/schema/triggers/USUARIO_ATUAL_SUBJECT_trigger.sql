-- FUNCTION: public.trigger_fct_usuario_atual_subject()

-- DROP FUNCTION IF EXISTS public.trigger_fct_usuario_atual_subject();

CREATE OR REPLACE FUNCTION public.trigger_fct_usuario_atual_subject()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF SECURITY DEFINER
AS $BODY$
DECLARE
    rc_usuario         usuario%rowtype;
    v_id_application   application.id%TYPE;
    v_id_datasource    datasource.id%TYPE;
    v_id_client        client.id%TYPE;
BEGIN
    v_id_application := psa_is_configured();
    v_id_datasource := psa_is_configured_datasource();
    v_id_client := psa_is_configured_client();
    IF
        v_id_application IS NOT NULL AND v_id_client IS NOT NULL AND v_id_datasource IS NOT NULL
    THEN
        IF
            TG_OP = 'INSERT' OR TG_OP = 'UPDATE'
        THEN
            rc_usuario.dt_atualizacao :=NEW.dt_atualizacao;
            rc_usuario.ds_email :=NEW.ds_email;
            rc_usuario.nm_usuario :=NEW.nm_usuario;
            rc_usuario.ds_usuario :=NEW.ds_usuario;
            rc_usuario.ds_senha :=NEW.ds_senha;
            rc_usuario.ds_tec :=NEW.ds_tec;
            rc_usuario.ds_login :=NEW.ds_login;
            rc_usuario.dt_alteracao_senha :=NEW.dt_alteracao_senha;
            rc_usuario.cd_estabelecimento :=NEW.cd_estabelecimento;
            rc_usuario.ie_situacao :=NEW.ie_situacao;
            rc_usuario.qt_acesso_invalido :=NEW.qt_acesso_invalido;
            rc_usuario.user_2fa_secret :=NEW.user_2fa_secret;
            rc_usuario.user_2fa_status :=NEW.user_2fa_status;
            rc_usuario.cd_barras :=NEW.cd_barras;
            IF
                TG_OP = 'INSERT'
            THEN
                CALL psa_subject_insert(rc_usuario);
            ELSE
                CALL psa_subject_update(OLD.nm_usuario,rc_usuario,NEW.ds_senha <>OLD.ds_senha);
            END IF;

        ELSE
            CALL psa_subject_delete(OLD.nm_usuario);
        END IF;
    END IF;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$;

ALTER FUNCTION public.trigger_fct_usuario_atual_subject()
    OWNER TO postgres;

