-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS material_rotina_atual ON material_rotina CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_material_rotina_atual() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN
BEGIN
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
-- REVOKE ALL ON FUNCTION trigger_fct_material_rotina_atual() FROM PUBLIC;

CREATE TRIGGER material_rotina_atual
	BEFORE INSERT OR UPDATE ON material_rotina FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_material_rotina_atual();

