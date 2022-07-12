-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_agenda_hora (nr_seq_agenda_global_p bigint, dt_agenda_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(01) := 'S';
hr_inicio_w	timestamp;
hr_final_w	timestamp;
hr_atual_w	timestamp;
ie_dia_semana_w	smallint;
ie_dia_atual_w	smallint;


BEGIN


select	max(hr_inicio),
	max(hr_final),
	max(ie_dia_semana)
into STRICT	hr_inicio_w,
	hr_final_w,
	ie_dia_semana_w
from	agenda_global
where	nr_sequencia	= nr_seq_agenda_global_p;


if (hr_inicio_w IS NOT NULL AND hr_inicio_w::text <> '') and (hr_final_w IS NOT NULL AND hr_final_w::text <> '') then
	begin

	ie_liberado_w	:= 'N';

	hr_atual_w	:= to_date(to_char(trunc(clock_timestamp()), 'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');

	if (hr_atual_w >=  to_date(to_char(trunc(clock_timestamp()), 'dd/mm/yyyy') || ' ' || to_char(hr_inicio_w, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')) and (hr_atual_w <=  to_date(to_char(trunc(clock_timestamp()), 'dd/mm/yyyy') || ' ' || to_char(hr_final_w, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')) then
		ie_liberado_w	:= 'S';
	end if;


	end;
end if;

if (ie_dia_semana_w IS NOT NULL AND ie_dia_semana_w::text <> '') then

	ie_liberado_w	:= 'N';

	ie_dia_atual_w	:= obter_cod_dia_semana(dt_agenda_p);

	if	((ie_dia_semana_w = ie_dia_atual_w) or ((ie_dia_semana_w = 9) and (ie_dia_atual_w not in (7,1)))) then
		ie_liberado_w	:= 'S';
	end if;
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_agenda_hora (nr_seq_agenda_global_p bigint, dt_agenda_p timestamp) FROM PUBLIC;

