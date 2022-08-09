-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_consulta_ageexam (cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, nm_usuario_p text) AS $body$
DECLARE

			
/* variaveis de controle horarios */

ie_tipo_horario_w		varchar(1);
nr_seq_horario_w		bigint;
nr_seq_agenda_w		agenda_paciente.nr_sequencia%TYPE;
hr_horario_w		timestamp;
hr_inicial_dia_w		timestamp;
hr_final_dia_w		timestamp;
hr_inicial_intervalo_w	timestamp;
hr_final_intervalo_w		timestamp;
nr_minuto_duracao_w	bigint;
nr_minuto_orig_w		bigint := 0;
nr_minuto_min_w		bigint := 0;
ie_dia_semana_w		integer;
ie_feriado_w		varchar(1);
nr_seq_especial_w		bigint;
ie_horario_adicional_w	varchar(1);
ie_horario_w		varchar(1);
ie_bloqueio_w		varchar(1);
nr_prioridade_w		bigint;

--Transporte Exames
qt_regra_w		bigint;
nr_seq_regra_transp_w	bigint;

/* variaveis de controle sobra horario */

hr_horario_inicial_w		timestamp;
hr_horario_final_w		timestamp;
nr_minuto_horario_w	bigint;
hr_horario_sobra_w		timestamp;
nr_minuto_sobra_w		bigint;
qt_horario_sobra_w		bigint;
cd_medico_exec_sobra_w	varchar(10);
nr_seq_classif_sobra_w	bigint;

/* variaveis de registro */

cd_turno_w		varchar(1);
nr_seq_medico_exec_w	bigint;
cd_medico_w		varchar(10);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_proc_interno_w	bigint;
nr_seq_classif_w		bigint;
nr_seq_sala_w		bigint;
ds_observacao_w		varchar(255);
cd_medico_executor_w	varchar(10);
ie_medico_executor_w	varchar(01)	:= 'N';
cd_procedencia_w		integer;
qt_agenda_w		smallint;
ie_gerar_hor_agenda_ant_w	varchar(1);
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
ie_encaixe_w		varchar(1);
cd_turno_ww		varchar(1);

ie_gerar_hor_bloq_w	varchar(1)	:= 'N';
ie_excluir_livres_w		varchar(5) 	:= 'N';
ie_autorizacao_w		varchar(5);
ie_tipo_consist_horario_w	varchar(2);
ie_gerar_hor_falta_w	varchar(1);

hr_horario_ant_sobra_w	timestamp;
ds_erro_w		varchar(255);
ie_limpa_obs_especial_w	varchar(1);
ie_gerar_nome_w		varchar(1);

ie_origem_dados_w		varchar(10);

dt_hor_adic_w		timestamp;
nr_min_dur_adic_w		bigint;
nr_seq_transporte_w	bigint;
ie_lado_w		varchar(1);
ie_forma_agendamento_w	smallint;	

cd_medico_exec_w		varchar(10);
cd_pessoa_fisica_w	varchar(10);
nm_paciente_w		varchar(60);
ie_status_Agenda_w	varchar(3);
--nr_minuto_duracao_w	number(10);
hr_inicio_w		timestamp;

nr_seq_medico_regra_w	bigint;
nr_seq_status_pac_w	bigint;
nr_atendimento_w		bigint;
cd_convenio_ww		integer;
ds_motivo_w			varchar(255);

/* obter horarios livres */

c01 CURSOR FOR
SELECT	'N' ie_horario,
	nr_sequencia,
	hr_inicial,
	hr_final,
	hr_inicial_intervalo,
	hr_final_intervalo,
	nr_minuto_intervalo,
	nr_seq_medico_exec,
	cd_medico,
	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	nr_seq_classif_agenda,
	nr_seq_sala,
	ds_observacao,
	cd_procedencia,
	cd_convenio,
	cd_categoria,
	coalesce(nr_prioridade,9999) nr_prioridade,
	nr_seq_transporte,
	ie_lado,
	ie_forma_agendamento
