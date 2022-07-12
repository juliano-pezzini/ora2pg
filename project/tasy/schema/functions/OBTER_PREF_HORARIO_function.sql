-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pref_horario ( dt_agenda_p timestamp, nr_seq_horario_p bigint, cd_perfil_p bigint, nr_seq_turno_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_preferencia_w	bigint;
dt_str_w		varchar(15);
dt_agenda_w		timestamp;


BEGIN

if (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') then
	begin
	
	dt_str_w	:=	to_char(clock_timestamp(),'dd/mm/yyyy');
	dt_agenda_w	:=	to_date(dt_str_w || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	
	if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') then
		select	max(nr_seq_preferencia)
		into STRICT	nr_seq_preferencia_w
		from	agenda_horario_pref
		where	nr_seq_horario = nr_seq_horario_p
		and	dt_agenda_w between to_date(dt_str_w || to_char(hr_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and
			to_date(dt_str_w || to_char(hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		and	coalesce(coalesce(cd_perfil,cd_perfil_p),0) = coalesce(cd_perfil_p,0)
		and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= dt_agenda_p))
		and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= dt_agenda_p));

	elsif (nr_seq_turno_p IS NOT NULL AND nr_seq_turno_p::text <> '') then
		select	max(nr_seq_preferencia)
		into STRICT	nr_seq_preferencia_w
		from	agenda_horario_pref
		where	nr_seq_turno = nr_seq_turno_p
		and	dt_agenda_w between to_date(dt_str_w || to_char(hr_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and
			to_date(dt_str_w || to_char(hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		and	coalesce(coalesce(cd_perfil,cd_perfil_p),0) = coalesce(cd_perfil_p,0)
		and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= dt_agenda_p))
		and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= dt_agenda_p));
	end if;

	end;
end if;

return nr_seq_preferencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pref_horario ( dt_agenda_p timestamp, nr_seq_horario_p bigint, cd_perfil_p bigint, nr_seq_turno_p bigint) FROM PUBLIC;
