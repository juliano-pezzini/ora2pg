-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_get_initial_date_report (dt_inicio_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_inicio_w		timestamp;


BEGIN
dt_inicio_w := to_date(to_char(dt_inicio_p,'dd/mm/yyyy')||' 08:00:00','dd/mm/yyyy hh24:mi:ss');

if (dt_inicio_p < dt_inicio_w) then
	dt_inicio_w := dt_inicio_w - 1;
end if;

return dt_inicio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_get_initial_date_report (dt_inicio_p timestamp) FROM PUBLIC;

