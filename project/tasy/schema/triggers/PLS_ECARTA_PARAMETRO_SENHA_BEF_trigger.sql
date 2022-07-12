-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_ecarta_parametro_senha_bef ON pls_ecarta_parametro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_ecarta_parametro_senha_bef() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ds_senha_ftp <> OLD.ds_senha_ftp) or
	(OLD.ds_senha_ftp is null AND NEW.ds_senha_ftp is not null) then
	NEW.ds_senha_ftp := wheb_seguranca.encrypt(NEW.ds_senha_ftp);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_ecarta_parametro_senha_bef() FROM PUBLIC;

CREATE TRIGGER pls_ecarta_parametro_senha_bef
	BEFORE INSERT OR UPDATE OF ds_senha_ftp ON pls_ecarta_parametro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_ecarta_parametro_senha_bef();

