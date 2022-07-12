-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atual_regra_prescr_proc ON regra_prescr_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atual_regra_prescr_proc() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (NEW.hr_inicio is not null) and 
  ((NEW.hr_inicio <> OLD.hr_inicio) or (NEW.dt_inicial <> OLD.dt_inicial)) then  
	NEW.dt_inicial := to_date(to_char(coalesce(NEW.dt_inicial,LOCALTIMESTAMP),'dd/mm/yyyy') || ' ' || NEW.hr_inicio || ':00', 'dd/mm/yyyy hh24:mi:ss');
end if;
 
if (NEW.hr_final is not null) and 
  ((NEW.hr_final <> OLD.hr_final) or (NEW.dt_final <> OLD.dt_final)) then 
	NEW.dt_final := to_date(to_char(coalesce(NEW.dt_final,LOCALTIMESTAMP),'dd/mm/yyyy') || ' ' || NEW.hr_final || ':00', 'dd/mm/yyyy hh24:mi:ss');
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atual_regra_prescr_proc() FROM PUBLIC;

CREATE TRIGGER atual_regra_prescr_proc
	BEFORE INSERT OR UPDATE ON regra_prescr_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atual_regra_prescr_proc();
