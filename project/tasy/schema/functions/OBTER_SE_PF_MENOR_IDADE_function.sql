-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_menor_idade ( cd_pessoa_fisica_p text, dt_atual_p timestamp) RETURNS varchar AS $body$
DECLARE


dt_nascimento_w	timestamp;
qt_idade_pac	bigint;
ds_retorno_w	varchar(1);


BEGIN
ds_retorno_w	:=	'';
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select 	dt_nascimento
	into STRICT	dt_nascimento_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	select	trunc((dt_atual_p - dt_nascimento_w)/365)
	into STRICT	qt_idade_pac
	;

	if (qt_idade_pac < 18) then
		ds_retorno_w	:= 'S';
	else
		ds_retorno_w	:= 'N';
	end if;

end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_menor_idade ( cd_pessoa_fisica_p text, dt_atual_p timestamp) FROM PUBLIC;

