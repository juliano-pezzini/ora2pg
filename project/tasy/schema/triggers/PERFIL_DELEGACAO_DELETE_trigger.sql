-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS perfil_delegacao_delete ON perfil_delegacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_perfil_delegacao_delete() RETURNS trigger AS $BODY$
declare
proxy_check_w   varchar(1);

BEGIN

    if (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'N') = 'S') then
        select 	coalesce(max('S'),'N')
        into STRICT    proxy_check_w
        from 	delegacao_logs
        where 	cd_perfil = OLD.cd_perfil
        and 	nm_usuario_proxy = OLD.nm_proxy;

        if (proxy_check_w = 'S') then
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1164206);
        end if;
    end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_perfil_delegacao_delete() FROM PUBLIC;

CREATE TRIGGER perfil_delegacao_delete
	BEFORE DELETE ON perfil_delegacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_perfil_delegacao_delete();
