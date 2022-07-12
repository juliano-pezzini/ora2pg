-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS motion_agenda_consulta_aft_upd ON agenda_consulta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_motion_agenda_consulta_aft_upd() RETURNS trigger AS $BODY$
declare
reg_integracao_p		gerar_int_padrao.reg_integracao;

BEGIN

if (NEW.cd_agendamento_Externo is not null) then
	if	(NEW.nr_atendimento is not null AND OLD.nr_atendimento is null) then
		reg_integracao_p := gerar_int_padrao.gravar_integracao('116', NEW.cd_agendamento_externo, NEW.nm_usuario, reg_integracao_p, 'IE_STATUS=S');
	elsif ((NEW.nr_atendimento is null ) and (NEW.ie_status_agenda in ('I', 'F') and (OLD.ie_status_agenda not in ('I', 'F') ) )) then
		reg_integracao_p := gerar_int_padrao.gravar_integracao('116', NEW.cd_agendamento_externo, NEW.nm_usuario, reg_integracao_p, 'IE_STATUS=N');
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_motion_agenda_consulta_aft_upd() FROM PUBLIC;

CREATE TRIGGER motion_agenda_consulta_aft_upd
	AFTER UPDATE ON agenda_consulta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_motion_agenda_consulta_aft_upd();
