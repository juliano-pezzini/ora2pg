-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_horario_otimizado ( cd_estabelecimento_p bigint, dt_agenda_p timestamp, dt_final_p timestamp, qt_minutos_p bigint, hr_inicial_p text, hr_final_p text, ds_restricao_p text, nm_usuario_p text, ie_grava_Livre_p text, ds_horarios_p INOUT text) AS $body$
DECLARE

			

ie_feriado_w			varchar(0001)	:= 'N';
ie_dia_semana_w			smallint;
hr_inicial_w			timestamp;
hr_final_w			timestamp;
hr_inicial_intervalo_w		timestamp;
hr_final_intervalo_w		timestamp;
hr_atual_w			timestamp;
nr_minuto_intervalo_w		smallint;
ie_existe_agenda_w		varchar(0001);
ie_bloqueio_w			varchar(0001);
ie_bloqueio_hora_w		varchar(0001);
ie_bloqueio_dia_w		varchar(0001);
qt_horario_w			smallint    := 0;
nr_sequencia_w			bigint    := 0;
dt_agenda_w			timestamp;
ds_horarios_w			varchar(0255)	:= '';
Virgula_w			varchar(1)		:= '';
qt_min_duracao_w		bigint	:= 0;
hr_inicio_w			timestamp;
hr_fim_w			timestamp;
hr_inicial_par_w		timestamp;
hr_final_par_w			timestamp;
cd_turno_w			smallint	:= 0;
nr_seq_esp_w			bigint	:= 0;
cd_medico_w			varchar(10);
nr_seq_agenda_medico_w		bigint;
cd_medico_exec_w		varchar(10);
qt_min_minimo_w			bigint;
qt_turno_w			bigint;
qt_intervalo_w			bigint;
HR_NADA_W			timestamp;
ie_sobra_horario_w		varchar(01);
ie_bloqueio_dia_hora_w		varchar(01);
ds_observacao_horario_w		varchar(255);
ie_gerar_obs_horario_w		varchar(01) := 'N';
ie_autorizacao_w		varchar(05);
ie_excluir_livres_w		varchar(01) 	:= 'N';
qt_agenda_w			bigint;
HR_QUEBRA_TURNO_W		varchar(05);
hr_quebra_turno_not_w		varchar(05);
qt_min_QUEBRA_TURNO_W		varchar(05);
nr_seq_sala_w			bigint;
ie_anestesista_w		varchar(01)	:= 'N';
ie_gerar_forcado_w		varchar(01)	:= 'N';
ie_gerar_autorizacao_livres_w	varchar(01)	:= 'N';
cd_anestesista_w		varchar(10);
dt_forcado_w			timestamp;
nr_min_forcado_w		bigint;
cd_agenda_forcado_w		bigint;
ie_tipo_atendimento_w		smallint;/* Rafael em 16/10/2006 OS 42479 */
ie_horario_adicional_w		varchar(1);/* Rafael em 09/11/2006 OS 43852 */
NR_SEQ_CLASSIF_AGENDA_w		bigint;
qt_horario_livre_gerado_w	bigint;
ie_carater_cirurgia_w		varchar(1);
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
nr_seq_agenda_w			agenda_paciente.nr_sequencia%type;
nm_paciente_w			varchar(60);
ie_status_agenda_w		varchar(1);
ie_gerar_bloqueados_w		varchar(1);
ie_deletar_bloqueados_w		varchar(1);
ie_gerar_dia_anterior_w		varchar(1);			
cd_agenda_w			bigint;

-- /***** Cursores ********/ 
C000 CURSOR FOR
	SELECT	cd_agenda
	from	agenda
	order by cd_agenda;
	
