-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tiss_senha_conexao_bef ON tiss_senha_conexao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tiss_senha_conexao_bef() RETURNS trigger AS $BODY$
declare

ds_hash_senha_w		varchar(32);
BEGIN

if (NEW.ds_senha_prest is not null) or (NEW.ds_senha_prest <> OLD.ds_senha_prest) then

	ds_hash_senha_w 		:= RAWTOHEX(dbms_obfuscation_toolkit.md5(input => encode(NEW.ds_senha_prest::bytea, 'hex')::bytea));
	NEW.ds_senha_prest_hash	:= lower(ds_hash_senha_w);

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tiss_senha_conexao_bef() FROM PUBLIC;

CREATE TRIGGER tiss_senha_conexao_bef
	BEFORE INSERT OR UPDATE ON tiss_senha_conexao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tiss_senha_conexao_bef();

