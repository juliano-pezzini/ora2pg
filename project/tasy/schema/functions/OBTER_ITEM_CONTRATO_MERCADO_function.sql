-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_item_contrato_mercado ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
			 
ie_contrato_w		varchar(15);
ie_mercado_w		varchar(15);
ds_retorno_w		varchar(15) := '';
			

BEGIN 
 
select	coalesce(obter_se_item_contrato(cd_material_p),'N') 
into STRICT	ie_contrato_w
;
 
if (ie_contrato_w = 'S') then 
	ds_retorno_w	:= 'C';
else 
	select	coalesce(obter_se_item_regra_solic_psc(cd_material_p, cd_estabelecimento_p),'N') 
	into STRICT	ie_mercado_w 
	;
	 
	if (ie_mercado_w = 'S') then 
		ds_retorno_w := 'M';
	end if;	
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_item_contrato_mercado ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
