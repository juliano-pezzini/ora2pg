-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_log_alt_status_atual ON agenda_log_alt_status CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_log_alt_status_atual() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (OLD.ds_stack is not null) then 
	NEW.ds_stack := substr(obter_desc_expressao(645952)||': '||OLD.ds_stack||obter_desc_expressao(487898)||': '||dbms_utility.format_call_stack,1,4000);
else 
	NEW.ds_stack := substr(dbms_utility.format_call_stack,1,4000);
end if;
	 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_log_alt_status_atual() FROM PUBLIC;

CREATE TRIGGER agenda_log_alt_status_atual
	BEFORE INSERT OR UPDATE ON agenda_log_alt_status FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_log_alt_status_atual();

