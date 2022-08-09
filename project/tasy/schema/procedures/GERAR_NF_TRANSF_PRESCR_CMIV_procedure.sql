-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nf_transf_prescr_cmiv ( nr_seq_ordem_p bigint, cd_estab_entrada_p bigint, cd_estab_saida_p bigint, cd_local_saida_p bigint, cd_operacao_nf_saida_p bigint, cd_nat_oper_nf_saida_p bigint, cd_operacao_nf_entrada_p bigint, cd_nat_oper_nf_entrada_p bigint, cd_cond_pagto_p bigint, cd_serie_nf_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_prescr_w			bigint;
nr_atendimento_w			bigint;
cd_setor_atendimento_w		integer;
cd_material_w			integer;
dt_entrada_unidade_w		timestamp;
cd_unidade_medida_w		varchar(30);
qt_material_w			double precision;
nr_seq_lote_fornec_w		bigint;
nr_prescricao_w			bigint;
cd_local_estoque_w		smallint;
cd_local_estoque_ww		smallint;
cd_motivo_baixa_w			varchar(1);
nr_seq_cabine_w			bigint;
cd_estabelecimento_w		smallint;
ie_estoque_w			varchar(1);
VarRegraLocalEstoque_w 		varchar(1);
ie_controlador_estoque_w 		varchar(1);
ie_lanca_conta_w	 		varchar(1);
dt_inicio_preparo_w			timestamp;
ie_generico_w			varchar(1);
dt_prescricao_w			timestamp;

ds_material_w			varchar(255);
cd_cgc_estab_saida_w		varchar(14);
cd_cgc_estab_entrada_w		varchar(14);
nr_seq_nf_saida_w			bigint;
nr_nota_fiscal_saida_w		varchar(255);
nr_seq_nf_entrada_w		bigint;
nr_nota_fiscal_entrada_w		varchar(255);
ie_tipo_conta_w			integer;
qt_nota_w			integer;
nr_item_nf_w			integer;
cd_unidade_medida_estoque_w	varchar(30);
qt_prevista_entrega_w		double precision;
qt_item_estoque_w			double precision;
vl_total_item_nf_w			double precision;
vl_liquido_w			double precision;
vl_desconto_w			double precision;
qt_conv_compra_estoque_w		double precision;
vl_unitario_item_nf_w		double precision;
dt_mesano_vigente_w		timestamp;
cd_material_estoque_w		integer;
cd_conta_contabil_w		varchar(20);
cd_centro_conta_w			integer;
nr_seq_conta_financeira_w		bigint;
qt_itens_nota_w			integer;
ds_erro_item_w			varchar(4000);
ds_erro_nota_w			varchar(4000);
ds_erro_w			varchar(4000);

c01 CURSOR FOR
SELECT	coalesce(a.nr_atendimento,c.nr_atendimento),
	b.cd_material,
	b.cd_unidade_medida_real,
	b.qt_dose_real,
	c.dt_prescricao,
	a.nr_prescricao,
	b.cd_motivo_baixa,
	c.cd_setor_atendimento,
	b.nr_seq_lote_fornec
from	prescr_medica c,
	can_ordem_prod_mat b,
	can_ordem_prod a
where	a.nr_sequencia	= nr_seq_ordem_p
and	a.nr_prescricao	= c.nr_prescricao
and	a.nr_sequencia	= b.nr_seq_ordem
and	((ie_lanca_conta_w = 'S') or (cd_motivo_baixa_w IS NOT NULL AND cd_motivo_baixa_w::text <> ''));


BEGIN
delete 	FROM w_nota_fiscal_consist
where	nm_usuario = nm_usuario_p;

ds_erro_w := null;

select	c.cd_local_estoque,
	b.nr_seq_cabine,
	a.cd_estabelecimento,
	a.dt_inicio_preparo
into STRICT	cd_local_estoque_w,
	nr_seq_cabine_w,
	cd_estabelecimento_w,
	dt_inicio_preparo_w
from	far_cabine_seg_biol c,
	far_etapa_producao b,
	can_ordem_prod a
where	a.nr_sequencia	= nr_seq_ordem_p
and	b.nr_sequencia	= a.nr_seq_etapa_prod
and	b.nr_seq_cabine	= c.nr_sequencia;

ie_generico_w := Obter_Param_Usuario(3130, 149, obter_perfil_ativo, nm_usuario_p, cd_estab_saida_p, ie_generico_w);
VarRegraLocalEstoque_w := Obter_Param_Usuario(3130, 158, obter_perfil_ativo, nm_usuario_p, cd_estab_saida_p, VarRegraLocalEstoque_w);
ie_controlador_estoque_w := Obter_Param_Usuario(3130, 167, obter_perfil_ativo, nm_usuario_p, cd_estab_saida_p, ie_controlador_estoque_w);
ie_lanca_conta_w := Obter_Param_Usuario(3130, 172, obter_perfil_ativo, nm_usuario_p, cd_estab_saida_p, ie_lanca_conta_w);

open	c01;
loop
fetch	c01 into
	nr_atendimento_w,
	cd_material_w,
	cd_unidade_medida_w,
	qt_material_w,
	dt_prescricao_w,
	nr_prescricao_w,
	cd_motivo_baixa_w,
	cd_setor_atendimento_w,
	nr_seq_lote_fornec_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin	
	cd_local_estoque_ww := cd_local_estoque_w;
	if (VarRegraLocalEstoque_w  = 'S') then
		begin
		select	max(nr_sequencia)
		into STRICT 	nr_seq_prescr_w
		from 	prescr_material 
		where	nr_prescricao	= nr_prescricao_w
		and	((cd_material	= cd_material_w) or ((cd_material_w = obter_material_generico(cd_material)) 
		and (ie_generico_w = 'S')));

		cd_local_estoque_ww := obter_local_disp_prescr(nr_prescricao_w, nr_seq_prescr_w, obter_perfil_ativo, nm_usuario_p);
		
		if (coalesce(cd_local_estoque_ww::text, '') = '') then
			cd_local_estoque_ww := cd_local_estoque_w;
		end if;
		end;
	end if;
	
	ie_estoque_w := Obter_Disp_estoque(	
		cd_material_w, cd_local_estoque_ww, cd_estab_entrada_p, 0, qt_material_w, '', ie_estoque_w);
				
	if (ie_estoque_w = 'N') then
		begin
		ie_estoque_w := Obter_Disp_estoque(
			cd_material_w, cd_local_saida_p, cd_estab_saida_p, 0, qt_material_w, '', ie_estoque_w);
	
		if (ie_estoque_w = 'S') then
			begin
			if (coalesce(nr_seq_nf_saida_w,0) = 0) then
				begin
				select	nextval('nota_fiscal_seq'),
					substr(obter_cgc_estabelecimento(cd_estab_saida_p),1,14),
					substr(obter_cgc_estabelecimento(cd_estab_entrada_p),1,14)
				into STRICT	nr_seq_nf_saida_w,
					cd_cgc_estab_saida_w,
					cd_cgc_estab_entrada_w
				;
				
				select	nextval('nota_fiscal_seq')
				into STRICT	nr_seq_nf_entrada_w
				;

				select	coalesce(max(somente_numero(nr_ultima_nf)), nr_seq_nf_saida_w) + 1
				into STRICT	nr_nota_fiscal_saida_w
				from	serie_nota_fiscal
				where	cd_serie_nf 		= cd_serie_nf_p
				and	cd_estabelecimento 	= cd_estab_saida_p;

				select	count(*)
				into STRICT	qt_nota_w
				from	nota_fiscal
				where	cd_estabelecimento = cd_estab_saida_p
				and	cd_cgc_emitente = cd_cgc_estab_saida_w
				and	cd_serie_nf = cd_serie_nf_p
				and	nr_nota_fiscal = nr_nota_fiscal_saida_w;

				if (qt_nota_w > 0) then
					select (coalesce(max(somente_numero(nr_nota_fiscal)),'0')+1)
					into STRICT	nr_nota_fiscal_saida_w
					from	nota_fiscal
					where	cd_estabelecimento = cd_estab_saida_p
					and	cd_cgc_emitente = cd_cgc_estab_saida_w
					and	cd_serie_nf = cd_serie_nf_p;
				end if;
				
				nr_nota_fiscal_entrada_w := nr_nota_fiscal_saida_w;
				
				select	count(*)
				into STRICT	qt_nota_w
				from	nota_fiscal
				where	cd_estabelecimento = cd_estab_entrada_p
				and	cd_cgc_emitente = cd_cgc_estab_saida_w
				and	cd_serie_nf = cd_serie_nf_p
				and	nr_nota_fiscal = nr_nota_fiscal_entrada_w;
				
				if (qt_nota_w > 0) then
					select (coalesce(max(somente_numero(nr_nota_fiscal)),'0')+1)
					into STRICT	nr_nota_fiscal_saida_w
					from	nota_fiscal
					where	cd_estabelecimento = cd_estab_entrada_p
					and	cd_cgc_emitente = cd_cgc_estab_saida_w
					and	cd_serie_nf = cd_serie_nf_p;
				end if;				

				insert into nota_fiscal(
					nr_sequencia,		cd_estabelecimento,
					cd_cgc_emitente,		cd_serie_nf,
					nr_nota_fiscal,		nr_sequencia_nf,
					cd_operacao_nf,		dt_emissao,
					dt_entrada_saida,		ie_acao_nf,
					ie_emissao_nf,		ie_tipo_frete,
					vl_mercadoria,		vl_total_nota,
					qt_peso_bruto,		qt_peso_liquido,
					dt_atualizacao,		nm_usuario,
					cd_condicao_pagamento,	cd_cgc,
					vl_ipi,
					vl_descontos,		vl_frete,
					vl_seguro,		vl_despesa_acessoria,
					ds_observacao,		cd_natureza_operacao,
					vl_desconto_rateio,		ie_situacao,
					ie_tipo_nota,		ie_entregue_bloqueto)
				values ( nr_seq_nf_saida_w,		cd_estab_saida_p,
					cd_cgc_estab_saida_w,	cd_serie_nf_p,
					nr_nota_fiscal_saida_w,	'1',
					cd_operacao_nf_saida_p,	clock_timestamp(),
					clock_timestamp(),			'1',
					'0',			'0',
					0,			0,
					0,			0,
					clock_timestamp(),			nm_usuario_p,
					cd_cond_pagto_p,		cd_cgc_estab_entrada_w,
					0,
					0,			0,
					0,			0,
					null,			cd_nat_oper_nf_saida_p,
					0,			'1',
					'ST',			'N');
					
				CALL gerar_historico_nota_fiscal(nr_seq_nf_saida_w, nm_usuario_p, '17', wheb_mensagem_pck.get_Texto(310565)); /*'Geração da nota'*/
				
				insert into nota_fiscal(
					nr_sequencia,		cd_estabelecimento,
					cd_cgc_emitente,		cd_serie_nf,
					nr_nota_fiscal,		nr_sequencia_nf,
					cd_operacao_nf,		dt_emissao,
					dt_entrada_saida,		ie_acao_nf,
					ie_emissao_nf,		ie_tipo_frete,
					vl_mercadoria,		vl_total_nota,
					qt_peso_bruto,		qt_peso_liquido,
					dt_atualizacao,		nm_usuario,
					cd_condicao_pagamento,	cd_cgc,
					vl_ipi,
					vl_descontos,		vl_frete,
					vl_seguro,		vl_despesa_acessoria,
					ds_observacao,		cd_natureza_operacao,
					vl_desconto_rateio,		ie_situacao,
					ie_tipo_nota,		ie_entregue_bloqueto)
				values ( nr_seq_nf_entrada_w,		cd_estab_entrada_p,
					cd_cgc_estab_saida_w,	cd_serie_nf_p,
					nr_nota_fiscal_saida_w,	'1',
					cd_operacao_nf_entrada_p, 	clock_timestamp(),
					clock_timestamp(),			'1',
					'0',			'0',
					0,			0,
					0,			0,
					clock_timestamp(),			nm_usuario_p,
					cd_cond_pagto_p,		cd_cgc_estab_entrada_w,
					0,
					0,			0,
					0,			0,
					null,			cd_nat_oper_nf_entrada_p,
					0,			'1',
					'EN',			'N');
					
				CALL gerar_historico_nota_fiscal(nr_seq_nf_entrada_w, nm_usuario_p, '17', wheb_mensagem_pck.get_Texto(310565)); /*'Geração da nota'*/
				end;
			end if;
			
			select	coalesce(max(nr_item_nf), 0) + 1
			into STRICT	nr_item_nf_w
			from	nota_fiscal_item
			where	nr_sequencia = nr_seq_nf_saida_w;

			select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_estoque,
				qt_conv_compra_estoque,
				cd_material_estoque
			into STRICT	cd_unidade_medida_estoque_w,
				qt_conv_compra_estoque_w,
				cd_material_estoque_w
			from	material
			where	cd_material = cd_material_w;
			
			qt_prevista_entrega_w 	:= qt_material_w;

			qt_item_estoque_w	:= dividir(qt_prevista_entrega_w,qt_conv_compra_estoque_w);
			if (cd_unidade_medida_w = cd_unidade_medida_estoque_w) then
				qt_item_estoque_w	:= qt_prevista_entrega_w;
			end if;
			
			vl_unitario_item_nf_w 	:= coalesce(obter_valor_item_transf_etq(cd_estab_saida_p, cd_material_w, cd_unidade_medida_w),0);	
			vl_total_item_nf_w		:= coalesce((qt_prevista_entrega_w * vl_unitario_item_nf_w),0);
			vl_unitario_item_nf_w 	:= coalesce(dividir(vl_total_item_nf_w,qt_prevista_entrega_w),0);
			vl_desconto_w		:= 0;
			vl_liquido_w		:= coalesce(vl_total_item_nf_w,0);

			ie_tipo_conta_w	:= 2;

			SELECT * FROM define_conta_material(
				cd_estab_saida_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_saida_p, cd_operacao_nf_saida_p, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;

			insert into nota_fiscal_item(
				nr_sequencia,			cd_estabelecimento,
				cd_cgc_emitente,			cd_serie_nf,
				nr_nota_fiscal,			nr_sequencia_nf,
				nr_item_nf,			cd_natureza_operacao,
				qt_item_nf,			vl_unitario_item_nf,
				vl_total_item_nf,			dt_atualizacao,
				nm_usuario,			vl_frete,
				vl_desconto,			vl_despesa_acessoria,
				cd_material,			cd_local_estoque,
				ds_observacao,			cd_unidade_medida_compra,		
				qt_item_estoque,			cd_unidade_medida_estoque,		
				cd_conta_contabil,			vl_desconto_rateio,			
				vl_seguro,			cd_material_estoque,
				vl_liquido,				pr_desconto,			
				nr_seq_conta_financ,		pr_desc_financ,
				cd_sequencia_parametro)
			values (	nr_seq_nf_saida_w,			cd_estab_saida_p,
				cd_cgc_estab_saida_w,		cd_serie_nf_p,
				nr_nota_fiscal_saida_w,		'1',
				nr_item_nf_w,			cd_nat_oper_nf_saida_p,
				qt_prevista_entrega_w,		vl_unitario_item_nf_w,
				vl_total_item_nf_w,			clock_timestamp(),
				nm_usuario_p, 			0,
				coalesce(vl_desconto_w,0),		0,
				cd_material_w, 			cd_local_saida_p,
				'',				cd_unidade_medida_w,		
				qt_item_estoque_w,			cd_unidade_medida_estoque_w,	
				cd_conta_contabil_w,		0,				
				0,				cd_material_estoque_w,		
				vl_liquido_w,			0,
				nr_seq_conta_financeira_w,	0,
				philips_contabil_pck.get_parametro_conta_contabil);
				
			SELECT * FROM define_conta_material(
				cd_estab_entrada_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_ww, cd_operacao_nf_entrada_p, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;

			insert into nota_fiscal_item(
				nr_sequencia,			cd_estabelecimento,
				cd_cgc_emitente,			cd_serie_nf,
				nr_nota_fiscal,			nr_sequencia_nf,
				nr_item_nf,			cd_natureza_operacao,
				qt_item_nf,			vl_unitario_item_nf,
				vl_total_item_nf,			dt_atualizacao,
				nm_usuario,			vl_frete,
				vl_desconto,			vl_despesa_acessoria,
				cd_material,			cd_local_estoque,
				ds_observacao,			cd_unidade_medida_compra,		
				qt_item_estoque,			cd_unidade_medida_estoque,		
				cd_conta_contabil,			vl_desconto_rateio,			
				vl_seguro,			cd_material_estoque,
				vl_liquido,				pr_desconto,			
				nr_seq_conta_financ,		pr_desc_financ,
				cd_sequencia_parametro)
			values (	nr_seq_nf_entrada_w,		cd_estab_entrada_p,
				cd_cgc_estab_saida_w,		cd_serie_nf_p,
				nr_nota_fiscal_saida_w,		'1',
				nr_item_nf_w,			cd_nat_oper_nf_entrada_p,
				qt_prevista_entrega_w,		vl_unitario_item_nf_w,
				vl_total_item_nf_w,			clock_timestamp(),
				nm_usuario_p, 			0,
				coalesce(vl_desconto_w,0),		0,
				cd_material_w, 			cd_local_estoque_ww,
				'',				cd_unidade_medida_w,		
				qt_item_estoque_w,			cd_unidade_medida_estoque_w,	
				cd_conta_contabil_w,		0,				
				0,				cd_material_estoque_w,		
				vl_liquido_w,			0,
				nr_seq_conta_financeira_w,	0,
				philips_contabil_pck.get_parametro_conta_contabil);
			end;
		else
			begin
			select	ds_material
			into STRICT	ds_material_w
			from	material
			where	cd_material = cd_material_w;

			ds_erro_w := wheb_mensagem_pck.get_Texto(310570, 'DS_MATERIAL_W='|| DS_MATERIAL_W); /*'O material ' || ds_material_w || ' não tem saldo suficiente no estoque.';*/
			
			insert into w_nota_fiscal_consist(
				nr_sequencia,
				ds_titulo,
				ds_log,
				dt_atualizacao,
				nm_usuario)
			values (nextval('w_nota_fiscal_consist_seq'),
				wheb_mensagem_pck.get_Texto(310576), /*'Material sem estoque para transferência.'*/
				ds_erro_w,
				clock_timestamp(),
				nm_usuario_p);
			end;
		end if;
		end;
	end if;
	end;
end loop;
close c01;

if (coalesce(nr_seq_nf_saida_w,0) > 0) then
	begin
	
	begin
	CALL atualiza_total_nota_fiscal(nr_seq_nf_saida_w,nm_usuario_p);
	exception when others then
		ds_erro_w := substr(sqlerrm(SQLSTATE),1,4000);
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310580, 'NR_SEQ_NF_SAIDA_W='|| NR_SEQ_NF_SAIDA_W), /*('Atualizar total da nota de saída ' || nr_seq_nf_saida_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
	end;
	
	begin
	SELECT * FROM consistir_nota_fiscal(nr_seq_nf_saida_w, nm_usuario_p, ds_erro_item_w, ds_erro_nota_w) INTO STRICT ds_erro_item_w, ds_erro_nota_w;
	exception when others then
		ds_erro_w := substr(sqlerrm(SQLSTATE),1,4000);
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310581, 'NR_SEQ_NF_SAIDA_W='|| NR_SEQ_NF_SAIDA_W), /*('Consistir nota de saída ' || nr_seq_nf_saida_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
	end;

	
	if (ds_erro_item_w IS NOT NULL AND ds_erro_item_w::text <> '') then
		begin
		ds_erro_w := ds_erro_item_w;
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310586, 'NR_SEQ_NF_SAIDA_W='|| NR_SEQ_NF_SAIDA_W), /*('Consistir nota de saída ' || nr_seq_nf_saida_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end if;

	
	if (ds_erro_nota_w IS NOT NULL AND ds_erro_nota_w::text <> '') then
		begin
		ds_erro_w := ds_erro_nota_w;
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310587, 'NR_SEQ_NF_SAIDA_W='|| NR_SEQ_NF_SAIDA_W), /*('Consistir itens da nota de saída ' || nr_seq_nf_saida_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end if;

	
	select 	count(*)
	into STRICT	qt_itens_nota_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_seq_nf_saida_w;
	
	if (qt_itens_nota_w = 0) then
		begin
		ds_erro_w := wheb_mensagem_pck.get_Texto(310589, 'NR_SEQ_NF_SAIDA_W='|| NR_SEQ_NF_SAIDA_W); /*'A nota fiscal de saída ' || nr_seq_nf_saida_w || ' não possuem itens para serem gerados.';*/
		
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values (nextval('w_nota_fiscal_consist_seq'),			
			wheb_mensagem_pck.get_Texto(310590), /*'Nota fiscal de saída sem itens.',*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end if;	
	
	begin
	CALL atualiza_total_nota_fiscal(nr_seq_nf_entrada_w,nm_usuario_p);
	exception when others then
		ds_erro_w := substr(sqlerrm(SQLSTATE),1,4000);
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310591, 'NR_SEQ_NF_ENTRADA_W='|| NR_SEQ_NF_ENTRADA_W), /*('Atualizar total da nota de entrada ' || nr_seq_nf_entrada_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);				
	end;	
	begin
	SELECT * FROM consistir_nota_fiscal(nr_seq_nf_entrada_w, nm_usuario_p, ds_erro_item_w, ds_erro_nota_w) INTO STRICT ds_erro_item_w, ds_erro_nota_w;
	exception when others then
		ds_erro_w := substr(sqlerrm(SQLSTATE),1,4000);
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310592, 'NR_SEQ_NF_ENTRADA_W='|| NR_SEQ_NF_ENTRADA_W), /*('Consistir nota de entrada ' || nr_seq_nf_entrada_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
	end;	

	
	if (ds_erro_item_w IS NOT NULL AND ds_erro_item_w::text <> '') then
		begin
		ds_erro_w := ds_erro_item_w;
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310593, 'NR_SEQ_NF_ENTRADA_W='|| NR_SEQ_NF_ENTRADA_W), /*('Consistir itens da nota de entrada ' || nr_seq_nf_entrada_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end if;

	
	if (ds_erro_nota_w IS NOT NULL AND ds_erro_nota_w::text <> '') then
		begin
		ds_erro_w := ds_erro_nota_w;
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values	(nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310595, 'NR_SEQ_NF_ENTRADA_W='|| NR_SEQ_NF_ENTRADA_W), /*('Consistir nota de entrada ' || nr_seq_nf_entrada_w || '.'),*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end if;

	select 	count(*)
	into STRICT	qt_itens_nota_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_seq_nf_entrada_w;
	
	if (qt_itens_nota_w = 0) then
		begin
		ds_erro_w := wheb_mensagem_pck.get_Texto(310596, 'NR_SEQ_NF_ENTRADA_W='|| NR_SEQ_NF_ENTRADA_W); /*'A nota fiscal de entrada ' || nr_seq_nf_entrada_w || ' não possuem itens para serem gerados.';*/
		
		insert into w_nota_fiscal_consist(
			nr_sequencia,
			ds_titulo,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values (nextval('w_nota_fiscal_consist_seq'),
			wheb_mensagem_pck.get_Texto(310597), /*'Nota fiscal de entrada sem itens.',*/
			ds_erro_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end if;	
	
	if (coalesce(ds_erro_w::text, '') = '') then
		begin
		
		begin
		CALL Atualizar_Nota_Fiscal(nr_seq_nf_saida_w,'I',nm_usuario_p,3);
		exception when others then
			ds_erro_w := substr(sqlerrm(SQLSTATE),1,4000);
			insert into w_nota_fiscal_consist(
				nr_sequencia,
				ds_titulo,
				ds_log,
				dt_atualizacao,
				nm_usuario)
			values	(nextval('w_nota_fiscal_consist_seq'),
				wheb_mensagem_pck.get_Texto(310599, 'NR_SEQ_NF_SAIDA_W='|| NR_SEQ_NF_SAIDA_W), /*('Calcular nota de saída ' || nr_seq_nf_saida_w || '.'),*/
				ds_erro_w,
				clock_timestamp(),
				nm_usuario_p);
		end;
		
		end;
	end if;
	
	
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		begin
		delete 	FROM nota_fiscal
		where	nr_sequencia = nr_seq_nf_saida_w;	
		delete 	FROM nota_fiscal
		where	nr_sequencia = nr_seq_nf_entrada_w;
		end;
	else
		begin
	
		begin
		CALL Atualizar_Nota_Fiscal(nr_seq_nf_entrada_w,'I',nm_usuario_p,0);
		exception when others then
			ds_erro_w := substr(sqlerrm(SQLSTATE),1,4000);
			insert into w_nota_fiscal_consist(
				nr_sequencia,
				ds_titulo,
				ds_log,
				dt_atualizacao,
				nm_usuario)
			values	(nextval('w_nota_fiscal_consist_seq'),
				wheb_mensagem_pck.get_Texto(310600, 'NR_SEQ_NF_ENTRADA_W='|| NR_SEQ_NF_ENTRADA_W), /*('Calcular nota de entrada ' || nr_seq_nf_entrada_w || '.'),*/
				ds_erro_w,
				clock_timestamp(),
				nm_usuario_p);
		end;
		
		end;
	end if;
	end;
	
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nf_transf_prescr_cmiv ( nr_seq_ordem_p bigint, cd_estab_entrada_p bigint, cd_estab_saida_p bigint, cd_local_saida_p bigint, cd_operacao_nf_saida_p bigint, cd_nat_oper_nf_saida_p bigint, cd_operacao_nf_entrada_p bigint, cd_nat_oper_nf_entrada_p bigint, cd_cond_pagto_p bigint, cd_serie_nf_p text, nm_usuario_p text) FROM PUBLIC;
