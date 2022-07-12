-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_cron_excessao_atual ON proj_cron_excessao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_cron_excessao_atual() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN
BEGIN
	if (NEW.hr_final is not null) and ((NEW.hr_final <> OLD.hr_final) or (OLD.dt_hr_final is null)) then
		NEW.dt_hr_final := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_final,'dd/mm/yyyy hh24:mi');
	end if;
	if (NEW.hr_inicio is not null) and ((NEW.hr_inicio <> OLD.hr_inicio) or (OLD.dt_hr_inicio is null)) then
		NEW.dt_hr_inicio := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_inicio,'dd/mm/yyyy hh24:mi');
	end if;
	if (NEW.dt_hr_final is not null ) and ((NEW.dt_hr_final <> OLD.dt_hr_final) or (OLD.hr_final is null)) then
		NEW.hr_final := to_char(NEW.dt_hr_final, 'hh24:mi');
	end if;
	if (NEW.dt_hr_inicio is not null ) and ((NEW.dt_hr_inicio <> OLD.dt_hr_inicio) or (OLD.hr_inicio is null)) then
		NEW.hr_inicio := to_char(NEW.dt_hr_inicio, 'hh24:mi');
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
-- REVOKE ALL ON FUNCTION trigger_fct_proj_cron_excessao_atual() FROM PUBLIC;

CREATE TRIGGER proj_cron_excessao_atual
	BEFORE INSERT OR UPDATE ON proj_cron_excessao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_cron_excessao_atual();

