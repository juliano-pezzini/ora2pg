-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dpp_us_atual_linked (dt_us_p timestamp, qt_ig_sem_us_p bigint, qt_ig_dia_us_p bigint, ie_opcao_p text, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

					
sql_w varchar(200);
qt_resultado_w bigint;


BEGIN

if (ie_opcao_p in ('D','S')) then	
	BEGIN
		qt_resultado_w := obter_dpp_us_atual_linked_calc(dt_us_P, qt_ig_sem_us_P, qt_ig_dia_us_P, ie_opcao_p, nr_atendimento_p, qt_resultado_w);
	END;

	return qt_resultado_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dpp_us_atual_linked (dt_us_p timestamp, qt_ig_sem_us_p bigint, qt_ig_dia_us_p bigint, ie_opcao_p text, nr_atendimento_p bigint) FROM PUBLIC;
