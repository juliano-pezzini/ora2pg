-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_assist_pck.get_pessoa_usuario () RETURNS varchar AS $body$
BEGIN
	if (current_setting('wheb_assist_pck.cd_pessoa_fisica_w')::(varchar(15) IS NOT NULL AND (varchar(15))::text <> '')) then
		return current_setting('wheb_assist_pck.cd_pessoa_fisica_w')::varchar(15);
	end if;
	
	select	max(cd_pessoa_fisica)
	into STRICT	current_setting('wheb_assist_pck.cd_pessoa_fisica_w')::varchar(15)
	from	usuario
	where	nm_usuario	= current_setting('wheb_assist_pck.nm_usuario_w')::varchar(50);
	
	return current_setting('wheb_assist_pck.cd_pessoa_fisica_w')::varchar(15);
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_assist_pck.get_pessoa_usuario () FROM PUBLIC;