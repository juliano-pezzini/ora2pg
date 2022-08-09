-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_rep_gerar_medicamento ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p cpoe_material.cd_pessoa_fisica%type, cd_funcao_origem_p funcao.cd_funcao%type , ie_tipo_pessoa_p text default 'N', cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null, nr_seq_agenda_p prescr_medica.nr_seq_agenda%type default null) AS $body$
DECLARE

					
_ora2pg_r RECORD;
nr_seq_material_w				prescr_material.nr_sequencia%type;
cd_material_w					prescr_material.cd_material%type;
cd_unidade_medida_dose_w		prescr_material.cd_unidade_medida_dose%type;
qt_dose_w						prescr_material.qt_dose%type;
ie_acm_w						prescr_material.ie_acm%type;
ie_se_necessario_w				prescr_material.ie_se_necessario%type;
ie_urgencia_w					prescr_material.ie_urgencia%type;
ds_horarios_w					prescr_material.ds_horarios%type;
hr_prim_horario_w				prescr_material.hr_prim_horario%type;
cd_intervalo_w					prescr_material.cd_intervalo%type;
ie_lado_w						prescr_material.ie_lado%type;
ie_via_aplicacao_w				prescr_material.ie_via_aplicacao%type;
nr_dia_util_w					prescr_material.nr_dia_util%type;
qt_total_dias_lib_w				prescr_material.qt_total_dias_lib%type;
ds_diluicao_edit_w				prescr_material.ds_diluicao_edit%type;
qt_hora_aplicacao_w				prescr_material.qt_hora_aplicacao%type;
qt_min_aplicacao_w				prescr_material.qt_min_aplicacao%type;
qt_solucao_w					prescr_material.qt_solucao%type;
ie_aplic_bolus_w				prescr_material.ie_aplic_bolus%type;
ie_aplic_lenta_w				prescr_material.ie_aplic_lenta%type;
qt_dia_prim_hor_w				prescr_material.qt_dia_prim_hor%type;
ds_justificativa_w				prescr_material.ds_justificativa%type;
qt_dias_solicitado_w			prescr_material.qt_dias_solicitado%type;
qt_dias_liberado_w				prescr_material.qt_dias_liberado%type;
ie_objetivo_w					prescr_material.ie_objetivo%type;
cd_microorganismo_cih_w			prescr_material.cd_microorganismo_cih%type;
cd_amostra_cih_w				prescr_material.cd_amostra_cih%type;
ie_origem_infeccao_w			prescr_material.ie_origem_infeccao%type;
cd_topografia_cih_w				prescr_material.cd_topografia_cih%type;
ie_indicacao_w					prescr_material.ie_indicacao%type;
ie_uso_antimicrobiano_w			prescr_material.ie_uso_antimicrobiano%type;
ie_medicacao_paciente_w			prescr_material.ie_medicacao_paciente%type;
ie_fator_correcao_w				prescr_material.ie_fator_correcao%type;
ie_bomba_infusao_w				prescr_material.ie_bomba_infusao%type;
ds_observacao_w					prescr_material.ds_observacao%type;
nr_ocorrencia_w					prescr_material.nr_ocorrencia%type;
nr_agrupamento_w				prescr_material.nr_agrupamento%type;
nr_agrupamento_ww				prescr_material.nr_agrupamento%type := 0;
cd_perfil_ativo_w				prescr_material.cd_perfil_ativo%type;
ds_dose_diferenciada_w			prescr_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_comp1_w	prescr_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_comp2_w	prescr_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_comp3_w	prescr_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_comp4_w	prescr_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_comp5_w	prescr_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_comp6_w	prescr_material.ds_dose_diferenciada%type;
ie_dose_espec_agora_w			prescr_material.ie_dose_espec_agora%type;
qt_dose_especial_w				prescr_material.qt_dose_especial%type;
hr_dose_especial_w				prescr_material.hr_dose_especial%type;
qt_min_aplic_dose_esp_w			prescr_material.qt_min_aplic_dose_esp%type;
cd_protocolo_w					prescr_material.cd_protocolo%type;
nr_seq_protocolo_w				prescr_material.nr_seq_protocolo%type;
cd_funcao_origem_w				prescr_medica.cd_funcao_origem%type;
hr_min_aplicacao_w				cpoe_material.hr_min_aplicacao%type;
nr_sequencia_w					cpoe_material.nr_sequencia%type;
ie_administracao_w				cpoe_material.ie_administracao%type;
dt_prim_horario_w				cpoe_material.dt_inicio%type;
ie_antibiotico_w				cpoe_material.ie_antibiotico%type;
dt_validade_prescr_w			prescr_medica.dt_validade_prescr%type;
nr_seq_ordem_adep_w				prescr_material.nr_seq_ordem_adep%type;
ds_insercao_w					varchar(1800);


