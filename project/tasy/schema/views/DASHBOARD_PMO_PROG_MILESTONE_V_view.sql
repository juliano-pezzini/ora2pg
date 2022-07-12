-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dashboard_pmo_prog_milestone_v (nr_sequencia, ds_programa, qt_milestone_prev, qt_milestone_real, ie_status_milestone, qt_total_milestone) AS select x.NR_SEQUENCIA,x.DS_PROGRAMA,x.QT_MILESTONE_PREV,x.QT_MILESTONE_REAL,x.IE_STATUS_MILESTONE,x.QT_TOTAL_MILESTONE
FROM   ( select t.nr_sequencia,
                t.ds_programa,
				/*Total de milestone previsto para estar concluído até a data de hoje*/

                ( select   count(e.nr_sequencia) qt_milestone_prev
                  from     proj_programa pr,
                           proj_projeto p,
                           proj_cronograma c,
                           proj_cron_etapa e
                  where    pr.nr_sequencia = p.nr_seq_programa
                  and      p.nr_sequencia  = c.nr_seq_proj
                  and      c.nr_sequencia  = e.nr_seq_cronograma
                  and      c.ie_situacao   = 'A'
                  and      e.ie_milestone  = 'S'
				  and	   trunc(e.dt_fim_prev)	<= trunc(LOCALTIMESTAMP)
                  and      pr.nr_sequencia =  t.nr_sequencia
                ) qt_milestone_prev,
				/*Total de milestone concluídos/realizados*/

                ( select   count(e.nr_sequencia) qt_milestone_real
                  from     proj_programa pr,
                           proj_projeto p,
                           proj_cronograma c,
                           proj_cron_etapa e
                  where    pr.nr_sequencia = p.nr_seq_programa
                  and      p.nr_sequencia  = c.nr_seq_proj
                  and      c.nr_sequencia  = e.nr_seq_cronograma
                  and      c.ie_situacao   = 'A'
                  and      e.ie_milestone  = 'S'
                  and      pr.nr_sequencia =  t.nr_sequencia
                  and      e.dt_fim_real is not null
                 ) qt_milestone_real,
                obter_status_mlt_dashboard_pmo('PR', t.nr_sequencia) ie_status_milestone,
				/*Total de milestone do projeto*/

				( select   count(e.nr_sequencia) qt_total_milestone
                  from     proj_programa pr,
                           proj_projeto p,
                           proj_cronograma c,
                           proj_cron_etapa e
                  where    pr.nr_sequencia = p.nr_seq_programa
                  and      p.nr_sequencia  = c.nr_seq_proj
                  and      c.nr_sequencia  = e.nr_seq_cronograma
                  and      c.ie_situacao   = 'A'
                  and      e.ie_milestone = 'S'
                  and      pr.nr_sequencia =  t.nr_sequencia
                ) qt_total_milestone
        from   proj_programa t
       ) x
where  x.qt_total_milestone > 0;
