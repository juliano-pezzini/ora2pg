-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_etapa_npi (nr_seq_etapa_processo_p bigint) RETURNS bigint AS $body$
DECLARE


retorno_w	bigint;
dt_fim_prev_w	timestamp;
ie_execucao_w	varchar(1);
pr_etapa_w      bigint;


BEGIN

select	coalesce(max((coalesce(p.ie_status_etapa,'2'))::numeric ),'2'),
	max(trunc(p.dt_fim_prev)),
	max(p.pr_etapa)
into STRICT	retorno_w,
	dt_fim_prev_w,
	pr_etapa_w
from	proj_cron_etapa p,
	prp_processo_etapa c
where	c.nr_sequencia = p.nr_seq_processo_etapa
and	c.nr_sequencia = nr_Seq_etapa_processo_p;


select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
into STRICT	ie_execucao_w
from	proj_cron_etapa p,
	prp_processo_etapa c,
	man_ordem_servico o,
	man_ordem_serv_ativ a
where	c.nr_sequencia = p.nr_seq_processo_etapa
and	p.nr_sequencia = o.nr_seq_proj_cron_etapa
and	o.nr_sequencia = a.nr_seq_ordem_serv
and	c.nr_sequencia = nr_Seq_etapa_processo_p;

if (pr_etapa_w = 100) then
     retorno_w := 4;
end if;

if (retorno_w in (2,3) and dt_fim_prev_w < trunc(clock_timestamp())) then
    retorno_w := 5;
elsif (retorno_w in (2,3) and ie_execucao_w = 'S') then
       retorno_w := 3;
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_etapa_npi (nr_seq_etapa_processo_p bigint) FROM PUBLIC;
