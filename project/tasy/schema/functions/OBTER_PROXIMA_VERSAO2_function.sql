-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proxima_versao2 ( dt_referencia_p timestamp) RETURNS timestamp AS $body$
DECLARE


ds_dia_versao_w		varchar(100);
ie_dia_w			smallint;
dt_referencia_w		timestamp;
dt_versao_w		timestamp;

BEGIN

dt_referencia_w	:= coalesce(dt_referencia_p,clock_timestamp());

ie_dia_w := to_char(pkg_date_utils.get_WeekDay(dt_referencia_w));

select	trunc(next_day(dt_referencia_w,3))
into STRICT	dt_versao_w
;

if (ie_dia_w >= 4) then

	if (ie_dia_w = 4) and ((to_char(dt_referencia_w,'hh24'))::numeric  >= 18) then
		dt_versao_w	:= dt_versao_w + 7;
	end if;
	if (ie_dia_w > 4) then
		dt_versao_w	:= dt_versao_w + 7;
	end if;
elsif (ie_dia_w in (1,2)) then
	dt_versao_w	:= dt_versao_w + 7;
end if;

if	((dt_referencia_w > to_date('12/12/2012','dd/mm/yyyy')) and (trunc(dt_referencia_w) < to_date('09/01/2013','dd/mm/yyyy'))) then
	dt_versao_w := to_date('15/01/2013','dd/mm/yyyy');
end if;

return	dt_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proxima_versao2 ( dt_referencia_p timestamp) FROM PUBLIC;
