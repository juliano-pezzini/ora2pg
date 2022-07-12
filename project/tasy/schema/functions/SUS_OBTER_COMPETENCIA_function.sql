-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_competencia ( cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

 
ds_retorno_w		timestamp;
dt_competencia_aih_w	timestamp;
dt_comp_apac_bpa_w	timestamp;
			

BEGIN 
select	max(dt_competencia_sus), 
	max(dt_comp_apac_bpa) 
into STRICT	dt_competencia_aih_w, 
	dt_comp_apac_bpa_w 
from	parametro_faturamento 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
if (ie_opcao_p	= 'AIH') then 
	ds_retorno_w	:= dt_competencia_aih_w;
else 
	ds_retorno_w	:= dt_comp_apac_bpa_w;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_competencia ( cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;

