-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW far_ims_compras_v (tp_registro, fixo_1, cd_ims, cd_cgc, dt_inicial, dt_final, dt_arquivo, fixo_2, ds_branco, cd_interno_ims, ds_razao_social, cd_loja, cd_flag_loja, dt_transacao, ds_flag, nr_nota, cd_produto, cd_flag_produto, qt_produto, vl_preco, vl_aliquota, vl_icms, pr_desconto, vl_desconto, qt_registro, qt_unidade, vl_total_icms, vl_total_desconto) AS select	'1' tp_registro,
	'C' fixo_1,
	'????'cd_ims,
	substr(obter_cgc_estabelecimento(1),1,120) cd_cgc,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_inicial,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_final,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_arquivo,
	'1' fixo_2,
	'                 'ds_branco,
	'imsbrcmp1' cd_interno_ims,
	substr(obter_razao_social(obter_cgc_estabelecimento(1)),1,120) ds_razao_social,
	'' cd_loja,
	'2' cd_flag_loja,
	'' dt_transacao,
	'' ds_flag,
	'' nr_nota,
	'' cd_produto,
	'' cd_flag_produto,
	'' qt_produto,
	'' vl_preco,
	'' vl_aliquota,
	'' vl_icms,
	'' pr_desconto,
	'' vl_desconto,
	'' qt_registro,
	'' qt_unidade,
	'' vl_total_icms,
	'' vl_total_desconto


union all

select	'2' tp_registro,
	'00' fixo_1,
	'' cd_ims,
	f.cd_cgc_emitente cd_cgc,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_inicial,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_final,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_arquivo,
	'0' fixo_2,
	'' ds_branco,
	'C' cd_interno_ims,
	'' ds_razao_social,
	'???' cd_loja,
	'1' cd_flag_loja,
	to_char(dt_processo,'ddmmyyyy') dt_transacao,
	substr(far_obter_tributo_nota_item(f.nr_nota_fiscal,a.cd_material),1,120) ds_flag,
	lpad(f.nr_nota_fiscal,9,0) nr_nota,
	to_char(lpad(a.cd_material,13,0)) cd_produto,
	'1' cd_flag_produto,
	to_char(lpad(a.qt_movimento,8,0)) qt_produto,
	lpad(somente_numero_char(Campo_Mascara_virgula(c.vl_movimento)),10,0) vl_preco,
	lpad(somente_numero_char(Campo_Mascara_virgula(coalesce((	select	max(y.tx_tributo)
							from	nota_fiscal_item x,
								nota_fiscal_item_trib y
							where	x.nr_sequencia = f.nr_sequencia
							and	x.nr_sequencia = y.nr_sequencia
							and	x.nr_item_nf = y.nr_item_nf
							and	x.cd_material = a.cd_material),0))),4,0) vl_aliquota,
	lpad(somente_numero_char(Campo_Mascara_virgula(coalesce((	select	max(y.vl_tributo)
							from	nota_fiscal_item x,
								nota_fiscal_item_trib y
							where	x.nr_sequencia = f.nr_sequencia
							and	x.nr_sequencia = y.nr_sequencia
							and	x.nr_item_nf = y.nr_item_nf
							and	x.cd_material = a.cd_material),0))),10,0) vl_icms,
	lpad(somente_numero_char(Campo_Mascara_virgula(coalesce((	select	max(x.pr_desconto)
							from	nota_fiscal_item x
							where	x.nr_sequencia = f.nr_sequencia
							and	x.cd_material = a.cd_material),0))),4,0) pr_desconto,
	lpad(somente_numero_char(Campo_Mascara_virgula(coalesce((	select	max(x.vl_desconto)
							from	nota_fiscal_item x
							where	x.nr_sequencia = f.nr_sequencia
							and	x.cd_material = a.cd_material),0))),10,0) vl_desconto,
	'' qt_registro,
	'' qt_unidade,
	'' vl_total_icms,
	'' vl_total_desconto
from	movimento_estoque a,
	movimento_estoque_valor c,
	operacao_estoque b,
	nota_fiscal f
where	a.cd_operacao_estoque = b.cd_operacao_estoque
and	a.nr_movimento_estoque = c.nr_movimento_estoque
and	b.ie_tipo_requisicao = 6 /* Domínio 21 (Nota fiscal compra) */
and	a.ie_origem_documento = 1 /* Documento = Nota Fiscal */
and	b.ie_tipo_perda is null
and	a.cd_fornecedor is not null
and	dt_movimento_estoque between to_date('07/07/2011 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('07/12/2011 23:59:59','dd/mm/yyyy hh24:mi:ss')
and	f.nr_sequencia = a.nr_seq_tab_orig

union all

select	'3' tp_registro,
	'0' fixo_1,
	'????' cd_ims,
	'' cd_cgc,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_inicial,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_final,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') dt_arquivo,
	'' fixo_2,
	'                                            ' ds_branco,
	'imsbrcmp3' cd_interno_ims,
	'' ds_razao_social,
	'' cd_loja,
	'' cd_flag_loja,
	'' dt_transacao,
	'' ds_flag,
	'' nr_nota,
	'' cd_produto,
	'' cd_flag_produto,
	'' qt_produto,
	'' vl_preco,
	'' vl_aliquota,
	'' vl_icms,
	'' pr_desconto,
	'' vl_desconto,
	'00000000' qt_registro,
	to_char(lpad(sum(a.qt_movimento),10,0)) qt_unidade,
	lpad(somente_numero_char(Campo_Mascara_virgula(coalesce(sum((	select	sum(y.vl_tributo)
								from	nota_fiscal_item x,
									nota_fiscal_item_trib y
								where	x.nr_sequencia = f.nr_sequencia
								and	x.nr_sequencia = y.nr_sequencia
								and	x.nr_item_nf = y.nr_item_nf
								and	x.cd_material = a.cd_material)),0))),12,0) vl_total_icms,
	lpad(somente_numero_char(Campo_Mascara_virgula(coalesce(sum((	select	sum(x.vl_desconto)
								from	nota_fiscal_item x
								where	x.nr_sequencia = f.nr_sequencia
								and	x.cd_material = a.cd_material)),0))),12,0) vl_total_desconto
from	movimento_estoque a,
	movimento_estoque_valor c,
	operacao_estoque b,
	nota_fiscal f
where	a.cd_operacao_estoque = b.cd_operacao_estoque
and	a.nr_movimento_estoque = c.nr_movimento_estoque
and	b.ie_tipo_requisicao = 6 /* Domínio 21 (Nota fiscal compra) */
and	a.ie_origem_documento = 1 /* Documento = Nota Fiscal */
and	b.ie_tipo_perda is null
and	a.cd_fornecedor is not null
and	dt_movimento_estoque between to_date('07/07/2011 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('07/12/2011 23:59:59','dd/mm/yyyy hh24:mi:ss')
and	f.nr_sequencia = a.nr_seq_tab_orig;

