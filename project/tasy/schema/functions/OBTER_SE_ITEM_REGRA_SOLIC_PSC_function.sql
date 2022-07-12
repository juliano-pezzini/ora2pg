-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_regra_solic_psc ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE



nr_seq_regra_w				bigint;
cd_grupo_material_w			smallint;
cd_subgrupo_material_w			smallint;
cd_classe_material_w			integer;
nr_seq_familia_w				integer;
ie_integra_w				varchar(1) := 'S';
ie_padronizado_w				varchar(1);
ie_estoque_w				varchar(1);
cd_perfil_w				integer;

c01 CURSOR FOR
SELECT	coalesce(ie_integra,'S')
from	regra_integr_sc_estrut
where	nr_seq_regra = nr_seq_regra_w
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and (coalesce(cd_material, cd_material_p) 			= cd_material_p or cd_material_p = 0)
and	((coalesce(ie_estoque,'T') = 'T') or
	((coalesce(ie_estoque,'T') = 'S') and (ie_estoque_w = 'S')) or
	((coalesce(ie_estoque,'T') = 'N') and (ie_estoque_w = 'N')))
and	((coalesce(ie_padronizado,'T') = 'T') or
	((coalesce(ie_padronizado,'T') = 'S') and (ie_padronizado_w = 'S')) or
	((coalesce(ie_padronizado,'T') = 'N') and (ie_padronizado_w = 'N')))
order by
	coalesce(cd_material, 0),
	coalesce(cd_classe_material, 0),
	coalesce(cd_subgrupo_material, 0),
	coalesce(cd_grupo_material, 0);

c03 CURSOR FOR
SELECT	a.nr_sequencia
from	regra_integr_solic_compra a
where	a.ie_tipo_servico = 'ES'
and	a.ie_integracao in ('S','BI')
and (cd_perfil = cd_perfil_w or coalesce(cd_perfil::text, '') = '')
and exists(
	SELECT	1
	from	regra_integr_sc_estrut x
	where	x.nr_seq_regra = a.nr_sequencia
	and	coalesce(x.cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(x.cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
	and	coalesce(x.cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
	and (coalesce(x.cd_material, cd_material_p) 			= cd_material_p or cd_material_p = 0)
	and	((coalesce(x.ie_estoque,'T') = 'T') or
		((coalesce(x.ie_estoque,'T') = 'S') and (ie_estoque_w = 'S')) or
		((coalesce(x.ie_estoque,'T') = 'N') and (ie_estoque_w = 'N')))
	and	((coalesce(x.ie_padronizado,'T') = 'T') or
		((coalesce(x.ie_padronizado,'T') = 'S') and (ie_padronizado_w = 'S')) or
		((coalesce(x.ie_padronizado,'T') = 'N') and (ie_padronizado_w = 'N'))))
order by
	coalesce(cd_perfil,99999) desc;


BEGIN

select	obter_perfil_ativo
into STRICT	cd_perfil_w
;


select	a.cd_grupo_material,
	a.cd_subgrupo_material,
	a.cd_classe_material,
	b.ie_padronizado,
	b.ie_material_estoque
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	ie_padronizado_w,
	ie_estoque_w
from	estrutura_material_v a,
	material_estab b
where	a.cd_material = b.cd_material
and	b.cd_estabelecimento = cd_estabelecimento_p
and	a.cd_material = cd_material_p;


open C03;
loop
fetch C03 into
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	nr_seq_regra_w := nr_seq_regra_w;
	end;
end loop;
close C03;

if (nr_seq_regra_w > 0) then

	open C01;
	loop
	fetch C01 into
		ie_integra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_integra_w	:= ie_integra_w;
		end;
	end loop;
	close C01;

end if;

return ie_integra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_regra_solic_psc ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
