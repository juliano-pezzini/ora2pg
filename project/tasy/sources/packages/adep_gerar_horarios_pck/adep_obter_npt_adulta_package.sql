-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_npt_adulta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

	nr_seq_wadep_w		bigint;
	nr_seq_npt_w		bigint;
	ds_npt_w		varchar(255);
	ie_status_solucao_w	varchar(3);
	current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)	varchar(1);
	ds_inf_npt_w		varchar(255);
	ds_inf_obs_w		varchar(2000);
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();	
	ie_acm_sn_w			varchar(1);
	nr_seq_npt_cpoe_w	nut_pac.nr_seq_npt_cpoe%type;
	ie_item_ordem_w		varchar(1);
	c01 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_npt, 
			ds_npt,
			ie_status_solucao,
			ds_inf_npt,
			ds_inf_obs,
			ie_acm,
			nr_seq_npt_cpoe,
			ie_item_ordem
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_npt,
			CASE WHEN x.ie_forma='P' THEN  wheb_mensagem_pck.get_texto(1109952) || ' ' || y.ds_npt  ELSE obter_valor_dominio(1988,x.ie_forma) END  ds_npt,
			substr(obter_status_solucao_prescr(6,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
			substr(obter_desc_inf_npt_adulta(a.nr_prescricao,x.nr_sequencia),1,255) ds_inf_npt,
			substr(obter_justificativa_item(x.nr_prescricao, x.nr_sequencia, 'NPT', x.nr_seq_npt_cpoe),1,2000) ds_inf_obs,
			x.ie_acm,
			x.nr_seq_npt_cpoe,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'TPN') ie_item_ordem
		FROM prescr_medica a, nut_pac x
LEFT OUTER JOIN protocolo_npt y ON (x.nr_seq_protocolo = y.nr_sequencia)
WHERE x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S' and x.ie_npt_adulta = 'S' and ((a.dt_liberacao_farmacia IS NOT NULL AND a.dt_liberacao_farmacia::text <> '') or (Get_NPTAntesFarmacia = 'N')) and ((x.ie_status in ('I','INT')) or
			 ((Obter_se_acm_sn_agora_especial(null, null, null, null) = 'N') and 
			  exists (select 1 from nut_paciente_hor k where k.nr_seq_nut_protocolo	= x.nr_sequencia and k.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((Obter_se_acm_sn_agora_especial(null, null, null, null) = 'S') and (obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S')) and ((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'NAN', 
																			cd_estabelecimento_p, 
																			cd_setor_usuario_p, 
																			cd_perfil_p, 
																			null, 
																			null, 
																			null, 
																			null,
																			a.cd_Setor_atendimento,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
																			null) = 'S')))  -- nr_seq_exame_p
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.ie_forma,
			y.ds_npt,
			substr(obter_justificativa_item(x.nr_prescricao, x.nr_sequencia, 'NPT', x.nr_seq_npt_cpoe),1,2000),
			x.ie_acm,
			x.nr_seq_npt_cpoe,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'TPN')
		) alias58
	group by
		nr_prescricao, 
		nr_seq_npt, 
		ds_npt,
		ie_status_solucao,
		ds_inf_npt,
		ds_inf_obs,
		ie_acm,
		nr_seq_npt_cpoe,
		ie_item_ordem;
	c02 CURSOR FOR
	SELECT	nr_prescricao,
			nr_seq_npt, 
			ds_npt,
			ie_status_solucao,
			ie_lib_pend_rep,
			ds_inf_npt,
			ds_inf_obs,
			ie_acm,
			nr_seq_npt_cpoe,
			ie_item_ordem
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_npt,
			CASE WHEN x.ie_forma='P' THEN  wheb_mensagem_pck.get_texto(1109952) || ' ' || y.ds_npt  ELSE obter_valor_dominio(1988,x.ie_forma) END  ds_npt,
			substr(obter_status_solucao_prescr(6,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			obter_desc_inf_npt_adulta(a.nr_prescricao,x.nr_sequencia) ds_inf_npt,
			substr(obter_justificativa_item(x.nr_prescricao, x.nr_sequencia, 'NPT', x.nr_seq_npt_cpoe),1,2000) ds_inf_obs,
			x.ie_acm,
			x.nr_seq_npt_cpoe,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'TPN') ie_item_ordem
		FROM prescr_medica a, nut_pac x
LEFT OUTER JOIN protocolo_npt y ON (x.nr_seq_protocolo = y.nr_sequencia)
WHERE x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S' and x.ie_npt_adulta = 'S' and coalesce(x.dt_status::text, '') = '' and coalesce(x.ie_status::text, '') = '' and ((a.dt_liberacao_farmacia IS NOT NULL AND a.dt_liberacao_farmacia::text <> '') or (Get_NPTAntesFarmacia = 'N')) and coalesce(x.dt_suspensao::text, '') = '' and coalesce(a.dt_suspensao::text, '') = '' and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S')) and obter_se_prescr_vig_adep(a.dt_prescricao,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'NAN', 
																			cd_estabelecimento_p, 
																			cd_setor_usuario_p, 
																			cd_perfil_p, 
																			null, 
																			null, 
																			null, 
																			null,
																			a.cd_Setor_atendimento,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
																			null) = 'S')))  -- nr_seq_exame_p
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.ie_forma,
			y.ds_npt,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			substr(obter_justificativa_item(x.nr_prescricao, x.nr_sequencia, 'NPT', x.nr_seq_npt_cpoe),1,2000),
			x.ie_acm,
			x.nr_seq_npt_cpoe,
			obter_se_item_ordem_medica(x.nr_prescricao, x.nr_sequencia, 'TPN')
		) alias49
	group by
		nr_prescricao, 
		nr_seq_npt, 
		ds_npt,
		ie_status_solucao,
		ie_lib_pend_rep,
		ds_inf_npt,
		ds_inf_obs,
		ie_acm,
		nr_seq_npt_cpoe,
		ie_item_ordem;
	
BEGIN
	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_npt_w,
			ds_npt_w,
			ie_status_solucao_w,
			ds_inf_npt_w,
			ds_inf_obs_w,
			ie_acm_sn_w,
			nr_seq_npt_cpoe_w,
			ie_item_ordem_w;
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
			ie_diferenciado,
			nr_agrupamento,
			nr_seq_proc_interno,
			ie_status_item,
			ds_prescricao,
			ds_diluicao,
			nr_seq_cpoe,
			ie_item_ordem)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'NAN',
			current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_npt_w,
			nr_seq_npt_w,
			substr(ds_npt_w,1,240),
			ie_acm_sn_w,
			'N',
			0,
			0,
			ie_status_solucao_w,
			ds_inf_npt_w,
			ds_inf_obs_w,
			nr_seq_npt_cpoe_w,
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
				nr_seq_npt_w,
				ds_npt_w,
				ie_status_solucao_w,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				ds_inf_npt_w,
				ds_inf_obs_w,
				ie_acm_sn_w,
				nr_seq_npt_cpoe_w,
				ie_item_ordem_w;
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
				ie_diferenciado,
				nr_agrupamento,
				nr_seq_proc_interno,
				ie_status_item,
				ie_pendente_liberacao,
				ds_prescricao,
				ds_diluicao,
				nr_seq_cpoe,
				ie_item_ordem)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'NAN',
				current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				nr_seq_npt_w,
				nr_seq_npt_w,
				substr(ds_npt_w,1,240),
				ie_acm_sn_w,
				'N',
				0,
				0,
				ie_status_solucao_w,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				ds_inf_npt_w,
				ds_inf_obs_w,
				nr_seq_npt_cpoe_w,
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
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_npt_adulta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;