-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_sit_esp_emp_insert_update ON ctb_sit_especial_empresa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_sit_esp_emp_insert_update() RETURNS trigger AS $BODY$
declare

BEGIN

if	((NEW.PR_EVENTO_EMPRESA < 0) or (NEW.PR_EVENTO_EMPRESA > 100)) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1084870);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_sit_esp_emp_insert_update() FROM PUBLIC;

CREATE TRIGGER ctb_sit_esp_emp_insert_update
	BEFORE INSERT OR UPDATE ON ctb_sit_especial_empresa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_sit_esp_emp_insert_update();