from 	agenda_horario
where 	cd_agenda = cd_agenda_p
and	to_char(hr_inicial,'hh24:mi:ss') < to_char(hr_final,'hh24:mi:ss')
and	((coalesce(dt_inicio_vigencia::text, '') = '') or (trunc(dt_inicio_vigencia) <= trunc(dt_agenda_p)))
and	((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia) >= trunc(dt_agenda_p)))
and	nr_minuto_intervalo > 0
and	((dt_dia_semana = ie_dia_semana_w) or ((dt_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))))
and	((((ie_feriado_w <> 'S') and (coalesce(ie_feriado,'X') <> 'F')) or (coalesce(ie_feriado,obter_se_agenda_feriado(cd_agenda_p)) = 'S')) or (ie_feriado = 'F' AND ie_feriado_w = 'S'))
and	((nr_seq_especial_w = 0) or (ie_horario_adicional_w = 'S'))
and	obter_se_gerar_turno_agecons(dt_inicio_vigencia,ie_frequencia,dt_agenda_p) = 'S'
and	((Obter_Semana_Dia(dt_agenda_p) = coalesce(ie_semana,0)) or (coalesce(ie_semana,0) = 0))

union

SELECT	'E' ie_horario,
	nr_sequencia,
	hr_inicial,
	hr_final,
	hr_inicial_intervalo,
	hr_final_intervalo,
	nr_minuto_intervalo,
	nr_seq_medico_exec,
	cd_medico,
	0,
	0,
	0,
	nr_seq_classif_agenda,
	nr_seq_sala,
	--'' ds_observacao *** Rafael 3/3/8 OS81458 ***
	ds_observacao,
	null,
	null,
	null,
	9999 nr_prioridade,
	null,
	null,
	null
from	agenda_horario_esp
where 	cd_agenda = cd_agenda_p
and	to_char(hr_inicial,'hh24:mi:ss') < to_char(hr_final,'hh24:mi:ss')
and	nr_minuto_intervalo > 0
and	((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))) or (coalesce(ie_dia_semana::text, '') = ''))
and dt_agenda_p between pkg_date_utils.start_of(dt_agenda,'DAY') and pkg_date_utils.end_of(coalesce(dt_agenda_fim,dt_agenda),'DAY')
order by
	nr_prioridade,1, 2;

/* obter dados sobra horario */

c02 CURSOR FOR
SELECT	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
	nr_minuto_intervalo,
	cd_procedencia,
	'1' ie_origem_dados
from 	agenda_horario
where 	cd_agenda = cd_agenda_p
and	to_char(hr_inicial,'hh24:mi:ss') < to_char(hr_final,'hh24:mi:ss')
and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_agenda_p)))
and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p)))
and	nr_minuto_intervalo > 0
and	((dt_dia_semana = ie_dia_semana_w) or ((dt_dia_semana = 9) and (ie_dia_semana_w not in (1,7))))
and	((((ie_feriado_w <> 'S') and (coalesce(ie_feriado,'X') <> 'F')) or (coalesce(ie_feriado,obter_se_agenda_feriado(cd_agenda_p)) = 'S')) or (ie_feriado = 'F' AND ie_feriado_w = 'S'))
and	((nr_seq_especial_w = 0) or (ie_horario_adicional_w = 'S'))
and	obter_se_gerar_turno_agecons(dt_inicio_vigencia,ie_frequencia,dt_agenda_p) = 'S'

union

SELECT	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
	nr_minuto_intervalo,
	null,
	'2' ie_origem_dados
from 	agenda_horario_esp
where 	cd_agenda = cd_agenda_p
and	to_char(hr_inicial,'hh24:mi:ss') < to_char(hr_final,'hh24:mi:ss')
and	nr_minuto_intervalo > 0
and	((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))) or (coalesce(ie_dia_semana::text, '') = ''))
and dt_agenda_p between pkg_date_utils.start_of(dt_agenda,'DAY') and pkg_date_utils.end_of(coalesce(dt_agenda_fim,dt_agenda),'DAY')
order by
	1,2;

/* obter sobra horario */

c03 CURSOR FOR
SELECT	/*+index(b AGEPACI_UK)*/	b.dt_agenda hr_inicial,
	b.dt_agenda + b.nr_minuto_duracao / 1440 hr_final,
	((b.dt_agenda + b.nr_minuto_duracao / 1440) - b.dt_agenda) * 1440 nr_minuto_horario,
	b.cd_medico_exec,
	null
