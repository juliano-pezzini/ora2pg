-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_tratamento_after_upd ON paciente_tratamento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_tratamento_after_upd() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.dt_final_tratamento is not null) and (OLD.dt_final_tratamento is null) then

	update	hd_protocolo_exame
	set		dt_fim 				= LOCALTIMESTAMP
	where	cd_pessoa_fisica 	= NEW.cd_pessoa_fisica
	and		dt_fim is null
	and		ie_tratamento 		= NEW.ie_tratamento;

	update 	hd_pac_renal_cronico
	set		ie_situacao = 'N'
	where 	cd_pessoa_fisica = NEW.cd_pessoa_fisica;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_tratamento_after_upd() FROM PUBLIC;

CREATE TRIGGER paciente_tratamento_after_upd
	AFTER UPDATE ON paciente_tratamento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_tratamento_after_upd();
