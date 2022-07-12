-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atual_regra_indic_cli_obrig ON regra_indic_clinica_obrig CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atual_regra_indic_cli_obrig() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.hr_prev_inicial is not null) and
   ((NEW.hr_prev_inicial <> OLD.hr_prev_inicial) or (OLD.dt_prev_inicial is null)) then
	NEW.dt_prev_inicial := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_prev_inicial || ':00', 'dd/mm/yyyy hh24:mi:ss');
end if;

if (NEW.hr_prev_final is not null) and
   ((NEW.hr_prev_final <> OLD.hr_prev_final) or (OLD.dt_prev_final is null)) then
	NEW.dt_prev_final := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_prev_final || ':00', 'dd/mm/yyyy hh24:mi:ss');
end if;

if (NEW.cd_procedimento is null or NEW.cd_procedimento = '') then
	NEW.ie_origem_proced := null;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atual_regra_indic_cli_obrig() FROM PUBLIC;

CREATE TRIGGER atual_regra_indic_cli_obrig
	BEFORE INSERT OR UPDATE ON regra_indic_clinica_obrig FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atual_regra_indic_cli_obrig();

