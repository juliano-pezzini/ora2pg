-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_marcar_dias_trat ( nr_seq_pendencia_p bigint, nr_seq_atendimento_p bigint, dt_agenda_p timestamp, nm_usuario_p text, nr_seq_local_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_min_duracao_p bigint, nr_seq_item_p bigint, nr_seq_prof_p bigint default null, ds_retorno_p INOUT text DEFAULT NULL, ie_consiste_estab_p text DEFAULT NULL, qt_tempo_medic_p bigint DEFAULT NULL, nr_horas_marcacao_p bigint DEFAULT NULL) AS $body$
DECLARE

 
dt_agenda_w		timestamp;
ie_Gerar_w		varchar(3);
ds_retorno_w		varchar(4000);
ie_primeiro_w		varchar(1)	:= 'S';
ds_sep_w		varchar(3);
ie_consiste_estab_w	varchar(1);
nr_seq_local_w		bigint;
dt_horario_w		timestamp;
ie_novo_automatico_w	varchar(1);
ds_msg_inf_w		varchar(255);
qt_tempo_medic_w	bigint;
nr_seq_grupo_quimio_w	bigint;
qt_horarios_w		varchar(1);
ie_mesmo_local_w	varchar(1);
qt_teste_w	bigint;
cd_estab_local_w	bigint;
cd_setor_atendimento_w	paciente_setor.cd_setor_atendimento%type;
nr_seq_local_ww		qt_local.nr_sequencia%type := null;
ie_local_livre_aut_w	parametro_agenda_quimio.ie_local_livre_aut%type;

