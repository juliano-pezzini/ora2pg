-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_usu_web ( cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_tipo_p:
C	= 	Cep
DE	=	Descricao do endereço
NE	=	Numero do endereço
CO	=	Complemento
B	=	Bairro
M	=	Município
*/
ds_retorno_w			varchar(255);


BEGIN

if (ie_tipo_p	= 'C') then
	select	cd_cep
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_p;
elsif (ie_tipo_p	= 'DE') then
	select	ds_endereco
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_p;
elsif (ie_tipo_p	= 'NE') then
	select	nr_endereco
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_p;
elsif (ie_tipo_p	= 'CO') then
	select	ds_complemento
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_p;
elsif (ie_tipo_p	= 'B') then
	select	ds_bairro
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_p;
elsif (ie_tipo_p	= 'M') then
	select	ds_municipio
	into STRICT	ds_retorno_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_usu_web ( cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, ie_tipo_p text) FROM PUBLIC;
