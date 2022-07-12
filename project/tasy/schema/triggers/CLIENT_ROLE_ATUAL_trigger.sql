-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS client_role_atual ON client_role CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_client_role_atual() RETURNS trigger AS $BODY$
BEGIN
  IF
    TG_OP = 'INSERT'
  THEN
    NEW.dt_creation := LOCALTIMESTAMP;
  END IF;
  IF
    TG_OP = 'INSERT' OR TG_OP = 'UPDATE'
  THEN
    NEW.dt_modification := LOCALTIMESTAMP;
  END IF;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_client_role_atual() FROM PUBLIC;

CREATE TRIGGER client_role_atual
	BEFORE INSERT OR UPDATE ON client_role FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_client_role_atual();

