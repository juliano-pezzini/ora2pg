-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS contrato_regra_nf_delete ON contrato_regra_nf CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_contrato_regra_nf_delete() RETURNS trigger AS $BODY$
DECLARE


BEGIN

update	reg_lic_homol_itens
set	nr_Seq_regra_contr = ''
where	nr_Seq_regra_contr = OLD.nr_Sequencia;

RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_contrato_regra_nf_delete() FROM PUBLIC;

CREATE TRIGGER contrato_regra_nf_delete
	BEFORE DELETE ON contrato_regra_nf FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_contrato_regra_nf_delete();

