-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consistir_bloq_agenda (cd_agenda_p bigint, dt_horario_p timestamp, ie_dia_semana_p bigint, nr_seq_proc_interno_p bigint, ie_bloqueio_p INOUT text, cd_paciente_p text) AS $body$
DECLARE


ie_bloqueio_w varchar(1) 	:= 'N';
qt_periodo_w	bigint	:= 0;
qt_horario_w	bigint	:= 0;
qt_dia_w	bigint	:= 0;
qt_dia_hor_w	bigint	:= 0;
qt_horarios_bloq_w	bigint	:= 0;
qt_idade_pac_w		integer	:= 0;
ie_sexo_w		varchar(1)	:= 'A';


BEGIN
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_horario_p IS NOT NULL AND dt_horario_p::text <> '') and (ie_dia_semana_p IS NOT NULL AND ie_dia_semana_p::text <> '') then
	/* consistir bloqueio período */

	begin
	select	count(*)
	into STRICT	qt_periodo_w
	from	agenda_bloqueio
	where	cd_agenda = cd_agenda_p
	and	trunc(dt_horario_p) between dt_inicial and dt_final
	and	coalesce(hr_inicio_bloqueio::text, '') = ''
	and	coalesce(hr_final_bloqueio::text, '') = ''
	and	coalesce(ie_dia_semana::text, '') = '';
	exception
		when others then
		qt_periodo_w := 0;
	end;

	/* consistir bloqueio horário */

	begin
	select	count(*)
	into STRICT	qt_horario_w
	from	agenda_bloqueio
	where	cd_agenda = cd_agenda_p
	and	trunc(dt_horario_p) between dt_inicial and dt_final
	and	dt_horario_p between	to_date(to_char(dt_horario_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and 						to_date(to_char(dt_horario_p,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and	(hr_inicio_bloqueio IS NOT NULL AND hr_inicio_bloqueio::text <> '')
	and	(hr_final_bloqueio IS NOT NULL AND hr_final_bloqueio::text <> '')
	and	hr_inicio_bloqueio < hr_final_bloqueio
	and	coalesce(ie_dia_semana::text, '') = '';
	exception
		when others then
		qt_horario_w := 0;
	end;

	/* consistir bloqueio dia */

	begin
	select 	count(*)
	into STRICT	qt_dia_w
	from	agenda_bloqueio
	where	cd_agenda = cd_agenda_p
	and	trunc(dt_horario_p) between dt_inicial and dt_final
	and	coalesce(hr_inicio_bloqueio::text, '') = ''
	and	coalesce(hr_final_bloqueio::text, '') = ''
	and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
	and	((ie_dia_semana = ie_dia_semana_p) or (ie_dia_semana = 9));
	exception
		when others then
		qt_dia_w := 0;
	end;

	/* consistir bloqueio dia e horário */

	begin
	select	count(*)
	into STRICT	qt_dia_hor_w
	from	agenda_bloqueio
	where	cd_agenda = cd_agenda_p
	and	trunc(dt_horario_p) between dt_inicial and dt_final
	and	dt_horario_p between	to_date(to_char(dt_horario_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and 						to_date(to_char(dt_horario_p,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and	(hr_inicio_bloqueio IS NOT NULL AND hr_inicio_bloqueio::text <> '')
	and	(hr_final_bloqueio IS NOT NULL AND hr_final_bloqueio::text <> '')
	and	hr_inicio_bloqueio < hr_final_bloqueio
	and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
	and	((ie_dia_semana = ie_dia_semana_p) or (ie_dia_semana = 9));
	exception
		when others then
		qt_dia_hor_w := 0;
	end;

	if (cd_paciente_p IS NOT NULL AND cd_paciente_p::text <> '') then
		select	coalesce(max(ie_sexo), 'A'),
			max(obter_idade(dt_nascimento, clock_timestamp(), 'A'))
		into STRICT	ie_sexo_w,
			qt_idade_pac_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_paciente_p;
	end if;

	select	coalesce(count(*), 0)
	into STRICT	qt_horarios_bloq_w
	from	ageint_bloqueio_exame
	where	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda_p::text, '') = ''))
	and	nr_seq_proc_interno	= nr_seq_proc_interno_p
	and (trunc(dt_horario_p) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
	and (trunc(dt_horario_p) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
	and (dt_horario_p between to_date(to_char(dt_horario_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and 	to_date(to_char(dt_horario_p,'dd/mm/yyyy') ||' '|| to_char(hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
	and	((coalesce(dt_dia_semana, ie_dia_semana_p) = ie_dia_semana_p) or ((dt_dia_semana = 9) and (ie_dia_semana_p not in (7,1))))
	and	((coalesce(ie_sexo, 'A') = ie_sexo_w) or (ie_sexo = 'A'))
	and	(((qt_idade_pac_w >= coalesce(qt_idade_min, qt_idade_pac_w)) and (qt_idade_pac_w <= coalesce(qt_idade_max, qt_idade_pac_w))) or (coalesce(qt_idade_pac_w::text, '') = ''));

	/* verificar horário bloqueado */

	if (qt_periodo_w > 0) or (qt_horario_w > 0) or (qt_dia_w > 0) or (qt_dia_hor_w > 0) or (qt_horarios_bloq_w > 0) then
		ie_bloqueio_w := 'S';
	end if;
end if;

ie_bloqueio_p := ie_bloqueio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consistir_bloq_agenda (cd_agenda_p bigint, dt_horario_p timestamp, ie_dia_semana_p bigint, nr_seq_proc_interno_p bigint, ie_bloqueio_p INOUT text, cd_paciente_p text) FROM PUBLIC;

