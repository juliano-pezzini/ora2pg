-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_agenda_hor_bloq ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_minuto_duracao_p bigint ) RETURNS varchar AS $body$
DECLARE


qt_agenda_w	integer;
ie_retorno_w	varchar(1);


BEGIN

begin
select	count(*)
into STRICT	qt_agenda_w
from	agenda_paciente
where	cd_agenda = cd_agenda_p
and	(dt_agenda_p between hr_inicio and hr_inicio + (nr_minuto_duracao/1440)
or	 dt_agenda_p + (nr_minuto_duracao_p/1440) between hr_inicio and hr_inicio + (nr_minuto_duracao/1440))
and	ie_status_agenda = 'B';
exception
	when others then
	qt_agenda_w	:= 0;
end;

if (qt_agenda_w > 0) then
	ie_retorno_w	:= 'S';
else
	ie_retorno_w	:= 'N';
end if;


return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_agenda_hor_bloq ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_minuto_duracao_p bigint ) FROM PUBLIC;
