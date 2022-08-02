-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recebe_nota_xml_cte ( ie_opcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_condicao_pagamento_p bigint, cd_serie_nf_p text, nr_nota_fiscal_p text, dt_emissao_p text, dt_entrada_saida_p text, ie_entrada_saida_p text, cd_cgc_emitente_p text, ds_razao_emit_p text, ds_fantasia_emit_p text, ds_logradouro_emit_p text, nr_endereco_emit_p text, ds_bairro_emit_p text, ds_municipio_emit_p text, ds_uf_emit_p text, cd_cep_emit_p text, ds_pais_emit_p text, nr_telefone_emit_p text, nr_inscr_estadual_emit_p text, nr_danfe_p text, cd_material_p text, qt_item_nf_p bigint, vl_unitario_item_nf_p text, vl_base_calculo_icms_p text, vl_tributo_icms_p text, tx_tributo_icms_p text, vl_base_calculo_pis_p text, vl_tributo_pis_p text, tx_tributo_pis_p text, vl_base_calculo_cofins_p text, vl_tributo_cofins_p text, tx_tributo_cofins_p text, vl_base_calculo_ipi_p text, vl_tributo_ipi_p text, tx_tributo_ipi_p text, nr_sequencia_p INOUT bigint, nr_item_nf_p INOUT bigint, ie_erro_p INOUT text, cd_operacao_nf_p bigint, ds_observacao_p text, cd_procedimento_p bigint, cd_natureza_operacao_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p bigint, cd_local_estoque_p text, nr_seq_classif_trib_p text) AS $body$
DECLARE

/*s
1 - importa a parte do cabecalho da nota fiscal
2 - importa os itens da nota fiscal
3 - importa os tributos do item
*/
nr_sequencia_w			nota_fiscal.nr_sequencia%type;
nr_sequencia_nf_w		nota_fiscal.nr_sequencia_nf%type;
cd_cgc_emitente_w		nota_fiscal.cd_cgc_emitente%type;
cd_tipo_pessoa_w		tipo_pessoa_juridica.cd_tipo_pessoa%type;
qt_existe_w			integer;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nm_usuario_dest_w		varchar(15);
nr_item_nf_w			nota_fiscal_item.nr_item_nf%type;
vl_total_item_nf_w		nota_fiscal_item.vl_total_item_nf%type := 0;
vl_liquido_w			nota_fiscal_item.vl_liquido%type := 0;
cd_tributo_w			tributo.cd_tributo%type;
nr_nota_fiscal_w		nota_fiscal.nr_nota_fiscal%type;
ie_erro_w			varchar(1) := 'N';
ds_texto_padrao_w		varchar(20) := wheb_mensagem_pck.get_texto(306421);
nr_seq_classif_w		bigint;


c01 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	ie_situacao = 'A';


BEGIN
nr_sequencia_w		:= nr_sequencia_p;
cd_cgc_emitente_w 	:= cd_cgc_emitente_p;


if (length(cd_cgc_emitente_p) <> '14') then
	ie_erro_w := 'S';
	--wheb_mensagem_pck.exibir_mensagem_abort(184844);
end if;

/*importa o cabecalho da nota fiscal*/

