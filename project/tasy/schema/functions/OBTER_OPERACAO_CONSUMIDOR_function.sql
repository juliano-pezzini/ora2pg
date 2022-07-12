-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_operacao_consumidor ( cd_pessoa_fisica_p text, cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
nr_inscricao_estadual_w		pessoa_juridica.nr_inscricao_estadual%type;
	

BEGIN
if (coalesce(cd_cgc_p,'X') <> 'X' )then

nr_inscricao_estadual_w	:=	nfe_obter_dados_pj(cd_cgc_p,'IN');

if (coalesce(nr_inscricao_estadual_w, 'X') <> 'X' and coalesce(nfe_obter_dados_pj(cd_cgc_p, 'TC'), 1) <> '9') then
		ds_retorno_w	:=	'0';
	
	else
	
		ds_retorno_w	:=	'1';
	
	end if;


end if;

if (coalesce(cd_pessoa_fisica_p,'X') <> 'X' )then

	select  nr_inscricao_estadual
	into STRICT	nr_inscricao_estadual_w
	from 	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;


	if (coalesce(nr_inscricao_estadual_w,'X') <> 'X') then
		ds_retorno_w	:=	'0';
	
	else
	
		ds_retorno_w	:=	'1';
	
	end if;	



end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_operacao_consumidor ( cd_pessoa_fisica_p text, cd_cgc_p text) FROM PUBLIC;
