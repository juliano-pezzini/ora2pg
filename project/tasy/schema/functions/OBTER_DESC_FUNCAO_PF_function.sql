-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_funcao_pf ( cd_pessoa_fisica_p bigint, ie_opcao_p text default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
nm_usuario_w	varchar(15);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	max(c.nm_usuario)
	into STRICT	nm_usuario_w
	from	usuario c
	where	c.cd_pessoa_fisica = cd_pessoa_fisica_p;
	
	if (coalesce(ie_opcao_p::text, '') = '') then

		select	b.ds_expressao
		into STRICT	ds_retorno_w
		from	valor_dominio_v b,
			usuario a
		where	a.nm_usuario		= nm_usuario_w
		and	b.cd_dominio		= 72
		and	a.ie_tipo_evolucao	= b.vl_dominio;
	
	elsif (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	
		select	b.vl_dominio
		into STRICT	ds_retorno_w
		from	valor_dominio b,
			usuario a
		where	a.nm_usuario		= nm_usuario_w
		and	b.cd_dominio		= 72
		and	a.ie_tipo_evolucao	= b.vl_dominio;
	
	end if;
	
end if;
	
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_funcao_pf ( cd_pessoa_fisica_p bigint, ie_opcao_p text default null) FROM PUBLIC;

