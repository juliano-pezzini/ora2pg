-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ehr_reg_template_delete ON ehr_reg_template CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ehr_reg_template_delete() RETURNS trigger AS $BODY$
declare
qt_reg_w					smallint;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'N')  then
	goto Final;
end if;

<<Final>>
qt_reg_w := 0;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ehr_reg_template_delete() FROM PUBLIC;

CREATE TRIGGER ehr_reg_template_delete
	BEFORE DELETE ON ehr_reg_template FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ehr_reg_template_delete();

