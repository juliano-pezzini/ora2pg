-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_solucao ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_solucoes_continuas_p text, ie_solucoes_interrompidas_p text, ie_prescr_setor_p text, ie_formato_solucoes_p text, cd_setor_paciente_p bigint, qt_horas_anteriores_p bigint, qt_horas_adicionais_p bigint, dt_referencia_p timestamp, ie_palm_p text, ie_quimio_p text, ie_html_p text) AS $body$
DECLARE

	nr_seq_wadep_w		bigint;
	nr_seq_solucao_w	integer;
	ds_solucao_w		varchar(255);
	ie_acm_sn_w		varchar(1);
	ds_prescricao_w		varchar(240);
	ds_componentes_w	varchar(2000);
	ie_status_solucao_w	varchar(15);
	ie_status_processo_w	varchar(15);
	ie_suspensa_w		varchar(1);
	dt_prev_prox_etapa_w	timestamp;
	dt_lib_farm_w		timestamp;
	current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)	varchar(1);
	cd_motivo_baixa_w	bigint;
	dt_iniciosol_w		timestamp;	
	ie_vencida_w		varchar(1);
	ie_quimio_w		varchar(1);
	ie_sol_custo_w		varchar(3);
	ie_alto_risco_w		varchar(3);
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();
	ie_oncologia_w		varchar(1);
	ie_item_ordem_w		varchar(1);
	ie_regra_disp_w		varchar(1);
	nr_seq_sol_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
	nr_prescrioes_w		varchar(2000);
	dt_suspensao_cpoe_w	timestamp;
	ie_prescr_anest_w		varchar(1);
	c01 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_solucao, 
			ds_solucao,
			ie_acm_sn,	
			ds_prescricao,
			ds_componentes,
			ie_status_solucao,
			null,
			dt_prev_prox_etapa,
			cd_motivo_baixa,
			ie_vencida,
			CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END  ie_quimio,
			ie_alto_custo,
			ie_alto_risco,
			ie_oncologia,
			ie_item_ordem,
			ie_regra_disp,
			nr_seq_sol_cpoe,
			ie_prescr_anest
	from	(
		SELECT	CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prescricao_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE a.nr_prescricao END  nr_prescricao,
			CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  get_nr_seq_solucao_agrupada(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE x.nr_seq_solucao END  nr_seq_solucao,
			substr(CASE WHEN GetJuntaCompSolucao='S' THEN obter_Concat_comp_sol(a.nr_prescricao,x.nr_seq_solucao)  ELSE coalesce(trim(both x.ds_solucao),obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)) END ,1,240) ds_solucao,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
			substr(obter_desc_vol_etapa_adep2(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prescricao_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE a.nr_prescricao END , CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  get_nr_seq_solucao_agrupada(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE x.nr_seq_solucao END ,x.ie_acm,x.ie_se_necessario, adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)),1,240) ds_prescricao,
			substr(CASE WHEN coalesce(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  null  ELSE obter_se_veloc_variavel(x.nr_prescricao, x.nr_seq_solucao) END  || chr(13) || get_cpoe_notes(obter_nr_seq_cpoe_sol(a.nr_prescricao, x.nr_seq_solucao)) || adep_gerar_horarios_pck.obter_valor_dose_ataque(obter_ds_solucao_dose_ataque(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao), dt_referencia_p)) || CASE WHEN coalesce(obter_nr_seq_cpoe_sol(a.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p)  ELSE get_solution_add_info(obter_nr_seq_cpoe_sol(a.nr_prescricao, x.nr_seq_solucao)) END  || chr(13) || obter_desc_expressao(301661) || ':' || substr(obter_Desc_via(x.ie_via_aplicacao),1,30) || chr(13) || CASE WHEN coalesce(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  CASE WHEN coalesce(x.DS_ORIENTACAO::text, '') = '' THEN ''  ELSE wheb_mensagem_pck.get_texto(857391,'ds_orientacao='|| x.DS_ORIENTACAO) END   ELSE null END  || adep_gerar_horarios_pck.obter_ds_justificativa(obter_justificativa_item(a.nr_prescricao, x.nr_seq_solucao, 'SOL')),1,2000) ds_componentes,
			substr(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_status_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao) END ,1,3) ie_status_solucao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prev_prox_etapa_adep(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE x.dt_prev_prox_etapa END  dt_prev_prox_etapa,
			CASE WHEN get_usa_legenda_item_baixado='S' THEN  CASE WHEN obter_se_item_sol_baixa(a.nr_prescricao,x.nr_seq_solucao)='S' THEN 1  ELSE 0 END   ELSE null END  cd_motivo_baixa,
			Obter_se_solucao_vencida(obter_data_inicio_prescr(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prescricao_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE a.nr_prescricao END ),24) ie_vencida,
			a.nr_seq_atend,
			coalesce(obter_se_sol_alto_custo(a.nr_prescricao,x.nr_seq_solucao,cd_estabelecimento_p),'N') ie_alto_custo,
			coalesce(obter_se_sol_alto_risco(a.nr_prescricao,x.nr_seq_solucao),'N') ie_alto_risco,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END  ie_oncologia,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_seq_solucao, 'S') ie_item_ordem,
			CASE WHEN obter_regra_disp_comp_sol(x.nr_prescricao, x.nr_seq_solucao)='E' THEN 'E'  ELSE null END  ie_regra_disp,
			obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao) nr_seq_sol_cpoe,
			obter_valor_prescr_medica_comp(a.nr_prescricao,'IE_PRESCRICAO_ANESTESICA') ie_prescr_anest
		from	prescr_solucao x,
			prescr_medica a
		where	x.nr_prescricao = a.nr_prescricao
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	coalesce(a.ie_hemodialise, 'N') <> 'R'
		and	obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico, x.dt_lib_material), coalesce(a.dt_liberacao, x.dt_lib_material), coalesce(coalesce(a.dt_liberacao_farmacia, x.dt_lib_farmacia),dt_lib_farm_w), ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	coalesce(x.nr_seq_dialise::text, '') = ''
		and	(((get_apresentar_sol_Agora_lib = 'S') and ((coalesce(x.ie_urgencia,'N') = 'S') and (coalesce(coalesce(a.dt_liberacao_medico,a.dt_liberacao), x.dt_lib_material) is not null))) or (get_apresentar_sol_Agora_lib = 'N') or ((coalesce(x.ie_urgencia,'N') <> 'S') and ((coalesce(a.dt_liberacao, x.dt_lib_material) IS NOT NULL AND (coalesce(a.dt_liberacao, x.dt_lib_material))::text <> ''))))
		and	a.dt_validade_prescr between dt_iniciosol_w and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp
		and	((get_ie_exibeSol_filtro = 'N') or (obter_se_sol_vig_adep(a.nr_prescricao, x.ie_status, qt_horas_anteriores_w, qt_horas_adicionais_w,dt_referencia_p,x.dt_suspensao, x.dt_status) = 'S'))
		and	((x.ie_status in ('I','INT') and ( dt_final_horarios_p >= buscar_ref_dt_inicio_solucao(a.nr_prescricao, x.nr_seq_solucao))) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, x.ie_etapa_especial) = 'N') and 
			  exists ( select 1 from prescr_mat_hor k where coalesce(k.ie_horario_especial,'N') = 'N' and k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'S' and k.dt_horario  between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, x.ie_etapa_especial) = 'S') and (obter_se_prescr_vig_adep(CASE WHEN Get_Param652='P' THEN a.dt_prescricao  ELSE a.dt_inicio_prescr END ,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S') and
			  (exists ( select 1 from prescr_mat_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and k.ie_agrupador = 4) or (ie_lib_pend_rep_p = 'N') or (ie_lib_pend_rep_p = 'S' AND x.dt_suspensao IS NOT NULL AND x.dt_suspensao::text <> '') or (ie_lib_pend_rep_p = 'S' and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '') and (a.dt_liberacao_farmacia IS NOT NULL AND a.dt_liberacao_farmacia::text <> ''))) and (not  exists ( select 1 from prescr_mat_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'N' and coalesce(k.nr_etapa_sol, 1) = 1 and ie_agrupador = 4 and coalesce(k.ie_horario_especial, 'N') = 'N'))
			  ))
		and	((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T'))
		and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((a.cd_funcao_origem = 2314 and ie_html_p = 'S') or (ie_solucoes_continuas_p = 'S' and ie_html_p = 'N') or (obter_se_sol_continua2(a.nr_prescricao,x.nr_seq_solucao,x.ds_solucao,dt_inicial_horarios_p, dt_final_horarios_p, dt_iniciosol_w, current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp, nr_prescrioes_w) = 'N'))
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))				 
		and	((ie_solucoes_interrompidas_p = 'S') or (x.ie_status <> 'INT'))
		and	((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SOL', 
																			cd_estabelecimento_p, 
																			cd_setor_usuario_p, 
																			cd_perfil_p, 
																			null, 
																			null, 
																			null, 
																			null,
																			a.cd_setor_Atendimento,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
																			null) = 'S'))) -- nr_seq_exame_p
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))
		group by
			a.nr_prescricao,
			x.nr_seq_solucao,
			x.ds_solucao,
			x.ie_acm,
			x.DS_ORIENTACAO,
			x.ie_se_necessario,
			nm_usuario_p,
			substr(CASE WHEN GetJuntaCompSolucao='S' THEN obter_Concat_comp_sol(a.nr_prescricao,x.nr_seq_solucao)  ELSE coalesce(trim(both x.ds_solucao),obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)) END ,1,240),
			cd_estabelecimento_p,
			obter_se_veloc_variavel(x.nr_prescricao, x.nr_seq_solucao),
			x.ie_suspenso,
			CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prev_prox_etapa_adep(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE x.dt_prev_prox_etapa END ,
			a.dt_inicio_prescr,
			a.nr_seq_atend,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END ,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_seq_solucao, 'S'),
			CASE WHEN obter_regra_disp_comp_sol(x.nr_prescricao, x.nr_seq_solucao)='E' THEN 'E'  ELSE null END ,
			obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao),
			x.ie_via_aplicacao
		order by a.nr_prescricao desc
		) alias187
	group by
		nr_prescricao, 
		nr_seq_solucao,
		ds_solucao,
		ie_acm_sn,	
		ds_prescricao,
		ds_componentes,
		ie_status_solucao,
		null,
		dt_prev_prox_etapa,
		cd_motivo_baixa,
		ie_vencida,
		CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END ,
		ie_alto_custo,
		ie_alto_risco,
		ie_oncologia,
		ie_item_ordem,
		ie_regra_disp,
		nr_seq_sol_cpoe,
		ie_prescr_anest;
	c02 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_solucao,
			ds_solucao,
			ie_acm_sn,	
			ds_prescricao,
			ds_componentes,
			ie_status_solucao,
			null,
			dt_prev_prox_etapa,
			CASE WHEN ie_lib_pend_rep='F' THEN CASE WHEN coalesce(ie_lib_farm,'N')='S' THEN 'F'  ELSE '' END   ELSE ie_lib_pend_rep END  ie_lib_pend_rep,
			cd_motivo_baixa,
			ie_vencida,
			CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END  ie_quimio,
			ie_alto_custo,
			ie_alto_risco,
			ie_oncologia,
			ie_item_ordem,
			ie_regra_disp,
			nr_seq_sol_cpoe,
			ie_prescr_anest
	from	(
		SELECT	CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prescricao_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE a.nr_prescricao END  nr_prescricao,
			CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  get_nr_seq_solucao_agrupada(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE x.nr_seq_solucao END  nr_seq_solucao,
			substr(CASE WHEN GetJuntaCompSolucao='S' THEN obter_Concat_comp_sol(a.nr_prescricao,x.nr_seq_solucao)  ELSE coalesce(trim(both x.ds_solucao),obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)) END ,1,240) ds_solucao,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
			substr(obter_desc_vol_etapa_adep2(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prescricao_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE a.nr_prescricao END , CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  get_nr_seq_solucao_agrupada(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE x.nr_seq_solucao END ,x.ie_acm,x.ie_se_necessario, adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)),1,240) ds_prescricao,
			substr(CASE WHEN coalesce(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  null  ELSE obter_se_veloc_variavel(x.nr_prescricao, x.nr_seq_solucao) END  || chr(13) || get_cpoe_notes(obter_nr_seq_cpoe_sol(a.nr_prescricao, x.nr_seq_solucao)) || adep_gerar_horarios_pck.obter_valor_dose_ataque(obter_ds_solucao_dose_ataque(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao), dt_referencia_p)) || obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p) || CASE WHEN coalesce(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  CASE WHEN coalesce(x.DS_ORIENTACAO::text, '') = '' THEN ''  ELSE wheb_mensagem_pck.get_texto(857391,'ds_orientacao='|| x.DS_ORIENTACAO) END   ELSE null END  || adep_gerar_horarios_pck.obter_ds_justificativa(obter_justificativa_item(a.nr_prescricao, x.nr_seq_solucao, 'SOL')),1,2000) ds_componentes,
			substr(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_status_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao) END ,1,3) ie_status_solucao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.dt_prev_prox_etapa,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			CASE WHEN get_usa_legenda_item_baixado='S' THEN CASE WHEN obter_se_item_sol_baixa(a.nr_prescricao,x.nr_seq_solucao)='S' THEN 1  ELSE 0 END   ELSE null END  cd_motivo_baixa,
			Obter_se_solucao_vencida(obter_data_inicio_prescr(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_prescricao_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE a.nr_prescricao END ),24) ie_vencida,
			a.nr_seq_atend,
			coalesce(obter_se_sol_alto_custo(a.nr_prescricao,x.nr_seq_solucao,cd_estabelecimento_p),'N') ie_alto_custo,
			coalesce(obter_se_sol_alto_risco(a.nr_prescricao,x.nr_seq_solucao),'N') ie_alto_risco,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END  ie_oncologia,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_seq_solucao, 'S') ie_item_ordem,
			CASE WHEN obter_regra_disp_comp_sol(x.nr_prescricao, x.nr_seq_solucao)='E' THEN 'E'  ELSE null END  ie_regra_disp,
			obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao) nr_seq_sol_cpoe,
			a.ie_lib_farm,
			obter_valor_prescr_medica_comp(a.nr_prescricao,'IE_PRESCRICAO_ANESTESICA') ie_prescr_anest
		from	prescr_solucao x,
			prescr_medica a
		where	x.nr_prescricao = a.nr_prescricao
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	coalesce(a.ie_hemodialise, 'N') <> 'R'
		and	a.dt_validade_prescr between dt_validade_limite_p and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp
		and	coalesce(obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, coalesce(a.dt_liberacao_farmacia,dt_lib_farm_w), ie_data_lib_prescr_p, a.ie_lib_farm),'N') = 'S'
		and	((get_ie_exibeSol_filtro = 'N') or (obter_se_sol_vig_adep(a.nr_prescricao, x.ie_status, qt_horas_anteriores_w, qt_horas_adicionais_w,dt_referencia_p,x.dt_suspensao, x.dt_status) = 'S'))
		and	(((coalesce(a.dt_liberacao::text, '') = '') or (coalesce(a.dt_liberacao_farmacia::text, '') = '')) and
		((exists ( select 1 from prescr_mat_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'N' and ie_agrupador = 4)) or (not exists ( select 1 from prescr_mat_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and k.ie_agrupador = 4))))
		and	(coalesce(a.dt_liberacao_medico, a.dt_liberacao_farmacia) IS NOT NULL AND (coalesce(a.dt_liberacao_medico, a.dt_liberacao_farmacia))::text <> '')
		and (not  exists ( select 1 from prescr_mat_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'S' and ie_agrupador = 4))			 		
		and	coalesce(x.nr_seq_dialise::text, '') = ''
		and 	coalesce(x.dt_suspensao::text, '') = ''
		and 	coalesce(a.dt_suspensao::text, '') = ''
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
		and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((a.cd_funcao_origem = 2314 and ie_html_p = 'S') or (ie_solucoes_continuas_p = 'S' and ie_html_p = 'N') or (obter_se_sol_continua2(a.nr_prescricao,x.nr_seq_solucao,x.ds_solucao,dt_inicial_horarios_p, dt_final_horarios_p, dt_iniciosol_w, current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp, null) = 'N'))
		and	((ie_solucoes_interrompidas_p = 'S') or (x.ie_status <> 'INT'))
		and	((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SOL', 
																			cd_estabelecimento_p, 
																			cd_setor_usuario_p, 
																			cd_perfil_p, 
																			null, 
																			null, 
																			null, 
																			null,
																			a.cd_setor_Atendimento,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
																			null) = 'S'))) -- nr_seq_exame_p
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))		
		group by
			a.nr_prescricao,
			x.nr_seq_solucao,
			x.ds_solucao,
			x.ie_acm,
			x.ie_se_necessario,
			substr(CASE WHEN GetJuntaCompSolucao='S' THEN obter_Concat_comp_sol(a.nr_prescricao,x.nr_seq_solucao)  ELSE coalesce(trim(both x.ds_solucao),obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)) END ,1,240),
			obter_se_veloc_variavel(x.nr_prescricao, x.nr_seq_solucao),
			x.DS_ORIENTACAO,
			nm_usuario_p,
			cd_estabelecimento_p,
			x.ie_suspenso,
			x.dt_prev_prox_etapa,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			a.dt_inicio_prescr,
			a.nr_seq_atend,
			a.ie_lib_farm,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END ,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_seq_solucao, 'S'),
			CASE WHEN obter_regra_disp_comp_sol(x.nr_prescricao, x.nr_seq_solucao)='E' THEN 'E'  ELSE null END ,
			obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao),
			obter_valor_prescr_medica_comp(a.nr_prescricao,'IE_PRESCRICAO_ANESTESICA')
		) alias146
	group by
		nr_prescricao, 
		nr_seq_solucao, 
		ds_solucao,
		ie_acm_sn,	
		ds_prescricao,
		ds_componentes,
		ie_status_solucao,
		null,
		dt_prev_prox_etapa,
		ie_lib_pend_rep,
		cd_motivo_baixa,
		ie_vencida,
		CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END ,
		ie_alto_custo,
		ie_alto_risco,
		ie_oncologia,
		ie_item_ordem,
		ie_regra_disp,
		nr_seq_sol_cpoe,
		ie_lib_farm,
		ie_prescr_anest;
	c03 CURSOR FOR
	SELECT	nr_prescricao			
	from	(
		SELECT	a.nr_prescricao,
				x.nr_seq_solucao,
				substr(CASE WHEN GetJuntaCompSolucao='S' THEN obter_Concat_comp_sol(a.nr_prescricao,x.nr_seq_solucao)  ELSE coalesce(trim(both x.ds_solucao),obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)) END ,1,240) ds_solucao,
				obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
				substr(obter_desc_vol_etapa_adep2(a.nr_prescricao,x.nr_seq_solucao,x.ie_acm,x.ie_se_necessario),1,240) ds_prescricao,
				substr(CASE WHEN coalesce(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  null  ELSE obter_se_veloc_variavel(x.nr_prescricao, x.nr_seq_solucao) END  || chr(13) || get_cpoe_notes(obter_nr_seq_cpoe_sol(a.nr_prescricao, x.nr_seq_solucao)) || adep_gerar_horarios_pck.obter_valor_dose_ataque(obter_ds_solucao_dose_ataque(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao), dt_referencia_p)) || obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p) || CASE WHEN coalesce(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)::text, '') = '' THEN  CASE WHEN coalesce(x.DS_ORIENTACAO::text, '') = '' THEN ''  ELSE wheb_mensagem_pck.get_texto(857391,'ds_orientacao='|| x.DS_ORIENTACAO) END   ELSE null END  || adep_gerar_horarios_pck.obter_ds_justificativa(obter_justificativa_item(a.nr_prescricao, x.nr_seq_solucao, 'SOL')),1,2000) ds_componentes,
				substr(CASE WHEN adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p)='S' THEN  obter_status_solucao_cpoe(obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao))  ELSE obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao) END ,1,3) ie_status_solucao,
				coalesce(x.ie_suspenso,'N') ie_suspenso,
				x.dt_prev_prox_etapa,
				CASE WHEN get_usa_legenda_item_baixado='S' THEN  CASE WHEN obter_se_item_sol_baixa(a.nr_prescricao,x.nr_seq_solucao)='S' THEN 1  ELSE 0 END   ELSE null END  cd_motivo_baixa,
				Obter_se_solucao_vencida(a.dt_inicio_prescr,get_horas_solucao_vence) ie_vencida,
				a.nr_seq_atend,
				coalesce(obter_se_sol_alto_custo(a.nr_prescricao,x.nr_seq_solucao,cd_estabelecimento_p),'N') ie_alto_custo,
				coalesce(obter_se_sol_alto_risco(a.nr_prescricao,x.nr_seq_solucao),'N') ie_alto_risco,
				CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END  ie_oncologia,
				obter_se_item_ordem_medica(x.nr_prescricao, x.nr_seq_solucao, 'S') ie_item_ordem,
				CASE WHEN obter_regra_disp_comp_sol(x.nr_prescricao, x.nr_seq_solucao)='E' THEN 'E'  ELSE null END  ie_regra_disp,
				obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao) nr_seq_sol_cpoe
		from	prescr_solucao x,
			prescr_medica a
		where	x.nr_prescricao = a.nr_prescricao
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	coalesce(a.ie_hemodialise, 'N') <> 'R'
		and	obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico, x.dt_lib_material), coalesce(a.dt_liberacao, x.dt_lib_material), coalesce(coalesce(a.dt_liberacao_farmacia, x.dt_lib_farmacia),dt_lib_farm_w), ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	coalesce(x.nr_seq_dialise::text, '') = ''
		and	(((get_apresentar_sol_Agora_lib = 'S') and ((coalesce(x.ie_urgencia,'N') = 'S') and (coalesce(coalesce(a.dt_liberacao_medico,a.dt_liberacao), x.dt_lib_material) is not null))) or (get_apresentar_sol_Agora_lib = 'N') or ((coalesce(x.ie_urgencia,'N') <> 'S') and ((coalesce(a.dt_liberacao, x.dt_lib_material) IS NOT NULL AND (coalesce(a.dt_liberacao, x.dt_lib_material))::text <> ''))))
		and	a.dt_validade_prescr between dt_iniciosol_w and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp
		and	((get_ie_exibeSol_filtro = 'N') or (obter_se_sol_vig_adep(a.nr_prescricao, x.ie_status, qt_horas_anteriores_w, qt_horas_adicionais_w,dt_referencia_p,x.dt_suspensao, x.dt_status) = 'S'))
		and	((x.ie_status in ('I','INT')) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, x.ie_etapa_especial) = 'N') and
			  exists ( select 1 from prescr_mat_hor k where coalesce(k.ie_horario_especial,'N') = 'N' and k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and k.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, x.ie_etapa_especial) = 'S') and (not  exists ( select 1 from prescr_mat_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_solucao = x.nr_seq_solucao and Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'N' and ie_agrupador = 4)) and (obter_se_prescr_vig_adep(CASE WHEN Get_Param652='P' THEN a.dt_prescricao  ELSE a.dt_inicio_prescr END ,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
		and	((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T'))
		and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))		
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))				 
		and	((ie_solucoes_interrompidas_p = 'S') or (x.ie_status <> 'INT'))
		and	((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SOL', 
																			cd_estabelecimento_p, 
																			cd_setor_usuario_p, 
																			cd_perfil_p, 
																			null, 
																			null, 
																			null, 
																			null,
																			a.cd_setor_Atendimento,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
																			null) = 'S'))) -- nr_seq_exame_p
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))
		and (adep_gerar_horarios_pck.get_ie_agrupa_solucao(ie_html_p) = 'S' or
			ie_solucoes_continuas_p = 'N' and ie_html_p = 'N')
		group by
			a.nr_prescricao,
			x.nr_seq_solucao,
			x.ds_solucao,
			x.ie_acm,
			x.DS_ORIENTACAO,
			x.ie_se_necessario,
			nm_usuario_p,
			substr(CASE WHEN GetJuntaCompSolucao='S' THEN obter_Concat_comp_sol(a.nr_prescricao,x.nr_seq_solucao)  ELSE coalesce(trim(both x.ds_solucao),obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)) END ,1,240),
			obter_se_veloc_variavel(x.nr_prescricao, x.nr_seq_solucao),
			cd_estabelecimento_p,
			x.ie_suspenso,
			x.dt_prev_prox_etapa,
			a.dt_inicio_prescr,
			a.nr_seq_atend,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END ,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_seq_solucao, 'S'),
			CASE WHEN obter_regra_disp_comp_sol(x.nr_prescricao, x.nr_seq_solucao)='E' THEN 'E'  ELSE null END ,
			obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)
		order by a.nr_prescricao desc
		) alias136
	group by
		nr_prescricao;
	
