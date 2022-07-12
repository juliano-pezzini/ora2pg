-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_possui_cidade_carona (nr_seq_regiao_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1);
			

BEGIN 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ds_retorno_w 
from	rp_cidade 
where	nr_seq_regiao = nr_seq_regiao_p 
and	cd_municipio_ibge = obter_compl_pf(cd_pessoa_fisica_p,1,'CDM');
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_possui_cidade_carona (nr_seq_regiao_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

