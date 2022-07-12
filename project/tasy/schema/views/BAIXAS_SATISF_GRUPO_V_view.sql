-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW baixas_satisf_grupo_v (nr_sequencia, ds_grupo, nr_seq_grupo_des, nr_seq_grupo_sup, nr_seq_gerencia, ie_grau_satisfacao, ds_dano_breve, dt_ordem_servico, ie_origem_os, dt_fim_real, ds_justificativa, ds_analise_insatisfacao, ds_grau_satisfacao_geral, ds_agilidade, ds_conhecimento, ds_cordialidade, ds_solucao, cd_opcao) AS select 	distinct a.nr_sequencia nr_sequencia,
	b.ds_grupo ds_grupo,
	b.nr_sequencia nr_seq_grupo_des,
	-1 nr_seq_grupo_sup,
	b.nr_seq_gerencia nr_seq_gerencia,
	a.ie_grau_satisfacao,
	a.ds_dano_breve,
	a.dt_ordem_servico,
	a.ie_origem_os,
	a.dt_fim_real,
	substr(man_obter_justif_satisf_ordem(a.nr_seq_justif_grau_satisf),1,255) ds_justificativa,
	substr(a.ds_analise_insatisfacao,1,200) ds_analise_insatisfacao,
	substr(obter_valor_dominio(1197, f.ie_grau_satisfacao_geral),1,200) ds_grau_satisfacao_geral,
	substr(obter_valor_dominio(1197, f.ie_agilidade),1,200) ds_agilidade,
	substr(obter_valor_dominio(1197, f.ie_conhecimento),1,200) ds_conhecimento,
	substr(obter_valor_dominio(1197, f.ie_cordialidade),1,200) ds_cordialidade,
	substr(obter_valor_dominio(1197, f.ie_solucao),1,200) ds_solucao,
	2 cd_opcao
FROM pessoa_fisica e, usuario d, grupo_desenvolvimento b, (	select 	distinct x.nr_sequencia,
			x.nr_seq_grupo_des,
			x.ie_grau_satisfacao,
			x.ds_dano_breve,
			x.dt_ordem_servico,
			x.ie_origem_os,
			x.nr_seq_justif_grau_satisf,
			x.ds_analise_insatisfacao,
			x.dt_fim_real,
			y.nm_usuario_exec
		from	man_ordem_servico x,
			man_ordem_servico_exec y
		where	x.nr_sequencia = y.nr_seq_ordem
		and exists (	select 	1
				from 	grupo_desenvolvimento
				where 	nr_seq_gerencia = x.nr_seq_gerencia_insatisf	)
		and    	x.ie_grau_satisfacao in ('R','P')
		and     	x.nr_seq_grupo_des is not null
		and	x.nr_seq_gerencia_insatisf is not null	) a
LEFT OUTER JOIN man_ordem_serv_satisf f ON (a.nr_sequencia = f.nr_seq_ordem_serv)
WHERE a.nr_seq_grupo_des = b.nr_sequencia and a.nm_usuario_exec = d.nm_usuario and d.cd_pessoa_fisica = e.cd_pessoa_fisica
union all

