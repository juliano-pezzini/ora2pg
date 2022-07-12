-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_se_gerente_canal ( nr_sequencia_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1) := 'N';
cd_cnpj_w		varchar(14);


BEGIN 
select	coalesce(max(a.cd_cnpj),0) 
into STRICT	cd_cnpj_w 
from	com_canal a 
where	a.nr_sequencia = nr_sequencia_p;
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ds_retorno_w 
from	pessoa_juridica_compl a 
where	a.cd_cgc = cd_cnpj_w 
and	a.cd_pessoa_fisica_canal = cd_pessoa_fisica_p 
and	a.ie_gerente_canal = 'S';
 
if (ds_retorno_w = 'N') then 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ds_retorno_w 
	from	com_canal_gerente 
	where	nr_seq_canal = nr_sequencia_p 
	and	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_se_gerente_canal ( nr_sequencia_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
