-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pat_conta_contabil (nr_seq_regra_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*ie_opcao 
C - CD_CONTA_CONTABIL 
DC - DS_CONTA_CONTABIL 
*/
 
 
cd_conta_contabil_w 	conta_contabil.cd_conta_contabil%type;
ds_conta_contabil_w	conta_contabil.ds_conta_contabil%type;

ds_retorno_w		varchar(255) := '';

 

BEGIN 
 
if (nr_seq_regra_p > 0) then 
	select	a.cd_conta_contabil, 
		substr(a.ds_conta_contabil,1,255) 
	into STRICT	cd_conta_contabil_w, 
		ds_conta_contabil_w 
	from	conta_contabil a, 
		pat_conta_contabil b 
	where	a.cd_conta_contabil = b.cd_conta_contabil 
	and	b.nr_sequencia = nr_seq_regra_p;
 
	if (ie_opcao_p = 'C') then 
		ds_retorno_w := cd_conta_contabil_w;
	elsif (ie_opcao_p = 'DC') then 
		ds_retorno_w := ds_conta_contabil_w;
	end if;
end if;
 
 
return	ds_retorno_w;
 
end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pat_conta_contabil (nr_seq_regra_p bigint, ie_opcao_p text) FROM PUBLIC;

