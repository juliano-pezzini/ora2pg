-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_compl_assist_atual ON paciente_compl_assist CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_compl_assist_atual() RETURNS trigger AS $BODY$
BEGIN

if (NEW.dt_liberacao is not null) and (OLD.dt_liberacao is null) then
	
	if (NEW.ie_nivel_compl is not null) then
		CALL wl_gerar_finalizar_tarefa('WO','F',NEW.nr_atendimento,NEW.cd_pessoa_fisica,NEW.nm_usuario,null,'N',null,null,null,null,null,null,null,null,null,null,null,NEW.dt_registro,null,null,null,null,null,null,null,NEW.nr_sequencia);
	end if;
	
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_compl_assist_atual() FROM PUBLIC;

CREATE TRIGGER paciente_compl_assist_atual
	AFTER INSERT OR UPDATE ON paciente_compl_assist FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_compl_assist_atual();
