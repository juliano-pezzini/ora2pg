-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS banda_relat_cmp_after_sql_stmt ON banda_relat_campo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_banda_relat_cmp_after_sql_stmt() RETURNS trigger AS $BODY$
BEGIN

  IF wheb_usuario_pck.get_ie_executar_trigger = 'S' THEN

    CALL DOC_EXPORT_AUTO_PKG.BANDA_RELAT_CAMPO_CHANGE_STMT();

  END IF;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_banda_relat_cmp_after_sql_stmt() FROM PUBLIC;

CREATE TRIGGER banda_relat_cmp_after_sql_stmt
	AFTER INSERT OR UPDATE OR DELETE ON banda_relat_campo FOR EACH STATEMENT
	EXECUTE PROCEDURE trigger_fct_banda_relat_cmp_after_sql_stmt();
