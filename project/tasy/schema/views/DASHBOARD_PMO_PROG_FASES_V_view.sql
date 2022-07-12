-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dashboard_pmo_prog_fases_v (nr_sequencia, ds_programa, area, nr_seq_area_fase, ds_fase, dt_inicio_prev, dt_inicio_real, dt_fim_prev, dt_fim_real, qt_hora_prev, qt_hora_real, pr_prev, pr_real) AS select   pr.nr_sequencia,
         pr.ds_programa,
         obter_valor_dominio(5551, a.ie_area_gerencia) area,
         e.nr_seq_area_fase,
         f.ds_fase,
         min(e.dt_inicio_prev) dt_inicio_prev,
         min(e.dt_inicio_real) dt_inicio_real,
         max(e.dt_fim_prev) dt_fim_prev,
         obter_dt_fim_real_fase_prog( pr.nr_sequencia, e.nr_seq_area_fase ) dt_fim_real,
         sum(e.qt_hora_prev) qt_hora_prev,
         sum(e.qt_hora_real) qt_hora_real,
         obter_pr_prev_crono(min(e.dt_inicio_real),max(e.dt_fim_prev)) pr_prev,
         obter_pr_real_prog_fase(pr.nr_sequencia, e.nr_seq_area_fase) pr_real
FROM     proj_programa pr,
         proj_projeto p,
         proj_cronograma c,
         proj_cron_etapa e,
         proj_area_gerencia_fase a,
         proj_fase f
where    pr.nr_sequencia = p.nr_seq_programa
and      p.nr_sequencia  = c.nr_seq_proj
and      c.nr_sequencia  = e.nr_seq_cronograma
and      a.nr_sequencia  = e.nr_seq_area_fase
and      f.nr_sequencia  = a.nr_seq_fase
and      c.ie_situacao   = 'A'
and      e.ie_fase       = 'N'
group by pr.nr_sequencia,
         pr.ds_programa,
         obter_valor_dominio(5551, a.ie_area_gerencia),
         e.nr_seq_area_fase,
         f.ds_fase
order by dt_inicio_prev;

