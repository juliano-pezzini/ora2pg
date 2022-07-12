-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW os_insatisfacao_gerencia_v (nr_sequencia, dt_fim_real, nr_seq_gerencia, nr_seq_grupo, ds_dano_breve, ie_origem_os, nr_seq_localizacao, cd_funcao, nr_seq_gerencia_insatisf, ie_area_gerencia, ie_terceiro, dt_encerramento_ordem) AS select	a.nr_sequencia,
	a.dt_fim_real,
	coalesce(a.nr_seq_gerencia_insatisf,b.nr_seq_gerencia) nr_seq_gerencia,
	b.nr_sequencia nr_seq_grupo,
	a.ds_dano_breve,
	a.ie_origem_os,
	a.nr_seq_localizacao,
	a.cd_funcao,
	a.nr_seq_gerencia_insatisf,
	(select max(ie_area_gerencia) FROM gerencia_wheb c where c.nr_sequencia  =  coalesce(a.nr_seq_gerencia_insatisf,b.nr_seq_gerencia)) ie_area_gerencia,
	m.ie_terceiro,
	man_obter_dt_os_encerrada(a.nr_sequencia) dt_encerramento_ordem
from	man_grau_satisf_justif j,
	grupo_desenvolvimento b,
	man_localizacao m,
	man_ordem_servico a	
where	a.nr_seq_grupo_des = b.nr_sequencia
and	m.nr_sequencia	= a.nr_seq_localizacao
and	b.ie_situacao = 'A'
and	a.ie_status_ordem = 3
and	a.nr_seq_justif_grau_satisf = j.nr_sequencia
and	a.nr_seq_justif_grau_satisf is not null
and	coalesce(j.ie_indicador,'S') = 'S'
and	a.ie_grau_satisfacao in ('P','R')
and	exists (select 1
		from 	man_estagio_processo d,
			man_ordem_serv_estagio e
		where	e.nr_seq_ordem = a.nr_sequencia
		and	d.nr_sequencia = e.nr_seq_estagio
		and (d.ie_desenv = 'S' or (d.ie_tecnologia = 'S') or (d.ie_infra = 'S')));
