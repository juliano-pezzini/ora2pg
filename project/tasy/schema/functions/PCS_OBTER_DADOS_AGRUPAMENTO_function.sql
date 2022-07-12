-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_dados_agrupamento ( nr_seq_grupo_p bigint, ie_retorno_p bigint) RETURNS varchar AS $body$
DECLARE

 
/* IE_RETORNO_P 
1 - Responsável (Cód) 
2 - Responsável (Nome) 
*/
 
 
ds_retorno_w				varchar(255);
cd_pessoa_responsavel_w			varchar(10);


BEGIN 
 
select	coalesce(cd_pessoa_responsavel,'0') 
into STRICT	cd_pessoa_responsavel_w 
from	grupo_segmento_compras 
where	nr_sequencia = nr_seq_grupo_p;
 
if (ie_retorno_p = 1) then 
	ds_retorno_w	:= cd_pessoa_responsavel_w;
 
elsif (ie_retorno_p = 2) then 
 
	select	coalesce(max(SUBSTR(OBTER_NOME_PF(CD_PESSOA_FISICA),0,255)),'') 
	into STRICT	ds_retorno_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = cd_pessoa_responsavel_w;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_dados_agrupamento ( nr_seq_grupo_p bigint, ie_retorno_p bigint) FROM PUBLIC;
