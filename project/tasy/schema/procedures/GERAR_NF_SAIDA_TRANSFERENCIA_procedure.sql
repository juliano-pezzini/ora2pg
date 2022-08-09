-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nf_saida_transferencia ( nr_ordem_compra_p bigint, cd_estabelecimento_p bigint, cd_operacao_nf_p bigint, cd_nat_oper_nf_p bigint, cd_serie_nf_p text, nr_nota_fiscal_p text, cd_local_estoque_p bigint, ds_observacao_p text, nr_seq_modelo_p bigint, nm_usuario_p text, ie_item_nf text, cd_setor_atendimento_p bigint, nr_sequencia_p INOUT bigint, ds_erro_p INOUT text, ds_erro_item_p INOUT text, ds_erro_nota_p INOUT text) AS $body$
DECLARE


nr_sequencia_w			bigint;
cd_cgc_ordem_w			varchar(14);
cd_cgc_estab_w			varchar(14);
cd_estab_ordem_w			bigint;
nr_nota_fiscal_w			varchar(255);
nr_sequencia_nf_w			bigint	:= 9;
dt_emissao_w			timestamp;
dt_entrada_saida_w		timestamp;
cd_condicao_pagto_w		bigint;
vl_frete_w			double precision;
qt_itens_nota_w			bigint;
ds_erro_w			varchar(255) := '';
ds_erro_item_w			varchar(255) := '';
ds_erro_nota_w			varchar(255) := '';
ie_consistiu_saldo_w		varchar(1) := 'N';

/*itens*/

nr_item_oci_w			integer;
cd_material_w			integer;
cd_unidade_medida_compra_w	varchar(30);
vl_unitario_item_nf_w		double precision;
pr_descontos_w			double precision;
ds_material_direto_w		varchar(255);
ds_observacao_item_w		varchar(255);
cd_centro_custo_w			integer;
cd_conta_contabil_w		varchar(20);
pr_desc_financ_w			double precision;
dt_prevista_entrega_w		timestamp;
vl_desconto_oci_w			double precision;
vl_desconto_w			double precision;
nr_seq_conta_financeira_w		bigint;
nr_item_nf_w			integer;
cd_unidade_medida_estoque_w	varchar(30);
qt_prevista_entrega_w		double precision;
qt_item_estoque_w			double precision;
vl_total_item_nf_w			double precision;
vl_total_item_unit_nf_w			double precision;
vl_liquido_w			double precision;
qt_conv_compra_estoque_w		double precision;
cd_material_estoque_w		integer;
ie_tipo_conta_w			integer;
cd_centro_conta_w			integer;
qt_nota_w			integer;
nr_seq_lote_w			bigint;
ie_indeterminado_w			varchar(2) := 'N';
dt_validade_w			timestamp;
ds_lote_fornec_w			varchar(20);
ds_barra_w			varchar(255);
ie_calcula_nf_w			varchar(01);
ie_consiste_saldo_w		varchar(1);
ie_consignado_operacao_w		varchar(1) := '0';
cd_fornecedor_consig_w		varchar(14);
ie_tipo_saldo_w			varchar(1);
ie_entrada_saida_w			operacao_estoque.ie_entrada_saida%type;
nr_seq_marca_w			material_lote_fornec.nr_seq_marca%type;
ds_origem_valor_w			varchar(255);
cd_operacao_estoque_w		operacao_estoque.cd_operacao_estoque%type;
ie_atualiza_cm_calc_nf_w		parametro_estoque.ie_atualiza_cm_calc_nf%type;
dt_mesano_vigente_w		timestamp;
dt_mesano_referencia_w		timestamp;
nr_seq_lote_fornec_w		ordem_compra_item.nr_seq_lote_fornec%type;
ie_integrar_nf_saida_w		parametros_farmacia.ie_integrar_nf_saida%type;
cd_local_entrega_w 			ordem_compra.cd_local_entrega%type;

c00 CURSOR FOR
SELECT	cd_material,
	cd_unidade_medida_compra,
	nr_item_oci,
	nr_seq_lote,
	qt_material
from	ordem_compra_item_cb
where (coalesce(ie_status,'CB') <> 'CM' or substr(obter_se_leitura_barras(cd_estabelecimento_p, cd_material, 146),1,1) = 'N')
and	ie_atende_recebe = 'A'
and	nr_ordem_compra = nr_ordem_compra_p
and	coalesce(nr_seq_nota::text, '') = '';

