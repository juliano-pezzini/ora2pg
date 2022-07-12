-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_dialise_bef_delete ON cpoe_dialise CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_dialise_bef_delete() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN

	update cpoe_revalidation_events
	set    nr_seq_dialysis  = NULL
	where  nr_seq_dialysis = OLD.nr_sequencia;

  delete  from cpoe_inconsistency
	where  nr_seq_item = OLD.nr_sequencia
	and    dt_liberacao is null
	and    nm_usuario =  OLD.nm_usuario;

	delete  from cpoe_plan_protocol
	where   nr_seq_dial_cpoe = OLD.nr_sequencia;

	delete FROM cpoe_revalidation_events
	where  nr_seq_dialysis = OLD.nr_sequencia;

	delete
	from   cpoe_dialise
	where    nr_sequencia = OLD.nr_sequencia
	and    dt_liberacao is null;
	
exception
when others then
	null;
  END;
RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_dialise_bef_delete() FROM PUBLIC;

CREATE TRIGGER cpoe_dialise_bef_delete
	BEFORE DELETE ON cpoe_dialise FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_dialise_bef_delete();
