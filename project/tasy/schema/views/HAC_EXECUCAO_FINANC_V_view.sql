-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hac_execucao_financ_v (ie_ordem, cd_conta_financ, ds_conta_financ, nr_bordero, ds_bordero, nr_seq_conta, ds_conta, ds_benefic, nr_titulo, vl_saida, dt_transacao, dt_referencia, dt_saldo, cd_estabelecimento, ie_origem, dt_atualizacao, vl_pago_titulo) AS select 	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END  ie_ordem,
	coalesce(c.nr_seq_conta_financ,0) cd_conta_financ, 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira') ds_conta_financ, 
	d.nr_bordero nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos') ds_bordero, 
	g.nr_seq_conta nr_seq_conta, 
	substr(obter_descricao_padrao('BANCO_ESTABELECIMENTO','CD_CONTA',g.nr_seq_conta),1,60) ds_conta, 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80) ds_benefic, 
	a.nr_titulo nr_titulo, 
	coalesce((obter_baixa_conta_financ(a.nr_titulo,c.nr_seq_conta_financ,null,'TP'))::numeric ,0) vl_saida, 
	e.dt_transacao dt_transacao, 
	g.dt_referencia dt_referencia, 
	to_date(null) dt_saldo, 
	h.cd_estabelecimento cd_estabelecimento, 
	'B' ie_origem, 
	e.dt_atualizacao dt_atualizacao, 
	sum(coalesce(OBTER_DADOS_TIT_PAGAR(a.nr_titulo,'P'),0)) vl_pago_titulo 
FROM banco_estabelecimento h, banco_saldo g, transacao_financeira f, movto_trans_financ e, titulo_pagar_bordero_v d, titulo_pagar a
LEFT OUTER JOIN titulo_pagar_classif c ON (a.nr_titulo = c.nr_titulo)
WHERE e.nr_seq_titulo_pagar 	= d.nr_titulo and a.nr_titulo		= d.nr_titulo  and e.nr_seq_trans_financ 	= f.nr_sequencia and e.nr_seq_saldo_banco 	= g.nr_sequencia and g.nr_seq_conta		= h.nr_sequencia and f.ie_banco 		= 'C' and e.nr_bordero is null group by 
	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END , 
	coalesce(c.nr_seq_conta_financ,0), 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira'), 
	d.nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos'), 
	g.nr_seq_conta, 
	substr(obter_descricao_padrao('BANCO_ESTABELECIMENTO','CD_CONTA',g.nr_seq_conta),1,60), 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80), 
	a.nr_titulo, 
	c.nr_seq_conta_financ, 
	e.dt_transacao, 
	g.dt_referencia, 
	h.cd_estabelecimento, 
	e.dt_atualizacao 

union all
 
select 	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END  ie_ordem, 
	coalesce(c.nr_seq_conta_financ,0) cd_conta_financ, 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira') ds_conta_financ, 
	d.nr_bordero nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos') ds_bordero, 
	g.nr_seq_conta nr_seq_conta, 
	substr(obter_descricao_padrao('BANCO_ESTABELECIMENTO','CD_CONTA',g.nr_seq_conta),1,60) ds_conta, 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80) ds_benefic, 
	a.nr_titulo nr_titulo, 
	coalesce((obter_baixa_conta_financ(a.nr_titulo,c.nr_seq_conta_financ,null,'TP'))::numeric ,0) vl_saida, 
	e.dt_transacao dt_transacao, 
	g.dt_referencia dt_referencia, 
	to_date(null) dt_saldo, 
	h.cd_estabelecimento cd_estabelecimento, 
	'B' ie_origem, 
	e.dt_atualizacao dt_atualizacao, 
	sum(coalesce(OBTER_DADOS_TIT_PAGAR(a.nr_titulo,'P'),0)) vl_pago_titulo 
FROM banco_estabelecimento h, banco_saldo g, transacao_financeira f, movto_trans_financ e, titulo_pagar_bordero_v d, titulo_pagar a
LEFT OUTER JOIN titulo_pagar_classif c ON (a.nr_titulo = c.nr_titulo)
WHERE e.nr_bordero	 	= d.nr_bordero and e.nr_sequencia		= (select	max(x.nr_sequencia) /*Trazer apenas uma transacao*/
 
				  from		movto_trans_financ x 
				  where	x.nr_bordero = d.nr_bordero) and a.nr_titulo		= d.nr_titulo  and e.nr_seq_trans_financ 	= f.nr_sequencia and e.nr_seq_saldo_banco 	= g.nr_sequencia and g.nr_seq_conta		= h.nr_sequencia and f.ie_banco 		= 'C' group by 
	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END , 
	coalesce(c.nr_seq_conta_financ,0), 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira'), 
	d.nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos'), 
	g.nr_seq_conta, 
	substr(obter_descricao_padrao('BANCO_ESTABELECIMENTO','CD_CONTA',g.nr_seq_conta),1,60), 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80), 
	a.nr_titulo, 
	c.nr_seq_conta_financ, 
	e.dt_transacao, 
	g.dt_referencia, 
	h.cd_estabelecimento, 
	e.dt_atualizacao 
