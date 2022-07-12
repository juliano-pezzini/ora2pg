-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_indicacao ( cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
 
/* 
 ie_opcao_p 
  C -> Codigo pessoa indicação 
  N -> Nome pessoa indicação 
*/
 
 
cd_pessoa_indicacao_w	varchar(10);
ds_retorno_w			varchar(254);


BEGIN 
 
select	i.cd_pessoa_fisica 
into STRICT	cd_pessoa_indicacao_w 
from	pessoa_fisica_indicacao i 
where	i.cd_pessoa_indicada	= cd_pessoa_fisica_p 
and	i.nr_sequencia		= (	SELECT	max(j.nr_sequencia) 
						from 	pessoa_fisica_indicacao j 
						where 	j.cd_pessoa_indicada 	= i.cd_pessoa_indicada);
 
if (ie_opcao_p =	'C') then 
	ds_retorno_w 	:= cd_pessoa_indicacao_w;
elsif (ie_opcao_p =	'N') then 
	ds_retorno_w	:= substr(obter_nome_pf(cd_pessoa_indicacao_w),1,100);
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_indicacao ( cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;

