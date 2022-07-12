-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_unidade_medida_med (cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(30);
ie_prioridade_w numeric(22);

BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	select  min(ie_prioridade),
		min(cd_unidade_medida)
	into STRICT	ie_prioridade_w,
		ds_retorno_w
	from	unidade_medida_dose_v
	where	cd_material = cd_material_p
	and	ie_prioridade  not in (8,9)
	and	obter_se_unid_consumo(cd_material, cd_estabelecimento_p,ie_prioridade) = 'S'
	order by ie_prioridade;
end if;
return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unidade_medida_med (cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
