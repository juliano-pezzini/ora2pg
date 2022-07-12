-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW acomp_tributo_v (vl_soma_trib_nao_retido, vl_soma_base_nao_retido, vl_soma_trib_adic, vl_soma_base_adic, cd_cgc, cd_pessoa_fisica, dt_tributo, cd_tributo, ie_origem_valores, vl_tributo, cd_cgc_emitente, vl_total_base, cd_estabelecimento, ie_base_calculo, vl_reducao, dt_criacao, nr_titulo, nr_repasse_terceiro, nr_seq_nota_fiscal, ie_baixa_titulo, cd_cnpj_raiz, cd_cnpj_emitente_raiz, cd_estab_financeiro, cd_darf, nr_seq_distribuicao, nr_seq_lote_protocolo, cd_empresa, nr_seq_pag_prest, nr_seq_trib_valor) AS select	coalesce(sum(a.VL_NAO_RETIDO),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.VL_BASE_NAO_RETIDO),0) vl_soma_base_nao_retido,
	coalesce(sum(a.VL_TRIB_ADIC),0) vl_soma_trib_adic,
	coalesce(sum(a.VL_BASE_ADIC),0) vl_soma_base_adic,
	b.cd_cgc,
	b.cd_pessoa_fisica,
	CASE WHEN c.ie_vencimento='V' THEN  b.dt_vencimento_atual WHEN c.ie_vencimento='C' THEN  coalesce(b.dt_contabil, b.dt_emissao)  ELSE b.dt_emissao END  dt_tributo,
	a.cd_tributo,
	'TP' ie_origem_valores,
	coalesce(sum(a.vl_imposto),0) vl_tributo,
	'' cd_cgc_emitente,
