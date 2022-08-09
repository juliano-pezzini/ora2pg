-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_nota_fiscal ( nr_sequencia_p bigint, nm_usuario_p text, ie_commit_p text default 'S', ds_motivo_canc_p text default null, ie_origem_p text default 'D') AS $body$
DECLARE

				
reg_integracao_p		gerar_int_padrao.reg_integracao;
nr_sequencia_nf_w		bigint;
nr_sequencia_w			bigint;
dt_atualizacao_w		timestamp := clock_timestamp();
cd_estabelecimento_w		smallint;
cd_cgc_emitente_w		varchar(14);
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
nr_nota_fiscal_w		varchar(255);
ie_atualizou_preco_w		varchar(1)	:= 'S';
nr_interno_conta_w		bigint;
nr_seq_protocolo_w		bigint;
qt_titulo_nf_saida_w		smallint;
cd_oper_ent_pass_direta_w	smallint;
cd_oper_cons_pass_direta_w	smallint;
qt_item_direto_w		bigint;
qt_nota_repasse_w		integer;
ie_calculada_conta_prot_w	integer;
qt_registro_w			bigint;
qt_existe_w			bigint;
nr_seq_lote_w			bigint;
ds_historico_w			varchar(255);
nr_titulo_w			bigint;
vl_saldo_titulo_w		double precision;
ie_canc_titulo_nota_w		varchar(1)	:= 'B';
nm_user_w			varchar(50);
nr_ordem_compra_rep_w		bigint;
nr_seq_lote_prot_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_adiantamento_w		bigint;
vl_adiantamento_w		double precision;
nr_seq_tit_adiant_w		bigint;
ie_desvincular_adiant_nf_w	varchar(1);
ie_inativa_lote_est_nf_w	varchar(1);
qt_item_nf_w			double precision;
nr_emprestimo_w			bigint;
nr_seq_item_emprestimo_w	bigint;
nr_seq_regra_w			bigint;
ds_email_destino_w		varchar(2000);
ie_momento_envio_w		varchar(1);
ie_contas_pagar_w		varchar(1);
ie_contas_receber_w		varchar(1);
cd_cnpj_editado_w		varchar(30);
ds_razao_social_w		pessoa_juridica.ds_razao_social%type;
ds_fantasia_w			varchar(100);
nm_pessoa_fisica_w		varchar(100);
dt_entrada_saida_w		timestamp;
vl_total_nota_w			double precision;
ds_total_nota_w			varchar(100);
nm_usuario_completo_w		varchar(100);
ds_cargo_w			varchar(80);
ie_usuario_w			varchar(15);
nr_telefone_w			varchar(15);
nr_ramal_w			varchar(20);
ds_email_w			varchar(255);
ds_assunto_w			varchar(80);
ds_mensagem_w			varchar(4000);
nr_seq_transf_cme_w		bigint;
ie_integracao_nota_w		varchar(15);
ds_erro_w			varchar(2000);
nr_sequencia_ref_w		bigint;
nr_ordem_compra_ww		bigint;
nr_ordem_compra_w		bigint;
ie_tipo_nota_w			varchar(15);
ie_devolucao_w			varchar(1);
ie_transferencia_estab_w	varchar(1);
nr_seq_nf_ref_w			bigint;
ie_empenho_orcamento_w		varchar(1);
nr_seq_mensalidade_w		bigint;
nr_seq_fatura_w			pls_fatura.nr_sequencia%type;
nr_seq_fatura_ndc_w		pls_fatura.nr_sequencia%type;
ie_commit_w			varchar(1);
ie_limpa_vinc_oc_nf_w		varchar(1);
ie_atualiza_dt_ent_saida_w	varchar(1);
cd_perfil_ativo_w		bigint;
ds_email_remetente_w		varchar(255);
dt_emissao_w			timestamp;
dt_entrada_saida_ant_w		timestamp;
nr_titulo_pagar_w		titulo_pagar_baixa.nr_titulo%type;
nr_sequencia_baixa_pg_w		titulo_pagar_baixa.nr_sequencia%type;
nr_seq_far_venda_w		nota_fiscal.nr_seq_far_venda%type;
nr_sequencia_cred_w             nf_credito.nr_sequencia%type;
ie_acao_w                       nf_credito.ie_acao%type;
nr_item_nf_w                    nota_fiscal_item.nr_item_nf%type;
vl_total_item_nf_w              nota_fiscal_item.vl_total_item_nf%type;
qt_existe_nf_gerada_w           integer;
vl_imposto_w                    nf_credito_item.vl_imposto%type;
nr_seq_baixa_tit_w              nota_fiscal.nr_seq_baixa_tit%type;
ds_mot_canc_fat_w		varchar(255);
ie_ctb_online_w                 varchar(1);
ie_situacao_w			nota_fiscal.ie_situacao%type;
qt_rateio_w bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	material_lote_fornec
	where	nr_sequencia_nf	= nr_sequencia_p;

C02 CURSOR FOR
	SELECT	nr_titulo,
		vl_saldo_titulo
	from	titulo_receber
	where	nr_seq_nf_saida = nr_sequencia_p
	and	ie_situacao	<> '3'; --lhalves OS 498856 em 26/09/2012 - Desconsiderar titulos ja cancelados
c03 CURSOR FOR
	SELECT	a.nr_titulo,
		b.nr_adiantamento,
		b.vl_adiantamento,
		b.nr_sequencia
	from	titulo_pagar_adiant b,
		titulo_pagar a
	where	a.nr_seq_nota_fiscal	= nr_sequencia_p
	and	a.nr_titulo		= b.nr_titulo;

c04 CURSOR FOR
	SELECT	qt_item_nf,
		nr_emprestimo,
		nr_seq_item_emprestimo
	from	nota_fiscal_item
	where	nr_sequencia = nr_sequencia_p
	and	nr_emprestimo > 0
	and	nr_seq_item_emprestimo > 0;

