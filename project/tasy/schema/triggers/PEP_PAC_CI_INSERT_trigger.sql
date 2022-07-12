-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pep_pac_ci_insert ON pep_pac_ci CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pep_pac_ci_insert() RETURNS trigger AS $BODY$
declare

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'S') then

	if (NEW.cd_pessoa_fisica is null) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(189913);
	end if;	

end if;

if (TG_OP = 'INSERT') then
	NEW.ie_status := 'P';
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pep_pac_ci_insert() FROM PUBLIC;

CREATE TRIGGER pep_pac_ci_insert
	BEFORE INSERT OR UPDATE ON pep_pac_ci FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pep_pac_ci_insert();

