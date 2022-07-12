-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_mensalidade_wcp_v (dt_referencia, vl_mensalidade, vl_pre_estabelecido, vl_pro_rata_dia, vl_coparticipacao, vl_antecipacao, nr_seq_pagador, nm_pagador, nr_sequencia, ie_cancelamento, nr_nota_fiscal, nr_titulo, vl_titulo, dt_liquidacao_titulo, dt_cancelamento, dt_vencimento, cd_banco, ds_conta, nr_seq_cobranca, ds_observacao, ds_mensagem_quitacao, vl_outros, nr_desconto_folha, forma_cobranca, cd_matricula, ds_empresa, vl_taxa_boleto, ds_motivo_cancelamento, nr_seq_lote, nr_sequencia_nf, nr_beneficiarios, nm_usuario_cancelamento, dt_pagamento_previsto, ie_tipo_formacao_preco, cd_pessoa_fisica, qt_tempo_geracao, ds_nota_titulo, nr_serie_mensalidade, ie_varios_titulos, nr_rps, cd_grupo_intercambio, nr_nfe_imp, ie_situacao_titulo, ds_envio_cobranca, ds_complemento) AS select	a.dt_referencia,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	coalesce(a.vl_pre_estabelecido,0) vl_pre_estabelecido,
	coalesce(a.vl_pro_rata_dia,0) vl_pro_rata_dia,
	coalesce(a.vl_coparticipacao,0) vl_coparticipacao,
	coalesce(a.vl_antecipacao,0) vl_antecipacao,
	a.nr_seq_pagador,
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) nm_pagador,
	a.nr_sequencia,
	a.ie_cancelamento,
	f.nr_nota_fiscal nr_nota_fiscal,
	g.nr_titulo nr_titulo,
	coalesce(g.vl_titulo,0) vl_titulo,
	g.dt_liquidacao dt_liquidacao_titulo,
	a.dt_cancelamento,
	a.dt_vencimento,
	a.cd_banco,
	(	select	k.ds_conta
		FROM	banco_estabelecimento_v	k
		where	a.nr_seq_conta_banco		= k.nr_sequencia) ds_conta,
	a.nr_seq_cobranca,
	substr(a.ds_observacao,1,255) ds_observacao,
	substr(a.ds_mensagem_quitacao,1,255) ds_mensagem_quitacao,
	coalesce(a.vl_outros,0) vl_outros,
	(	select	max(h.nr_seq_cobranca)
		from	titulo_receber_cobr	h,
			cobranca_escritural	i
		where	h.nr_seq_cobranca	= i.nr_sequencia
		and	i.ie_tipo_cobranca	= 'D'
		and	h.nr_seq_mensalidade	= a.nr_sequencia) nr_desconto_folha,
	(	select	substr(ds_valor_dominio,1,254)
		from 	valor_dominio_v
		where 	cd_dominio	= 1720
		and	vl_dominio	= a.nr_seq_forma_cobranca) forma_cobranca,
	e.cd_matricula cd_matricula,
	(	select	em.ds_razao_social
		from	pessoa_juridica		em,
			pls_desc_empresa	i
		where	em.cd_cgc		= i.cd_cgc
		and	e.nr_seq_empresa	= i.nr_sequencia) ds_empresa,
	a.vl_taxa_boleto,
	(	select	j.ds_motivo
		from	pls_motivo_canc_mens	j
		where	a.nr_seq_motivo_canc	= j.nr_sequencia) ds_motivo_cancelamento,
	l.nr_sequencia nr_seq_lote,
	f.nr_sequencia nr_sequencia_nf,
	a.qt_beneficiarios nr_beneficiarios,
	a.nm_usuario_cancelamento,
	g.dt_pagamento_previsto,
	CASE WHEN a.ie_tipo_formacao_preco='R' THEN 'Pré-estabelecido' WHEN a.ie_tipo_formacao_preco='P' THEN 'Pós-estabelecido' END  ie_tipo_formacao_preco,
	d.cd_pessoa_fisica,
	a.qt_tempo_geracao,
	CASE WHEN a.ie_nota_titulo='T' THEN 'Somente título'  ELSE 'Nota fiscal e título' END  ds_nota_titulo,
	a.nr_serie_mensalidade,
	a.ie_varios_titulos,
	a.nr_rps,
	a.cd_grupo_intercambio,
	f.nr_nfe_imp	nr_nfe_imp,
	g.ie_situacao ie_situacao_titulo,
	substr(obter_valor_dominio(2817, d.ie_envia_cobranca),1,255) ds_envio_cobranca,
	substr(a.ds_complemento,1,255) ds_complemento