c05 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(ds_email_remetente,'X'),
		replace(ds_email_adicional,',',';'),
		coalesce(ie_momento_envio,'I'),
		ie_usuario
	from	regra_envio_email_compra
	where	ie_tipo_mensagem = 59
	and	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w
	and	(ds_email_adicional IS NOT NULL AND ds_email_adicional::text <> '')
	and	ie_contas_pagar_w = 'S'
	
union

	SELECT	nr_sequencia,
		coalesce(ds_email_remetente,'X'),
		replace(ds_email_adicional,',',';'),
		coalesce(ie_momento_envio,'I'),
		ie_usuario
	from	regra_envio_email_compra
	where	ie_tipo_mensagem = 61
	and	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w
	and	(ds_email_adicional IS NOT NULL AND ds_email_adicional::text <> '')
	and	ie_contas_receber_w = 'S';
	
c06 CURSOR FOR	
	SELECT	coalesce(a.nr_titulo, 0),
		coalesce(a.nr_sequencia, 0)
	from	titulo_pagar_baixa a,
		titulo_pagar b
	where	a.nr_titulo		= b.nr_titulo
	and	b.nr_seq_nota_fiscal 	= nr_sequencia_ref_w
	and	nr_seq_devolucao	= nr_sequencia_p;
	
c07 CURSOR FOR
	SELECT nr_item_nf,
	       vl_total_item_nf
	from   nota_fiscal_item
	where  nr_sequencia = nr_sequencia_p;


BEGIN

select 	ie_situacao
into STRICT 	ie_situacao_w
from 	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

if (ie_situacao_w  (2,3)) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1132944);
end if;

-- validacoes da funcao OPS - Pagamento de Producao Medica
select  count(1)
into STRICT	qt_existe_w
from	pls_pp_base_acum_trib	b,
	pls_pp_prestador	a
where	a.nr_seq_prestador	= b.nr_seq_prestador
and	a.nr_seq_lote 		= b.nr_seq_lote_pgto_orig
and	b.nr_seq_nota_fiscal	= nr_sequencia_p
and	coalesce(a.ie_cancelado::text, '') = '';

if (qt_existe_w > 0) then
	-- Nao e possivel excluir esta nota, seus tributos foram utilizados como base de calculo na funcao

	-- OPS - Pagamentos de Producao Medica(nova).
	CALL wheb_mensagem_pck.exibir_mensagem_abort(461022);
end if;

select	count(1)
into STRICT	qt_existe_w
from	pls_pp_lr_base_trib	b,
	pls_pp_prestador	a
where	a.nr_seq_prestador	= b.nr_seq_prestador
and	a.nr_seq_lote 		= b.nr_seq_lote_pgto
and	b.nr_seq_nota_fiscal = nr_sequencia_p
and	coalesce(a.ie_cancelado::text, '') = '';

if (qt_existe_w > 0) then
	-- Nao e possivel excluir esta nota, seus tributos foram utilizados como base de calculo na funcao

	-- OPS - Pagamentos de Producao Medica(nova).
	CALL wheb_mensagem_pck.exibir_mensagem_abort(461022);
end if;
-- fim validacoes da funcao OPS - Pagamento de Producao Medica
ie_commit_w		:= coalesce(ie_commit_p, 'S');

ie_atualizou_preco_w	:= 'S';
cd_perfil_ativo_w	:= obter_perfil_ativo;

select	cd_estabelecimento,
	dt_emissao,
	dt_entrada_saida,
	nr_seq_far_venda
into STRICT	cd_estabelecimento_w,
	dt_emissao_w,
	dt_entrada_saida_ant_w,
	nr_seq_far_venda_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

ie_atualiza_dt_ent_saida_w	:= coalesce((obter_valor_param_usuario(40, 372, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_w)), 'N');

if	((ie_atualiza_dt_ent_saida_w = 'S') or (ie_atualiza_dt_ent_saida_w = 'A')) then
	update	nota_fiscal
	set	ie_situacao		= '3',
		dt_cancelamento		= clock_timestamp(),
		dt_emissao		= clock_timestamp(),
		dt_entrada_saida	= clock_timestamp(),
		nm_usuario_cancel	= nm_usuario_p
	where	nr_sequencia		= nr_sequencia_p;

else
	update	nota_fiscal
	set	ie_situacao		= '3',
		dt_cancelamento		= clock_timestamp(),
		nm_usuario_cancel	= nm_usuario_p
	where	nr_sequencia		= nr_sequencia_p;
end if;

update	nf_credito
set	ie_situacao 		= 3,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_seq_nf_gerada 	= nr_sequencia_p;

select	coalesce(nr_interno_conta,0),
	coalesce(nr_seq_protocolo,0),
	nr_seq_mensalidade,
	nr_seq_baixa_tit,
	nr_seq_fatura,
	nr_seq_fatura_ndc
into STRICT	nr_interno_conta_w,
	nr_seq_protocolo_w,
	nr_seq_mensalidade_w,
	nr_seq_baixa_tit_w,
	nr_seq_fatura_w,
	nr_seq_fatura_ndc_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

if	((nr_seq_mensalidade_w IS NOT NULL AND nr_seq_mensalidade_w::text <> '') or (nr_seq_baixa_tit_w IS NOT NULL AND nr_seq_baixa_tit_w::text <> '')) then
	ie_commit_w	:= 'N';
end if;

