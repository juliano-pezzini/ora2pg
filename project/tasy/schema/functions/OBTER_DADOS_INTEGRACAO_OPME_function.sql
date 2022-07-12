-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_integracao_opme ( ie_sistema_integracao_p text, cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
 
ds_url_servico_opme_w	varchar(255);
ds_usuario_servico_opme_w 	varchar(255);
ds_senha_servico_opme_w 	varchar(255);
ds_retorno_w		varchar(255);	
cd_estab_regra_w		varchar(255);
ds_url_opme_w		varchar(255);

/* 
ie_opcao 
URL - wsdl da integração 
S - senha 
U - usuário 
E - estabelecimentos cadatrados 
SI - site 
*/
			 

BEGIN 
 
select	ds_url_servico_opme, 
	ds_usuario_servico_opme, 
	ds_senha_servico_opme, 
	cd_estab_regra, 
	ds_url_opme	 
into STRICT	ds_url_servico_opme_w, 
	ds_usuario_servico_opme_w, 
	ds_senha_servico_opme_w, 
	cd_estab_regra_w, 
	ds_url_opme_w	 	 
from 	parametros_opme 
where 	ie_sistema_integracao = ie_sistema_integracao_p 
and	cd_estabelecimento = cd_estabelecimento_p;
 
if (ie_opcao_p = 'URL') then 
	ds_retorno_w := ds_url_servico_opme_w;
elsif (ie_opcao_p = 'S') then 
	ds_retorno_w := ds_senha_servico_opme_w;
elsif (ie_opcao_p = 'U') then 
	ds_retorno_w := ds_usuario_servico_opme_w;
elsif (ie_opcao_p = 'E') then 
	ds_retorno_w := cd_estab_regra_w;
elsif (ie_opcao_p = 'SI') then 
	ds_retorno_w := ds_url_opme_w;	
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_integracao_opme ( ie_sistema_integracao_p text, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;