FROM pls_lote_mensalidade l, nota_fiscal f, pls_contrato_pagador_fin e, pls_contrato_pagador d, pls_mensalidade a
LEFT OUTER JOIN titulo_receber g ON (a.nr_sequencia = g.nr_seq_mensalidade)
WHERE l.nr_sequencia			= a.nr_seq_lote and a.nr_seq_pagador		= d.nr_sequencia and f.nr_seq_mensalidade		= a.nr_sequencia  and e.nr_seq_pagador		= d.nr_sequencia and a.nr_seq_pagador_fin		= e.nr_sequencia and a.ie_varios_titulos is null group by	a.dt_referencia,
		a.vl_mensalidade,
		a.vl_pre_estabelecido,
		a.vl_coparticipacao,
		a.nr_seq_pagador,
		d.cd_pessoa_fisica,
		d.cd_cgc,
		a.nr_sequencia,
		a.ie_cancelamento,
		a.dt_cancelamento,
		a.dt_vencimento,
		a.cd_banco,
		a.nr_seq_conta_banco,
		a.nr_seq_cobranca,
		a.nr_seq_motivo_canc,
		a.ds_observacao,
		a.ds_mensagem_quitacao,
		a.vl_outros,
		a.nr_seq_forma_cobranca,
		l.nr_sequencia,
		f.nr_nota_fiscal,
		g.nr_titulo,
		g.vl_titulo,
		g.dt_liquidacao,
		e.cd_matricula,
		f.nr_sequencia,
		a.qt_beneficiarios,
		a.vl_pro_rata_dia,
		a.vl_antecipacao,
		a.nm_usuario_cancelamento,
		a.nr_seq_lote,
		a.vl_taxa_boleto,
		g.dt_pagamento_previsto,
		a.ie_tipo_formacao_preco,
		e.nr_seq_empresa,
		a.qt_tempo_geracao,
		a.ie_nota_titulo,
		a.nr_serie_mensalidade,
		a.ie_varios_titulos,
		a.nr_rps,
		a.cd_grupo_intercambio,
		f.nr_nfe_imp,
		g.ie_situacao,
		d.ie_envia_cobranca,
		a.ds_complemento

union all

