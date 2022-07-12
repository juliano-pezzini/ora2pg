-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text) AS $body$
DECLARE

	nr_seq_wadep_w			bigint;
	nr_seq_procedimento_w		integer;
	cd_procedimento_w		bigint;
	ds_procedimento_w		varchar(255);
	nr_seq_lab_w			varchar(20);
	ie_acm_sn_w			varchar(1);
	cd_intervalo_w			varchar(7);
	qt_procedimento_w		double precision;
	ds_prescricao_w			varchar(240);
	ie_status_solucao_w		varchar(3);
	ie_status_w			varchar(1);
	nr_seq_proc_interno_w		bigint;
	ie_classif_adep_w		varchar(15);
	current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)		varchar(1);
	ie_horario_w			varchar(1);
	ie_util_hemocomponente_w	varchar(1);
	ds_diluicao_w			varchar(2000);
	ie_tipo_proced_w		varchar(255);
	ie_recem_nato_w			varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();
	ie_exibe_cuidados_w		varchar(1) := adep_gerar_horarios_pck.get_ie_exibe_cuidados_hm();
	ie_oncologia_w			varchar(1);
	nr_seq_proc_cpoe_w	prescr_procedimento.nr_seq_proc_cpoe%type;
	dt_suspensao_cpoe_w	timestamp;
	ds_observacao_w		varchar(255);
	ie_item_ordem_w		varchar(1);
	c01 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_procedimento, 
			cd_procedimento,
			ds_procedimento,
			ie_acm_sn,	
			cd_intervalo,
			qt_procedimento,
			ds_prescricao,
			ie_status_solucao,
			ie_suspenso,
			nr_seq_proc_interno,
			ie_classif_adep,
			nr_seq_lab,
			ds_diluicao,
			ie_util_hemocomponente,
			ie_tipo_proced,
			CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END  ie_oncologia,
			nr_seq_proc_cpoe,
			substr(ds_observacao,1,255),
			ie_item_ordem
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_procedimento,
			x.cd_procedimento,
			CASE WHEN coalesce(x.nr_seq_exame_sangue::text, '') = '' THEN CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado,y.ds_procedimento)  ELSE substr(Obter_desc_san_exame(x.nr_seq_exame_sangue),1,80) END  || ' ' || substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END  qt_procedimento,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100) ds_prescricao,
			substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			coalesce(x.nr_seq_proc_interno,0) nr_seq_proc_interno,
			'P' ie_classif_adep,
			x.nr_seq_lab,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo) ds_diluicao,
			x.ie_util_hemocomponente,
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100) ie_tipo_proced,
			a.nr_seq_atend, --decode(ie_palm_p,'S',obter_se_setor_oncologia(a.cd_setor_atendimento),null) ie_oncologia,
			x.nr_seq_proc_cpoe,
			x.ds_observacao ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM') ie_item_ordem
		FROM procedimento y, prescr_solic_bco_sangue p, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and x.nr_seq_solic_sangue = p.nr_sequencia and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S')) and ((get_ie_Visualiza_hem_naoLib = 'N') or (x.dt_liberacao_hemoterapia IS NOT NULL AND x.dt_liberacao_hemoterapia::text <> '')) and ((get_ie_Visualiza_hem_naoLib = 'N') or (coalesce(x.dt_cancelamento::text, '') = '')) and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((get_ie_mostrar_reservado = 'S') or (x.IE_UTIL_HEMOCOMPONENTE <> 'R')) and ((x.ie_status in ('I','INT')) or
			((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, 'N') = 'N') and (exists (select 1 from prescr_proc_hor k where coalesce(k.ie_horario_especial,'N') = 'N' and k.nr_prescricao = x.nr_prescricao and	k.nr_seq_procedimento = x.nr_sequencia and	Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'S' and	k.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p))) or
			((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, 'N') = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S') and
			 (exists (select 1 from prescr_proc_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_procedimento = x.nr_sequencia) or (ie_lib_pend_rep_p = 'N') or (ie_lib_pend_rep_p = 'S' AND x.dt_suspensao IS NOT NULL AND x.dt_suspensao::text <> '')) and (not exists (select 1 from prescr_proc_hor k where k.nr_prescricao = x.nr_prescricao and	k.nr_seq_procedimento = x.nr_sequencia and	Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'N' and	coalesce(k.nr_etapa, 1) = 1)))) and ((ie_exibir_sol_realizadas_p = 'S') or (coalesce(x.ie_status,'N') <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ie_regra_inclusao_p <> 'N' and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) and ((getIE_mostrar_outasBS = 'S') or (x.ie_tipo_proced <> 'BSST')) and ((obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, 'N') = 'S')
		or (exists (select	1
					from	prescr_proc_hor	h
					where	x.nr_prescricao	= h.nr_prescricao
					and		x.nr_sequencia	= h.nr_seq_procedimento
					and		h.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
					and		Obter_se_horario_liberado(h.dt_lib_horario, h.dt_horario) = 'S'
					and		h.ie_horario_especial = 'N'))) group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			coalesce(z.ds_derivado,y.ds_procedimento),
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END ,
			x.ie_suspenso,
			x.nr_seq_proc_interno,
			CASE WHEN coalesce(x.nr_seq_exame_sangue::text, '') = '' THEN CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado,y.ds_procedimento)  ELSE substr(Obter_desc_san_exame(x.nr_seq_exame_sangue),1,80) END ,
			'P',
			x.nr_seq_lab,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo),
			x.ie_util_hemocomponente,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100),
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100),
			substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100),
			a.nr_seq_atend,  --decode(ie_palm_p,'S',obter_se_setor_oncologia(a.cd_setor_atendimento),null)
			x.nr_seq_proc_cpoe,
			x.ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM')
		
