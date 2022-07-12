-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_grafico_novo (nr_cirurgia_p bigint, nr_seq_pepo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(10);
ds_retorno_w		varchar(255);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;


BEGIN 
 
select 	max(cd_pessoa_fisica), 
	max(cd_procedimento_princ), 
	max(ie_origem_proced) 
into STRICT 	cd_pessoa_fisica_w, 
	cd_procedimento_w, 
	ie_origem_proced_w 
from 	cirurgia 
where 	nr_cirurgia = nr_cirurgia_p 
or 	nr_seq_pepo = nr_seq_pepo_p;
 
ds_retorno_w := '';
 
if (ie_opcao_p = 'NPF') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
	select 	substr(obter_nome_pf(cd_pessoa_fisica_w),1,255) 
	into STRICT	ds_retorno_w 
	;
elsif (ie_opcao_p = 'IPF') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
	select 	substr(obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'D'),1,255) 
	into STRICT	ds_retorno_w 
	;
elsif (ie_opcao_p = 'PPF') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
	select 	substr(obter_peso_pf(cd_pessoa_fisica_w),1,255) 
	into STRICT	ds_retorno_w 
	;
elsif (ie_opcao_p = 'VPF') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
	select 	substr(obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255) 
	into STRICT	ds_retorno_w 
	;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_grafico_novo (nr_cirurgia_p bigint, nr_seq_pepo_p bigint, ie_opcao_p text) FROM PUBLIC;