if (ie_opcao_p = 1) then

	/*se nao tem o cd_cgc_emitente cadastrado no sistema, cadastra automaticamente*/

	select	count(*)
	into STRICT	qt_existe_w
	from	pessoa_juridica
	where	cd_cgc = cd_cgc_emitente_w
	and	ie_situacao = 'A';	
	
	if (qt_existe_w = 0) then
		begin
		
		select	min(cd_tipo_pessoa)
		into STRICT	cd_tipo_pessoa_w
		from	tipo_pessoa_juridica
		where	ie_situacao = 'A'
		and	((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''));		
		
		insert into pessoa_juridica(
			cd_cgc,								ds_razao_social,
			nm_fantasia,							cd_cep,
			ds_endereco,							ds_bairro,
			ds_municipio,							sg_estado,
			dt_atualizacao,							nm_usuario,
			nr_telefone,							nr_endereco,
			nr_inscricao_estadual,						cd_tipo_pessoa,
			ie_prod_fabric,							ie_situacao,
			dt_atualizacao_nrec,						nm_usuario_nrec)
		values (	cd_cgc_emitente_w,						substr(coalesce(ds_razao_emit_p,ds_texto_padrao_w),1,80),
			substr(coalesce(ds_fantasia_emit_p,ds_texto_padrao_w),1,80),		substr(coalesce(cd_cep_emit_p,'0'),1,15),
			substr(coalesce(ds_logradouro_emit_p,ds_texto_padrao_w),1,40),	substr(ds_bairro_emit_p,1,40),
			substr(coalesce(ds_municipio_emit_p,ds_texto_padrao_w),1,40),	substr(coalesce(ds_uf_emit_p,'SP'),1,15),
			clock_timestamp(),							nm_usuario_p,
			substr(nr_telefone_emit_p,1,15),				substr(nr_endereco_emit_p,1,10),			
			substr(nr_inscr_estadual_emit_p,1,20),				cd_tipo_pessoa_w,
			'N',								'A',
			clock_timestamp(),							nm_usuario_p);

    commit;
		
		open c01;
		loop
		fetch c01 into	
			cd_estabelecimento_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			insert into pessoa_juridica_estab(
				nr_sequencia,				cd_cgc,
				cd_estabelecimento,			dt_atualizacao,
				nm_usuario,				dt_atualizacao_nrec,
				nm_usuario_nrec,			ie_conta_dif_nf,
				ie_rateio_adiant,			ie_retem_iss)
			values (	nextval('pessoa_juridica_estab_seq'),	cd_cgc_emitente_w,
				cd_estabelecimento_w,			clock_timestamp(),
				nm_usuario_p,				clock_timestamp(),
				nm_usuario_p,				'N',
				'P',					'N');	
      commit;		
			end;
		end loop;
		close c01;		
		end;
		
		select	obter_usuario_pf(cd_comprador_padrao)
		into STRICT	nm_usuario_dest_w
		from	parametro_compras
		where	cd_estabelecimento = cd_estabelecimento_p;
		
		if (nm_usuario_dest_w IS NOT NULL AND nm_usuario_dest_w::text <> '') then
		
			select	max(obter_classif_comunic('f'))
			into STRICT	nr_seq_classif_w
			;
		
			CALL gerar_comunic_padrao(
				clock_timestamp(),
				wheb_mensagem_pck.get_texto(306433),
				wheb_mensagem_pck.get_texto(306434,'CD_CGC_EMITENTE_W='||cd_cgc_emitente_w),
				nm_usuario_p,
				'N',
				nm_usuario_dest_w,
				'N',         
				nr_seq_classif_w,
				'',
				cd_estabelecimento_p,
				'',
				clock_timestamp(),
				'',
				'');
		end if;
	commit;
	end if;
	/*fim cadastro da pessoa juridica*/

		
	select (coalesce(max(nr_sequencia_nf),0)+1)
	into STRICT 	nr_sequencia_nf_w
	from 	nota_fiscal
	where 	cd_estabelecimento = cd_estabelecimento_p
	and 	cd_cgc_emitente    = cd_cgc_emitente_w
	and 	nr_nota_fiscal     = nr_nota_fiscal_p
	and 	cd_serie_nf        = cd_serie_nf_p;	
		
	select	nextval('nota_fiscal_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into nota_fiscal(	
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
		dt_atualizacao,
		nm_usuario,
		cd_condicao_pagamento,
		cd_cgc,
		vl_ipi,
		vl_descontos,
		vl_frete,
		vl_seguro,
		vl_despesa_acessoria,
		vl_desconto_rateio,
		cd_natureza_operacao,
		ie_situacao,
		nr_lote_contabil,
		ie_entregue_bloqueto,
		ie_tipo_nota,
		nr_nota_fiscal,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_observacao,
    nr_danfe)
	values (	nr_sequencia_w,
		cd_estabelecimento_p,
		cd_cgc_emitente_w,
		cd_serie_nf_p,		
		nr_sequencia_nf_w,	
		cd_operacao_nf_p,
		to_date(substr(dt_emissao_p,9,2) || '/' || substr(dt_emissao_p,6,2) || '/' || substr(dt_emissao_p,1,4),'dd/mm/yy'),
    to_date(clock_timestamp(), 'dd/mm/yy'),
		'1',
		'0',
		'0',
		0,
		0,
		0,
		0,
		clock_timestamp(),
		nm_usuario_p,
		cd_condicao_pagamento_p,
		cd_cgc_emitente_w,
		0,
		0,
		0,
		0,
		0,
		0,
		cd_natureza_operacao_p,		
		'1',
		0,
		'N',
		'EN',
		nr_nota_fiscal_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_observacao_p,
    nr_danfe_p);

  commit;
		
