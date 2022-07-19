-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_sala_ageserv (nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_turno_p bigint, nr_seq_sala_p bigint, dt_agenda_p timestamp, ds_erro_p INOUT text) AS $body$
DECLARE


ie_consiste_sala_agendamento_w varchar(1);
qt_agendamentos_w              bigint;
ds_erro_w               	   varchar(255) := '';
hr_inicial_turno_w             timestamp;
hr_final_turno_w               timestamp;
dt_agenda_hor_turno_ini_w      timestamp;
dt_agenda_hor_turno_fim_w      timestamp;


BEGIN

ie_consiste_sala_agendamento_w := obter_param_usuario(866, 315, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_sala_agendamento_w);	

if (ie_consiste_sala_agendamento_w = 'S') and (nr_seq_sala_p IS NOT NULL AND nr_seq_sala_p::text <> '') then
	select at.hr_inicial,
		   at.hr_final
	into STRICT hr_inicial_turno_w,
		 hr_final_turno_w
	from agenda_turno at
	where at.nr_sequencia = nr_seq_turno_p;	
	
	dt_agenda_hor_turno_ini_w := to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || ' ' || to_char(hr_inicial_turno_w, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
	dt_agenda_hor_turno_fim_w := to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || ' ' || to_char(hr_final_turno_w, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');

	select count(*)
	into STRICT qt_agendamentos_w
	from agenda_consulta ac,
		 agenda_turno at
	where ac.nr_seq_turno = at.nr_sequencia
	and ac.nr_seq_turno <> nr_seq_turno_p
	and ac.nr_seq_sala = nr_seq_sala_p
	and (to_date(to_char(ac.dt_agenda, 'dd/mm/yyyy') || ' ' || to_char(at.hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <= dt_agenda_hor_turno_ini_w
		 or to_date(to_char(ac.dt_agenda, 'dd/mm/yyyy') || ' ' || to_char(at.hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') <= dt_agenda_hor_turno_fim_w)
	and (to_date(to_char(ac.dt_agenda, 'dd/mm/yyyy') || ' ' || to_char(at.hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >= dt_agenda_hor_turno_ini_w
		 or to_date(to_char(ac.dt_agenda, 'dd/mm/yyyy') || ' ' || to_char(at.hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') >= dt_agenda_hor_turno_fim_w)
	and ac.ie_status_agenda not in ('C','L');
	
	if (qt_agendamentos_w > 0) then
		ds_erro_w := obter_desc_expressao(950383);
	end if;

end if;

ds_erro_p := ds_erro_w;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_sala_ageserv (nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_turno_p bigint, nr_seq_sala_p bigint, dt_agenda_p timestamp, ds_erro_p INOUT text) FROM PUBLIC;

