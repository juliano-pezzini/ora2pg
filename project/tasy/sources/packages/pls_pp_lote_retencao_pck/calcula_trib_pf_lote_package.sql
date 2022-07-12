-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_retencao_pck.calcula_trib_pf_lote ( nr_seq_lote_p pls_pp_lr_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_acumulativo_w	tributo_conta_pagar.ie_acumulativo%type;
vl_teto_base_calc_w	tributo_conta_pagar.vl_teto_base_calculo%type;
vl_minimo_base_w	tributo_conta_pagar.vl_minimo%type;
vl_minimo_tributo_w	tributo_conta_pagar.vl_minimo_tributo%type;
vl_desconto_depend_w	tributo_conta_pagar.vl_desc_dependente%type;
vl_trib_nao_retido_w	pls_pp_valor_trib_pessoa.vl_nao_retido%type;
vl_base_nao_retido_w	pls_pp_valor_trib_pessoa.vl_base_nao_retido%type;
vl_base_adic_w		pls_pp_valor_trib_pessoa.vl_base_adic%type;
vl_trib_adic_w		pls_pp_valor_trib_pessoa.vl_trib_adic%type;
vl_tributo_pago_w	pls_pp_valor_trib_pessoa.vl_tributo_pago%type;
vl_irrelevante_w	double precision;
nr_seq_regra_irpf_w	regra_calculo_irpf.nr_sequencia%type;

-- tabelas utilizadas para fazer o update dos registros
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_vl_base_calc_w	pls_util_cta_pck.t_number_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_trib_pag_w	pls_util_cta_pck.t_number_table;
tb_pr_aliquota_w	pls_util_cta_pck.t_number_table;
tb_dt_pgto_trib_w	pls_util_cta_pck.t_date_table;
tb_nr_seq_trans_reg_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_trans_baixa_w	pls_util_cta_pck.t_number_table;
tb_cd_beneficiario_w	pls_util_cta_pck.t_varchar2_table_20;
tb_ie_periodicidade_w	pls_util_cta_pck.t_varchar2_table_5;
tb_cd_variacao_w	pls_util_cta_pck.t_number_table;
tb_cd_cond_pgto_w	pls_util_cta_pck.t_number_table;
tb_cd_darf_w		pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_classe_w	pls_util_cta_pck.t_number_table;
tb_cd_tipo_baixa_neg_w	pls_util_cta_pck.t_number_table;
tb_ie_vencimento_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_ger_tit_pagar_w	pls_util_cta_pck.t_varchar2_table_5;
tb_cd_conta_financ_w	pls_util_cta_pck.t_number_table;

nr_cont_w		integer;

c01 CURSOR(	nr_seq_lote_pc	pls_pp_lr_lote.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.cd_pessoa_fisica,
		a.vl_base_pgto,
		a.vl_base_acumulada,
		a.ie_tipo_contratacao,
		a.nr_seq_tipo_prestador,
		a.cd_tributo,
		a.vl_base_total,
		a.vl_base_adic,
		a.vl_trib_adic,
		a.vl_base_nao_retido,
		a.vl_nao_retido,
		b.ie_vencimento,
		CASE WHEN b.ie_gerar_titulo_pagar='N' THEN 'S'  ELSE 'N' END  ie_gerar_titulo_pagar, -- se gerar título for "S" é porque gerou titulo no lote de pagamento, se for "N" tem que gerar note lote de retenção
		b.ie_venc_pls_pag_prod,
		(SELECT	max(x.dt_venc_titulo)
		from 	pls_pp_prestador_tmp x
		where	x.cd_pessoa_fisica = a.cd_pessoa_fisica) dt_venc_titulo,
		b.ie_tipo_tributo,
		a.vl_tributo_pago,
		null nr_seq_class_prestador
	from	pls_pp_lr_trib_pessoa a,
		tributo b
	where	a.nr_seq_lote_ret = nr_seq_lote_pc
	and	b.cd_tributo = a.cd_tributo
	and	b.ie_tipo_tributo in ('INSS','IR');

BEGIN
-- inicializa as variáveis
SELECT * FROM pls_pp_lote_retencao_pck.atualizar_valores_trib_pessoa(	nr_cont_w, tb_nr_sequencia_w, tb_nr_seq_trib_pag_w, tb_pr_aliquota_w, tb_vl_base_calc_w, tb_vl_tributo_w, tb_dt_pgto_trib_w, tb_nr_seq_trans_reg_w, tb_nr_seq_trans_baixa_w, tb_cd_beneficiario_w, tb_ie_periodicidade_w, tb_cd_variacao_w, tb_cd_cond_pgto_w, tb_cd_darf_w, tb_nr_seq_classe_w, tb_cd_tipo_baixa_neg_w, tb_ie_vencimento_w, tb_ie_ger_tit_pagar_w, tb_cd_conta_financ_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_nr_seq_trib_pag_w := _ora2pg_r.tb_nr_seq_trib_pag_p; tb_pr_aliquota_w := _ora2pg_r.tb_pr_aliquota_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_dt_pgto_trib_w := _ora2pg_r.tb_dt_pgto_trib_p; tb_nr_seq_trans_reg_w := _ora2pg_r.tb_nr_seq_trans_reg_p; tb_nr_seq_trans_baixa_w := _ora2pg_r.tb_nr_seq_trans_baixa_p; tb_cd_beneficiario_w := _ora2pg_r.tb_cd_beneficiario_p; tb_ie_periodicidade_w := _ora2pg_r.tb_ie_periodicidade_p; tb_cd_variacao_w := _ora2pg_r.tb_cd_variacao_p; tb_cd_cond_pgto_w := _ora2pg_r.tb_cd_cond_pgto_p; tb_cd_darf_w := _ora2pg_r.tb_cd_darf_p; tb_nr_seq_classe_w := _ora2pg_r.tb_nr_seq_classe_p; tb_cd_tipo_baixa_neg_w := _ora2pg_r.tb_cd_tipo_baixa_neg_p; tb_ie_vencimento_w := _ora2pg_r.tb_ie_vencimento_p; tb_ie_ger_tit_pagar_w := _ora2pg_r.tb_ie_ger_tit_pagar_p; tb_cd_conta_financ_w := _ora2pg_r.tb_cd_conta_financ_p;

for r_c01_w in c01(nr_seq_lote_p) loop

	tb_nr_sequencia_w(nr_cont_w) := r_c01_w.nr_sequencia;
	tb_ie_vencimento_w(nr_cont_w) := r_c01_w.ie_vencimento;
	tb_ie_ger_tit_pagar_w(nr_cont_w) := r_c01_w.ie_gerar_titulo_pagar;
	
	-- encontra a regra de tributo conta pagar e os dados necessários para realizar os cálculos do tributo
	SELECT * FROM pls_pp_tributacao_pck.obter_regra_trib_tit_pagar_pf(	r_c01_w.cd_pessoa_fisica, r_c01_w.cd_tributo, r_c01_w.vl_base_pgto, r_c01_w.ie_tipo_contratacao, cd_estabelecimento_p, current_setting('pls_pp_lote_retencao_pck.dt_mes_competencia_lote_w')::pls_pp_lr_lote.dt_mes_competencia%type, r_c01_w.nr_seq_tipo_prestador, r_c01_w.nr_seq_class_prestador) INTO STRICT tb_pr_aliquota_w(nr_cont_w), tb_cd_cond_pgto_w(nr_cont_w), ie_acumulativo_w, vl_teto_base_calc_w, vl_desconto_depend_w, vl_minimo_base_w, vl_minimo_tributo_w, tb_nr_seq_trans_reg_w(nr_cont_w), tb_nr_seq_trans_baixa_w(nr_cont_w), tb_cd_beneficiario_w(nr_cont_w), tb_ie_periodicidade_w(nr_cont_w), tb_cd_variacao_w(nr_cont_w), tb_cd_darf_w(nr_cont_w), tb_nr_seq_classe_w(nr_cont_w), tb_cd_tipo_baixa_neg_w(nr_cont_w), tb_cd_conta_financ_w(nr_cont_w);
												
	tb_dt_pgto_trib_w(nr_cont_w) := pls_pp_tributacao_pck.obter_data_pgto_tributo(	tb_cd_cond_pgto_w(nr_cont_w), r_c01_w.ie_vencimento,
											r_c01_w.ie_venc_pls_pag_prod, current_setting('pls_pp_lote_retencao_pck.dt_mes_competencia_lote_w')::pls_pp_lr_lote.dt_mes_competencia%type,
											r_c01_w.dt_venc_titulo, cd_estabelecimento_p,
											null, r_c01_w.cd_tributo);

	-- a base de cálculo é a base de pagamento, na rotina que faz o cálculo irá retornar o valor que foi utilizado 
	-- para chegar ao valor do tributo no cálculo, esse será o vl_base_calculo
	tb_vl_base_calc_w(nr_cont_w) := r_c01_w.vl_base_pgto;
	
	-- como será recálculado tudo de INSS para o período passamos como tributo pago 0
	vl_tributo_pago_w := 0;
	
	vl_trib_nao_retido_w := r_c01_w.vl_nao_retido;
	vl_base_nao_retido_w := r_c01_w.vl_base_nao_retido;
	vl_base_adic_w := r_c01_w.vl_base_adic;
	vl_trib_adic_w := r_c01_w.vl_trib_adic;
	
	-- faz o cálculo do INSS, aqui é verificado se chegou no teto se faltou recolher algum INSS 
	-- todos os tratamentos para INSS PF devem ser feitos dentro desta rotina
	SELECT * FROM pls_pp_lote_retencao_pck.calcula_vl_trib_inss(	ie_acumulativo_w, r_c01_w.cd_tributo, vl_teto_base_calc_w, vl_minimo_base_w, vl_minimo_tributo_w, vl_tributo_pago_w, r_c01_w.vl_base_acumulada, current_setting('pls_pp_lote_retencao_pck.dt_mes_competencia_lote_w')::pls_pp_lr_lote.dt_mes_competencia%type, r_c01_w.vl_base_total, tb_pr_aliquota_w(nr_cont_w), tb_vl_base_calc_w(nr_cont_w), vl_trib_nao_retido_w, vl_trib_adic_w, vl_base_nao_retido_w, vl_base_adic_w) INTO STRICT tb_pr_aliquota_w(nr_cont_w), tb_vl_base_calc_w(nr_cont_w), vl_trib_nao_retido_w, vl_trib_adic_w, vl_base_nao_retido_w, vl_base_adic_w, vl_irrelevante_w, vl_irrelevante_w, vl_irrelevante_w, nr_seq_regra_irpf_w;
	
	-- Para IR não precisa calcular valor do tributo e nem informar a aliquota do tributo
	if (r_c01_w.ie_tipo_tributo = 'IR') then
		tb_vl_tributo_w(nr_cont_w)	:= r_c01_w.vl_tributo_pago;
		tb_pr_aliquota_w(nr_cont_w)	:= 0;
	end if;
	
	-- se atingiu a quantidade manda pro banco, senão incrementa o contador
	if (nr_cont_w >= pls_util_pck.qt_registro_transacao_w) then
	
		SELECT * FROM pls_pp_lote_retencao_pck.atualizar_valores_trib_pessoa(	nr_cont_w, tb_nr_sequencia_w, tb_nr_seq_trib_pag_w, tb_pr_aliquota_w, tb_vl_base_calc_w, tb_vl_tributo_w, tb_dt_pgto_trib_w, tb_nr_seq_trans_reg_w, tb_nr_seq_trans_baixa_w, tb_cd_beneficiario_w, tb_ie_periodicidade_w, tb_cd_variacao_w, tb_cd_cond_pgto_w, tb_cd_darf_w, tb_nr_seq_classe_w, tb_cd_tipo_baixa_neg_w, tb_ie_vencimento_w, tb_ie_ger_tit_pagar_w, tb_cd_conta_financ_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_nr_seq_trib_pag_w := _ora2pg_r.tb_nr_seq_trib_pag_p; tb_pr_aliquota_w := _ora2pg_r.tb_pr_aliquota_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_dt_pgto_trib_w := _ora2pg_r.tb_dt_pgto_trib_p; tb_nr_seq_trans_reg_w := _ora2pg_r.tb_nr_seq_trans_reg_p; tb_nr_seq_trans_baixa_w := _ora2pg_r.tb_nr_seq_trans_baixa_p; tb_cd_beneficiario_w := _ora2pg_r.tb_cd_beneficiario_p; tb_ie_periodicidade_w := _ora2pg_r.tb_ie_periodicidade_p; tb_cd_variacao_w := _ora2pg_r.tb_cd_variacao_p; tb_cd_cond_pgto_w := _ora2pg_r.tb_cd_cond_pgto_p; tb_cd_darf_w := _ora2pg_r.tb_cd_darf_p; tb_nr_seq_classe_w := _ora2pg_r.tb_nr_seq_classe_p; tb_cd_tipo_baixa_neg_w := _ora2pg_r.tb_cd_tipo_baixa_neg_p; tb_ie_vencimento_w := _ora2pg_r.tb_ie_vencimento_p; tb_ie_ger_tit_pagar_w := _ora2pg_r.tb_ie_ger_tit_pagar_p; tb_cd_conta_financ_w := _ora2pg_r.tb_cd_conta_financ_p;
	else
		nr_cont_w := nr_cont_w + 1;
	end if;
end loop;

-- se sobrou algo manda pro banco
SELECT * FROM pls_pp_lote_retencao_pck.atualizar_valores_trib_pessoa(	nr_cont_w, tb_nr_sequencia_w, tb_nr_seq_trib_pag_w, tb_pr_aliquota_w, tb_vl_base_calc_w, tb_vl_tributo_w, tb_dt_pgto_trib_w, tb_nr_seq_trans_reg_w, tb_nr_seq_trans_baixa_w, tb_cd_beneficiario_w, tb_ie_periodicidade_w, tb_cd_variacao_w, tb_cd_cond_pgto_w, tb_cd_darf_w, tb_nr_seq_classe_w, tb_cd_tipo_baixa_neg_w, tb_ie_vencimento_w, tb_ie_ger_tit_pagar_w, tb_cd_conta_financ_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_nr_seq_trib_pag_w := _ora2pg_r.tb_nr_seq_trib_pag_p; tb_pr_aliquota_w := _ora2pg_r.tb_pr_aliquota_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_dt_pgto_trib_w := _ora2pg_r.tb_dt_pgto_trib_p; tb_nr_seq_trans_reg_w := _ora2pg_r.tb_nr_seq_trans_reg_p; tb_nr_seq_trans_baixa_w := _ora2pg_r.tb_nr_seq_trans_baixa_p; tb_cd_beneficiario_w := _ora2pg_r.tb_cd_beneficiario_p; tb_ie_periodicidade_w := _ora2pg_r.tb_ie_periodicidade_p; tb_cd_variacao_w := _ora2pg_r.tb_cd_variacao_p; tb_cd_cond_pgto_w := _ora2pg_r.tb_cd_cond_pgto_p; tb_cd_darf_w := _ora2pg_r.tb_cd_darf_p; tb_nr_seq_classe_w := _ora2pg_r.tb_nr_seq_classe_p; tb_cd_tipo_baixa_neg_w := _ora2pg_r.tb_cd_tipo_baixa_neg_p; tb_ie_vencimento_w := _ora2pg_r.tb_ie_vencimento_p; tb_ie_ger_tit_pagar_w := _ora2pg_r.tb_ie_ger_tit_pagar_p; tb_cd_conta_financ_w := _ora2pg_r.tb_cd_conta_financ_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_retencao_pck.calcula_trib_pf_lote ( nr_seq_lote_p pls_pp_lr_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;