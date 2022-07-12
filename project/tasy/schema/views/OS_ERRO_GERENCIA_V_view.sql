-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW os_erro_gerencia_v (nr_sequencia, dt_ordem_servico, nr_seq_gerencia, cd_pessoa_fisica, nr_seq_grupo, ds_dano_breve, ie_forma_origem, ie_origem_erro, ie_ident_erro, ie_gravidade, nr_seq_tipo, ds_grupo, dt_liberacao, qt_cliente, ie_classificacao, nr_seq_erro, ds_acao_imediata, ds_solucao, ds_gerencia, nr_seq_ordem_origem, nr_seq_localizacao, cd_funcao, nr_seq_severidade_wheb, nr_seq_grupo_des, nr_seq_severidade, nr_seq_equipamento, cd_pessoa_resp, ie_origem_os, nm_usuario_liberou_erro, nr_seq_lp, dt_ocorrencia_erro, ie_prioridade_cliente, ie_grau_satisfacao, ie_base_cliente, ie_libera_correcao, nr_seq_grupo_des_erro, nr_seq_subtipo, nr_seq_func_item, cd_versao_alteracao, cd_versao_ident, ie_plataforma, nr_seq_proj_def) AS select	b.nr_sequencia,
	b.dt_ordem_servico,
	d.nr_seq_gerencia,
	a.cd_pessoa_fisica,
	d.nr_sequencia nr_seq_grupo,
	b.ds_dano_breve,
	a.ie_forma_origem,
	a.ie_origem_erro,
	a.ie_ident_erro,
	a.ie_gravidade,
	a.nr_seq_tipo,
	d.ds_grupo,
	a.dt_liberacao,
	a.qt_cliente,
	b.ie_classificacao,
	a.nr_sequencia nr_seq_erro,
	a.ds_acao_imediata ds_acao_imediata,
	a.ds_solucao ds_solucao,
	c.ds_gerencia ds_gerencia,
	a.nr_seq_ordem_origem,
	b.nr_seq_localizacao,
	b.cd_funcao,
	b.nr_seq_severidade_wheb,
	b.nr_seq_grupo_des,
	nr_seq_severidade,
	b.nr_seq_equipamento,
	a.cd_pessoa_resp,
	b.ie_origem_os,
	a.nm_usuario_liberou_erro,
	a.nr_seq_lp,
	a.dt_ocorrencia_erro,
	b.ie_prioridade_cliente,
	b.ie_grau_satisfacao,
	a.ie_base_cliente,
	a.ie_libera_correcao,
	a.nr_seq_grupo_des nr_seq_grupo_des_erro,
	a.nr_seq_subtipo,
	b.nr_seq_func_item,
	a.cd_versao_alteracao,
	a.cd_versao_ident,
	CASE WHEN a.nr_seq_lp=1 THEN 'D' WHEN a.nr_seq_lp=2 THEN 'S' WHEN a.nr_seq_lp=5 THEN 'H'  ELSE coalesce(b.ie_plataforma,'D') END  ie_plataforma,
	a.nr_seq_proj_def
FROM	grupo_desenvolvimento	d,
	man_ordem_servico 	b,
	man_doc_erro		a,
	gerencia_wheb		c
where	a.nr_seq_ordem		= b.nr_sequencia
and	a.nr_seq_grupo_des	= d.nr_sequencia
and	d.nr_seq_gerencia	= c.nr_sequencia
and	coalesce(a.ie_origem_erro,'KK') = 'W'
and	d.nr_seq_gerencia	!= 25
and	a.nr_seq_ordem_origem is null
and ( coalesce(a.ie_recorrente,'N') = 'N' or b.dt_ordem_servico < to_date('01/05/2011','dd/mm/yyyy'))
and	exists ( select 1
		from	man_estagio_processo c,
				man_ordem_serv_estagio d
		where	c.nr_sequencia 	= d.nr_seq_estagio
		and	d.nr_seq_ordem 		= b.nr_sequencia
		and (c.ie_suporte 		= 'S' or c.ie_desenv = 'S'));
