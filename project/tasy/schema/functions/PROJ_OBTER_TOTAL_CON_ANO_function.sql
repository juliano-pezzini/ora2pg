-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_total_con_ano ( nr_seq_cliente_p bigint, nr_seq_cronograma_p bigint, cd_executor_p text, dt_mes_p timestamp, nr_seq_etapa_p bigint default null) RETURNS bigint AS $body$
DECLARE


nr_seq_etapa_w	bigint;
qt_min_ativ_w	double precision;


BEGIN

nr_seq_etapa_w	:= coalesce(nr_seq_etapa_p,0);

select	coalesce(round((dividir(sum(y.qt_min_ativ),60))::numeric,2),0)
into STRICT	qt_min_ativ_w
from 	proj_rat x,
	proj_rat_ativ y
where 	x.nr_sequencia = y.nr_seq_rat
and	x.nr_seq_cliente = nr_seq_cliente_p
and	x.cd_executor = cd_executor_p
and	y.nr_seq_etapa_cron in (	SELECT	b.nr_sequencia
				from	proj_cron_etapa b
				where (b.nr_seq_cronograma = coalesce(nr_seq_cronograma_p,0) or coalesce(nr_seq_cronograma_p,0) = 0)
				and (b.nr_sequencia	= nr_seq_etapa_w or nr_seq_etapa_w = 0)
				and	coalesce(b.ie_situacao,'A') = 'A')

and (trunc(y.dt_inicio_ativ,'year') = trunc(dt_mes_p,'year') or coalesce(dt_mes_p::text, '') = '');

return	qt_min_ativ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_total_con_ano ( nr_seq_cliente_p bigint, nr_seq_cronograma_p bigint, cd_executor_p text, dt_mes_p timestamp, nr_seq_etapa_p bigint default null) FROM PUBLIC;

