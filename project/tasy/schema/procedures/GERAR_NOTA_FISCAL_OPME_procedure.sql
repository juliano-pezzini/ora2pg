-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_fiscal_opme ( cd_estabelecimento_p bigint, cd_cgc_fornecedor_p text, nr_seq_agenda_p bigint, nm_usuario_p text, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_operacao_nota_p bigint, cd_natureza_operacao_p bigint, dt_emissao_p timestamp, cd_setor_digitacao_p bigint, cd_local_estoque_p bigint, ie_tipo_nota_p text, nr_sequencia_p INOUT bigint) AS $body$
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
vl_desconto_ww			double precision;
valor_total_item_w			double precision;
pr_desconto_w			double precision;
cd_cond_pagto_w			bigint;
qt_item_estoque_w			double precision;
qt_conv_compra_estoque_w		double precision;
cd_centro_custo_w			integer;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_material,
	coalesce(a.vl_unitario_item,0),
	coalesce(a.vl_desconto,0),
	a.cd_cond_pagto,
	a.qt_material -
	(SELECT	coalesce(sum(n.qt_item_nf), 0)
	from	nota_fiscal_item n
	where	n.nr_seq_ag_pac_opme	= a.nr_sequencia	
	and	n.nr_seq_agenda_pac	= b.nr_sequencia) qt_material
from 	agenda_pac_opme a,
	agenda_paciente b
where	b.nr_sequencia	= a.nr_seq_agenda
and	b.nr_sequencia	= nr_seq_agenda_p
and	a.cd_cgc		= cd_cgc_fornecedor_p
and	(b.ie_opme_integracao IS NOT NULL AND b.ie_opme_integracao::text <> '')
and	substr(obter_regra_int_opme_material(a.cd_material, '01'),1,1) = 'S'
and	a.qt_material		> (
	select	coalesce(sum(n.qt_item_nf), 0)
	from	nota_fiscal_item n
	where	n.nr_seq_ag_pac_opme	= a.nr_sequencia
	and	n.nr_seq_agenda_pac	= b.nr_sequencia);
	
	
c02 CURSOR FOR
SELECT 	a.nr_sequencia,
	a.cd_material,
	coalesce(a.vl_unitario_item,0),
	coalesce(a.vl_desconto,0),
	a.cd_cond_pagto,
	substr(CASE WHEN obter_regra_int_opme_material(a.cd_material, '01')='S' THEN		campo_mascara_virgula(		sum((SELECT  coalesce(sum(n.qt_item_nf),0)	   	        from 	    nota_fiscal_item n	    	        where  n.nr_seq_ag_pac_opme = a.nr_sequencia		        and	    obter_se_nota_entrada_saida(n.nr_sequencia) = 'E'		        and	    n.nr_seq_agenda_pac  = b.nr_sequencia)))  ELSE 0 END ,1,20) - coalesce((obter_qt_mat_integracao_opme(a.nr_seq_agenda, a.nr_sequencia, 'F')),0) qt_devolucao
from 	agenda_pac_opme a,
  	agenda_paciente b
where   b.nr_sequencia = a.nr_seq_agenda
and	(b.ie_opme_integracao IS NOT NULL AND b.ie_opme_integracao::text <> '')
and    	a.ie_integracao = 'S'
and	b.nr_sequencia  = nr_seq_agenda_p
and	a.cd_cgc	= cd_cgc_fornecedor_p
group by a.nr_sequencia,
	a.nr_seq_agenda,
	a.cd_material,
	coalesce(a.vl_unitario_item,0),
	coalesce(a.vl_desconto,0),
	a.cd_cond_pagto
order by cd_material;	
	

BEGIN
cd_centro_custo_w := obter_param_usuario(1750, 14, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_centro_custo_w);

select	coalesce(max(b.ie_consignado),0),
	coalesce(max(b.cd_operacao_estoque),0)
into STRICT	ie_consignado_w,
	cd_operacao_estoque_w
from	operacao_estoque b,
	operacao_nota a
where	a.cd_operacao_estoque	= b.cd_operacao_estoque
and	a.cd_operacao_nf	= cd_operacao_nota_p;

select (coalesce(max(nr_sequencia_nf),0) + 1)
into STRICT	nr_sequencia_nf_w
from	nota_fiscal
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_cgc_emitente		= cd_cgc_fornecedor_p
and	nr_nota_fiscal		= nr_nota_fiscal_p
and	cd_serie_nf		= cd_serie_nf_p;