--	sum(to_number(OBTER_DADOS_TIT_PAGAR(b.nr_titulo, 'V'))) vl_total_base,  Edgar 15/03/2006 OS 31396, devido ao INSS descontado do IRPF
	coalesce(sum(a.vl_base_calculo),0) vl_total_base,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(a.nr_titulo, 'TP'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	b.nr_titulo nr_titulo,
	0 nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	coalesce(c.ie_baixa_titulo, 'N') ie_baixa_titulo,
	e.cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	b.cd_estab_financeiro,
	a.CD_DARF,
	(null)::numeric  nr_seq_distribuicao,
	(null)::numeric  nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
FROM tributo c, titulo_pagar_imposto a, titulo_pagar b
LEFT OUTER JOIN pessoa_juridica e ON (b.cd_cgc = e.cd_cgc
group 	by b.cd_cgc,
	b.cd_pessoa_fisica,
	b.dt_vencimento_atual,
	a.cd_tributo,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(a.nr_titulo, 'TP'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	b.nr_titulo,
	c.ie_baixa_titulo,
	e.cd_cnpj_raiz,
	b.cd_estab_financeiro,
	c.ie_vencimento,
	b.dt_contabil,
	b.dt_emissao,
	a.CD_DARF,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento))
WHERE a.nr_titulo		= b.nr_titulo and b.ie_situacao	in ('A','L','D') and a.ie_pago_prev	= 'V' and a.cd_tributo		= c.cd_tributo and coalesce(c.ie_baixa_titulo, 'N')	= 'N'
union

select	coalesce(sum(a.VL_NAO_RETIDO),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.VL_BASE_NAO_RETIDO),0) vl_soma_base_nao_retido,
	coalesce(sum(a.VL_TRIB_ADIC),0) vl_soma_trib_adic,
	coalesce(sum(a.VL_BASE_ADIC),0) vl_soma_base_adic,
	d.CD_CGC,
	d.CD_PESSOA_FISICA,
	CASE WHEN e.ie_vencimento='V' THEN  b.DT_VENCIMENTO WHEN e.ie_vencimento='C' THEN  coalesce(b.DT_VENCIMENTO, c.dt_mesano_referencia)  ELSE c.dt_mesano_referencia END  dt_tributo,
	a.cd_tributo,
	'RT' ie_origem_valores,
	coalesce(sum(a.vl_imposto),0) vl_tributo,
	'' cd_cgc_emitente,
	sum(a.VL_BASE_CALCULO) vl_total_base,
	c.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(c.nr_repasse_terceiro, 'RT'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	c.nr_repasse_terceiro nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	f.cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	(OBTER_ESTAB_FINANCEIRO(c.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	(null)::numeric  nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(c.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
FROM tributo e, repasse_terceiro c, repasse_terceiro_venc b, repasse_terc_venc_trib a, terceiro d
LEFT OUTER JOIN pessoa_juridica f ON (d.cd_cgc = f.cd_cgc
group	by d.CD_CGC,
	d.CD_PESSOA_FISICA,
	CASE WHEN e.ie_vencimento)
WHERE a.nr_seq_rep_venc	= b.nr_sequencia and b.nr_repasse_terceiro	= c.nr_repasse_terceiro and c.nr_seq_terceiro	= d.nr_sequencia and a.ie_pago_prev		= 'V' and e.cd_tributo		= a.cd_tributo and (e.ie_repasse_titulo	= 'N' or exists (select 1 from titulo_pagar x where x.nr_repasse_terceiro = c.nr_repasse_terceiro))  
union

select	coalesce(sum(a.VL_TRIB_NAO_RETIDO), 0) vl_soma_trib_nao_retido,
	coalesce(sum(a.VL_BASE_NAO_RETIDO), 0) vl_soma_base_nao_retido,
	coalesce(sum(a.vl_trib_adic), 0) vl_soma_trib_adic,
	coalesce(sum(a.vl_base_adic), 0) vl_soma_base_adic,
	CASE WHEN coalesce(b.cd_pessoa_fisica,'X')='X' THEN  b.cd_cgc  ELSE '' END  cd_cgc,
	b.cd_pessoa_fisica,
	b.dt_emissao dt_tributo,
	a.cd_tributo,
	'NFE' ie_origem_valores,
	coalesce(sum(a.vl_tributo),0) vl_tributo,
	b.cd_cgc_emitente,
	sum(a.vl_base_calculo) vl_total_base,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(b.nr_sequencia, 'NFE'),1,1)  ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	0 nr_repasse_terceiro,
	b.nr_sequencia nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	e.cd_cnpj_raiz,
	f.cd_cnpj_raiz cd_cnpj_emitente_raiz,
	(OBTER_ESTAB_FINANCEIRO(b.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	(null)::numeric  nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
FROM operacao_nota o, tributo d, nota_fiscal_trib a, nota_fiscal b
LEFT OUTER JOIN pessoa_juridica e ON (b.cd_cgc = e.cd_cgc)
LEFT OUTER JOIN pessoa_juridica f ON (b.cd_cgc_emitente = f.cd_cgc
group 	by b.cd_cgc,
	b.cd_pessoa_fisica,
	b.dt_emissao,
	a.cd_tributo,
	b.cd_cgc_emitente,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(b.nr_sequencia, 'NFE'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	b.nr_sequencia,
	e.cd_cnpj_raiz,
	f.cd_cnpj_raiz,
	(OBTER_ESTAB_FINANCEIRO(b.cd_estabelecimento))::numeric ,
	a.cd_darf,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento))
WHERE a.nr_sequencia	= b.nr_sequencia and coalesce(b.ie_situacao,'1')	= '1' and b.cd_operacao_nf	= o.cd_operacao_nf and o.IE_OPERACAO_FISCAL	= 'E' and a.cd_tributo		= d.cd_tributo and d.ie_corpo_item	= 'C' and coalesce(a.ie_origem_trib, 'N')	= 'N' and coalesce(ie_pago_prev,'V')	= 'V'   
union

select	coalesce(sum(a.VL_TRIB_NAO_RETIDO), 0) vl_soma_trib_nao_retido, -- Edgar OS 50572 tributos que tem a base de calculo conforme vencimentos da NF
	coalesce(sum(a.VL_BASE_NAO_RETIDO), 0) vl_soma_base_nao_retido,
	coalesce(sum(a.vl_trib_adic), 0) vl_soma_trib_adic,
	coalesce(sum(a.vl_base_adic), 0) vl_soma_base_adic,
	CASE WHEN coalesce(b.cd_pessoa_fisica,'X')='X' THEN  b.cd_cgc  ELSE '' END  cd_cgc,
	b.cd_pessoa_fisica,
	a.dt_vencimento dt_tributo,
	a.cd_tributo,
	'NFE' ie_origem_valores,
	coalesce(sum(a.vl_tributo),0) vl_tributo,
	b.cd_cgc_emitente,
	sum(a.vl_base_calculo) vl_total_base,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(b.nr_sequencia, 'NFE'),1,1)  ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	0 nr_repasse_terceiro,
	b.nr_sequencia nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	e.cd_cnpj_raiz,
	f.cd_cnpj_raiz cd_cnpj_emitente_raiz,
	(OBTER_ESTAB_FINANCEIRO(b.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	(null)::numeric  nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
FROM operacao_nota o, tributo d, nota_fiscal_venc_trib a, nota_fiscal b
LEFT OUTER JOIN pessoa_juridica e ON (b.cd_cgc = e.cd_cgc)
LEFT OUTER JOIN pessoa_juridica f ON (b.cd_cgc_emitente = f.cd_cgc
group 	by b.cd_cgc,
	b.cd_pessoa_fisica,
	a.dt_vencimento,
	a.cd_tributo,
	b.cd_cgc_emitente,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(b.nr_sequencia, 'NFE'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	b.nr_sequencia,
	e.cd_cnpj_raiz,
	f.cd_cnpj_raiz,
	(OBTER_ESTAB_FINANCEIRO(b.cd_estabelecimento))::numeric ,
	a.cd_darf,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento))
WHERE a.nr_sequencia	= b.nr_sequencia and coalesce(b.ie_situacao,'1')	= '1' and b.cd_operacao_nf	= o.cd_operacao_nf and o.IE_OPERACAO_FISCAL	= 'E' and a.cd_tributo		= d.cd_tributo and d.ie_corpo_item	= 'V'   
union

select	coalesce(sum(a.VL_NAO_RETIDO),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.VL_BASE_NAO_RETIDO),0) vl_soma_base_nao_retido,
	coalesce(sum(a.VL_TRIB_ADIC),0) vl_soma_trib_adic,
	coalesce(sum(a.VL_BASE_ADIC),0) vl_soma_base_adic,
	b.cd_cgc,
	b.cd_pessoa_fisica,
	d.dt_baixa dt_tributo,
	a.cd_tributo,
	'TP' ie_origem_valores,
	coalesce(sum(a.vl_imposto),0) vl_tributo,
	'' cd_cgc_emitente,
--	sum(to_number(OBTER_DADOS_TIT_PAGAR(b.nr_titulo, 'V'))) vl_total_base,  Edgar 15/03/2006 OS 31396, devido ao INSS descontado do IRPF
	coalesce(sum(a.vl_base_calculo),0) vl_total_base,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(a.nr_titulo, 'TP'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	b.nr_titulo nr_titulo,
	0 nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	c.ie_baixa_titulo ie_baixa_titulo,
	e.cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	b.cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	(null)::numeric  nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
FROM titulo_pagar_baixa d, tributo c, titulo_pagar_imposto a, titulo_pagar b
LEFT OUTER JOIN pessoa_juridica e ON (b.cd_cgc = e.cd_cgc
group 	by b.cd_cgc,
	b.cd_pessoa_fisica,
	d.dt_baixa,
	a.cd_tributo,
	b.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(a.nr_titulo, 'TP'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	b.nr_titulo,
	c.ie_baixa_titulo,
	e.cd_cnpj_raiz,
	b.cd_estab_financeiro,
	a.cd_darf,
	OBTER_EMPRESA_ESTAB(b.cd_estabelecimento))
WHERE a.nr_titulo		= b.nr_titulo and b.ie_situacao	in ('A','L') and a.ie_pago_prev	= 'V' and a.cd_tributo		= c.cd_tributo and c.ie_baixa_titulo	= 'S' and a.nr_seq_baixa		= d.nr_sequencia and a.nr_titulo		= d.nr_titulo  
union

select	coalesce(sum(a.VL_NAO_RETIDO),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.VL_BASE_NAO_RETIDO),0) vl_soma_base_nao_retido,
	coalesce(sum(a.VL_TRIB_ADIC),0) vl_soma_trib_adic,
	coalesce(sum(a.VL_BASE_ADIC),0) vl_soma_base_adic,
	'' CD_CGC,
	d.CD_PESSOA_FISICA,
	CASE WHEN e.ie_vencimento='V' THEN  c.DT_VENCIMENTO WHEN e.ie_vencimento='C' THEN  coalesce(c.DT_VENCIMENTO, f.dt_mesano_ref)  ELSE f.dt_mesano_ref END  dt_tributo,
	a.cd_tributo,
	'DL' ie_origem_valores,
	coalesce(sum(a.vl_tributo),0) vl_tributo,
	'' cd_cgc_emitente,
	sum(a.VL_BASE_CALCULO) vl_total_base,
	d.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(c.nr_sequencia, 'DL'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	(null)::numeric  nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	'' cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	(OBTER_ESTAB_FINANCEIRO(d.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	c.nr_sequencia nr_seq_distribuicao,
	(null)::numeric  nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(d.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
from	tributo e,
	dl_socio d,
	dl_lote_distribuicao f,
	dl_distribuicao c,
	dl_distribuicao_trib a
where	a.nr_seq_distribuicao	= c.nr_sequencia
and	c.nr_seq_socio		= d.nr_sequencia
and	a.cd_tributo		= e.cd_tributo
and	c.nr_seq_lote		= f.nr_sequencia
group	by d.CD_PESSOA_FISICA,
	CASE WHEN e.ie_vencimento='V' THEN  c.DT_VENCIMENTO WHEN e.ie_vencimento='C' THEN  coalesce(c.DT_VENCIMENTO, f.dt_mesano_ref)  ELSE f.dt_mesano_ref END ,
	a.cd_tributo,
	d.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(c.nr_sequencia, 'DL'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	(OBTER_ESTAB_FINANCEIRO(d.cd_estabelecimento))::numeric ,
	a.cd_darf,
	c.nr_sequencia,
	OBTER_EMPRESA_ESTAB(d.cd_estabelecimento)

union

select	coalesce(sum(a.VL_NAO_RETIDO),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.VL_BASE_NAO_RETIDO),0) vl_soma_base_nao_retido,
	coalesce(sum(a.VL_TRIB_ADIC),0) vl_soma_trib_adic,
	coalesce(sum(a.VL_BASE_ADIC),0) vl_soma_base_adic,
	d.CD_CGC,
	d.CD_PESSOA_FISICA,
	CASE WHEN e.ie_vencimento='V' THEN  b.DT_VENCIMENTO WHEN e.ie_vencimento='C' THEN  coalesce(b.DT_VENCIMENTO, c.dt_mes_competencia)  ELSE c.dt_mes_competencia END  dt_tributo,
	a.cd_tributo,
	'LP' ie_origem_valores,
	coalesce(sum(a.vl_imposto),0) vl_tributo,
	'' cd_cgc_emitente,
	sum(a.VL_BASE_CALCULO) vl_total_base,
	c.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(c.nr_sequencia, 'LP'),1,1) ie_base_calculo,
	sum(coalesce(a.vl_reducao,0)) vl_reducao,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao) dt_criacao,
	0 nr_titulo,
	(null)::numeric  nr_repasse_terceiro,
	0 nr_seq_nota_fiscal,
	'N' ie_baixa_titulo,
	substr(obter_cnpj_raiz(d.cd_cgc),1,20) cd_cnpj_raiz,
	'' cd_cnpj_emitente_raiz,
	(OBTER_ESTAB_FINANCEIRO(c.cd_estabelecimento))::numeric  cd_estab_financeiro,
	a.cd_darf,
	(null)::numeric  nr_seq_distribuicao,
	c.nr_sequencia nr_seq_lote_protocolo,
	OBTER_EMPRESA_ESTAB(c.cd_estabelecimento) cd_empresa,
	(null)::numeric  nr_seq_pag_prest,
	null nr_seq_trib_valor
from	tributo e,
	pls_prestador d,
	pls_lote_protocolo c,
	pls_lote_protocolo_venc b,
	pls_lote_prot_venc_trib a
where	a.nr_seq_lote_venc	= b.nr_sequencia
and	b.nr_seq_lote		= c.nr_sequencia
and	c.nr_seq_prestador	= d.nr_sequencia
and	a.ie_pago_prev		= 'V'
and	e.cd_tributo		= a.cd_tributo
group	by d.CD_CGC,
	d.CD_PESSOA_FISICA,
	CASE WHEN e.ie_vencimento='V' THEN  b.DT_VENCIMENTO WHEN e.ie_vencimento='C' THEN  coalesce(b.DT_VENCIMENTO, c.dt_mes_competencia)  ELSE c.dt_mes_competencia END ,
	a.cd_tributo,
	c.cd_estabelecimento,
	substr(OBTER_SE_BASE_CALCULO(c.nr_sequencia, 'LP'),1,1),
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	c.nr_sequencia,
	substr(obter_cnpj_raiz(d.cd_cgc),1,20),
	(OBTER_ESTAB_FINANCEIRO(c.cd_estabelecimento))::numeric ,
	a.cd_darf,
	OBTER_EMPRESA_ESTAB(c.cd_estabelecimento)

union

select	coalesce(sum(a.vl_nao_retido),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.vl_base_nao_retido),0) vl_soma_base_nao_retido,
	coalesce(sum(a.vl_trib_adic),0) vl_soma_trib_adic,
	coalesce(sum(a.vl_base_adic),0) vl_soma_base_adic,
	d.cd_cgc,
	d.cd_pessoa_fisica,
	CASE WHEN e.ie_venc_pls_pag_prod='C' THEN  p.dt_mes_competencia WHEN e.ie_venc_pls_pag_prod='V' THEN  b.dt_vencimento  ELSE CASE WHEN e.ie_vencimento='V' THEN  b.dt_vencimento WHEN e.ie_vencimento='C' THEN  coalesce(b.dt_vencimento, p.dt_mes_competencia)  ELSE p.dt_mes_competencia END  END  dt_tributo,
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
from	tributo				e,
	pls_prestador			d,
	pls_lote_pagamento		p,
	pls_pagamento_prestador		c,
	pls_pag_prest_vencimento	b,
	pls_pag_prest_venc_trib		a
where	a.nr_seq_vencimento	= b.nr_sequencia
and	b.nr_seq_pag_prestador	= c.nr_sequencia
and	c.nr_seq_prestador	= d.nr_sequencia
and	c.nr_seq_lote		= p.nr_sequencia
and	a.ie_pago_prev		= 'V'
and	e.cd_tributo		= a.cd_tributo
and	c.IE_CANCELAMENTO is null
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

union

select	coalesce(sum(a.vl_nao_retido),0) vl_soma_trib_nao_retido,
	coalesce(sum(a.vl_base_nao_retido),0) vl_soma_base_nao_retido,
	coalesce(sum(a.vl_trib_adic),0) vl_soma_trib_adic,
	coalesce(sum(a.vl_base_adic),0) vl_soma_base_adic,
	'' cd_cgc,
	b.cd_pessoa_fisica,
	CASE WHEN e.ie_vencimento='V' THEN  a.dt_imposto WHEN e.ie_vencimento='C' THEN  coalesce(a.dt_imposto, c.dt_mes_referencia)  ELSE c.dt_mes_referencia END  dt_tributo,
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
from	pls_lote_ret_trib_valor		a,
	pls_lote_ret_trib_prest		b,
	pls_lote_retencao_trib		c,
	tributo				e
where	a.nr_seq_trib_prest	= b.nr_sequencia
and	b.nr_seq_lote		= c.nr_sequencia
and	b.cd_pessoa_fisica is not null
and	a.ie_pago_prev		in ('R','V')
and	e.cd_tributo		= a.cd_tributo
group by
	b.cd_pessoa_fisica,
	CASE WHEN e.ie_vencimento='V' THEN  a.dt_imposto WHEN e.ie_vencimento='C' THEN  coalesce(a.dt_imposto, c.dt_mes_referencia)  ELSE c.dt_mes_referencia END ,
	a.cd_tributo,
	c.cd_estabelecimento,
	c.nr_sequencia,
	coalesce(a.dt_atualizacao_nrec,a.dt_atualizacao),
	a.cd_darf,
	a.nr_sequencia;

