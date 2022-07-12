-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pmo_timeline_html_v (dt_referencia, qt_linha, init_date, end_date, nr_sequencia, ds_titulo, pr_prev, code_group) AS select	b.dt_referencia,
	4 qt_linha,
	obter_maior_data(a.dt_inicio_prev, a.dt_inicio_real) INIT_DATE,
	obter_maior_data(a.dt_fim_prev, a.dt_fim_real) end_date,
	a.nr_sequencia,
	a.ds_titulo,
	b.pr_prev,
	c.code_group
FROM	dashboard_pmo_proj_resumo_v a,
	dashboard_pmo_proj_graf b,
	grafico_projeto_pmo_html_v c
where	a.nr_sequencia = b.nr_seq_proj
and	c.code_chart = a.nr_sequencia
and	code_group = 'P'

union

select	b.dt_referencia,
	4 qt_linha,
	obter_maior_data(a.dt_inicio_prev, a.dt_inicio_real) INIT_DATE,
	obter_maior_data(a.dt_fim_prev, a.dt_fim_real) end_date,
	a.nr_sequencia,
	a.ds_titulo,
	b.pr_real,
	c.code_group
from	dashboard_pmo_proj_resumo_v a,
	dashboard_pmo_proj_graf b,
	grafico_projeto_pmo_html_v c
where	a.nr_sequencia = b.nr_seq_proj
and	c.code_chart = a.nr_sequencia
and	code_group = 'R'

union

/*  Projeto  Horas previsto/realizado*/

select	b.dt_referencia,
	4 qt_linha,
	obter_maior_data(a.dt_inicio_prev, a.dt_inicio_real) INIT_DATE,
	obter_maior_data(a.dt_fim_prev, a.dt_fim_real) end_date,
	a.nr_sequencia,
	a.ds_titulo,
	b.qt_hora_prev,
	c.code_group
from	dashboard_pmo_proj_resumo_v a,
	dashboard_pmo_proj_graf b,
	grafico_projeto_pmo_html_v c
where	a.nr_sequencia = b.nr_seq_proj
and	c.code_chart = a.nr_sequencia
and	code_group = 'PH'

union

select	b.dt_referencia,
	4 qt_linha,
	obter_maior_data(a.dt_inicio_prev, a.dt_inicio_real) INIT_DATE,
	obter_maior_data(a.dt_fim_prev, a.dt_fim_real) end_date,
	a.nr_sequencia,
	a.ds_titulo,
	b.qt_hora_real,
	c.code_group
from	dashboard_pmo_proj_resumo_v a,
	dashboard_pmo_proj_graf b,
	grafico_projeto_pmo_html_v c
where	a.nr_sequencia = b.nr_seq_proj
and	c.code_chart = a.nr_sequencia
and	code_group = 'RH';

