-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ehr_reg_template_update ON ehr_reg_template CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ehr_reg_template_update() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN

if (NEW.NR_SEQ_TEMPLATE	<> OLD.NR_SEQ_TEMPLATE) then

	BEGIN

	delete	FROM ehr_reg_elemento
	where	nr_seq_reg_template	= NEW.nr_sequencia;

	exception
		when others then
		null;
	end;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ehr_reg_template_update() FROM PUBLIC;

CREATE TRIGGER ehr_reg_template_update
	AFTER UPDATE ON ehr_reg_template FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ehr_reg_template_update();
