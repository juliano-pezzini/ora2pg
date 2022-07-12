-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ate_pac_insert_case ON atendimento_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ate_pac_insert_case() RETURNS trigger AS $BODY$
declare

cd_medico_resp_w	atendimento_paciente.cd_medico_resp%type;

BEGIN

if (NEW.cd_medico_resp is null)  then
	if (NEW.cd_medico_referido is not null) then
		NEW.cd_medico_resp := NEW.cd_medico_referido;
	else

		select	max(cd_pessoa_fisica)
		into STRICT	cd_medico_resp_w
		from	usuario
		where   nm_usuario = NEW.nm_usuario
		and	obter_se_medico(cd_pessoa_fisica,'M') = 'S';

		if (cd_medico_resp_w is null) then
			select	min(cd_pessoa_fisica)
			into STRICT	cd_medico_resp_w
			from	medico
			where	ie_situacao = 'A';
		end if;

		NEW.cd_medico_resp := cd_medico_resp_w;
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ate_pac_insert_case() FROM PUBLIC;

CREATE TRIGGER ate_pac_insert_case
	BEFORE INSERT ON atendimento_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ate_pac_insert_case();
