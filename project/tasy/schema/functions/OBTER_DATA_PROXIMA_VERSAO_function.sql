-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_proxima_versao ( dt_referencia_p timestamp) RETURNS timestamp AS $body$
DECLARE



ie_dia_w			smallint;
dt_referencia_w		timestamp;
dt_versao_w		timestamp;

BEGIN

dt_referencia_w	:= coalesce(dt_referencia_p,clock_timestamp());

select	pkg_date_utils.get_weekday(dt_referencia_w)
into STRICT	ie_dia_w
;

select	pkg_date_utils.start_of(next_day(dt_referencia_w, 3), 'DD', 0)
into STRICT	dt_versao_w
;

if (ie_dia_w >= 4) then

	if (ie_dia_w = 4) and (pkg_date_utils.extract_field('HOUR', dt_referencia_w, 0) >= 18) then
		dt_versao_w	:= dt_versao_w + 7;
	end if;
	if (ie_dia_w > 4) then
		dt_versao_w	:= dt_versao_w + 7;
	end if;
elsif (ie_dia_w in (1,2)) then
	dt_versao_w	:= dt_versao_w + 7;
end if;

if (dt_referencia_w <= pkg_date_utils.get_date(2012, 1, 11, 0)) then
	dt_versao_w := pkg_date_utils.get_date(2012, 1, 17, 0);
end if;

return	dt_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_proxima_versao ( dt_referencia_p timestamp) FROM PUBLIC;