union all

		select	a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			CASE WHEN coalesce(x.nr_seq_exame_sangue::text, '') = '' THEN CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado, w.ds_proc_exame)  ELSE substr(Obter_desc_san_exame(x.nr_seq_exame_sangue),1,80) END  || ' ' || substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END  qt_procedimento,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100) ds_prescricao,
			substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.nr_seq_proc_interno,
			coalesce(w.ie_classif_adep,'P'),
			x.nr_seq_lab,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo) ds_diluicao,
			x.ie_util_hemocomponente,
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100) ie_tipo_proced,
			a.nr_seq_atend, --decode(ie_palm_p,'S',obter_se_setor_oncologia(a.cd_setor_atendimento),null) ie_oncologia
			x.nr_seq_proc_cpoe,
			x.ds_observacao ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM') ie_item_ordem
		FROM procedimento y, proc_interno w, prescr_solic_bco_sangue p, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp and coalesce(w.ie_tipo,'O') <> 'G' and ((get_ie_Visualiza_hem_naoLib = 'N') or (x.dt_liberacao_hemoterapia IS NOT NULL AND x.dt_liberacao_hemoterapia::text <> '')) and ((get_ie_Visualiza_hem_naoLib = 'N') or (coalesce(x.dt_cancelamento::text, '') = '')) and coalesce(w.ie_ivc,'N') <> 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and x.nr_seq_solic_sangue = p.nr_sequencia and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S')) and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((get_ie_mostrar_reservado = 'S') or (x.IE_UTIL_HEMOCOMPONENTE <> 'R')) and ((x.ie_status in ('I','INT')) or
			((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, 'N') = 'N') and (exists (select 1 from prescr_proc_hor k where coalesce(k.ie_horario_especial,'N') = 'N' and k.nr_prescricao = x.nr_prescricao and	k.nr_seq_procedimento = x.nr_sequencia and	Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'S' and	k.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p))) or
			((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, 'N') = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S') and
			 (exists (select 1 from prescr_proc_hor k where k.nr_prescricao = x.nr_prescricao and k.nr_seq_procedimento = x.nr_sequencia) or (ie_lib_pend_rep_p = 'N') or (ie_lib_pend_rep_p = 'S' AND x.dt_suspensao IS NOT NULL AND x.dt_suspensao::text <> '')) and (not exists (select 1 from prescr_proc_hor k where k.nr_prescricao = x.nr_prescricao and	k.nr_seq_procedimento = x.nr_sequencia and	Obter_se_horario_liberado(k.dt_lib_horario, k.dt_horario) = 'N' and	coalesce(k.nr_etapa, 1) = 1)))) and ((ie_exibir_sol_realizadas_p = 'S') or (coalesce(x.ie_status,'N') <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ie_regra_inclusao_p <> 'N' and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) and ((getIE_mostrar_outasBS = 'S') or (x.ie_tipo_proced <> 'BSST')) and ((obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, 'N') = 'S')
		or (exists (select	1
					from	prescr_proc_hor	h
					where	x.nr_prescricao	= h.nr_prescricao
					and		x.nr_sequencia	= h.nr_seq_procedimento
					and		h.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
					and		Obter_se_horario_liberado(h.dt_lib_horario, h.dt_horario) = 'S'
					and		h.ie_horario_especial = 'N'))) group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			coalesce(z.ds_derivado, w.ds_proc_exame),
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END ,
			x.ie_suspenso,
			x.nr_seq_proc_interno,
			w.ie_classif_adep,
			x.nr_seq_lab,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo),
			x.ie_util_hemocomponente,
			CASE WHEN coalesce(x.nr_seq_exame_sangue::text, '') = '' THEN CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado, w.ds_proc_exame)  ELSE substr(Obter_desc_san_exame(x.nr_seq_exame_sangue),1,80) END  || ' ' || substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100),
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100),
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100),
			substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100),
			a.nr_seq_atend, --decode(ie_palm_p,'S',obter_se_setor_oncologia(a.cd_setor_atendimento),null)
			x.nr_seq_proc_cpoe,
			x.ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM')
		) alias251
	group by
		nr_prescricao, 
		nr_seq_procedimento, 
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,	
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		ie_status_solucao,
		ie_suspenso,
		nr_seq_proc_interno,
		ie_classif_adep,
		nr_seq_lab,
		ds_diluicao,
		ie_util_hemocomponente,
		ie_tipo_proced,
		CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END ,
		nr_seq_proc_cpoe,
		substr(ds_observacao,1,255),
		ie_item_ordem;
	c02 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_procedimento, 
			cd_procedimento,
			ds_procedimento,
			ie_acm_sn,	
			cd_intervalo,
			qt_procedimento,
			ds_prescricao,
			ie_status_solucao,
			ie_suspenso,
			nr_seq_proc_interno,
			ie_classif_adep,
			ie_lib_pend_rep,
			nr_seq_lab,
			ie_horario,
			ds_diluicao,
			ie_util_hemocomponente,
			ie_tipo_proced,
			ie_oncologia,
			nr_seq_proc_cpoe,
			substr(ds_observacao,1,255),
			ie_item_ordem
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_procedimento,
			x.cd_procedimento,
			CASE WHEN coalesce(x.nr_seq_exame_sangue::text, '') = '' THEN z.ds_derivado  ELSE substr(Obter_desc_san_exame(x.nr_seq_exame_sangue),1,80) END  || ' ' || substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END  qt_procedimento,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100) ds_prescricao,
			substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			coalesce(x.nr_seq_proc_interno,0) nr_seq_proc_interno,
			'P' ie_classif_adep,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			x.nr_seq_lab,
			CASE WHEN coalesce(x.ds_horarios::text, '') = '' THEN  'N'  ELSE 'S' END  ie_horario,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo) ds_diluicao,
			x.ie_util_hemocomponente,
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100) ie_tipo_proced,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END  ie_oncologia,
			x.nr_seq_proc_cpoe,
			x.ds_observacao ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM') ie_item_ordem
		FROM procedimento y, prescr_solic_bco_sangue p, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and ((get_ie_Visualiza_hem_naoLib = 'N') or (x.dt_liberacao_hemoterapia IS NOT NULL AND x.dt_liberacao_hemoterapia::text <> '')) and ((get_ie_Visualiza_hem_naoLib = 'N') or (coalesce(x.dt_cancelamento::text, '') = '')) and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and coalesce(x.dt_status::text, '') = '' and coalesce(x.ie_status::text, '') = '' and coalesce(x.dt_suspensao::text, '') = '' and x.nr_seq_solic_sangue = p.nr_sequencia and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S')) and ((get_ie_mostrar_reservado = 'S') or (x.IE_UTIL_HEMOCOMPONENTE <> 'R')) and coalesce(a.dt_suspensao::text, '') = '' and obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ie_regra_inclusao_p <> 'N' and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) and ((getIE_mostrar_outasBS = 'S') or (x.ie_tipo_proced <> 'BSST')) group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			CASE WHEN coalesce(x.nr_seq_exame_sangue::text, '') = '' THEN z.ds_derivado  ELSE substr(Obter_desc_san_exame(x.nr_seq_exame_sangue),1,80) END ,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END ,
			x.ie_suspenso,
			x.nr_seq_proc_interno,
			'P',
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			x.nr_seq_lab,
			x.ds_horarios,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo),
			x.ie_util_hemocomponente,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100),
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100),
			substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100),
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END ,
			x.nr_seq_proc_cpoe,
			x.ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM')
		
