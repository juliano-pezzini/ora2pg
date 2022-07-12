-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_glic_delete ON cpoe_proc_glic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_glic_delete() RETURNS trigger AS $BODY$
declare
	ds_log_cpoe_w	varchar(2000);
	
	pragma autonomous_transaction;
BEGIN
  BEGIN
	ds_log_cpoe_w := substr('CPOE_GLIC_DELETE nr_sequencia: ' || OLD.nr_sequencia || ' nr_seq_procedimento: ' || OLD.nr_seq_procedimento ||
		' nr_seq_proc_edit: ' || OLD.nr_seq_proc_edit || ' nr_atendimento: ' || OLD.nr_atendimento || ' nr_seq_protocolo: ' || OLD.nr_seq_protocolo  ,1,2000);

	CALL gravar_log_cpoe(ds_log_cpoe_w, OLD.nr_atendimento, null, null);

	commit;
exception
when others then
	null;
  END;
RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_glic_delete() FROM PUBLIC;

CREATE TRIGGER cpoe_glic_delete
	BEFORE DELETE ON cpoe_proc_glic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_glic_delete();