from	agenda a,
	ageint_consulta_horarios b
where	a.cd_agenda = b.cd_agenda
and	b.cd_agenda = cd_agenda_p
and	trunc(b.dt_agenda) between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400
and	a.ie_gerar_sobra_horario = 'S'
and	b.ie_status_agenda not in ('C','LF')
order by
	1,2;
	
C04 CURSOR FOR
	SELECT	dt_horario,
		nr_minuto_duracao
	from	agenda_horario_adicional
	where	cd_agenda		= cd_agenda_p
	and	trunc(dt_horario) 	= trunc(dt_agenda_p)
	order by 1;
	
C05 CURSOR FOR
	SELECT	cd_pessoa_fisica,
		nm_paciente,
		cd_medico_exec,
		ie_status_agenda,
		nr_minuto_duracao,
		hr_inicio,
		nr_seq_status_pac,
		cd_procedimento,
		ie_origem_proced,
		nr_seq_proc_interno,
		nr_sequencia,
		nr_atendimento,
		cd_convenio,
		cd_turno,
		coalesce(ie_encaixe,'N'),
		SUBSTR(obter_motivo_agenda(nr_sequencia),1,255)
	from	agenda_paciente
	where	cd_agenda		= cd_agenda_p
	and	ie_status_agenda	<> 'L'
	and	trunc(dt_agenda)		= trunc(dt_agenda_p)
	order by hr_inicio;


BEGIN

delete	FROM ageint_consulta_horarios
where	cd_agenda	= cd_agenda_p
and	nm_usuario	= nm_usuario_p
and	dt_agenda	between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 83699/86400;

select	coalesce(max(ie_gerar_hor_bloq),'N'),
	max(ie_tipo_consist_horario)
into STRICT	ie_gerar_hor_bloq_w,
	ie_tipo_consist_horario_w
from	agenda
where	cd_agenda	= cd_agenda_p;

ie_excluir_livres_w := obter_param_usuario(820, 113, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_excluir_livres_w);

/* obter dia semana */

select	obter_cod_dia_semana(dt_agenda_p)
into STRICT	ie_dia_semana_w
;

ie_medico_executor_w := Obter_Param_Usuario(820, 62, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_medico_executor_w);

ie_gerar_hor_agenda_ant_w := Obter_Param_Usuario(820, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_hor_agenda_ant_w);

ie_autorizacao_w := Obter_Param_Usuario(820, 114, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_autorizacao_w);

ie_limpa_obs_especial_w := Obter_Param_Usuario(820, 125, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_limpa_obs_especial_w);

ie_gerar_nome_w := Obter_Param_Usuario(820, 162, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_nome_w);

ie_gerar_hor_falta_w := Obter_Param_Usuario(820, 176, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_hor_falta_w);

/* verificar feriado */

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_feriado_w
from 	feriado a, 
	agenda b
where 	a.cd_estabelecimento = cd_estabelecimento_p
and	a.dt_feriado = dt_agenda_p
and 	b.cd_agenda = cd_agenda_p;


/* obter dados horario especial (se existir) */

select	coalesce(max(nr_sequencia),0),
	coalesce(max(ie_horario_adicional),'N')
into STRICT	nr_seq_especial_w,
	ie_horario_adicional_w
from	agenda_horario_esp
where	cd_agenda = cd_agenda_p
and	((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))) or (coalesce(ie_dia_semana::text, '') = ''))
and dt_agenda_p between pkg_date_utils.start_of(dt_agenda,'DAY') and pkg_date_utils.end_of(coalesce(dt_agenda_fim,dt_agenda),'DAY');

