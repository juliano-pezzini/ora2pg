-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW os_teste_anal_migr_proj_migr_v (nr_seq_projeto, nr_seq_os, nm_executor, dt_os, nr_seq_grupo_desenv) AS select	p.nr_sequencia nr_seq_projeto,
	o.nr_sequencia nr_seq_os,
	e.nm_usuario_exec nm_executor,
	o.dt_ordem_servico dt_os,
	p.nr_seq_grupo_des nr_seq_grupo_desenv
FROM	man_ordem_servico_exec e,
	proj_projeto p,
	man_ordem_servico o
where	e.nr_seq_ordem = o.nr_sequencia
and	p.nr_seq_ordem_serv = o.nr_sequencia
and	p.nr_seq_gerencia = 9
and	p.nr_seq_classif = 14
and	p.nr_seq_estagio = 13
and	o.nr_seq_estagio = 1141
and	o.ie_status_ordem in ('1','2');

