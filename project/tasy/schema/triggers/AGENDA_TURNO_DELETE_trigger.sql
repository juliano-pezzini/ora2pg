-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_turno_delete ON agenda_turno CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_turno_delete() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
BEGIN
  BEGIN
BEGIN

delete	from agenda_controle_horario
where	dt_agenda >= trunc(LOCALTIMESTAMP)
and	cd_agenda	 = OLD.cd_agenda;

exception
	when others then
      	dt_atualizacao := LOCALTIMESTAMP;
end;
  END;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_turno_delete() FROM PUBLIC;

CREATE TRIGGER agenda_turno_delete
	BEFORE DELETE ON agenda_turno FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_turno_delete();