ie_retrogrado_w			prescr_medica.ie_prescr_emergencia%type;
cd_medico_w					prescr_medica.cd_medico%type;

qt_composto_w					bigint;
ie_libera_cpoe_w				varchar(1);
ie_oncologia_w					cpoe_material.ie_oncologia%type;
nr_seq_atend_w					prescr_medica.nr_seq_atend%type;
dt_liberacao_enf_w				timestamp;
nm_usuario_lib_enf_w			prescr_medica.nm_usuario_lib_enf%type;
ie_param1562_cpoe_w				varchar(1);
dt_fim_w						cpoe_material.dt_fim%type;
dt_protocolo_onc_w				cpoe_material.dt_protocolo_onc%type;
nr_seq_interno_onc_w			cpoe_material.nr_seq_interno_onc%type;

ie_justificativa_w      		regra_antimicrobiano.ie_justificativa%type;
ie_objetivo_proc_w      		regra_antimicrobiano.ie_objetivo%type;
ie_dia_utilizacao_w     		regra_antimicrobiano.ie_dia_utilizacao%type;
ie_topografia_w       			regra_antimicrobiano.ie_topografia%type;
ie_amostra_w         			regra_antimicrobiano.ie_amostra%type;
ie_microorganismo_w     		regra_antimicrobiano.ie_microorganismo%type;
ie_origem_w         			regra_antimicrobiano.ie_origem%type;
ie_exige_indicacao_w     		regra_antimicrobiano.ie_indicacao%type;
qt_dias_prev_w        			regra_antimicrobiano.qt_dias_prev%type;
ie_obj_regra_w        			regra_antimicrobiano.ie_objetivo_filtro%type;
ie_lib_auto_w        			regra_antimicrobiano.ie_lib_auto%type;
ie_possui_regra_w      			varchar(5);
ie_regra_intervalo_w			cpoe_material.cd_intervalo%type;
qt_dias_lib_padrao_w			parametro_medico.qt_dias_lib_padrao%type;

c01 CURSOR FOR
SELECT	nr_sequencia,
		cd_material,
		cd_unidade_medida_dose,
		qt_dose,
		ds_dose_diferenciada,
		coalesce(ie_acm,'N'),
		coalesce(ie_se_necessario,'N'),
		coalesce(ie_urgencia,'N'),
		ds_horarios,
		hr_prim_horario,
		cd_intervalo,
		ie_lado,
		ie_via_aplicacao,
		nr_dia_util,
		nr_ocorrencia,
		qt_total_dias_lib,
		ds_diluicao_edit,
		qt_hora_aplicacao,
		qt_min_aplicacao,
		qt_solucao,
		coalesce(ie_aplic_bolus,'N'),
		coalesce(ie_aplic_lenta,'N'),
		coalesce(qt_dia_prim_hor,0),
		ds_justificativa,
		qt_dias_solicitado,
		qt_dias_liberado,
		ie_objetivo,
		cd_microorganismo_cih,
		cd_amostra_cih,
		ie_origem_infeccao,
		cd_topografia_cih,
		ie_indicacao,
		coalesce(ie_uso_antimicrobiano,'N'),
		coalesce(ie_medicacao_paciente,'N'),
		coalesce(ie_fator_correcao,'N'),
		ie_bomba_infusao,
		ds_observacao,
		nr_agrupamento,
		cd_perfil_ativo,
		coalesce(ie_dose_espec_agora,'N'),
		qt_dose_especial,
		hr_dose_especial,
		qt_min_aplic_dose_esp,
		cd_protocolo,
		nr_seq_protocolo,
		nr_seq_ordem_adep,
		nr_seq_atend_medic
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and		ie_agrupador = 1;



