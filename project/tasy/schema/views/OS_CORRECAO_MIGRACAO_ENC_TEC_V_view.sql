-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW os_correcao_migracao_enc_tec_v (nr_seq_projeto, nr_seq_os, nr_seq_os_teste, ds_dano_breve, ds_estagio, nm_executor, dt_os, nr_seq_grupo_desenv_proj, nr_seq_grupo_desenv_os, nr_seq_estagio_os) AS select	p.nr_sequencia nr_seq_projeto,
	o.nr_sequencia nr_seq_os,
	o.nr_seq_origem nr_seq_os_teste,
	o.ds_dano_breve,
	s.ds_estagio,
	e.nm_usuario_exec nm_executor,
	o.dt_ordem_servico dt_os,
	p.nr_seq_grupo_des nr_seq_grupo_desenv_proj,
	o.nr_seq_grupo_des nr_seq_grupo_desenv_os,
	o.nr_seq_estagio nr_seq_estagio_os
FROM	man_estagio_processo s,
	man_ordem_servico_exec e,
	proj_ordem_servico r,
	proj_projeto p,
	man_ordem_servico o
where	s.nr_sequencia = o.nr_seq_estagio
and	e.nr_seq_ordem = o.nr_sequencia
and	r.nr_seq_proj = p.nr_sequencia
and	r.nr_seq_ordem = o.nr_sequencia
and	r.ie_tipo_ordem = 'CET'
and	p.nr_seq_gerencia = 9
and	p.nr_seq_classif = 14;

