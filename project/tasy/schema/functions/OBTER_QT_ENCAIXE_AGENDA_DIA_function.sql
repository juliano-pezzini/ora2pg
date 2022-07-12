-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_encaixe_agenda_dia (cd_agenda_p bigint, dt_agenda_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_encaixe_w	bigint := 0;


BEGIN
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') then
	select	count(*)
	into STRICT	qt_encaixe_w
	from	agenda_consulta
	where	cd_agenda = cd_agenda_p
	and	trunc(dt_agenda,'dd') = trunc(dt_agenda_p,'dd')
	and	ie_status_agenda not in ('C','L','B','F','I','LF')
	and	ie_encaixe = 'S';
end if;

return qt_encaixe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_encaixe_agenda_dia (cd_agenda_p bigint, dt_agenda_p timestamp) FROM PUBLIC;

