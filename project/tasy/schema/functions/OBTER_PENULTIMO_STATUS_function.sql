-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_penultimo_status (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE



cd_agenda_w		agenda_consulta.cd_agenda%type;
dt_agenda_w		timestamp;
ie_hor_bloq_w		varchar(1);
ie_retorno_w		varchar(10);
ie_status_agenda_w	varchar(10);


BEGIN

begin
select 	status
into STRICT	ie_status_agenda_w
from (
SELECT  ie_status_agenda status
from 	agenda_cons_log_status
where 	nr_sequencia not in (select max(nr_sequencia)
from 	agenda_cons_log_status where nr_seq_agenda = nr_sequencia_p)
and 	nr_seq_agenda = nr_sequencia_p
order by nr_sequencia desc
) alias2 LIMIT 1;

exception
   when no_data_found then
   null;
end;

if ( coalesce(ie_status_agenda_w::text, '') = '')then

	select	cd_agenda,
		dt_agenda
	into STRICT	cd_agenda_w,
		dt_agenda_w
	from 	agenda_consulta
	where 	nr_sequencia = nr_sequencia_p;

	ie_hor_bloq_w := agencons_obter_se_bloq(cd_agenda_w, dt_agenda_w);

	if (ie_hor_bloq_w = 'S')then
		ie_status_agenda_w := 'B';
	else
		ie_status_agenda_w := 'L';
	end if;

end if;

ie_retorno_w := ie_status_agenda_w;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_penultimo_status (nr_sequencia_p bigint) FROM PUBLIC;
