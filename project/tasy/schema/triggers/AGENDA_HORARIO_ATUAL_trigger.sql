-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_horario_atual ON agenda_horario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_horario_atual() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
dt_final_w	timestamp;
C01 CURSOR FOR
	SELECT	*
	from	agenda_horario
	where	hr_inicial > hr_final;
BEGIN
  BEGIN
BEGIN

delete	from agenda_controle_horario
where	dt_agenda >= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(LOCALTIMESTAMP)
and	cd_agenda	 = NEW.cd_agenda;

for r_c01 in c01 loop
	BEGIN
	dt_final_w	:= to_date(to_char( r_c01.hr_inicial,'dd/mm/yyyy') ||' '|| to_char( r_c01.hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	
	update	agenda_horario
	set	hr_final = dt_final_w
	where	nr_sequencia = r_c01.nr_sequencia;
	end;
end loop;

exception
	when others then
      	dt_atualizacao := LOCALTIMESTAMP;
end;
  END;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_horario_atual() FROM PUBLIC;

CREATE TRIGGER agenda_horario_atual
	BEFORE INSERT OR UPDATE ON agenda_horario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_horario_atual();