nr_sequencia_w		:= 0;


/*Cursor específico para as notas de Entrada*/

if (ie_tipo_nota_p = 'EN') then
	open C01;
	loop
	fetch C01 into	
		nr_sequencia_opme_w,
		cd_material_w,
		vl_unitario_item_w,
		vl_desconto_w,
		cd_cond_pagto_w,
		qt_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_sequencia_w = 0) then
			begin

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
				cd_serie_nf_p,
				1,
				cd_operacao_nota_p,
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
				nr_nota_fiscal_p,
				cd_cgc_fornecedor_p,
				cd_natureza_operacao_p,
				1,
				'N',
				cd_setor_digitacao_p,
				ie_tipo_nota_p,
				cd_cond_pagto_w,
				nr_seq_agenda_p);
			end;
		end if;

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
				cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_p, cd_operacao_estoque_w, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;

		valor_total_item_w	:= (qt_material_w * vl_unitario_item_w);
		vl_desconto_ww		:= (vl_desconto_w * qt_material_w);
		pr_desconto_w		:= dividir((vl_desconto_ww * 100), valor_total_item_w);
		qt_item_estoque_w	:= qt_material_w * qt_conv_compra_estoque_w;

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
			cd_centro_custo,
			cd_sequencia_parametro)
		values (	cd_estabelecimento_p,
			cd_cgc_fornecedor_p,
			cd_serie_nf_p,
			nr_nota_fiscal_p,
			nr_sequencia_nf_w,
			nr_item_nf_w,
			cd_natureza_operacao_p,
			qt_material_w,
			qt_item_estoque_w,
			vl_unitario_item_w,
			valor_total_item_w,
			clock_timestamp(),
			nm_usuario_p,
			0,
			vl_desconto_ww,
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
			cd_local_estoque_p,
			cd_conta_contabil_w,
			nr_sequencia_opme_w,
			nr_seq_agenda_p,
			pr_desconto_w,
			cd_centro_custo_w,
			philips_contabil_pck.get_parametro_conta_contabil);
		end;
	end loop;
	close C01;
end if;


/*Cursor específico para as notas de Saida*/

if (ie_tipo_nota_p = 'SD') then
	open C02;
	loop
	fetch C02 into	
		nr_sequencia_opme_w,
		cd_material_w,
		vl_unitario_item_w,
		vl_desconto_w,
		cd_cond_pagto_w,
		qt_material_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (nr_sequencia_w = 0) then
			begin

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
				cd_serie_nf_p,
				1,
				cd_operacao_nota_p,
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
				nr_nota_fiscal_p,
				cd_cgc_fornecedor_p,
				cd_natureza_operacao_p,
				1,
				'N',
				cd_setor_digitacao_p,
				ie_tipo_nota_p,
				cd_cond_pagto_w,
				nr_seq_agenda_p);
			end;
		end if;

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
				cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_p, cd_operacao_estoque_w, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;

		valor_total_item_w	:= (qt_material_w * vl_unitario_item_w);
		pr_desconto_w		:= dividir((vl_desconto_w * 100),valor_total_item_w);
		qt_item_estoque_w	:= qt_material_w * qt_conv_compra_estoque_w;

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
			cd_centro_custo,
			cd_sequencia_parametro)
		values (	cd_estabelecimento_p,
			cd_cgc_fornecedor_p,
			cd_serie_nf_p,
			nr_nota_fiscal_p,
			nr_sequencia_nf_w,
			nr_item_nf_w,
			cd_natureza_operacao_p,
			qt_material_w,
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
			cd_local_estoque_p,
			cd_conta_contabil_w,
			nr_sequencia_opme_w,
			nr_seq_agenda_p,
			pr_desconto_w,
			cd_centro_custo_w,
			philips_contabil_pck.get_parametro_conta_contabil);
		end;
	end loop;
	close C02;
end if;
	
nr_sequencia_p 		 := nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_fiscal_opme ( cd_estabelecimento_p bigint, cd_cgc_fornecedor_p text, nr_seq_agenda_p bigint, nm_usuario_p text, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_operacao_nota_p bigint, cd_natureza_operacao_p bigint, dt_emissao_p timestamp, cd_setor_digitacao_p bigint, cd_local_estoque_p bigint, ie_tipo_nota_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;
