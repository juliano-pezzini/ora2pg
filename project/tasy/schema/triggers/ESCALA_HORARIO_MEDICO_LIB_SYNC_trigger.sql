-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_horario_medico_lib_sync ON escala_horario_medico_lib CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_horario_medico_lib_sync() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN

BEGIN
if (coalesce(OLD.HR_INICIAL_VINC,'X') <> coalesce(NEW.HR_INICIAL_VINC,'X')) then
 if (NEW.HR_INICIAL_VINC is not null) then
  NEW.HR_INICIAL_VINCULO := pkg_date_utils.get_Time(LOCALTIMESTAMP,NEW.HR_INICIAL_VINC);
 else
  NEW.HR_INICIAL_VINCULO := null;
 end if;
elsif (coalesce(OLD.HR_INICIAL_VINCULO,pkg_date_utils.get_Time('')) <> coalesce(NEW.HR_INICIAL_VINCULO,pkg_date_utils.get_Time(''))) then
 NEW.HR_INICIAL_VINC := lpad(pkg_date_utils.extract_field('HOUR',NEW.HR_INICIAL_VINCULO),2,0) || ':' || lpad(pkg_date_utils.extract_field('MINUTE',NEW.HR_INICIAL_VINCULO),2,0);
end if;

if (coalesce(OLD.HR_FINAL_VINC,'X') <> coalesce(NEW.HR_FINAL_VINC,'X')) then
 if (NEW.HR_FINAL_VINC is not null) then
  NEW.HR_FINAL_VINCULO := pkg_date_utils.get_Time(LOCALTIMESTAMP,NEW.HR_FINAL_VINC);
 else
  NEW.HR_FINAL_VINCULO := null;
 end if;
elsif (coalesce(OLD.HR_FINAL_VINCULO,pkg_date_utils.get_Time('')) <> coalesce(NEW.HR_FINAL_VINCULO,pkg_date_utils.get_Time(''))) then
 NEW.HR_FINAL_VINC := lpad(pkg_date_utils.extract_field('HOUR',NEW.HR_FINAL_VINCULO),2,0) || ':' || lpad(pkg_date_utils.extract_field('MINUTE',NEW.HR_FINAL_VINCULO),2,0);
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
-- REVOKE ALL ON FUNCTION trigger_fct_escala_horario_medico_lib_sync() FROM PUBLIC;

CREATE TRIGGER escala_horario_medico_lib_sync
	BEFORE INSERT OR UPDATE ON escala_horario_medico_lib FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_horario_medico_lib_sync();
