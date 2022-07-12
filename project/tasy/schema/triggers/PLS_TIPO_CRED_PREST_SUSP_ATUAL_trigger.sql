-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_tipo_cred_prest_susp_atual ON pls_tipo_cred_prest_susp CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_tipo_cred_prest_susp_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	if (NEW.dt_inicio_suspensao is not null) and (NEW.dt_fim_suspensao is not null) and (fim_dia(NEW.dt_fim_suspensao) < trunc(NEW.dt_inicio_suspensao,'dd')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1205555); --A data final deve ser posterior a data inicial
	end if;

	if (NEW.ie_acao = '2') and (NEW.ds_mensagem is null) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1205558); --E necessario informar uma mensagem para a regra
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_tipo_cred_prest_susp_atual() FROM PUBLIC;

CREATE TRIGGER pls_tipo_cred_prest_susp_atual
	BEFORE INSERT OR UPDATE ON pls_tipo_cred_prest_susp FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_tipo_cred_prest_susp_atual();

