-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cep_loc_insert ON cep_loc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cep_loc_insert() RETURNS trigger AS $BODY$
BEGIN

if	not obter_se_uf_valido(NEW.ds_uf) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1023731, null);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cep_loc_insert() FROM PUBLIC;

CREATE TRIGGER cep_loc_insert
	BEFORE INSERT OR UPDATE ON cep_loc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cep_loc_insert();

