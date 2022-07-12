-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW registro_cobranca_v (cd_tipo, ds_tipo, ie_status, nr_sequencia, nr_seq_cobrador, cd_pessoa_fisica, cd_cgc, nr_titulo, nr_seq_cheque, vl_acobrar, vl_juros, vl_multa, dt_emissao, dt_vencimento, ds_banco, nr_cheque, cd_estabelecimento, vl_titulo, vl_cheque, dt_liquidacao, ie_regulamentacao_plano, nm_cobrador, nr_carteirinha, nr_seq_pagador, nr_contrato) AS select 	'T' cd_tipo,
	'Título' ds_tipo, 
	a.ie_status, 
	a.nr_sequencia, 
	a.nr_seq_cobrador, 
	b.cd_pessoa_fisica, 
	b.cd_cgc, 
	a.nr_titulo, 
	a.nr_seq_cheque, 
	a.vl_acobrar, 
	coalesce(obter_juros_multa_titulo(b.nr_titulo,LOCALTIMESTAMP,'R','J'),0) vl_juros, 
	coalesce(obter_juros_multa_titulo(b.nr_titulo,LOCALTIMESTAMP,'R','M'),0) vl_multa, 
	b.dt_emissao dt_emissao, 
	b.dt_pagamento_previsto dt_vencimento, 
	null ds_banco, 
	null nr_cheque, 
	a.cd_estabelecimento, 
	coalesce(b.vl_titulo,0) vl_titulo, 
	0 vl_cheque, 
	b.dt_liquidacao dt_liquidacao, 
	(select max(x.ie_regulamentacao) 
	FROM pls_plano x, 
		pls_mensalidade_segurado y 
	where x.nr_sequencia   = y.nr_seq_plano 
	and y.nr_seq_mensalidade = b.nr_seq_mensalidade 
	) ie_regulamentacao_plano, 
	substr(obter_nome_pf_pj(obter_descricao_padrao('COBRADOR','CD_PESSOA_FISICA',a.NR_SEQ_COBRADOR), null), 1, 80) nm_cobrador, 
	substr(pls_carteira_pag_se_seg(obter_dados_titulo_receber(b.nr_titulo,'PPS'),b.cd_pessoa_fisica),1,40) nr_carteirinha, 
	substr(obter_dados_titulo_receber(b.nr_titulo,'PPS'),1,10) nr_seq_pagador, 
	substr(pls_obter_dados_pagador(obter_dados_titulo_receber(b.nr_titulo,'PPS'),'NC'),1,10) nr_contrato 
from titulo_receber b, 
	cobranca a 
where a.nr_titulo = b.nr_titulo 
and a.nr_titulo is not null 

union all
 
select 	'C' cd_tipo, 
	'Cheque' ds_tipo, 
	a.ie_status, 
	a.nr_sequencia, 
	a.nr_seq_cobrador, 
	b.cd_pessoa_fisica, 
	b.cd_cgc, 
	a.nr_titulo, 
	a.nr_seq_cheque, 
	a.vl_acobrar, 
	CASE WHEN b.dt_devolucao IS NULL THEN  obter_juro_multa_cheque(a.nr_seq_cheque,LOCALTIMESTAMP, 'R', 'J')  ELSE 0 END  vl_juros, 
	CASE WHEN b.dt_devolucao IS NULL THEN  obter_juro_multa_cheque(a.nr_seq_cheque,LOCALTIMESTAMP, 'R', 'M')  ELSE 0 END  vl_multa, 
	b.dt_contabil dt_emissao, 
	coalesce(b.dt_vencimento_atual,b.dt_vencimento) dt_vencimento, 
	substr(obter_nome_banco(b.cd_banco),1,255) ds_banco, 
	b.nr_cheque nr_cheque, 
	a.cd_estabelecimento, 
	0 vl_titulo, 
	coalesce(b.vl_cheque,0) vl_cheque, 
	b.dt_compensacao dt_liquidacao, 
	to_char(null) ie_regulamentacao_plano, 
	substr(obter_nome_pf_pj(obter_descricao_padrao('COBRADOR','CD_PESSOA_FISICA',a.NR_SEQ_COBRADOR), null), 1, 80) nm_cobrador, 
	null nr_carteirinha, 
	null nr_seq_pagador, 
	null nr_contrato 
from cheque_cr b, 
	cobranca a 
where a.nr_seq_cheque = b.nr_seq_cheque;

