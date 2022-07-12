-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW valores_tributo_pag_v (vl_soma_trib_nao_retido, vl_soma_base_nao_retido, vl_soma_trib_adic, vl_soma_base_adic, cd_cgc, cd_pessoa_fisica, dt_tributo, dt_tributo_mes, cd_tributo, ie_origem_valores, vl_tributo, cd_cgc_emitente, vl_total_base, cd_estabelecimento, ie_base_calculo, vl_reducao, dt_criacao, nr_titulo, nr_repasse_terceiro, nr_seq_nota_fiscal, ie_baixa_titulo, cd_cnpj_raiz, cd_cnpj_emitente_raiz, cd_estab_financeiro, cd_darf, nr_seq_distribuicao, nr_seq_lote_protocolo, cd_empresa, nr_seq_pag_prest, nr_seq_trib_valor) AS select	coalesce(sum(a.vl_nao_retido),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.vl_base_nao_retido),0) vl_soma_base_nao_retido,
	coalesce(sum(a.vl_trib_adic),0) vl_soma_trib_adic,
	coalesce(sum(a.vl_base_adic),0) vl_soma_base_adic,
	d.cd_cgc,
	d.cd_pessoa_fisica,
	CASE WHEN e.ie_venc_pls_pag_prod='C' THEN  p.dt_mes_competencia WHEN e.ie_venc_pls_pag_prod='V' THEN  b.dt_vencimento  ELSE CASE WHEN e.ie_vencimento='V' THEN  b.dt_vencimento WHEN e.ie_vencimento='C' THEN  coalesce(b.dt_vencimento, p.dt_mes_competencia)  ELSE p.dt_mes_competencia END  END  dt_tributo,
	trunc(CASE WHEN e.ie_venc_pls_pag_prod='C' THEN  p.dt_mes_competencia WHEN e.ie_venc_pls_pag_prod='V' THEN  b.dt_vencimento  ELSE CASE WHEN e.ie_vencimento='V' THEN  b.dt_vencimento WHEN e.ie_vencimento='C' THEN  coalesce(b.dt_vencimento, p.dt_mes_competencia)  ELSE p.dt_mes_competencia END  END ,'month') dt_tributo_mes,
	a.cd_tributo,
	'PP' ie_origem_valores,
	coalesce(sum(a.vl_imposto),0) vl_tributo,
	'' cd_cgc_emitente,
	sum(a.vl_base_calculo) vl_total_base,
	p.cd_estabelecimento,
	substr(obter_se_base_calculo(c.nr_sequencia, 'PP'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	(null)::numeric  nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	substr(obter_cnpj_raiz(d.cd_cgc),1,20) cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	(obter_estab_financeiro(p.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	null nr_seq_lote_protocolo,
	obter_empresa_estab(p.cd_estabelecimento) cd_empresa,
	c.nr_sequencia nr_seq_pag_prest,
	null nr_seq_trib_valor
FROM	tributo e,
	pls_prestador d,
	pls_lote_pagamento p,
	pls_pagamento_prestador c,
	pls_pag_prest_vencimento b,
	pls_pag_prest_venc_trib a
where	a.nr_seq_vencimento = b.nr_sequencia
and	b.nr_seq_pag_prestador = c.nr_sequencia
and	c.nr_seq_prestador = d.nr_sequencia
and	c.nr_seq_lote = p.nr_sequencia
and	a.ie_pago_prev = 'V'
and	e.cd_tributo = a.cd_tributo
and	coalesce(c.ie_cancelamento,'X') = 'X'
group by
	d.cd_cgc,
	d.cd_pessoa_fisica,
	CASE WHEN e.ie_venc_pls_pag_prod='C' THEN  p.dt_mes_competencia WHEN e.ie_venc_pls_pag_prod='V' THEN  b.dt_vencimento  ELSE CASE WHEN e.ie_vencimento='V' THEN  b.dt_vencimento WHEN e.ie_vencimento='C' THEN  coalesce(b.dt_vencimento, p.dt_mes_competencia)  ELSE p.dt_mes_competencia END  END ,
	a.cd_tributo,
	p.cd_estabelecimento,
	substr(obter_se_base_calculo(c.nr_sequencia, 'PP'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	c.nr_sequencia,
	substr(obter_cnpj_raiz(d.cd_cgc),1,20),
	(obter_estab_financeiro(p.cd_estabelecimento))::numeric ,
	a.cd_darf,
	obter_empresa_estab(p.cd_estabelecimento)

union all

select	coalesce(sum(a.vl_nao_retido),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.vl_base_nao_retido),0) vl_soma_base_nao_retido,
	coalesce(sum(a.vl_trib_adic),0) vl_soma_trib_adic,
	coalesce(sum(a.vl_base_adic),0) vl_soma_base_adic,
	'' cd_cgc,
	b.cd_pessoa_fisica,
	CASE WHEN e.ie_vencimento='V' THEN  a.dt_imposto WHEN e.ie_vencimento='C' THEN  coalesce(a.dt_imposto, c.dt_mes_referencia)  ELSE c.dt_mes_referencia END  dt_tributo,
	trunc(CASE WHEN e.ie_vencimento='V' THEN  a.dt_imposto WHEN e.ie_vencimento='C' THEN  coalesce(a.dt_imposto, c.dt_mes_referencia)  ELSE c.dt_mes_referencia END ,'month') dt_tributo_mes,
	a.cd_tributo,
	'PP' ie_origem_valores,
	coalesce(sum(a.vl_imposto),0) vl_tributo,
	'' cd_cgc_emitente,
	sum(a.vl_base_calculo) vl_total_base,
	c.cd_estabelecimento,
	substr(obter_se_base_calculo(c.nr_sequencia, 'PP'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	(null)::numeric  nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	null cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	(obter_estab_financeiro(c.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	null nr_seq_lote_protocolo,
	obter_empresa_estab(c.cd_estabelecimento) cd_empresa,
	null nr_seq_pag_prest,
	a.nr_sequencia nr_seq_trib_valor
from	pls_lote_ret_trib_valor a,
	pls_lote_ret_trib_prest b,
	pls_lote_retencao_trib c,
	tributo e
where	a.nr_seq_trib_prest = b.nr_sequencia
and	b.nr_seq_lote = c.nr_sequencia
and	b.cd_pessoa_fisica is not null
and	a.ie_pago_prev in ('R','V')
and	e.cd_tributo = a.cd_tributo
group by
	b.cd_pessoa_fisica,
	CASE WHEN e.ie_vencimento='V' THEN  a.dt_imposto WHEN e.ie_vencimento='C' THEN  coalesce(a.dt_imposto, c.dt_mes_referencia)  ELSE c.dt_mes_referencia END ,
	a.cd_tributo,
	c.cd_estabelecimento,
	c.nr_sequencia,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	a.cd_darf,
	a.nr_sequencia;

