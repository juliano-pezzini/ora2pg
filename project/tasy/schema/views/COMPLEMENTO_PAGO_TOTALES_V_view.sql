-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW complemento_pago_totales_v (sequencia, ret_iva, ret_issr, ret_ieps, traslados_base_iva16, traslados_imp_iva16, traslados_base_iva8, traslados_imp_iva8, traslados_base_iva0, traslados_imp0, monto_total_pagos) AS select	
	b.nr_sequencia sequencia,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_tributo), d.vl_recebido, a.vl_total_nota), 2))
	FROM	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and 	upper(obter_tipo_tributo(b.cd_tributo)) = 'IVAR'
	having  coalesce(sum(b.vl_tributo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) ret_iva,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_tributo), d.vl_recebido, a.vl_total_nota), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and 	upper(obter_tipo_tributo(b.cd_tributo)) = 'ISRR'
	having  coalesce(sum(b.vl_tributo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) ret_issr,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_tributo), d.vl_recebido, a.vl_total_nota), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and 	upper(obter_tipo_tributo(b.cd_tributo)) = 'IEPS'
	having  coalesce(sum(b.vl_tributo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) ret_ieps,
	
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_base_calculo), d.vl_recebido, a.vl_total_nota), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and     upper(obter_tipo_tributo(b.cd_tributo)) = 'IVA'
	and	b.tx_tributo = 16
	having  coalesce(sum(b.vl_base_calculo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) traslados_base_iva16,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_base_calculo), d.vl_recebido, a.vl_total_nota) * dividir_sem_round((b.tx_tributo)::numeric,100), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and     upper(obter_tipo_tributo(b.cd_tributo)) = 'IVA'
	and	b.tx_tributo = 16
	having  coalesce(sum(b.vl_tributo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) traslados_imp_iva16,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_base_calculo), d.vl_recebido, a.vl_total_nota), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and     upper(obter_tipo_tributo(b.cd_tributo)) = 'IVA'
	and	b.tx_tributo = 8
	having  coalesce(sum(b.vl_base_calculo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) traslados_base_iva8,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_base_calculo), d.vl_recebido, a.vl_total_nota) * dividir_sem_round((b.tx_tributo)::numeric,100), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and     upper(obter_tipo_tributo(b.cd_tributo)) = 'IVA'
	and	b.tx_tributo = 8
	having  coalesce(sum(b.vl_tributo),0) > 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) traslados_imp_iva8,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_base_calculo), d.vl_recebido, a.vl_total_nota), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and     upper(obter_tipo_tributo(b.cd_tributo)) = 'IVA'
	and	b.tx_tributo = 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) traslados_base_iva0,
	
	(select  subst_virgula_ponto_adic_zero(campo_mascara_casas(fis_get_base_imp_compl_pago(a.nr_sequencia, b.tx_tributo, sum(b.vl_base_calculo), d.vl_recebido, a.vl_total_nota) * dividir_sem_round((b.tx_tributo)::numeric,100), 2))
	from	nota_fiscal_item_trib b
	where	b.nr_sequencia = a.nr_sequencia
	and     upper(obter_tipo_tributo(b.cd_tributo)) = 'IVA'
	and	b.tx_tributo = 0
	group by b.tx_tributo, d.vl_recebido, a.vl_total_nota, a.nr_sequencia) traslados_imp0,

	(select subst_virgula_ponto_adic_zero(sum(monto_cfdi_4))
	from 	complemento_pago_v
	where 	sequencia = b.nr_sequencia) monto_total_pagos
	
from 	nota_fiscal  a,
     	nota_fiscal  b,
	nota_fiscal_item i,
	titulo_receber c,
	titulo_receber_liq d
where 	b.nr_sequencia = i.nr_sequencia
and     a.nr_sequencia = c.nr_seq_nf_saida
and     i.nr_titulo = c.nr_titulo
and     c.nr_titulo = d.nr_titulo
and     d.nr_sequencia = i.nr_seq_tit_rec;
