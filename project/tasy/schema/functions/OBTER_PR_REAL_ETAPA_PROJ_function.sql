-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_real_etapa_proj ( nr_seq_proj_p bigint,dt_inicio_prev_p timestamp ) RETURNS bigint AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter percentual real de execução de uma etapa do projeto
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
pr_retorno_w double precision;
pr_realizacao_w	double precision;

BEGIN


select  max(p.pr_realizacao)
into STRICT 	pr_realizacao_w
from    proj_projeto p,
		proj_cronograma c,
		proj_cron_etapa e
where	p.nr_sequencia = c.nr_seq_proj
and     c.nr_sequencia = e.nr_seq_cronograma
and     c.ie_situacao  = 'A'
and 	p.nr_sequencia = nr_seq_proj_p
and  	not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia);

if (coalesce(pr_realizacao_w,0) < 100
	and dt_inicio_prev_p > trunc(clock_timestamp()))then
	goto final;
end if;

	select	max(pr_real)
	into STRICT	pr_retorno_w
	from	dashboard_pmo_proj_graf
	where 	nr_seq_proj = nr_seq_proj_p
	and	trunc(dt_referencia) = trunc(dt_inicio_prev_p);


	/*if 	(pr_retorno_w is null) then
		select 	max(qt_hr_residuais)
		into	pr_retorno_w
		from	W_GRAFICO_PROJ
		where 	nr_seq_proj = nr_seq_proj_p;
	end if;*/
	if (coalesce(pr_retorno_w::text, '') = '') then
		pr_retorno_w := 0;
	end if;


  <<final>>
  return  pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_real_etapa_proj ( nr_seq_proj_p bigint,dt_inicio_prev_p timestamp ) FROM PUBLIC;