union all

		select	a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			z.ds_derivado || ' ' || substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END  qt_procedimento,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100) ds_prescricao,
			substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.nr_seq_proc_interno,
			coalesce(w.ie_classif_adep,'P'),
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			x.nr_seq_lab,
			CASE WHEN coalesce(x.ds_horarios::text, '') = '' THEN  'N'  ELSE 'S' END  ie_horario,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo) ds_diluicao,
			x.ie_util_hemocomponente,
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100) ie_tipo_proced,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END  ie_oncologia,
			x.nr_seq_proc_cpoe,
			x.ds_observacao ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM') ie_item_ordem
		FROM procedimento y, proc_interno w, prescr_solic_bco_sangue p, prescr_medica a, san_derivado z
LEFT OUTER JOIN prescr_procedimento x ON (z.nr_sequencia = x.nr_seq_derivado)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp and coalesce(w.ie_tipo,'O') not in ('G','BS') and ((get_ie_Visualiza_hem_naoLib = 'N') or (x.dt_liberacao_hemoterapia IS NOT NULL AND x.dt_liberacao_hemoterapia::text <> '')) and ((get_ie_Visualiza_hem_naoLib = 'N') or (coalesce(x.dt_cancelamento::text, '') = '')) and ((get_ie_mostrar_reservado = 'S') or (x.IE_UTIL_HEMOCOMPONENTE <> 'R')) and coalesce(w.ie_ivc,'N') <> 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and (x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') and coalesce(x.nr_seq_exame_sangue::text, '') = '' and coalesce(x.dt_status::text, '') = '' and coalesce(x.ie_status::text, '') = '' and x.nr_seq_solic_sangue = p.nr_sequencia and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S')) and obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ie_regra_inclusao_p <> 'N' and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) and ((getIE_mostrar_outasBS = 'S') or (x.ie_tipo_proced <> 'BSST')) group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			z.ds_derivado,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN x.qt_vol_hemocomp  ELSE x.qt_procedimento END ,
			x.ie_suspenso,
			x.nr_seq_proc_interno,
			w.ie_classif_adep,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			x.nr_seq_lab,
			x.ds_horarios,
			adep_dados_horarios_pck.get_ds_diluicao_hemo(x.nr_prescricao, x.nr_sequencia, p.nr_sequencia, p.ie_tipo),
			x.ie_util_hemocomponente,
			substr(CASE WHEN obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia)='BSHE' THEN  Obter_dados_prescr_hm(a.nr_prescricao, x.nr_sequencia, x.cd_procedimento)  ELSE adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario) END ,1,100),
			substr(obter_tipo_proc_bs(a.nr_prescricao, x.nr_sequencia),1,100),
			substr(obter_interv_cuidados_hm(x.nr_prescricao, x.nr_sequencia, get_ie_exibe_cuidados_hm),1,100),
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END ,
			x.nr_seq_proc_cpoe,
			x.ds_observacao,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'HM')
		) alias167
	group by
		nr_prescricao, 
		nr_seq_procedimento, 
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,	
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		ie_status_solucao,
		ie_suspenso,
		nr_seq_proc_interno,
		ie_classif_adep,
		ie_lib_pend_rep,
		nr_seq_lab,
		ie_horario,
		ds_diluicao,
		ie_util_hemocomponente,
		ie_tipo_proced,
		ie_oncologia,
		nr_seq_proc_cpoe,
		substr(ds_observacao,1,255),
		ie_item_ordem;
	