/*select 	distinct a.nr_sequencia nr_sequencia,
	b.ds_grupo ds_grupo,
	-1 nr_seq_grupo_des,
	b.nr_sequencia nr_seq_grupo_sup,
	b.nr_seq_gerencia_sup nr_seq_gerencia,
	a.ie_grau_satisfacao,
	a.ds_dano_breve,
	a.dt_ordem_servico,
	a.ie_origem_os,
	a.dt_fim_real,
	substr(man_obter_justif_satisf_ordem(a.nr_seq_justif_grau_satisf),1,255) ds_justificativa,
	substr(a.ds_analise_insatisfacao,1,200) ds_analise_insatisfacao,
	substr(obter_valor_dominio(1197, f.ie_grau_satisfacao_geral),1,200) ds_grau_satisfacao_geral,
	substr(obter_valor_dominio(1197, f.ie_agilidade),1,200) ds_agilidade,
	substr(obter_valor_dominio(1197, f.ie_conhecimento),1,200) ds_conhecimento,
	substr(obter_valor_dominio(1197, f.ie_cordialidade),1,200) ds_cordialidade,
	substr(obter_valor_dominio(1197, f.ie_solucao),1,200) ds_solucao,
	1 cd_opcao
from	(	select 	distinct x.nr_sequencia,
			x.nr_seq_grupo_sup,
			x.ie_grau_satisfacao,
			x.ds_dano_breve,
			x.dt_ordem_servico,
			x.ie_origem_os,
			x.nr_seq_justif_grau_satisf,
			x.ds_analise_insatisfacao,
			x.dt_fim_real,
			y.nm_usuario_exec
		from	man_ordem_servico x,
			man_ordem_servico_exec y
		where	x.nr_sequencia = y.nr_seq_ordem
		and    	x.ie_grau_satisfacao in ('R','P')
		and	x.ie_classificacao in ('D')
		and     	x.nr_seq_grupo_sup is not null
		and	x.nr_seq_gerencia_insatisf is null	) a,
	grupo_suporte b,
	usuario d,
	pessoa_fisica e,
	man_ordem_serv_satisf f
where   	a.nr_seq_grupo_sup = b.nr_sequencia
and     	a.nm_usuario_exec = d.nm_usuario
and     	d.cd_pessoa_fisica = e.cd_pessoa_fisica
and	a.nr_sequencia = f.nr_seq_ordem_serv(+)
union all*/
select 	distinct a.nr_sequencia nr_sequencia,
	b.ds_grupo ds_grupo,
	-1 nr_seq_grupo_des,
	b.nr_sequencia nr_seq_grupo_sup,
	b.nr_seq_gerencia_sup nr_seq_gerencia,
	a.ie_grau_satisfacao,
	a.ds_dano_breve,
	a.dt_ordem_servico,
	a.ie_origem_os,
	a.dt_fim_real,
	substr(man_obter_justif_satisf_ordem(a.nr_seq_justif_grau_satisf),1,255) ds_justificativa,
	substr(a.ds_analise_insatisfacao,1,200) ds_analise_insatisfacao,
	substr(obter_valor_dominio(1197, f.ie_grau_satisfacao_geral),1,200) ds_grau_satisfacao_geral,
	substr(obter_valor_dominio(1197, f.ie_agilidade),1,200) ds_agilidade,
	substr(obter_valor_dominio(1197, f.ie_conhecimento),1,200) ds_conhecimento,
	substr(obter_valor_dominio(1197, f.ie_cordialidade),1,200) ds_cordialidade,
	substr(obter_valor_dominio(1197, f.ie_solucao),1,200) ds_solucao,
	2 cd_opcao
FROM pessoa_fisica e, usuario d, grupo_suporte b, (	select 	distinct x.nr_sequencia,
			x.nr_seq_grupo_sup,
			x.ie_grau_satisfacao,
			x.ds_dano_breve,
			x.dt_ordem_servico,
			x.ie_origem_os,
			x.nr_seq_justif_grau_satisf,
			x.ds_analise_insatisfacao,
			x.dt_fim_real,
			y.nm_usuario_exec
		from	man_ordem_servico x,
			man_ordem_servico_exec y
		where	x.nr_sequencia = y.nr_seq_ordem
		and exists (	select 	1
				from 	grupo_suporte
				where 	nr_seq_gerencia_sup = x.nr_seq_gerencia_insatisf	)
		and    	x.ie_grau_satisfacao in ('R','P')
		and    	x.nr_seq_grupo_sup is not null
		and	x.nr_seq_gerencia_insatisf is not null	) a
LEFT OUTER JOIN man_ordem_serv_satisf f ON (a.nr_sequencia = f.nr_seq_ordem_serv)
WHERE a.nr_seq_grupo_sup = b.nr_sequencia and a.nm_usuario_exec = d.nm_usuario and d.cd_pessoa_fisica = e.cd_pessoa_fisica  order by ds_grupo;

