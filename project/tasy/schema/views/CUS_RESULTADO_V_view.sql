-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cus_resultado_v (cd_estabelecimento, cd_centro_controle, ie_tipo_centro_controle, ie_centro_resultado, cd_tabela_custo, ie_classif_conta, ds_classificacao, ie_emite, ie_emite_perc, ie_receita_liquida, nr_seq_unid_neg, dt_mes_referencia, vl_mes, pr_rec_liquida, ie_orcado_real) AS select		a.cd_estabelecimento,
		a.cd_centro_controle,
		c.ie_tipo_centro_controle,
		c.ie_centro_resultado,
		a.cd_tabela_custo,
		a.ie_classif_conta,
		ds_classificacao,
		b.ie_emite,
		b.ie_emite_perc,
		b.ie_receita_liquida,
		c.nr_seq_unid_neg,
		d.dt_mes_referencia,
		coalesce(sum(a.vl_mes),0) vl_mes,
		dividir(sum(a.pr_rec_liquida * a.vl_mes), sum(a.vl_mes)) pr_rec_liquida,
		d.ie_orcado_real
FROM		centro_controle c,
		classif_result b,
		resultado_centro_controle a,
		tabela_custo d
where		a.cd_tabela_custo = d.cd_tabela_custo
and		a.cd_centro_controle = c.cd_centro_controle
and		a.ie_classif_conta = b.cd_classificacao
group by	a.cd_estabelecimento,
		a.cd_centro_controle,
		c.ie_tipo_centro_controle,
		c.ie_centro_resultado,
		a.cd_tabela_custo,
		a.ie_classif_conta,
	       	ds_classificacao,
		b.ie_emite,
		b.ie_emite_perc,
		b.ie_receita_liquida,
		c.nr_seq_unid_neg,
		d.dt_mes_referencia,
		d.ie_orcado_real
order by	d.dt_mes_referencia,
		a.ie_classif_conta;
