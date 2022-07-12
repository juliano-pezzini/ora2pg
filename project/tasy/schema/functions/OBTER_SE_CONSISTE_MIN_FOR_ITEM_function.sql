-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_consiste_min_for_item ( nr_cot_compra_p bigint, cd_material_p bigint, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE

/*ie_retorno_p
C - Consiste (Sim ou Não)
Q - Quantidade mínimo de fornecedores necessários para o item*/
ds_retorno_w			varchar(255);
ie_consiste_w			varchar(1);
qt_minimo_fornec_w		bigint;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
qt_fornecedores_w		bigint;
cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w		subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w		classe_material.cd_classe_material%type;


c01 CURSOR FOR
SELECT	qt_minimo_fornec
from	regra_min_fornec_item_cot
where	cd_estabelecimento = cd_estabelecimento_w
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and (coalesce(cd_material, cd_material_p) 			= cd_material_p or cd_material_p = 0)
order by
	coalesce(cd_material,0),
	coalesce(cd_classe_material,0),
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_grupo_material,0);


BEGIN

ie_consiste_w := 'N';

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	cot_compra
where	nr_cot_compra = nr_cot_compra_p;

select	a.cd_grupo_material,
	a.cd_subgrupo_material,
	a.cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	estrutura_material_v a
where	a.cd_material = cd_material_p;


open C01;
loop
fetch C01 into
	qt_minimo_fornec_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_minimo_fornec_w := qt_minimo_fornec_w;
	end;
end loop;
close C01;

if (qt_minimo_fornec_w > 0) then

	select	count(distinct a.cd_cgc_fornecedor)
	into STRICT	qt_fornecedores_w
	from	cot_compra_forn a,
		cot_compra_forn_item b
	where	a.nr_sequencia = b.nr_seq_cot_forn
	and	a.nr_cot_compra = nr_cot_compra_p
	and	vl_unitario_material > 0
	and	b.cd_material = cd_material_p;

	if (qt_fornecedores_w < qt_minimo_fornec_w) then
		ie_consiste_w := 'S';
	end if;
end if;

if (ie_retorno_p = 'C') then
	ds_retorno_w := ie_consiste_w;
elsif (ie_retorno_p = 'Q') then
	ds_retorno_w := qt_minimo_fornec_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_consiste_min_for_item ( nr_cot_compra_p bigint, cd_material_p bigint, ie_retorno_p text) FROM PUBLIC;
