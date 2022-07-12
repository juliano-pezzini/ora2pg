-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_agenda_tipo_dia ( dt_agenda_p timestamp, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


nr_retorno_w	smallint;


BEGIN
if (ie_tipo_p = 'P') then
	begin
		select	1
		into STRICT	nr_retorno_w
		
		where	pkg_date_utils.get_DiffDate(clock_timestamp(), dt_agenda_p, 'DAY') < 0;
	exception
	when others then
		nr_retorno_w := 0;
	end;
elsif (ie_tipo_p = 'F') then
	begin
		select	1
		into STRICT	nr_retorno_w
		
		where	pkg_date_utils.get_DiffDate(clock_timestamp(), dt_agenda_p, 'DAY') > 0;
	exception
	when others then
		nr_retorno_w := 0;
	end;
elsif (ie_tipo_p = 'D') then
	begin
		select	1
		into STRICT	nr_retorno_w
		
		where	pkg_date_utils.get_DiffDate(clock_timestamp(), dt_agenda_p, 'DAY') = 0;
	exception
	when others then
		nr_retorno_w := 0;
	end;
end if;

RETURN	nr_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_agenda_tipo_dia ( dt_agenda_p timestamp, ie_tipo_p text) FROM PUBLIC;

