-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_data_encaixe_agenda () AS $body$
DECLARE


nr_seq_w	bigint;
cd_agenda_w	bigint;
dt_agenda_w	timestamp;
hr_inicio_w	timestamp;
ie_status_w	varchar(5);

qt_hor_w	bigint;
qt_reg_w	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_agenda,
	dt_agenda,
	hr_inicio,
	ie_status_agenda
from	agenda_paciente
where	coalesce(ie_encaixe,'N') = 'S'
order by
	nr_sequencia;


BEGIN
open c01;
loop
fetch c01 into 	nr_seq_w,
			cd_agenda_w,
			dt_agenda_w,
			hr_inicio_w,
			ie_status_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	count(*)
	into STRICT	qt_hor_w
	from	agenda_paciente
	where	nr_sequencia 		<> nr_seq_w
	and	cd_agenda 		= cd_agenda_w
	and	dt_agenda		= trunc(dt_agenda_w,'dd')
	and	hr_inicio 		= hr_inicio_w
	and	ie_status_agenda	= ie_status_w;

	update	agenda_paciente
	set	dt_agenda	= trunc(dt_agenda,'dd'),
		hr_inicio	= hr_inicio + qt_hor_w / 86400
	where	nr_sequencia	= nr_seq_w;

	if (qt_reg_w = 10000) then
		commit;
		qt_reg_w := 0;
	else
		qt_reg_w := qt_reg_w + 1;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_data_encaixe_agenda () FROM PUBLIC;
