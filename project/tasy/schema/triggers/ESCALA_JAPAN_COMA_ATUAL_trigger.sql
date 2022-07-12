-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_japan_coma_atual ON escala_japan_coma CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_japan_coma_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then

	NEW.qt_score :=  coalesce(NEW.IE_DIGIT_GRADE_1,0)  +  coalesce(NEW.IE_DIGIT_GRADE_2,0) +  coalesce(NEW.IE_DIGIT_GRADE_3,0);

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_japan_coma_atual() FROM PUBLIC;

CREATE TRIGGER escala_japan_coma_atual
	BEFORE INSERT OR UPDATE ON escala_japan_coma FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_japan_coma_atual();

