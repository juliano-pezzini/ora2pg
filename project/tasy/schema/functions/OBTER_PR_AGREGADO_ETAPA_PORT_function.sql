-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_agregado_etapa_port ( nr_seq_port_p bigint,dt_inicio_prev_p timestamp ) RETURNS bigint AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter percentual agregado (pr real X hora prevista) execução de uma etapa do projeto
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
hr_retorno_w double precision;
hr_prev_w double precision;
pr_realizacao_w	double precision;
pr_prev_w double precision;
pr_real_w double precision;
dt_referencia_w		timestamp;


BEGIN


select  max(p.pr_realizacao)
into STRICT 	pr_realizacao_w
from    proj_portifolio pf,
	proj_programa pr,
	proj_projeto p,
	proj_cronograma c,
	proj_cron_etapa e
where	pf.nr_sequencia = pr.nr_seq_portifolio
and	pr.nr_sequencia = p.nr_seq_programa
and	p.nr_sequencia = c.nr_seq_proj
and     c.nr_sequencia = e.nr_seq_cronograma
and     c.ie_situacao  = 'A'
and 	pf.nr_sequencia = nr_seq_port_p
and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
and  	not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia and xx.nr_seq_cronograma = e.nr_seq_cronograma);

dt_referencia_w	:= dt_inicio_prev_p;

if (coalesce(pr_realizacao_w,0) < 100
	and dt_inicio_prev_p > trunc(clock_timestamp()))then
	dt_referencia_w	:= trunc(clock_timestamp());
end if;

	select	max(QT_HORA_prev),
		max(pr_real),
		max(pr_prev)
	into STRICT	hr_prev_w,
		pr_real_w,
		pr_prev_w
	from	dashboard_pmo_port_graf
	where 	nr_seq_port = nr_seq_port_p
	and	trunc(dt_referencia) = trunc(dt_referencia_w);

	hr_retorno_w	:= (hr_prev_w * pr_real_w) / 100;


	if (coalesce(hr_retorno_w::text, '') = '') then
		hr_retorno_w := 0;
	end if;


  <<final>>
  return  hr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_agregado_etapa_port ( nr_seq_port_p bigint,dt_inicio_prev_p timestamp ) FROM PUBLIC;