C01 CURSOR FOR 
	SELECT	to_date(to_char(coalesce(a.dt_prevista_agenda, coalesce(a.dt_real, a.dt_prevista)),'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'), 
			qt_obter_dur_aplicacao(a.ds_dia_ciclo,b.nr_seq_medicacao,b.cd_protocolo,a.nr_seq_atendimento,coalesce(a.dt_real, a.dt_prevista),nr_seq_pendencia_p,nm_usuario_p,cd_estabelecimento_p), 
			b.cd_setor_atendimento 
	from	paciente_atendimento a, 
		paciente_setor b 
	where	a.nr_Seq_pend_agenda	= nr_seq_pendencia_p 
	and (a.nr_seq_atendimento	= nr_seq_atendimento_p or nr_seq_atendimento_p = 0) 
	and	a.nr_seq_paciente	= b.nr_seq_paciente 
	and		coalesce(a.dt_suspensao::text, '') = '' 
	and	coalesce(a.dt_prevista_agenda, coalesce(a.dt_real,a.dt_prevista))	>= trunc(dt_agenda_p) 
	and		((coalesce(a.cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p and ie_consiste_estab_w = 'S') or ie_consiste_estab_w = 'N') 
	--and	not exists (select 1 from agenda_quimio_marcacao x where x.nr_seq_pend_agenda = a.nr_Seq_pend_agenda and trunc(nvl(a.dt_prevista_agenda, nvl(a.dt_real, a.dt_prevista))) = trunc(x.dt_agenda)) 
	and	coalesce(a.dt_cancelamento::text, '') = '' 
	and	coalesce(a.dt_interrompido::text, '') = '' 
	order by 1;


BEGIN 
ie_novo_automatico_w	:= coalesce(Obter_Valor_Param_Usuario(865, 195, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ie_mesmo_local_w		:= coalesce(Obter_Valor_Param_Usuario(865, 230, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ie_consiste_estab_w	:= coalesce(ie_consiste_estab_p,'S');
 
select	coalesce(max(ie_local_livre_aut), 'N') 
into STRICT	ie_local_livre_aut_w 
from	parametro_agenda_quimio 
where	cd_estabelecimento = cd_estabelecimento_p;
 
delete 
from	w_consistencia_qt_marc 
where	nr_seq_pend_agenda	= nr_seq_pendencia_p 
or	nm_usuario		= nm_usuario_p;
 
open C01;
loop 
fetch C01 into 
	dt_agenda_w, 
	qt_tempo_medic_w, 
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
			 
	CALL Qt_Gerar_Horario(nr_seq_pendencia_p, null, trunc(dt_agenda_w), nm_usuario_p, nr_min_duracao_p, 
			cd_pessoa_fisica_p ,null, null, nr_seq_local_p,nr_seq_item_p,'');	
	 
	select	coalesce(max(nr_seq_grupo_quimio),0), 
		coalesce(max(cd_estabelecimento), max(cd_estabelecimento_p)) 
	into STRICT	nr_seq_grupo_quimio_w, 
		cd_estab_local_w 
	from	qt_local 
	where	nr_sequencia	= nr_seq_local_p;
	 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	qt_horarios_w 
	from	w_agenda_quimio x, 
		qt_local z 
	where	z.nr_sequencia = x.nr_seq_local 
	and	x.nr_seq_local = nr_seq_local_p 
	and	x.nm_usuario = nm_usuario_p 
	and	x.ie_status = 'L' 
	and	x.dt_horario = to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	 
	if (qt_horarios_w = 'S') and (ie_mesmo_local_w = 'N') then 
		ie_gerar_w := Qt_Atualizar_Dados_Marcacao(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_agenda_w, nm_usuario_p, nr_seq_local_p, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p, ie_consiste_estab_w, dt_agenda_p);
	else 
		ie_Gerar_w := 'N';
	end if;
	 
	if (ie_Gerar_w	<> 'S') and (ie_novo_automatico_w = 'S') then 
		if (qt_tempo_medic_w IS NOT NULL AND qt_tempo_medic_w::text <> '') then 
			if (trunc(dt_agenda_p)	<> trunc(dt_agenda_w)) then 
 
				if (ie_local_livre_aut_w = 'S') then 
					nr_seq_local_ww := qt_consiste_hora_disp( dt_agenda_p , qt_tempo_medic_w , cd_Estabelecimento_p	);
				end if;
 
				CALL Qt_Gerar_Horario(nr_seq_pendencia_p, null, trunc(dt_agenda_w), nm_usuario_p, nr_min_duracao_p, 
						cd_pessoa_fisica_p ,null, null, nr_seq_local_ww ,nr_seq_item_p,'');
			end if;
			 
			IF (ie_mesmo_local_w = 'N') THEN 
			 
			 
				select	min(x.dt_horario), 
					min(x.nr_seq_local) 
				into STRICT	dt_horario_w, 
					nr_seq_local_w 
				from	w_agenda_quimio x, 
					qt_local z 
				where	z.nr_sequencia = x.nr_seq_local 
				and	z.cd_estabelecimento = cd_estab_local_w 
				and	x.nm_usuario = nm_usuario_p 
				and	x.ie_status = 'L' 
				and	x.nr_seq_local = nr_seq_local_p 
				--and	nvl(z.nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)	= nr_seq_grupo_quimio_w 
				and	not exists (	SELECT	1 
							from	w_agenda_quimio y 
							where	y.nr_seq_local = x.nr_seq_local 
							and	y.ie_status <> 'L' 
							and	y.dt_horario between x.dt_horario and x.dt_horario + qt_tempo_medic_w/1440) 
				and	x.dt_horario > clock_timestamp() 
				and	(to_char(x.dt_horario,'hh24:mi') > (select coalesce(max(to_char(hr_min_inicio,'hh24:mi')),'00:00') from parametro_agenda_quimio) 
				and	((x.dt_horario > (clock_timestamp() + coalesce(nr_horas_marcacao_p,0)/24)) or (coalesce(nr_horas_marcacao_p,0) = 0))) 
				and	Qt_Consitir_Classif_Dur(x.dt_horario, qt_tempo_medic_w, z.nr_sequencia, cd_setor_atendimento_w) = 'S' 
				and	x.dt_horario = to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
				 
				ie_gerar_w := Qt_Atualizar_Dados_Marcacao(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_horario_w, nm_usuario_p, nr_seq_local_w, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p, ie_consiste_estab_w, dt_agenda_p);
 
				IF (ie_Gerar_w	<> 'S') THEN 
				 
					select	min(x.dt_horario), 
						min(x.nr_seq_local) 
					into STRICT	dt_horario_w, 
						nr_seq_local_w 
					from	w_agenda_quimio x, 
						qt_local z 
					where	z.nr_sequencia = x.nr_seq_local 
					and (z.cd_estabelecimento = cd_estabelecimento_p or ie_consiste_estab_w = 'N') 
					and	x.nm_usuario = nm_usuario_p 
					and	x.ie_status = 'L' 
					and	coalesce(z.nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)	= nr_seq_grupo_quimio_w 
					and	not exists (	SELECT	1 
								from	w_agenda_quimio y 
								where	y.nr_seq_local = x.nr_seq_local 
								and	y.ie_status <> 'L' 
								and	y.dt_horario between x.dt_horario + 1/1440 and x.dt_horario + (qt_tempo_medic_w -1)/1440) 
					and	x.dt_horario > clock_timestamp() 
					and	(to_char(x.dt_horario,'hh24:mi') > (select coalesce(max(to_char(hr_min_inicio,'hh24:mi')),'00:00') from parametro_agenda_quimio) 
					and	((x.dt_horario > (clock_timestamp() + coalesce(nr_horas_marcacao_p,0)/24)) or (coalesce(nr_horas_marcacao_p,0) = 0))) 
					and	Qt_Consitir_Classif_Dur(x.dt_horario, qt_tempo_medic_w, z.nr_sequencia, cd_setor_atendimento_w) = 'S' 
					and	x.dt_horario = to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')					 
					and	z.nr_seq_apres = ( 
									SELECT	min(b.nr_seq_apres) 
									from	w_agenda_quimio a, 
										qt_local b 
									where	b.nr_sequencia = x.nr_seq_local 
									and (b.cd_estabelecimento = cd_estabelecimento_p or ie_consiste_estab_w = 'N') 
									and	a.nm_usuario = nm_usuario_p 
									and	a.ie_status = 'L' 
									and	coalesce(b.nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)	= nr_seq_grupo_quimio_w 
									and	not exists (	select	1 
												from	w_agenda_quimio y 
												where	y.nr_seq_local = x.nr_seq_local 
												and	y.ie_status <> 'L' 
												and	y.dt_horario between x.dt_horario + 1/1440 and x.dt_horario + (qt_tempo_medic_w -1)/1440) 
									and	a.dt_horario > clock_timestamp() 
									and	(to_char(x.dt_horario,'hh24:mi') > (select coalesce(max(to_char(hr_min_inicio,'hh24:mi')),'00:00') from parametro_agenda_quimio) 
									and	((a.dt_horario > (clock_timestamp() + coalesce(nr_horas_marcacao_p,0)/24)) or (coalesce(nr_horas_marcacao_p,0) = 0))) 
									and	Qt_Consitir_Classif_Dur(a.dt_horario, qt_tempo_medic_w, b.nr_sequencia, cd_setor_atendimento_w) = 'S' 
									and	a.dt_horario = to_date(to_char(dt_agenda_w,'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'));
					 
					ie_gerar_w := Qt_Atualizar_Dados_Marcacao(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_horario_w, nm_usuario_p, nr_seq_local_w, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p, ie_consiste_estab_w, dt_agenda_p);
				 
				END IF;
			ELSE 
				SELECT 	min(dt_horario), 
					min(nr_seq_local) 
				into STRICT	dt_horario_w, 
					nr_seq_local_w 
				FROM (	 
					SELECT	x.dt_horario, 
						x.nr_seq_local, 
						ROW_NUMBER() OVER (ORDER BY coalesce(z.nr_seq_apres,1), dt_horario, z.nr_sequencia ) AS row_id_pagina 
					from	w_agenda_quimio x, 
						qt_local z 
					where	z.nr_sequencia = x.nr_seq_local 
					and (z.cd_estabelecimento = cd_estabelecimento_p or ie_consiste_estab_w = 'N') 
					and	x.nm_usuario = nm_usuario_p 
					and	x.ie_status = 'L' 
					--AND	NR_sEQ_LOcal = NR_sEQ_LOCAL_P 
					--and	nvl(z.nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)	= nr_seq_grupo_quimio_w 
					and (	SELECT	sum(nr_min_duracao_p) 
								from	w_agenda_quimio y 
								where	y.nr_seq_local = x.nr_seq_local 
								and	y.ie_status = 'L' 
								and	y.dt_horario between x.dt_horario and x.dt_horario + qt_tempo_medic_w /1440) >= qt_tempo_medic_w 
					and	x.dt_horario > clock_timestamp() 
					and	(to_char(x.dt_horario,'hh24:mi') > (select coalesce(max(to_char(hr_min_inicio,'hh24:mi')),'00:00') from parametro_agenda_quimio) 
					and	((x.dt_horario > (clock_timestamp() + coalesce(nr_horas_marcacao_p,0)/24)) or (coalesce(nr_horas_marcacao_p,0) = 0))) 
					and	Qt_Consitir_Classif_Dur(x.dt_horario, qt_tempo_medic_w, z.nr_sequencia, cd_setor_atendimento_w) = 'S' 
					and	trunc(x.dt_horario) = trunc(dt_agenda_w) 
			       ) alias25 
				WHERE row_id_pagina <= 1;
								 
				ie_gerar_w := Qt_Atualizar_Dados_Marcacao(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_horario_w, nm_usuario_p, nr_seq_local_w, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p, ie_consiste_estab_w);
				 
				if (ie_gerar_w <> 'S') then 
				 
					SELECT 	min(dt_horario), 
						min(nr_seq_local) 
					into STRICT	dt_horario_w, 
						nr_seq_local_w 
					FROM (	 
						SELECT	x.dt_horario, 
							x.nr_seq_local, 
							ROW_NUMBER() OVER (ORDER BY coalesce(z.nr_seq_apres, z.nr_sequencia), dt_horario ) AS row_id_pagina 
						from	w_agenda_quimio x, 
							qt_local z 
						where	z.nr_sequencia = x.nr_seq_local 
						and (z.cd_estabelecimento = cd_estabelecimento_p or ie_consiste_estab_w = 'N') 
						and	x.nm_usuario = nm_usuario_p 
						and	x.ie_status = 'L' 
						--AND	NR_sEQ_LOcal = NR_sEQ_LOCAL_P 
						--and	nvl(z.nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)	= nr_seq_grupo_quimio_w 
						and (	SELECT	sum(nr_min_duracao_p) 
									from	w_agenda_quimio y 
									where	y.nr_seq_local = x.nr_seq_local 
									and	y.ie_status = 'L' 
									and	y.dt_horario between x.dt_horario and x.dt_horario + qt_tempo_medic_w /1440) >= qt_tempo_medic_w 
						and	x.dt_horario > clock_timestamp() 
						and	(to_char(x.dt_horario,'hh24:mi') > (select coalesce(max(to_char(hr_min_inicio,'hh24:mi')),'00:00') from parametro_agenda_quimio) 
						and	((x.dt_horario > (clock_timestamp() + coalesce(nr_horas_marcacao_p,0)/24)) or (coalesce(nr_horas_marcacao_p,0) = 0))) 
						and	Qt_Consitir_Classif_Dur(x.dt_horario, qt_tempo_medic_w, z.nr_sequencia, cd_setor_atendimento_w) = 'S' 
						and	trunc(x.dt_horario) = trunc(dt_agenda_w) 
					   ) alias26 
					WHERE row_id_pagina <= 1;
									 
					ie_gerar_w := Qt_Atualizar_Dados_Marcacao(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_horario_w, nm_usuario_p, nr_seq_local_w, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p, ie_consiste_estab_w, dt_agenda_p);
				end if;
				 
			END IF;
		end if;
	end if;
	 
	if (ie_Gerar_w	<> 'S') then		 
		 
		ds_msg_inf_w := null;
		 
		if ('T' = ie_Gerar_w) then 
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(238909) || chr(10);
			 
		elsif ('Q' = ie_Gerar_w) then 
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(286516) || chr(10);
			 
		elsif ('G' = ie_Gerar_w) then 
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(286518) || chr(10);
		 
		elsif ('P' = ie_Gerar_w) then 
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(795109) || chr(10);
		 
		elsif ('E' = ie_Gerar_w) then 
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(286334) || chr(10);
		 
		elsif ('L' = ie_Gerar_w) then 
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(286335) || chr(10);
		 
		elsif ('H' = ie_Gerar_w) then 
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(286336) || chr(10);
		 
		elsif ('A' = ie_Gerar_w) then 
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(795110) || chr(10);
		 
		elsif ('M' = ie_Gerar_w) then			 
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(286333) || chr(10);
			 
		elsif ('D' = ie_Gerar_w) then 
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(231858) || chr(10);
			 
		elsif ('FT' = ie_gerar_w) then 
			ds_msg_inf_w  := wheb_mensagem_pck.get_texto(286520) || chr(10);
			 
		elsif ('JPM' = ie_Gerar_w) then 
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(795111) ||'.'|| chr(10);
			 
		end if;			
		 
		insert into w_consistencia_qt_marc(	 
			dt_atualizacao, 
			nm_usuario, 
			dt_tratamento, 
			ds_consistencia, 
			nr_seq_pend_agenda ) 
		values (	clock_timestamp(), 
			nm_usuario_p, 
			dt_agenda_w, 
			coalesce(ds_msg_inf_w,wheb_mensagem_pck.get_texto(795112)||'.'), 
			nr_seq_pendencia_p);
		 
		if ('S' = ie_primeiro_w) then 
			ie_primeiro_w := 'N';
			ds_retorno_w	:= wheb_mensagem_pck.get_texto(795113);
		end if;
		 
		ds_retorno_w	:= substr(ds_retorno_w || ds_sep_w || to_char(dt_agenda_w,'dd/mm/yyyy'),1,4000);
		ds_sep_w	:= ', ';
	end if;
	end;
end loop;
close C01;
 
ds_retorno_p	:= substr(ds_retorno_w,1,255);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_marcar_dias_trat ( nr_seq_pendencia_p bigint, nr_seq_atendimento_p bigint, dt_agenda_p timestamp, nm_usuario_p text, nr_seq_local_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_min_duracao_p bigint, nr_seq_item_p bigint, nr_seq_prof_p bigint default null, ds_retorno_p INOUT text DEFAULT NULL, ie_consiste_estab_p text DEFAULT NULL, qt_tempo_medic_p bigint DEFAULT NULL, nr_horas_marcacao_p bigint DEFAULT NULL) FROM PUBLIC;