select	a.dt_referencia,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	coalesce(a.vl_pre_estabelecido,0) vl_pre_estabelecido,
	coalesce(a.vl_pro_rata_dia,0) vl_pro_rata_dia,
	coalesce(a.vl_coparticipacao,0) vl_coparticipacao,
	coalesce(a.vl_antecipacao,0) vl_antecipacao,
	a.nr_seq_pagador,
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) nm_pagador,
	a.nr_sequencia,
	a.ie_cancelamento,
	null nr_nota_fiscal,
	g.nr_titulo nr_titulo,
	coalesce(g.vl_titulo,0) vl_titulo,
	g.dt_liquidacao dt_liquidacao_titulo,
	a.dt_cancelamento,
	a.dt_vencimento,
	a.cd_banco,
	(	select	k.ds_conta
		from	banco_estabelecimento_v	k
		where	a.nr_seq_conta_banco		= k.nr_sequencia) ds_conta,
	a.nr_seq_cobranca,
	substr(a.ds_observacao,1,255) ds_observacao,
	substr(a.ds_mensagem_quitacao,1,255) ds_mensagem_quitacao,
	coalesce(a.vl_outros,0) vl_outros,
	(	select	max(h.nr_seq_cobranca)
		from	titulo_receber_cobr	h,
			cobranca_escritural	i
		where	h.nr_seq_cobranca	= i.nr_sequencia
		and	i.ie_tipo_cobranca	= 'D'
		and	h.nr_seq_mensalidade	= a.nr_sequencia) nr_desconto_folha,
	(	select	substr(ds_valor_dominio,1,254)
		from 	valor_dominio_v
		where 	cd_dominio	= 1720
		and	vl_dominio	= a.nr_seq_forma_cobranca) forma_cobranca,
	e.cd_matricula cd_matricula,
	(	select	em.ds_razao_social
		from	pessoa_juridica		em,
			pls_desc_empresa	i
		where	em.cd_cgc		= i.cd_cgc
		and	e.nr_seq_empresa	= i.nr_sequencia) ds_empresa,
	a.vl_taxa_boleto,
	(	select	j.ds_motivo
		from	pls_motivo_canc_mens	j
		where	a.nr_seq_motivo_canc	= j.nr_sequencia) ds_motivo_cancelamento,
	l.nr_sequencia nr_seq_lote,
	null nr_sequencia_nf,
	a.qt_beneficiarios nr_beneficiarios,
	a.nm_usuario_cancelamento,
	g.dt_pagamento_previsto,
	CASE WHEN a.ie_tipo_formacao_preco='R' THEN 'Pré-estabelecido' WHEN a.ie_tipo_formacao_preco='P' THEN 'Pós-estabelecido' END  ie_tipo_formacao_preco,
	d.cd_pessoa_fisica,
	a.qt_tempo_geracao,
	CASE WHEN a.ie_nota_titulo='T' THEN 'Somente título'  ELSE 'Nota fiscal e título' END  ds_nota_titulo,
	a.nr_serie_mensalidade,
	a.ie_varios_titulos,
	a.nr_rps,
	a.cd_grupo_intercambio,
	'' 	nr_nfe_imp,
	g.ie_situacao ie_situacao_titulo,
	substr(obter_valor_dominio(2817, d.ie_envia_cobranca),1,255) ds_envio_cobranca,
	substr(a.ds_complemento,1,255) ds_complemento
from	titulo_receber			g,
	pls_contrato_pagador_fin	e,
	pls_contrato_pagador		d,
	pls_mensalidade			a,
	pls_lote_mensalidade		l
where	l.nr_sequencia			= a.nr_seq_lote
and	a.nr_seq_pagador		= d.nr_sequencia
and	g.nr_seq_mensalidade		= a.nr_sequencia
and	e.nr_seq_pagador		= d.nr_sequencia
and	a.nr_seq_pagador_fin		= e.nr_sequencia
and	a.ie_varios_titulos is null
and 	not exists (	select	1
				from	nota_fiscal n
				where	n.nr_seq_mensalidade		= a.nr_sequencia)
group by	a.dt_referencia,
		a.vl_mensalidade,
		a.vl_pre_estabelecido,
		a.vl_coparticipacao,
		a.nr_seq_pagador,
		d.cd_pessoa_fisica,
		d.cd_cgc,
		a.nr_sequencia,
		a.ie_cancelamento,
		a.dt_cancelamento,
		a.dt_vencimento,
		a.cd_banco,
		a.nr_seq_conta_banco,
		a.nr_seq_cobranca,
		a.nr_seq_motivo_canc,
		a.ds_observacao,
		a.ds_mensagem_quitacao,
		a.vl_outros,
		a.nr_seq_forma_cobranca,
		l.nr_sequencia,
		g.nr_titulo,
		g.vl_titulo,
		g.dt_liquidacao,
		e.cd_matricula,
		a.qt_beneficiarios,
		a.vl_pro_rata_dia,
		a.vl_antecipacao,
		a.nm_usuario_cancelamento,
		a.nr_seq_lote,
		a.vl_taxa_boleto,
		g.dt_pagamento_previsto,
		a.ie_tipo_formacao_preco,
		e.nr_seq_empresa,
		a.qt_tempo_geracao,
		a.ie_nota_titulo,
		a.nr_serie_mensalidade,
		a.ie_varios_titulos,
		a.nr_rps,
		a.cd_grupo_intercambio,
		g.ie_situacao,
		d.ie_envia_cobranca,
		a.ds_complemento

