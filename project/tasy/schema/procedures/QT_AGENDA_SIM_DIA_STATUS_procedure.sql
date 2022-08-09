-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_agenda_sim_dia_status ( cd_estabelecimento_p bigint, nr_seq_pac_sim_p bigint, dt_Inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, hr_min_local_p bigint, hr_max_local_p bigint, nr_minuto_duracao_p bigint, ie_Status_p INOUT text) AS $body$
DECLARE



ie_Status_w		varchar(4000);
ie_Status_dia_w		varchar(10);
dt_atual_w		timestamp;
cd_tipo_agenda_w	bigint;
ie_feriado_w		varchar(10);
ie_dia_feriado_w	varchar(10);
ie_dia_semana_w		varchar(10);
qt_horario_w		bigint;
qt_horario_livre_w	bigint;
qt_regra_horario_w	bigint;
qt_horario_bloqueado_w	bigint;
ds_horarios_w		varchar(255);
ie_bloqueio_w		varchar(10);
ie_gravar_w		varchar(10) := 'N';
ie_sobra_horario_w	varchar(10) := 'S';
ds_retorno_w		varchar(4000) := '';
qt_bloqueio_w		bigint;
qt_horario_ocupado_w	bigint;
qt_dia_pend_w		bigint;
qt_agendado_w		bigint;
dt_min_trat_w		timestamp;
dt_max_trat_w		timestamp;
hr_hora_w		smallint;
ie_primeiro_w		varchar(1);
ie_gerado_w		varchar(1)	:= 'N';
qt_tempo_medic_w	bigint;
dt_horario_w		timestamp;
--ie_status_w		varchar2(15);
dt_primeiro_livre_w	timestamp;
ie_dia_livre_w		varchar(1)	:= 'N';
qt_agendamento_w	bigint;
nr_Seq_local_w		bigint;
ie_status_hor_w		varchar(15);
qt_tempo_prep_medic_w	bigint;
qt_tempo_prep_pac_w	bigint;
qt_tempo_div_tela_w	bigint;

C01 CURSOR FOR
	SELECT	dt_horario,
		ie_Status
	from	w_agenda_quimio
	where	nr_seq_paciente		= nr_seq_pac_sim_p
	and	trunc(dt_horario)	= trunc(dt_atual_w)
	and	nr_seq_local		= nr_seq_local_w
	order by 1;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	qt_local
	where	ie_situacao	= 'A'
	order by 1;


BEGIN
if	((Dt_final_p - dt_inicial_p) > 255) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262405);
end if;

select	coalesce(max(Obter_Valor_Param_Usuario(865, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),0)
into STRICT	qt_tempo_prep_medic_w
;

select	coalesce(max(Obter_Valor_Param_Usuario(865, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),0)
into STRICT	qt_tempo_prep_pac_w
;

select	coalesce(max(Obter_Valor_Param_Usuario(865, 3, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),0)
into STRICT	qt_tempo_div_tela_w
;

select 	min(coalesce(dt_real, dt_prevista))
into STRICT	dt_min_trat_w
from	paciente_atendimento_sim
where	nr_seq_paciente	= nr_seq_pac_sim_p;

select 	max(coalesce(dt_Real, dt_prevista))
into STRICT	dt_max_trat_w
from	paciente_atendimento_sim
where	nr_seq_paciente	= nr_seq_pac_sim_p;

select	max(a.qt_tempo_medic)
into STRICT	qt_tempo_medic_w
from	paciente_setor_sim a,
	paciente_atendimento_sim b
where	a.nr_sequencia	= b.nr_seq_paciente
and	b.nr_seq_paciente	= nr_seq_pac_sim_p;

qt_tempo_medic_w	:= qt_tempo_medic_w + qt_tempo_prep_medic_w + qt_tempo_prep_pac_w;

ie_status_w					:= '';
dt_atual_w					:= trunc(dt_inicial_p, 'dd');
WHILE(dt_atual_w	<= Trunc(dt_final_p,'dd')) LOOP
	begin
	ie_status_dia_w			:= 'X';
	if (trunc(dt_atual_w)	>= trunc(dt_min_trat_w)) and (trunc(dt_atual_w)	<= trunc(dt_max_trat_w)) then
		select	count(*)
		into STRICT	qt_agendamento_w
		from	paciente_atendimento_sim
		where	nr_seq_paciente	= nr_seq_pac_sim_p
		and	trunc(coalesce(dt_real, dt_prevista))	= trunc(dt_atual_w);
		if (qt_agendamento_w	> 0) then
			ie_status_dia_w	:= 'L';
		end if;
		ie_dia_livre_w	:= 'N';
		ie_primeiro_w	:= 'S';
	end if;

	ie_status_w	:= ie_status_w || ie_status_dia_w;
	dt_atual_w	:= dt_atual_w + 1;
	end;
END LOOP;
ie_status_p		:= ie_status_w;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_agenda_sim_dia_status ( cd_estabelecimento_p bigint, nr_seq_pac_sim_p bigint, dt_Inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, hr_min_local_p bigint, hr_max_local_p bigint, nr_minuto_duracao_p bigint, ie_Status_p INOUT text) FROM PUBLIC;
