-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_medic_cih (cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_resultado_w			varchar(100) := '';
cd_medicamento_w		bigint;


BEGIN

if (coalesce(cd_material_p,0) > 0) then

	select  max(cd_medicamento)
	into STRICT	cd_medicamento_w
	from    material
	where   cd_material = cd_material_p;

	if (coalesce(cd_medicamento_w,0) > 0) then

		ds_resultado_w :=  SUBSTR(obter_desc_medic_cih(cd_medicamento_w),1,100);

	end if;

end if;

if (ie_opcao_p = 'D') then
	return ds_resultado_w;

elsif (ie_opcao_p = 'C') then
	return cd_medicamento_w;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_medic_cih (cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;
