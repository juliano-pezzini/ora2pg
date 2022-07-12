-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_preco_mat ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_tab_preco_mat_w 		parametro_estoque.cd_tab_preco_far_venda%type;
cd_tab_preco_far_venda_w	parametro_estoque.cd_tab_preco_far_venda%type;
vl_preco_w 			double precision;
vl_preco_venda_w			double precision;
vl_preco_minimo_w			double precision;
tx_ajuste_w			double precision;
tx_ajuste_minimo_w		double precision;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w 		integer;
tx_ajuste_contrato_conv		double precision;


BEGIN

select 	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from 	estrutura_material_v
where	cd_material = cd_material_p;

select	max(CD_TAB_PRECO_FAR_VENDA)
into STRICT	cd_tab_preco_mat_w
from	PARAMETRO_ESTOQUE
where	cd_estabelecimento = cd_estabelecimento_p;

begin
	select obter_valor_param_usuario(1608, 2, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_p)
	into STRICT   cd_tab_preco_far_venda_w
	;
exception
when others then
	cd_tab_preco_far_venda_w := null;
end;

if (cd_tab_preco_far_venda_w IS NOT NULL AND cd_tab_preco_far_venda_w::text <> '') then
	cd_tab_preco_mat_w := cd_tab_preco_far_venda_w;
end if;

select 	max(vl_preco_venda)
into STRICT	vl_preco_w
from 	preco_material a
where 	cd_material = cd_material_p
and	cd_tab_preco_mat = cd_tab_preco_mat_w
and	ie_situacao = 'A'
and	trunc(dt_inicio_vigencia) =	(SELECT	max(trunc(x.dt_inicio_vigencia))
				from	preco_material x
				where	x.cd_tab_preco_mat = a.cd_tab_preco_mat
				and	x.cd_material = a.cd_material
				and	x.ie_situacao = 'A'
				and	trunc(x.dt_inicio_vigencia) <= trunc(clock_timestamp()));

return coalesce(vl_preco_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_preco_mat ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