end if;

/*importa os itens*/

if (ie_opcao_p = 2) then
	
	vl_total_item_nf_w	:= round((qt_item_nf_p * vl_unitario_item_nf_p)::numeric,2);
	vl_liquido_w		:= vl_total_item_nf_w;	
	
	
	select	cd_cgc_emitente,
		nr_sequencia_nf,
		nr_nota_fiscal
	into STRICT	cd_cgc_emitente_w,
		nr_sequencia_nf_w,
		nr_nota_fiscal_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_w;
	

		
	select	coalesce(max(nr_item_nf),0) +1
	into STRICT	nr_item_nf_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_sequencia_w;

	
		
	insert into nota_fiscal_item(
		nr_sequencia,
		cd_estabelecimento,
		cd_cgc_emitente,
		cd_serie_nf,
		nr_sequencia_nf,
		nr_item_nf,
		cd_natureza_operacao,
		qt_item_nf,
		vl_unitario_item_nf,
		vl_total_item_nf,
		dt_atualizacao,
		nm_usuario,
		vl_frete,
		vl_desconto,
		vl_despesa_acessoria,
		cd_material,
		cd_procedimento,		
		cd_local_estoque,
		cd_conta_contabil,
		vl_desconto_rateio,
		vl_seguro,
		cd_centro_custo,
		vl_liquido,
		pr_desconto,
		pr_desc_financ,
		vl_desc_financ,
		nr_nota_fiscal,
    nr_seq_classif_trib)		
	values (nr_sequencia_w,
		cd_estabelecimento_p,
		cd_cgc_emitente_w,
		cd_serie_nf_p,
		nr_sequencia_nf_w,
		nr_item_nf_w,
		cd_natureza_operacao_p,
		replace(qt_item_nf_p,'.',','),
		replace(vl_unitario_item_nf_p,'.',','),
		vl_total_item_nf_w,
		clock_timestamp(),
		nm_usuario_p,
		0,
		0,
		0,
		CASE WHEN cd_material_p='' THEN null  ELSE cd_material_p END ,
		CASE WHEN cd_procedimento_p='' THEN null  ELSE cd_procedimento_p END ,
		cd_local_estoque_p,
		cd_conta_contabil_p,
		0,
		0,
		CASE WHEN cd_centro_custo_p=0 THEN null  ELSE cd_centro_custo_p END ,
		vl_liquido_w,
		0,
		0,
		0,
		nr_nota_fiscal_w,
    nr_seq_classif_trib_p);

  commit;
	
end if;

/*importa os tributos do item*/