c01 CURSOR FOR
SELECT	a.nr_item_oci,
	a.cd_material,
	a.cd_unidade_medida_compra,
	a.vl_unitario_material,
	coalesce(a.pr_descontos,0),
	substr(a.ds_material_direto,1,255),
	a.ds_observacao,
	coalesce(a.pr_desc_financ,0),
	coalesce(a.vl_desconto,0),
	a.nr_seq_lote_fornec
from	ordem_compra_item a,
	ordem_compra_item_entrega b
where	a.nr_ordem_compra = b.nr_ordem_compra
and	a.nr_item_oci = b.nr_item_oci
and	substr(obter_se_leitura_barras(cd_estabelecimento_p, a.cd_material, 146),1,1) = 'N'
and	a.nr_ordem_compra = nr_ordem_compra_p
and	coalesce(a.qt_material,0) > coalesce(a.qt_material_entregue,0)
and	coalesce(a.dt_reprovacao::text, '') = ''
and	coalesce(b.dt_cancelamento::text, '') = ''
group by a.nr_ordem_compra,
	a.nr_item_oci,
	a.cd_material,
	a.cd_unidade_medida_compra,
	a.vl_unitario_material,
	coalesce(a.pr_descontos,0),
	substr(a.ds_material_direto,1,255),
	a.ds_observacao,
	coalesce(a.pr_desc_financ,0),
	coalesce(a.vl_desconto,0),
	a.nr_seq_lote_fornec
having	((sum(b.qt_prevista_entrega) - max(obter_qt_oci_trans_nota(a.nr_ordem_compra, a.nr_item_oci,'S'))) > 0)
order by a.nr_item_oci;

c02 CURSOR FOR
SELECT	nr_seq_lote
from	ordem_compra_item_cb
where	cd_material = cd_material_w
and	nr_item_oci	= nr_item_oci_w
and	nr_ordem_compra	= nr_ordem_compra_p
and	coalesce(nr_seq_nota::text, '') = '';

c03 CURSOR FOR
SELECT	cd_material_estoque,
	sum(qt_item_estoque) qt_prevista_entrega,
	sup_obter_saldo_estoque(a.cd_estabelecimento, trunc(clock_timestamp(),'mm'), cd_local_estoque, cd_material_estoque) qt_item_estoque
from	nota_fiscal a,
	nota_fiscal_item b
where	a.nr_sequencia = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_w
and	substr(obter_se_local_direto(cd_local_estoque),1,1) = 'N'
and	somente_numero(obter_se_mat_consignado(cd_material_estoque)) in (0,2)
and	coalesce(ie_consignado_operacao_w,0) = 0
and	ie_consiste_saldo_w = 'S'
GROUP BY cd_material_estoque, a.cd_estabelecimento, cd_local_estoque
 HAVING	coalesce(sum(qt_item_estoque),0) > sup_obter_saldo_estoque(a.cd_estabelecimento, trunc(clock_timestamp(),'mm'), cd_local_estoque, cd_material_estoque)

union all

SELECT	cd_material_estoque,
	sum(qt_item_estoque) qt_prevista_entrega,
	obter_saldo_disp_estoque(a.cd_estabelecimento, cd_material_estoque, cd_local_estoque, trunc(clock_timestamp(),'mm')) qt_item_estoque
from	nota_fiscal a,
	nota_fiscal_item b
where	a.nr_sequencia = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_w
and	substr(obter_se_local_direto(cd_local_estoque),1,1) = 'N'
and	somente_numero(obter_se_mat_consignado(cd_material_estoque)) in (0,2)
and	coalesce(ie_consignado_operacao_w,0) = 0
and	ie_consiste_saldo_w = 'D'
having	coalesce(sum(qt_item_estoque),0) > obter_saldo_disp_estoque(a.cd_estabelecimento, cd_material_estoque, cd_local_estoque, trunc(clock_timestamp(),'mm'))
group by cd_material_estoque, a.cd_estabelecimento, cd_local_estoque;


BEGIN
dt_emissao_w		:= trunc(clock_timestamp(), 'dd');
dt_entrada_saida_w	:= clock_timestamp();

select	cd_estabelecimento,
	cd_condicao_pagamento,
	vl_frete,
	cd_local_entrega
