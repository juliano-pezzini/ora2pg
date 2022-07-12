-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_pp_valor_trib_pessoa_v (nr_seq_lote, dt_competencia, nr_seq_trib_pessoa, cd_tributo, cd_pessoa_fisica, nr_seq_prestador, cd_cgc, nm_prestador, ie_tipo_contratacao, ds_tributo, ie_tipo_tributo, pr_aliquota, vl_base_calculo, vl_tributo, vl_reducao, vl_tributo_pago, vl_base_acumulada, vl_base_atual, vl_base_total, vl_desc_dependente, qt_dependente, nr_seq_regra_irpf, nr_seq_trib_conta_pagar, vl_nao_retido, vl_base_nao_retido, vl_trib_adic, vl_base_adic, vl_teto_base_calculo, dt_pgto_tributo, nr_titulo_pagar, vl_minimo, cd_retencao) AS select	b.nr_seq_lote,
	b.dt_competencia,
	b.nr_sequencia nr_seq_trib_pessoa,
	b.cd_tributo,
	b.cd_pessoa_fisica,
	b.nr_seq_prestador,
	b.cd_cgc,
	substr(pls_obter_dados_prestador(nr_seq_prestador, 'N'),1,255) nm_prestador,
	substr(pls_obter_ds_tipo_contratacao(b.ie_tipo_contratacao), 1, 255) ie_tipo_contratacao,
	max(c.ds_tributo) ds_tributo,
	max(c.ie_tipo_tributo) ie_tipo_tributo,
	max(b.pr_aliquota) pr_aliquota,
	max(b.vl_base_calculo) vl_base_calculo,
	max(b.vl_tributo) vl_tributo,
	max(b.vl_reducao) vl_reducao,
	max(b.vl_tributo_pago) vl_tributo_pago,
	max(b.vl_base_acumulada) vl_base_acumulada,
	max(b.vl_base_atual) vl_base_atual,
	max(b.vl_base_total) vl_base_total,
	max(b.vl_desc_dependente) vl_desc_dependente,
	max(b.qt_dependente) qt_dependente,
	max(b.nr_seq_regra_irpf) nr_seq_regra_irpf,
	max(b.nr_seq_trib_conta_pagar) nr_seq_trib_conta_pagar,
	max(b.vl_nao_retido) vl_nao_retido,
	max(b.vl_base_nao_retido) vl_base_nao_retido,
	max(b.vl_trib_adic) vl_trib_adic,
	max(b.vl_base_adic) vl_base_adic,
	coalesce(max(d.vl_teto_base_calculo), 0) vl_teto_base_calculo,
	max(b.dt_pgto_tributo) dt_pgto_tributo,
	max(b.nr_titulo_pagar) nr_titulo_pagar,
	max(d.vl_minimo) vl_minimo,
	max(d.cd_darf) cd_retencao
FROM tributo c, pls_pp_valor_trib_pessoa b
LEFT OUTER JOIN tributo_conta_pagar d ON (b.nr_seq_trib_conta_pagar = d.nr_sequencia
group	by b.nr_seq_lote,
	b.dt_competencia,
	b.nr_sequencia,
	b.cd_tributo,
	b.ie_tipo_contratacao,
	b.cd_pessoa_fisica,
	b.nr_seq_prestador,
	b.cd_cgc
order	by b.dt_competencia, ie_tipo_tributo, vl_base_calculo, nm_prestador, nr_seq_prestador)
WHERE c.cd_tributo = b.cd_tributo;
