-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS exame_lab_pseudo_update ON exame_lab_pseudo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_exame_lab_pseudo_update() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ds_pseudo_loc	is null) or (NEW.ds_pseudo <> OLD.ds_pseudo )	then
	NEW.ds_pseudo_loc	:= upper(elimina_acentuacao(NEW.ds_pseudo));

end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_exame_lab_pseudo_update() FROM PUBLIC;

CREATE TRIGGER exame_lab_pseudo_update
	BEFORE INSERT OR UPDATE ON exame_lab_pseudo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_exame_lab_pseudo_update();

