-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_r_and_d_dashboard_kpi_v (management_id, management_group, pr_defect, pr_antigas, pr_satisfaction, qt_closed, qt_backlog, dt_referencia) AS select	nr_seq_gerencia management_id,
	substr(obter_desc_expressao(cd_exp_grupo, ds_grupo), 1, 255) management_group,
	obter_informacao_os_grupo(to_char(trunc(LOCALTIMESTAMP), 'dd/mm/rrrr'), nr_sequencia, 'PREX', null) pr_defect,
	obter_informacao_os_grupo(trunc(LOCALTIMESTAMP), nr_sequencia, 'PRANTIGA', null) pr_antigas,
	100 - obter_informacao_os_grupo(trunc(LOCALTIMESTAMP), nr_sequencia, 'PRY', null) pr_satisfaction,
	dividir(obter_informacao_os_grupo(trunc(LOCALTIMESTAMP), nr_sequencia, 'EN', null),
		(((	select	count(distinct(b.nm_usuario_grupo))
			FROM	usuario_grupo_des b,
				grupo_desenvolvimento g
			where	g.nr_sequencia = b.nr_seq_grupo
			and	g.ie_situacao = 'A'
			and	b.ie_funcao_usuario <> 'E' -- Estagiário
			and	g.nr_sequencia = a.nr_sequencia
		) - obter_informacao_os_grupo(trunc(LOCALTIMESTAMP), nr_sequencia, 'QAUSEN', null)))) qt_closed,
	obter_informacao_os_grupo(trunc(LOCALTIMESTAMP), nr_sequencia, 'QTBACKLOG', null) qt_backlog,
	to_char(trunc(LOCALTIMESTAMP), 'dd/mm/rrrr') dt_referencia
from	grupo_desenvolvimento a
where	a.ie_situacao = 'A'
and	coalesce(a.ie_gerencia, 'N') = 'N'
and	exists (	select	1
			from	usuario_grupo_des b
			where	a.nr_sequencia = b.nr_seq_grupo
		)

union

select	nr_seq_gerencia management_id,
	substr(obter_desc_expressao(cd_exp_grupo, ds_grupo), 1, 255) management_group,
	obter_informacao_os_gerencia(to_char(trunc(LOCALTIMESTAMP), 'dd/mm/rrrr'), a.nr_seq_gerencia, 'PREX', null) pr_defect,
	obter_informacao_os_gerencia(trunc(LOCALTIMESTAMP), a.nr_seq_gerencia, 'PRANTIGA', null) pr_antigas,
	100 - obter_informacao_os_gerencia(trunc(LOCALTIMESTAMP), a.nr_seq_gerencia, 'PRY', null) pr_satisfaction,
	dividir(obter_informacao_os_gerencia(trunc(LOCALTIMESTAMP), a.nr_seq_gerencia, 'EN', null),
		(((	select	count(distinct(b.nm_usuario_grupo))
			from	usuario_grupo_des b,
				grupo_desenvolvimento gru,
				gerencia_wheb ger
			where	gru.nr_sequencia = b.nr_seq_grupo
			and	gru.nr_seq_gerencia = ger.nr_sequencia
			and	gru.ie_situacao = 'A'
			and	b.ie_funcao_usuario <> 'E' -- Estagiário
			and	ger.nr_sequencia = a.nr_seq_gerencia
		) - obter_informacao_os_gerencia(trunc(LOCALTIMESTAMP), a.nr_seq_gerencia, 'QAUSEN', null)))) qt_closed,
	obter_informacao_os_gerencia(trunc(LOCALTIMESTAMP), a.nr_seq_gerencia, 'QTBACKLOG', null) qt_backlog,
	to_char(trunc(LOCALTIMESTAMP), 'dd/mm/rrrr') dt_referencia
from	grupo_desenvolvimento a
where	a.ie_situacao = 'A'
and	coalesce(a.ie_gerencia, 'N') = 'S'
and	exists (	select	1
			from	usuario_grupo_des b
			where	a.nr_sequencia = b.nr_seq_grupo
		);
