-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_doador ( nr_seq_doador_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(14);
nm_pessoa_fisica_w	varchar(100);			

BEGIN 
 
select	max(cd_pessoa_fisica), 
	max(obter_nome_pf(cd_pessoa_fisica)) 
into STRICT	cd_pessoa_fisica_w, 
	nm_pessoa_fisica_w 
from  	san_doacao 
where 	nr_sequencia = nr_seq_doador_p;
 
if (ie_opcao_p = 'C') then 
	return	cd_pessoa_fisica_w;
else 
	return nm_pessoa_fisica_w;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_doador ( nr_seq_doador_p bigint, ie_opcao_p text) FROM PUBLIC;