BEGIN

	if (obter_rastreabilidade_adep(nr_atendimento_p, 'PT') = 'S') then
		CALL adep_gerar_log_rastr(substr($$plsql_unit || ':' || $$plsql_line || chr(13)
			|| 'cd_estabelecimento_p:' || cd_estabelecimento_p || chr(13)
			|| 'cd_setor_usuario_p:' || cd_setor_usuario_p || chr(13)
			|| 'cd_perfil_p:' || cd_perfil_p || chr(13)
			|| 'nm_usuario_p:' || nm_usuario_p || chr(13)
			|| 'nr_atendimento_p:' || nr_atendimento_p || chr(13)
			|| 'dt_inicial_horarios_p:' || to_char(dt_inicial_horarios_p, 'dd/mm/yyyy hh24:mi:ss') || chr(13)
			|| 'dt_final_horarios_p:' || to_char(dt_final_horarios_p, 'dd/mm/yyyy hh24:mi:ss') || chr(13)
			|| 'dt_validade_limite_p:' || to_char(dt_validade_limite_p, 'dd/mm/yyyy hh24:mi:ss') || chr(13)
			|| 'ie_exibir_sol_realizadas_p:' || ie_exibir_sol_realizadas_p || chr(13)
			|| 'ie_exibir_sol_suspensas_p:' || ie_exibir_sol_suspensas_p || chr(13)
			|| 'ie_regra_inclusao_p:' || ie_regra_inclusao_p || chr(13)
			|| 'ie_data_lib_prescr_p:' || ie_data_lib_prescr_p || chr(13)
			|| 'ie_lib_pend_rep_p:' || ie_lib_pend_rep_p || chr(13)
			|| 'ie_exibir_suspensos_p:' || ie_exibir_suspensos_p || chr(13)
			|| 'ie_agrupar_acm_sn_p:' || ie_agrupar_acm_sn_p || chr(13)
			|| 'ie_data_lib_proced_p:' || ie_data_lib_proced_p || chr(13)
			|| 'ie_so_proc_setor_usuario_p:' || ie_so_proc_setor_usuario_p || chr(13)
			|| 'ie_prescr_setor_p:' || ie_prescr_setor_p || chr(13)
			|| 'cd_setor_paciente_p:' || cd_setor_paciente_p || chr(13)
			|| 'ie_palm_p:' || ie_palm_p || chr(13)
			|| 'dt_fim_w:' || to_char(current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp, 'dd/mm/yyyy hh24:mi:ss') || chr(13)
			|| 'ie_recem_nato_w:' || ie_recem_nato_w, 1, 1500
		));
	end if;

	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_procedimento_w,
			cd_procedimento_w,
			ds_procedimento_w,
			ie_acm_sn_w,		
			cd_intervalo_w,
			qt_procedimento_w,
			ds_prescricao_w,
			ie_status_solucao_w,
			ie_status_w,
			nr_seq_proc_interno_w,
			ie_classif_adep_w,
			nr_seq_lab_w,
			ds_diluicao_w,
			ie_util_hemocomponente_w,
			ie_tipo_proced_w,
			ie_oncologia_w,
			nr_seq_proc_cpoe_w,
			ds_observacao_w,
			ie_item_ordem_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		--Hemo
		dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_proc_cpoe_w, 'H');
		if	dt_suspensao_cpoe_w <= clock_timestamp() then
			ds_procedimento_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_procedimento_w,1,240);
		elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
			ds_procedimento_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_procedimento_w,1,240);
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
			cd_item,
			ds_item,
			ie_acm_sn,		
			cd_intervalo,
			qt_item,
			ds_prescricao,
			ie_status_item,
			nr_seq_proc_interno,
			ie_classif_adep,
			nr_agrupamento,
			ie_diferenciado,
			nr_seq_lab,
			ds_diluicao,
			ie_util_hemocomponente,
			ie_tipo_proced,
			ie_oncologia,
			nr_seq_cpoe,
			ds_observacao,
			ie_item_ordem)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'HM',
			current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_procedimento_w,
			cd_procedimento_w,
			substr(ds_procedimento_w,1,240),
			ie_acm_sn_w,
			cd_intervalo_w,
			qt_procedimento_w,
			ds_prescricao_w,
			ie_status_solucao_w,
			nr_seq_proc_interno_w,
			ie_classif_adep_w,
			0,
			'N',
			nr_seq_lab_w,
			ds_diluicao_w,
			ie_util_hemocomponente_w,
			ie_tipo_proced_w,
			ie_oncologia_w,
			nr_seq_proc_cpoe_w,
			ds_observacao_w,
			ie_item_ordem_w);
		commit;
		end;
	end loop;
	close c01;
	if (ie_lib_pend_rep_p = 'S') then
		begin
		open c02;
		loop
		fetch c02 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_procedimento_w,
				cd_procedimento_w,
				ds_procedimento_w,
				ie_acm_sn_w,		
				cd_intervalo_w,
				qt_procedimento_w,
				ds_prescricao_w,
				ie_status_solucao_w,
				ie_status_w,
				nr_seq_proc_interno_w,
				ie_classif_adep_w,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				nr_seq_lab_w,
				ie_horario_w,
				ds_diluicao_w,
				ie_util_hemocomponente_w,
				ie_tipo_proced_w,
				ie_oncologia_w,
				nr_seq_proc_cpoe_w,
				ds_observacao_w,
				ie_item_ordem_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			--Hemo
			dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_proc_cpoe_w, 'H');
			if	dt_suspensao_cpoe_w <= clock_timestamp() then
				ds_procedimento_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_procedimento_w,1,240);
			elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
				ds_procedimento_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_procedimento_w,1,240);
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
				cd_item,
				ds_item,
				ie_acm_sn,		
				cd_intervalo,
				qt_item,
				ds_prescricao,
				ie_status_item,
				nr_seq_proc_interno,
				ie_classif_adep,
				nr_agrupamento,
				ie_diferenciado,
				ie_pendente_liberacao,
				nr_seq_lab,
				ie_horario,
				ds_diluicao,
				ie_util_hemocomponente,
				ie_tipo_proced,
				ie_oncologia,
				nr_seq_cpoe,
				ds_observacao,
				ie_item_ordem)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'HM',
				current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_procedimento_w,
				cd_procedimento_w,
				substr(ds_procedimento_w,1,240),
				ie_acm_sn_w,
				cd_intervalo_w,
				qt_procedimento_w,
				ds_prescricao_w,
				ie_status_solucao_w,
				nr_seq_proc_interno_w,
				ie_classif_adep_w,
				0,
				'N',
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				nr_seq_lab_w,
				ie_horario_w,
				ds_diluicao_w,
				ie_util_hemocomponente_w,
				ie_tipo_proced_w,
				ie_oncologia_w,
				nr_seq_proc_cpoe_w,
				ds_observacao_w,
				ie_item_ordem_w);
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
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text) FROM PUBLIC;
