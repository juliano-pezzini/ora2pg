-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_idade_tps ( cd_pessoa_fisica_p text, dt_parametro_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_idade_w			bigint;


BEGIN

select	coalesce(obter_idade(dt_nascimento, dt_parametro_p, 'A'),0)
into STRICT	qt_idade_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

/* Em relação ao domínio 2486 */

if (qt_idade_w	< 60) then
	return	1;
elsif (qt_idade_w	>= 60) then
	return 2;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_idade_tps ( cd_pessoa_fisica_p text, dt_parametro_p timestamp) FROM PUBLIC;

