-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_nome_abreviado ( cd_convenio_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := null;
ie_nome_abrev_w	varchar(255);


BEGIN

select	coalesce(max(a.ie_nome_abrev),'N')
into STRICT	ie_nome_abrev_w
from	tiss_parametros_convenio a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_convenio		= cd_convenio_p;

if (coalesce(ie_nome_abrev_w,'N') = 'S') then
	select	max(nm_abreviado)
	into STRICT	ds_retorno_w
	from	pessoa_fisica a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_nome_abreviado ( cd_convenio_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
