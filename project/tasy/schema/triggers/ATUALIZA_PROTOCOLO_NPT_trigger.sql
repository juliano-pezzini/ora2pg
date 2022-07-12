-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atualiza_protocolo_npt ON protocolo_npt CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atualiza_protocolo_npt() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.hr_inicio_capd is not null) and (NEW.hr_inicio_capd <> ':') and
   ((NEW.hr_inicio_capd <> OLD.hr_inicio_capd) or (OLD.dt_inicio_capd is null)) then
	NEW.dt_inicio_capd := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_inicio_capd || ':00', 'dd/mm/yyyy hh24:mi:ss');
end if;

if (NEW.hr_fim_capd is not null) and (NEW.hr_fim_capd <> ':') and
   ((NEW.hr_fim_capd <> OLD.hr_fim_capd) or (OLD.dt_fim_capd is null)) then
	NEW.dt_fim_capd := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_fim_capd || ':00', 'dd/mm/yyyy hh24:mi:ss');
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atualiza_protocolo_npt() FROM PUBLIC;

CREATE TRIGGER atualiza_protocolo_npt
	BEFORE INSERT OR UPDATE ON protocolo_npt FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atualiza_protocolo_npt();

