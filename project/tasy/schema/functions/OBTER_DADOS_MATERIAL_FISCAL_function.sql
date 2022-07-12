-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_material_fiscal ( cd_material_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE

/* 
IE_OPCAO_P 
1	IE_TIPO_FISCAL 
2	IE_ORIGEM_MERCADORIA 
3	IE_TRIBUTACAO_ICMS 
*/
 
				 
				 
ds_retorno_w			varchar(255);


BEGIN 
 
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then 
	begin 
	if (ie_opcao_p = 1) then 
		select	max(ie_tipo_fiscal) 
		into STRICT	ds_retorno_w 
		from	material_fiscal 
		where	cd_material	= cd_material_p;
	end if;
	 
	if (ie_opcao_p = 2) then 
		select	max(ie_origem_mercadoria) 
		into STRICT	ds_retorno_w 
		from	material_fiscal 
		where	cd_material	= cd_material_p;
	end if;
	 
	if (ie_opcao_p = 3) then 
		select	max(ie_tributacao_icms) 
		into STRICT	ds_retorno_w 
		from	material_fiscal 
		where	cd_material	= cd_material_p;
	end if;
	 
	end;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_material_fiscal ( cd_material_p bigint, ie_opcao_p bigint) FROM PUBLIC;

