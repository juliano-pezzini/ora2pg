-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ecd_demo_rubrica_v (nr_seq_demo, nr_seq_apres, ds_observacao, ds_rubrica, qt_desl_esq, ie_informacao, vl_1_coluna, vl_2_coluna, vl_3_coluna, vl_4_coluna, vl_5_coluna, vl_6_coluna, vl_7_coluna, vl_8_coluna, vl_9_coluna, vl_10_coluna, vl_11_coluna, vl_12_coluna, vl_13_coluna, vl_14_coluna, vl_15_coluna, vl_16_coluna, vl_17_coluna, vl_18_coluna, vl_19_coluna, vl_20_coluna, vl_21_coluna, vl_22_coluna, vl_23_coluna, vl_24_coluna, vl_25_coluna, vl_26_coluna, vl_27_coluna, vl_28_coluna, vl_29_coluna, vl_30_coluna, vl_31_coluna, vl_32_coluna, vl_33_coluna, vl_34_coluna, vl_35_coluna, vl_36_coluna, vl_37_coluna, vl_38_coluna, vl_39_coluna, vl_40_coluna, ds_origem, ie_negrito, ie_italico, ie_sublinhado, ds_cor_fonte, ds_cor_fundo, ie_origem_valor, nr_seq_rubrica) AS select	a.nr_seq_demo,
	b.nr_seq_apres,
	b.ds_observacao,
	substr(lpad(' ', qt_desl_esq) || ds_rubrica,1,100) ds_rubrica,
	qt_desl_esq,
	b.ie_informacao,
	sum(CASE WHEN c.nr_seq_coluna=1 THEN  a.vl_referencia END ) vl_1_coluna,
	sum(CASE WHEN c.nr_seq_coluna=2 THEN  a.vl_referencia END ) vl_2_coluna,
	sum(CASE WHEN c.nr_seq_coluna=3 THEN  a.vl_referencia END ) vl_3_coluna,
	sum(CASE WHEN c.nr_seq_coluna=4 THEN  a.vl_referencia END ) vl_4_coluna,
	sum(CASE WHEN c.nr_seq_coluna=5 THEN  a.vl_referencia END ) vl_5_coluna,
	sum(CASE WHEN c.nr_seq_coluna=6 THEN  a.vl_referencia END ) vl_6_coluna,
	sum(CASE WHEN c.nr_seq_coluna=7 THEN  a.vl_referencia END ) vl_7_coluna,
	sum(CASE WHEN c.nr_seq_coluna=8 THEN  a.vl_referencia END ) vl_8_coluna,
	sum(CASE WHEN c.nr_seq_coluna=9 THEN  a.vl_referencia END ) vl_9_coluna,
	sum(CASE WHEN c.nr_seq_coluna=10 THEN  a.vl_referencia END ) vl_10_coluna,
	sum(CASE WHEN c.nr_seq_coluna=11 THEN  a.vl_referencia END ) vl_11_coluna,
	sum(CASE WHEN c.nr_seq_coluna=12 THEN  a.vl_referencia END ) vl_12_coluna,
	sum(CASE WHEN c.nr_seq_coluna=13 THEN  a.vl_referencia END ) vl_13_coluna,
	sum(CASE WHEN c.nr_seq_coluna=14 THEN  a.vl_referencia END ) vl_14_coluna,
	sum(CASE WHEN c.nr_seq_coluna=15 THEN  a.vl_referencia END ) vl_15_coluna,
	sum(CASE WHEN c.nr_seq_coluna=16 THEN  a.vl_referencia END ) vl_16_coluna,
	sum(CASE WHEN c.nr_seq_coluna=17 THEN  a.vl_referencia END ) vl_17_coluna,
	sum(CASE WHEN c.nr_seq_coluna=18 THEN  a.vl_referencia END ) vl_18_coluna,
	sum(CASE WHEN c.nr_seq_coluna=19 THEN  a.vl_referencia END ) vl_19_coluna,
	sum(CASE WHEN c.nr_seq_coluna=20 THEN  a.vl_referencia END ) vl_20_coluna,
	sum(CASE WHEN c.nr_seq_coluna=21 THEN  a.vl_referencia END ) vl_21_coluna,
	sum(CASE WHEN c.nr_seq_coluna=22 THEN  a.vl_referencia END ) vl_22_coluna,
	sum(CASE WHEN c.nr_seq_coluna=23 THEN  a.vl_referencia END ) vl_23_coluna,
	sum(CASE WHEN c.nr_seq_coluna=24 THEN  a.vl_referencia END ) vl_24_coluna,
	sum(CASE WHEN c.nr_seq_coluna=25 THEN  a.vl_referencia END ) vl_25_coluna,
	sum(CASE WHEN c.nr_seq_coluna=26 THEN  a.vl_referencia END ) vl_26_coluna,
	sum(CASE WHEN c.nr_seq_coluna=27 THEN  a.vl_referencia END ) vl_27_coluna,
	sum(CASE WHEN c.nr_seq_coluna=28 THEN  a.vl_referencia END ) vl_28_coluna,
	sum(CASE WHEN c.nr_seq_coluna=29 THEN  a.vl_referencia END ) vl_29_coluna,
	sum(CASE WHEN c.nr_seq_coluna=30 THEN  a.vl_referencia END ) vl_30_coluna,
	sum(CASE WHEN c.nr_seq_coluna=31 THEN  a.vl_referencia END ) vl_31_coluna,
	sum(CASE WHEN c.nr_seq_coluna=32 THEN  a.vl_referencia END ) vl_32_coluna,
	sum(CASE WHEN c.nr_seq_coluna=33 THEN  a.vl_referencia END ) vl_33_coluna,
	sum(CASE WHEN c.nr_seq_coluna=34 THEN  a.vl_referencia END ) vl_34_coluna,
	sum(CASE WHEN c.nr_seq_coluna=35 THEN  a.vl_referencia END ) vl_35_coluna,
	sum(CASE WHEN c.nr_seq_coluna=36 THEN  a.vl_referencia END ) vl_36_coluna,
	sum(CASE WHEN c.nr_seq_coluna=37 THEN  a.vl_referencia END ) vl_37_coluna,
	sum(CASE WHEN c.nr_seq_coluna=38 THEN  a.vl_referencia END ) vl_38_coluna,
	sum(CASE WHEN c.nr_seq_coluna=39 THEN  a.vl_referencia END ) vl_39_coluna,
	sum(CASE WHEN c.nr_seq_coluna=40 THEN  a.vl_referencia END ) vl_40_coluna,
	b.ds_origem,
	b.ie_negrito,
	b.ie_italico,
	b.ie_sublinhado,
	b.ds_cor_fonte,
	b.ds_cor_fundo,
	b.ie_origem_valor,
	b.nr_sequencia nr_seq_rubrica
FROM 	ctb_demo_mes c,
	ctb_modelo_rubrica b,
	ctb_demo_rubrica a
where	a.nr_seq_rubrica	= b.nr_sequencia
and	a.nr_seq_demo	= c.nr_seq_demo
and	a.nr_seq_col	= c.nr_sequencia
group by a.nr_seq_demo,
	b.nr_sequencia,
	b.nr_seq_apres,
	b.ds_observacao,
	b.ds_origem,
	b.ie_negrito,
	qt_desl_esq,
	substr(lpad(' ', qt_desl_esq) || ds_rubrica,1,100),
	b.ie_informacao,
	b.ie_italico,
	b.ie_sublinhado,
	b.ds_cor_fonte,
	b.ds_cor_fundo,
	b.ie_origem_valor;

