-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_asis_atual ON escala_asis CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_asis_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
	BEGIN
	NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
	end;
end if;



RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_asis_atual() FROM PUBLIC;

CREATE TRIGGER escala_asis_atual
	BEFORE INSERT OR UPDATE ON escala_asis FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_asis_atual();

