-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_calc_horas_prev ( nr_sequencia_p bigint, nr_seq_superior_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		double precision;
qt_hora_prev_sup_w	double precision;
qt_hora_prev_w		double precision;


BEGIN

select	coalesce(qt_hora_prev,0)
into STRICT	qt_hora_prev_sup_w
from	proj_cron_etapa
where	nr_sequencia = nr_seq_superior_p;

select	coalesce(qt_hora_prev,0)
into STRICT	qt_hora_prev_w
from	proj_cron_etapa
where	nr_sequencia = nr_sequencia_p;

select (dividir(qt_hora_prev_w, qt_hora_prev_sup_w) * 100)
into STRICT	qt_retorno_w
;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_calc_horas_prev ( nr_sequencia_p bigint, nr_seq_superior_p bigint) FROM PUBLIC;

