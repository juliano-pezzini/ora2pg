-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_delete_hl7 ON pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_delete_hl7() RETURNS trigger AS $BODY$
declare

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S' ) then

  CALL ger_pessoa_fisica_delete(OLD.cd_pessoa_fisica);

end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_delete_hl7() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_delete_hl7
	AFTER DELETE ON pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_delete_hl7();
