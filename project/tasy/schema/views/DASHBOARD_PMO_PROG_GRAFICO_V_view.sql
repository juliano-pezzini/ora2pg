-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dashboard_pmo_prog_grafico_v (nr_seq_prog, dt_inicio_prev, dt_inicio_real, dt_fim_prev, dt_fim_real, pr_prev, pr_real) AS select  pr.nr_sequencia nr_seq_prog,
		e.dt_inicio_prev dt_inicio_prev,
		 e.dt_inicio_real dt_inicio_real,
		 e.dt_fim_prev dt_fim_prev,
		 c.dt_fim_real dt_fim_real,
		 obter_pr_prev_etapa_prog(pr.nr_sequencia ,e.dt_fim_prev) pr_prev,
		 obter_pr_real_etapa_prog(pr.nr_sequencia, e.dt_fim_prev) pr_real
FROM     proj_programa pr,
		 proj_projeto p,
		 proj_cronograma c,
		 proj_cron_etapa e
where    pr.nr_sequencia = p.nr_seq_programa
and 	 p.nr_sequencia = c.nr_seq_proj
and      c.nr_sequencia = e.nr_seq_cronograma
and      c.ie_situacao  = 'A'
and      e.ie_fase = 'N'
and  	 not exists (select 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia)
group by e.dt_inicio_prev,
		 e.dt_inicio_real,
		 e.dt_fim_prev,
		 c.dt_fim_real,
		 pr.nr_sequencia
order by dt_inicio_prev;

