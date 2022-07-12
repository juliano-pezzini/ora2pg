-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_medic_hd_de ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, nr_seq_dialise_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_dose_esp_p text, ie_diluicao_acm_sn_gestao_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
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
	ds_dil_obs_w		varchar(2000);
	ie_status_w		varchar(1);
	ie_lib_pend_rep_w	varchar(1);
	ie_alto_risco_w		varchar(1);
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();
	nr_seq_mat_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;	
	dt_suspensao_cpoe_w	timestamp;
	c01 CURSOR FOR
	SELECT	CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END   ELSE null END ,
			CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END   ELSE null END , 	
			cd_material,
			ds_material,
			ie_acm_sn,	
			cd_intervalo,
			qt_dose,
			nr_agrupamento,
			ds_prescricao,
			ds_dil_obs,
			CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  ie_status,
			ie_alto_risco,
			nr_seq_mat_cpoe
	from	(
		SELECT	a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			y.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
			'DE ' || to_char(x.qt_dose_especial) || ' ' || x.cd_unidade_medida_dose ds_prescricao,
			substr(adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000) ds_dil_obs,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			y.ie_alto_risco,
			x.nr_seq_mat_cpoe
		from	material y,
			prescr_material x,
			prescr_mat_hor c,
			prescr_medica a
		where	y.cd_material = x.cd_material
		and	x.nr_prescricao = c.nr_prescricao
		and	x.nr_sequencia = c.nr_seq_material	
		and	x.nr_prescricao = a.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao	
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
		and	x.ie_agrupador = 1
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))	
		and	obter_se_gerar_item_adep('M',a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,getie_apres_kit) = 'S'
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	coalesce(c.ie_adep,'S') = 'S'
		and	c.ie_agrupador = 1
		and	coalesce(c.ie_dose_especial,'N') = 'S'
		and	(((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(x.ie_acm, x.ie_se_necessario, x.ie_urgencia, c.ie_dose_especial) = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
		and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
		and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))	
		and	c.nr_seq_dialise = nr_seq_dialise_p
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
		and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		group by
			a.nr_prescricao,
			c.nr_seq_material,
			c.cd_material,
			y.ds_material,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_dose,
			x.qt_dose_especial,
			x.cd_unidade_medida_dose,
			x.nr_agrupamento,
			x.ie_suspenso,
			y.ie_alto_risco,
			x.nr_seq_mat_cpoe
		) alias52
	group by
		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END   ELSE null END ,
		CASE WHEN coalesce(nr_seq_mat_cpoe::text, '') = '' THEN  CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END   ELSE null END , 	
		cd_material,
		ds_material,
		ie_acm_sn,	
		cd_intervalo,
		qt_dose,
		nr_agrupamento,
		ds_prescricao,
		ds_dil_obs,
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END ,
		ie_alto_risco,
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
			ds_dil_obs_w,
			ie_status_w,
			ie_alto_risco_w,
			nr_seq_mat_cpoe_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		--Medic HD
		dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_mat_cpoe_w, 'M');
		if	dt_suspensao_cpoe_w <= clock_timestamp() then
			ds_material_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_material_w,1,240);
		elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
			ds_material_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_material_w,1,240);
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
			nr_agrupamento,
			ds_prescricao,
			ds_diluicao,
			ie_status_item,
			nr_seq_proc_interno,
			ie_diferenciado,
			nr_prescricoes,
			ie_alto_risco,
			nr_seq_cpoe)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'ME',
			current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_material_w,
			cd_material_w,
			substr(ds_material_w,1,240),
			ie_acm_sn_w,
			cd_intervalo_w,
			qt_dose_w,
			nr_agrupamento_w,
			ds_prescricao_w,
			ds_dil_obs_w,
			ie_status_w,
			0,
			CASE WHEN coalesce(ds_dil_obs_w::text, '') = '' THEN 'N'  ELSE 'S' END ,
			CASE WHEN ie_acm_sn_w='S' THEN current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type  ELSE null END ,
			ie_alto_risco_w,
			nr_seq_mat_cpoe_w);
		commit;
		end;
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_medic_hd_de ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, nr_seq_dialise_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_dose_esp_p text, ie_diluicao_acm_sn_gestao_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;