-- Verifica se a nota fiscal e de faturamento
if	((nr_seq_fatura_w IS NOT NULL AND nr_seq_fatura_w::text <> '') or (nr_seq_fatura_ndc_w IS NOT NULL AND nr_seq_fatura_ndc_w::text <> '')) then
	ds_mot_canc_fat_w := substr(wheb_mensagem_pck.get_texto(1055534),1,255);
	
	-- Titulo receber
	if (nr_seq_fatura_w IS NOT NULL AND nr_seq_fatura_w::text <> '') then
		-- Remove o titulo/nota a receber que sera cancelado
		CALL pls_desv_tit_lote_faturamento(nr_seq_fatura_w, null, nm_usuario_p, 'N', null, coalesce(ds_motivo_canc_p, ds_mot_canc_fat_w), ie_origem_p);
	end if;
	
	-- Titulo receber NDC
	if (nr_seq_fatura_ndc_w IS NOT NULL AND nr_seq_fatura_ndc_w::text <> '') then
		-- Remove o titulo/nota a receber que sera cancelado
		CALL pls_desv_tit_lote_faturamento(nr_seq_fatura_ndc_w, null, nm_usuario_p, 'N', null, coalesce(ds_motivo_canc_p, ds_mot_canc_fat_w), ie_origem_p);
	end if;
end if;

select	count(*)
into STRICT	qt_titulo_nf_saida_w
from	titulo_receber
where	nr_seq_nf_saida	= nr_sequencia_p
and	ie_situacao	<> '3'; --lhalves OS 498856 em 26/09/2012 - Desconsiderar titulos ja cancelados
begin
update	preco_material
set	ie_situacao = 'I'
where	nr_sequencia_nf	= nr_sequencia_p;
exception
	when others then
	ie_atualizou_preco_w := 'N';
end;

if (ie_atualizou_preco_w = 'S') then
	begin
	delete	from material_preco_dia a
	where	a.cd_material in (
		SELECT	distinct(b.cd_material)
		from	nota_fiscal_item b
		where	b.nr_sequencia = nr_sequencia_p);
	exception
		when others then
			ie_atualizou_preco_w := 'N';
	end;
end if;

select	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	cd_pessoa_fisica,
	dt_entrada_saida,
	vl_total_nota,
	nr_sequencia_ref,
	ie_tipo_nota,
	nr_ordem_compra,
	nr_seq_nf_ref
into STRICT	cd_cgc_emitente_w,
	cd_serie_nf_w,
	nr_nota_fiscal_w,
	cd_pessoa_fisica_w,
	dt_entrada_saida_w,
	vl_total_nota_w,
	nr_sequencia_ref_w,
	ie_tipo_nota_w,
	nr_ordem_compra_w,
	nr_seq_nf_ref_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

select	coalesce(a.ie_devolucao,'N'),
	coalesce(ie_transferencia_estab,'N')
into STRICT	ie_devolucao_w,
	ie_transferencia_estab_w
from	operacao_nota a,
	nota_fiscal b
where	a.cd_operacao_nf = b.cd_operacao_nf
and	b.nr_sequencia = nr_sequencia_p;

select	coalesce(max(ie_integracao_nota),'N'),
	coalesce(max(ie_limpa_vinc_oc_nf),'N')
into STRICT	ie_integracao_nota_w,
	ie_limpa_vinc_oc_nf_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_w;

/*Fabio 28/04/2006 - para tratamento do local direto*/

select	coalesce(max(cd_oper_ent_pass_direta),0),
	coalesce(max(cd_oper_cons_pass_direta),0),
	coalesce(max(ie_inativa_lote_est_nf),'N'),
	coalesce(max(ie_empenho_orcamento),'N')
into STRICT	cd_oper_ent_pass_direta_w,
	cd_oper_cons_pass_direta_w,
	ie_inativa_lote_est_nf_w,
	ie_empenho_orcamento_w
from	parametro_estoque
where	cd_estabelecimento = cd_estabelecimento_w;

select	coalesce(max(ie_canc_titulo_nota),'B')
into STRICT	ie_canc_titulo_nota_w
from	parametro_contas_receber
where	cd_estabelecimento	= cd_estabelecimento_w;

select	coalesce(max(a.ie_desvincular_adiant_nf),'N')
into STRICT	ie_desvincular_adiant_nf_w
from	parametros_contas_pagar a
where	a.cd_estabelecimento	= cd_estabelecimento_w;

select	count(*)
into STRICT	qt_item_direto_w
from	nota_fiscal_item
where	nr_sequencia		= nr_sequencia_p
and	(cd_material IS NOT NULL AND cd_material::text <> '')
and (obter_se_local_direto(cd_local_estoque) = 'S');
/*Fabio 28/04/2006 - Fim alteracao*/

select (max(nr_sequencia_nf)+1)
into STRICT	nr_sequencia_nf_w
from	nota_fiscal
where	cd_estabelecimento = cd_estabelecimento_w
and	((cd_cgc_emitente_w IS NOT NULL AND cd_cgc_emitente_w::text <> '' AND cd_cgc_emitente = cd_cgc_emitente_w) or (coalesce(cd_cgc_emitente_w::text, '') = ''))
and	cd_serie_nf = cd_serie_nf_w
and	nr_nota_fiscal = nr_nota_fiscal_w
and	cd_estabelecimento = cd_estabelecimento_w;

select	nextval('nota_fiscal_seq')
into STRICT	nr_sequencia_w
;

insert into nota_fiscal(
	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
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
	dt_contabil,
	cd_cgc,
	cd_pessoa_fisica,
	vl_ipi,
	vl_descontos,
	vl_frete,
	vl_seguro,
	vl_despesa_acessoria,
	ds_observacao,
	nr_nota_referencia,
	cd_serie_referencia,
	cd_natureza_operacao,
	dt_atualizacao_estoque,
	vl_desconto_rateio,
	ie_situacao,
	nr_ordem_compra,
	nr_lote_contabil,
	nr_sequencia,
	nr_sequencia_ref,
	ie_tipo_nota,
	nr_seq_protocolo,
	nr_interno_conta,
	nm_usuario_calc,
	nr_nfe_imp,
	vl_conv_estrangeiro,
	vl_conv_moeda,
	cd_moeda_estrangeira)
