-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_semana_ano (nr_semana_ano_p bigint, nr_ano_p bigint, ie_data_semana_p text) RETURNS timestamp AS $body$
DECLARE


dt_semana_ano_w			timestamp;
dt_primeira_data_semana		timestamp;
dt_segunda_data_semana		timestamp;
dt_ano_w			timestamp;

BEGIN
if (nr_semana_ano_p IS NOT NULL AND nr_semana_ano_p::text <> '') and (nr_ano_p IS NOT NULL AND nr_ano_p::text <> '') and (nr_semana_ano_p <= 53) and (nr_semana_ano_p > 0) then

	dt_ano_w	:= pkg_date_utils.get_date(nr_ano_p, 1, 1, 0);

	select
		obter_data_maior((dt_ano_w + ((nr_semana_ano_p-1)*7)) - (pkg_date_utils.get_weekday(dt_ano_w + ((nr_semana_ano_p-1)*7))-1), dt_ano_w),
		obter_data_menor((dt_ano_w + ((nr_semana_ano_p-1)*7)) + (7-pkg_date_utils.get_weekday(dt_ano_w + ((nr_semana_ano_p-1)*7))), pkg_date_utils.get_date(nr_ano_p, 12, 31, 0))
	into STRICT	dt_primeira_data_semana,
		dt_segunda_data_semana
	;

	if (ie_data_semana_p = 'P') then
		dt_semana_ano_w := dt_primeira_data_semana;
	elsif (ie_data_semana_p = 'S') then
		dt_semana_ano_w := dt_segunda_data_semana;
	end if;

end if;

return	dt_semana_ano_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_semana_ano (nr_semana_ano_p bigint, nr_ano_p bigint, ie_data_semana_p text) FROM PUBLIC;