if (ie_opcao_p = 3) then
	
	nr_item_nf_w := nr_item_nf_p;	

	select	cd_cgc_emitente,
		nr_sequencia_nf,
		nr_nota_fiscal
	into STRICT	cd_cgc_emitente_w,
		nr_sequencia_nf_w,
		nr_nota_fiscal_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_w;
	
	
	/*importa icms*/

	if (tx_tributo_icms_p > 0) then	
		
		select	coalesce(max(cd_tributo),0)
		into STRICT	cd_tributo_w
		from	tributo
		where	ie_situacao = 'A'
		and	ie_corpo_item = 'I'
		and	ie_tipo_tributo = 'ICMS';
	
		if (cd_tributo_w > 0) then
	
			insert into nota_fiscal_item_trib(
				nr_sequencia,
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_sequencia_nf,
				nr_item_nf,
				cd_tributo,
				vl_tributo,
				dt_atualizacao,
				nm_usuario,
				vl_base_calculo,
				tx_tributo,
				vl_reducao_base,
				ie_rateio,
				vl_trib_nao_retido,
				vl_base_nao_retido,
				vl_trib_adic,
				vl_base_adic,
				nr_nota_fiscal)
			values (	nr_sequencia_w,
				cd_estabelecimento_p,
				cd_cgc_emitente_w,
				cd_serie_nf_p,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				cd_tributo_w,
				replace(vl_tributo_icms_p,'.',','),
				clock_timestamp(),
				nm_usuario_p,
				replace(vl_base_calculo_icms_p,'.',','),
				replace(tx_tributo_icms_p,'.',','),
				0,
				'N',
				0,
				0,
				0,
				0,
				nr_nota_fiscal_w);	

      commit;

		end if;
	end if;
		
	/*importa pis*/

	if (tx_tributo_pis_p > 0) then	
		
		select	coalesce(max(cd_tributo),0)
		into STRICT	cd_tributo_w
		from	tributo
		where	ie_situacao = 'A'
		and	ie_corpo_item = 'I'
		and	ie_tipo_tributo = 'PIS';
	
		if (cd_tributo_w > 0) then
	
			insert into nota_fiscal_item_trib(
				nr_sequencia,
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_sequencia_nf,
				nr_item_nf,
				cd_tributo,
				vl_tributo,
				dt_atualizacao,
				nm_usuario,
				vl_base_calculo,
				tx_tributo,
				vl_reducao_base,
				ie_rateio,
				vl_trib_nao_retido,
				vl_base_nao_retido,
				vl_trib_adic,
				vl_base_adic,
				nr_nota_fiscal)
			values (	nr_sequencia_w,
				cd_estabelecimento_p,
				cd_cgc_emitente_w,
				cd_serie_nf_p,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				cd_tributo_w,
				replace(vl_tributo_pis_p,'.',','),
				clock_timestamp(),
				nm_usuario_p,
				replace(vl_base_calculo_pis_p,'.',','),
				replace(tx_tributo_pis_p,'.',','),
				0,
				'N',
				0,
				0,
				0,
				0,
				nr_nota_fiscal_w);	

      commit;

		end if;
	end if;
	
	/*importa cofins*/

	if (tx_tributo_cofins_p > 0) then	
		
		select	coalesce(max(cd_tributo),0)
		into STRICT	cd_tributo_w
		from	tributo
		where	ie_situacao = 'A'
		and	ie_corpo_item = 'I'
		and	ie_tipo_tributo = 'COFINS';
	
		if (cd_tributo_w > 0) then
	
			insert into nota_fiscal_item_trib(
				nr_sequencia,
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_sequencia_nf,
				nr_item_nf,
				cd_tributo,
				vl_tributo,
				dt_atualizacao,
				nm_usuario,
				vl_base_calculo,
				tx_tributo,
				vl_reducao_base,
				ie_rateio,
				vl_trib_nao_retido,
				vl_base_nao_retido,
				vl_trib_adic,
				vl_base_adic,
				nr_nota_fiscal)
			values (	nr_sequencia_w,
				cd_estabelecimento_p,
				cd_cgc_emitente_w,
				cd_serie_nf_p,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				cd_tributo_w,
				replace(vl_tributo_cofins_p,'.',','),
				clock_timestamp(),
				nm_usuario_p,
				replace(vl_base_calculo_cofins_p,'.',','),
				replace(tx_tributo_cofins_p,'.',','),
				0,
				'N',
				0,
				0,
				0,
				0,
				nr_nota_fiscal_w);

      commit;

		end if;
	end if;
	
	/*importa ipi*/

	if (tx_tributo_ipi_p > 0) then	
		
		select	coalesce(max(cd_tributo),0)
		into STRICT	cd_tributo_w
		from	tributo
		where	ie_situacao = 'A'
		and	ie_corpo_item = 'I'
		and	ie_tipo_tributo = 'IPI';
	
		if (cd_tributo_w > 0) then
	
			insert into nota_fiscal_item_trib(
				nr_sequencia,
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_sequencia_nf,
				nr_item_nf,
				cd_tributo,
				vl_tributo,
				dt_atualizacao,
				nm_usuario,
				vl_base_calculo,
				tx_tributo,
				vl_reducao_base,
				ie_rateio,
				vl_trib_nao_retido,
				vl_base_nao_retido,
				vl_trib_adic,
				vl_base_adic,
				nr_nota_fiscal)
			values (	nr_sequencia_w,
				cd_estabelecimento_p,
				cd_cgc_emitente_w,
				cd_serie_nf_p,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				cd_tributo_w,
				replace(vl_tributo_ipi_p,'.',','),
				clock_timestamp(),
				nm_usuario_p,
				replace(vl_base_calculo_ipi_p,'.',','),
				replace(tx_tributo_ipi_p,'.',','),
				0,
				'N',
				0,
				0,
				0,
				0,
				nr_nota_fiscal_w);

      commit;

		end if;
	end if;	
