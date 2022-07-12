-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_imp_v (nr_sequencia, cd_profissional_exec_conv, nr_seq_segurado_conv, nr_cons_prof_exec_conv, cd_cid_principal, cd_cat_cid_principal, nr_seq_cbo_saude, cd_guia_referencia, nr_seq_guia, cd_tiss_atendimento, dt_atendimento, nr_seq_prest_solic_conv, nr_seq_prestador_req, dt_inicio_faturamento, dt_fim_faturamento, dt_inicio_faturamento_trunc, dt_fim_faturamento_trunc, dt_atendimento_conv, dt_atendimento_conv_trunc, ie_tipo_guia, nr_seq_prest_exec_conv, nr_seq_prestador_prot, nr_seq_plano, ie_carater_atendimento_conv, nr_seq_tipo_prest_prot, nr_seq_tipo_prest_exec, nr_seq_tipo_atend_conv, cd_estabelecimento, cd_prestador_exec, ie_regime_atendimento) AS select	/* Campos da tabela */

	a.nr_sequencia,
	a.cd_profissional_exec_conv,
	a.nr_seq_segurado_conv,
	a.nr_cons_prof_exec_conv,
	(select	max(g.cd_doenca)
	FROM	pls_diagnostico_conta g
	where	g.nr_seq_conta		= a.nr_sequencia
	and	g.ie_classificacao	= 'P') cd_cid_principal,
	-- Categoria do CID principal

	(select	max(h.cd_categoria_cid)
	from	pls_diagnostico_conta	g,
		cid_doenca		h
	where	g.nr_seq_conta 		= a.nr_sequencia
	and	g.ie_classificacao 	= 'P'
	and	h.cd_doenca_cid		= g.cd_doenca) cd_cat_cid_principal,
	a.nr_seq_cbo_prof_exec_conv nr_seq_cbo_saude,
	a.cd_guia_ok_conv cd_guia_referencia,
	nr_seq_guia_conv nr_seq_guia,
	-- Obter o tipo de atendimento no TISS para esta conta (Regra De: Para:)

	(select	max(z.cd_tiss)
	from	pls_tipo_atendimento z
	where	z.nr_sequencia = a.nr_seq_tipo_atend_conv) cd_tiss_atendimento,
	a.dt_atendimento,
	a.nr_seq_prest_solic_conv,
	(select	max(req.nr_seq_prestador)
	from	pls_execucao_requisicao req
	where	req.nr_seq_guia = a.nr_seq_guia_conv
	and	req.ie_situacao = '1') nr_seq_prestador_req,
	dt_inicio_faturamento,
	dt_fim_faturamento,
	trunc(dt_inicio_faturamento,'dd') dt_inicio_faturamento_trunc,
	trunc(dt_fim_faturamento,'dd') dt_fim_faturamento_trunc,
	a.dt_atendimento_conv,
	trunc(a.dt_atendimento_conv,'dd') dt_atendimento_conv_trunc,
	b.ie_tipo_guia,
	a.nr_seq_prest_exec_conv,
	b.nr_seq_prestador_conv nr_seq_prestador_prot,
	(	select 	max(nr_seq_plano)
		from	pls_segurado s
		where	s.nr_sequencia = a.nr_seq_segurado_conv) nr_seq_plano,
	a.ie_carater_atendimento_conv,
	(	select	x.nr_seq_tipo_prestador
		from	pls_prestador x
		where	x.nr_sequencia	= b.nr_seq_prestador_conv) nr_seq_tipo_prest_prot,
	(	select	x.nr_seq_tipo_prestador
		from	pls_prestador x
		where	x.nr_sequencia	= a.nr_seq_prest_exec_conv) nr_seq_tipo_prest_exec,
	a.nr_seq_tipo_atend_conv,
	a.cd_estabelecimento,
	(	select	x.cd_prestador
		from	pls_prestador x
		where	x.nr_sequencia	= a.nr_seq_prest_exec_conv) cd_prestador_exec,
	a.ie_regime_atendimento
from	pls_conta_imp		a,
	pls_protocolo_conta_imp	b
where	b.nr_sequencia = a.nr_seq_protocolo;
