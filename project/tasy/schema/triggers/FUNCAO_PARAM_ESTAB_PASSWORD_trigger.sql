-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS funcao_param_estab_password ON funcao_param_estab CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_funcao_param_estab_password() RETURNS trigger AS $BODY$
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	if (NEW.cd_funcao = 6001 and NEW.nr_seq_param = 31 and NEW.vl_parametro < 8) then

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1206521);

	end if;

end if;
	
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_funcao_param_estab_password() FROM PUBLIC;

CREATE TRIGGER funcao_param_estab_password
	BEFORE INSERT OR UPDATE ON funcao_param_estab FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_funcao_param_estab_password();
