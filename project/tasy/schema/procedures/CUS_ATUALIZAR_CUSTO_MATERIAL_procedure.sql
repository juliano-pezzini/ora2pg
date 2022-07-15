-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_atualizar_custo_material ( nr_seq_tabela_p bigint, cd_material_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, ie_tipo_valor_p text, cd_tabela_preco_p bigint, ie_sobrepor_valor_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



/*
ie_tipo_valor_p
'UC' - Vl Ultima Compra
'CM' - Vl Custo Medio Estoque
'TP' - Vl Tabela Preco Mat
*/
					
cd_material_w				material.cd_material%type;
cd_material_ww				material.cd_material%type;
cd_material_estoque_w			material.cd_material%type;
cd_tabela_preco_w			tabela_preco_material.cd_tab_preco_mat%type;
vl_custo_unit_w				double precision;
qt_dias_prazo_w				integer;
ds_observacao_w				varchar(4000);
dt_parametro_w				timestamp;

c01 CURSOR FOR
SELECT	a.nr_seq_tabela,
	a.cd_tabela_custo,
	a.cd_estabelecimento,
	a.cd_material
from	estrutura_material_v b,
	custo_material a
where	a.cd_material		= b.cd_material
and	a.nr_seq_tabela		= nr_seq_tabela_p
and	b.cd_grupo_material	= coalesce(cd_grupo_material_p, b.cd_grupo_material)
and	b.cd_subgrupo_material	= coalesce(cd_subgrupo_material_p, b.cd_subgrupo_material)
and	b.cd_classe_material	= coalesce(cd_classe_material_p, b.cd_classe_material)
and	a.cd_material		= coalesce(cd_material_p,a.cd_material);


vet01	c01%RowType;


BEGIN

select	coalesce(max(dt_parametro),clock_timestamp())
into STRICT	dt_parametro_w
from	tabela_parametro
where	nr_seq_tabela		= nr_seq_tabela_p
and	nr_seq_parametro	= 4;

cd_material_w := coalesce(cd_material_p,0);

open 	C01;
loop
fetch 	C01 into	
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	vl_custo_unit_w := 0;
	ds_observacao_w := '';
	qt_dias_prazo_w := 0;
	
	if (ie_tipo_valor_p in ('UC','CM')) then
		begin

		cus_obter_preco_ultima_compra(	vet01.cd_material,vet01.nr_seq_tabela,
						vet01.cd_tabela_custo,vet01.cd_estabelecimento,
						ie_tipo_valor_p, vl_custo_unit_w,ds_observacao_w,qt_dias_prazo_w);
		end;
	elsif (ie_tipo_valor_p = 'TP') then
		begin
		cd_tabela_preco_w	:= coalesce(cus_obter_regra_custo_mat(vet01.cd_estabelecimento, vet01.cd_material), cd_tabela_preco_p);
		
		if (coalesce(cd_tabela_preco_w,0) > 0) then
			begin
			select  dividir(coalesce(vl_preco_venda,0),coalesce(QT_CONVERSAO,1))
			into STRICT	vl_custo_unit_w
			from	preco_material 
			where	cd_estabelecimento	= vet01.cd_estabelecimento
			and	cd_tab_preco_mat	= cd_tabela_preco_w
			and	cd_material		= vet01.cd_material
			and	dt_inicio_vigencia	=     (	SELECT	max(dt_inicio_vigencia)
								from	preco_material 
								where	cd_estabelecimento	= vet01.cd_estabelecimento
								and	cd_tab_preco_mat	= cd_tabela_preco_w
								and	cd_material		= vet01.cd_material
								and	dt_inicio_vigencia <= dt_parametro_w
								and	coalesce(dt_final_vigencia,dt_parametro_w) >= dt_parametro_w);
			exception when others then
				vl_custo_unit_w := 0;
			end;
		end if;
		end;
	end if;
	
	if (vl_custo_unit_w <> 0) then
		update 	custo_material
		set	vl_cotado_compra	= CASE WHEN ie_sobrepor_valor_p='S' THEN vl_custo_unit_w WHEN ie_sobrepor_valor_p='N' THEN CASE WHEN coalesce(vl_cotado_compra,0)=0 THEN  vl_custo_unit_w  ELSE vl_cotado_compra END  END ,
			qt_dias_prazo		= coalesce(qt_dias_prazo_w,0),
			ds_observacao		= ds_observacao_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			pr_frete		= 0
		where	cd_estabelecimento	= vet01.cd_estabelecimento
		and	nr_seq_tabela		= nr_seq_tabela_p
		and	cd_material		= vet01.cd_material;

	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_atualizar_custo_material ( nr_seq_tabela_p bigint, cd_material_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, ie_tipo_valor_p text, cd_tabela_preco_p bigint, ie_sobrepor_valor_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

