-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_pat_local ( nr_seq_local_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
vl_retorno_w			varchar(255) := '';
			

BEGIN 
 
if (nr_seq_local_p > 0) then 
	if (ie_opcao_p = 'C') then 
		select 	cd_estabelecimento 
		into STRICT	vl_retorno_w 
		from	pat_local 
		where 	nr_sequencia = nr_seq_local_p;
	else 
		select	substr(a.nm_fantasia_estab,1,255) 
		into STRICT	vl_retorno_w 
		from	estabelecimento a, 
			pat_local b 
		where	a.cd_estabelecimento = b.cd_estabelecimento 
		and	b.nr_sequencia = nr_seq_local_p;
	end if;
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estab_pat_local ( nr_seq_local_p bigint, ie_opcao_p text) FROM PUBLIC;
