-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_cron_obter_pr_prev_dia (nr_seq_cron_p bigint) RETURNS bigint AS $body$
DECLARE


dt_inicio_real_w		timestamp;
dt_fim_prev_w			timestamp;
qt_dias_uteis_w			bigint;
pr_por_dia_w			double precision;
qt_dias_trab_w			bigint;
pr_prev_dia_w			double precision;


BEGIN

	select 	dt_inicio_real,
			dt_fim
	into STRICT	dt_inicio_real_w,
			dt_fim_prev_w
	from 	proj_cronograma
	where	nr_sequencia = nr_seq_cron_p;


	if (dt_inicio_real_w IS NOT NULL AND dt_inicio_real_w::text <> '') and (dt_fim_prev_w IS NOT NULL AND dt_fim_prev_w::text <> '') then

		select	OBTER_DIAS_UTEIS_PERIODO(dt_inicio_real_w, dt_fim_prev_w, 1)
		into STRICT	qt_dias_uteis_w
		;

		select	dividir(100, qt_dias_uteis_w)
		into STRICT	pr_por_dia_w
		;

		select	OBTER_DIAS_UTEIS_PERIODO(dt_inicio_real_w, clock_timestamp(), 1)
		into STRICT	qt_dias_trab_w
		;

		pr_prev_dia_w		:= (pr_por_dia_w * qt_dias_trab_w);

		if (pr_prev_dia_w > 100) then
			pr_prev_dia_w	:= 100;
		end if;

	end if;

return	pr_prev_dia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_cron_obter_pr_prev_dia (nr_seq_cron_p bigint) FROM PUBLIC;