C01 CURSOR FOR
	SELECT 	a.cd_agenda,
		to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
			to_char(a.hr_inicial,'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
		 	to_char(a.hr_final,'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
		 	to_char(coalesce(a.hr_Inicial_Intervalo,a.hr_final),'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
		 	to_char(coalesce(a.hr_final_Intervalo,a.hr_final),'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			CASE WHEN coalesce(qt_minutos_p,0)=0 THEN  a.nr_minuto_intervalo  ELSE qt_minutos_p END ,
			a.cd_medico,
			a.nr_seq_medico_exec,
			a.ds_observacao,
			a.nr_seq_sala,
			a.nr_seq_classif_agenda,
			a.cd_anestesista,
			a.ie_carater_cirurgia,
			a.cd_convenio,
			a.cd_categoria
	from 		agenda_Horario a
	where		((a.dt_dia_semana	= ie_dia_Semana_w) or ((a.dt_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))))
	and		((coalesce(a.dt_final_vigencia::text, '') = '') or (a.dt_final_vigencia >= trunc(dt_agenda_p)))
	and		((coalesce(a.dt_inicio_vigencia::text, '') = '') or (a.dt_inicio_vigencia <= trunc(dt_agenda_p)))
	and 		a.hr_inicial < hr_final
	and		coalesce(a.nr_minuto_intervalo,0) > 0
	
union

	SELECT 		a.cd_agenda,
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
			to_char(a.hr_inicial,'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
		 	to_char(a.hr_final,'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
		 	to_char(coalesce(a.hr_Inicial_Intervalo,a.hr_final),'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
		 	to_char(coalesce(a.hr_final_Intervalo,a.hr_final),'hh24:mi'),'dd/mm/yyyy hh24:mi'),
			a.nr_minuto_intervalo,
			a.cd_medico, a.nr_seq_medico_exec,
			a.ds_observacao,
			a.nr_seq_sala,
			a.NR_SEQ_CLASSIF_AGENDA,
			null,
			null,
			null,
			null
	from 		agenda_Horario_esp a
	where 		a.dt_agenda	= trunc(dt_agenda_p,'dd')
	and 		a.hr_inicial < hr_final
	and		coalesce(a.nr_minuto_intervalo,0) > 0
	order by 1,2,5,6;

C02 CURSOR FOR
	SELECT	a.cd_agenda,
		a.hr_inicio,
		(a.hr_inicio + (CASE WHEN a.ie_status_agenda='C' THEN  0  ELSE a.nr_minuto_duracao / 1440 END )) dt_final
	from 	agenda_paciente a
        where	a.hr_inicio between trunc(dt_agenda_p,'dd') and (trunc(dt_agenda_p,'dd') + (86399/86400))
	and	a.hr_inicio >= clock_timestamp()
	order by 1,2;

c03 CURSOR FOR
	SELECT	a.dt_agenda,
		a.nr_minuto_duracao,
		a.cd_agenda
	from	agenda_livre_forcado a
	where	a.dt_agenda	between trunc(dt_agenda_p,'dd') and (trunc(dt_agenda_p,'dd') + (86399/86400))
	and	a.dt_agenda > trunc(clock_timestamp() - interval '1 days', 'dd')
	and	not exists (SELECT	1
		from	agenda_paciente x
		where	x.cd_agenda		= a.cd_agenda
		and	x.hr_inicio		= a.dt_agenda
		and	x.ie_status_agenda	in ('LF', 'N', 'E'))
	group by a.dt_agenda,
		 a.nr_minuto_duracao,
		 a.cd_agenda;

C04 CURSOR FOR
	SELECT	a.nr_sequencia
	from	autor_convenio_evento b,
		agenda_paciente a
	where	a.nr_sequencia 	= b.nr_seq_agenda
	and	a.dt_agenda 	= trunc(dt_agenda_p,'dd')
	and 	a.ie_status_agenda		= 'L';
	

BEGIN
ie_gerar_bloqueados_w := obter_param_usuario(871, 297, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_bloqueados_w);
ie_deletar_bloqueados_w := obter_param_usuario(871, 369, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_deletar_bloqueados_w);
ie_gerar_dia_anterior_w := obter_param_usuario(871, 423, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_dia_anterior_w);

if (coalesce(hr_inicial_p::text, '') = '') then
	hr_inicial_par_w		:= trunc(dt_agenda_p,'dd');
else
	hr_inicial_par_w		:= to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
					hr_inicial_p,'dd/mm/yyyy hh24:mi');
end if;
if (coalesce(hr_final_p::text, '') = '') then
	hr_final_par_w			:= trunc(dt_agenda_p,'dd') + 86399/86400;
else
	hr_final_par_w			:= to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
					hr_final_p,'dd/mm/yyyy hh24:mi');
end if;

dt_agenda_w				:= trunc(dt_agenda_p,'dd');

select	pkg_date_utils.get_WeekDay(dt_agenda_w)
into STRICT 	ie_dia_semana_w
;

open C000;
loop
fetch C000 into	
	cd_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C000 */
	begin
	Delete /*+ INDEX(A AGEPACI_UK) */	from 	agenda_paciente a
	where 	cd_agenda 	= cd_agenda_w
	and 	dt_agenda 	>= clock_timestamp()
	and 	ie_status_agenda	= 'L';	
	commit;
	
	if (ie_deletar_bloqueados_w = 'S') and (ie_gerar_bloqueados_w = 'S') then
	delete
	from 	agenda_paciente a
	where 	cd_agenda 	= cd_agenda_w
	and 	dt_agenda 	>= clock_timestamp()
	and 	ie_status_agenda	= 'B'
	and	nm_paciente		= Wheb_mensagem_pck.get_texto(300737); --'Horario bloqueado';
	
	end if;

	end;
end loop;
close C000;
commit;
open C04;
Loop
	Fetch C04 into	
		nr_seq_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */

	update	autor_convenio_evento
	set	nr_seq_agenda  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_agenda = nr_seq_agenda_w;
end loop;
Close C04;

commit;

OPEN C01;
LOOP
FETCH C01 into
	cd_agenda_w,
	hr_inicial_w,
	hr_final_w,
	hr_inicial_Intervalo_w,
	hr_final_Intervalo_w,
	nr_minuto_Intervalo_w,
	cd_medico_w,
	nr_seq_agenda_medico_w,
	ds_observacao_horario_w,
	nr_seq_sala_w,
	nr_seq_classif_agenda_w,
	cd_anestesista_w,
	ie_carater_cirurgia_w,
	cd_convenio_w,
	cd_categoria_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
     	begin

	select 	coalesce(max('S'),'N')
	into STRICT	ie_feriado_w
	from 	feriado a,
		agenda b
	where 	a.cd_estabelecimento 	= cd_estabelecimento_p
	and 	a.dt_feriado		= dt_agenda_w
	and 	b.cd_agenda		= cd_agenda_w
	and 	ie_feriado		= 'N';

	select	coalesce(max(ie_gerar_sobra_horario), 'N'),
		coalesce(max(HR_QUEBRA_TURNO), '12'),
		coalesce(max(qt_min_quebra_turno), '00'),
		max(ie_anestesista),
		coalesce(max(ie_tipo_atendimento), 0),
		max(hr_quebra_turno_not)
	into STRICT	ie_sobra_horario_w,
		HR_QUEBRA_TURNO_W,	
		qt_min_QUEBRA_TURNO_W,
		ie_anestesista_w,
		ie_tipo_atendimento_w,
		hr_quebra_turno_not_w
	from	agenda
	where	cd_agenda	= cd_agenda_w;

	select	coalesce(max(nr_sequencia),0),
		coalesce(max(ie_horario_adicional),'N')
	into STRICT	nr_seq_esp_w,
		ie_horario_adicional_w
	from	agenda_horario_esp
	where	cd_agenda	= cd_agenda_w
	and	dt_agenda	= trunc(dt_agenda_p,'dd');

	if	((nr_seq_esp_w = 0) or (ie_horario_adicional_w = 'S')) and (ie_feriado_w <> 'S') then
		if (NR_SEQ_CLASSIF_AGENDA_w = 0) then
			NR_SEQ_CLASSIF_AGENDA_w := null;
		end if;
		hr_atual_w			:= hr_inicial_w;
		while(hr_atual_w	< hr_final_w) and (hr_atual_w	< hr_final_par_w)  loop
			BEGIN
			begin
			select	/*+ INDEX(A AGEPACI_UK) */				coalesce(max(nr_minuto_duracao),0)
			into STRICT	qt_min_duracao_w			
			from 	agenda_paciente a
			where 	cd_agenda			= cd_agenda_w
			and 	ie_status_agenda		<> 'C'
			and	dt_agenda			= trunc(hr_atual_w,'dd')
			and	to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
				to_char(hr_inicio,'hh24:mi'),'dd/mm/yyyy hh24:mi') <
				(hr_atual_w + (nr_minuto_intervalo_w / 1440))
			and	to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' ||
				to_char(hr_inicio + ((nr_minuto_duracao -1) / 1440),'hh24:mi'),
					'dd/mm/yyyy hh24:mi') >	hr_atual_w;
			exception
				when others then	
					qt_min_duracao_w		:= 0;
			end;
			

			/* bloqueio por periodo */

			select coalesce(max('S'),'N')
			into STRICT	ie_bloqueio_w
			from	agenda_bloqueio
			where	cd_agenda	= cd_agenda_w
			and	trunc(hr_atual_w) between dt_inicial and dt_final
			and	coalesce(ie_dia_semana::text, '') = ''
			and	coalesce(HR_INICIO_BLOQUEIO::text, '') = ''
			and	coalesce(HR_FINAL_BLOQUEIO::text, '') = '';

			/* bloqueio por horario */

			select coalesce(max('S'),'N')
			into STRICT	ie_bloqueio_hora_w
			from	agenda_bloqueio
			where	cd_agenda	= cd_agenda_w
			and	trunc(hr_atual_w) between dt_inicial and dt_final
			and	hr_atual_w between to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '|| to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
				and to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
			and	coalesce(ie_dia_semana::text, '') = ''
			and	(HR_INICIO_BLOQUEIO IS NOT NULL AND HR_INICIO_BLOQUEIO::text <> '')
			and	(HR_FINAL_BLOQUEIO IS NOT NULL AND HR_FINAL_BLOQUEIO::text <> '')
			and	hr_inicio_bloqueio < hr_final_bloqueio;

			/* bloqueio por dia */

			select coalesce(max('S'),'N')
			into STRICT	ie_bloqueio_dia_w
			from	agenda_bloqueio
			where	cd_agenda	= cd_agenda_w
			and	trunc(hr_atual_w) between dt_inicial and dt_final
			and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
			and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
			and	coalesce(HR_INICIO_BLOQUEIO::text, '') = ''
			and	coalesce(HR_FINAL_BLOQUEIO::text, '') = '';

			/* bloqueio dia e hora */

			select coalesce(max('S'),'N')
			into STRICT	ie_bloqueio_dia_hora_w
			from	agenda_bloqueio
			where	cd_agenda	= cd_agenda_w
			and	trunc(hr_atual_w) between dt_inicial and dt_final
			and	hr_atual_w between to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '|| to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
				and to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
			and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
			and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
			and	(HR_INICIO_BLOQUEIO IS NOT NULL AND HR_INICIO_BLOQUEIO::text <> '')
			and	(HR_FINAL_BLOQUEIO IS NOT NULL AND HR_FINAL_BLOQUEIO::text <> '')
			and	hr_inicio_bloqueio < hr_final_bloqueio;

			if (qt_min_duracao_w = 0) and (hr_atual_w >= clock_timestamp()) and (hr_atual_w >= hr_inicial_par_w)  and
				(((ie_bloqueio_w = 'N') and (ie_bloqueio_hora_w = 'N') and (ie_bloqueio_dia_w = 'N') and (ie_bloqueio_dia_hora_w = 'N')) or (ie_gerar_bloqueados_w = 'S'))  then
				begin
				if (coalesce(length(ds_horarios_w),0) < 249) then
					ds_horarios_w	:= ds_horarios_w || virgula_w ||
							to_char(hr_atual_w,'hh24:mi');
				end if;
				virgula_w		:= ',';
				if (ie_grava_livre_p = 'S') then
					begin
					cd_turno_w		:= 0;
				
					if ((to_char(hr_atual_w,'hh24'))::numeric  > somente_numero(HR_QUEBRA_TURNO_W)) or
						(((to_char(hr_atual_w,'hh24'))::numeric  = somente_numero(HR_QUEBRA_TURNO_W)) and ((to_char(hr_atual_w,'mi'))::numeric  >= somente_numero(qt_min_QUEBRA_TURNO_W))) then
						cd_turno_w	:= 1;
					end if;
					
					if (hr_quebra_turno_not_w IS NOT NULL AND hr_quebra_turno_not_w::text <> '') and ((to_char(hr_atual_w,'hh24'))::numeric  >= somente_numero(hr_quebra_turno_not_w)) then
						cd_turno_w	:= 3;
					end if;
					
					select nextval('agenda_paciente_seq')
					into STRICT nr_sequencia_w
					;

					select	max(cd_medico)
					into STRICT	cd_medico_exec_w
					from	agenda_medico
					where	nr_sequencia	= nr_seq_agenda_medico_w;
				
					select	count(*)
					into STRICT	qt_agenda_w
					from	agenda_paciente
					where	cd_agenda		= cd_agenda_w
					and	dt_agenda		= trunc(dt_agenda_p,'dd')
					and	hr_inicio		= hr_atual_w
					and	ie_status_agenda	in ('L','N','R'); /* Dalcastagne em 24/08/2007 OS 66649 */
 

					/* Dalcastagne em 24/08/2007 OS 66649 */

					if (qt_agenda_w = 0) and (coalesce(ie_gerar_dia_anterior_w,'S') = 'S') then
						select	count(*)
						into STRICT	qt_agenda_w
						from	agenda_paciente
						where	cd_agenda		= cd_agenda_w
						and	dt_agenda		= trunc(dt_agenda_p-1,'dd')
						and	hr_atual_w between hr_inicio and hr_inicio + ((nr_minuto_duracao-1) / 1440)
						and	ie_status_agenda not in ('L','C','B');
					end if;
					
					if (qt_agenda_w = 0) then
						select	count(*)
						into STRICT	qt_agenda_w
						from	agenda_paciente
						where	cd_agenda		= cd_agenda_w
						and	dt_agenda		= trunc(dt_agenda_p,'dd')
						and	hr_atual_w between hr_inicio and hr_inicio + ((nr_minuto_duracao-1) / 1440)
						and	ie_status_agenda not in ('L','C','B');
					end if;

					nm_paciente_w		:= null;
					ie_status_agenda_w	:= 'L';
					if (ie_bloqueio_w = 'S') or (ie_bloqueio_hora_w = 'S') or (ie_bloqueio_dia_w = 'S') or (ie_bloqueio_dia_hora_w = 'S')  then
						nm_paciente_w		:= Wheb_mensagem_pck.get_texto(300737); --'Horario bloqueado';
						ie_status_agenda_w	:= 'B';	
					end if;
									
				
					if (qt_agenda_w = 0) then
						begin


						insert into agenda_paciente(cd_agenda, dt_agenda, hr_inicio,
							nr_minuto_duracao,nm_usuario, dt_atualizacao, 
							ie_status_agenda,	ie_ortese_protese, ie_cdi, 
							ie_uti,ie_banco_sangue,	ie_serv_especial, 
							ie_leito, ie_anestesia, nr_sequencia, cd_turno, 
							ie_equipamento, ie_autorizacao, ie_video, ie_uc, 
							cd_medico, cd_medico_exec, nm_paciente, ie_biopsia, ie_congelacao, nr_seq_sala,
							IE_CONSULTA_ANESTESICA, IE_PRE_INTERNACAO, ie_tipo_atendimento, ie_arco_c, NR_SEQ_CLASSIF_AGENDA,
							cd_anestesista, ie_carater_cirurgia,cd_convenio,cd_categoria)
						values (
							cd_agenda_w, trunc(dt_agenda_p,'dd'), hr_atual_w, 
							nr_minuto_Intervalo_w, nm_usuario_p, clock_timestamp(), 
							ie_status_agenda_w, 'N', 'N', 'N', 'N', 'N', 'S', ie_anestesista_w,
							nr_sequencia_w, cd_turno_w, 'N', NULL, 'N', 'N', cd_medico_w, cd_medico_exec_w, 
							substr(coalesce(nm_paciente_w,CASE WHEN ie_gerar_obs_horario_w='S' THEN  ds_observacao_horario_w  ELSE null END ),1,60),
							'N', 'N', nr_seq_sala_w, 'N', 'N', CASE WHEN ie_tipo_atendimento_w=0 THEN  null  ELSE ie_tipo_atendimento_w END ,'N',
							NR_SEQ_CLASSIF_AGENDA_w, cd_anestesista_w, ie_carater_cirurgia_w,cd_convenio_w,cd_categoria_w);
						commit;
						end;
					end if;
					end;
					end if;			
				end;
			end if;
			
			hr_atual_w		:= hr_atual_w + (nr_minuto_intervalo_w / 1440);
			qt_horario_w 	:= qt_horario_w + 1;
			
		/*	if	(hr_atual_w >= hr_inicial_intervalo_w) and 
				(hr_atual_w < hr_final_intervalo_w) then
				hr_atual_w	:= hr_final_intervalo_w; 
			end if;
			if	(qt_horario_w > 201 ) then
				hr_atual_w	:= hr_final_w + 1;
		end if; */
	END;
	END LOOP;
	end if;
	end;
END LOOP;
CLOSE C01;



hr_nada_w	:= trunc(dt_agenda_p,'year');
hr_fim_w	:= hr_nada_w;
qt_min_minimo_w	:= 0;

OPEN C02;
LOOP
FETCH C02 into
	cd_agenda_w,
	hr_inicial_w,
	hr_final_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	select	coalesce(max(ie_gerar_sobra_horario), 'N'),
		coalesce(max(HR_QUEBRA_TURNO), '12'),
		coalesce(max(qt_min_quebra_turno), '00'),
		max(ie_anestesista),
		coalesce(max(ie_tipo_atendimento), 0),
		max(hr_quebra_turno_not)
	into STRICT	ie_sobra_horario_w,
		HR_QUEBRA_TURNO_W,	
		qt_min_QUEBRA_TURNO_W,
		ie_anestesista_w,
		ie_tipo_atendimento_w,
		hr_quebra_turno_not_w
	from	agenda
	where	cd_agenda	= cd_agenda_w;
	
	hr_fim_w	:= hr_nada_w;	
	
	if (coalesce(ie_sobra_horario_w,'N') = 'S') then
		if (hr_fim_w <> hr_nada_w) and (hr_inicial_w > hr_fim_w) then
			BEGIN

			nr_minuto_intervalo_w	:= (hr_inicial_w - hr_fim_w) * 1440;
			hr_atual_w		:= hr_fim_w;
			if (nr_minuto_intervalo_w >= qt_min_minimo_w) then
				begin
				select	count(*)
				into STRICT	qt_turno_w			
				from 	agenda_horario
				where 	cd_agenda     	= cd_agenda_w
				and 	dt_dia_semana	= ie_dia_Semana_w
				and	hr_atual_w	between
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_inicial,'hh24:mi'),'dd/mm/yyyy hh24:mi')
							and
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_final - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');

				select	count(*)
				into STRICT	qt_intervalo_w			
				from 	agenda_horario
				where 	cd_agenda     	= cd_agenda_w
				and 	dt_dia_semana	= ie_dia_Semana_w
				and   	to_char(hr_inicial_intervalo,'hh24') <> '00'
				and	hr_atual_w	between
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_inicial_intervalo,'hh24:mi'),'dd/mm/yyyy hh24:mi')
							and
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_final_intervalo - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');


				if (qt_turno_w	= 0) then
					begin

					select	count(*)
					into STRICT	qt_turno_w			
					from 	agenda_horario
					where 	cd_agenda     	= cd_agenda_w
					and 	dt_dia_semana	= 9
					and	hr_atual_w	between
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_inicial,'hh24:mi'),'dd/mm/yyyy hh24:mi')
								and
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_final  - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');

					select	count(*)
					into STRICT	qt_intervalo_w			
					from 	agenda_horario
					where 	cd_agenda     	= cd_agenda_w
					and 	dt_dia_semana	= 9
					and   	to_char(hr_inicial_intervalo,'hh24') <> '00'
					and	hr_atual_w	between
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_inicial_intervalo,'hh24:mi'),'dd/mm/yyyy hh24:mi')
								and
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_final_intervalo - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');


					end;
				end if;

				begin
				/* bloqueio por dia */

				select 'S'
				into STRICT	ie_bloqueio_dia_w
				from	agenda_bloqueio
				where	cd_agenda	= cd_agenda_w
				and	trunc(hr_atual_w) between dt_inicial and dt_final
				and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
				and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
				and	coalesce(HR_INICIO_BLOQUEIO::text, '') = ''
				and	coalesce(HR_FINAL_BLOQUEIO::text, '') = '';
				exception
					when others then
						ie_bloqueio_dia_w := 'N';
				end;



				begin
				/* bloqueio dia e hora */

				select 'S'
				into STRICT	ie_bloqueio_dia_hora_w
				from	agenda_bloqueio
				where	cd_agenda	= cd_agenda_w
				and	trunc(hr_atual_w) between dt_inicial and dt_final
				and	hr_atual_w between to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '||
					to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
				and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
				and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
				and	(HR_INICIO_BLOQUEIO IS NOT NULL AND HR_INICIO_BLOQUEIO::text <> '')
				and	(HR_FINAL_BLOQUEIO IS NOT NULL AND HR_FINAL_BLOQUEIO::text <> '')
				and	hr_inicio_bloqueio < hr_final_bloqueio;
				exception
					when others then
						ie_bloqueio_dia_hora_w := 'N';
				end;


				if	((ie_bloqueio_dia_w = 'N' AND ie_bloqueio_dia_hora_w = 'N') or (ie_gerar_bloqueados_w = 'S')) and (qt_turno_w > 0) and (qt_intervalo_w = 0) then
					begin
					cd_turno_w		:= 0;

					if ((to_char(hr_atual_w,'hh24'))::numeric  > somente_numero(HR_QUEBRA_TURNO_W)) or
						(((to_char(hr_atual_w,'hh24'))::numeric  = somente_numero(HR_QUEBRA_TURNO_W)) and ((to_char(hr_atual_w,'mi'))::numeric  >= somente_numero(qt_min_QUEBRA_TURNO_W))) then
						cd_turno_w	:= 1;
					end if;
					
					if (hr_quebra_turno_not_w IS NOT NULL AND hr_quebra_turno_not_w::text <> '') and ((to_char(hr_atual_w,'hh24'))::numeric  >= somente_numero(hr_quebra_turno_not_w)) then
						cd_turno_w	:= 3;
					end if;

					select 	nextval('agenda_paciente_seq')
					into STRICT 	nr_sequencia_w
					;

					select 	count(*)
					into STRICT	qt_horario_livre_gerado_w
					from 	agenda_paciente
					where	cd_agenda = cd_agenda_w
					and	hr_inicio = hr_atual_w
					and	ie_status_agenda = 'L'
					and	dt_agenda = trunc(dt_agenda_p,'dd');
					
					nm_paciente_w		:= null;
					ie_status_agenda_w	:= 'L';
					
					if (ie_bloqueio_dia_w = 'S') or (ie_bloqueio_dia_hora_w = 'S')  then
						nm_paciente_w		:= Wheb_mensagem_pck.get_texto(300737); --'Horario bloqueado';
						ie_status_agenda_w	:= 'B';	
					end if;
					
					if (qt_horario_livre_gerado_w = 0) then

						insert into agenda_paciente(cd_agenda, dt_agenda, hr_inicio,
							nr_minuto_duracao,nm_usuario, dt_atualizacao, 
							ie_status_agenda,	ie_ortese_protese, ie_cdi, 
							ie_uti,ie_banco_sangue,	ie_serv_especial, 
							ie_leito, ie_anestesia, nr_sequencia, cd_turno, 
							ie_equipamento, ie_autorizacao, ie_video, ie_uc, cd_medico, cd_medico_exec,
							nm_paciente, ie_biopsia, ie_congelacao, IE_CONSULTA_ANESTESICA,         
							IE_PRE_INTERNACAO, ie_tipo_atendimento, ie_arco_c,NR_SEQ_CLASSIF_AGENDA, cd_anestesista, ie_carater_cirurgia)
						values (
							cd_agenda_w, trunc(dt_agenda_p,'dd'), hr_atual_w, 
							nr_minuto_Intervalo_w, nm_usuario_p, clock_timestamp(), 
							ie_status_agenda_w, 'N', 'N', 'N', 'N', 'N', 'S', ie_anestesista_w,
							nr_sequencia_w, cd_turno_w, 'N', NULL, 
							'N', 'N', cd_medico_w, cd_medico_exec_w, coalesce(nm_paciente_w,CASE WHEN ie_gerar_obs_horario_w='S' THEN  ds_observacao_horario_w  ELSE null END ), 'N', 'N', 'N', 'N', 
							CASE WHEN ie_tipo_atendimento_w=0 THEN  null  ELSE ie_tipo_atendimento_w END , 'N',NR_SEQ_CLASSIF_AGENDA_w,cd_anestesista_w, ie_carater_cirurgia_w);
						commit;
					end if;
					end;
				end if;
				end;
			end if;
			END;
		end if;
		if (hr_final_w > hr_fim_w) then
			hr_fim_w	:= hr_final_w;
		end if;
	end if;
