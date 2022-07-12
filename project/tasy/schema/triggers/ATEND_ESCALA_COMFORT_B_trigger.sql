-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_escala_comfort_b ON escala_comfort_b CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_escala_comfort_b() RETURNS trigger AS $BODY$
declare

BEGIN

NEW.QT_PONTUACAO := 	coalesce(NEW.IE_CONCIENCIA, -1) +1 +
						coalesce(NEW.IE_AGITACAO, -1) +1 +
						coalesce(NEW.IE_VENTILACAO, -1) +1 +
						coalesce(NEW.IE_CHORO, -1) +1 +
						coalesce(NEW.IE_FISICO, -1) +1 +
						coalesce(NEW.IE_TONUS, -1) +1 +
						coalesce(NEW.IE_TENSAO, -1) +1;
						
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_escala_comfort_b() FROM PUBLIC;

CREATE TRIGGER atend_escala_comfort_b
	BEFORE INSERT OR UPDATE ON escala_comfort_b FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_escala_comfort_b();
