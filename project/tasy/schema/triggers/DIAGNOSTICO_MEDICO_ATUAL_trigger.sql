-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_medico_atual ON diagnostico_medico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_medico_atual() RETURNS trigger AS $BODY$
declare
ie_tipo_atendimento_w	smallint;
qt_reg_w	smallint;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

if (coalesce(OLD.DT_DIAGNOSTICO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_DIAGNOSTICO) and (NEW.DT_DIAGNOSTICO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_DIAGNOSTICO, 'HV');	
end if;

if (NEW.ie_tipo_atendimento is null) then

	/* obter tipo atendimento atual atend */


	select	MAX(ie_tipo_atendimento)
	into STRICT	ie_tipo_atendimento_w
	from	atendimento_paciente
	where	nr_atendimento = NEW.nr_atendimento;
	
	/* gerar tipo atendimento diag */


	NEW.ie_tipo_atendimento := ie_tipo_atendimento_w;
	
end if;
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_medico_atual() FROM PUBLIC;

CREATE TRIGGER diagnostico_medico_atual
	BEFORE INSERT OR UPDATE ON diagnostico_medico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_medico_atual();

