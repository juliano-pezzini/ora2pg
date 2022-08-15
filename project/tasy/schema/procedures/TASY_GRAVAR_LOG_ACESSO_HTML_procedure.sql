-- PROCEDURE: public.tasy_gravar_log_acesso_html(text, text, text, text, text, text, bigint, text, bigint, bigint, text, text)

-- DROP PROCEDURE IF EXISTS public.tasy_gravar_log_acesso_html(text, text, text, text, text, text, bigint, text, bigint, bigint, text, text);

CREATE OR REPLACE PROCEDURE public.tasy_gravar_log_acesso_html(
	IN nm_usuario_p text,
	IN ds_maquina_p text,
	IN nm_usuario_so_p text,
	IN ie_acao_p text,
	IN nm_maq_cliente_p text,
	IN cd_aplicacao_tasy_p text,
	INOUT nr_sequencia_p bigint,
	INOUT ie_acao_excesso_p text,
	IN cd_estabelecimento_p bigint DEFAULT NULL::bigint,
	IN nr_handle_p bigint DEFAULT NULL::bigint,
	IN ds_mac_address_p text DEFAULT NULL::text,
	IN ds_so_maquina_p text DEFAULT NULL::text)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE

nm_usuario_w usuario.nm_usuario%TYPE;

BEGIN
    SELECT MAX(nm_usuario)
    INTO STRICT nm_usuario_w
    FROM usuario
    WHERE UPPER(nm_usuario) = UPPER(nm_usuario_p);

    IF (coalesce(nm_usuario_w::text, '') = '') THEN
        SELECT MAX(nm_usuario)
        INTO STRICT nm_usuario_w
        FROM usuario
        WHERE UPPER(ds_login) = UPPER(nm_usuario_p);

        IF (coalesce(nm_usuario_w::text, '') = '') THEN
          nm_usuario_w := SUBSTR(nm_usuario_p, 0, 15);
        END IF;
    END IF;

    CALL TASY_GRAVAR_LOG_ACESSO(
        nm_usuario_w, ds_maquina_p, nm_usuario_so_p, ie_acao_p, nm_maq_cliente_p, cd_aplicacao_tasy_p, nr_sequencia_p, ie_acao_excesso_p, cd_estabelecimento_p, nr_handle_p, ds_mac_address_p, ds_so_maquina_p
    );
END;
$BODY$;
ALTER PROCEDURE public.tasy_gravar_log_acesso_html(text, text, text, text, text, text, bigint, text, bigint, bigint, text, text)
    OWNER TO postgres;

