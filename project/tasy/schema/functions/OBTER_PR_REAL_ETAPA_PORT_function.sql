-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_real_etapa_port ( nr_seq_port_p bigint,dt_fim_prev_p timestamp ) RETURNS bigint AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter percentual real de execução de uma portifolio
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
pr_retorno_w double precision := 0;
qt_total_hr_prev_w double precision := 0;


BEGIN

	select 	sum(pe.qt_hora_prev) qt_hora_prev
	into STRICT 	qt_total_hr_prev_w
	from	proj_portifolio pf,
			proj_programa pr,
			proj_projeto p,
			proj_cronograma pc,
			proj_cron_etapa pe
	where  	pf.nr_sequencia = pr.nr_seq_portifolio
	and 	pr.nr_sequencia =  p.nr_seq_programa
	and 	p.nr_sequencia = pc.nr_seq_proj
	and 	pc.nr_sequencia = pe.nr_seq_cronograma
	and    	pf.nr_sequencia = nr_seq_port_p
	and    	pc.ie_situacao  = 'A'
	and 	pe.ie_fase      = 'N'
	and    	not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  pe.nr_sequencia);

  select ( select dividir(t.per_exec * 100,qt_total_hr_prev_w) pr_realizado
           from (  SELECT sum(dividir(pe.qt_hora_prev * pe.pr_etapa,100)) per_exec
							from	proj_portifolio pf,
									proj_programa pr,
									proj_projeto p,
									proj_cronograma pc,
									proj_cron_etapa pe
							where  	pf.nr_sequencia = pr.nr_seq_portifolio
							and 	pr.nr_sequencia =  p.nr_seq_programa
							and 	p.nr_sequencia = pc.nr_seq_proj
							and 	pc.nr_sequencia = pe.nr_seq_cronograma
							and    	pf.nr_sequencia = nr_seq_port_p
							and    	pc.ie_situacao  = 'A'
							and 	pe.ie_fase      = 'N'
							and    	trunc(pe.dt_fim_prev) <= trunc(dt_fim_prev_p)
							and    	not exists (select 1 from proj_cron_etapa xx where xx.nr_seq_superior =  pe.nr_sequencia)
				  ) t
         ) pr_real
  into STRICT   pr_retorno_w
;

  return  pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_real_etapa_port ( nr_seq_port_p bigint,dt_fim_prev_p timestamp ) FROM PUBLIC;
