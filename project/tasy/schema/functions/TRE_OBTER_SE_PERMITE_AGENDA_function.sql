-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tre_obter_se_permite_agenda ( cd_pessoa_fisica_p text, nr_seq_agenda_p bigint, ie_dia_semana_p text, dt_horario_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(1);
nr_seq_pac_reab_w	bigint;
ie_dia_semana_w		varchar(1);
hr_inicial_w		timestamp;
hr_final_w		timestamp;
dt_inicio_w		timestamp;
dt_final_w		timestamp;
dt_horario_w		timestamp;


C01 CURSOR FOR
	SELECT	ie_dia_semana,
		hr_inicial,
		hr_final
	from	tre_agenda_turno
	where	nr_seq_agenda_tre = nr_seq_agenda_p
	and ((dt_horario_p between dt_inicio_vigencia and fim_dia(dt_fim_vigencia)) or ((coalesce(dt_inicio_vigencia::text, '') = '') or (coalesce(dt_fim_vigencia::text, '') = '')));

C02 CURSOR FOR
	SELECT	ie_dia_semana,
		hr_horario
	from	rp_item_modelo_agenda
	where	nr_seq_modelo = nr_seq_agenda_p
	and	coalesce(ie_situacao,'A') = 'A';


BEGIN
if (ie_opcao_p = 'T') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_pac_reab_w
	from	rp_paciente_reabilitacao
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	select	max(coalesce(dt_inicio_real,dt_inicio)),
		max(coalesce(dt_termino_real,dt_termino))
	into STRICT	dt_inicio_w,
		dt_final_w
	from	tre_agenda
	where	nr_sequencia = nr_seq_agenda_p;

	open C01;
	loop
	fetch C01 into
		ie_dia_semana_w,
		hr_inicial_w,
		hr_final_w;
	EXIT WHEN NOT FOUND or ds_retorno_w = 'N';  /* apply on C01 */
		begin
		--Verifica se há serviços infividuais no mesmo dia e horário.
		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ds_retorno_w
		from	rp_pac_agend_individual
		where	nr_seq_pac_reab = nr_seq_pac_reab_w
		and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9 and ie_dia_semana not in (1,7)))
		and	to_date(to_char(dt_horario,'hh24:mi'),'hh24:mi') between to_date(to_char(hr_inicial_w,'hh24:mi'),'hh24:mi') and to_date(to_char(hr_final_w,'hh24:mi'),'hh24:mi')
		and	coalesce(dt_fim_agendamento::text, '') = ''
		and	((coalesce(dt_final_w::text, '') = '') or (trunc(dt_final_w) <= trunc(clock_timestamp())));

		if (ds_retorno_w = 'S') then
			--Verifica se há modelos no mesmo dia e horário.
			select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
			into STRICT	ds_retorno_w
			from	rp_pac_modelo_agendamento a,
				rp_modelo_agendamento b,
				rp_item_modelo_agenda c
			where	a.nr_seq_modelo_agendamento  = b.nr_sequencia
			and	c.nr_seq_modelo = b.nr_sequencia
			and	a.nr_seq_pac_reab = nr_seq_pac_reab_w
			and	coalesce(a.dt_fim_tratamento::text, '') = ''
			and	coalesce(a.dt_fim_agendamento::text, '') = ''
			and	coalesce(a.dt_inativacao::text, '') = ''
			and	((c.ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9 and c.ie_dia_semana not in (1,7)))
			and	to_date(to_char(c.HR_HORARIO,'hh24:mi'),'hh24:mi') between to_date(to_char(hr_inicial_w,'hh24:mi'),'hh24:mi') and to_date(to_char(hr_final_w,'hh24:mi'),'hh24:mi')
			and	((coalesce(dt_final_w::text, '') = '') or (trunc(dt_final_w) <= trunc(clock_timestamp())));
		end if;
		end;
	end loop;
	close C01;
elsif (ie_opcao_p = 'RI') then

	select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ds_retorno_w
	from	TRE_AGENDA a,
		TRE_AGENDA_TURNO b,
		TRE_CANDIDATO c
	where	a.nr_sequencia = c.nr_seq_agenda
	and	b.nr_Seq_agenda_tre = a.nr_sequencia
	and	c.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	((trunc(coalesce(a.dt_termino_real,a.dt_termino)) <= trunc(clock_timestamp())) or (coalesce(coalesce(a.dt_termino_real,a.dt_termino)::text, '') = ''))
	and	b.ie_dia_semana = ie_dia_semana_p
	and	to_date(to_char(dt_horario_p,'hh24:mi'),'hh24:mi') between to_date(to_char(hr_inicial,'hh24:mi'),'hh24:mi') and to_date(to_char(hr_final,'hh24:mi'),'hh24:mi');

elsif (ie_opcao_p = 'RM') then

	open C02;
	loop
	fetch C02 into
		ie_dia_semana_w,
		dt_horario_w;
	EXIT WHEN NOT FOUND or ds_retorno_w = 'N';  /* apply on C02 */
		begin

		select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ds_retorno_w
		from	TRE_AGENDA a,
			TRE_AGENDA_TURNO b,
			TRE_CANDIDATO c
		where	a.nr_sequencia = c.nr_seq_agenda
		and	b.nr_Seq_agenda_tre = a.nr_sequencia
		and	c.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	((trunc(coalesce(a.dt_termino_real,a.dt_termino)) <= trunc(clock_timestamp())) or (coalesce(coalesce(a.dt_termino_real,a.dt_termino)::text, '') = ''))
		and	b.ie_dia_semana = ie_dia_semana_w
		and	to_date(to_char(dt_horario_w,'hh24:mi'),'hh24:mi') between to_date(to_char(hr_inicial,'hh24:mi'),'hh24:mi') and to_date(to_char(hr_final,'hh24:mi'),'hh24:mi');
		end;
	end loop;
	close C02;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tre_obter_se_permite_agenda ( cd_pessoa_fisica_p text, nr_seq_agenda_p bigint, ie_dia_semana_p text, dt_horario_p timestamp, ie_opcao_p text) FROM PUBLIC;