BEGIN
	SELECT * FROM adep_gerar_horarios_pck.getdtrefsol(dt_validade_limite_p, dt_iniciosol_w, current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp) INTO STRICT dt_iniciosol_w, current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp;	
	open C03;
	loop
	fetch C03 into	
		current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (coalesce(nr_prescrioes_w::text, '') = '') then
			nr_prescrioes_w	:= current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type;
		else
			nr_prescrioes_w	:= nr_prescrioes_w || ',' || current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type;
		end if;			
		end;
	end loop;
	close C03;
	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_solucao_w,
			ds_solucao_w,
			ie_acm_sn_w,		
			ds_prescricao_w,
			ds_componentes_w,
			ie_status_solucao_w,
			ie_suspensa_w,
			dt_prev_prox_etapa_w,
			cd_motivo_baixa_w,
			ie_vencida_w,
			ie_quimio_w,
			ie_sol_custo_w,
			ie_alto_risco_w,
			ie_oncologia_w,
			ie_item_ordem_w,
			ie_regra_disp_w,
			nr_seq_sol_cpoe_w,
			ie_prescr_anest_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		--Solucao
		dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_sol_cpoe_w, 'M');
		if	dt_suspensao_cpoe_w <= clock_timestamp() then
			ds_solucao_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_solucao_w,1,240);
		elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
			ds_solucao_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_solucao_w,1,240);
		end if;
		select	nextval('w_adep_t_seq')
		into STRICT	nr_seq_wadep_w
		;
		insert into w_adep_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			nr_prescricao,
			nr_seq_item,
			ds_item,
			ie_acm_sn,
			ds_prescricao,
			ds_diluicao,
			ie_status_item,
			ie_suspenso,
			dt_prev_term,
			nr_seq_proc_interno,
			nr_agrupamento,
			ie_diferenciado,
			nr_prescricoes,
			cd_item,
			cd_motivo_baixa,
			ds_componentes,
			ie_vencida,
			ie_quimio,
			ie_sol_custo,
			ie_alto_risco,
			ie_oncologia,
			ie_item_ordem,
			ie_regra_disp,
			nr_seq_cpoe,
			ie_prescricao_anestesica)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'SOL',
			current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_solucao_w,
			substr(ds_solucao_w,1,240),
			ie_acm_sn_w,
			ds_prescricao_w,
			CASE WHEN get_ie_gravar_diluicao_sol='S' THEN  ds_componentes_w  ELSE obter_desc_expressao(689983) END ,
			ie_status_solucao_w,
			ie_suspensa_w,
			dt_prev_prox_etapa_w,
			0,
			0,
			'N',
			current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			0,
			cd_motivo_baixa_w,
			ds_componentes_w,
			ie_vencida_w,
			ie_quimio_w,
			ie_sol_custo_w,
			ie_alto_risco_w,
			ie_oncologia_w,
			ie_item_ordem_w,
			ie_regra_disp_w,
			nr_seq_sol_cpoe_w,
			ie_prescr_anest_w);
		commit;
		end;
	end loop;
	close c01;
	if (ie_lib_pend_rep_p = 'S') then
		begin
		open c02;
		loop
		fetch c02 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_solucao_w,
				ds_solucao_w,
				ie_acm_sn_w,		
				ds_prescricao_w,
				ds_componentes_w,
				ie_status_solucao_w,
				ie_suspensa_w,
				dt_prev_prox_etapa_w,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				cd_motivo_baixa_w,
				ie_vencida_w,
				ie_quimio_w,
				ie_sol_custo_w,
				ie_alto_risco_w,
				ie_oncologia_w,
				ie_item_ordem_w,
				ie_regra_disp_w,
				nr_seq_sol_cpoe_w,
				ie_prescr_anest_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			--Solucao
			dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_sol_cpoe_w, 'M');
			if	dt_suspensao_cpoe_w <= clock_timestamp() then
				ds_solucao_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_solucao_w,1,240);
			elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
				ds_solucao_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_solucao_w,1,240);
			end if;
			select	nextval('w_adep_t_seq')
			into STRICT	nr_seq_wadep_w
			;
			insert into w_adep_t(
				nr_sequencia,
				nm_usuario,
				ie_tipo_item,
				nr_prescricao,
				nr_seq_item,
				ds_item,
				ie_acm_sn,
				ds_prescricao,
				ds_diluicao,
				ie_status_item,
				ie_suspenso,
				dt_prev_term,
				nr_seq_proc_interno,
				nr_agrupamento,
				ie_diferenciado,
				nr_prescricoes,
				ie_pendente_liberacao,
				cd_item,
				cd_motivo_baixa,
				ds_componentes,
				ie_vencida,
				ie_quimio,
				ie_sol_custo,
				ie_alto_risco,
				ie_oncologia,
				ie_item_ordem,
				ie_regra_disp,
				nr_seq_cpoe,
				ie_prescricao_anestesica)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'SOL',
				current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_solucao_w,
				substr(ds_solucao_w,1,240),
				ie_acm_sn_w,
				ds_prescricao_w,
				CASE WHEN get_ie_gravar_diluicao_sol='S' THEN  ds_componentes_w  ELSE obter_desc_expressao(689983) END ,
				ie_status_solucao_w,
				ie_suspensa_w,
				dt_prev_prox_etapa_w,
				0,
				0,
				'N',
				current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				0,
				cd_motivo_baixa_w,
				ds_componentes_w,
				ie_vencida_w,
				ie_quimio_w,
				ie_sol_custo_w,
				ie_alto_risco_w,
				ie_oncologia_w,
				ie_item_ordem_w,
				ie_regra_disp_w,
				nr_seq_sol_cpoe_w,
				ie_prescr_anest_w);
			commit;
			end;
		end loop;
		close c02;	
		end;
	end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_solucao ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_solucoes_continuas_p text, ie_solucoes_interrompidas_p text, ie_prescr_setor_p text, ie_formato_solucoes_p text, cd_setor_paciente_p bigint, qt_horas_anteriores_p bigint, qt_horas_adicionais_p bigint, dt_referencia_p timestamp, ie_palm_p text, ie_quimio_p text, ie_html_p text) FROM PUBLIC;
