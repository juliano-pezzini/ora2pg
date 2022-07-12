-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_dialise_insert_update ON cpoe_dialise CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_dialise_insert_update() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	if (NEW.hr_inicio_capd is not null) and ((NEW.hr_inicio_capd <> OLD.hr_inicio_capd) or (OLD.dt_inicio_capd is null)) then	
		NEW.dt_inicio_capd := to_date(to_char(coalesce(NEW.dt_inicio, LOCALTIMESTAMP),'dd/mm/yyyy') || ' ' || NEW.hr_inicio_capd,'dd/mm/yyyy hh24:mi');
	end if;
	if (NEW.hr_fim_capd is not null) and ((NEW.hr_fim_capd <> OLD.hr_fim_capd) or (OLD.dt_fim_capd is null)) then	
		NEW.dt_fim_capd := to_date(to_char(coalesce(NEW.dt_fim, LOCALTIMESTAMP),'dd/mm/yyyy') || ' ' || NEW.hr_fim_capd,'dd/mm/yyyy hh24:mi');
	end if;	
	
	if (NEW.nr_cirurgia is not null) and (NEW.ie_tipo_prescr_cirur is null) then
		NEW.ie_tipo_prescr_cirur := 2;
	end if;

	if (trim(both NEW.qt_tempo_infusao) = ':') then
		NEW.qt_tempo_infusao := null;
	end if;

	if (trim(both NEW.qt_tempo_permanencia) = ':') then
		NEW.qt_tempo_permanencia := null;
	end if;

	if (trim(both NEW.qt_tempo_drenagem) = ':') then
		NEW.qt_tempo_drenagem := null;
	end if;

	if (trim(both NEW.qt_hora_min_duracao) = ':') then
		NEW.qt_hora_min_duracao := null;
	end if;

	CALL generate_task_needs_ack(NEW.nr_atendimento, NEW.cd_pessoa_fisica, NEW.nr_sequencia, 'D', NEW.dt_liberacao, NEW.dt_liberacao_farm, OLD.dt_liberacao_farm, NEW.dt_inicio);	
end if;
exception
	when others then
	null;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_dialise_insert_update() FROM PUBLIC;

CREATE TRIGGER cpoe_dialise_insert_update
	BEFORE INSERT OR UPDATE ON cpoe_dialise FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_dialise_insert_update();