SELECT	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf_w,
	cd_operacao_nf,
	CASE WHEN ie_atualiza_dt_ent_saida_w='S' THEN  dt_emissao WHEN ie_atualiza_dt_ent_saida_w='A' THEN  dt_emissao_w WHEN ie_atualiza_dt_ent_saida_w='O' THEN  clock_timestamp()  ELSE dt_emissao END ,
	CASE WHEN ie_atualiza_dt_ent_saida_w='S' THEN  dt_entrada_saida WHEN ie_atualiza_dt_ent_saida_w='A' THEN  dt_entrada_saida_ant_w WHEN ie_atualiza_dt_ent_saida_w='O' THEN  clock_timestamp()  ELSE dt_entrada_saida END ,
	'2',
	ie_emissao_nf,
	ie_tipo_frete,
	vl_mercadoria,
	vl_total_nota,
	qt_peso_bruto,
	qt_peso_liquido,
	dt_atualizacao_w,
	nm_usuario_p,
	cd_condicao_pagamento,
	dt_contabil,
	cd_cgc,
	cd_pessoa_fisica,
	vl_ipi,
	vl_descontos,
	vl_frete,
	vl_seguro,
	vl_despesa_acessoria,
	ds_observacao,
	nr_nota_referencia,
	cd_serie_referencia,
	cd_natureza_operacao,
	null,
	vl_desconto_rateio,
	'2',
	CASE WHEN ie_limpa_vinc_oc_nf_w='S' THEN null  ELSE nr_ordem_compra END ,
	0,
	nr_sequencia_w,
	nr_sequencia,
	ie_tipo_nota,
	nr_seq_protocolo,
	nr_interno_conta,
	nm_usuario_calc,
	nr_nfe_imp,
	vl_conv_estrangeiro,
	vl_conv_moeda,
	cd_moeda_estrangeira
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

insert into nota_fiscal_item(
	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
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
	cd_setor_atendimento,
	cd_conta,
	cd_local_estoque,
	ds_observacao,
	qt_peso_bruto,
	qt_peso_liquido,
	cd_unidade_medida_compra,
	qt_item_estoque,
	cd_unidade_medida_estoque,
	cd_lote_fabricacao,
	dt_validade,
	dt_atualizacao_estoque,
	cd_conta_contabil,
	vl_desconto_rateio,
	vl_seguro,
	cd_centro_custo,
	cd_material_estoque,
	ie_origem_proced,
	nr_ordem_compra,
	nr_item_oci,
	nr_sequencia,
	vl_liquido,
	nr_seq_ordem_serv,
	nr_seq_lote_fornec,
	dt_inicio_garantia,
	dt_fim_garantia,
	dt_entrega_ordem,
	nr_seq_conta_financ,
	vl_total_estrangeiro,
	vl_unit_estrangeiro, 
	vl_dif_estrangeiro,
    nr_seq_proj_rec)
SELECT	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf_w,
	nr_item_nf,
	cd_natureza_operacao,
	qt_item_nf,
	vl_unitario_item_nf,
	vl_total_item_nf,
	dt_atualizacao_w,
	nm_usuario_p,
	vl_frete,
	vl_desconto,
	vl_despesa_acessoria,
	cd_material,
	cd_procedimento,
	cd_setor_atendimento,
	cd_conta,
	cd_local_estoque,
	ds_observacao,
	qt_peso_bruto,
	qt_peso_liquido,
	cd_unidade_medida_compra,
	qt_item_estoque,
	cd_unidade_medida_estoque,
	cd_lote_fabricacao,
	dt_validade,
	dt_atualizacao_estoque,
	cd_conta_contabil,
	vl_desconto_rateio,
	vl_seguro,
	cd_centro_custo,
	cd_material_estoque,
	ie_origem_proced,
	CASE WHEN ie_limpa_vinc_oc_nf_w='S' THEN null  ELSE nr_ordem_compra END ,
	CASE WHEN ie_limpa_vinc_oc_nf_w='S' THEN null  ELSE nr_item_oci END ,
	nr_sequencia_w,
	vl_liquido,
	nr_seq_ordem_serv,
	nr_seq_lote_fornec,
	dt_inicio_garantia,
	dt_fim_garantia,
	dt_entrega_ordem,
	nr_seq_conta_financ,
	vl_total_estrangeiro, 
	vl_unit_estrangeiro, 
	vl_dif_estrangeiro,
    nr_seq_proj_rec
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_p;

insert into nota_fiscal_trib(
	ie_retencao,
	nr_sequencia,
	cd_tributo,
	vl_tributo,
	dt_atualizacao,
	nm_usuario,
	vl_base_calculo,
	tx_tributo,
	vl_reducao_base,
	vl_trib_nao_retido,
	vl_base_nao_retido,
	vl_trib_adic,
	vl_base_adic,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_interno)
SELECT ie_retencao,	
	nr_sequencia_w,
	cd_tributo,
	vl_tributo,
	dt_atualizacao,
	nm_usuario,
	vl_base_calculo,
	tx_tributo,
	vl_reducao_base,
	vl_trib_nao_retido,
	vl_base_nao_retido,
	vl_trib_adic,
	vl_base_adic,
	clock_timestamp(),
	nm_usuario_p,
	nextval('nota_fiscal_trib_seq')
from	nota_fiscal_trib
where	nr_sequencia = nr_sequencia_p;

insert into fis_rateio_trib_item(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_centro_custo,
	cd_tributo,
	pr_percentual,
	vl_rateio,
	nr_seq_nota_fiscal,
	nr_item_nf)
SELECT	nextval('fis_rateio_trib_item_seq'),
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	clock_timestamp(),
	nm_usuario_p,
	cd_centro_custo,
	cd_tributo,
	pr_percentual,
	vl_rateio,
	nr_sequencia_w,
	nr_item_nf
from	fis_rateio_trib_item
where	nr_seq_nota_fiscal = nr_sequencia_p;

