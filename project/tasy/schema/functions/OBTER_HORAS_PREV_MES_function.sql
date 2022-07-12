-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horas_prev_mes ( nr_seq_cronograma_p bigint, dt_mes_referencia_p timestamp, ie_tipo_data_p text) RETURNS bigint AS $body$
DECLARE


/*

ie_tipo_data_p

A - Anual
M - Mensal

*/
qt_horas_w		double precision;


BEGIN

if (ie_tipo_data_p = 'M') then

	select	sum(l.qt_hora_prev) qt_hora_prev
	into STRICT	qt_horas_w
	from	proj_cron_etapa l
	where	l.nr_seq_cronograma = nr_seq_cronograma_p
	and	ie_fase = 'N'
	and	trunc(dt_inicio_prev,'month') = trunc(dt_mes_referencia_p,'month');

elsif (ie_tipo_data_p = 'A') then

	select	sum(l.qt_hora_prev) qt_hora_prev
	into STRICT	qt_horas_w
	from	proj_cron_etapa l
	where	l.nr_seq_cronograma = nr_seq_cronograma_p
	and	ie_fase = 'N'
	and	trunc(dt_inicio_prev,'year') = trunc(dt_mes_referencia_p,'year');

end if;

RETURN qt_horas_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horas_prev_mes ( nr_seq_cronograma_p bigint, dt_mes_referencia_p timestamp, ie_tipo_data_p text) FROM PUBLIC;

