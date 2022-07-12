-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS trg_lista_equipe_med_exec ON lista_equipe_med_exec CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_trg_lista_equipe_med_exec() RETURNS trigger AS $BODY$
DECLARE NR_SEQUENCIA_W bigint;
BEGIN
  IF (TG_OP = 'INSERT') AND (COALESCE(NEW.NR_SEQUENCIA,0)= 0) THEN
    SELECT nextval('lista_equipe_med_exec_seq') INTO STRICT NR_SEQUENCIA_W;
    NEW.NR_SEQUENCIA := NR_SEQUENCIA_W;
  END IF;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_trg_lista_equipe_med_exec() FROM PUBLIC;

CREATE TRIGGER trg_lista_equipe_med_exec
	BEFORE INSERT OR UPDATE ON lista_equipe_med_exec FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_trg_lista_equipe_med_exec();

