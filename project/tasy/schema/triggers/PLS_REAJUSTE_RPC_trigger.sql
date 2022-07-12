-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_reajuste_rpc ON pls_reajuste CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_reajuste_rpc() RETURNS trigger AS $BODY$
declare
ie_consistir_envio_rpc_w	varchar(1);

BEGIN

select	max(ie_consistir_envio_rpc)
into STRICT	ie_consistir_envio_rpc_w
from	pls_parametros
where	cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento;

if (coalesce(ie_consistir_envio_rpc_w,'N') = 'S') and (NEW.ie_tipo_reajuste = 'C') then
	if (TG_OP = 'UPDATE') then
		if (NEW.ie_status <> OLD.ie_status) and (NEW.ie_status = '2') and (pls_obter_se_rpc_enviado(NEW.dt_aplicacao_reajuste) = 'S') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(360248);
		end if;
	elsif (TG_OP = 'INSERT') and (pls_obter_se_rpc_enviado(NEW.dt_aplicacao_reajuste) = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(360248); --Não é possível gerar reajuste pois já foi realizado o envio do RPC para o período.
	end if;
end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_reajuste_rpc() FROM PUBLIC;

CREATE TRIGGER pls_reajuste_rpc
	BEFORE INSERT OR UPDATE OR DELETE ON pls_reajuste FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_reajuste_rpc();