union all

select	a.dt_referencia,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	coalesce(a.vl_pre_estabelecido,0) vl_pre_estabelecido,
	coalesce(a.vl_pro_rata_dia,0) vl_pro_rata_dia,
	coalesce(a.vl_coparticipacao,0) vl_coparticipacao,
	coalesce(a.vl_antecipacao,0) vl_antecipacao,
	a.nr_seq_pagador,
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) nm_pagador,
	a.nr_sequencia,
	a.ie_cancelamento,
	null nr_nota_fiscal,
	null nr_titulo,
	null vl_titulo,
	null dt_liquidacao_titulo,
	a.dt_cancelamento,
	a.dt_vencimento,
	a.cd_banco,
	(	select	k.ds_conta
		from	banco_estabelecimento_v	k
		where	a.nr_seq_conta_banco		= k.nr_sequencia) ds_conta,
	a.nr_seq_cobranca,
	substr(a.ds_observacao,1,255) ds_observacao,
	substr(a.ds_mensagem_quitacao,1,255) ds_mensagem_quitacao,
	coalesce(a.vl_outros,0) vl_outros,
	(	select	max(h.nr_seq_cobranca)
		from	titulo_receber_cobr	h,
			cobranca_escritural	i
		where	h.nr_seq_cobranca	= i.nr_sequencia
		and	i.ie_tipo_cobranca	= 'D'
		and	h.nr_seq_mensalidade	= a.nr_sequencia) nr_desconto_folha,
	(	select	substr(ds_valor_dominio,1,254)
		from 	valor_dominio_v
		where 	cd_dominio	= 1720
		and	vl_dominio	= a.nr_seq_forma_cobranca) forma_cobranca,
	e.cd_matricula cd_matricula,
	(	select	em.ds_razao_social
		from	pessoa_juridica		em,
			pls_desc_empresa	i
		where	em.cd_cgc		= i.cd_cgc
		and	e.nr_seq_empresa	= i.nr_sequencia) ds_empresa,
	a.vl_taxa_boleto,
	(	select	j.ds_motivo
		from	pls_motivo_canc_mens	j
		where	a.nr_seq_motivo_canc	= j.nr_sequencia) ds_motivo_cancelamento,
	l.nr_sequencia nr_seq_lote,
	null nr_sequencia_nf,
	a.qt_beneficiarios nr_beneficiarios,
	a.nm_usuario_cancelamento,
	null dt_pagamento_previsto,
	CASE WHEN a.ie_tipo_formacao_preco='R' THEN 'Pré-estabelecido' WHEN a.ie_tipo_formacao_preco='P' THEN 'Pós-estabelecido' END  ie_tipo_formacao_preco,
	d.cd_pessoa_fisica,
	a.qt_tempo_geracao,
	CASE WHEN a.ie_nota_titulo='T' THEN 'Somente título'  ELSE 'Nota fiscal e título' END  ds_nota_titulo,
	a.nr_serie_mensalidade,
	a.ie_varios_titulos,
	a.nr_rps,
	a.cd_grupo_intercambio,
	'' nr_nfe_imp,
	null ie_situacao_titulo,
	substr(obter_valor_dominio(2817, d.ie_envia_cobranca),1,255) ds_envio_cobranca,
	substr(a.ds_complemento,1,255) ds_complemento
from	pls_contrato_pagador_fin	e,
	pls_contrato_pagador		d,
	pls_mensalidade			a,
	pls_lote_mensalidade		l
where	l.nr_sequencia			= a.nr_seq_lote
and	a.nr_seq_pagador		= d.nr_sequencia
and	e.nr_seq_pagador		= d.nr_sequencia
and	a.nr_seq_pagador_fin		= e.nr_sequencia
and	not exists (	select	1
			from	titulo_receber t
			where	t.nr_seq_mensalidade	= a.nr_sequencia)
