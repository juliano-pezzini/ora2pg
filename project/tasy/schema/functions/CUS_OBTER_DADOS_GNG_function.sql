-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_dados_gng ( nr_seq_gng_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


cd_grupo_natureza_gasto_w	bigint;
cd_estabelecimento_w		bigint;
ds_retorno_w			varchar(255);


BEGIN

select	a.cd_grupo_natureza_gasto,
	a.cd_estabelecimento
into STRICT	cd_grupo_natureza_gasto_w,
	cd_estabelecimento_w
from	grupo_natureza_gasto a
where	nr_sequencia	= nr_seq_gng_p;

if (ie_opcao_p = 'C') then
	ds_retorno_w	:= cd_grupo_natureza_gasto_w;
elsif (ie_opcao_p = 'E') then
	ds_retorno_w	:= cd_estabelecimento_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_dados_gng ( nr_seq_gng_p bigint, ie_opcao_p text) FROM PUBLIC;

