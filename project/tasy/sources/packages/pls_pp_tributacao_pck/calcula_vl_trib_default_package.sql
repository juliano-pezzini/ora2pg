-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_tributacao_pck.calcula_vl_trib_default ( ie_acumulativo_p tributo_conta_pagar.ie_acumulativo%type, cd_tributo_p tributo.cd_tributo%type, vl_minimo_base_p tributo_conta_pagar.vl_minimo%type, vl_minimo_tributo_p tributo_conta_pagar.vl_minimo_tributo%type, pr_aliquota_p tributo_conta_pagar.pr_aliquota%type, vl_teto_base_calc_p tributo_conta_pagar.vl_teto_base_calculo%type, dt_competencia_p timestamp, vl_base_total_p pls_pp_valor_trib_pessoa.vl_base_total%type, vl_base_calculo_p INOUT pls_pp_valor_trib_pessoa.vl_base_calculo%type, vl_trib_nao_retido_p INOUT pls_pp_valor_trib_pessoa.vl_nao_retido%type, vl_trib_adic_p INOUT pls_pp_valor_trib_pessoa.vl_trib_adic%type, vl_base_nao_retido_p INOUT pls_pp_valor_trib_pessoa.vl_base_nao_retido%type, vl_base_adic_p INOUT pls_pp_valor_trib_pessoa.vl_base_adic%type, vl_base_total_out_p out pls_pp_valor_trib_pessoa.vl_base_total%type, vl_base_acum_out_p out pls_pp_valor_trib_pessoa.vl_base_acumulada%type, vl_reducao_p out regra_calculo_irpf.vl_reducao%type, nr_seq_regra_irpf_p out regra_calculo_irpf.nr_sequencia%type) AS $body$
DECLARE


/* 	esta rotina ira calcular todos os tributos que tenham calculo simples, ou seja, que seja o valor base de calculo 
	X um percentual, qualquer imposto que necessite de algum tratamento diferente do que estiver nesta rotina devera ser
	criada uma function nova com os tratamentos necessarios e fazer a chamada da mesma no mesmo case que chama esta */


vl_tributo_w		pls_pp_valor_trib_pessoa.vl_tributo%type;
vl_base_calculo_w	pls_pp_valor_trib_pessoa.vl_base_calculo%type;
pr_aliquota_w		tributo_conta_pagar.pr_aliquota%type;
nr_seq_regra_irpf_w	regra_calculo_irpf.nr_sequencia%type;
vl_trib_nao_retido_w	pls_pp_valor_trib_pessoa.vl_nao_retido%type;
vl_trib_adic_w		pls_pp_valor_trib_pessoa.vl_trib_adic%type;
vl_base_nao_retido_w	pls_pp_valor_trib_pessoa.vl_base_nao_retido%type;
vl_base_adic_w		pls_pp_valor_trib_pessoa.vl_base_adic%type;
vl_irrelevante_w	double precision;
	

BEGIN

-- criadas as variaveis e as mesmas recebem o valor do parametro, os valores que serao retornados nestas serao desconsiderados

vl_base_calculo_w := vl_base_calculo_p;
pr_aliquota_w := pr_aliquota_p;
vl_irrelevante_w := 0;

