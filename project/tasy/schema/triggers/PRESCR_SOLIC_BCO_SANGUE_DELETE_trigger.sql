-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_solic_bco_sangue_delete ON prescr_solic_bco_sangue CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_solic_bco_sangue_delete() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
pragma autonomous_transaction;
BEGIN
  BEGIN
BEGIN
delete	FROM med_avaliacao_paciente
where	nr_seq_prescr	= OLD.nr_sequencia;

COMMIT;
exception
	when others then
      	dt_atualizacao := LOCALTIMESTAMP;
end;

  END;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_solic_bco_sangue_delete() FROM PUBLIC;

CREATE TRIGGER prescr_solic_bco_sangue_delete
	BEFORE DELETE ON prescr_solic_bco_sangue FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_solic_bco_sangue_delete();
