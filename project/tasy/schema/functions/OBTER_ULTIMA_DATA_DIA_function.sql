-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_data_dia ( nr_dia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		timestamp;
nr_dia_w		bigint;


BEGIN

select	(to_char(clock_timestamp(),'dd'))::numeric
into STRICT	nr_dia_w
;

if (nr_dia_w >= nr_dia_p) then
	select	to_date(to_char(nr_dia_p)||'/'||to_char(clock_timestamp(),'mm/yyyy'),'dd/mm/yyyy')
	into STRICT	dt_retorno_w
	;
else
	select	to_date(to_char(nr_dia_p)||'/'||to_char(trunc(clock_timestamp(), 'month')-1,'mm/yyyy'),'dd/mm/yyyy')
	into STRICT	dt_retorno_w
	;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_data_dia ( nr_dia_p bigint) FROM PUBLIC;