/*Caixa*/
 

union all
 
select 	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END  ie_ordem, 
	coalesce(c.nr_seq_conta_financ,0) cd_conta_financ, 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira') ds_conta_financ, 
	d.nr_bordero nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos') ds_bordero, 
	null nr_seq_conta, 
	substr(obter_descricao_padrao('CAIXA','DS_CAIXA',g.nr_seq_caixa),1,60) ds_conta, 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80) ds_benefic, 
	a.nr_titulo nr_titulo, 
	coalesce((obter_baixa_conta_financ(a.nr_titulo,c.nr_seq_conta_financ,null,'TP'))::numeric ,0) vl_saida, 
	e.dt_transacao dt_transacao, 
	to_date(null) dt_referencia, 
	g.dt_saldo dt_saldo, 
	h.cd_estabelecimento cd_estabelecimento, 
	'C' ie_origem, 
	e.dt_atualizacao dt_atualizacao, 
	sum(coalesce(OBTER_DADOS_TIT_PAGAR(a.nr_titulo,'P'),0)) vl_pago_titulo 
FROM caixa h, caixa_saldo_diario g, transacao_financeira f, movto_trans_financ e, titulo_pagar_bordero_v d, titulo_pagar a
LEFT OUTER JOIN titulo_pagar_classif c ON (a.nr_titulo = c.nr_titulo)
WHERE e.nr_seq_titulo_pagar 	= d.nr_titulo and a.nr_titulo		= d.nr_titulo  and e.nr_seq_trans_financ 	= f.nr_sequencia and e.nr_seq_saldo_caixa 	= g.nr_sequencia and g.nr_seq_caixa		= h.nr_sequencia and f.ie_saldo_caixa	= 'S' and f.ie_caixa		in ('D','A') group by 
	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END , 
	coalesce(c.nr_seq_conta_financ,0), 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira'), 
	d.nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos'), 
	substr(obter_descricao_padrao('CAIXA','DS_CAIXA',g.nr_seq_caixa),1,60), 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80), 
	a.nr_titulo, 
	c.nr_seq_conta_financ, 
	e.dt_transacao, 
	g.dt_saldo, 
	h.cd_estabelecimento, 
	e.dt_atualizacao 

union all
 
select 	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END  ie_ordem, 
	coalesce(c.nr_seq_conta_financ,0) cd_conta_financ, 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira') ds_conta_financ, 
	d.nr_bordero nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos') ds_bordero, 
	null nr_seq_conta, 
	substr(obter_descricao_padrao('CAIXA','DS_CAIXA',g.nr_seq_caixa),1,60) ds_conta, 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80) ds_benefic, 
	a.nr_titulo nr_titulo, 
	coalesce((obter_baixa_conta_financ(a.nr_titulo,c.nr_seq_conta_financ,null,'TP'))::numeric ,0) vl_saida, 
	e.dt_transacao dt_transacao, 
	to_date(null) dt_referencia, 
	g.dt_saldo dt_saldo, 
	h.cd_estabelecimento cd_estabelecimento, 
	'C' ie_origem, 
	e.dt_atualizacao dt_atualizacao, 
	sum(coalesce(OBTER_DADOS_TIT_PAGAR(a.nr_titulo,'P'),0)) vl_pago_titulo 
FROM caixa h, caixa_saldo_diario g, transacao_financeira f, movto_trans_financ e, titulo_pagar_bordero_v d, titulo_pagar a
LEFT OUTER JOIN titulo_pagar_classif c ON (a.nr_titulo = c.nr_titulo)
WHERE e.nr_bordero	 	= d.nr_bordero and e.nr_sequencia		= (select	max(x.nr_sequencia) /*Trazer apenas uma transacao*/
 
				  from		movto_trans_financ x 
				  where	x.nr_bordero = d.nr_bordero) and a.nr_titulo		= d.nr_titulo  and e.nr_seq_trans_financ 	= f.nr_sequencia and e.nr_seq_saldo_caixa 	= g.nr_sequencia and g.nr_seq_caixa		= h.nr_sequencia and f.ie_saldo_caixa	= 'S' and f.ie_caixa		in ('D','A') group by 
	CASE WHEN c.nr_seq_conta_financ IS NULL THEN 2  ELSE 1 END , 
	coalesce(c.nr_seq_conta_financ,0), 
	coalesce(substr(obter_descricao_padrao('CONTA_FINANCEIRA','DS_CONTA_FINANC',c.nr_seq_conta_financ),1,60),'Sem Conta Financeira'), 
	d.nr_bordero, 
	coalesce(to_char(d.nr_bordero),'Avulsos'), 
	substr(obter_descricao_padrao('CAIXA','DS_CAIXA',g.nr_seq_caixa),1,60), 
	substr(obter_pessoa_titulo_pagar(d.nr_titulo),1,80), 
	a.nr_titulo, 
	c.nr_seq_conta_financ, 
	e.dt_transacao, 
	g.dt_saldo, 
	h.cd_estabelecimento, 
	e.dt_atualizacao;
