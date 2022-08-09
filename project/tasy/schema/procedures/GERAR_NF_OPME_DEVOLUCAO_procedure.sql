-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nf_opme_devolucao ( cd_estabelecimento_p bigint, cd_cgc_fornecedor_p text, nr_seq_agenda_p bigint, nm_usuario_p text, dt_emissao_p timestamp, qt_material_devol_p bigint, nr_seq_nf_entrada_p bigint, nr_item_nf_p bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE



nr_sequencia_opme_w		bigint;
nr_sequencia_w			bigint;
nr_sequencia_nf_w			bigint;
nr_item_nf_w			integer;
cd_material_w			integer;	
qt_material_w			double precision;
cd_unidade_medida_compra_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
cd_material_estoque_w		integer	:= null;
ie_consignado_w			varchar(01);
cd_operacao_estoque_w		bigint;
ie_tipo_conta_w			integer	:= 2;
cd_conta_contabil_w		varchar(20)	:= null;
cd_centro_conta_w			integer;
qt_existe_w			integer;
vl_unitario_item_w			double precision;
vl_desconto_w			double precision;
valor_total_item_w			double precision;
pr_desconto_w			double precision;
cd_cond_pagto_w			bigint;
qt_item_estoque_w			double precision;
qt_conv_compra_estoque_w		double precision;
cd_centro_custo_w			integer;
cd_operacao_nota_saida_w		bigint;
cd_operacao_nota_entrada_w	bigint;
cd_natureza_operacao_entrada_w	bigint;
cd_natureza_operacao_saida_w	bigint;
cd_local_estoque_w		smallint;
cd_setor_atendimento_w		integer;
nr_nota_fiscal_w			varchar(255);


BEGIN

select	coalesce((max(obter_valor_param_usuario(1750, 14, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p))),'0'),
	coalesce((max(obter_valor_param_usuario(1750, 27, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p))),'0'),
	coalesce((max(obter_valor_param_usuario(1750, 30, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p))),'0')
into STRICT	cd_centro_custo_w,
	cd_operacao_nota_saida_w,
	cd_natureza_operacao_saida_w
;

if (cd_operacao_nota_saida_w = '0') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266010);
	--'É necessário informar a operação da nota para geração da mesma.' || chr(13) || chr(10) || 'Verifique o parâmetro [27]'
end if;
if (cd_natureza_operacao_saida_w = '0') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266011);
	--'É necessário informar a natureza da nota para geração da mesma.' || chr(13) || chr(10) || 'Verifique o parâmetro [30]'
end if;	

select	coalesce(max(b.ie_consignado),0),
	coalesce(max(b.cd_operacao_estoque),0)
into STRICT	ie_consignado_w,
	cd_operacao_estoque_w
from	operacao_estoque b,
	operacao_nota a
where	a.cd_operacao_estoque	= b.cd_operacao_estoque
and	a.cd_operacao_nf	= cd_natureza_operacao_entrada_w;

if (nr_sequencia_p = 0) then

	nr_sequencia_w		:= 0;
	
	select	coalesce(max(cd_setor_atendimento),0),
		nr_nota_fiscal
	into STRICT	cd_setor_atendimento_w,
		nr_nota_fiscal_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_seq_nf_entrada_p
	group by nr_nota_fiscal;

	if (nr_sequencia_w = 0) then
				
		select 	max(cd_condicao_pagamento)
		into STRICT	cd_cond_pagto_w
		from 	nota_fiscal
		where 	nr_nota_fiscal = nr_nota_fiscal_w;

		select	nextval('nota_fiscal_seq')
		into STRICT	nr_sequencia_w
		;

		insert	into nota_fiscal(
			nr_sequencia,
			cd_estabelecimento,
			cd_cgc_emitente,
			cd_serie_nf,       
			nr_sequencia_nf,
			cd_operacao_nf,
			dt_emissao,
			dt_entrada_saida,
			ie_acao_nf,
			ie_emissao_nf,
			ie_tipo_frete,
			vl_mercadoria,
			vl_total_nota,
			qt_peso_bruto,
			qt_peso_liquido,
			vl_ipi,
			vl_descontos,
			vl_frete,
			vl_seguro,
			vl_despesa_acessoria,
			dt_atualizacao,
			nm_usuario,
			nr_nota_fiscal,
			cd_cgc,
			cd_natureza_operacao,
			ie_situacao,
			ie_entregue_bloqueto,
			cd_setor_digitacao,
			ie_tipo_nota,
			cd_condicao_pagamento,
			nr_seq_agenda_pac)
		values (	nr_sequencia_w,
			cd_estabelecimento_p,
			cd_cgc_fornecedor_p,
			1,
			1,
			cd_operacao_nota_saida_w,
			dt_emissao_p,
			clock_timestamp(),
			1,
			0,
			0,
			0,
			0,
			0,
			0,
			0,0,0,0,0,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_w,
			cd_cgc_fornecedor_p,
			cd_natureza_operacao_saida_w,
			1,
			'N',
			cd_setor_atendimento_w,
			'SE',
			cd_cond_pagto_w,
			nr_seq_agenda_p);
	end if;
