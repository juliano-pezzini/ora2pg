-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_documento_delete ON reg_documento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_documento_delete() RETURNS trigger AS $BODY$
BEGIN
	DELETE FROM reg_versao_documento 
	WHERE nr_seq_documento = OLD.nr_sequencia;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_documento_delete() FROM PUBLIC;

CREATE TRIGGER reg_documento_delete
	BEFORE DELETE ON reg_documento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_documento_delete();