and	not exists (	select	1
			from	nota_fiscal n
			where	n.nr_seq_mensalidade	= a.nr_sequencia)
group by	a.dt_referencia,
		a.vl_mensalidade,
		a.vl_pre_estabelecido,
		a.vl_coparticipacao,
		a.nr_seq_pagador,
		d.cd_pessoa_fisica,
		d.cd_cgc,
		a.nr_sequencia,
		a.ie_cancelamento,
		a.dt_cancelamento,
		a.dt_vencimento,
		a.cd_banco,
		a.nr_seq_conta_banco,
		a.nr_seq_cobranca,
		a.nr_seq_motivo_canc,
		a.ds_observacao,
		a.ds_mensagem_quitacao,
		a.vl_outros,
		a.nr_seq_forma_cobranca,
		l.nr_sequencia,
		e.cd_matricula,
		a.qt_beneficiarios,
		a.vl_pro_rata_dia,
		a.vl_antecipacao,
		a.nm_usuario_cancelamento,
		a.nr_seq_lote,
		a.vl_taxa_boleto,
		a.ie_tipo_formacao_preco,
		e.nr_seq_empresa,
		a.qt_tempo_geracao,
		a.ie_nota_titulo,
		a.nr_serie_mensalidade,
		a.ie_varios_titulos,
		a.nr_rps,
		a.cd_grupo_intercambio,
		d.ie_envia_cobranca,
		a.ds_complemento

union all

select	a.dt_referencia,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	coalesce(a.vl_pre_estabelecido,0) vl_pre_estabelecido,
	coalesce(a.vl_pro_rata_dia,0) vl_pro_rata_dia,
	coalesce(a.vl_coparticipacao,0) vl_coparticipacao,
	coalesce(a.vl_antecipacao,0) vl_antecipacao,
	a.nr_seq_pagador,
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) nm_pagador,
	a.nr_sequencia,
	a.ie_cancelamento,
	f.nr_nota_fiscal nr_nota_fiscal,
	null nr_titulo,
	null vl_titulo,
	null dt_liquidacao_titulo,
	a.dt_cancelamento,
	a.dt_vencimento,
	a.cd_banco,
	(	select	k.ds_conta
		from	banco_estabelecimento_v	k
		where	a.nr_seq_conta_banco		= k.nr_sequencia) ds_conta,
	a.nr_seq_cobranca,
	substr(a.ds_observacao,1,255) ds_observacao,
	substr(a.ds_mensagem_quitacao,1,255) ds_mensagem_quitacao,
	coalesce(a.vl_outros,0) vl_outros,
	(	select	max(h.nr_seq_cobranca)
		from	titulo_receber_cobr	h,
			cobranca_escritural	i
		where	h.nr_seq_cobranca	= i.nr_sequencia
		and	i.ie_tipo_cobranca	= 'D'
		and	h.nr_seq_mensalidade	= a.nr_sequencia) nr_desconto_folha,
	(	select	substr(ds_valor_dominio,1,254)
		from 	valor_dominio_v
		where 	cd_dominio	= 1720
		and	vl_dominio	= a.nr_seq_forma_cobranca) forma_cobranca,
	e.cd_matricula cd_matricula,
	(	select	em.ds_razao_social
		from	pessoa_juridica		em,
			pls_desc_empresa	i
		where	em.cd_cgc		= i.cd_cgc
		and	e.nr_seq_empresa	= i.nr_sequencia) ds_empresa,
	a.vl_taxa_boleto,
	(	select	j.ds_motivo
		from	pls_motivo_canc_mens	j
		where	a.nr_seq_motivo_canc	= j.nr_sequencia) ds_motivo_cancelamento,
	l.nr_sequencia nr_seq_lote,
	f.nr_sequencia nr_sequencia_nf,
	a.qt_beneficiarios nr_beneficiarios,
	a.nm_usuario_cancelamento,
	null dt_pagamento_previsto,
	CASE WHEN a.ie_tipo_formacao_preco='R' THEN 'Pré-estabelecido' WHEN a.ie_tipo_formacao_preco='P' THEN 'Pós-estabelecido' END  ie_tipo_formacao_preco,
	d.cd_pessoa_fisica,
	a.qt_tempo_geracao,
	CASE WHEN a.ie_nota_titulo='T' THEN 'Somente título'  ELSE 'Nota fiscal e título' END  ds_nota_titulo,
	a.nr_serie_mensalidade,
	a.ie_varios_titulos,
	a.nr_rps,
	a.cd_grupo_intercambio,
	f.nr_nfe_imp	nr_nfe_imp,
	null ie_situacao_titulo,
	substr(obter_valor_dominio(2817, d.ie_envia_cobranca),1,255) ds_envio_cobranca,
	substr(a.ds_complemento,1,255) ds_complemento