open C05;
loop
fetch C05 into	
	cd_pessoa_fisica_w,
	nm_paciente_w,
	cd_medico_exec_w,
	ie_status_agenda_w,
	nr_minuto_duracao_w,
	hr_inicio_w,
	nr_seq_status_pac_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_seq_proc_interno_w,
	nr_seq_agenda_w,
	nr_atendimento_w,
	cd_convenio_ww,
	cd_turno_ww,
	ie_encaixe_w,
	ds_motivo_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	begin
	
	select	max(nr_seq_medico_regra)
	into STRICT	nr_seq_medico_regra_w
	from	agenda_medico
	where	cd_agenda	= cd_agenda_p
	and	cd_medico	= cd_medico_exec_w;
	
	
	insert into ageint_consulta_horarios(dt_Atualizacao,
		nm_usuario,
		cd_agenda,
		cd_medico_exec,
		cd_paciente,
		nm_paciente,
		ie_status_agenda,
		nr_minuto_duracao,
		dt_agenda,
		nr_seq_medico_regra,
		nr_seq_status_pac,
		cd_procedimento,
		ie_origem_proced,
		nr_seq_proc_interno,
		nr_seq_agenda,
		nr_atendimento,
		cd_convenio,
		cd_turno,
		ie_encaixe,
		ds_motivo)
	values (clock_timestamp(),
		nm_usuario_p,
		cd_Agenda_p,
		cd_medico_exec_w,
		cd_pessoa_fisica_w,
		nm_paciente_w,
		ie_status_Agenda_w,
		nr_minuto_duracao_w,
		hr_inicio_w,
		nr_seq_medico_regra_w,
		nr_seq_status_pac_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_proc_interno_w,
		nr_seq_agenda_w,
		nr_atendimento_w,
		cd_convenio_ww,
		cd_turno_ww,
		ie_encaixe_w,
		ds_motivo_w);
	
	end;
end loop;
close C05;

open C04;
loop
fetch C04 into	
	dt_hor_adic_w,
	nr_min_dur_adic_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
	
			select	/*+index(a AGEPACI_UK)*/				CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
			into STRICT	ie_horario_w
			from	ageint_consulta_horarios a
			where	a.cd_agenda = cd_agenda_p
			and	trunc(a.dt_agenda) = trunc(dt_agenda_p,'dd')
			and	a.dt_agenda = dt_hor_adic_w
			and	a.ie_status_agenda not in ('C','LF');

			/* consistir horario gerado e ja utilizado x minutos duracao alterado */

			if (ie_horario_w = 'S') then
				select	/*+index(a AGEPACI_UK)*/					CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
				into STRICT	ie_horario_w
				from	ageint_consulta_horarios a
				where	a.cd_agenda = cd_agenda_p
				--and	a.dt_agenda = trunc(dt_agenda_p,'dd')
				and	a.dt_agenda < dt_hor_adic_w
				and	a.dt_agenda + a.nr_minuto_duracao / 1440 > dt_hor_adic_w
				and	trunc(a.dt_agenda) = trunc(dt_hor_adic_w, 'dd')
				and	a.ie_status_agenda not in ('C','LF');
			end if;

			/* consistir bloqueio */

			ie_bloqueio_w := consistir_bloqueio_agenda(cd_agenda_p, dt_hor_adic_w, ie_dia_semana_w, ie_bloqueio_w);

			if (ie_horario_w = 'S') and
				((ie_bloqueio_w = 'N') or (ie_gerar_hor_bloq_w = 'S')) then
				/* obter sequencia */


				/*select	agenda_paciente_seq.nextval
				into	nr_seq_agenda_w
				from	dual;*/


				/* obter turno horario */

				select	obter_turno_horario_agenda(cd_agenda_p, to_char(dt_hor_adic_w,'hh24:mi:ss'))
				into STRICT	cd_turno_w
				;

				select 	max(nr_seq_proc_interno)
				into STRICT	nr_seq_proc_interno_w
				from	agenda_horario
				where	nr_sequencia = cd_turno_w;
				
				/* inserir registros */

				
				select	obter_executor_agenda_exame(nr_seq_medico_exec_w)
				into STRICT	cd_medico_executor_w
				;				
								
				if (coalesce(cd_medico_executor_w::text, '') = '') and (ie_medico_executor_w = 'S') then
					select	max(cd_medico)
					into STRICT	cd_medico_executor_w
					from	agenda_medico
					where	cd_agenda	= cd_agenda_p;
				end if;
				
				
				select	CASE WHEN nr_minuto_orig_w=0 THEN  nr_minuto_duracao_w  ELSE nr_minuto_orig_w END
				into STRICT	nr_minuto_min_w
				;
				
							
				ds_erro_w := consistir_horario_medico_ger(nr_seq_agenda_w, cd_medico_executor_w, nr_minuto_min_w, dt_hor_adic_w, cd_agenda_p, ds_erro_w);
				
				if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') THEN
				
					ie_bloqueio_w	:= 'S';
				
				end if;
				
				/*Bruna em 03/03/2009 OS 130376*/

				select	count(*)
				into STRICT	qt_agenda_w
				from	agenda_paciente
				where	cd_agenda		= cd_agenda_p
				and	dt_agenda		= trunc(dt_agenda_p-1,'dd')
				and	dt_hor_adic_w between hr_inicio and hr_inicio + ((nr_minuto_duracao-1) / 1440)
				and	ie_status_agenda not in ('L','C','B')
				and (ie_gerar_hor_agenda_ant_w = 'S');
				
				select	max(nr_seq_medico_regra)
				into STRICT	nr_seq_medico_regra_w
				from	agenda_medico
				where	cd_agenda	= cd_agenda_p
				and	cd_medico	= cd_medico_executor_w;
			
				if (qt_agenda_w = 0) then	
					insert into ageint_consulta_horarios(dt_Atualizacao,
						nm_usuario,
						cd_agenda,
						cd_medico_exec,
						cd_paciente,
						nm_paciente,
						ie_status_agenda,
						nr_minuto_duracao,
						dt_Agenda,
						nr_seq_medico_regra,
						cd_turno,
						ie_encaixe,
						nr_seq_proc_interno)
					values (clock_timestamp(),
						nm_usuario_p,
						cd_Agenda_p,
						cd_medico_executor_w,
						null,
						null,
						CASE WHEN ie_bloqueio_w='S' THEN  'B'  ELSE 'L' END ,
						nr_min_dur_adic_w,
						dt_hor_adic_w,
						nr_seq_medico_regra_w,
						cd_turno_w,
						'N',
						nr_seq_proc_interno_w);
				end if;
			end if;
	
	
	end;
