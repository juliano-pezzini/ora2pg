-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_local_estoque_cc_item_nf ( cd_estabelecimento_p bigint, cd_operacao_nf_p bigint, cd_material_p bigint, cd_local_estoque_p INOUT bigint, cd_centro_custo_p INOUT bigint) AS $body$
DECLARE


qt_existe_w		bigint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;

cd_local_estoque_w	smallint;
cd_centro_custo_w	integer;

C01 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_retorno
from	sup_regra_local_cc_nf a,
	local_estoque b
where	coalesce(a.cd_operacao_nf, cd_operacao_nf_p) = cd_operacao_nf_p
and	coalesce(a.cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
and	coalesce(a.cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
and	coalesce(a.cd_classe_material, cd_classe_material_w) = cd_classe_material_w
and	coalesce(a.cd_material, cd_material_p) = cd_material_p
and (coalesce(cd_centro_custo_p::text, '') = '' or coalesce(a.cd_centro_custo, cd_centro_custo_p) = cd_centro_custo_p)
and (a.cd_local_estoque = b.cd_local_estoque)
and (b.ie_situacao = 'A')
and	a.cd_estabelecimento = cd_estabelecimento_p
order by coalesce(a.cd_operacao_nf, 0) asc,
	coalesce(CASE WHEN coalesce(cd_centro_custo_p::text, '') = '' THEN  0  ELSE a.cd_centro_custo END , 0) asc,
	coalesce(a.cd_material, 0) asc,
	coalesce(a.cd_classe_material, 0) asc,
	coalesce(a.cd_subgrupo_material, 0) asc,
	coalesce(a.cd_grupo_material, 0) asc;

C02 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_retorno
from	sup_regra_local_cc_nf a,
	local_estoque b
where	coalesce(a.cd_operacao_nf, cd_operacao_nf_p) = cd_operacao_nf_p
and (coalesce(cd_centro_custo_p::text, '') = '' or coalesce(a.cd_centro_custo, cd_centro_custo_p) = cd_centro_custo_p)
and (a.cd_local_estoque = b.cd_local_estoque)
and (b.ie_situacao = 'A')
and	a.cd_estabelecimento = cd_estabelecimento_p
order by coalesce(a.cd_operacao_nf, 0) asc,
	coalesce(CASE WHEN coalesce(cd_centro_custo_p::text, '') = '' THEN  0  ELSE a.cd_centro_custo END , 0) asc,
	coalesce(a.cd_material, 0) desc,
	coalesce(a.cd_classe_material, 0) desc,
	coalesce(a.cd_subgrupo_material, 0) desc,
	coalesce(a.cd_grupo_material, 0) desc;


BEGIN
select	count(*)
into STRICT	qt_existe_w
from	sup_regra_local_cc_nf
where	cd_estabelecimento = cd_estabelecimento_p;

if (qt_existe_w > 0) then
	begin
	if (coalesce(cd_material_p,0) > 0) then
		begin
		select	cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material
		into STRICT	cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w
		from	estrutura_material_v
		where	cd_material = cd_material_p;

		open C01;
		loop
		fetch C01 into
			cd_local_estoque_w,
			cd_centro_custo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		end loop;
		close C01;
		end;
	else
		begin
		open C02;
		loop
		fetch C02 into
			cd_local_estoque_w,
			cd_centro_custo_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		end loop;
		close C02;
		end;
	end if;
	end;
end if;

cd_local_estoque_p	:= coalesce(cd_local_estoque_w, cd_local_estoque_p);
cd_centro_custo_p	:= coalesce(cd_centro_custo_w, cd_centro_custo_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_local_estoque_cc_item_nf ( cd_estabelecimento_p bigint, cd_operacao_nf_p bigint, cd_material_p bigint, cd_local_estoque_p INOUT bigint, cd_centro_custo_p INOUT bigint) FROM PUBLIC;