END LOOP;
CLOSE C02;
/*
if	(ie_gerar_forcado_w = 'S') then
	begin
	
	open	c03;
	loop
	fetch	c03 into 
		dt_forcado_w, 
		nr_min_forcado_w,
		cd_agenda_forcado_w;
	exit 	when c03%notfound;
		begin

		select	count(*)
		into	qt_horario_w
		from	agenda_paciente
		where	cd_agenda		= cd_agenda_forcado_w
		and	dt_agenda		= trunc(dt_forcado_w, 'dd')
		and	hr_inicio		= dt_forcado_w
		and	ie_status_agenda	in ('LF', 'N', 'E');

	
		if	(qt_horario_w = 0) then
			begin

			select	agenda_paciente_seq.nextval
			into	nr_sequencia_w
			from	dual;

			insert	into agenda_paciente
				(cd_agenda,
				dt_agenda,
				hr_inicio,
				nr_minuto_duracao,
				nm_usuario,
				dt_atualizacao,
				nr_sequencia,
				ie_equipamento,
				ie_status_agenda,
				nm_paciente,
				IE_CONSULTA_ANESTESICA,IE_PRE_INTERNACAO, ie_tipo_atendimento,
				NR_SEQ_CLASSIF_AGENDA,
				ie_carater_cirurgia)
			values
				(cd_agenda_forcado_w,
				trunc(dt_forcado_w, 'dd'),
				dt_forcado_w,
				nr_min_forcado_w,
				nm_usuario_p,
				sysdate,
				nr_sequencia_w,
				'N', 'LF', null, 'N', 'N', decode(ie_tipo_atendimento_w, 0, null, ie_tipo_atendimento_w),
				NR_SEQ_CLASSIF_AGENDA_w,
				ie_carater_cirurgia_w);
			delete	from agenda_livre_forcado
			where	dt_agenda	= dt_forcado_w
			and	cd_agenda	= cd_agenda_forcado_w;
			end;
		end if;

		end;
	end loop;
	close c03;
	end;
end if;
*/
OPEN C02;
LOOP
FETCH C02 into
	cd_agenda_w,
	hr_inicial_w,
	hr_final_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	select	coalesce(max(ie_gerar_sobra_horario), 'N'),
		coalesce(max(HR_QUEBRA_TURNO), '12'),
		coalesce(max(qt_min_quebra_turno), '00'),
		max(ie_anestesista),
		coalesce(max(ie_tipo_atendimento), 0),
		max(hr_quebra_turno_not)
	into STRICT	ie_sobra_horario_w,
		HR_QUEBRA_TURNO_W,	
		qt_min_QUEBRA_TURNO_W,
		ie_anestesista_w,
		ie_tipo_atendimento_w,
		hr_quebra_turno_not_w
	from	agenda
	where	cd_agenda	= cd_agenda_w;
	
	if (coalesce(ie_sobra_horario_w,'N') = 'S') then
		
		if (hr_inicial_w > hr_final_w) then
			BEGIN
		
			nr_minuto_intervalo_w	:= (hr_inicial_w - hr_final_w) * 1440;
			hr_atual_w		:= hr_inicial_w;
			if (nr_minuto_intervalo_w >= qt_min_minimo_w) then
				begin
				select	count(*)
				into STRICT	qt_turno_w			
				from 	agenda_horario
				where 	cd_agenda     	= cd_agenda_w
				and	dt_dia_semana	= ie_dia_Semana_w
				and	hr_atual_w	between
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_inicial,'hh24:mi'),'dd/mm/yyyy hh24:mi')
							and
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_final - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');

				select	count(*)
				into STRICT	qt_intervalo_w			
				from 	agenda_horario
				where 	cd_agenda     	= cd_agenda_w
				and 	dt_dia_semana	= ie_dia_Semana_w
				and   	to_char(hr_inicial_intervalo,'hh24') <> '00'
				and	hr_atual_w	between
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_inicial_intervalo,'hh24:mi'),'dd/mm/yyyy hh24:mi')
							and
							to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
							to_char(hr_final_intervalo - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');


				if (qt_turno_w	= 0) then
					begin

					select	count(*)
					into STRICT	qt_turno_w			
					from 	agenda_horario
					where 	cd_agenda     	= cd_agenda_w
					and 	dt_dia_semana	= 9
					and	hr_atual_w	between
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_inicial,'hh24:mi'),'dd/mm/yyyy hh24:mi')
								and
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_final  - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');

					select	count(*)
					into STRICT	qt_intervalo_w			
					from 	agenda_horario
					where 	cd_agenda     	= cd_agenda_w
					and 	dt_dia_semana	= 9
					and   	to_char(hr_inicial_intervalo,'hh24') <> '00'
					and	hr_atual_w	between
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_inicial_intervalo,'hh24:mi'),'dd/mm/yyyy hh24:mi')
								and
								to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' ||
								to_char(hr_final_intervalo - 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');


					end;
				end if;

				begin
				/* bloqueio por dia */

				select 'S'
				into STRICT	ie_bloqueio_dia_w
				from	agenda_bloqueio
				where	cd_agenda	= cd_agenda_w
				and	trunc(hr_atual_w) between dt_inicial and dt_final
				and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
				and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
				and	coalesce(HR_INICIO_BLOQUEIO::text, '') = ''
				and	coalesce(HR_FINAL_BLOQUEIO::text, '') = '';
				exception
					when others then
						ie_bloqueio_dia_w := 'N';
				end;



				begin
				/* bloqueio dia e hora */

				select 'S'
				into STRICT	ie_bloqueio_dia_hora_w
				from	agenda_bloqueio
				where	cd_agenda	= cd_agenda_w
				and	trunc(hr_atual_w) between dt_inicial and dt_final
				and	hr_atual_w between to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '||
					to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and to_date(to_char(hr_atual_w,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
				and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '')
				and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
				and	(HR_INICIO_BLOQUEIO IS NOT NULL AND HR_INICIO_BLOQUEIO::text <> '')
				and	(HR_FINAL_BLOQUEIO IS NOT NULL AND HR_FINAL_BLOQUEIO::text <> '')
				and	hr_inicio_bloqueio < hr_final_bloqueio;
				exception
					when others then
						ie_bloqueio_dia_hora_w := 'N';
				end;


				if (ie_bloqueio_dia_w = 'N') and (ie_bloqueio_dia_hora_w = 'N') and (qt_turno_w > 0) and (qt_intervalo_w = 0) then
					begin
					cd_turno_w		:= 0;

					if ((to_char(hr_atual_w,'hh24'))::numeric  > somente_numero(HR_QUEBRA_TURNO_W)) or
						(((to_char(hr_atual_w,'hh24'))::numeric  = somente_numero(HR_QUEBRA_TURNO_W)) and ((to_char(hr_atual_w,'mi'))::numeric  >= somente_numero(qt_min_QUEBRA_TURNO_W))) then
						cd_turno_w	:= 1;
					end if;
					
					if (hr_quebra_turno_not_w IS NOT NULL AND hr_quebra_turno_not_w::text <> '') and ((to_char(hr_atual_w,'hh24'))::numeric  >= somente_numero(hr_quebra_turno_not_w)) then
						cd_turno_w	:= 3;
					end if;

					select 	count(*)
					into STRICT	qt_horario_livre_gerado_w
					from 	agenda_paciente
					where	cd_agenda = cd_agenda_w
					and	hr_inicio = hr_atual_w
					and	ie_status_agenda = 'L'
					and	dt_agenda = trunc(dt_agenda_p,'dd');
					
					if (qt_horario_livre_gerado_w = 0) then

						select 	nextval('agenda_paciente_seq')
						into STRICT 	nr_sequencia_w
						;

						insert into agenda_paciente(cd_agenda, dt_agenda, hr_inicio,
							nr_minuto_duracao,nm_usuario, dt_atualizacao, 
							ie_status_agenda,	ie_ortese_protese, ie_cdi, 
							ie_uti,ie_banco_sangue,	ie_serv_especial, 
							ie_leito, ie_anestesia, nr_sequencia, cd_turno, 
							ie_equipamento, ie_autorizacao, ie_video, ie_uc, cd_medico, cd_medico_exec,
							nm_paciente, ie_biopsia, ie_congelacao, IE_CONSULTA_ANESTESICA,         
							IE_PRE_INTERNACAO, ie_tipo_atendimento, ie_arco_c,NR_SEQ_CLASSIF_AGENDA, cd_anestesista, ie_carater_cirurgia)
						values (
							cd_agenda_w, trunc(dt_agenda_p,'dd'), hr_atual_w, 
							nr_minuto_Intervalo_w, nm_usuario_p, clock_timestamp(), 
							'L', 'N', 'N', 'N', 'N', 'N', 'S', ie_anestesista_w,
							nr_sequencia_w, cd_turno_w, 'N', NULL, 
							'N', 'N', cd_medico_w, cd_medico_exec_w, 	CASE WHEN ie_gerar_obs_horario_w='S' THEN  ds_observacao_horario_w  ELSE null END , 'N', 'N', 'N', 'N', 
							CASE WHEN ie_tipo_atendimento_w=0 THEN  null  ELSE ie_tipo_atendimento_w END , 'N',NR_SEQ_CLASSIF_AGENDA_w,cd_anestesista_w, ie_carater_cirurgia_w);
						commit;
					end if;

					end;
				end if;
				end;
			end if;
			END;
		end if;
		if (hr_final_w >= hr_fim_w) then
			hr_fim_w	:= hr_final_w;
		end if;
	end if;
END LOOP;
CLOSE C02;


open C000;
loop
fetch C000 into	
	cd_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C000 */
	begin
	delete	/*+ INDEX(A AGEPACI_UK) */	from 	agenda_paciente
	where 	cd_agenda	= cd_agenda_w
	and	dt_agenda between trunc(dt_agenda_p,'dd') and (trunc(dt_agenda_p,'dd') + (86399/86400))
	and	nr_minuto_duracao = 0
	and	ie_status_agenda = 'L';
	commit;
	end;
end loop;
close C000;

ds_horarios_p	:= ds_horarios_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_horario_otimizado ( cd_estabelecimento_p bigint, dt_agenda_p timestamp, dt_final_p timestamp, qt_minutos_p bigint, hr_inicial_p text, hr_final_p text, ds_restricao_p text, nm_usuario_p text, ie_grava_Livre_p text, ds_horarios_p INOUT text) FROM PUBLIC;

