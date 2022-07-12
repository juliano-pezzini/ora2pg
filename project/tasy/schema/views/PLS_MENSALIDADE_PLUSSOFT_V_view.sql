-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_mensalidade_plussoft_v (dt_referencia, vl_mensalidade, dt_vencimento, cd_banco, cd_agencia, cd_conta, nr_seq_conta_banco, nr_seq_forma_cobranca, nr_seq_pagador, nr_titulo, nr_seq_lote, dt_mesano_referencia, nr_serie_mensalidade, ie_varios_titulos, nm_pagador, forma_cobranca, ds_conta, nr_seq_contrato) AS select	a.dt_referencia							dt_referencia,	
	coalesce(a.vl_mensalidade,0) 					vl_mensalidade, 
	a.dt_vencimento							dt_vencimento, 
	h.cd_banco							cd_banco, 
	h.cd_agencia_bancaria						cd_agencia, 
	h.cd_conta							cd_conta, 
	a.nr_seq_conta_banco						nr_seq_conta_banco, 
	a.nr_seq_forma_cobranca						nr_seq_forma_cobranca, 
	a.nr_seq_pagador						nr_seq_pagador, 
	g.nr_titulo 							nr_titulo, 
	l.nr_sequencia 							nr_seq_lote, 
	l.dt_mesano_referencia						dt_mesano_referencia, 
	a.nr_serie_mensalidade						nr_serie_mensalidade, 
	a.ie_varios_titulos						ie_varios_titulos, 
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) 	nm_pagador, 
	(	select	substr(ds_valor_dominio,1,254) 
		FROM 	valor_dominio 
		where 	cd_dominio	= 1720 
		and	vl_dominio	= a.nr_seq_forma_cobranca) 	forma_cobranca, 
	h.ds_conta							ds_conta, 
	i.nr_seq_contrato 
from	titulo_receber			g, 
	pls_mensalidade			a, 
	pls_lote_mensalidade		l, 
	banco_estabelecimento_v		h, 
	pls_contrato_pagador		i 
where	l.nr_sequencia			= a.nr_seq_lote 
and	g.nr_seq_mensalidade		= a.nr_sequencia 
and	a.nr_seq_conta_banco		= h.nr_sequencia 
and 	a.nr_seq_pagador		= i.nr_sequencia 
and	a.ie_varios_titulos is null 
group by	a.dt_referencia, 
		a.vl_mensalidade, 
		a.dt_vencimento, 
		a.cd_banco, 
		a.nr_seq_conta_banco, 
		a.nr_seq_forma_cobranca, 
		a.nr_seq_pagador, 
		g.nr_titulo, 
		l.nr_sequencia, 
		l.dt_mesano_referencia, 
		a.nr_serie_mensalidade, 
		a.ie_varios_titulos, 
		h.cd_banco, 
		h.cd_agencia_bancaria, 
		h.cd_conta, 
		h.ds_conta, 
		i.nr_seq_contrato 

union all
 
select	a.dt_referencia							dt_referencia,	 
	coalesce(a.vl_mensalidade,0) 					vl_mensalidade, 
	a.dt_vencimento							dt_vencimento, 
	h.cd_banco							cd_banco, 
	h.cd_agencia_bancaria						cd_agencia, 
	h.cd_conta							cd_conta,	 
	a.nr_seq_conta_banco						nr_seq_conta_banco, 
	a.nr_seq_forma_cobranca						nr_seq_forma_cobranca, 
	a.nr_seq_pagador						nr_seq_pagador, 
	null 								nr_titulo, 
	l.nr_sequencia 							nr_seq_lote, 
	l.dt_mesano_referencia						dt_mesano_referencia, 
	a.nr_serie_mensalidade						nr_serie_mensalidade, 
	a.ie_varios_titulos						ie_varios_titulos, 
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) 	nm_pagador, 
	(	select	substr(ds_valor_dominio,1,254) 
		from 	valor_dominio 
		where 	cd_dominio	= 1720 
		and	vl_dominio	= a.nr_seq_forma_cobranca) 	forma_cobranca, 
	h.ds_conta 							ds_conta, 
	i.nr_seq_contrato 
from	pls_mensalidade			a, 
	pls_lote_mensalidade		l, 
	banco_estabelecimento_v		h, 
	pls_contrato_pagador		i 
where	l.nr_sequencia			= a.nr_seq_lote 
and	a.nr_seq_conta_banco		= h.nr_sequencia 
and 	a.nr_seq_pagador		= i.nr_sequencia 
and	a.ie_varios_titulos is null	 
and	not exists (	select	1 
			from	titulo_receber t 
			where	t.nr_seq_mensalidade	= a.nr_sequencia) 
group by	a.dt_referencia, 
		a.vl_mensalidade, 
		a.dt_vencimento, 
		a.cd_banco, 
		a.nr_seq_conta_banco, 
		a.nr_seq_forma_cobranca, 
		a.nr_seq_pagador, 
		l.nr_sequencia, 
		l.dt_mesano_referencia, 
		a.nr_serie_mensalidade, 
		a.ie_varios_titulos, 
		h.cd_banco, 
		h.cd_agencia_bancaria, 
		h.cd_conta, 
		h.ds_conta, 
		i.nr_seq_contrato 

union all
 
select	a.dt_referencia							dt_referencia,	 
	coalesce(a.vl_mensalidade,0) 					vl_mensalidade, 
	a.dt_vencimento							dt_vencimento, 
	h.cd_banco							cd_banco, 
	h.cd_agencia_bancaria						cd_agencia, 
	h.cd_conta							cd_conta,	 
	a.nr_seq_conta_banco						nr_seq_conta_banco, 
	a.nr_seq_forma_cobranca						nr_seq_forma_cobranca, 
	a.nr_seq_pagador						nr_seq_pagador, 
	null								nr_titulo, 
	l.nr_sequencia 							nr_seq_lote, 
	l.dt_mesano_referencia						dt_mesano_referencia, 
	a.nr_serie_mensalidade						nr_serie_mensalidade, 
	a.ie_varios_titulos						ie_varios_titulos, 
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) 	nm_pagador, 
	(	select	substr(ds_valor_dominio,1,254) 
		from 	valor_dominio 
		where 	cd_dominio	= 1720 
		and	vl_dominio	= a.nr_seq_forma_cobranca) 	forma_cobranca, 
	h.ds_conta 							ds_conta, 
	i.nr_seq_contrato 
from	pls_mensalidade			a, 
	pls_lote_mensalidade		l, 
	banco_estabelecimento_v		h, 
	pls_contrato_pagador		i 
where	l.nr_sequencia			= a.nr_seq_lote 
and	a.nr_seq_conta_banco		= h.nr_sequencia 
and 	a.nr_seq_pagador		= i.nr_sequencia 
and	a.ie_varios_titulos = 'S' 
group by	a.dt_referencia, 
		a.vl_mensalidade, 
		a.dt_vencimento, 
		a.cd_banco, 
		a.nr_seq_conta_banco, 
		a.nr_seq_forma_cobranca, 
		a.nr_seq_pagador, 
		l.nr_sequencia, 
		l.dt_mesano_referencia, 
		a.nr_serie_mensalidade, 
		a.ie_varios_titulos, 
		h.cd_banco, 
		h.cd_agencia_bancaria, 
		h.cd_conta, 
		h.ds_conta, 
		i.nr_seq_contrato;