end if;

/*atualiza total nota fiscal e a data de atualizacao estoque da nota */

if (ie_opcao_p = 4) then	
  CALL gerar_vencimento_nota_fiscal(nr_sequencia_p, nm_usuario_p);
  CALL atualiza_total_nota_fiscal(nr_sequencia_p,nm_usuario_p);
	CALL gerar_titulo_pagar_nf(nr_sequencia_p, nm_usuario_p);
	update nota_fiscal set dt_atualizacao_estoque  = clock_timestamp() where nr_sequencia = nr_sequencia_p;			
	
end if;

	
nr_item_nf_p	:= nr_item_nf_w;
nr_sequencia_p	:= nr_sequencia_w;
ie_erro_p	:= ie_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recebe_nota_xml_cte ( ie_opcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_condicao_pagamento_p bigint, cd_serie_nf_p text, nr_nota_fiscal_p text, dt_emissao_p text, dt_entrada_saida_p text, ie_entrada_saida_p text, cd_cgc_emitente_p text, ds_razao_emit_p text, ds_fantasia_emit_p text, ds_logradouro_emit_p text, nr_endereco_emit_p text, ds_bairro_emit_p text, ds_municipio_emit_p text, ds_uf_emit_p text, cd_cep_emit_p text, ds_pais_emit_p text, nr_telefone_emit_p text, nr_inscr_estadual_emit_p text, nr_danfe_p text, cd_material_p text, qt_item_nf_p bigint, vl_unitario_item_nf_p text, vl_base_calculo_icms_p text, vl_tributo_icms_p text, tx_tributo_icms_p text, vl_base_calculo_pis_p text, vl_tributo_pis_p text, tx_tributo_pis_p text, vl_base_calculo_cofins_p text, vl_tributo_cofins_p text, tx_tributo_cofins_p text, vl_base_calculo_ipi_p text, vl_tributo_ipi_p text, tx_tributo_ipi_p text, nr_sequencia_p INOUT bigint, nr_item_nf_p INOUT bigint, ie_erro_p INOUT text, cd_operacao_nf_p bigint, ds_observacao_p text, cd_procedimento_p bigint, cd_natureza_operacao_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p bigint, cd_local_estoque_p text, nr_seq_classif_trib_p text) FROM PUBLIC;