insert into nota_fiscal_venc(
	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf,
	dt_vencimento,
	vl_vencimento,
	dt_atualizacao,
	nm_usuario,
	nr_sequencia,
	ie_origem)
SELECT	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf_w,
	dt_vencimento,
	vl_vencimento,
	dt_atualizacao_w,
	nm_usuario_p,
	nr_sequencia_w,
	coalesce(ie_origem,'N')
from	nota_fiscal_venc
where	nr_sequencia = nr_sequencia_p;

insert into nota_fiscal_venc_trib(
	nr_sequencia,
	dt_vencimento,
	cd_tributo,
	vl_tributo,
	dt_atualizacao,
	nm_usuario,
	vl_base_calculo,
	tx_tributo,
	vl_trib_nao_retido,
	vl_base_nao_retido,
	vl_trib_adic,
	vl_base_adic,
	vl_reducao,
	vl_desc_base,
	cd_darf,
	ie_origem)
SELECT	nr_sequencia_w,
	dt_vencimento,
	cd_tributo,
	vl_tributo,
	dt_atualizacao_w,
	nm_usuario_p,
	vl_base_calculo,
	tx_tributo,
	vl_trib_nao_retido,
	vl_base_nao_retido,
	vl_trib_adic,
	vl_base_adic,
	vl_reducao,
	vl_desc_base,
	cd_darf,
	coalesce(ie_origem,'N')
from	nota_fiscal_venc_trib
where	nr_sequencia = nr_sequencia_p;

insert into nota_fiscal_item_trib(
	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf,
	nr_item_nf,
	cd_tributo,
	vl_tributo,
	dt_atualizacao,
	nm_usuario,
	vl_base_calculo,
	tx_tributo,
	vl_reducao_base,
	nr_sequencia,
	ie_rateio,
	vl_trib_nao_retido,
	vl_base_nao_retido,
	vl_trib_adic,
	vl_base_adic)
SELECT
	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf_w,
	nr_item_nf,
	cd_tributo,
	vl_tributo,
	dt_atualizacao_w,
	nm_usuario,
	vl_base_calculo,
	tx_tributo,
	vl_reducao_base,
	nr_sequencia_w,
	ie_rateio,
	vl_trib_nao_retido,
	vl_base_nao_retido,
	vl_trib_adic,
	vl_base_adic
from	nota_fiscal_item_trib
where	nr_sequencia = nr_sequencia_p;

/* Fabio 29/06/2004 coloquei o insert abaixo, porque nao estava inserindo o rateio*/

insert into Nota_Fiscal_Item_Rateio(
	nr_sequencia,
	nr_seq_nota,
	nr_item_nf,
	nr_seq_criterio,
	dt_atualizacao,
	nm_usuario,
	cd_centro_custo,
	cd_conta_contabil,
	cd_conta_financ,
	vl_rateio,
	vl_frete,
	vl_desconto,
	vl_seguro,
	vl_despesa_acessoria,
	ie_situacao,
	qt_rateio)
SELECT	nextval('nota_fiscal_item_rateio_seq'),
	nr_sequencia_w,
	nr_item_nf,
	nr_seq_criterio,
	clock_timestamp(),
	nm_usuario_p,
	cd_centro_custo,
	cd_conta_contabil,
	cd_conta_financ,
	vl_rateio,
	vl_frete,
	vl_desconto,
	vl_seguro,
	vl_despesa_acessoria,
	ie_situacao,
	qt_rateio
from	Nota_Fiscal_Item_Rateio
where	nr_seq_nota    = nr_sequencia_p;
/* Fabio 29/06/2004 Fim Alteracao*/



/* Fabio 06/07/2004 coloquei o insert abaixo, porque nao estava inserindo as despesas adicionais*/

insert into nota_fiscal_desp_adic(
	nr_sequencia,
	nr_seq_nf,
	nr_documento,
	dt_emissao,
	vl_documento,
	dt_vencimento,
	cd_cgc,
	ds_observacao,
	dt_atualizacao,
	nm_usuario)
SELECT	nextval('nota_fiscal_desp_adic_seq'),
	nr_sequencia_w,
	nr_documento,
	dt_emissao,
	vl_documento,
	dt_vencimento,
	cd_cgc,
	ds_observacao,
	clock_timestamp(),
	nm_usuario_p
from	nota_fiscal_desp_adic
where	nr_seq_nf = nr_sequencia_p;

insert into nota_fiscal_item_lote(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_nota,
	nr_item_nf,
	dt_validade,
	qt_material,
	cd_lote_fabricacao,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_marca,
	nr_seq_lote_fornec,
	ie_indeterminado)
