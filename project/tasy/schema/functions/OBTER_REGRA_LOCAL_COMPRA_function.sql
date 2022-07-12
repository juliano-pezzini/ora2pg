-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_local_compra ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_funcao_p text, ie_retorno_p text, ie_tipo_ordem_p text) RETURNS varchar AS $body$
DECLARE


cd_grupo_material_w			grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w			subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w			classe_material.cd_classe_material%type;
qt_regra_w				integer;
cd_local_estoque_w			regra_local_compra.cd_local_estoque%type;
cd_centro_custo_w			regra_local_compra.cd_centro_custo%type;
cd_local_entrega_w			regra_local_compra.cd_local_entrega%type;
ie_controlado_w				varchar(1);
ie_padronizado_w			material_estab.ie_padronizado%type;
cd_unidade_medida_compra_w		unidade_medida.cd_unidade_medida%type;
cd_perfil_w				perfil.cd_perfil%type;
ds_retorno_w				varchar(255);

/* ie_funcao_p
	OC =	Ordem de compras
	NF =	Nota Fiscal

ie_retorno_p
	LE =	Local de estoque
	CC = 	Centro custo
	LN = 	Local de entrega
	*/
c01 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_custo,
	a.cd_local_entrega
from	regra_local_compra a,
	local_estoque b
where	a.cd_estabelecimento = cd_estabelecimento_p
and	coalesce(a.cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(a.cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(a.cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and	coalesce(a.cd_perfil, cd_perfil_w)				= cd_perfil_w
and (coalesce(a.cd_material, cd_material_p) 			= cd_material_p or cd_material_p = 0)
and	((coalesce(a.ie_controlado,'A') = 'A') or (coalesce(a.ie_controlado, 'A') 	= ie_controlado_w))
and	((coalesce(a.ie_padronizado,'A') = 'A') or (coalesce(a.ie_padronizado, 'A') 	= ie_padronizado_w))
and	coalesce(a.cd_unidade_medida, cd_unidade_medida_compra_w)	= cd_unidade_medida_compra_w
and	(((ie_funcao_p = 'OC') and (coalesce(a.ie_ordem_compra,'N') = 'S')) or
	((ie_funcao_p = 'NF') and (coalesce(a.ie_nota_fiscal,'N') = 'S')))
and	coalesce(a.ie_tipo_ordem,ie_tipo_ordem_p) = ie_tipo_ordem_p
and (a.cd_local_estoque = b.cd_local_estoque)
and (b.ie_situacao = 'A')
order by
	coalesce(a.cd_material, 0),
	coalesce(a.cd_classe_material, 0),
	coalesce(a.cd_subgrupo_material, 0),
	coalesce(a.cd_grupo_material, 0);


BEGIN

cd_perfil_w	:= Obter_Perfil_Ativo;

select	count(*)
into STRICT	qt_regra_w
from	regra_local_compra;

if (qt_regra_w > 0) then
	begin
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		substr(obter_se_medic_controlado(cd_material),1,1) ie_controlado,
		substr(obter_se_material_padronizado(cd_estabelecimento_p, cd_material),1,1) ie_padronizado
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		ie_controlado_w,
		ie_padronizado_w
	from	estrutura_material_v
	where	cd_material = cd_material_p;

	select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMC'),1,255) cd_unidade_medida_compra
	into STRICT	cd_unidade_medida_compra_w
	from	material
	where	cd_material = cd_material_p;

	open c01;
	loop
	fetch c01 into
		cd_local_estoque_w,
		cd_centro_custo_w,
		cd_local_entrega_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		cd_local_estoque_w	:= cd_local_estoque_w;
		cd_centro_custo_w	:= cd_centro_custo_w;
		cd_local_entrega_w	:= cd_local_entrega_w;
	end loop;
	close c01;
	end;
end if;

if (ie_retorno_p = 'LE') then
	ds_retorno_w	:= cd_local_estoque_w;
elsif (ie_retorno_p = 'CC') then
	ds_retorno_w	:= cd_centro_custo_w;
elsif (ie_retorno_p = 'LN') then
	ds_retorno_w	:= cd_local_entrega_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_local_compra ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_funcao_p text, ie_retorno_p text, ie_tipo_ordem_p text) FROM PUBLIC;
