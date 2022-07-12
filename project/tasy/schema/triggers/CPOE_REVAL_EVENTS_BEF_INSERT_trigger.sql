-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_reval_events_bef_insert ON cpoe_revalidation_events CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_reval_events_bef_insert() RETURNS trigger AS $BODY$
declare

BEGIN

	NEW.ds_stack := substr(dbms_utility.format_call_stack, 1, 3000);

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_reval_events_bef_insert() FROM PUBLIC;

CREATE TRIGGER cpoe_reval_events_bef_insert
	BEFORE INSERT ON cpoe_revalidation_events FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_reval_events_bef_insert();
