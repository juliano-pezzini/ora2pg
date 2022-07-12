-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_consistencia_area_npi (nr_seq_proj_cron_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w			varchar(1);
nr_seq_etapa_processo_w	bigint;
nr_seq_projeto_w		bigint;
nr_seq_ordem_consist_w	bigint;
nr_seq_ordem_w		bigint;
qt_area_w		integer;
dt_inicio_w		timestamp;
dt_inicio_consist_w		timestamp;


BEGIN

retorno_w:= 'N';

select	coalesce(max(nr_seq_etapa_processo),0)
into STRICT	nr_seq_etapa_processo_w
from	prp_etapa_equipe_definida;

if (nr_seq_etapa_processo_w > 0) then

	select	coalesce(max(b.nr_seq_proj),0)
	into STRICT	nr_seq_projeto_w
	from	proj_cron_etapa a,
		proj_cronograma b
	where	b.nr_sequencia = a.nr_seq_cronograma
	and	b.ie_classificacao = 'N'
	and	a.nr_sequencia = nr_seq_proj_cron_p;

	select	trunc(max(e.dt_inicio)) dt_inicio,
		max(obter_ordem_etapa_npi(a.nr_seq_cronograma,a.nr_sequencia)) nr_seq_ordem
	into STRICT	dt_inicio_consist_w,
		nr_seq_ordem_consist_w
	from	prp_processo_etapa d,
		proj_cron_etapa a,
		proj_cronograma e
	where	d.nr_sequencia = a.nr_seq_processo_etapa
	and	e.nr_sequencia = a.nr_seq_cronograma
	and	d.nr_seq_etapa_processo = nr_seq_etapa_processo_w
	and	e.nr_seq_proj = nr_seq_projeto_w;

	select	trunc(max(e.dt_inicio)) dt_inicio,
		max(obter_ordem_etapa_npi(a.nr_seq_cronograma,a.nr_sequencia)) nr_seq_ordem
	into STRICT	dt_inicio_w,
		nr_seq_ordem_w
	from	proj_cron_etapa a,
		proj_cronograma e
	where	e.nr_sequencia = a.nr_seq_cronograma
	and	a.nr_sequencia = nr_seq_proj_cron_p;

	if (dt_inicio_w >= dt_inicio_consist_w) and (nr_seq_ordem_w > nr_seq_ordem_consist_w) then

		select sum(total)
		into STRICT	qt_area_w
		from (SELECT	count(*) total
			from	prp_area_processo x
			where	not exists (select	1
						from	prp_processo a,
							prp_processo_fase b,
							prp_processo_etapa c
						where	a.nr_sequencia = b.nr_seq_processo
						and	b.nr_sequencia = c.nr_seq_processo_fase
						and	a.nr_seq_projeto = nr_seq_projeto_w
						and	c.nr_seq_area_processo = x.nr_sequencia)
			
union all

			SELECT	count(*) total
			from	prp_area_processo_partic x
			where	(x.nr_seq_grupo IS NOT NULL AND x.nr_seq_grupo::text <> '')
			and	not exists (select	1
						from	prp_processo a,
							prp_processo_fase b,
							prp_processo_etapa c
						where	a.nr_sequencia = b.nr_seq_processo
						and	b.nr_sequencia = c.nr_seq_processo_fase
						and	a.nr_seq_projeto = nr_seq_projeto_w
						and	c.nr_seq_grupo_cargo = x.nr_seq_grupo)) alias8;

		if (qt_area_w > 0) then

			retorno_w:= 'S';

		end if;

	end if;

end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_consistencia_area_npi (nr_seq_proj_cron_p bigint) FROM PUBLIC;
