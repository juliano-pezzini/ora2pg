-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/*---------------------------------------------------------------------------------------------------------------------------------------------
	|			VARIAVEIS_GLOBAIS					|
	*/
	

	/*---------------------------------------------------------------------------------------------------------------------------------------------
	|			OBTER_INTERVALO_AGENDA				|
	*/
	/* Function generica onde retorna o intervalo de minutos de determinada agenda para determinado horario
	   Tambem e utilizada por functions externas */
CREATE OR REPLACE FUNCTION mprev_agenda_pck.obter_intervalo_agenda (cd_agenda_p bigint, dt_agendamento_p timestamp, dt_final_agendamento_p timestamp) RETURNS bigint AS $body$
DECLARE


	qt_intervalo_w		bigint := null;
	nr_dia_semana_w		smallint := pkg_date_utils.get_weekday(dt_agendamento_p);
	dt_horario_w		timestamp := to_date(to_char(dt_agendamento_p, 'hh24:mi'), 'hh24:mi');
	dt_horario_final_w	timestamp;

	
BEGIN

	if (dt_final_agendamento_p IS NOT NULL AND dt_final_agendamento_p::text <> '') then

		dt_horario_final_w := to_date(to_char(dt_final_agendamento_p, 'hh24:mi'), 'hh24:mi');

		select	min(nr_minuto_intervalo)
		into STRICT	qt_intervalo_w
		from	agenda_turno
		where	cd_agenda = cd_agenda_p
		and (ie_dia_semana	= nr_dia_semana_w or (ie_dia_semana = '9' and nr_dia_semana_w > 1 and nr_dia_semana_w < 7))
		and	pkg_date_utils.start_of(dt_agendamento_p, 'DD', 0)  between dt_inicio_vigencia and coalesce(dt_final_vigencia, dt_agendamento_p)
		and 	to_date(to_char(hr_inicial, 'hh24:mi'), 'hh24:mi') <= dt_horario_w
		and 	to_date(to_char(hr_final, 'hh24:mi'), 'hh24:mi') >= dt_horario_final_w
		and	((coalesce(hr_inicial_intervalo::text, '') = '' and coalesce(hr_final_intervalo::text, '') = '') -- se nao tiver intervalo ja retorna o registro
		or	((dt_horario_w <= to_date(to_char(hr_inicial_intervalo,'hh24:mi'), 'hh24:mi') -- senao vai verificar se a data de agendamento esta fora do intervalo
		and	dt_horario_final_w <= to_date(to_char(hr_inicial_intervalo,'hh24:mi'), 'hh24:mi'))
		or (dt_horario_w >= to_date(to_char(hr_final_intervalo,'hh24:mi'), 'hh24:mi')
		and	dt_horario_final_w >= to_date(to_char(hr_final_intervalo,'hh24:mi'), 'hh24:mi'))));

	else
		-- Se nao tem a data final do agendamento, o sistem vai usar como base o intervalo de minutos
		select	min(nr_minuto_intervalo)
		into STRICT	qt_intervalo_w
		from	agenda_turno
		where	cd_agenda = cd_agenda_p
		and (ie_dia_semana	= nr_dia_semana_w or (ie_dia_semana = '9' and nr_dia_semana_w > 1 and nr_dia_semana_w < 7))
		and	pkg_date_utils.start_of(dt_agendamento_p,'DD',0)  between dt_inicio_vigencia and coalesce(dt_final_vigencia, dt_agendamento_p)
		and 	to_date(to_char(hr_inicial, 'hh24:mi'), 'hh24:mi') <= dt_horario_w
		and 	to_date(to_char(hr_final, 'hh24:mi'), 'hh24:mi') >= (dt_horario_w + (nr_minuto_intervalo * (1/24/60)))
		and	((coalesce(hr_inicial_intervalo::text, '') = '' and coalesce(hr_final_intervalo::text, '') = '') -- se nao tiver intervalo ja retorna o registro
		or	((dt_horario_w <= to_date(to_char(hr_inicial_intervalo,'hh24:mi'), 'hh24:mi') -- senao vai verificar se a data de agendamento esta fora do intervalo
		and	(dt_horario_w + (nr_minuto_intervalo * (1/24/60))) <= to_date(to_char(hr_inicial_intervalo,'hh24:mi'), 'hh24:mi'))
		or	(dt_horario_w >= to_date(to_char(hr_final_intervalo,'hh24:mi'), 'hh24:mi')
		and	(dt_horario_w + (nr_minuto_intervalo * (1/24/60))) >= to_date(to_char(hr_final_intervalo,'hh24:mi'), 'hh24:mi'))));

	end if;

	return	qt_intervalo_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION mprev_agenda_pck.obter_intervalo_agenda (cd_agenda_p bigint, dt_agendamento_p timestamp, dt_final_agendamento_p timestamp) FROM PUBLIC;
