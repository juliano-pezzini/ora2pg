-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tiss_cabecalho_bf_insert ON tiss_cabecalho CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tiss_cabecalho_bf_insert() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ds_versao is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1075885);
end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tiss_cabecalho_bf_insert() FROM PUBLIC;

CREATE TRIGGER tiss_cabecalho_bf_insert
	BEFORE INSERT ON tiss_cabecalho FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tiss_cabecalho_bf_insert();
