-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_assoc_proc ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_dose_esp_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_quimio_p text) AS $body$
DECLARE

	nr_seq_wadep_w		bigint;
	nr_seq_material_w	integer;
	cd_material_w		integer;
	ds_material_w		varchar(255);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_dose_w		double precision;
	nr_agrupamento_w	double precision;
	ds_prescricao_w		varchar(240);
	ie_status_w		varchar(1);
	current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)	varchar(1);
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();	
	nr_seq_mat_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
	c01 CURSOR FOR
	SELECT		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN(case when ie_acm_sn = 'S' or obter_se_intervalo_acm(cd_intervalo) = 'S' or obter_se_intervalo_sn(cd_intervalo) = 'S' then 'S' else 'N' end)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material, ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END   ELSE null END ,
			CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN(case when ie_acm_sn = 'S' or obter_se_intervalo_acm(cd_intervalo) = 'S' or obter_se_intervalo_sn(cd_intervalo) = 'S' then 'S' else 'N' end)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material, ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END   ELSE null END ,	
			cd_material,
			ds_material,
			ie_acm_sn,
			cd_intervalo,
			qt_dose,
			nr_agrupamento,
			ds_prescricao,
			CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  ie_status,
			nr_seq_mat_cpoe
	from	(
		SELECT	a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			z.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
			substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.nr_seq_mat_cpoe
		from	material z,
			proc_interno w,
			prescr_procedimento y,
			prescr_material x,
			prescr_mat_hor c,
			prescr_medica a
		where	z.cd_material = x.cd_material
		and	z.cd_material = c.cd_material
		and	w.nr_sequencia = y.nr_seq_proc_interno
		and	y.nr_prescricao = x.nr_prescricao
		and	y.nr_sequencia = x.nr_sequencia_proc
		and	y.nr_prescricao = a.nr_prescricao
		and	x.nr_prescricao = c.nr_prescricao
		and	x.nr_sequencia = c.nr_seq_material
		and	x.nr_prescricao = a.nr_prescricao
		and	c.nr_prescricao = y.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	coalesce(w.ie_tipo,'O') not in ('G','BS')
		and	coalesce(w.ie_ivc,'N') <> 'S'
		and	coalesce(w.ie_ctrl_glic,'NC') = 'NC'
		and	(y.nr_seq_proc_interno IS NOT NULL AND y.nr_seq_proc_interno::text <> '')
		and	coalesce(y.nr_seq_prot_glic::text, '') = ''
		and	((get_ie_chec_mat_assoc_proc_lab = 'S') or (coalesce(y.nr_seq_exame::text, '') = '')) --and	y.nr_seq_exame is null
		and	coalesce(y.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(y.nr_seq_derivado::text, '') = ''
		and	coalesce(y.nr_seq_exame_sangue::text, '') = ''
		and	x.ie_agrupador = 5
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	coalesce(c.ie_adep,'S') = 'S'
		and	c.ie_agrupador = 5
		and	get_ie_mat_med_proc_gestao = 'S'
		and	coalesce(x.ie_checar_adep,'N') = 'S'
		and	(((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
		and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
		and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))		
		group by
			a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			z.ds_material,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_dose,
			x.nr_agrupamento,
			x.ie_suspenso,
			x.nr_seq_mat_cpoe
		
union all

		select	a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			z.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
			substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.nr_seq_mat_cpoe
		from	material z,
			prescr_procedimento y,
			prescr_material x,
			prescr_mat_hor c,
			prescr_medica a
		where	z.cd_material = x.cd_material
		and	z.cd_material = c.cd_material
		and	y.nr_prescricao = x.nr_prescricao
		and	y.nr_sequencia = x.nr_sequencia_proc
		and	y.nr_prescricao = a.nr_prescricao
		and	x.nr_prescricao = c.nr_prescricao
		and	x.nr_sequencia = c.nr_seq_material
		and	x.nr_prescricao = a.nr_prescricao
		and	c.nr_prescricao = y.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	coalesce(y.nr_seq_proc_interno::text, '') = ''
		and	((get_ie_chec_mat_assoc_proc_lab = 'S') or (coalesce(y.nr_seq_exame::text, '') = '')) --and	y.nr_seq_exame is null
		and	coalesce(y.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(y.nr_seq_derivado::text, '') = ''
		and	coalesce(y.nr_seq_exame_sangue::text, '') = ''
		and	get_ie_mat_med_proc_gestao = 'S'
		and	x.ie_agrupador = 5
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	coalesce(c.ie_adep,'S') = 'S'
		and	c.ie_agrupador = 5
		and	coalesce(x.ie_checar_adep,'N') = 'S'
		and	(((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
		and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
		and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))		
		group by
			a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			z.ds_material,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_dose,
			x.nr_agrupamento,
			x.ie_suspenso,
			x.nr_seq_mat_cpoe
		
union all

		select	a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			z.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
			substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.nr_seq_mat_cpoe
		from	material z,
			prescr_gasoterapia y,
			prescr_material x,
			prescr_mat_hor c,
			prescr_medica a
		where	z.cd_material = x.cd_material
		and	z.cd_material = c.cd_material
		and	y.nr_prescricao = x.nr_prescricao
		and	y.nr_sequencia = x.nr_seq_gasoterapia
		and	y.nr_prescricao = a.nr_prescricao
		and	x.nr_prescricao = c.nr_prescricao
		and	x.nr_sequencia = c.nr_seq_material
		and	x.nr_prescricao = a.nr_prescricao
		and	c.nr_prescricao = y.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	x.ie_agrupador = 15
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	coalesce(c.ie_adep,'S') = 'S'
		and	c.ie_agrupador = 15
		and	getExibeAssocGas = 'S'
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	(((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
		and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
		and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))		
		group by
			a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			z.ds_material,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_dose,
			x.nr_agrupamento,
			x.ie_suspenso,
			x.nr_seq_mat_cpoe			
		) alias178
	group by
		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN(case when ie_acm_sn = 'S' or obter_se_intervalo_acm(cd_intervalo) = 'S' or obter_se_intervalo_sn(cd_intervalo) = 'S' then 'S' else 'N' end)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material, ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END   ELSE null END ,
		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN(case when ie_acm_sn = 'S' or obter_se_intervalo_acm(cd_intervalo) = 'S' or obter_se_intervalo_sn(cd_intervalo) = 'S' then 'S' else 'N' end)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material, ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END   ELSE null END ,	
		cd_material,
		ds_material,
		ie_acm_sn,	
		cd_intervalo,
		qt_dose,
		nr_agrupamento,
		ds_prescricao,
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END ,
		nr_seq_mat_cpoe;
	c02 CURSOR FOR
	SELECT	CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  nr_prescricao  ELSE null END ,
			CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  nr_seq_material  ELSE null END ,	
			cd_material,
			ds_material,
			ie_acm_sn,
			cd_intervalo,
			qt_dose,
			nr_agrupamento,
			ds_prescricao,
			CASE WHEN ie_suspenso='N' THEN null  ELSE ie_suspenso END ,
			ie_lib_pend_rep,
			nr_seq_mat_cpoe
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_material,
			x.cd_material,
			z.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,x.nr_sequencia,x.nr_agrupamento,x.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
			substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			x.nr_seq_mat_cpoe
		from	material z,
			proc_interno w,
			prescr_procedimento y,
			prescr_material x,
			prescr_medica a
		where	z.cd_material = x.cd_material
		and	w.nr_sequencia = y.nr_seq_proc_interno
		and	y.nr_prescricao = x.nr_prescricao
		and	y.nr_sequencia = x.nr_sequencia_proc
		and	y.nr_prescricao = a.nr_prescricao
		and	x.nr_prescricao = a.nr_prescricao
		and	coalesce(a.ie_adep,'S') = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	coalesce(w.ie_tipo,'O') not in ('G','BS')
		and	coalesce(w.ie_ivc,'N') <> 'S'
		and	coalesce(w.ie_ctrl_glic,'NC') = 'NC'
		and	(y.nr_seq_proc_interno IS NOT NULL AND y.nr_seq_proc_interno::text <> '')
		and	coalesce(y.nr_seq_prot_glic::text, '') = ''
		and	((get_ie_chec_mat_assoc_proc_lab = 'S') or (coalesce(y.nr_seq_exame::text, '') = '')) --and	y.nr_seq_exame is null
		and	coalesce(y.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(y.nr_seq_derivado::text, '') = ''
		and	coalesce(y.nr_seq_exame_sangue::text, '') = ''
		and 	coalesce(x.dt_suspensao::text, '') = ''
		and 	coalesce(a.dt_suspensao::text, '') = ''	
		and 	coalesce(y.dt_suspensao::text, '') = ''
		and	x.ie_agrupador = 5
		and	get_ie_mat_med_proc_gestao = 'S'
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	coalesce(x.ie_checar_adep,'N') = 'S'
		and	obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
		and	not exists (
				select	1
				from	prescr_mat_hor c
				where	c.cd_material = z.cd_material
				and	c.nr_prescricao = x.nr_prescricao
				and	c.nr_seq_material = x.nr_sequencia
				and	c.ie_agrupador = 5
				and	x.ie_agrupador = 5
				and	c.nr_prescricao = y.nr_prescricao
				and	c.nr_prescricao = a.nr_prescricao
				and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')	
		and	((ie_prescr_setor_p = 'N') or ((ie_prescr_setor_p = 'S') and (a.cd_setor_atendimento = Obter_Unidade_Atendimento(nr_atendimento_p, 'IAR', 'CS'))))
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))		
		group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_material,
			z.ds_material,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_dose,
			x.nr_agrupamento,
			x.ie_suspenso,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			x.nr_seq_mat_cpoe
		
union all

		select	a.nr_prescricao,
			x.nr_sequencia nr_seq_material,
			x.cd_material,
			z.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,x.nr_sequencia,x.nr_agrupamento,x.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
			substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			x.nr_seq_mat_cpoe
		from	material z,
			prescr_procedimento y,
			prescr_material x,
			prescr_medica a
		where	z.cd_material = x.cd_material
		and	y.nr_prescricao = x.nr_prescricao
		and	y.nr_sequencia = x.nr_sequencia_proc
		and	y.nr_prescricao = a.nr_prescricao
		and	x.nr_prescricao = a.nr_prescricao
		and	coalesce(a.ie_adep,'S') = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	coalesce(y.nr_seq_proc_interno::text, '') = ''
		and	((get_ie_chec_mat_assoc_proc_lab = 'S') or (coalesce(y.nr_seq_exame::text, '') = '')) --and	y.nr_seq_exame is null
		and 	coalesce(x.dt_suspensao::text, '') = ''
		and 	coalesce(a.dt_suspensao::text, '') = ''	
		and 	coalesce(y.dt_suspensao::text, '') = ''	
		and	coalesce(y.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(y.nr_seq_derivado::text, '') = ''
		and	coalesce(y.nr_seq_exame_sangue::text, '') = ''
		and	x.ie_agrupador = 5
		and	coalesce(x.ie_checar_adep,'N') = 'S'
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
		and	not exists (
				select	1
				from	prescr_mat_hor c
				where	c.cd_material = z.cd_material
				and	c.nr_prescricao = x.nr_prescricao
				and	c.nr_seq_material = x.nr_sequencia
				and	c.ie_agrupador = 5
				and	x.ie_agrupador = 5
				and	c.nr_prescricao = y.nr_prescricao
				and	c.nr_prescricao = a.nr_prescricao
				and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')
		and	((ie_prescr_setor_p = 'N') or ((ie_prescr_setor_p = 'S') and (a.cd_setor_atendimento = Obter_Unidade_Atendimento(nr_atendimento_p, 'IAR', 'CS'))))
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and	get_ie_mat_med_proc_gestao = 'S'
		and	((ie_quimio_p		= 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))		
		group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_material,
			z.ds_material,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_dose,
			x.nr_agrupamento,
			x.ie_suspenso,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			x.nr_seq_mat_cpoe
		) alias99
	group by
		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  nr_prescricao  ELSE null END ,
		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  nr_seq_material  ELSE null END ,	
		cd_material,
		ds_material,
		ie_acm_sn,
		cd_intervalo,
		qt_dose,
		nr_agrupamento,
		ds_prescricao,
		CASE WHEN ie_suspenso='N' THEN null  ELSE ie_suspenso END ,
		ie_lib_pend_rep,
		nr_seq_mat_cpoe;	
	
BEGIN
	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_material_w,
			cd_material_w,
			ds_material_w,
			ie_acm_sn_w,		
			cd_intervalo_w,
			qt_dose_w,
			nr_agrupamento_w,
			ds_prescricao_w,
			ie_status_w,
			nr_seq_mat_cpoe_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
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
			nr_agrupamento,
			ds_prescricao,
			ie_status_item,
			nr_seq_proc_interno,
			nr_seq_cpoe)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'IA',
			current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_material_w,
			cd_material_w,
			substr(ds_material_w,1,240),
			ie_acm_sn_w,
			cd_intervalo_w,
			qt_dose_w,
			nr_agrupamento_w,
			ds_prescricao_w,
			ie_status_w,
			0,
			nr_seq_mat_cpoe_w);
		commit;
		end;
	end loop;
	close c01;
	if (ie_lib_pend_rep_p = 'S') then
		begin
		open c02;
		loop
		fetch c02 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_material_w,
				cd_material_w,
				ds_material_w,
				ie_acm_sn_w,		
				cd_intervalo_w,
				qt_dose_w,
				nr_agrupamento_w,
				ds_prescricao_w,
				ie_status_w,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				nr_seq_mat_cpoe_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
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
				nr_agrupamento,
				ds_prescricao,
				ie_status_item,
				nr_seq_proc_interno,
				ie_pendente_liberacao,
				nr_seq_cpoe)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'IA',
				current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_material_w,
				cd_material_w,
				substr(ds_material_w,1,240),
				ie_acm_sn_w,
				cd_intervalo_w,
				qt_dose_w,
				nr_agrupamento_w,
				ds_prescricao_w,
				ie_status_w,
				0,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				nr_seq_mat_cpoe_w);
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
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_assoc_proc ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_dose_esp_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_quimio_p text) FROM PUBLIC;