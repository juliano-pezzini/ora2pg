-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.vipe_sincronizar_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


	ds_sep_bv_w		varchar(50);
	nr_prescricao_w		bigint;
	nr_seq_procedimento_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(15);
	cd_procedimento_w	bigint;
	ds_procedimento_w	varchar(255);
	nr_seq_proc_interno_w	bigint;
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_procedimento_w	double precision;
	ds_prescricao_w		varchar(100);
	ds_mat_med_assoc_w	varchar(2000);
	ie_suspenso_w		varchar(1);
	dt_suspensao_w		timestamp;
	ds_comando_update_w	varchar(4000);
	current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp		timestamp;
	nr_horario_w		integer;
	dt_fim_w		timestamp;
	ie_pintar_w		varchar(1);

	c01 CURSOR FOR
	SELECT	a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  'N'  ELSE 'S' END ,
		coalesce(x.dt_status,x.dt_prev_execucao) dt_horario,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM') ie_pintar
	FROM procedimento y, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S' and ((x.ie_status in ('I','INT')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (coalesce(x.dt_status,x.dt_prev_execucao) between dt_inicial_horarios_p and dt_final_horarios_p)) or
		 ((get_ie_considera_horario = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = '')) and coalesce(x.ie_status,'N') = 'N' and ((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'HM',
																		cd_estabelecimento_p,
																		cd_setor_usuario_p,
																		cd_perfil_p,
																		null,
																		x.cd_procedimento,
																		x.ie_origem_proced,
																		x.nr_seq_proc_interno,
																		a.cd_setor_atendimento,
																		x.cd_setor_atendimento,
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																		x.nr_seq_exame) = 'S')))  -- nr_seq_exame_p
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S' group by
		coalesce(x.dt_status,x.dt_prev_execucao),
		a.nr_prescricao,
		x.nr_sequencia,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM'),
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  'N'  ELSE 'S' END
	
