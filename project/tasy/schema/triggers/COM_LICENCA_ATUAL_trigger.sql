-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS com_licenca_atual ON com_licenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_com_licenca_atual() RETURNS trigger AS $BODY$
DECLARE
ds_hash_w	varchar(32);

BEGIN
	if (OLD.dt_liberacao is not null and OLD.ds_hash is not null) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(279393);
	end if;

	if (OLD.cd_licenca is null ) then
		NEW.cd_licenca := GERAR_CODIGO_LICENCA;
	end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_com_licenca_atual() FROM PUBLIC;

CREATE TRIGGER com_licenca_atual
	BEFORE INSERT OR UPDATE ON com_licenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_com_licenca_atual();
