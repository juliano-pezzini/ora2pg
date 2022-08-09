-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_gravar_log_acesso_html ( nm_usuario_p text, ds_maquina_p text, nm_usuario_so_p text, ie_acao_p text, nm_maq_cliente_p text, cd_aplicacao_tasy_p text, nr_sequencia_p INOUT bigint, ie_acao_excesso_p INOUT text, cd_estabelecimento_p bigint DEFAULT NULL, nr_handle_p bigint DEFAULT NULL, ds_mac_address_p text DEFAULT NULL, ds_so_maquina_p text DEFAULT NULL) AS $body$
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

    SELECT * FROM TASY_GRAVAR_LOG_ACESSO(
        nm_usuario_w, ds_maquina_p, nm_usuario_so_p, ie_acao_p, nm_maq_cliente_p, cd_aplicacao_tasy_p, nr_sequencia_p, ie_acao_excesso_p, cd_estabelecimento_p, nr_handle_p, ds_mac_address_p, ds_so_maquina_p
    ) INTO STRICT nr_sequencia_p, ie_acao_excesso_p;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_gravar_log_acesso_html ( nm_usuario_p text, ds_maquina_p text, nm_usuario_so_p text, ie_acao_p text, nm_maq_cliente_p text, cd_aplicacao_tasy_p text, nr_sequencia_p INOUT bigint, ie_acao_excesso_p INOUT text, cd_estabelecimento_p bigint DEFAULT NULL, nr_handle_p bigint DEFAULT NULL, ds_mac_address_p text DEFAULT NULL, ds_so_maquina_p text DEFAULT NULL) FROM PUBLIC;