union all

	SELECT	a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  'N'  ELSE 'S' END ,
		coalesce(x.dt_status,x.dt_prev_execucao),
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM') ie_pintar
	FROM procedimento y, proc_interno w, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and w.ie_tipo <> 'G' and w.ie_tipo <> 'BS' and coalesce(w.ie_ivc,'N') <> 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S' and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and coalesce(x.ie_status,'N') = 'N' and ((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = '')) and ((x.ie_status in ('I','INT')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (coalesce(x.dt_status,x.dt_prev_execucao) between dt_inicial_horarios_p and dt_final_horarios_p)) or
		 ((get_ie_considera_horario = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'HM',
																		cd_estabelecimento_p,
																		cd_setor_usuario_p,
																		cd_perfil_p,
																		null,
																		x.cd_procedimento,
																		x.ie_origem_proced,
																		x.nr_seq_proc_interno,
																		a.cd_setor_atendimento,
																		x.cd_setor_atendimento,
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																		x.nr_seq_exame) = 'S')))  -- nr_seq_exame_p
	--and	nvl(x.dt_status,x.dt_prev_execucao) between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S' group by
		coalesce(x.dt_status,x.dt_prev_execucao),
		a.nr_prescricao,
		x.nr_sequencia,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM'),
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  'N'  ELSE 'S' END 
	order by dt_horario;

	c02 CURSOR FOR
	SELECT	a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15)  ELSE 'S' END ,
		c.dt_horario,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM') ie_pintar
	from	procedimento y,
		prescr_procedimento x,
		prescr_proc_hor c,
		prescr_medica a
	where	y.cd_procedimento = x.cd_procedimento
	and	y.ie_origem_proced = x.ie_origem_proced
	and	y.cd_procedimento = c.cd_procedimento
	and	y.ie_origem_proced = c.ie_origem_proced
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_procedimento
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
	and	coalesce(x.nr_seq_proc_interno::text, '') = ''
	and	coalesce(x.nr_seq_exame::text, '') = ''
	and	((get_ie_Visualiza_hem_naoLib = 'N') or (x.dt_liberacao_hemoterapia IS NOT NULL AND x.dt_liberacao_hemoterapia::text <> ''))
	and	((get_ie_Visualiza_hem_naoLib = 'N') or (coalesce(x.dt_cancelamento::text, '') = ''))
	and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
	and 	coalesce(x.nr_Seq_origem::text, '') = ''
	and	((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
	and	((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S'))
	and	adep_obter_se_apres_hor_proc('PROC', cd_estabelecimento_p, a.cd_setor_atendimento, cd_perfil_p, x.cd_procedimento, x.ie_origem_proced, x.nr_seq_proc_interno) = 'S'
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
	and	((ie_exibir_sol_realizadas_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
	and	((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'PROC',
																		cd_estabelecimento_p,
																		cd_setor_usuario_p,
																		cd_perfil_p,
																		null,
																		c.cd_procedimento,
																		c.ie_origem_proced,
																		c.nr_seq_proc_interno,
																		a.cd_Setor_atendimento,
																		x.cd_Setor_atendimento,
																		a.nr_prescricao,
																		x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p
	and	c.dt_horario between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and     obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
	group by
		a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15)  ELSE 'S' END ,
		c.dt_horario,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM')
	
union all

	SELECT	a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15)  ELSE 'S' END ,
		c.dt_horario,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM') ie_pintar
	from	procedimento y,
		proc_interno w,
		prescr_procedimento x,
		prescr_proc_hor c,
		prescr_medica a
	where	y.cd_procedimento = x.cd_procedimento
	and	y.ie_origem_proced = x.ie_origem_proced
	and	y.cd_procedimento = c.cd_procedimento
	and	y.ie_origem_proced = c.ie_origem_proced
	and	w.nr_sequencia = x.nr_seq_proc_interno
	and	w.nr_sequencia = c.nr_seq_proc_interno
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_procedimento
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
	and	w.ie_tipo <> 'G'
	and	((get_ie_Visualiza_hem_naoLib = 'N') or (x.dt_liberacao_hemoterapia IS NOT NULL AND x.dt_liberacao_hemoterapia::text <> ''))
	and	((get_ie_Visualiza_hem_naoLib = 'N') or (coalesce(x.dt_cancelamento::text, '') = ''))
	and	w.ie_tipo <> 'BS'
	and	coalesce(w.ie_ivc,'N') <> 'S'
	and	coalesce(w.ie_ctrl_glic,'NC') = 'NC'
	and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
	and	coalesce(x.nr_seq_prot_glic::text, '') = ''
	and 	coalesce(x.nr_Seq_origem::text, '') = ''
	and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
	and	((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S'))
	and	((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
	and	adep_obter_se_apres_hor_proc('PROC', cd_estabelecimento_p, a.cd_setor_atendimento, cd_perfil_p, x.cd_procedimento, x.ie_origem_proced, x.nr_seq_proc_interno) = 'S'
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S'))
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
	and	((ie_exibir_sol_realizadas_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
	and	((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'PROC',
																		cd_estabelecimento_p,
																		cd_setor_usuario_p,
																		cd_perfil_p,
																		null,
																		c.cd_procedimento,
																		c.ie_origem_proced,
																		c.nr_seq_proc_interno,
																		a.cd_Setor_atendimento,
																		x.cd_Setor_atendimento,
																		a.nr_prescricao,
																		x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p
	and	c.dt_horario between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and     obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
	group by
		a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(x.dt_suspensao::text, '') = '' THEN  substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15)  ELSE 'S' END ,
		c.dt_horario,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'HM')
	order by
		dt_horario;

	
BEGIN
	ds_sep_bv_w := obter_separador_bv;
	dt_fim_w	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_validade_limite_p);

	if (coalesce(get_ie_utiliza_hem_p_hor,'N') <> 'S') then
		open c01;
		loop
		fetch c01 into	nr_prescricao_w,
				nr_seq_procedimento_w,
				ie_status_horario_w,
				current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp,
				ie_pintar_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			nr_horario_w := vipe_gerar_horarios_pck.obter_posicao_horario(current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp);

			if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
				ds_comando_update_w	:=	' update w_vipe_t ' ||
								' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
								' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
								' ie_pintar = :ie_pintar ' ||
								' where nm_usuario = :nm_usuario ' ||
								' and ie_tipo_item = :ie_tipo ' ||
								' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
								' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

				CALL exec_sql_dinamico_bv('VIPE', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
											'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
											'ie_pintar=' || ie_pintar_w || ds_sep_bv_w ||
											'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
											'ie_tipo=HM' || ds_sep_bv_w ||
											'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );
			else
				ds_comando_update_w	:=	' update w_vipe_t ' ||
								' set nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
								' ie_pintar = :ie_pintar ' ||
								' where nm_usuario = :nm_usuario ' ||
								' and ie_tipo_item = :ie_tipo ' ||
								' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
								' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

				CALL exec_sql_dinamico_bv('VIPE', ds_comando_update_w,	'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
											'ie_pintar=' || ie_pintar_w || ds_sep_bv_w ||
											'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
											'ie_tipo=HM' || ds_sep_bv_w ||
											'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );
			end if;
			end;
		end loop;
		close c01;
	else
		open c02;
		loop
		fetch c02 into	nr_prescricao_w,
				nr_seq_procedimento_w,
				ie_status_horario_w,
				current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp,
				ie_pintar_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			nr_horario_w := vipe_gerar_horarios_pck.obter_posicao_horario(current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp);

			if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
				ds_comando_update_w	:=	' update w_vipe_t ' ||
								' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
								' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
								' ie_pintar = :ie_pintar ' ||
								' where nm_usuario = :nm_usuario ' ||
								' and ie_tipo_item = :ie_tipo ' ||
								' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
								' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

				CALL exec_sql_dinamico_bv('VIPE', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
											'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
											'ie_pintar=' || ie_pintar_w || ds_sep_bv_w ||
											'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
											'ie_tipo=HM' || ds_sep_bv_w ||
											'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );
			else
				ds_comando_update_w	:=	' update w_vipe_t ' ||
								' set nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
								' ie_pintar = :ie_pintar ' ||
								' where nm_usuario = :nm_usuario ' ||
								' and ie_tipo_item = :ie_tipo ' ||
								' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
								' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

				CALL exec_sql_dinamico_bv('VIPE', ds_comando_update_w,	'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
											'ie_pintar=' || ie_pintar_w || ds_sep_bv_w ||
											'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
											'ie_tipo=HM' || ds_sep_bv_w ||
											'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );
			end if;
			end;
		end loop;
		close c02;
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.vipe_sincronizar_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;