into STRICT	cd_estab_ordem_w,
	cd_condicao_pagto_w,
	vl_frete_w,
	cd_local_entrega_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p;

select	nextval('nota_fiscal_seq')
into STRICT	nr_sequencia_w
;

select	substr(obter_cgc_estabelecimento(cd_estabelecimento_p),1,14),
	substr(obter_cgc_estabelecimento(cd_estab_ordem_w),1,14)
into STRICT	cd_cgc_estab_w, /* cnpj estabelecimento  emitente da nf matheus os*/
	cd_cgc_ordem_w /* cnpj do estabelecimento que gerou a ordem, para o qual sera emitida a nf */
;

ie_calcula_nf_w		:=	substr(coalesce(obter_valor_param_usuario(146, 26, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N'),1,1);
ie_consiste_saldo_w	:= 	substr(coalesce(obter_valor_param_usuario(146, 24, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N'),1,1);

select	coalesce(cd_operacao_estoque,0)
into STRICT	cd_operacao_estoque_w
from	operacao_nota
where	cd_operacao_nf = cd_operacao_nf_p;

select	ie_consignado,
	CASE WHEN coalesce(ie_entrada_saida,'S')='S' THEN 'E'  ELSE 'S' END
into STRICT	ie_consignado_operacao_w,
	ie_entrada_saida_w
from	operacao_estoque
where	cd_operacao_estoque = cd_operacao_estoque_w;


if (ie_calcula_nf_w = 'S') then
	

nr_nota_fiscal_w := nr_sequencia_w + 80000;

elsif (coalesce(nr_nota_fiscal_p, '0') = '0') then
	begin
			
	select	coalesce(max(somente_numero(nr_ultima_nf)), nr_sequencia_w) + 1
	into STRICT	nr_nota_fiscal_w
	from	serie_nota_fiscal
	where	cd_serie_nf 		= cd_serie_nf_p
	and	cd_estabelecimento 	= cd_estabelecimento_p;
	


	select	count(*)
	into STRICT	qt_nota_w
	from	nota_fiscal
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_cgc_emitente = cd_cgc_estab_w
	and	cd_serie_nf = cd_serie_nf_p
	and	nr_nota_fiscal = nr_nota_fiscal_w;

	if (qt_nota_w > 0) then
		select (coalesce(max(somente_numero(nr_nota_fiscal)),'0')+1)
		into STRICT	nr_nota_fiscal_w
		from	nota_fiscal
		where	cd_estabelecimento = cd_estabelecimento_p
		and	cd_cgc_emitente = cd_cgc_estab_w
		and	cd_serie_nf = cd_serie_nf_p;
			
	end if;
	end;
else
	begin
	
	nr_nota_fiscal_w := nr_nota_fiscal_p;
	
	select	count(*)
	into STRICT	qt_nota_w
	from	nota_fiscal
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_cgc_emitente = cd_cgc_estab_w
	and	cd_serie_nf = cd_serie_nf_p
	and	nr_nota_fiscal = nr_nota_fiscal_w;
	
	if (qt_nota_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(181246);
	end if;
	end;
end if;

select	coalesce(max(ie_integrar_nf_saida),'N')
into STRICT	ie_integrar_nf_saida_w
from	parametros_farmacia
where 	cd_estabelecimento = cd_estabelecimento_p;

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
	cd_pessoa_fisica,		vl_ipi,
	vl_descontos,		vl_frete,
	vl_seguro,		vl_despesa_acessoria,
	ds_observacao,		cd_natureza_operacao,
	vl_desconto_rateio,		ie_situacao,
	nr_interno_conta,		nr_seq_protocolo,
	ds_obs_desconto_nf,	nr_seq_classif_fiscal,
	ie_tipo_nota,		nr_ordem_compra,
	ie_entregue_bloqueto,	cd_setor_digitacao,
	nr_seq_modelo)
values ( nr_sequencia_w,		cd_estabelecimento_p,
	cd_cgc_estab_w,		cd_serie_nf_p,
	nr_nota_fiscal_w,		nr_sequencia_nf_w,
	cd_operacao_nf_p,		dt_emissao_w,
	dt_entrada_saida_w,	'1',
	'0',			'0',
	0,			0,
	0,			0,
	clock_timestamp(),			nm_usuario_p,
	cd_condicao_pagto_w,	cd_cgc_ordem_w,
	null,			0,
	0,			vl_frete_w,
	0,			0,
	ds_observacao_p,		cd_nat_oper_nf_p,
	0,			'1',
	null,			null,
	null,			null,
	'ST',			nr_ordem_compra_p,
	'N',			cd_setor_atendimento_p,
	nr_seq_modelo_p);
	
	
select	coalesce(max(ie_atualiza_cm_calc_nf),'N'),
	max(dt_mesano_vigente)
into STRICT	ie_atualiza_cm_calc_nf_w,
	dt_mesano_vigente_w
from	parametro_estoque
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_atualiza_cm_calc_nf_w = 'S') then
	begin	
	if (dt_entrada_saida_w <= pkg_date_utils.end_of(dt_mesano_vigente_w, 'MONTH', 0)) then
		dt_mesano_referencia_w := dt_mesano_vigente_w;
   	else
		dt_mesano_referencia_w := pkg_date_utils.start_of(dt_entrada_saida_w,'month',0);
	end if;
	end;
end if;

CALL gerar_historico_nota_fiscal(nr_sequencia_w, nm_usuario_p, '17', wheb_mensagem_pck.get_texto(277520));

if (ie_item_nf = 0) then
	open c01;
	loop
	fetch c01 into
		nr_item_oci_w,
		cd_material_w,
		cd_unidade_medida_compra_w,
		vl_unitario_item_nf_w,
		pr_descontos_w,
		ds_material_direto_w,
		ds_observacao_item_w,
		pr_desc_financ_w,
		vl_desconto_oci_w,
		nr_seq_lote_fornec_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	coalesce(max(nr_item_nf), 0) + 1
		into STRICT	nr_item_nf_w
		from	nota_fiscal_item
		where	nr_sequencia = nr_sequencia_w;

		select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque,
				qt_conv_compra_estoque,
				cd_material_estoque
		into STRICT	cd_unidade_medida_estoque_w,
				qt_conv_compra_estoque_w,
				cd_material_estoque_w
		from	material
		where	cd_material = cd_material_w;

		select	coalesce(sum(a.qt_prevista_entrega) - max(obter_qt_oci_trans_nota(a.nr_ordem_compra, a.nr_item_oci,'S')),0)
		into STRICT	qt_prevista_entrega_w
		from	ordem_compra_item_entrega a,
			ordem_compra_item b
		where	b.nr_ordem_compra 	= a.nr_ordem_compra
		and	a.nr_item_oci		= b.nr_item_oci
		and	a.nr_ordem_compra	= nr_ordem_compra_p
		and	a.nr_item_oci		= nr_item_oci_w
		and	coalesce(a.dt_cancelamento::text, '') = '';

		if (cd_unidade_medida_compra_w = cd_unidade_medida_estoque_w) then
			qt_item_estoque_w := qt_prevista_entrega_w;
		else
			qt_item_estoque_w := obter_quantidade_convertida(cd_material_w,qt_prevista_entrega_w,cd_unidade_medida_compra_w,'UME','N');
		end if;
		
		if (ie_atualiza_cm_calc_nf_w = 'S') then
			begin
			if (substr(sup_obter_metodo_valorizacao(dt_mesano_referencia_w, cd_estabelecimento_p),1,15) = 'MPM') then
				CALL val_estoque_media_ponderada.val_prod_mat(dt_mesano_referencia_w, cd_estabelecimento_p, cd_material_estoque_w, nm_usuario_p);
			else
				CALL val_mensal_estoque.val_est_prod_mat(dt_mesano_referencia_w, cd_estabelecimento_p, cd_material_estoque_w, nm_usuario_p);
			end if;
			end;
		end if;	
		
		--vl_unitario_item_nf_w := nvl(obter_valor_item_transf_etq(cd_estabelecimento_p, cd_material_w, cd_unidade_medida_compra_w),0);		
		SELECT * FROM sup_obter_valor_item_transf( cd_estabelecimento_p, cd_material_w, cd_unidade_medida_compra_w, vl_unitario_item_nf_w, ds_origem_valor_w) INTO STRICT vl_unitario_item_nf_w, ds_origem_valor_w;

		
		vl_total_item_nf_w		:= coalesce((qt_prevista_entrega_w * vl_unitario_item_nf_w),0);
		vl_unitario_item_nf_w 	:= coalesce(dividir(vl_total_item_nf_w,qt_prevista_entrega_w),0);
		vl_desconto_w		:= coalesce((dividir((vl_total_item_nf_w * pr_descontos_w), 100) + coalesce(vl_desconto_oci_w,0)),0);
		vl_liquido_w		:= coalesce((vl_total_item_nf_w - vl_desconto_w),0);

		
		
		ie_tipo_conta_w	:= 3;
		if (coalesce(cd_centro_custo_w::text, '') = '') then
			ie_tipo_conta_w	:= 2;
		end if;

		SELECT * FROM define_conta_material(
			cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_p, cd_operacao_estoque_w, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;

		nr_seq_conta_financeira_w := obter_conta_financeira(
				ie_entrada_saida_w, cd_estabelecimento_p, cd_material_w, null, null, null, null, cd_cgc_estab_w, cd_centro_custo_w, nr_seq_conta_financeira_w, null, cd_operacao_nf_p, 'PJ', null, null, null, null, null, null, null, null, null, cd_local_estoque_p, '', '', '', '', '', null);

		insert into nota_fiscal_item(
			nr_sequencia,			cd_estabelecimento,
			cd_cgc_emitente,		cd_serie_nf,
			nr_nota_fiscal,			nr_sequencia_nf,
			nr_item_nf,			cd_natureza_operacao,
			qt_item_nf,			vl_unitario_item_nf,
			vl_total_item_nf,		dt_atualizacao,
			nm_usuario,			vl_frete,
			vl_desconto,			vl_despesa_acessoria,
			cd_material,			cd_local_estoque,
			ds_observacao,			ds_complemento,
			cd_unidade_medida_compra,	qt_item_estoque,
			cd_unidade_medida_estoque,	cd_conta_contabil,
			vl_desconto_rateio,		vl_seguro,
			cd_material_estoque,
			nr_ordem_compra,		vl_liquido,
			pr_desconto,			nr_item_oci,
			dt_entrega_ordem,		nr_seq_conta_financ,
			pr_desc_financ,			cd_fornecedor_consig,
			ds_origem_valor,
			cd_sequencia_parametro)
		values (	nr_sequencia_w,			cd_estabelecimento_p,
			cd_cgc_estab_w,			cd_serie_nf_p,
			nr_nota_fiscal_w,		nr_sequencia_nf_w,
			nr_item_nf_w,			cd_nat_oper_nf_p,
			qt_prevista_entrega_w,		vl_unitario_item_nf_w,
			vl_total_item_nf_w,		clock_timestamp(),
			nm_usuario_p, 			coalesce(vl_frete_w,0),
			coalesce(vl_desconto_w,0),		0,
			cd_material_w, 			cd_local_estoque_p,
			'',				ds_material_direto_w,
			cd_unidade_medida_compra_w,	qt_item_estoque_w,
			cd_unidade_medida_estoque_w,	cd_conta_contabil_w,
			0,				0,
			cd_material_estoque_w,
			nr_ordem_compra_p,		vl_liquido_w,
			0,				nr_item_oci_w,
			dt_prevista_entrega_w,		CASE WHEN coalesce(nr_seq_conta_financeira_w,0)=0 THEN null  ELSE nr_seq_conta_financeira_w END ,
			0,				cd_fornecedor_consig_w,
			ds_origem_valor_w,
			philips_contabil_pck.get_parametro_conta_contabil);

		if (ie_integrar_nf_saida_w = 'S') then
			CALL gerar_int_disp_req_material(nr_requisicao_p => null,
					nr_ordem_compra_p => nr_ordem_compra_p,
					cd_acao_p => 'ESA',
					cd_material_p => cd_material_w,
					qt_material_atend_p => qt_prevista_entrega_w,
					nr_lote_fornec_p => nr_seq_lote_fornec_w,
					cd_barras_p	=> cd_material_w,
					cd_local_estoque_p => cd_local_entrega_w);
		end if;		
	end;
	end loop;
	close c01;
end if;

if (ie_item_nf = 1) then
	open c00;
		loop
		fetch c00 into
		cd_material_w,
		cd_unidade_medida_compra_w,
		nr_item_oci_w,
		nr_seq_lote_w,
		qt_prevista_entrega_w;
	EXIT WHEN NOT FOUND; /* apply on c00 */
		begin		
		if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then			
			select	dt_validade,
				ds_lote_fornec,
				CASE WHEN coalesce(cd_barra_material,'X')='X' THEN  lpad(nr_sequencia || nr_digito_verif,11,0)  ELSE cd_barra_material END  ds_barra
			into STRICT	dt_validade_w,
				ds_lote_fornec_w,
				ds_barra_w
			from 	material_lote_fornec
			where	nr_sequencia = nr_seq_lote_w;
			
			if (coalesce(dt_validade_w::text, '') = '') then
				ie_indeterminado_w := 'S';
			end if;	
		else
			dt_validade_w 		:= '';
			ds_lote_fornec_w	:= '';
			ds_barra_w		:= '';
		end if;
			
		select	dt_entrega
		into STRICT	dt_prevista_entrega_w
		from	ordem_compra
		where	nr_ordem_compra = nr_ordem_compra_p;

		select	coalesce(max(nr_item_nf), 0) + 1
		into STRICT	nr_item_nf_w
		from	nota_fiscal_item
		where	nr_sequencia = nr_sequencia_w;

		select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque,
				qt_conv_compra_estoque,
				cd_material_estoque
		into STRICT	cd_unidade_medida_estoque_w,
				qt_conv_compra_estoque_w,
				cd_material_estoque_w
		from	material
		where	cd_material = cd_material_w;

		if (cd_unidade_medida_compra_w = cd_unidade_medida_estoque_w) then
			qt_item_estoque_w := qt_prevista_entrega_w;
		else
			qt_item_estoque_w := obter_quantidade_convertida(cd_material_w,qt_prevista_entrega_w,cd_unidade_medida_compra_w,'UME','N');
		end if;
		
		if (ie_atualiza_cm_calc_nf_w = 'S') then
			begin
			if (substr(sup_obter_metodo_valorizacao(dt_mesano_referencia_w, cd_estabelecimento_p),1,15) = 'MPM') then
				CALL val_estoque_media_ponderada.val_prod_mat(dt_mesano_referencia_w, cd_estabelecimento_p, cd_material_estoque_w, nm_usuario_p);
			else
				CALL val_mensal_estoque.val_est_prod_mat(dt_mesano_referencia_w, cd_estabelecimento_p, cd_material_estoque_w, nm_usuario_p);
			end if;
			end;
		end if;	
		
		--vl_unitario_item_nf_w := nvl(obter_valor_item_transf_etq(cd_estabelecimento_p, cd_material_w, cd_unidade_medida_compra_w),0);
		SELECT * FROM sup_obter_valor_item_transf( cd_estabelecimento_p, cd_material_w, cd_unidade_medida_compra_w, vl_unitario_item_nf_w, ds_origem_valor_w) INTO STRICT vl_unitario_item_nf_w, ds_origem_valor_w;
		
		vl_total_item_nf_w		:= coalesce((qt_prevista_entrega_w * vl_unitario_item_nf_w),0);
		--Variavel criada para que o calculo seja feito com 4 casas decimais, pois estava sendo gerado o valor unitario errado do material
		vl_total_item_unit_nf_w		:= coalesce((qt_prevista_entrega_w * vl_unitario_item_nf_w),0);
		
		vl_liquido_w			:= coalesce(vl_total_item_nf_w,0);
		vl_unitario_item_nf_w 	:= coalesce(dividir(vl_total_item_unit_nf_w,qt_prevista_entrega_w),0);
		
		ie_tipo_conta_w	:= 3;
		if (coalesce(cd_centro_custo_w::text, '') = '') then
			ie_tipo_conta_w	:= 2;
		end if;

		SELECT * FROM define_conta_material(
			cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_p, cd_operacao_estoque_w, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;
			
		if (ie_consignado_operacao_w > 0) and (coalesce(nr_seq_lote_w,0) > 0) then
			select	cd_cgc_fornec
			into STRICT	cd_fornecedor_consig_w
			from	material_lote_fornec
			where	nr_sequencia = nr_seq_lote_w;
		end if;

		nr_seq_conta_financeira_w := obter_conta_financeira(
				ie_entrada_saida_w, cd_estabelecimento_p, cd_material_w, null, null, null, null, cd_cgc_estab_w, cd_centro_custo_w, nr_seq_conta_financeira_w, null, cd_operacao_nf_p, 'PJ', null, null, null, null, null, null, null, null, null, cd_local_estoque_p, '', '', '', '', '', null);
				
		begin
		select	nr_seq_marca
		into STRICT	nr_seq_marca_w
		from	material_lote_fornec
		where	nr_sequencia = nr_seq_lote_w;
		exception
		when others then
			nr_seq_marca_w	:=	null;
		end;

		insert into nota_fiscal_item(
			nr_sequencia,			cd_estabelecimento,
			cd_cgc_emitente,		cd_serie_nf,
			nr_nota_fiscal,			nr_sequencia_nf,
			nr_item_nf,			cd_natureza_operacao,
			qt_item_nf,			vl_unitario_item_nf,
			vl_total_item_nf,		dt_atualizacao,
			nm_usuario,			vl_frete,
			vl_desconto,			vl_despesa_acessoria,
			cd_material,			cd_local_estoque,
			ds_observacao,			ds_complemento,
			cd_unidade_medida_compra,	qt_item_estoque,
			cd_unidade_medida_estoque,	cd_conta_contabil,
			vl_desconto_rateio,		vl_seguro,
			cd_material_estoque,
			nr_ordem_compra,		vl_liquido,
			pr_desconto,			nr_item_oci,
			dt_entrega_ordem,		nr_seq_conta_financ,
			pr_desc_financ,			cd_lote_fabricacao,
			ie_indeterminado,		dt_validade,
			nr_seq_lote_fornec,		cd_fornecedor_consig,
			nr_seq_marca,			ds_origem_valor,
			cd_sequencia_parametro)
		values (	nr_sequencia_w,			cd_estabelecimento_p,
			cd_cgc_estab_w,			cd_serie_nf_p,
			nr_nota_fiscal_w,		nr_sequencia_nf_w,
			nr_item_nf_w,			cd_nat_oper_nf_p,
			qt_prevista_entrega_w,		vl_unitario_item_nf_w,
			vl_total_item_nf_w,			clock_timestamp(),
			nm_usuario_p, 			coalesce(vl_frete_w,0),
			coalesce(vl_desconto_w,0),		0,
			cd_material_w, 			cd_local_estoque_p,
			'',				ds_material_direto_w,
			cd_unidade_medida_compra_w,	qt_item_estoque_w,
			cd_unidade_medida_estoque_w,	cd_conta_contabil_w,
			0,				0,
			cd_material_estoque_w,
			nr_ordem_compra_p,		vl_liquido_w,
			0,				nr_item_oci_w,
			dt_prevista_entrega_w,		CASE WHEN coalesce(nr_seq_conta_financeira_w,0)=0 THEN null  ELSE nr_seq_conta_financeira_w END ,
			0,				ds_lote_fornec_w,
			ie_indeterminado_w,		dt_validade_w,
			nr_seq_lote_w,			cd_fornecedor_consig_w,
			nr_seq_marca_w,			ds_origem_valor_w,
			philips_contabil_pck.get_parametro_conta_contabil);
			
		if (ds_barra_w IS NOT NULL AND ds_barra_w::text <> '') then
			begin
			update  nota_fiscal_item
			set	cd_barra_material	= ds_barra_w
			where   nr_item_nf 		= nr_item_nf_w
			and	nr_sequencia 		= nr_sequencia_w
			and	(cd_material IS NOT NULL AND cd_material::text <> '')
			and     coalesce(ds_barras::text, '') = '';
			end;
		end if;
		
		if (ie_integrar_nf_saida_w = 'S') then
			CALL gerar_int_disp_req_material(nr_requisicao_p => null,
					nr_ordem_compra_p => nr_ordem_compra_p,
					cd_acao_p => 'ESA',
					cd_material_p => cd_material_w,
					qt_material_atend_p => qt_prevista_entrega_w,
					nr_lote_fornec_p => nr_seq_lote_w,
					cd_barras_p	=> coalesce(ds_barra_w,cd_material_w),
					cd_local_estoque_p => cd_local_entrega_w);
		end if;		
		
	end;
	end loop;
	close c00;
end if;

select 	count(*)
into STRICT	qt_itens_nota_w
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_w;

if (qt_itens_nota_w = 0) then
	begin
	delete FROM nota_fiscal where nr_sequencia = nr_sequencia_w;
	nr_sequencia_w	:= 0;
	ds_erro_nota_w	:= wheb_mensagem_pck.get_texto(277522);
	end;
else
	begin	
	CALL atualiza_total_nota_fiscal(nr_sequencia_w,nm_usuario_p);
	CALL gerar_vencimento_nota_fiscal(nr_sequencia_w, nm_usuario_p);
	
	if (ie_calcula_nf_w = 'S') then
		SELECT * FROM consistir_nota_fiscal(nr_sequencia_w, nm_usuario_p, ds_erro_item_w, ds_erro_nota_w) INTO STRICT ds_erro_item_w, ds_erro_nota_w;
	end if;
	
	if (ie_consiste_saldo_w <> 'N') then
		begin
		open c03;
		loop
		fetch c03 into	
			cd_material_w,
			qt_prevista_entrega_w,
			qt_item_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			ds_erro_item_w 	:= substr(ds_erro_item_w ||
						wheb_mensagem_pck.get_texto(277523) || cd_material_w || wheb_mensagem_pck.get_texto(277524) || campo_mascara_virgula(qt_prevista_entrega_w) || chr(13) || chr(10) ||
						wheb_mensagem_pck.get_texto(277525) || campo_mascara_virgula(qt_item_estoque_w) || chr(13) || chr(10),1,255);
			ie_consistiu_saldo_w	:= 'S';
			end;
		end loop;
		close c03;
		end;
	end if;
	end;
end if;

if (qt_itens_nota_w > 0) and (coalesce(ds_erro_item_w::text, '') = '') and (coalesce(ds_erro_nota_w::text, '') = '') and (coalesce(ds_erro_w::text, '') = '') then
	begin
	if (ie_calcula_nf_w = 'S') then
		CALL atualizar_nota_fiscal(nr_sequencia_w,'I',nm_usuario_p,3);
	end if;

	update	ordem_compra_item_cb
	set	nr_seq_nota	= nr_sequencia_w
	where 	nr_ordem_compra = nr_ordem_compra_p
	and	coalesce(nr_seq_nota::text, '') = '';
	
	CALL gerar_comunic_solic_transf(nr_ordem_compra_p,nr_sequencia_w,33,nm_usuario_p);
	CALL gerar_email_solic_transf(nr_ordem_compra_p,nr_sequencia_w,43,nm_usuario_p);
	end;
	
else
	insert into log_tasy(
		   CD_LOG,
		   DS_LOG,
		   NM_USUARIO,
		   DT_ATUALIZACAO)
		   values (
		   924,
		   substr('CTE Ordem ' || nr_ordem_compra_p || ' Nota- ' || nr_sequencia_w  || ' Q- ' || qt_itens_nota_w || ' I- ' || ds_erro_item_w || ' N - ' || ds_erro_nota_w || ' E- ' || ds_erro_w,1,2000),
		   nm_usuario_p,
		   clock_timestamp());
	
end if;

if (ds_erro_item_w IS NOT NULL AND ds_erro_item_w::text <> '') or (ds_erro_nota_w IS NOT NULL AND ds_erro_nota_w::text <> '') then
	begin
	delete	FROM nota_fiscal
	where	nr_sequencia = nr_sequencia_w;
	
	if (ie_consistiu_saldo_w = 'N') then
		begin
		ds_erro_w := nr_sequencia_w;
		end;
	end if;	
	
	nr_sequencia_w	:= 0;
	end;
end if;	

nr_sequencia_p	:= nr_sequencia_w;
ds_erro_p		:= substr(ds_erro_w,1,255);
ds_erro_item_p	:= substr(ds_erro_item_w,1,255);
ds_erro_nota_p	:= substr(ds_erro_nota_w,1,255);


commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nf_saida_transferencia ( nr_ordem_compra_p bigint, cd_estabelecimento_p bigint, cd_operacao_nf_p bigint, cd_nat_oper_nf_p bigint, cd_serie_nf_p text, nr_nota_fiscal_p text, cd_local_estoque_p bigint, ds_observacao_p text, nr_seq_modelo_p bigint, nm_usuario_p text, ie_item_nf text, cd_setor_atendimento_p bigint, nr_sequencia_p INOUT bigint, ds_erro_p INOUT text, ds_erro_item_p INOUT text, ds_erro_nota_p INOUT text) FROM PUBLIC;