BEGIN

select	max(cd_funcao_origem),
		max(coalesce(ie_prescr_emergencia,'N')),
		max(nr_seq_atend),
		max(dt_liberacao),
		max(nm_usuario_lib_enf),
		max(cd_medico)
into STRICT	cd_funcao_origem_w,
		ie_retrogrado_w,
		nr_seq_atend_w,
		dt_liberacao_enf_w,
		nm_usuario_lib_enf_w,
		cd_medico_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

dt_validade_prescr_w	:= dt_validade_prescr_p;

ie_libera_cpoe_w := 'N';
if (cd_funcao_origem_w = 924) or (cd_funcao_origem_w = 950) or (cd_funcao_origem_w = 281) or (cd_funcao_origem_w = 900) or (cd_funcao_origem_w = 3130) or (cd_funcao_origem_w = 440) or (cd_funcao_origem_w = 872) or (cd_funcao_origem_w = 381) or (cd_funcao_origem_w = -9) or (cd_funcao_origem_w = -2025) or (cd_funcao_origem_w = 99072) or (ie_retrogrado_w = 'S' and ie_tipo_pessoa_p = 'S')
	then
	ie_libera_cpoe_w := 'S';
end if;

open c01;
loop
fetch c01 into	nr_seq_material_w,
				cd_material_w,
				cd_unidade_medida_dose_w,
				qt_dose_w,
				ds_dose_diferenciada_w,
				ie_acm_w,
				ie_se_necessario_w,
				ie_urgencia_w,
				ds_horarios_w,
				hr_prim_horario_w,
				cd_intervalo_w,
				ie_lado_w,
				ie_via_aplicacao_w,
				nr_dia_util_w,
				nr_ocorrencia_w,
				qt_total_dias_lib_w,
				ds_diluicao_edit_w,
				qt_hora_aplicacao_w,
				qt_min_aplicacao_w,
				qt_solucao_w,
				ie_aplic_bolus_w,
				ie_aplic_lenta_w,
				qt_dia_prim_hor_w,
				ds_justificativa_w,
				qt_dias_solicitado_w,
				qt_dias_liberado_w,
				ie_objetivo_w,
				cd_microorganismo_cih_w,
				cd_amostra_cih_w,
				ie_origem_infeccao_w,
				cd_topografia_cih_w,
				ie_indicacao_w,
				ie_uso_antimicrobiano_w,
				ie_medicacao_paciente_w,
				ie_fator_correcao_w,
				ie_bomba_infusao_w,
				ds_observacao_w,
				nr_agrupamento_w,
				cd_perfil_ativo_w,
				ie_dose_espec_agora_w,
				qt_dose_especial_w,
				hr_dose_especial_w,
				qt_min_aplic_dose_esp_w,
				cd_protocolo_w,
				nr_seq_protocolo_w,
				nr_seq_ordem_adep_w,
				nr_seq_interno_onc_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	dt_fim_w := null;
	begin
	if (nr_agrupamento_w <> nr_agrupamento_ww) then
		nr_agrupamento_ww := nr_agrupamento_w;
		qt_composto_w := 1;
		ie_administracao_w := 'P';
		if (ie_acm_w = 'S') then
			ie_administracao_w := 'C';
			hr_prim_horario_w := '';
			ds_horarios_w := '';
		elsif (ie_se_necessario_w = 'S') then
			ie_administracao_w := 'N';
			hr_prim_horario_w := '';
			ds_horarios_w := '';
		else
			-- Clear out the text inside the line and adds the sufix of ":00" as needed, fitting it 		
			ds_horarios_w := REPLACE(Padroniza_horario_prescr(ds_horarios_w,NULL),'A','');
			
			if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
				hr_prim_horario_w := obter_prim_dshorarios(ds_horarios_w);
			end if;
		end if;


		dt_prim_horario_w := dt_inicio_prescr_p + qt_dia_prim_hor_w;
		
		select	nextval('cpoe_material_seq')
		into STRICT	nr_sequencia_w
		;
		
		
		if (coalesce(cd_unidade_medida_dose_w::text, '') = '') then
			select max(CD_UNIDADE_MEDIDA_CONSUMO)
			into STRICT	cd_unidade_medida_dose_w
			from	material
			where	cd_material = cd_material_w;
		end if;
		
		if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
			begin
				dt_prim_horario_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prim_horario_w, hr_prim_horario_w);
			exception
			when others then
				dt_prim_horario_w	:= dt_inicio_prescr_p + qt_dia_prim_hor_w;				
			end;
		end if;
		
		if (dt_inicio_prescr_p > dt_prim_horario_w and coalesce(ie_acm_w, 'N') = 'N' and coalesce(ie_se_necessario_w,'N') = 'N' and coalesce(ie_urgencia_w, 'N') = 'N') then
			dt_prim_horario_w := dt_prim_horario_w + 1;
		end if;
		
		begin
			if ((coalesce(qt_hora_aplicacao_w, 0) > 0) or (coalesce(qt_min_aplicacao_w, 0) > 0)) then
			
				if (coalesce(qt_hora_aplicacao_w, 0) = 0) then
					hr_min_aplicacao_w := '00';
				elsif (length(qt_hora_aplicacao_w) = 1) then
					hr_min_aplicacao_w := '0' || qt_hora_aplicacao_w;
				else
					hr_min_aplicacao_w := qt_hora_aplicacao_w;
				end if;
				
				hr_min_aplicacao_w := hr_min_aplicacao_w || ':';
				
				if (coalesce(qt_min_aplicacao_w, 0) = 0) then
					hr_min_aplicacao_w := hr_min_aplicacao_w || '00';
				elsif (length(qt_min_aplicacao_w) = 1) then
					hr_min_aplicacao_w := hr_min_aplicacao_w || '0' || qt_min_aplicacao_w;
				else
					hr_min_aplicacao_w := hr_min_aplicacao_w  || qt_min_aplicacao_w;
				end if;
				
			end if;
		exception when others then
		 	null;
		end;	

		if (cd_funcao_origem_w not in (281,3130,381)) then
			nr_agrupamento_w := null;
		end if;	

		if (cd_funcao_origem_w in (281,3130,381)) then
			dt_protocolo_onc_w := obter_data_protocolo_onco_gpt(nr_prescricao_p);
		end if;

		if ((cd_funcao_origem_w not in (924,950)) or
		    ((cd_funcao_origem_w in (924,950)) and (dt_prim_horario_w <= dt_validade_prescr_w))) then
			
			if (position('A' in CPOE_Padroniza_horario_prescr(ds_horarios_w, dt_prim_horario_w)) = 0 and cd_funcao_origem_w = 281) then
				ie_param1562_cpoe_w := obter_param_usuario(281, 1562, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1), ie_param1562_cpoe_w);
				if (ie_param1562_cpoe_w = 'F') then					
					dt_fim_w := fim_dia(dt_prim_horario_w);
				end if;
			end if;
			
			if (coalesce(obter_se_mat_antibiotico(cd_material_w), 'N') = 'S') then
				SELECT * FROM cpoe_obter_dados_antimicrob(cd_material_w, wheb_usuario_pck.get_cd_perfil, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1), nm_usuario_p, ie_objetivo_w, cd_intervalo_w) INTO STRICT _ora2pg_r;
 ie_justificativa_w := _ora2pg_r.ie_justificativa_p; ie_objetivo_proc_w := _ora2pg_r.ie_objetivo_p; ie_dia_utilizacao_w := _ora2pg_r.ie_dia_utilizacao_p; ie_topografia_w := _ora2pg_r.ie_topografia_p; ie_amostra_w := _ora2pg_r.ie_amostra_p; ie_microorganismo_w := _ora2pg_r.ie_microorganismo_p; ie_origem_w := _ora2pg_r.ie_origem_p; ie_exige_indicacao_w := _ora2pg_r.ie_exige_indicacao_p; qt_dias_prev_w := _ora2pg_r.qt_dias_prev_p; ie_obj_regra_w := _ora2pg_r.ie_obj_regra_p; ie_lib_auto_w := _ora2pg_r.ie_lib_auto_p; ie_possui_regra_w := _ora2pg_r.ie_possui_regra_p; ie_regra_intervalo_w := _ora2pg_r.ie_regra_intervalo_p; qt_dias_lib_padrao_w := _ora2pg_r.qt_dias_lib_padrao_p;
											
				ie_antibiotico_w := ie_possui_regra_w;				
			end if;						
			
			insert into cpoe_material(
						nr_sequencia,
						nr_atendimento,
						ie_controle_tempo,
						ie_administracao,
						ie_duracao,
						dt_inicio,
						dt_fim,
						dt_prox_geracao,
						dt_liberacao,
						cd_material,
						cd_unidade_medida,
						qt_dose,
						ie_acm,
						ie_se_necessario,
						ie_urgencia,
						ds_horarios,
						hr_prim_horario,
						cd_intervalo,
						ie_lado,
						ie_via_aplicacao,
						nr_dia_util,
						nr_ocorrencia,
						nr_etapas,
						qt_total_dias_lib,
						ds_orientacao_preparo,
						qt_hora_aplicacao,
						qt_min_aplicacao,
						hr_min_aplicacao,
						qt_solucao,
						ie_aplic_bolus,
						ie_aplic_lenta,
						ds_justificativa,
						qt_dias_solicitado,
						qt_dias_liberado,
						ie_objetivo,
						cd_microorganismo_cih,
						cd_amostra_cih,
						ie_origem_infeccao,
						cd_topografia_cih,
						ie_indicacao,
						ie_uso_antimicrobiano,
						ie_medicacao_paciente,
						ie_fator_correcao,
						ie_bomba_infusao,
						ds_observacao,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec,
						cd_perfil_ativo,
						qt_tempo_aplicacao,
						ds_dose_diferenciada,
						cd_pessoa_fisica,
						ie_material,
						cd_funcao_origem,
						cd_setor_atendimento,
						ie_retrogrado,
						ie_oncologia,
						dt_liberacao_enf,
						nm_usuario_lib_enf,
						cd_medico,
						nr_seq_agenda,
						cd_protocolo,
						nr_seq_protocolo,
						nr_agrupamento,
						dt_protocolo_onc,
						ie_antibiotico,
						nr_seq_interno_onc)
					values (
						nr_sequencia_w,
						nr_atendimento_p,
						'N',
						ie_administracao_w,
						'P',
						dt_prim_horario_w,
						coalesce(dt_fim_w, dt_validade_prescr_p),
						dt_prim_horario_w + 12/24,
						CASE WHEN ie_libera_cpoe_w='S' THEN  dt_liberacao_p  ELSE null END ,
						cd_material_w,
						cd_unidade_medida_dose_w,
						qt_dose_w,
						ie_acm_w,
						ie_se_necessario_w,
						CASE WHEN ie_urgencia_w='S' THEN '0'  ELSE null END ,
						ds_horarios_w,
						hr_prim_horario_w,
						cd_intervalo_w,
						ie_lado_w,
						ie_via_aplicacao_w,
						nr_dia_util_w,
						nr_ocorrencia_w,
						nr_ocorrencia_w,
						qt_total_dias_lib_w,
						ds_diluicao_edit_w,
						qt_hora_aplicacao_w,
						qt_min_aplicacao_w,
						hr_min_aplicacao_w,
						qt_solucao_w,
						ie_aplic_bolus_w,
						ie_aplic_lenta_w,
						ds_justificativa_w,
						qt_dias_solicitado_w,
						qt_dias_liberado_w,
						ie_objetivo_w,
						cd_microorganismo_cih_w,
						cd_amostra_cih_w,
						ie_origem_infeccao_w,
						cd_topografia_cih_w,
						ie_indicacao_w,
						ie_uso_antimicrobiano_w,
						ie_medicacao_paciente_w,
						ie_fator_correcao_w,
						ie_bomba_infusao_w,
						ds_observacao_w,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						cd_perfil_ativo_w,
						24,
						ds_dose_diferenciada_w,
						cd_pessoa_fisica_p,
						'N',
						cd_funcao_origem_p,
						cd_setor_atendimento_p,
						ie_retrogrado_w,
						CASE WHEN coalesce(nr_seq_atend_w::text, '') = '' THEN 'N'  ELSE 'S' END ,
						dt_liberacao_enf_w,
						nm_usuario_lib_enf_w,
						cd_medico_w,
						nr_seq_agenda_p,
						cd_protocolo_w,
						nr_seq_protocolo_w,
						coalesce(nr_seq_ordem_adep_w,nr_agrupamento_w),
						dt_protocolo_onc_w,
						ie_antibiotico_w,
						nr_seq_interno_onc_w);
						
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		ie_dose_adicional	= ie_dose_espec_agora_w,
						qt_dose_adicional	= qt_dose_especial_w,
						hr_min_aplic_adic	= obter_horas_minutos(qt_min_aplic_dose_esp_w),
						dt_adm_adicional	= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prim_horario_w, hr_dose_especial_w)
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
						
			CALL cpoe_rep_gerar_dil_redil_recon(nr_prescricao_p, nr_sequencia_w, nr_seq_material_w, 'S', 'CD_MAT_RECONS');
			
			CALL cpoe_rep_gerar_albumina_medic(nr_sequencia_w, nr_prescricao_p, nr_seq_material_w);
						
			update	prescr_material
			set		nr_seq_mat_cpoe = nr_sequencia_w
			where	nr_sequencia = nr_seq_material_w
			and		nr_prescricao = nr_prescricao_p;
		else
			ds_insercao_w	:= substr(
			'Insercao REP/CPOE (new)= '	||
			' NR_PRESCRICAO-'			|| nr_prescricao_p || 
			' NR_SEQ_MATERIAL-'			|| nr_seq_material_w || 
			' DT_PRIM_HORARIO_W-'		|| PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_prim_horario_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| 
			' DT_VALIDADE_PRESCR_P-'	|| PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_validade_prescr_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| 
			' CD_FUNCAO_ORIGEM_P-' 		|| cd_funcao_origem_p
			,1,1800);
			CALL Gerar_log_prescr_mat(nr_prescricao_p, nr_seq_material_w, 1, null, null, ds_insercao_w, coalesce(nm_usuario_p,wheb_usuario_pck.get_nm_usuario), 'N');
		end if;
	else
		if (qt_composto_w = 1) then
			update	cpoe_material
			set		cd_mat_comp1				= cd_material_w,
					qt_dose_comp1				= qt_dose_w,
					cd_unid_med_dose_comp1		= cd_unidade_medida_dose_w,
					ds_dose_diferenciada_comp1	= ds_dose_diferenciada_comp1_w
			where	nr_sequencia 				= nr_sequencia_w;
			
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		qt_dose_adic_comp1	= qt_dose_w
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
			
		elsif (qt_composto_w = 2) then
			update	cpoe_material
			set		cd_mat_comp2				= cd_material_w,
					qt_dose_comp2				= qt_dose_w,
					cd_unid_med_dose_comp2		= cd_unidade_medida_dose_w,
					ds_dose_diferenciada_comp2	= ds_dose_diferenciada_comp2_w
			where	nr_sequencia 				= nr_sequencia_w;
			
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		qt_dose_adic_comp2	= qt_dose_w
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
			
		elsif (qt_composto_w = 3) then
			update	cpoe_material
			set		cd_mat_comp3				= cd_material_w,
					qt_dose_comp3				= qt_dose_w,
					cd_unid_med_dose_comp3		= cd_unidade_medida_dose_w,
					ds_dose_diferenciada_comp3	= ds_dose_diferenciada_comp3_w
			where	nr_sequencia 				= nr_sequencia_w;
			
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		qt_dose_adic_comp3	= qt_dose_w
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
			
		elsif (qt_composto_w = 4) then
			update	cpoe_material
			set		cd_mat_comp4				= cd_material_w,
					qt_dose_comp4				= qt_dose_w,
					cd_unid_med_dose_comp4		= cd_unidade_medida_dose_w,
					ds_dose_diferenciada_comp4	= ds_dose_diferenciada_comp4_w
			where	nr_sequencia 				= nr_sequencia_w;
			
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		qt_dose_adic_comp4	= qt_dose_w
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
			
		elsif (qt_composto_w = 5) then
			update	cpoe_material
			set		cd_mat_comp5				= cd_material_w,
					qt_dose_comp5				= qt_dose_w,
					cd_unid_med_dose_comp5		= cd_unidade_medida_dose_w,
					ds_dose_diferenciada_comp5	= ds_dose_diferenciada_comp5_w
			where	nr_sequencia 				= nr_sequencia_w;
			
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		qt_dose_adic_comp5	= qt_dose_w
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
			
		elsif (qt_composto_w = 6) then
			update	cpoe_material
			set		cd_mat_comp6				= cd_material_w,
					qt_dose_comp6				= qt_dose_w,
					cd_unid_med_dose_comp6		= cd_unidade_medida_dose_w,
					ds_dose_diferenciada_comp6	= ds_dose_diferenciada_comp6_w
			where	nr_sequencia 				= nr_sequencia_w;
			
			if (ie_dose_espec_agora_w = 'S') then
				update	cpoe_material
				set		qt_dose_adic_comp6	= qt_dose_w
				where	nr_sequencia		= nr_sequencia_w;					
			end if;
			
		end if;

    update	prescr_material
		set		nr_seq_mat_cpoe = nr_sequencia_w
		where	nr_sequencia = nr_seq_material_w
		and		nr_prescricao = nr_prescricao_p;

		if ((nr_seq_atend_w IS NOT NULL AND nr_seq_atend_w::text <> '') and coalesce(qt_composto_w, 0) > 0 and coalesce(qt_composto_w, 0) < 7) then
			CALL cpoe_rep_gerar_dil_redil_recon(nr_prescricao_p, nr_sequencia_w, nr_seq_material_w, 'S', 'CD_MAT_RECONS'||qt_composto_w);
		end if;
		qt_composto_w := qt_composto_w + 1;
	end if;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_rep_gerar_medicamento ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p cpoe_material.cd_pessoa_fisica%type, cd_funcao_origem_p funcao.cd_funcao%type , ie_tipo_pessoa_p text default 'N', cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null, nr_seq_agenda_p prescr_medica.nr_seq_agenda%type default null) FROM PUBLIC;