obter_valores_tributo(	ie_acumulativo_p, -- vem do cadastro do tributo indicando se o mesmo e acumulativo
			pr_aliquota_w, -- in out entra e sai a mesma aliquota nestes casos
			vl_minimo_base_p,
			vl_minimo_tributo_p,
			vl_trib_nao_retido_p, -- vl_soma_trib_nao_retido_p nao faz diferenca nestes calculos
			vl_trib_adic_p, -- vl_soma_trib_adic_p nao faz diferenca nestes calculos
			vl_base_nao_retido_p, -- vl_soma_base_nao_retido_p nao faz diferenca nestes calculos
			vl_base_adic_p, -- vl_soma_base_adic_p nao faz diferenca nestes calculos
			vl_base_calculo_w, -- in out entra o valor de base atual e sai o valor que foi utilizado para chegar no valor do tributo
			vl_tributo_w, -- valor do tributo calculado
			vl_trib_nao_retido_w, -- vl_trib_nao_retido_p salvamos estes dados apenas por causa da view dos tributos
			vl_trib_adic_w, -- vl_trib_adic_p salvamos estes dados apenas por causa da view dos tributos
			vl_base_nao_retido_w, -- vl_base_nao_retido_p salvamos estes dados apenas por causa da view dos tributos
			vl_base_adic_w, -- vl_base_adic_p salvamos estes dados apenas por causa da view dos tributos
			vl_teto_base_calc_p, -- vl teto do tributo
			vl_irrelevante_w, -- tributo pago nao faz diferenca nestes calculos
			'N', -- ie_irpf_p, como nao sera calculado IRPF entao e passado fixo
			vl_irrelevante_w, -- vl_base_anterior_p nao faz diferenca nestes calculos
			vl_irrelevante_w, -- nao faz diferenca nestes calculos
			vl_irrelevante_w, -- vl_desc_dependente_p nao faz diferenca nestes calculos
			vl_irrelevante_w, -- nao faz diferenca nestes calculos
			vl_irrelevante_w, -- vl_base_pago_p nao faz diferenca nestes calculos
			vl_irrelevante_w, -- vl_base_pago_adic_base_p nao faz diferenca nestes calculos
			vl_irrelevante_w, -- vl_base_retido_outro_p nao faz diferenca nestes calculos
			vl_irrelevante_w, -- vl_outras_red_irpf_p nao faz diferenca nestes calculos
			dt_competencia_p,
			nr_seq_regra_irpf_w, -- out sequencia da regra de IRPF
			cd_tributo_p);

-- alimenta os parametros out com as variaveis

vl_trib_nao_retido_p := vl_trib_nao_retido_w;
vl_trib_adic_p := vl_trib_adic_w;
vl_base_nao_retido_p := vl_base_nao_retido_w;
vl_base_adic_p := vl_base_adic_w;
vl_base_calculo_p := vl_base_calculo_w;

-- campos criados pois existem diferenca no valores salvo nestes dependendo do tipo de tributo

vl_base_acum_out_p := coalesce(vl_base_adic_w, 0);
vl_base_total_out_p := vl_base_total_p;

-- campos utilizados apenas para calculo de IRPF

vl_reducao_p := 0;
nr_seq_regra_irpf_p := null;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_tributacao_pck.calcula_vl_trib_default ( ie_acumulativo_p tributo_conta_pagar.ie_acumulativo%type, cd_tributo_p tributo.cd_tributo%type, vl_minimo_base_p tributo_conta_pagar.vl_minimo%type, vl_minimo_tributo_p tributo_conta_pagar.vl_minimo_tributo%type, pr_aliquota_p tributo_conta_pagar.pr_aliquota%type, vl_teto_base_calc_p tributo_conta_pagar.vl_teto_base_calculo%type, dt_competencia_p timestamp, vl_base_total_p pls_pp_valor_trib_pessoa.vl_base_total%type, vl_base_calculo_p INOUT pls_pp_valor_trib_pessoa.vl_base_calculo%type, vl_trib_nao_retido_p INOUT pls_pp_valor_trib_pessoa.vl_nao_retido%type, vl_trib_adic_p INOUT pls_pp_valor_trib_pessoa.vl_trib_adic%type, vl_base_nao_retido_p INOUT pls_pp_valor_trib_pessoa.vl_base_nao_retido%type, vl_base_adic_p INOUT pls_pp_valor_trib_pessoa.vl_base_adic%type, vl_base_total_out_p out pls_pp_valor_trib_pessoa.vl_base_total%type, vl_base_acum_out_p out pls_pp_valor_trib_pessoa.vl_base_acumulada%type, vl_reducao_p out regra_calculo_irpf.vl_reducao%type, nr_seq_regra_irpf_p out regra_calculo_irpf.nr_sequencia%type) FROM PUBLIC;