from	nota_fiscal			f,
	pls_contrato_pagador_fin	e,
	pls_contrato_pagador		d,
	pls_mensalidade			a,
	pls_lote_mensalidade		l
where	l.nr_sequencia			= a.nr_seq_lote
and	a.nr_seq_pagador		= d.nr_sequencia
and	f.nr_seq_mensalidade		= a.nr_sequencia
and	e.nr_seq_pagador		= d.nr_sequencia
and	a.nr_seq_pagador_fin		= e.nr_sequencia
and	a.ie_varios_titulos	= 'S'
group by	a.dt_referencia,
		a.vl_mensalidade,
		a.vl_pre_estabelecido,
		a.vl_coparticipacao,
		a.nr_seq_pagador,
		d.cd_pessoa_fisica,
		d.cd_cgc,
		a.nr_sequencia,
		a.ie_cancelamento,
		a.dt_cancelamento,
		a.dt_vencimento,
		a.cd_banco,
		a.nr_seq_conta_banco,
		a.nr_seq_cobranca,
		a.nr_seq_motivo_canc,
		a.ds_observacao,
		a.ds_mensagem_quitacao,
		a.vl_outros,
		a.nr_seq_forma_cobranca,
		l.nr_sequencia,
		f.nr_nota_fiscal,
		e.cd_matricula,
		f.nr_sequencia,
		a.qt_beneficiarios,
		a.vl_pro_rata_dia,
		a.vl_antecipacao,
		a.nm_usuario_cancelamento,
		a.nr_seq_lote,
		a.vl_taxa_boleto,
		a.ie_tipo_formacao_preco,
		e.nr_seq_empresa,
		a.qt_tempo_geracao,
		a.ie_nota_titulo,
		a.nr_serie_mensalidade,
		a.ie_varios_titulos,
		a.nr_rps,
		a.cd_grupo_intercambio,
		f.nr_nfe_imp,
		d.ie_envia_cobranca,
		a.ds_complemento

union all

