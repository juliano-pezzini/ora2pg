-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_consiste_regra_lib_oc ( cd_material_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1);
qt_existe_regra_w			bigint;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
ie_tipo_material_w		material.ie_tipo_material%type;
ie_exige_marca_w			varchar(1)	:= 'N';
ie_exige_fabricante_w		varchar(1)	:= 'N';
ie_exige_ca_w			varchar(1)	:= 'N';
ie_exige_tipo_compra_w		varchar(1)	:= 'N';
ie_exige_anvisa_w			varchar(1)	:= 'N';
ie_exige_anexo_w		varchar(1)	:= 'N';

c01 CURSOR FOR
SELECT	coalesce(ie_exige_marca,'N'),
	coalesce(ie_exige_fabricante,'N'),
	coalesce(ie_exige_ca,'N'),
	coalesce(ie_exige_anvisa,'N'),
	coalesce(ie_exige_tipo_compra,'N'),
	coalesce(ie_exige_anexo,'N')
from	sup_regra_consist_lib_oc
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao = 'A'
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and	coalesce(ie_tipo_material, ie_tipo_material_w)		= ie_tipo_material_w
and	coalesce(cd_material,cd_material_p)				= cd_material_p
order by	coalesce(cd_material, 0),
	coalesce(cd_classe_material, 0),
	coalesce(cd_subgrupo_material, 0),
	coalesce(cd_grupo_material, 0),
	coalesce(ie_tipo_material_w,'0');


BEGIN

select	count(*)
into STRICT	qt_existe_regra_w
from	sup_regra_consist_lib_oc
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao = 'A';

if (qt_existe_regra_w > 0) then
	begin

	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		ie_tipo_material
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		ie_tipo_material_w
	from	estrutura_material_v
	where	cd_material = cd_material_p;

	open c01;
	loop
	fetch c01 into
		ie_exige_marca_w,
		ie_exige_fabricante_w,
		ie_exige_ca_w,
		ie_exige_anvisa_w,
		ie_exige_tipo_compra_w,
		ie_exige_anexo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;

	end;
end if;

if (ie_opcao_p = 'M') then
	ie_retorno_w	:= ie_exige_marca_w;
elsif (ie_opcao_p = 'F') then
	ie_retorno_w	:= ie_exige_fabricante_w;
elsif (ie_opcao_p = 'CA') then
	ie_retorno_w	:= ie_exige_ca_w;
elsif (ie_opcao_p = 'AN') then
	ie_retorno_w	:= ie_exige_anvisa_w;
elsif (ie_opcao_p = 'TC') then
	ie_retorno_w	:= ie_exige_tipo_compra_w;
elsif (ie_opcao_p = 'A') then
	ie_retorno_w	:= ie_exige_anexo_w;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_consiste_regra_lib_oc ( cd_material_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