end if;

if (nr_sequencia_p > 0) or (nr_sequencia_w > 0) then
	
	if (nr_sequencia_p > 0) then
		nr_sequencia_w := nr_sequencia_p;
	end if;
	
	select (coalesce(max(nr_sequencia_nf),0) + 1)
	into STRICT	nr_sequencia_nf_w
	from	nota_fiscal
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_cgc_emitente		= cd_cgc_fornecedor_p;
	
	-- Busca os itens da nota
	select	cd_material,
		cd_local_estoque,
		nr_seq_ag_pac_opme,
		vl_unitario_item_nf,
		vl_desconto
	into STRICT	cd_material_w,
		cd_local_estoque_w,
		nr_sequencia_opme_w,
		vl_desconto_w,
		vl_unitario_item_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_seq_nf_entrada_p
	and	nr_seq_agenda_pac = nr_seq_agenda_p
	and	nr_item_nf = nr_item_nf_p;
	
	select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMC'),1,30) cd_unidade_medida_compra,
		substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque,
		cd_material_estoque,
		qt_conv_compra_estoque
	into STRICT	cd_unidade_medida_compra_w,
		cd_unidade_medida_estoque_w,
		cd_material_estoque_w,
		qt_conv_compra_estoque_w
	from	material
	where	cd_material = cd_material_w;

	select (coalesce(max(nr_item_nf),0) + 1)
	into STRICT	nr_item_nf_w
	from	nota_fiscal_item
	where	nr_sequencia	= nr_sequencia_w;
	
	SELECT * FROM define_conta_material(
			cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_w, cd_operacao_estoque_w, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;
	
	valor_total_item_w := round((qt_material_devol_p * vl_unitario_item_w)::numeric,2);
	begin		
		pr_desconto_w :=  ((100 / valor_total_item_w) * vl_desconto_w);
		
	exception
	when others then
		pr_desconto_w := 0;
	end;
	
	qt_item_estoque_w	:= qt_material_devol_p * qt_conv_compra_estoque_w;

	insert into nota_fiscal_item(
		cd_estabelecimento,
		cd_cgc_emitente,
		cd_serie_nf,
		nr_nota_fiscal,
		nr_sequencia_nf,
		nr_item_nf,
		cd_natureza_operacao,
		qt_item_nf,
		qt_item_estoque,
		vl_unitario_item_nf,
		vl_total_item_nf,
		dt_atualizacao,
		nm_usuario,
		vl_frete,
		vl_desconto,
		vl_despesa_acessoria,
		cd_material,
		vl_desconto_rateio,
		vl_seguro,
		nr_sequencia,
		vl_liquido,
		cd_unidade_medida_compra,
		cd_unidade_medida_estoque,
		cd_material_estoque,
		ie_indeterminado,
		cd_local_estoque,
		cd_conta_contabil,
		nr_seq_ag_pac_opme,
		nr_seq_agenda_pac,
		pr_desconto,
		cd_sequencia_parametro)
	values (	cd_estabelecimento_p,
		cd_cgc_fornecedor_p,
		1,
		nr_sequencia_w,
		nr_sequencia_nf_w,
		nr_item_nf_w,
		cd_natureza_operacao_saida_w,
		qt_material_devol_p,
		qt_item_estoque_w,
		vl_unitario_item_w,
		valor_total_item_w,
		clock_timestamp(),
		nm_usuario_p,
		0,
		vl_desconto_w, 
		0,
		cd_material_w,
		0,
		0,
		nr_sequencia_w,
		(valor_total_item_w - vl_desconto_w),
		cd_unidade_medida_compra_w,
		cd_unidade_medida_estoque_w,
		cd_material_estoque_w,
		'N',
		cd_local_estoque_w,
		cd_conta_contabil_w,
		nr_sequencia_opme_w,
		nr_seq_agenda_p,
		pr_desconto_w,
		philips_contabil_pck.get_parametro_conta_contabil);
end if;

nr_sequencia_p := nr_sequencia_w;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nf_opme_devolucao ( cd_estabelecimento_p bigint, cd_cgc_fornecedor_p text, nr_seq_agenda_p bigint, nm_usuario_p text, dt_emissao_p timestamp, qt_material_devol_p bigint, nr_seq_nf_entrada_p bigint, nr_item_nf_p bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
