-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_faixa_etaria_pf (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


qt_idade_w	bigint;
ds_retorno_w	varchar(50);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	(substr(obter_idade(x.dt_nascimento, clock_timestamp(), 'A'),1,10))::numeric
	into STRICT	qt_idade_w
	from	pessoa_fisica x
	where	x.cd_pessoa_fisica = cd_pessoa_fisica_p;

	ds_retorno_w := substr(coalesce(eis_obter_faixa_etaria(qt_idade_w),'0'),1,15);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_faixa_etaria_pf (cd_pessoa_fisica_p text) FROM PUBLIC;