end loop;
close C04;

/* gerar horarios livres */

open c01;
loop
fetch c01 into	ie_tipo_horario_w,
			nr_seq_horario_w,
			hr_inicial_dia_w,
			hr_final_dia_w,
			hr_inicial_intervalo_w,
			hr_final_intervalo_w,
			nr_minuto_duracao_w,
			nr_seq_medico_exec_w,
			cd_medico_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_proc_interno_w,
			nr_seq_classif_w,
			nr_seq_sala_w,
			ds_observacao_w,
			cd_procedencia_w,
			cd_convenio_w,
			cd_categoria_w,
			nr_prioridade_w,
			nr_seq_transporte_w,
			ie_lado_w,
			ie_forma_agendamento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	

	begin

	hr_inicial_dia_w := to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicial_dia_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	hr_final_dia_w	 := to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final_dia_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	hr_inicial_intervalo_w := to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicial_intervalo_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	hr_final_intervalo_w :=	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final_intervalo_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	
	--Bruno - Busca da regra se existe uma regra para o perfil (transporte)
	select	count(*)
	into STRICT	qt_regra_w
	from	regra_valor_padrao_agenda
	where	cd_perfil = obter_perfil_ativo;
	
	if (qt_regra_w > 0) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_regra_transp_w
		from	regra_valor_padrao_agenda
		where	cd_perfil = obter_perfil_ativo;
		
		select 	nr_seq_transporte
		into STRICT	nr_seq_transporte_w
		from	regra_valor_padrao_agenda
		where	nr_sequencia = nr_seq_regra_transp_w;
	end if;
	--
	
	
	hr_horario_w := hr_inicial_dia_w;
	while(hr_horario_w < hr_final_dia_w) loop
		begin
				
		if	(((hr_horario_w < hr_inicial_intervalo_w) or (hr_horario_w >= hr_final_intervalo_w)) or
			((coalesce(hr_inicial_intervalo_w::text, '') = '') and (coalesce(hr_final_intervalo_w::text, '') = ''))) and (hr_horario_w > clock_timestamp()) then
			/* consistir horario gerado e ja utilizado */

			
			if (ie_gerar_hor_falta_w = 'S') then
				select	/*+index(a AGEPACI_UK)*/					CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
				into STRICT	ie_horario_w
				from	ageint_consulta_horarios a
				where	a.cd_agenda = cd_agenda_p
				and	trunc(a.dt_agenda) = trunc(dt_agenda_p,'dd')
				and	a.dt_agenda = hr_horario_w
				and	a.ie_status_agenda not in ('C','LF','F','I');
			else
				select	/*+index(a AGEPACI_UK)*/					CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
				into STRICT	ie_horario_w
				from	ageint_consulta_horarios a
				where	a.cd_agenda = cd_agenda_p
				and	trunc(a.dt_agenda) = trunc(dt_agenda_p,'dd')
				and	a.dt_agenda = hr_horario_w
				and	a.ie_status_agenda not in ('C','LF');
			end if;

			/* consistir horario gerado e ja utilizado x minutos duracao alterado */

			if (ie_horario_w = 'S') then
				
				if (ie_gerar_hor_falta_w = 'S') then
					select	/*+index(a AGEPACI_UK)*/						CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
					into STRICT	ie_horario_w
					from	ageint_consulta_horarios a
					where	a.cd_agenda = cd_agenda_p
					and	a.dt_Agenda < hr_horario_w
					and	a.dt_Agenda + a.nr_minuto_duracao / 1440 > hr_horario_w
					and	trunc(a.dt_agenda) = trunc(hr_horario_w, 'dd')
					and	a.ie_status_agenda not in ('C','LF','F','I');
				else
					select	/*+index(a AGEPACI_UK)*/						CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
					into STRICT	ie_horario_w
					from	ageint_consulta_horarios a
					where	a.cd_agenda = cd_agenda_p
					and	a.dt_agenda < hr_horario_w
					and	a.dt_agenda + a.nr_minuto_duracao / 1440 > hr_horario_w
					and	trunc(a.dt_agenda) = trunc(hr_horario_w, 'dd')
					and	a.ie_status_agenda not in ('C','LF');
				end if;
				
			--elsif	(ie_tipo_horario_w = 'E') then			

				--gerar_horario_esp_agenda(cd_agenda_p, dt_agenda_p, hr_horario_w, nr_seq_horario_w,nm_usuario_p,cd_estabelecimento_p);
			end if;
			
			/* consistir bloqueio */

			ie_bloqueio_w := consistir_bloqueio_agenda(cd_agenda_p, hr_horario_w, ie_dia_semana_w, ie_bloqueio_w);
			
			if (ie_horario_w = 'S') and
				((ie_bloqueio_w = 'N') or (ie_gerar_hor_bloq_w = 'S')) then
				/* obter sequencia */


				/*select	agenda_paciente_seq.nextval
				into	nr_seq_agenda_w
				from	dual;*/


				/* obter turno horario */

				select	obter_turno_horario_agenda(cd_agenda_p, to_char(hr_horario_w,'hh24:mi:ss'))
				into STRICT	cd_turno_w
				;

				/* validar duracao horario */


				/*
				select	validar_duracao_horario_agenda(cd_agenda_p, hr_horario_w, nr_minuto_duracao_w)
				into	nr_minuto_orig_w
				from	dual;
				*/
			

				/* inserir registros */

				
				select	obter_executor_agenda_exame(nr_seq_medico_exec_w)
				into STRICT	cd_medico_executor_w
				;				
								
				if (coalesce(cd_medico_executor_w::text, '') = '') and (ie_medico_executor_w = 'S') then
					select	max(cd_medico)
					into STRICT	cd_medico_executor_w
					from	agenda_medico
					where	cd_agenda	= cd_agenda_p;
				end if;
				
				
				select	CASE WHEN nr_minuto_orig_w=0 THEN  nr_minuto_duracao_w  ELSE nr_minuto_orig_w END
				into STRICT	nr_minuto_min_w
				;
				
							
				ds_erro_w := consistir_horario_medico_ger(nr_seq_agenda_w, cd_medico_executor_w, nr_minuto_min_w, hr_horario_w, cd_agenda_p, ds_erro_w);
				
				if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') THEN
				
					ie_bloqueio_w	:= 'S';
				
				end if;
				
				/*Bruna em 03/03/2009 OS 130376*/

				select	count(*)
				into STRICT	qt_agenda_w
				from	agenda_paciente
				where	cd_agenda		= cd_agenda_p
				and	trunc(dt_agenda)		= trunc(dt_agenda_p-1,'dd')
				and	hr_horario_w between hr_inicio and hr_inicio + ((nr_minuto_duracao-1) / 1440)
				and	ie_status_agenda not in ('L','C','B')
				and (ie_gerar_hor_agenda_ant_w = 'S');
				
				if (qt_agenda_w = 0) then	

				
					if (ie_bloqueio_w <> 'S') and (ie_tipo_horario_w = 'E') and (ie_limpa_obs_especial_w = 'S') then		
						ds_observacao_w := '';
					end if;
					
					select	max(nr_seq_medico_regra)
					into STRICT	nr_seq_medico_regra_w
					from	agenda_medico
					where	cd_agenda	= cd_agenda_p
					and	cd_medico	= cd_medico_executor_w;
			
					insert into ageint_consulta_horarios(dt_Atualizacao,
						nm_usuario,
						cd_agenda,
						cd_medico_exec,
						cd_paciente,
						nm_paciente,
						ie_status_agenda,
						nr_minuto_duracao,
						dt_Agenda,
						nr_seq_medico_regra,
						cd_turno,
						ie_encaixe,
						nr_seq_proc_interno)
					values (clock_timestamp(),
						nm_usuario_p,
						cd_Agenda_p,
						cd_medico_executor_w,
						null,
						null,
						CASE WHEN ie_bloqueio_w='S' THEN  'B'  ELSE 'L' END ,
						CASE WHEN nr_minuto_orig_w=0 THEN  nr_minuto_duracao_w  ELSE nr_minuto_orig_w END ,
						hr_horario_w,
						nr_seq_medico_regra_w,
						cd_turno_w,
						'N',
						CASE WHEN nr_seq_proc_interno_w=0 THEN null  ELSE nr_seq_proc_interno_w END );
				end if;
				
			end if;
		end if;
		/* atualizar horario a ser gerado */

		if	((hr_horario_w + nr_minuto_duracao_w / 1440) >= hr_inicial_intervalo_w) and
			((hr_horario_w + nr_minuto_duracao_w / 1440) < hr_final_intervalo_w) then
			hr_horario_w := hr_final_intervalo_w;
		else
			hr_horario_w := hr_horario_w + nr_minuto_duracao_w / 1440;
		end if;
		end;
	end loop;
	end;
