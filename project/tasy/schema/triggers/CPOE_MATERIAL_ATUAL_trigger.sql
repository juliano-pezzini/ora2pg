-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_material_atual ON cpoe_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_material_atual() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN
BEGIN
    if (NEW.hr_min_aplicacao is not null) and ((NEW.hr_min_aplicacao <> OLD.hr_min_aplicacao) or (OLD.dt_min_aplicacao is null)) then
		NEW.dt_min_aplicacao := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_min_aplicacao,'dd/mm/yyyy hh24:mi');
	end if;
    if (NEW.hr_min_aplic_adic is not null) and ((NEW.hr_min_aplic_adic <> OLD.hr_min_aplic_adic) or (OLD.dt_min_aplic_adic is null)) then
		NEW.dt_min_aplic_adic := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_min_aplic_adic,'dd/mm/yyyy hh24:mi');
	end if;
	if (NEW.hr_min_aplic_ataque is not null) and ((NEW.hr_min_aplic_ataque <> OLD.hr_min_aplic_ataque) or (OLD.dt_min_aplic_ataque is null)) then
		NEW.dt_min_aplic_ataque := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_min_aplic_ataque,'dd/mm/yyyy hh24:mi');
	end if;
    if (NEW.hr_prim_horario is not null) and ((NEW.hr_prim_horario <> OLD.hr_prim_horario) or (OLD.dt_prim_horario is null)) then
		NEW.dt_prim_horario := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_prim_horario,'dd/mm/yyyy hh24:mi');
	end if;
exception
	when others then
	null;
end;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_material_atual() FROM PUBLIC;

CREATE TRIGGER cpoe_material_atual
	BEFORE INSERT OR UPDATE ON cpoe_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_material_atual();
