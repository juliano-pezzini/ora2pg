-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nut_paciente_hor_prot ( nr_prescricao_p bigint, nr_atendimento_p bigint, nr_seq_nut_pac_p bigint, dt_horario_p timestamp, ie_aprazando_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_hor_w	bigint;
dt_hora_atual_w				timestamp;
dt_proxima_dose_w			timestamp;
dt_validade_prescr_w		timestamp;


/* cursor */

ie_cursor_w					varchar(1) := 'N';
ie_inconsistencia_w			varchar(1);
ie_gerar_nec_disp_kit_w		varchar(1);
ie_gedipa_w					varchar(20);
nr_prescr_www				bigint;
ie_local_estoque_mat_hor_w	varchar(20);
ds_inconsistentes_w			varchar(255);
nr_prescricoes_w			varchar(255);
ie_local_estoque_w			varchar(20);
ie_gera_lote_param_w		varchar(1) := 'S';
ie_aprazar_w				varchar(1) := 'S';
nr_prescricao_w				bigint;
ie_dispensar_farm_w			varchar(3);
TAMANHO_W					bigint;
x							bigint;
qt_item_w					bigint;
nr_prescricao_ww			bigint;
nr_prescricao_www			bigint;
nr_etapa_w					bigint;
nr_seq_processo_nut_w		bigint;
qt_hora_intervalo_w			bigint;
nr_seq_processo_agora_w		bigint;
nr_seq_processo_w			bigint;
cd_setor_atendimento_w		bigint;
qt_total_dispensar_w		double precision;
nr_seq_item_w				bigint;
qt_registros_vetor_w		bigint;
qt_controle_ww				bigint;
nr_prescr_atual_w			bigint := 0;
qt_horas_apraz_w			bigint;

/* informacoes */

nr_seq_orig_w				bigint;
qt_dose_w					double precision;
qt_dispensar_w				double precision;
qt_dispensar_hor_w			double precision;
cd_unidade_medida_w			varchar(30);
ie_exibe_suspenso_w			varchar(10);
cd_unidade_medida_dose_w	varchar(30);
ie_gerar_lote_w				varchar(1);
ie_gerar_lote_ww			varchar(1);
ie_origem_proced_w			bigint;
cont_w						bigint;
nr_seq_proc_interno_w		bigint;
nr_prescr_aux_w				bigint;
cd_material_exame_w			varchar(20);
nr_seq_classif_w			bigint;
cd_setor_pac_w				integer;
nr_prescricao_adic_w		bigint;
nr_prescricoes_ww			varchar(255);
nr_prescr_vigente_w			bigint;

/* insert */

nr_seq_horario_w			bigint;

/* evento */

ie_alteracao_w				smallint := 15;
ie_data_proc_w				varchar(15);
dt_validade_w				timestamp;
dt_fim_w					timestamp;
dt_ini_w					timestamp;
ie_gerar_necessidade_disp_w	varchar(15);
cd_setor_prescr_w			integer;
cd_estab_prescr_w			smallint;
ie_agrupador_w				smallint;
cd_local_estoque_w			smallint;
nr_agrupamento_w			double precision;
ie_data_lib_prescr_w		varchar(15);
ie_aprazar_suspensos_w		varchar(10);
ie_classif_urgente_w		varchar(3);
ie_padronizado_w			varchar(1);
ie_classif_nao_padrao_w		varchar(15);
ie_controlado_w				varchar(1);
dt_limite_agora_w			timestamp;
dt_limite_especial_w		timestamp;
dt_liberacao_w				timestamp;
qt_min_agora_w				bigint;
qt_min_especial_w			bigint;
cd_estabelecimento_w		bigint;
qt_dose_hor_w				double precision;
cd_unid_med_dose_hor_w		varchar(30);
cd_material_w				integer;
ie_aprazar_mat_proc_w		varchar(1);
nr_prescr_w					bigint;
nr_prescr_ww				bigint;
ie_aprazar_agrupados_w		varchar(1);
ie_aprazar_ivc_adep_w		varchar(1);
ie_acm_w					varchar(1);
ie_sn_w						varchar(1);
ie_acm_sn_w					varchar(1);
ie_liberado_w				varchar(1);
ie_agora_impressao_w		varchar(15);
nr_seq_turno_hor_ag_w		bigint;
hr_turno_agora_w			varchar(15);
qt_min_antes_atend_w		integer;
cd_refeicao_w				varchar(15);
nr_seq_dieta_w				bigint;
nr_etapa_item_w				bigint;
ie_desagrupa_proced_w		varchar(1);
nr_seq_classif_param_w		bigint;
ie_ver_check_adep_w			varchar(1);
ie_gerar_classif_agora_w	varchar(1);
ie_agrupar_acm_sn_w			varchar(1);
nr_seq_hor_glic_w			bigint;
ie_gerar_serv_supl_w		varchar(1);
ie_gera_nutricao_w			varchar(1);
hr_final_turno_agora_w		varchar(15);
dt_inicio_prescr_w			timestamp;
qt_w						bigint;
ie_horario_especial_w		varchar(1);
ie_define_agora_w		regra_tempo_disp.ie_define_agora%type;

c04 CURSOR FOR
SELECT	a.nr_prescricao nr_prescricao, /* materiais NPT */
		b.nr_sequencia nr_seq_item,
		coalesce(c.cd_local_estoque,coalesce(b.cd_local_estoque,a.cd_local_estoque)) cd_local_estoque,
		b.nr_agrupamento,
		b.cd_material,
		b.cd_unidade_medida,
		'N' ie_sn,
		'N' ie_acm,
		b.qt_dose
from		prescr_mat_hor c,
		prescr_material b,
		prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and		c.nr_seq_material = b.nr_sequencia
and		b.nr_prescricao = a.nr_prescricao
and		b.ie_agrupador	= 11
and		coalesce(b.dt_suspensao::text, '') = ''
and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
and		obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and		a.dt_validade_prescr > dt_validade_w
and		a.nr_atendimento = nr_atendimento_p
and		dt_horario_p between a.dt_inicio_prescr and a.dt_validade_prescr
and		a.nr_prescricao	= nr_prescricao_p
group by
	a.nr_prescricao,
	b.nr_sequencia,
	coalesce(c.cd_local_estoque,coalesce(b.cd_local_estoque,a.cd_local_estoque)),
	b.nr_agrupamento,
	b.cd_material,
	b.cd_unidade_medida,
	'N',
	b.qt_dose
order by
	1, 2;
	
c11 CURSOR FOR
SELECT	nr_sequencia,
		ie_classif_urgente,
		ie_controlado,
		ie_padronizado
from		classif_lote_disp_far
where	cd_estabelecimento = cd_estabelecimento_w
and		ie_situacao = 'A'
order by ie_classif_urgente,
		ie_controlado desc,
		ie_padronizado desc;


BEGIN

select	count(*)
into STRICT		qt_w
from		nut_paciente_hor
where	nr_seq_nut_protocolo	= nr_seq_nut_pac_p
and		dt_horario				= dt_horario_p
and		coalesce(ie_horario_especial,'N')	= 'N';

dt_validade_w		:= clock_timestamp() - interval '999 days' / 24;

ie_data_lib_prescr_w := obter_param_usuario(1113, 115, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_lib_prescr_w);
nr_seq_classif_param_w := obter_param_usuario(1113, 498, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, nr_seq_classif_param_w);

if (qt_w = 0) then

	select	coalesce(max(ie_acm),'N')
	into STRICT	ie_acm_w
	from	nut_pac
	where	nr_prescricao	= nr_prescricao_p
	and		nr_sequencia	= nr_seq_nut_pac_p;

	if (ie_acm_w	= 'N') or (ie_aprazando_p	= 'S') then
	    		
		select	count(*) + 1
		into STRICT	nr_etapa_w
		from	nut_paciente_hor
		where	nr_seq_nut_protocolo	= nr_seq_nut_pac_p
		and		coalesce(ie_horario_especial,'N')	= 'N';

		ie_horario_especial_w	:= 'N';
	else
		nr_etapa_w	:= 0;
		ie_horario_especial_w	:= 'S';
	
	end if;	

	select	nextval('nut_paciente_hor_seq')
	into STRICT	nr_seq_hor_w
	;

	
	insert into nut_paciente_hor(	
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_nut_protocolo,
			dt_horario,
			nr_etapa,
			ie_horario_especial)
	values (	nr_seq_hor_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_nut_pac_p,
			dt_horario_p,
			nr_etapa_w,
			ie_horario_especial_w);
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	
	if (ie_aprazando_p = 'S') then
		open C04;
		loop
		fetch C04 into	
			nr_prescricao_w,
			nr_seq_item_w,
			cd_local_estoque_w,
			nr_agrupamento_w,
			cd_material_w,		
			cd_unidade_medida_w,		
			ie_sn_w,
			ie_acm_w,
			qt_dose_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			ie_cursor_w := 'S';
			
			select	max(dt_liberacao),
					max(cd_estabelecimento)
			into STRICT	dt_liberacao_w,
					cd_estabelecimento_w
			from	prescr_medica
			where	nr_prescricao = nr_prescricao_w;

			select	coalesce(max(qt_min_agora),0),
					coalesce(max(qt_min_especial),0),
					max(ie_classif_urgencia),
					coalesce(max(ie_forma_agora), 'N')
			into STRICT	qt_min_agora_w,
					qt_min_especial_w,
					ie_classif_nao_padrao_w,
					ie_agora_impressao_w
			from	parametros_farmacia
			where	cd_estabelecimento = cd_estabelecimento_w;
			
			dt_limite_agora_w	:= dt_liberacao_w + qt_min_agora_w/1440;
			dt_limite_especial_w	:= dt_liberacao_w + qt_min_especial_w/1440;
			
			if (coalesce(ie_gerar_classif_agora_w,'N') = 'S') then
				dt_hora_atual_w := clock_timestamp();
				dt_limite_agora_w	:=  dt_hora_atual_w + qt_min_agora_w/1440; 			
			end if;
			
			if (ie_sn_w = 'S') or (ie_acm_w = 'S') then			
				ie_acm_sn_w := 'S';
			else
				ie_acm_sn_w := 'N';
			end if;	
			
			ie_aprazar_w := 'S';
			if (ie_aprazar_w = 'S') then
				begin
				select	cd_estabelecimento,
						cd_setor_atendimento,
						dt_inicio_prescr
				into STRICT		cd_estab_prescr_w,
						cd_setor_prescr_w,
						dt_inicio_prescr_w
				from		prescr_medica
				where	nr_prescricao = nr_prescricao_w;
				
				ie_agrupador_w	:= 11;
				
				select	coalesce(min(nr_sequencia),0)
				into STRICT		nr_seq_orig_w
				from		prescr_mat_hor
				where	nr_prescricao = nr_prescricao_w
				and		nr_seq_material = nr_seq_item_w
				and		coalesce(ie_situacao,'A') = 'A'
				and		Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
									
				if (nr_seq_orig_w > 0) then
					select	qt_dose,
						qt_dispensar,
						qt_dispensar_hor,
						cd_unidade_medida,
						cd_unidade_medida_dose,
						ie_dispensar_farm
					into STRICT	qt_dose_w,
						qt_dispensar_w,
						qt_dispensar_hor_w,
						cd_unidade_medida_w,
						cd_unidade_medida_dose_w,
						ie_dispensar_farm_w
					from	prescr_mat_hor
					where	nr_sequencia = nr_seq_orig_w;
				else		
					cd_unid_med_dose_hor_w := null;
					qt_dose_hor_w	:= null;	
													
					SELECT * FROM obter_dose_um_horario_pmh(cd_material_w, qt_dose_w, cd_unidade_medida_dose_w, qt_dose_hor_w, cd_unid_med_dose_hor_w) INTO STRICT qt_dose_hor_w, cd_unid_med_dose_hor_w;							
				end if;
								
				select	coalesce(max(substr(Obter_se_medic_controlado(cd_material_w),1,1)),'N'),
					coalesce(max(substr(obter_se_material_padronizado(cd_estabelecimento_w, cd_material_w),1,1)),'N')
				into STRICT	ie_controlado_w,
					ie_padronizado_w
				;
				
				/*	Fabio e JonasJonas - 19/01/2010 = Para gerar os lotes como AGORA dependendo do horario final do turno, e nao mais pelo minutos de agora*/

				if (ie_agora_impressao_w = 'S') then
					nr_seq_turno_hor_ag_w	:= obter_turno_horario_prescr(cd_estabelecimento_w,cd_setor_prescr_w,to_char(dt_horario_p,'hh24:mi'), cd_local_estoque_w);
					select	max(to_char(b.hr_inicial,'hh24:mi')),
						max(to_char(b.hr_final,'hh24:mi'))
					into STRICT	hr_turno_agora_w,
							hr_final_turno_agora_w
					from	regra_turno_disp_param b,
							regra_turno_disp a
					where	a.nr_sequencia		= b.nr_seq_turno
					and	a.cd_estabelecimento	= cd_estabelecimento_w
					and	a.nr_sequencia		= nr_seq_turno_hor_ag_w
					and (coalesce(b.cd_setor_atendimento,coalesce(cd_setor_prescr_w,0))	= coalesce(cd_setor_prescr_w,0));

					select	coalesce(max(qt_min_antes_atend), 0),
						coalesce(max(ie_define_agora), 'N')
					into STRICT	qt_min_antes_atend_w,
						ie_define_agora_w
					from	regra_tempo_disp
					where	cd_estabelecimento	= cd_estabelecimento_w
					and (coalesce(cd_setor_atendimento,coalesce(cd_setor_prescr_w,0)) = coalesce(cd_setor_prescr_w,0))
					and		nr_seq_turno = nr_seq_turno_hor_ag_w
					and		ie_situacao = 'A';

					if (hr_turno_agora_w > hr_final_turno_agora_w) then
						if (pkg_date_utils.get_time(dt_horario_p, 0,0,0) > pkg_date_utils.get_time(dt_inicio_prescr_w, 0,0,0)) then
							dt_limite_agora_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_horario_p - 1, coalesce(hr_turno_agora_w, '00:00')) - (qt_min_antes_atend_w/1440);
						else
							dt_limite_agora_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_horario_p, coalesce(hr_turno_agora_w, '00:00')) - (qt_min_antes_atend_w/1440);
						end if;
					else
						dt_limite_agora_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_horario_p, coalesce(hr_turno_agora_w, '00:00')) - (qt_min_antes_atend_w/1440);
					end if;
				end if;
				/*	Fabio e Jonas - 19/01/2010 = Final da alteracao*/

				
				if (coalesce(ie_classif_nao_padrao_w::text, '') = '') or (ie_padronizado_w = 'S') then
					begin
					ie_classif_urgente_w	:= 'N';
					if (dt_horario_p <= dt_limite_agora_w) then
						ie_classif_urgente_w	:= 'A';
					elsif	((dt_limite_agora_w <= clock_timestamp()) and (ie_agora_impressao_w = 'S') and (ie_define_agora_w = 'N')) then
						ie_classif_urgente_w	:= 'A';
					elsif (ie_agora_impressao_w = 'S' and ie_define_agora_w = 'S') and
						(dt_horario_p <= (clock_timestamp() + (qt_min_antes_atend_w /1440))) then
						ie_classif_urgente_w	:= 'A';
					elsif (dt_horario_p <= dt_limite_especial_w) then
						ie_classif_urgente_w	:= 'E';
					end if;
					end;
				else
					ie_classif_urgente_w	:= ie_classif_nao_padrao_w;
				end if;
								
				ie_liberado_w := 'N';
				
				select	coalesce(max('S'),'N')
				into STRICT		ie_liberado_w
				from		prescr_mat_hor	
				where	nr_prescricao = nr_prescricao_w
				and		(dt_lib_horario IS NOT NULL AND dt_lib_horario::text <> '');
				
				select	nextval('prescr_mat_hor_seq')
				into STRICT		nr_seq_horario_w
				;

				insert into prescr_mat_hor(
					nr_sequencia,
					nr_seq_digito,
					nr_prescricao,
					nr_seq_material,
					ie_agrupador,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_material,
					qt_dose,
					qt_dispensar_hor,
					ds_horario,
					dt_horario,
					cd_unidade_medida,
					cd_unidade_medida_dose,
					ie_urgente,
					dt_emissao_farmacia,
					dt_fim_horario,
					dt_suspensao,
					ie_horario_especial,
					qt_hor_reaprazamento,
					nm_usuario_reaprazamento,
					nr_seq_turno,
					dt_disp_farmacia,
					ie_aprazado,
					ie_classif_urgente,
					ie_padronizado,
					ie_controlado,
					cd_unid_med_hor,
					qt_horario,
					ie_gerar_lote,
					dt_lib_horario,
					qt_dispensar,
					ie_dispensar_farm,
					cd_local_estoque,
					nr_atendimento
					)
				values (
					nr_seq_horario_w,
					calcula_digito('MODULO11',nr_seq_horario_w),
					nr_prescricao_w,
					nr_seq_item_w,
					--decode('M','M',1,12),
					ie_agrupador_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_material_w,
					qt_dose_w,
					qt_dispensar_hor_w,
					to_char(dt_horario_p,'hh24:mi'),
					dt_horario_p,
					cd_unidade_medida_w,
					cd_unidade_medida_dose_w,
					'N',
					CASE WHEN ie_gerar_necessidade_disp_w='S' THEN null  ELSE clock_timestamp() END ,
					null,
					null,
					'N',
					null,
					null,
					obter_turno_horario_prescr(coalesce(cd_estabelecimento_p,cd_estab_prescr_w),cd_setor_prescr_w,to_char(dt_horario_p,'hh24:mi'),cd_local_estoque_w),
					clock_timestamp(),
					'S',
					ie_classif_urgente_w,
					ie_padronizado_w,
					ie_controlado_w,
					coalesce(cd_unid_med_dose_hor_w, cd_unidade_medida_dose_w),
					qt_dose_w,
					coalesce(ie_gerar_lote_w,'S'),
					CASE WHEN ie_liberado_w='N' THEN  null  ELSE clock_timestamp() END ,
					qt_dispensar_w,
					ie_dispensar_farm_w,
					cd_local_estoque_w,
					nr_atendimento_p);						
					
				if (coalesce(nr_seq_classif_param_w ,0) > 0)	then
					begin
					update	prescr_mat_hor
					set	nr_seq_classif		= nr_seq_classif_param_w
					where	nr_prescricao		= nr_prescricao_w	
					and	nr_sequencia		= nr_seq_horario_w;
					end;
				else	
					open C11;
					loop
					fetch C11 into	
						nr_seq_classif_w,
						ie_classif_urgente_w,
						ie_controlado_w,
						ie_padronizado_w;
					EXIT WHEN NOT FOUND; /* apply on C11 */
						begin
						if (ie_controlado_w = 'A') and (ie_padronizado_w = 'A') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w	
							and	nr_sequencia		= nr_seq_horario_w
							--and	nr_seq_lote		is not null
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'A') and (ie_padronizado_w = 'S') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_padronizado		= 'S'
							and	nr_sequencia		= nr_seq_horario_w
							--and	nr_seq_lote		is not null
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'A') and (ie_padronizado_w = 'N') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_padronizado		= 'N'
							and	nr_sequencia		= nr_seq_horario_w
							--and	nr_seq_lote		is not null
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'N') and (ie_padronizado_w = 'A') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_controlado		= 'N'
							and	nr_sequencia		= nr_seq_horario_w
							--and	nr_seq_lote		is not null
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'N') and (ie_padronizado_w = 'N') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_controlado		= 'N'
							and	ie_padronizado		= 'N'
							and	nr_sequencia		= nr_seq_horario_w
							--and	nr_seq_lote		is not null
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'N') and (ie_padronizado_w = 'S') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_controlado		= 'N'
							and	ie_padronizado		= 'S'
							--and	nr_seq_lote		is not null
							and	nr_sequencia		= nr_seq_horario_w
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'S') and (ie_padronizado_w = 'A') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_controlado		= 'S'
							--and	nr_seq_lote		is not null
							and	nr_sequencia		= nr_seq_horario_w
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'S') and (ie_padronizado_w = 'N') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_controlado		= 'S'
							and	ie_padronizado		= 'N'
							--and	nr_seq_lote		is not null
							and	nr_sequencia		= nr_seq_horario_w
							and	ie_classif_urgente	= ie_classif_urgente_w;
						elsif (ie_controlado_w = 'S') and (ie_padronizado_w = 'S') then
							update	prescr_mat_hor
							set	nr_seq_classif		= nr_seq_classif_w
							where	nr_prescricao		= nr_prescricao_w
							and	ie_controlado		= 'S'
							and	ie_padronizado		= 'S'
							--and	nr_seq_lote		is not null
							and	nr_sequencia		= nr_seq_horario_w
							and	ie_classif_urgente	= ie_classif_urgente_w;
						end if;
					
						end;
					end loop;
					close C11;
				end if;

				if (ie_local_estoque_mat_hor_w	= 'S') then
				
					cd_setor_atendimento_w := cd_setor_prescr_w;
					if (ie_local_estoque_w = 'S') then
						CALL define_local_disp_prescr(nr_prescricao_w, nr_seq_item_w, obter_perfil_ativo, nm_usuario_p);
						select	max(cd_local_estoque)
						into STRICT	cd_local_estoque_w
						from	prescr_material b
						where	nr_prescricao	= nr_prescricao_w
						and	nr_sequencia	= nr_seq_item_w;
						
						cd_setor_atendimento_w		:= Obter_Setor_Atendimento(nr_atendimento_p);
					elsif (ie_local_estoque_w = 'R') then
						CALL define_local_disp_prescr(nr_prescricao_w, nr_seq_item_w, obter_perfil_ativo, nm_usuario_p);
						select	max(cd_local_estoque)
						into STRICT	cd_local_estoque_w
						from	prescr_material b
						where	nr_prescricao	= nr_prescricao_w
						and	nr_sequencia	= nr_seq_item_w;
						
						cd_setor_atendimento_w		:= Obter_Setor_Atendimento_lib(nr_atendimento_p);
					end if;
					
					CALL define_disp_prescr_mat_hor(nr_seq_horario_w, nr_prescricao_w, nr_seq_item_w, obter_perfil_ativo, nm_usuario_p);
				
					select	coalesce(max(cd_local_estoque),cd_local_estoque_w)
					into STRICT		cd_local_estoque_w
					from		prescr_mat_hor
					where	nr_sequencia	= nr_seq_horario_w;
					
					update	prescr_mat_hor
					set		nr_seq_turno	= coalesce(Obter_turno_horario_prescr(cd_estabelecimento_w, cd_setor_atendimento_w, to_char(dt_horario_p,'hh24:mi'), cd_local_estoque_w),nr_seq_turno)
					where	nr_sequencia	= nr_seq_horario_w;
				end if;
				
				/* gerar evento aprazamento */

				if	--(nr_prescr_atual_w <> nr_prescricao_w) and
					(coalesce(nr_seq_horario_w,0) > 0) then
					CALL gerar_evento_reaprazamento(nr_atendimento_p, nr_prescricao_w, nr_seq_item_w, nr_seq_horario_w, cd_material_w, 'M', ie_alteracao_w, null, null, nm_usuario_p, null,ie_acm_sn_w,null);
					CALL adep_gerar_area_prep(nr_prescricao_w, null, nm_usuario_p);
					CALL gerar_acm_sn_apraz_prescricao(nr_prescricao_w, nr_seq_item_w,cd_local_estoque_w,nm_usuario_p);	
				end if;

				/* atualizar prescricao */

				nr_prescr_atual_w := nr_prescricao_w;							
				end;
			else
				ie_inconsistencia_w := 'H';
				if (coalesce(ds_inconsistentes_w::text, '') = '') then
					ds_inconsistentes_w := to_char(nr_prescricao_w);
				elsif (position(nr_prescricao_w in ds_inconsistentes_w) = 0) then
					ds_inconsistentes_w := ds_inconsistentes_w || ', ' || to_char(nr_prescricao_w);
				end if;					
				
			end if;
		end loop;
		close C04;
		CALL Gerar_Lote_Atend_Prescricao(nr_prescricao_p, null, null, 'N', nm_usuario_p, 'AIP');
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nut_paciente_hor_prot ( nr_prescricao_p bigint, nr_atendimento_p bigint, nr_seq_nut_pac_p bigint, dt_horario_p timestamp, ie_aprazando_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
