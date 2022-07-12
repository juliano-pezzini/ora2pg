-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS trg_reg_rel_doc_insert ON reg_rel_documento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_trg_reg_rel_doc_insert() RETURNS trigger AS $BODY$
BEGIN
	INSERT INTO reg_item_documento(nr_sequencia, nr_seq_documento, nr_seq_rel_item)
			SELECT	nextval('reg_item_documento_seq'),
				NEW.nr_sequencia,
				i.nr_sequencia
			FROM	reg_relatorio_item i;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_trg_reg_rel_doc_insert() FROM PUBLIC;

CREATE TRIGGER trg_reg_rel_doc_insert
	AFTER INSERT ON reg_rel_documento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_trg_reg_rel_doc_insert();
