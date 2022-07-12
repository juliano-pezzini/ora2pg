-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_estab_insert ON pessoa_fisica_estab CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_estab_insert() RETURNS trigger AS $BODY$
declare

qt_count_w	bigint;

BEGIN

select	count(*)
into STRICT	qt_count_w
from	pessoa_fisica_estab
where	cd_estabelecimento = NEW.cd_estabelecimento
and	cd_pessoa_fisica = NEW.cd_pessoa_fisica;

if (qt_count_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(950038);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_estab_insert() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_estab_insert
	BEFORE INSERT ON pessoa_fisica_estab FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_estab_insert();
