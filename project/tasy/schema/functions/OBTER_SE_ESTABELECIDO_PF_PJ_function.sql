-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estabelecido_pf_pj (cd_cgc_p text, cd_pessoa_fisica_p text, cd_municipio_ibge_p bigint) RETURNS varchar AS $body$
DECLARE



cd_municipio_ibge_cgc_w			varchar(6) := '0';
cd_municipio_ibge_pf_w			varchar(6) := '0';
ds_retorno_w				varchar(6) := 'S';

BEGIN

if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	begin
	select	coalesce(max(cd_municipio_ibge),0)
	into STRICT	cd_municipio_ibge_cgc_w
	from	pessoa_juridica
	where	cd_cgc	= cd_cgc_p;
	end;
else
	begin
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
		select	coalesce(max(cd_municipio_ibge),0)
		into STRICT	cd_municipio_ibge_pf_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	end if;
	end;
end if;

if (cd_municipio_ibge_cgc_w = cd_municipio_ibge_p) and (cd_municipio_ibge_cgc_w <> '0') then
	ds_retorno_w	:= 'S';
elsif (cd_municipio_ibge_pf_w = cd_municipio_ibge_p)	and (cd_municipio_ibge_pf_w	<> '0') then
	ds_retorno_w	:= 'S';
else
	ds_retorno_w	:= 'N';
end if;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estabelecido_pf_pj (cd_cgc_p text, cd_pessoa_fisica_p text, cd_municipio_ibge_p bigint) FROM PUBLIC;

