-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_prev_etapa_port ( nr_seq_port_p bigint,dt_ref_p timestamp ) RETURNS bigint AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter percentual previsto de execução de uma etapa do portifolio
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
pr_retorno_w	double precision := 0;
hrs_prev_w		double precision;
dias_uteis_w	double precision;
dias_uteis_data_atual_w	double precision;
hrs_executadas_prev_w	double precision;
total_hrs_prev_w	    double precision := 0;
total_hrs_exec_prev_w   double precision := 0;

C01 CURSOR FOR
SELECT  e.qt_hora_prev hrs_previstas,
	OBTER_DIAS_SEMANA_PERIODO(e.dt_inicio_prev, e.dt_fim_prev) dias_uteis,
        OBTER_DIAS_SEMANA_PERIODO(e.dt_inicio_prev, trunc(dt_ref_p)) dias_uteis_data_atual
from    proj_portifolio pf,
	proj_programa pr,
	proj_projeto p,
	proj_cronograma c,
	proj_cron_etapa e
where  	pf.nr_sequencia = pr.nr_seq_portifolio
and	pr.nr_sequencia =  p.nr_seq_programa
and	p.nr_sequencia = c.nr_seq_proj
and     c.nr_sequencia = e.nr_seq_cronograma
and     c.ie_situacao  = 'A'
and 	pf.nr_sequencia = nr_seq_port_p
and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
and	e.dt_inicio_prev >= dt_ref_p
and  	not exists (select 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia and xx.nr_seq_cronograma = e.nr_seq_cronograma)
order by c.ie_tipo_cronograma, e.dt_inicio_prev;


BEGIN


select  coalesce(sum(e.qt_hora_prev),0)
into STRICT	total_hrs_exec_prev_w
from    proj_portifolio pf,
	proj_programa pr,
	proj_projeto p,
	proj_cronograma c,
	proj_cron_etapa e
where  	pf.nr_sequencia = pr.nr_seq_portifolio
and	pr.nr_sequencia =  p.nr_seq_programa
and	p.nr_sequencia = c.nr_seq_proj
and     c.nr_sequencia = e.nr_seq_cronograma
and     c.ie_situacao  = 'A'
and 	pf.nr_sequencia = nr_seq_port_p
and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
and	e.dt_inicio_prev < dt_ref_p
and  	not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia and xx.nr_seq_cronograma = e.nr_seq_cronograma);

total_hrs_prev_w	:= total_hrs_exec_prev_w;

open C01;
loop
fetch C01 into
	hrs_prev_w,
	dias_uteis_w,
	dias_uteis_data_atual_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

		if (dias_uteis_data_atual_w >= dias_uteis_w) then
			hrs_executadas_prev_w := hrs_prev_w;
		else
			hrs_executadas_prev_w := ((dias_uteis_data_atual_w / dias_uteis_w) * hrs_prev_w);
		end if;

		total_hrs_exec_prev_w 	:= total_hrs_exec_prev_w + hrs_executadas_prev_w;
		total_hrs_prev_w 	:= total_hrs_prev_w + hrs_prev_w;

	end;
end loop;
close C01;



	if (total_hrs_exec_prev_w = 0 and total_hrs_prev_w = 0)then
		pr_retorno_w := 0;
	else
		pr_retorno_w := ((total_hrs_exec_prev_w / total_hrs_prev_w) * 100);
	end if;


return  pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_prev_etapa_port ( nr_seq_port_p bigint,dt_ref_p timestamp ) FROM PUBLIC;

