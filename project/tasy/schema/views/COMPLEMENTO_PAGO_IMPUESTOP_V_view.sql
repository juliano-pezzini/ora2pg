-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW complemento_pago_impuestop_v (sequencia, base, tipo_factor, tasa_o_cuota, importe, cd_tributo) AS select	b.nr_sequencia sequencia,
	fis_get_base_imp_compl_pago(a.nr_sequencia, e.tx_tributo, sum(e.vl_base_calculo), d.vl_recebido, a.vl_total_nota) base,
	'Tasa' tipo_factor,
	subst_virgula_ponto_adic_zero(campo_mascara_casas(dividir_sem_round((e.tx_tributo)::numeric,100),6)) tasa_o_cuota,
	subst_virgula_ponto_adic_zero(campo_mascara_casas(subst_virgula_ponto_adic_zero(fis_get_base_imp_compl_pago(a.nr_sequencia, e.tx_tributo, sum(e.vl_base_calculo), d.vl_recebido, a.vl_total_nota) * dividir_sem_round((e.tx_tributo)::numeric,100)), 2)) importe,
	max(e.cd_tributo) cd_tributo
FROM	nota_fiscal  a,
     	nota_fiscal  b,
	nota_fiscal_item i,
	titulo_receber c,
	titulo_receber_liq d,
	nota_fiscal_item_trib e
where	e.nr_sequencia = a.nr_sequencia
and     b.nr_sequencia = i.nr_sequencia
and     a.nr_sequencia = c.nr_seq_nf_saida
and     i.nr_titulo = c.nr_titulo
and     c.nr_titulo = d.nr_titulo
and     d.nr_sequencia = i.nr_seq_tit_rec
group by CASE WHEN obter_tipo_tributo(e.cd_tributo)='IVA' THEN '002' WHEN obter_tipo_tributo(e.cd_tributo)='ISR' THEN '001' WHEN obter_tipo_tributo(e.cd_tributo)='IEPS' THEN '003' END ,  e.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia, b.nr_sequencia;

