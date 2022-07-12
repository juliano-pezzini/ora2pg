-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_total_horas_estim ( nr_seq_proj_p bigint, dt_inicial_p timestamp, dt_final_p timestamp ) RETURNS bigint AS $body$
DECLARE


qt_horas_estim_w 	bigint;


BEGIN

select	sum(e.qt_hora_prev) qt_horas_estim
into STRICT	qt_horas_estim_w
from 	proj_cronograma p,
	proj_cron_etapa e
where	nr_seq_proj_p = p.nr_seq_proj
and	p.nr_sequencia = e.nr_seq_cronograma
and	coalesce(e.ie_fase, 'N') = 'N'
and	trunc(e.dt_inicio_prev, 'month') between to_date(dt_inicial_p) and to_date(dt_final_p);

return qt_horas_estim_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_total_horas_estim ( nr_seq_proj_p bigint, dt_inicial_p timestamp, dt_final_p timestamp ) FROM PUBLIC;

