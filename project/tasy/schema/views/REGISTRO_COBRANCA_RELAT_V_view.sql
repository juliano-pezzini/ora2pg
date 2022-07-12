-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW registro_cobranca_relat_v (ie_modo, nm_operador, ds_resultado, qt_contrato, qt_cobranca, vl_emitido, vl_saldo, nr_seq_grupo, dt_previsao, dt_vencimento, nr_seq_cobrador, nr_seq_historico, nr_seq_plano, nr_seq_registro) AS select	/*+ USE_CONCAT */	'R' ie_modo,
	'' nm_operador,
	substr(coalesce(pls_obter_dados_produto_contr(f.nr_seq_contrato,'R'),'R'),1,255) ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	(select	max(x.nr_sequencia)
	FROM grupo_cobranca x, h
LEFT OUTER JOIN grupo_cobranca_membro y ON (h.nr_sequencia = y.nr_seq_cobrador)
WHERE x.nr_sequencia = y.nr_seq_grupo ) nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	(select	max(x.nr_seq_plano)
	from	pls_contrato_plano x
	where	x.nr_seq_contrato = f.nr_seq_contrato
	and	x.ie_situacao = 'A') nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobr_item b, registro_cobranca a, cobranca c
LEFT OUTER JOIN cobrador h ON (c.nr_seq_cobrador = h.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_registro and b.nr_seq_cobranca= c.nr_sequencia  and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia group by
	coalesce(pls_obter_dados_produto_contr(f.nr_seq_contrato,'R'),'R'),
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	f.nr_seq_contrato,
	a.nr_seq_historico,
	a.nr_sequencia

union all

select	'P' ie_modo,
	'' nm_operador,
	substr(pls_obter_dados_produto_contr(f.nr_seq_contrato,'N'),1,255) ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	(select	max(x.nr_sequencia)
	FROM grupo_cobranca x, h
LEFT OUTER JOIN grupo_cobranca_membro y ON (h.nr_sequencia = y.nr_seq_cobrador)
WHERE x.nr_sequencia = y.nr_seq_grupo ) nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	somente_numero(substr(pls_obter_dados_produto_contr(f.nr_seq_contrato,'S'),1,255)) nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobranca a, cobrador h
LEFT OUTER JOIN cobranca c ON (h.nr_sequencia = c.nr_seq_cobrador)
LEFT OUTER JOIN registro_cobr_item b ON (c.nr_sequencia = b.nr_seq_cobranca)
WHERE a.nr_sequencia	= b.nr_seq_registro   and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia and (select	x.ie_tipo_operacao
	from	pls_plano x
	where	x.nr_sequencia = somente_numero(substr(pls_obter_dados_produto_contr(f.nr_seq_contrato,'S'),1,10))) = 'B' group by
	pls_obter_dados_produto_contr(f.nr_seq_contrato,'N'),
	pls_obter_dados_produto_contr(f.nr_seq_contrato,'S'),
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	a.nr_seq_historico,
	a.nr_sequencia

union all

select	'E' ie_modo,
	'' nm_operador,
	i.ds_grupo ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	i.nr_sequencia nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	(select	max(x.nr_seq_plano)
	from	pls_contrato_plano x
	where	x.nr_seq_contrato = f.nr_seq_contrato
	and	x.ie_situacao = 'A') nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM grupo_cobranca i, pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobr_item b, registro_cobranca a, cobranca c
LEFT OUTER JOIN cobrador h ON (c.nr_seq_cobrador = h.nr_sequencia)
LEFT OUTER JOIN grupo_cobranca_membro g ON (h.nr_sequencia = g.nr_seq_cobrador)
WHERE a.nr_sequencia	= b.nr_seq_registro and b.nr_seq_cobranca= c.nr_sequencia   and i.nr_sequencia = g.nr_seq_grupo and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia group by
	i.ds_grupo,
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	i.nr_sequencia,
	f.nr_seq_contrato,
	a.nr_seq_historico,
	a.nr_sequencia

union all

select	'H' ie_modo,
	'' nm_operador,
	g.ds_historico ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	(select	max(x.nr_sequencia)
	FROM grupo_cobranca x, h
LEFT OUTER JOIN grupo_cobranca_membro y ON (h.nr_sequencia = y.nr_seq_cobrador)
WHERE x.nr_sequencia = y.nr_seq_grupo ) nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	(select	max(x.nr_seq_plano)
	from	pls_contrato_plano x
	where	x.nr_seq_contrato = f.nr_seq_contrato
	and	x.ie_situacao = 'A') nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM tipo_hist_cob g, pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobr_item b, registro_cobranca a, cobranca c
LEFT OUTER JOIN cobrador h ON (c.nr_seq_cobrador = h.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_registro and b.nr_seq_cobranca= c.nr_sequencia  and a.nr_seq_historico = g.nr_sequencia and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia group by
	g.ds_historico,
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	a.nr_seq_historico,
	f.nr_seq_contrato,
	a.nr_sequencia

union all

select	'Q' ie_modo,
	'' nm_operador,
	to_char(pls_obter_qt_meses_pendentes(f.cd_pessoa_fisica,f.cd_cgc)) ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	(select	max(x.nr_sequencia)
	FROM grupo_cobranca x, h
LEFT OUTER JOIN grupo_cobranca_membro y ON (h.nr_sequencia = y.nr_seq_cobrador)
WHERE x.nr_sequencia = y.nr_seq_grupo ) nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	(select	max(x.nr_seq_plano)
	from	pls_contrato_plano x
	where	x.nr_seq_contrato = f.nr_seq_contrato
	and	x.ie_situacao = 'A') nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobr_item b, registro_cobranca a, cobranca c
LEFT OUTER JOIN cobrador h ON (c.nr_seq_cobrador = h.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_registro and b.nr_seq_cobranca= c.nr_sequencia  and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia group by
	to_char(pls_obter_qt_meses_pendentes(f.cd_pessoa_fisica,f.cd_cgc)),
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	f.nr_seq_contrato,
	a.nr_seq_historico,
	a.nr_sequencia

union all

select	'D' ie_modo,
	'' nm_operador,
	to_char(d.dt_pagamento_previsto,'dd/mm/yyyy') ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	(select	max(x.nr_sequencia)
	FROM grupo_cobranca x, h
LEFT OUTER JOIN grupo_cobranca_membro y ON (h.nr_sequencia = y.nr_seq_cobrador)
WHERE x.nr_sequencia = y.nr_seq_grupo ) nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	(select	max(x.nr_seq_plano)
	from	pls_contrato_plano x
	where	x.nr_seq_contrato = f.nr_seq_contrato
	and	x.ie_situacao = 'A') nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobr_item b, registro_cobranca a, cobranca c
LEFT OUTER JOIN cobrador h ON (c.nr_seq_cobrador = h.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_registro and b.nr_seq_cobranca= c.nr_sequencia  and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia group by
	d.dt_pagamento_previsto,
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	f.nr_seq_contrato,
	a.nr_seq_historico,
	a.nr_sequencia

union all

select	'C' ie_modo,
	'' nm_operador,
	h.nm_guerra ds_resultado,
	count(distinct f.nr_seq_contrato) qt_contrato,
	count(*) qt_cobranca,
	c.vl_original vl_emitido,
	c.vl_acobrar vl_saldo,
	(select	max(x.nr_sequencia)
	FROM grupo_cobranca x, h
LEFT OUTER JOIN grupo_cobranca_membro y ON (h.nr_sequencia = y.nr_seq_cobrador)
WHERE x.nr_sequencia = y.nr_seq_grupo ) nr_seq_grupo,
	d.dt_pagamento_previsto dt_previsao,
	d.dt_vencimento,
	h.nr_sequencia nr_seq_cobrador,
	a.nr_seq_historico,
	(select	max(x.nr_seq_plano)
	from	pls_contrato_plano x
	where	x.nr_seq_contrato = f.nr_seq_contrato
	and	x.ie_situacao = 'A') nr_seq_plano,
	a.nr_sequencia nr_seq_registro
FROM pls_contrato_pagador f, pls_mensalidade e, titulo_receber d, registro_cobr_item b, registro_cobranca a, cobranca c
LEFT OUTER JOIN cobrador h ON (c.nr_seq_cobrador = h.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_registro and b.nr_seq_cobranca= c.nr_sequencia  and c.nr_titulo	= d.nr_titulo and d.nr_seq_mensalidade	= e.nr_sequencia and e.nr_seq_pagador	= f.nr_sequencia group by
	d.dt_pagamento_previsto,
	c.vl_original,
	c.vl_acobrar,
	d.dt_pagamento_previsto,
	d.dt_vencimento,
	h.nr_sequencia,
	h.nm_guerra,
	f.nr_seq_contrato,
	a.nr_seq_historico,
	a.nr_sequencia;

