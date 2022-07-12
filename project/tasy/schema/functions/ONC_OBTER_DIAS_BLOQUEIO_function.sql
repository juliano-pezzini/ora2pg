-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION onc_obter_dias_bloqueio ( data_selecionada_p timestamp, nr_sequencia_bloqueio_p bigint) RETURNS varchar AS $body$
DECLARE


periodo_dias_w	varchar(2000);


BEGIN

	select 	CASE WHEN count(nr_sequencia)=0 THEN 'ONE_DAY'  ELSE 'SEVERAL_DAYS' END
		
	into STRICT 	periodo_dias_w

	from	qt_bloqueio

	where ( to_date(dt_inicial, 'YYYY-MM-DD') < to_date(data_selecionada_p, 'YYYY-MM-DD')

		or to_date(dt_final, 'YYYY-MM-DD') > to_date(data_selecionada_p, 'YYYY-MM-DD') )

		and nr_sequencia = nr_sequencia_bloqueio_p;

		return periodo_dias_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION onc_obter_dias_bloqueio ( data_selecionada_p timestamp, nr_sequencia_bloqueio_p bigint) FROM PUBLIC;