SELECT	nextval('nota_fiscal_item_lote_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_sequencia_w,
	nr_item_nf,
	dt_validade,
	qt_material,
	cd_lote_fabricacao,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_marca,
	nr_seq_lote_fornec,
	ie_indeterminado
from	nota_fiscal_item_lote
where	nr_seq_nota = nr_sequencia_p;

insert into nota_fiscal_conta(
	nr_sequencia,
	nr_seq_nf,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_conta_contabil,
	vl_contabil)
SELECT	nextval('nota_fiscal_conta_seq'),
	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_conta_contabil,
	vl_contabil
from	nota_fiscal_conta
where	nr_seq_nf = nr_sequencia_p;

if (nr_sequencia_ref_w > 0) then

	select	coalesce(max(nr_ordem_compra),0)
	into STRICT	nr_ordem_compra_ww
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_ref_w;
end if;

if (ie_integracao_nota_w = 'P') and (ie_tipo_nota_w = 'EN') and (nr_ordem_compra_w > 0) and (ie_transferencia_estab_w = 'N') then

	delete from erros_integracao_piramide
	where	cd_Estabelecimento = cd_estabelecimento_w
	and	nm_usuario = nm_usuario_p
	and	ie_funcao in ('NFE','NFS');

	CALL exec_sql_dinamico('Tasy','begin pir_envia_nota_fiscal_entrada('
			|| nr_sequencia_p || ','
			|| 1 || ','
			|| chr(39) || nm_usuario_p || chr(39) || '); end;');

	select	max(ds_erro)
	into STRICT	ds_erro_w
	from	erros_integracao_piramide
	where	cd_Estabelecimento = cd_estabelecimento_w
	and	nm_usuario = nm_usuario_p
	and	ie_funcao in ('NFE');

	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(188158,'DS_MENSAGEM=' || ds_erro_w);
	end if;
end if;


if (ie_integracao_nota_w = 'P') and (ie_tipo_nota_w = 'SD') and (ie_devolucao_w = 'S')and (nr_ordem_compra_ww > 0) and (ie_transferencia_estab_w = 'N') then

	delete from erros_integracao_piramide
	where	cd_Estabelecimento = cd_estabelecimento_w
	and	nm_usuario = nm_usuario_p
	and	ie_funcao in ('NFE','NFS');

	CALL exec_sql_dinamico('Tasy','begin pir_envia_nota_fiscal_devol('
			|| nr_sequencia_p || ','
			|| 1 || ','
			|| chr(39) || nm_usuario_p || chr(39) || '); end;');

	select	max(ds_erro)
	into STRICT	ds_erro_w
	from	erros_integracao_piramide
	where	cd_Estabelecimento = cd_estabelecimento_w
	and	nm_usuario = nm_usuario_p
	and	ie_funcao in ('NFS');

	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(188158,'DS_MENSAGEM=' || ds_erro_w);
	end if;
end if;

if (nr_seq_protocolo_w < 1) and (nr_interno_conta_w < 1) then
	begin
	CALL Gerar_movto_estoque_NF(nr_sequencia_w, nm_usuario_p);

	/*Gerar movimentacao para itens de passagem direta
	Movimentacao de entrada e Movimentacao de consumo*/
	if (cd_oper_ent_pass_direta_w > 0) and (cd_oper_cons_pass_direta_w > 0) and (qt_item_direto_w > 0) then
		CALL Gerar_movto_estoque_direto_nf( nr_sequencia_w, nm_usuario_p);
	end if;

	if (coalesce(ie_desvincular_adiant_nf_w,'N') = 'S') then
		open	c03;
		loop
		fetch	c03 into
			nr_titulo_w,
			nr_adiantamento_w,
			vl_adiantamento_w,
			nr_seq_tit_adiant_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */

			CALL atualiza_adiantamento_pago(nr_titulo_w,nr_adiantamento_w,vl_adiantamento_w,nr_seq_tit_adiant_w,nm_usuario_p,'E');

		end loop;
		close c03;
	end if;

	CALL Gerar_Titulo_Pagar_NF( nr_sequencia_w, nm_usuario_p);

	CALL atualizar_ordem_compra_nf(nr_sequencia_p, nm_usuario_p, 'E');

	update	nota_fiscal
	set	dt_atualizacao_estoque	= clock_timestamp()
	where	nr_sequencia		= nr_sequencia_w;
	
	CALL sup_atualizar_opm_nf(nr_sequencia_p, 'E', nm_usuario_p);
	end;
end if;

/*Coloquei este Update aqui porque:
Para notas de protocolo e conta, atualiza a data somente se a nota original tem a data*/
if	((nr_seq_protocolo_w > 0) or (nr_interno_conta_w > 0)) then
	select	count(*)
	into STRICT	ie_calculada_conta_prot_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_p
	and	(dt_atualizacao_estoque IS NOT NULL AND dt_atualizacao_estoque::text <> '');
	if (ie_calculada_conta_prot_w > 0) then
		begin
		update	nota_fiscal
		set	dt_atualizacao_estoque	= clock_timestamp()
		where	nr_sequencia		= nr_sequencia_w;
		
		CALL sup_atualizar_opm_nf(nr_sequencia_p, 'E', nm_usuario_p);
		end;
	end if;
end if;

/* Bruna - retirar o vinculo com o repasse caso a nota tenha sido estornada */

select 	coalesce(count(*),0)
into STRICT	qt_nota_repasse_w
from	repasse_nota_fiscal
where	nr_seq_nota_fiscal = nr_sequencia_p;

if (qt_nota_repasse_w > 0) then
	delete 	FROM repasse_nota_fiscal
	where	nr_seq_nota_fiscal = nr_sequencia_p;
end if;

if (nr_seq_protocolo_w < 1) and (nr_interno_conta_w < 1) and (qt_titulo_nf_saida_w > 0) then
	if (ie_canc_titulo_nota_w = 'A') then
		open c02;
		loop
		fetch c02 into
			nr_titulo_w,
			vl_saldo_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			CALL cancelar_titulo_receber(nr_titulo_w,nm_usuario_p,'N',clock_timestamp());
		end loop;
		close c02;
	else
		CALL cancelar_titulo_receber_nfs(nr_sequencia_p, nm_usuario_p, cd_estabelecimento_w);
	end if;
end if;


ds_historico_w		:= Wheb_mensagem_pck.get_Texto(300831); /*'Nota fiscal estornada';*/
select	count(*)
into STRICT	qt_existe_w
from	material_lote_fornec
where	nr_sequencia_nf	= nr_sequencia_p;
if (qt_existe_w > 0) then
	begin

	ds_historico_w		:= '';
	open c01;
	loop
	fetch c01 into
		nr_seq_lote_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (coalesce(ds_historico_w,'X') = 'X') then
			ds_historico_w	:= substr(Wheb_mensagem_pck.get_Texto(300832, 'NR_SEQ_LOTE_W='||NR_SEQ_LOTE_W),1,255); /*substr('Lotes existentes ao estornar (Seq): ' || nr_seq_lote_w,1,255);*/
		else
			ds_historico_w	:= substr(ds_historico_w || ', ' || nr_seq_lote_w,1,255);
		end if;

		if (ie_inativa_lote_est_nf_w = 'S') then
			CALL inativar_lote_fornec_est_nf(nr_seq_lote_w, nr_sequencia_p, nm_usuario_p);
		end if;
		end;
	end loop;
	close c01;
	end;
end if;

CALL gerar_historico_nota_fiscal(nr_sequencia_p, nm_usuario_p, '2', ds_historico_w);

/*Limpar a inspecao recebimento, caso a nota tenha sido gerada pela inspecao*/

select	count(*)
into STRICT	qt_registro_w
from	inspecao_recebimento
where	nr_seq_nota_fiscal = nr_sequencia_p;
if (qt_registro_w > 0) then
	update	inspecao_recebimento
	set	nr_seq_nota_fiscal = '',
		nr_seq_item_nf 	   = ''
	where	nr_seq_nota_fiscal = nr_sequencia_p;
end if;

select	count(*)
into STRICT	qt_existe_w
from	inspecao_registro
where	nr_seq_nf = nr_sequencia_p;

if (qt_existe_w > 0) then
	update	inspecao_registro
	set	nr_seq_nf  = NULL,
		nr_seq_nf_estornada = nr_sequencia_p
	where	nr_seq_nf = nr_sequencia_p;
end if;


select	coalesce(max(nr_seq_lote_prot),0)
into STRICT	nr_seq_lote_prot_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_lote_prot_w > 0) then
	select	count(*)
	into STRICT	qt_existe_w
	from	nota_fiscal
	where	nr_seq_lote_prot = nr_seq_lote_prot_w;

	if (qt_existe_w > 0) then
		update	lote_protocolo
		set	dt_geracao_nota = ''
		where	nr_sequencia = nr_seq_lote_prot_w;
	end if;

	update	nota_fiscal
	set	nr_seq_lote_prot  = NULL
	where	nr_sequencia = nr_sequencia_p;
