-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_horario_esp_agenda (cd_agenda_p bigint, dt_agenda_p timestamp, hr_agenda_p timestamp, nr_seq_esp_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE


nr_seq_horario_w	bigint;
ie_gerar_hor_falta_w	varchar(1);


BEGIN

ie_gerar_hor_falta_w := obter_param_usuario(820, 176, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_hor_falta_w);

if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (hr_agenda_p IS NOT NULL AND hr_agenda_p::text <> '') and (nr_seq_esp_p IS NOT NULL AND nr_seq_esp_p::text <> '') then

	if (ie_gerar_hor_falta_w = 'S') then
		select	/*+index(a AGEPACI_UK)*/			coalesce(max(a.nr_sequencia),0)
		into STRICT	nr_seq_horario_w
		from	agenda_paciente a
		where	a.cd_agenda = cd_agenda_p
		and	a.dt_agenda = trunc(dt_agenda_p,'dd')
		and	a.hr_inicio = hr_agenda_p
		and	a.ie_status_agenda not in ('C','LF','F','I');
	else
		select	/*+index(a AGEPACI_UK)*/			coalesce(max(a.nr_sequencia),0)
		into STRICT	nr_seq_horario_w
		from	agenda_paciente a
		where	a.cd_agenda = cd_agenda_p
		and	a.dt_agenda = trunc(dt_agenda_p,'dd')
		and	a.hr_inicio = hr_agenda_p
		and	a.ie_status_agenda not in ('C','LF');
	end if;

	if (nr_seq_horario_w > 0) then

		update	agenda_paciente
		set	nr_seq_esp 	= nr_seq_esp_p
		where	nr_sequencia	= nr_seq_horario_w
		and	coalesce(nr_seq_esp::text, '') = '';

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_horario_esp_agenda (cd_agenda_p bigint, dt_agenda_p timestamp, hr_agenda_p timestamp, nr_seq_esp_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;

