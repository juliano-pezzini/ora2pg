-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_pai_mae (cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN


if (ie_opcao_p = 'M') then
	select 	max(nm_contato)
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	ie_tipo_complemento = '5'
	and	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;

if (ie_opcao_p = 'P') then
	select 	max(nm_contato)
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	ie_tipo_complemento = '4'
	and	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_pai_mae (cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;

