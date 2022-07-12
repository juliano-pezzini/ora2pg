-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medico_turno_agenda (nr_seq_agenda_p bigint, cd_medico_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_turno_w			bigint;
cd_agenda_w			bigint;
hr_inicio_w			timestamp;
ie_dia_semana_w			bigint;
ie_liberado_w			varchar(01) := 'S';
qt_reg_w			bigint;


BEGIN

select	max(cd_agenda),
		max(hr_inicio)
into STRICT	cd_agenda_w,
		hr_inicio_w
from	agenda_paciente
where	nr_sequencia	= nr_seq_agenda_p;


select	count(*)
into STRICT	qt_reg_w
from 	agenda_medico
where	cd_medico	= cd_medico_p
and		(nr_seq_turno IS NOT NULL AND nr_seq_turno::text <> '')
and		cd_agenda = cd_agenda_w;

if (qt_reg_w > 0) then
	begin

	select	cd_agenda,
		hr_inicio
	into STRICT	cd_agenda_w,
		hr_inicio_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_agenda_p;

	select 	pkg_date_utils.get_WeekDay(hr_inicio_w)
	into STRICT	ie_dia_semana_w
	;

	select	max(nr_sequencia)
	into STRICT	nr_seq_turno_w
	from 	agenda_horario
	where	cd_agenda	= cd_agenda_w
	and	dt_dia_semana	= ie_dia_semana_w
	and	to_date(trunc(clock_timestamp(), 'dd') || ' ' || to_char(hr_inicio_w, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') between
			to_date(trunc(clock_timestamp(), 'dd') || ' ' || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') and
			to_date(trunc(clock_timestamp(), 'dd') || ' ' || to_char(hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');


	select	coalesce(max('S'),'N')
	into STRICT	ie_liberado_w
	from	agenda_medico
	where	cd_agenda	= cd_agenda_w
	and	cd_medico	= cd_medico_p
	and 	coalesce(nr_seq_turno, nr_seq_turno_w) = nr_seq_turno_w;
	end;
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medico_turno_agenda (nr_seq_agenda_p bigint, cd_medico_p text) FROM PUBLIC;