end loop;
close c01;

ds_observacao_w		:= '';

/* gerar dados sobra horario */

open c02;
loop
fetch c02 into	hr_inicial_dia_w,
			hr_final_dia_w,
			nr_minuto_duracao_w,
			cd_procedencia_w,
			ie_origem_dados_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	/* gerar sobra horario */

	open c03;
	loop
	fetch c03 into	hr_horario_inicial_w,
			hr_horario_final_w,
			nr_minuto_horario_w,
			cd_medico_exec_sobra_w,
			nr_seq_classif_sobra_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		if (nr_minuto_horario_w = nr_minuto_duracao_w) and (hr_horario_ant_sobra_w IS NOT NULL AND hr_horario_ant_sobra_w::text <> '') and
			((hr_horario_ant_sobra_w + nr_minuto_duracao_w / 1440) < hr_horario_final_w) then
			hr_horario_final_w	:= hr_horario_final_w - ((hr_horario_final_w - hr_horario_ant_sobra_w) * 1440 / 1440);
			nr_minuto_horario_w	:= (hr_horario_final_w - hr_horario_ant_sobra_w) * 1440;
		end if;

		hr_horario_ant_sobra_w	:= hr_horario_final_w;
		
		if (nr_minuto_horario_w <> nr_minuto_duracao_w) and
			((ie_origem_dados_w = '1' AND hr_inicial_dia_w <= hr_horario_final_w) or (ie_origem_dados_w <> '1'))  then
			hr_horario_sobra_w := hr_horario_final_w;
			if (nr_minuto_horario_w < nr_minuto_duracao_w) then
				nr_minuto_sobra_w := nr_minuto_duracao_w - nr_minuto_horario_w;
			else
				select	trunc(dividir(nr_minuto_horario_w, nr_minuto_duracao_w))
				into STRICT	qt_horario_sobra_w
				;

				select (qt_horario_sobra_w * nr_minuto_duracao_w) - (nr_minuto_horario_w - nr_minuto_duracao_w)
				into STRICT	nr_minuto_sobra_w
				;
			end if;
			
			if	(((hr_horario_sobra_w < hr_inicial_intervalo_w) or (hr_horario_sobra_w >= hr_final_intervalo_w)) or
				((coalesce(hr_inicial_intervalo_w::text, '') = '') and (coalesce(hr_final_intervalo_w::text, '') = ''))) and (hr_horario_sobra_w > clock_timestamp()) and
				((hr_horario_sobra_w < hr_final_dia_w) or (hr_horario_sobra_w + nr_minuto_sobra_w / 1400 <= hr_final_dia_w + nr_minuto_duracao_w / 1440)) then
				
				/* consistir horario gerado e ja utilizado */

				select	/*+index(a AGEPACI_UK)*/					CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
				into STRICT	ie_horario_w
				from	ageint_consulta_horarios a
				where	a.cd_agenda = cd_agenda_p
				and	trunc(a.dt_agenda) = trunc(dt_agenda_p,'dd')
				and	a.dt_Agenda = hr_horario_sobra_w
				and	a.ie_status_agenda not in ('C','LF');

				/* consistir horario gerado e ja utilizado x minutos duracao alterado */

				if (ie_horario_w = 'S') then
					select	/*+index(a AGEPACI_UK)*/						CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
					into STRICT	ie_horario_w
					from	ageint_consulta_horarios a
					where	a.cd_agenda = cd_agenda_p
					--and	a.dt_agenda = trunc(dt_agenda_p,'dd')
					and	a.dt_Agenda < hr_horario_sobra_w
					and	a.dt_Agenda + a.nr_minuto_duracao / 1440 > hr_horario_sobra_w
					and	trunc(a.dt_agenda) = trunc(hr_horario_sobra_w, 'dd')
					and	a.ie_status_agenda not in ('C','LF');
				end if;

				/* consistir bloqueio */

				ie_bloqueio_w := consistir_bloqueio_agenda(cd_agenda_p, hr_horario_sobra_w, ie_dia_semana_w, ie_bloqueio_w);

				if (ie_horario_w = 'S') and
					((ie_bloqueio_w = 'N') or (ie_gerar_hor_bloq_w = 'S')) then
					/* obter sequencia */


					/*select	agenda_paciente_seq.nextval
					into	nr_seq_agenda_w
					from	dual;*/


					/* obter turno horario */

					select	obter_turno_horario_agenda(cd_agenda_p, to_char(hr_horario_sobra_w,'hh24:mi:ss'))
					into STRICT	cd_turno_w
					;
					
					select 	max(nr_seq_proc_interno)
					into STRICT	nr_seq_proc_interno_w
					from	agenda_horario
					where	nr_sequencia = cd_turno_w;
					
					select	max(nr_seq_medico_regra)
					into STRICT	nr_seq_medico_regra_w
					from	agenda_medico
					where	cd_agenda	= cd_agenda_p
					and	cd_medico	= cd_medico_exec_sobra_w;
					
					/* inserir registros */
					
					insert into ageint_consulta_horarios(dt_Atualizacao,
						nm_usuario,
						cd_agenda,
						cd_medico_exec,
						cd_paciente,
						nm_paciente,
						ie_status_agenda,
						nr_minuto_duracao,
						dt_agenda,
						nr_seq_medico_regra,
						cd_turno,
						ie_encaixe,
						nr_seq_proc_interno)
					values (clock_timestamp(),
						nm_usuario_p,
						cd_Agenda_p,
						cd_medico_exec_sobra_w,
						null,
						null,
						CASE WHEN ie_bloqueio_w='S' THEN  'B'  ELSE 'L' END ,
						nr_minuto_sobra_w,
						hr_horario_sobra_w,
						nr_seq_medico_regra_w,
						cd_turno_w,
						'N',
						nr_seq_proc_interno_w);
				end if;
			end if;
		end if;
		end;
	end loop;
	close c03;
	end;
end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_consulta_ageexam (cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, nm_usuario_p text) FROM PUBLIC;