end if;

if (ie_limpa_vinc_oc_nf_w = 'S') then
	update	nota_fiscal
	set	nr_ordem_compra  = NULL
	where	nr_sequencia = nr_sequencia_p;

	update	nota_fiscal_item
	set	nr_ordem_compra  = NULL,
		nr_item_oci  = NULL
	where	nr_sequencia = nr_sequencia_p;
end if;

select	coalesce(max(nr_seq_transf_cme),0)
into STRICT	nr_seq_transf_cme_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_transf_cme_w > 0) then
	CALL cm_estorna_movto_conjunto(nr_seq_transf_cme_w);
end if;

select	count(*)
into STRICT	qt_rateio_w
from	nota_fiscal_oc_rateio
where	nr_seq_nota_rateio = nr_sequencia_p
and ie_situacao = 'N';

if (qt_rateio_w > 0) then
   update nota_fiscal_oc_rateio
   set ie_situacao = 'E'
   where	nr_seq_nota_rateio = nr_sequencia_p;
end if;

open C04;
loop
fetch C04 into
	qt_item_nf_w,
	nr_emprestimo_w,
	nr_seq_item_emprestimo_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
	update	emprestimo_material
	set	qt_nota_fiscal = coalesce(qt_nota_fiscal,0) - coalesce(qt_item_nf_w,0)
	where	nr_emprestimo = nr_emprestimo_w
	and	nr_sequencia = nr_seq_item_emprestimo_w;
	end;
end loop;
close C04;

/*Deletar registros da ultima compra*/

delete from sup_dados_ultima_compra
where	nr_seq_nota = nr_sequencia_p;

CALL grava_dados_ultima_compra(nr_sequencia_p, 2, nm_usuario_p);

CALL FIN_Cancelar_NF_RAT(nr_sequencia_p);

select	username
into STRICT	nm_user_w
from	user_users;
if (nm_user_w = 'CORP') then
	begin
	select	coalesce(max(nr_ordem_compra), 0)
	into STRICT	nr_ordem_compra_rep_w
	from	ordem_compra
	where	nr_seq_nf_repasse = nr_sequencia_p;

	if (nr_ordem_compra_rep_w > 0) then
		update	ordem_compra
		set	dt_baixa		= clock_timestamp(),
			ds_observacao	= substr(Wheb_mensagem_pck.get_Texto(300834, 'DS_OBSERVACAO_W='||DS_OBSERVACAO),1,4000) /*Baixa pelo cancelamento da NF do repasse' || DS_OBSERVACAO*/
		where	nr_ordem_compra	= nr_ordem_compra_rep_w;
	end if;
	end;
end if;

select	nvl(max(a.ie_contas_pagar),'N'),
	nvl(max(a.ie_contas_receber),'N')
into	ie_contas_pagar_w,
	ie_contas_receber_w
from	operacao_nota a,
	nota_fiscal b
where	a.cd_operacao_nf = b.cd_operacao_nf
and	b.nr_sequencia = nr_sequencia_p;

open C05;
loop
fetch C05 into
	nr_seq_regra_w,
	ds_email_remetente_w,
	ds_email_destino_w,
	ie_momento_envio_w,
	ie_usuario_w;