select	a.dt_referencia,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	coalesce(a.vl_pre_estabelecido,0) vl_pre_estabelecido,
	coalesce(a.vl_pro_rata_dia,0) vl_pro_rata_dia,
	coalesce(a.vl_coparticipacao,0) vl_coparticipacao,
	coalesce(a.vl_antecipacao,0) vl_antecipacao,
	a.nr_seq_pagador,
	substr(pls_obter_dados_pagador(a.nr_seq_pagador,'D'),1,255) nm_pagador,
	a.nr_sequencia,
	a.ie_cancelamento,
	null nr_nota_fiscal,
	null nr_titulo,
	null vl_titulo,
	null dt_liquidacao_titulo,
	a.dt_cancelamento,
	a.dt_vencimento,
	a.cd_banco,
	(	select	k.ds_conta
		from	banco_estabelecimento_v	k
		where	a.nr_seq_conta_banco		= k.nr_sequencia) ds_conta,
	a.nr_seq_cobranca,
	substr(a.ds_observacao,1,255) ds_observacao,
	substr(a.ds_mensagem_quitacao,1,255) ds_mensagem_quitacao,
	coalesce(a.vl_outros,0) vl_outros,
	(	select	max(h.nr_seq_cobranca)
		from	titulo_receber_cobr	h,
			cobranca_escritural	i
		where	h.nr_seq_cobranca	= i.nr_sequencia
		and	i.ie_tipo_cobranca	= 'D'
		and	h.nr_seq_mensalidade	= a.nr_sequencia) nr_desconto_folha,
	(	select	substr(ds_valor_dominio,1,254)
		from 	valor_dominio_v
		where 	cd_dominio	= 1720
		and	vl_dominio	= a.nr_seq_forma_cobranca) forma_cobranca,
	e.cd_matricula cd_matricula,
	(	select	em.ds_razao_social
		from	pessoa_juridica		em,
			pls_desc_empresa	i
		where	em.cd_cgc		= i.cd_cgc
		and	e.nr_seq_empresa	= i.nr_sequencia) ds_empresa,
	a.vl_taxa_boleto,
	(	select	j.ds_motivo
		from	pls_motivo_canc_mens	j
		where	a.nr_seq_motivo_canc	= j.nr_sequencia) ds_motivo_cancelamento,
	l.nr_sequencia nr_seq_lote,
	null nr_sequencia_nf,
	a.qt_beneficiarios nr_beneficiarios,
	a.nm_usuario_cancelamento,
	null dt_pagamento_previsto,
	CASE WHEN a.ie_tipo_formacao_preco='R' THEN 'Pré-estabelecido' WHEN a.ie_tipo_formacao_preco='P' THEN 'Pós-estabelecido' END  ie_tipo_formacao_preco,
	d.cd_pessoa_fisica,
	a.qt_tempo_geracao,
	CASE WHEN a.ie_nota_titulo='T' THEN 'Somente título'  ELSE 'Nota fiscal e título' END  ds_nota_titulo,
	a.nr_serie_mensalidade,
	a.ie_varios_titulos,
	a.nr_rps,
	a.cd_grupo_intercambio,
	'' nr_nfe_imp,
	null ie_situacao_titulo,
	substr(obter_valor_dominio(2817, d.ie_envia_cobranca),1,255) ds_envio_cobranca,
	substr(a.ds_complemento,1,255) ds_complemento
from	pls_contrato_pagador_fin	e,
	pls_contrato_pagador		d,
	pls_mensalidade			a,
	pls_lote_mensalidade		l
where	l.nr_sequencia			= a.nr_seq_lote
and	a.nr_seq_pagador		= d.nr_sequencia
and	e.nr_seq_pagador		= d.nr_sequencia
and	a.nr_seq_pagador_fin		= e.nr_sequencia
and	a.ie_varios_titulos	= 'S'
and 	not exists (	select	1
				from	nota_fiscal n
				where	n.nr_seq_mensalidade		= a.nr_sequencia)
group by	a.dt_referencia,
		a.vl_mensalidade,
		a.vl_pre_estabelecido,
		a.vl_coparticipacao,
		a.nr_seq_pagador,
		d.cd_pessoa_fisica,
		d.cd_cgc,
		a.nr_sequencia,
		a.ie_cancelamento,
		a.dt_cancelamento,
		a.dt_vencimento,
		a.cd_banco,
		a.nr_seq_conta_banco,
		a.nr_seq_cobranca,
		a.nr_seq_motivo_canc,
		a.ds_observacao,
		a.ds_mensagem_quitacao,
		a.vl_outros,
		a.nr_seq_forma_cobranca,
		l.nr_sequencia,
		e.cd_matricula,
		a.qt_beneficiarios,
		a.vl_pro_rata_dia,
		a.vl_antecipacao,
		a.nm_usuario_cancelamento,
		a.nr_seq_lote,
		a.vl_taxa_boleto,
		a.ie_tipo_formacao_preco,
		e.nr_seq_empresa,
		a.qt_tempo_geracao,
		a.ie_nota_titulo,
		a.nr_serie_mensalidade,
		a.ie_varios_titulos,
		a.nr_rps,
		a.cd_grupo_intercambio,
		d.ie_envia_cobranca,
		a.ds_complemento;
