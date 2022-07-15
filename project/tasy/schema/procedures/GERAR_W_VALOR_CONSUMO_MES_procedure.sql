-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_valor_consumo_mes ( cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_opcao_p	- CE - Consumo estoque
		- NF - Nota Fiscal
		- CC - Consumo consignado
*/
dt_inicio_mes_w		timestamp;
dt_fim_mes_w		timestamp;

ie_tipo_w		varchar(2);
cd_material_w		integer;
cd_centro_custo_w	integer;
cd_conta_contabil_w	varchar(20);
cd_local_estoque_w	smallint;
vl_consumo_w		double precision;
vl_direto_w		double precision;
vl_consignado_w		double precision;
qt_estoque_w		double precision;
qt_item_nf_w		double precision;
vl_item_nf_w		double precision;
vl_preco_w		double precision;
ds_centro_custo_w	varchar(80);
ds_conta_contabil_w	varchar(255);
nr_sequencia_w		bigint;
ie_consumo_w		varchar(1);
cd_operacao_estoque_w	smallint;

C01 CURSOR FOR
	SELECT ie_tipo,
		cd_material,
		cd_centro_custo,
		cd_local_estoque,
		cd_conta_contabil,
		substr(coalesce(obter_desc_centro_custo(cd_centro_custo), wheb_mensagem_pck.get_texto(312086)),1,80),
		substr(coalesce(obter_desc_conta_contabil(cd_conta_contabil), wheb_mensagem_pck.get_texto(312088)),1,255),
		sum(qt_estoque),
		sum(vl_consumo),
		sum(vl_direto),
		sum(vl_consignado),
		ie_consumo,
		cd_operacao_estoque
	from (
	SELECT 'CE' ie_tipo,
		cd_material,
		cd_centro_custo,
		cd_local_estoque,
		cd_conta_contabil,
		CASE WHEN b.ie_consumo='A' THEN  qt_estoque  ELSE qt_estoque * -1 END  qt_estoque,
		CASE WHEN b.ie_consumo='A' THEN  vl_estoque  ELSE vl_estoque * -1 END  vl_consumo,
		0 vl_direto,
		0 vl_consignado,
		b.ie_consumo,
		b.cd_operacao_estoque
	from	operacao_estoque b,
		resumo_movto_estoque a
	where	a.cd_operacao_estoque	= b.cd_operacao_estoque
	and	b.ie_consumo in ('A', 'D')
	and	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	dt_mesano_referencia between dt_inicio_mes_w and dt_fim_mes_w
	and	a.ie_consignado = 'N'
	
union all

	select 'NF',
		a.cd_material,
		a.cd_centro_custo,
		a.cd_local_estoque,
		cd_conta_contabil,
		a.qt_movimento qt_estoque,
		0 vl_consumo,
		vl_movimento vl_direto,
		0 vl_consignado,
		''ie_consumo,
		a.cd_operacao_estoque
	from	local_estoque b,
		nota_fiscal_centro_custo_v a
	where	a.cd_local_estoque = b.cd_local_estoque
	and	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	dt_atualizacao_estoque between dt_inicio_mes_w and dt_fim_mes_w
	and	b.ie_tipo_local = 8
	and	a.ie_consignado = 'N'
	
union	all

	select 'NC',
		a.cd_material,
		a.cd_centro_custo,
		a.cd_local_estoque,
		cd_conta_contabil,
		a.qt_movimento qt_estoque,
		0 vl_consumo,
		vl_movimento vl_direto,
		0 vl_consignado,
		''ie_consumo,
		a.cd_operacao_estoque
	from	local_estoque b,
		nota_fiscal_centro_custo_v a
	where	a.cd_local_estoque = b.cd_local_estoque
	and	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	dt_atualizacao_estoque between dt_inicio_mes_w and dt_fim_mes_w
	and	b.ie_tipo_local = 8
	and	a.ie_consignado = 'S'
	
union	all

	select 'CC',
		cd_material,
		cd_centro_custo,
		cd_local_estoque,
		cd_conta_contabil,
		CASE WHEN b.ie_consumo='A' THEN  qt_estoque  ELSE qt_estoque * -1 END  qt_estoque,
		0,
		0,
		0 vl_consignado,
		b.ie_consumo,
		b.cd_operacao_estoque
	from	operacao_estoque b,
		resumo_movto_estoque a
	where	a.cd_operacao_estoque	= b.cd_operacao_estoque
	and	b.ie_consumo in ('A', 'D')
	and	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	dt_mesano_referencia between dt_inicio_mes_w and dt_fim_mes_w
	and	a.ie_consignado = 'S') alias14
	group by	ie_tipo,
		cd_material,
		cd_centro_custo,
		cd_local_estoque,
		cd_conta_contabil,
		ie_consumo,
		cd_operacao_estoque;


BEGIN

delete FROM w_valor_consumo_mes;

dt_inicio_mes_w	:= PKG_DATE_UTILS.start_of(dt_mesano_referencia_p, 'MONTH', 0);
dt_fim_mes_w	:= PKG_DATE_UTILS.END_OF(dt_mesano_referencia_p, 'MONTH', 0);

open C01;
loop
	fetch C01 into		ie_tipo_w,
				cd_material_w,
				cd_centro_custo_w,
				cd_local_estoque_w,
				cd_conta_contabil_w,
				ds_centro_custo_w,
				ds_conta_contabil_w,
				qt_estoque_w,
				vl_consumo_w,
				vl_direto_w,
				vl_consignado_w,
				ie_consumo_w,
				cd_operacao_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */

		select nextval('w_valor_consumo_mes_seq')
		into STRICT	nr_sequencia_w
		;

		if (ie_tipo_w = 'CC') and (qt_estoque_w <> 0) then
			select coalesce(max(vl_total_item_nf),0),
				coalesce(max(qt_item_estoque),0)
			into STRICT 	vl_item_nf_w,
				qt_item_nf_w
			from	nota_fiscal_item a
			where	a.cd_material = cd_material_w
			and	a.nr_sequencia = (	SELECT	max(a.nr_sequencia)
							from	nota_fiscal_item b,
								nota_fiscal a
							where	a.nr_sequencia = b.nr_sequencia
							and	a.dt_entrada_saida between
								PKG_DATE_UTILS.ADD_MONTH(dt_inicio_mes_w,-3,0) and dt_fim_mes_w
							and	b.cd_material = cd_material_w);
			vl_consignado_w	:= qt_estoque_w * dividir(vl_item_nf_w, qt_item_nf_w);

			if (vl_item_nf_w = 0) then
				select coalesce(max(vl_preco_venda),0)
				into STRICT vl_preco_w
				from preco_material a
				where cd_estabelecimento = cd_estabelecimento_p
				and cd_material = cd_material_w
				and dt_inicio_vigencia = (	SELECT	max(x.dt_inicio_vigencia)
								from	preco_material x
								where	x.cd_estabelecimento = cd_estabelecimento_p
								and	x.cd_material = cd_material_w);
			vl_consignado_w	:= qt_estoque_w * vl_preco_w;
			end if;
		end if;
		insert into w_valor_consumo_mes(
			cd_centro_custo,
			cd_local_estoque,
			cd_material,
			ds_centro_custo,
			qt_estoque,
			vl_consumo,
			vl_direto,
			vl_consignado,
			ie_opcao,
			dt_atualizacao,
			nm_usuario,
			nr_sequencia,
			cd_conta_contabil,
			ds_conta_contabil,
			ie_consumo,
			cd_operacao_estoque)
		values (cd_centro_custo_w,
			cd_local_estoque_w,
			cd_material_w,
			ds_centro_custo_w,
			qt_estoque_w,
			vl_consumo_w,
			vl_direto_w,
			vl_consignado_w,
			ie_tipo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_w,
			cd_conta_contabil_w,
			ds_conta_contabil_w,
			ie_consumo_w,
			cd_operacao_estoque_w);
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_valor_consumo_mes ( cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