exit when C05%notfound;
	begin
	select	substr(obter_cgc_cpf_editado(cd_cgc_emitente_w),1,30),
		substr(obter_nome_pf_pj(null,cd_cgc_emitente_w),1,255),
		substr(obter_dados_pf_pj(null,cd_cgc_emitente_w,'F'),1,100),
		substr(campo_mascara_virgula(vl_total_nota_w),1,100),
		substr(obter_nome_usuario(nm_usuario_p),1,100),
		substr(obter_desc_cargo(obter_dados_usuario_opcao(nm_usuario_p,'R')),1,80),
		substr(obter_nome_pf_pj(cd_pessoa_fisica_w,null),1,100)
	into	cd_cnpj_editado_w,
		ds_razao_social_w,
		ds_fantasia_w,
		ds_total_nota_w,
		nm_usuario_completo_w,
		ds_cargo_w,
		nm_pessoa_fisica_w
	from	dual;

	if	(ie_usuario_w = 'U') then --Usuario
		select	substr(obter_dados_usuario_opcao(nm_usuario_p,'M'),1,8),
			substr(obter_dados_usuario_opcao(nm_usuario_p,'E'),1,255),
			substr(obter_dados_pf_pj(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),obter_cgc_estabelecimento(cd_estabelecimento_w),'T'),1,15)
		into	nr_ramal_w,
			ds_email_w,
			nr_telefone_w
		from	usuario
		where	nm_usuario = nm_usuario_p;
	elsif	(ie_usuario_w = 'C') then --Setor compras
		select	ds_email,
			nr_telefone
		into	ds_email_w,
			nr_telefone_w
		from	parametro_compras
		where	cd_estabelecimento = cd_estabelecimento_w;
	end if;

	select	substr(ds_assunto,1,80),
		substr(ds_mensagem_padrao,1,4000)
	into	ds_assunto_w,
		ds_mensagem_w
	from	regra_envio_email_compra
	where	nr_sequencia = nr_seq_regra_w;
	
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nr_nota_fiscal',nr_nota_fiscal_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cnpj_editado',cd_cnpj_editado_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cnpj',cd_cgc_emitente_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@razao_pj',ds_razao_social_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@fantasia_pj',ds_fantasia_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cd_pessoa_fisica',cd_pessoa_fisica_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nm_pessoa_fisica',nm_pessoa_fisica_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_entrada_saida',dt_entrada_saida_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@vl_nota',ds_total_nota_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nm_usuario',nm_usuario_completo_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@usuario',nm_usuario_p),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cargo',ds_cargo_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@fone',nr_telefone_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ramal',nr_ramal_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@email',ds_email_w),1,4000);

	if	(ds_email_remetente_w <> 'X') then
		ds_email_w	:= ds_email_remetente_w;
	end if;

	begin
	if	(ie_momento_envio_w = 'A') then
		begin
		sup_grava_envio_email(
			'NF',
			'59',
			nr_sequencia_p,
			null,
			null,
			ds_email_destino_w,
			nm_usuario_p,
			ds_email_w,
			ds_assunto_w,
			ds_mensagem_w,
			cd_estabelecimento_w,
			nm_usuario_p);
		end;
	else
		begin
		enviar_email(
			ds_assunto_w,
			ds_mensagem_w,
			ds_email_w,
			ds_email_destino_w,
			nm_usuario_p,
			'M');
		end;
	end if;
	exception
	when others then
		null;
	end;
	end;
end loop;
close C05;


/*
comentado na OS 874216, devido a problemas de performance em outros clientes
select	count(1)
into	qt_existe_w
from	prescr_material
where	nr_seq_nf_entrada = nr_sequencia_p;

if	(qt_existe_w > 0) then
	update	prescr_material
	set	nr_seq_nf_entrada = null
	where	nr_seq_nf_entrada = nr_sequencia_p;
end if;*/
if	(ie_tipo_nota_w = 'NC') and
	(nr_seq_nf_ref_w > 0) then
	atualizar_movto_estoque_nf(nr_seq_nf_ref_w, nm_usuario_p);
end if;

if	(ie_empenho_orcamento_w = 'S') then
	begin
	gerar_empenho_nota_fiscal(nr_sequencia_p, '2', nm_usuario_p);
	exception when others then
		ds_erro_w	:= substr(sqlerrm(sqlcode),1,1000);
	end;
end if;

gpi_vincular_nota_fiscal(nr_sequencia_p, 0, 0, 0, 'D', 0, nm_usuario_p, 'N');
gravar_agend_integracao(352, 'NR_SEQ_NOTA_FISCAL=' || nr_sequencia_p || ';');

estornar_enc_contas_abat_nc( nr_sequencia_p,
							 nm_usuario_p);

if	(ie_tipo_nota_w in('SD', 'SE')) and
	(ie_devolucao_w = 'S') and	
	(nr_sequencia_ref_w > 0) then
		
	open C06;
	loop
	fetch C06 into
		nr_titulo_pagar_w,
		nr_sequencia_baixa_pg_w;
	exit when C06%notfound;
		begin

		if (nr_titulo_pagar_w > 0) and (nr_sequencia_baixa_pg_w > 0) then
			
			Estornar_tit_pagar_baixa ( 	nr_titulo_pagar_w,
						nr_sequencia_baixa_pg_w,
						sysdate,
						nm_usuario_p,
						'N');

			Atualizar_Saldo_Tit_Pagar( nr_titulo_pagar_w, nm_usuario_p);
			
		end if;		
		
		end;
	end loop;
	close C06;	
	
end if;


ie_ctb_online_w := ctb_online_pck.get_modo_lote(2, cd_estabelecimento_w);

if	(ie_ctb_online_w = 'S') then
	begin
	ctb_contab_onl_lote_nf_pck.ctb_contabiliza_nota_fiscal(	nr_sequencia_w,
								cd_estabelecimento_w,
								nm_usuario_p);
	end;
end if;

if	(nr_seq_far_venda_w > 0) then
	far_estornar_movto_estoque(nr_seq_far_venda_w,nm_usuario_p, nr_sequencia_p);
end if;

if	(nvl(ie_commit_w,'S') = 'S') then
	commit;
end if;

reg_integracao_p.ie_operacao	:= 'U';
gerar_int_padrao.gravar_integracao('3', nr_sequencia_p, nm_usuario_p, reg_integracao_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_nota_fiscal ( nr_sequencia_p bigint, nm_usuario_p text, ie_commit_p text default 'S', ds_motivo_canc_p text default null, ie_origem_p text default 'D') FROM PUBLIC;
