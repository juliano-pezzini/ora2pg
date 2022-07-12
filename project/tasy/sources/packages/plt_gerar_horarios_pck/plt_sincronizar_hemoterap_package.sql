-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE plt_gerar_horarios_pck.plt_sincronizar_hemoterap ( nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, ie_prescr_usuario_p text, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) AS $body$
DECLARE

					
	ds_sep_bv_w			varchar(50);				
	nr_prescricao_w			bigint;
	nr_seq_procedimento_w		integer;
	nr_seq_horario_w		bigint;
	ie_status_horario_w		varchar(15);
	cd_procedimento_w		bigint;
	ds_procedimento_w		varchar(255);
	nr_seq_proc_interno_w		bigint;
	ie_acm_sn_w			varchar(1);
	cd_intervalo_w			varchar(7);
	qt_procedimento_w		double precision;
	ds_prescricao_w			varchar(100);
	ds_mat_med_assoc_w		varchar(2000);
	ie_suspenso_w			varchar(1);
	dt_suspensao_w			timestamp;
	ds_comando_update_w		varchar(4000);
	current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)		varchar(1);
	current_setting('plt_gerar_horarios_pck.dt_horario_w')::timestamp			timestamp;
	nr_horario_w			integer;	
	dt_fim_w			timestamp;

	
	c01 REFCURSOR;
	c02 REFCURSOR;

	
BEGIN
	dt_fim_w	:= dt_validade_limite_p + 5;
	ds_sep_bv_w 	:= obter_separador_bv;

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		open	c01 for
		SELECT	nr_prescricao,
				nr_sequencia,
				ie_status,
				ie_lib_pend_rep,
				trunc(dt_status, 'mi')
		from	(	SELECT	a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END  ie_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,
							x.dt_status,
							x.dt_suspensao
					FROM procedimento y, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and a.nr_atendimento = nr_atendimento_p and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S' and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and x.ie_status in ('P','N') and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																									x.ie_origem_proced, 
																									x.nr_seq_proc_interno,
																									a.cd_setor_Atendimento,
																									x.cd_setor_atendimento,
																									null,
																									x.nr_seq_exame) = 'S'))) group by
							a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
							a.dt_liberacao_medico,
							a.dt_liberacao,
							a.dt_liberacao_farmacia,
							x.dt_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),
							x.dt_suspensao
					
union all

					select	a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END  ie_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,
							x.dt_status,
							x.dt_suspensao
					FROM procedimento y, proc_interno w, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and a.nr_atendimento = nr_atendimento_p and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and w.ie_tipo <> 'G' and coalesce(w.ie_ivc,'N') <> 'S' and plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'PH') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'ST') = 'S')) and x.ie_status in ('P','N') and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM', 
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																									x.ie_origem_proced, 
																									x.nr_seq_proc_interno,
																									a.cd_setor_Atendimento,
																									x.cd_setor_atendimento,
																									null,
																									x.nr_seq_exame) = 'S'))) group by
							a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
							a.dt_liberacao_medico,
							a.dt_liberacao,
							a.dt_liberacao_farmacia,
							x.dt_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),
							x.dt_suspensao) alias85
		where	plt_obter_se_item_periodo(	dt_validade_limite_p,		dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			dt_status,
											current_setting('plt_gerar_horarios_pck.dt_horario_inicio_sinc_w')::timestamp,	current_setting('plt_gerar_horarios_pck.dt_horario_fim_sinc_w')::timestamp,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
											dt_referencia_p,			ie_edicao_p,			ie_exibir_hor_suspensos_p,	dt_suspensao,		'HM',
											nr_sequencia,				nr_prescricao,			'S') = 'S'
		group by
				nr_prescricao,
				nr_sequencia,
				ie_status,
				ie_lib_pend_rep,
				dt_status;
			
		open	c02 for
		SELECT	nr_prescricao,
				nr_seq_procedimento,
				ie_lib_pend_rep,
				nr_sequencia,
				ie_status,
				dt_horario
		from	(	SELECT	a.nr_prescricao,
							x.nr_sequencia nr_seq_procedimento,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,
							c.nr_sequencia,
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END  ie_status,
							c.dt_horario,
							x.dt_suspensao
					from	procedimento y,
							prescr_procedimento x,
							prescr_proc_hor c,
							prescr_medica a
					where	y.cd_procedimento = x.cd_procedimento
					and		y.ie_origem_proced = x.ie_origem_proced
					and		y.cd_procedimento = c.cd_procedimento
					and		y.ie_origem_proced = c.ie_origem_proced			
					and		x.nr_prescricao = c.nr_prescricao
					and		x.nr_sequencia = c.nr_seq_procedimento
					and		x.nr_prescricao = a.nr_prescricao
					and		c.nr_prescricao = a.nr_prescricao
					and		a.nr_atendimento = nr_atendimento_p
					and		PLT_Gerar_Horarios_PCK.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S'
					and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
					and		a.dt_validade_prescr	between dt_validade_limite_p	and dt_fim_w	
					and		coalesce(x.nr_seq_proc_interno::text, '') = ''
					and		coalesce(x.nr_seq_exame::text, '') = ''
					and		(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
					and 	coalesce(x.nr_Seq_origem::text, '') = ''
					and		((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
					and		((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
					and		coalesce(c.ie_situacao,'A') = 'A'
					and		((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))	
					and		((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																								wheb_usuario_pck.get_cd_estabelecimento, 
																								wheb_usuario_pck.get_cd_setor_atendimento, 
																								wheb_usuario_pck.get_cd_perfil, 
																								null, 
																								x.cd_procedimento, 
																								x.ie_origem_proced, 
																								x.nr_seq_proc_interno,
																								a.cd_setor_Atendimento,
																								x.cd_setor_atendimento,
																								null,
																								x.nr_seq_exame) = 'S')))
					group by
							a.nr_prescricao,
							c.nr_sequencia,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),		
							x.nr_sequencia,
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END ,
							c.dt_horario,
							x.dt_suspensao
					
union all

					select	a.nr_prescricao,
							x.nr_sequencia nr_seq_procedimento,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,		
							c.nr_sequencia,
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END  ie_status,
							c.dt_horario,
							x.dt_suspensao
					from	procedimento y,
							proc_interno w,
							prescr_procedimento x,
							prescr_proc_hor c,
							prescr_medica a
					where	y.cd_procedimento = x.cd_procedimento
					and		y.ie_origem_proced = x.ie_origem_proced
					and		y.cd_procedimento = c.cd_procedimento
					and		y.ie_origem_proced = c.ie_origem_proced		
					and		w.nr_sequencia = x.nr_seq_proc_interno
					and		w.nr_sequencia = c.nr_seq_proc_interno
					and		x.nr_prescricao = c.nr_prescricao
					and		x.nr_sequencia = c.nr_seq_procedimento
					and		x.nr_prescricao = a.nr_prescricao
					and		c.nr_prescricao = a.nr_prescricao
					and		a.nr_atendimento = nr_atendimento_p		
					and		plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S'
					and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
					and		a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w	
					and		w.ie_tipo <> 'G'
					and		coalesce(w.ie_ivc,'N') <> 'S'
					and		coalesce(w.ie_ctrl_glic,'NC') = 'NC'
					and		(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
					and		coalesce(x.nr_seq_prot_glic::text, '') = ''
					and		coalesce(x.nr_seq_exame::text, '') = ''
					and 	coalesce(x.nr_Seq_origem::text, '') = ''
					and		(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
					and		((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'PH') = 'S'))
					and		((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'ST') = 'S'))
					and		coalesce(c.ie_situacao,'A') = 'A'
					and		((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
					and		((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							 ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM', 
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																									x.ie_origem_proced, 
																									x.nr_seq_proc_interno,
																									a.cd_setor_Atendimento,
																									x.cd_setor_atendimento,
																									null,
																									x.nr_seq_exame) = 'S')))
					group by	 
							a.nr_prescricao,
							c.nr_sequencia,
							x.nr_sequencia,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),		
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END ,
							c.dt_horario,
							x.dt_suspensao) alias101
		where	plt_obter_se_item_periodo(	dt_validade_limite_p,		dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			dt_horario,
											current_setting('plt_gerar_horarios_pck.dt_horario_inicio_sinc_w')::timestamp,	current_setting('plt_gerar_horarios_pck.dt_horario_fim_sinc_w')::timestamp,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
											dt_referencia_p,			ie_edicao_p,			ie_exibir_hor_suspensos_p,	dt_suspensao,		'HM',
											nr_seq_procedimento,		nr_prescricao,		'S') = 'S'
		group by	
				nr_prescricao,
				nr_seq_procedimento,
				ie_lib_pend_rep,
				nr_sequencia,
				ie_status,
				dt_horario
		order by
				dt_horario;	
	else
		open	c01 for
		SELECT	nr_prescricao,
				nr_sequencia,
				ie_status,
				ie_lib_pend_rep,
				trunc(dt_status, 'mi')
		from	(	SELECT	a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END  ie_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,
							x.dt_status,
							x.dt_suspensao
					FROM procedimento y, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10) and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and x.ie_status in ('P','N') and plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S' and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																									x.ie_origem_proced, 
																									x.nr_seq_proc_interno,
																									a.cd_setor_Atendimento,
																									x.cd_setor_atendimento,
																									null,
																									x.nr_seq_exame) = 'S'))) group by
							a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
							a.dt_liberacao_medico,
							a.dt_liberacao,
							a.dt_liberacao_farmacia,
							x.dt_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),
							x.dt_suspensao
					
union all

					select	a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END  ie_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,
							trunc(x.dt_status,'mi'),
							x.dt_suspensao
					FROM procedimento y, proc_interno w, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10) and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and w.ie_tipo <> 'G' and coalesce(w.ie_ivc,'N') <> 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and PLT_Gerar_Horarios_PCK.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'PH') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'ST') = 'S')) and x.ie_status in ('P','N') and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM', 
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																									x.ie_origem_proced, 
																									x.nr_seq_proc_interno,
																									a.cd_setor_Atendimento,
																									x.cd_setor_atendimento,
																									null,
																									x.nr_seq_exame) = 'S'))) group by
							a.nr_prescricao,
							x.nr_sequencia,
							CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
							a.dt_liberacao_medico,
							a.dt_liberacao,
							a.dt_liberacao_farmacia,
							x.dt_status,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),
							x.dt_suspensao) alias89
		where	plt_obter_se_item_periodo(	dt_validade_limite_p,		dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			dt_status,
											current_setting('plt_gerar_horarios_pck.dt_horario_inicio_sinc_w')::timestamp,	current_setting('plt_gerar_horarios_pck.dt_horario_fim_sinc_w')::timestamp,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
											dt_referencia_p,			ie_edicao_p,			ie_exibir_hor_suspensos_p,	dt_suspensao,		'HM',
											nr_sequencia,				nr_prescricao,			'S') = 'S'
		group by
				nr_prescricao,
				nr_sequencia,
				ie_status,
				ie_lib_pend_rep,
				dt_status;
			
		open	c02 for
		SELECT	nr_prescricao,
				nr_seq_procedimento,
				ie_lib_pend_rep,
				nr_sequencia,
				ie_status,
				dt_horario
		from	(	SELECT	a.nr_prescricao,
							x.nr_sequencia nr_seq_procedimento,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,
							c.nr_sequencia,
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END  ie_status,
							c.dt_horario,
							x.dt_suspensao
					from	procedimento y,
							prescr_procedimento x,
							prescr_proc_hor c,
							prescr_medica a
					where	y.cd_procedimento = x.cd_procedimento
					and		y.ie_origem_proced = x.ie_origem_proced
					and		y.cd_procedimento = c.cd_procedimento
					and		y.ie_origem_proced = c.ie_origem_proced			
					and		x.nr_prescricao = c.nr_prescricao
					and		x.nr_sequencia = c.nr_seq_procedimento
					and		x.nr_prescricao = a.nr_prescricao
					and		c.nr_prescricao = a.nr_prescricao
					and		a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10)		
					and		PLT_Gerar_Horarios_PCK.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S'
					and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
					and		a.dt_validade_prescr	between dt_validade_limite_p	and dt_fim_w
					and		coalesce(x.nr_seq_proc_interno::text, '') = ''
					and		coalesce(x.nr_seq_exame::text, '') = ''
					and		(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
					and 	coalesce(x.nr_Seq_origem::text, '') = ''
					and		((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
					and		((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S'))
					and		coalesce(c.ie_situacao,'A') = 'A'
					and		((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
					and		((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																								x.ie_origem_proced, 
																								x.nr_seq_proc_interno,
																								a.cd_setor_Atendimento,
																								x.cd_setor_atendimento,
																								null,
																								x.nr_seq_exame) = 'S')))
					group by
							a.nr_prescricao,
							c.nr_sequencia,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),		
							x.nr_sequencia,
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END ,
							c.dt_horario,
							x.dt_suspensao
					
union all

					select	a.nr_prescricao,
							x.nr_sequencia nr_seq_procedimento,
							coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X') ie_lib_pend_rep,		
							c.nr_sequencia,
							CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END  ie_status,
							c.dt_horario,
							x.dt_suspensao
					from	procedimento y,
							proc_interno w,
							prescr_procedimento x,
							prescr_proc_hor c,
							prescr_medica a
					where	y.cd_procedimento = x.cd_procedimento
					and		y.ie_origem_proced = x.ie_origem_proced
					and		y.cd_procedimento = c.cd_procedimento
					and		y.ie_origem_proced = c.ie_origem_proced		
					and		w.nr_sequencia = x.nr_seq_proc_interno
					and		w.nr_sequencia = c.nr_seq_proc_interno
					and		x.nr_prescricao = c.nr_prescricao
					and		x.nr_sequencia = c.nr_seq_procedimento
					and		x.nr_prescricao = a.nr_prescricao
					and		c.nr_prescricao = a.nr_prescricao
					and		a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10)	
					and		plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S'		
					and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
					and		a.dt_validade_prescr	between dt_validade_limite_p	and dt_fim_w
					and		w.ie_tipo <> 'G'
					and		coalesce(w.ie_ivc,'N') <> 'S'
					and		coalesce(w.ie_ctrl_glic,'NC') = 'NC'
					and		(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
					and		coalesce(x.nr_seq_prot_glic::text, '') = ''
					and		coalesce(x.nr_seq_exame::text, '') = ''
					and 	coalesce(x.nr_Seq_origem::text, '') = ''
					and		(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
					and		((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'PH') = 'S'))
					and		((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'ST') = 'S'))
					and		coalesce(c.ie_situacao,'A') = 'A'
					and		((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
					and		((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
							((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM', 
																									wheb_usuario_pck.get_cd_estabelecimento, 
																									wheb_usuario_pck.get_cd_setor_atendimento, 
																									wheb_usuario_pck.get_cd_perfil, 
																									null, 
																									x.cd_procedimento, 
																									x.ie_origem_proced, 
																									x.nr_seq_proc_interno,
																									a.cd_setor_Atendimento,
																									x.cd_setor_atendimento,
																									null,
																									x.nr_seq_exame) = 'S')))
					group by	 
						a.nr_prescricao,
						c.nr_sequencia,
						x.nr_sequencia,
						coalesce(substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),'X'),		
						CASE WHEN coalesce(c.dt_lib_horario::text, '') = '' THEN 'W'  ELSE substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,null,null,a.nr_prescricao,null),1,15) END ,
						c.dt_horario,
						x.dt_suspensao) alias105
		where	plt_obter_se_item_periodo(	dt_validade_limite_p,		dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			dt_horario,
											current_setting('plt_gerar_horarios_pck.dt_horario_inicio_sinc_w')::timestamp,	current_setting('plt_gerar_horarios_pck.dt_horario_fim_sinc_w')::timestamp,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
											dt_referencia_p,			ie_edicao_p,			ie_exibir_hor_suspensos_p,	dt_suspensao,		'HM',
											nr_seq_procedimento,		nr_prescricao,		'S') = 'S'
		group by	
				nr_prescricao,
				nr_seq_procedimento,
				ie_lib_pend_rep,
				nr_sequencia,
				ie_status,
				dt_horario
		order by
				dt_horario;		
	end if;

	if (coalesce(get_ie_utiliza_hem_p_hor,'N') <> 'S') then
		loop
		fetch c01 into	nr_prescricao_w,
				nr_seq_procedimento_w,
				ie_status_horario_w,
				current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),				
				current_setting('plt_gerar_horarios_pck.dt_horario_w')::timestamp;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			nr_horario_w := plt_gerar_horarios_pck.get_posicao_horario( current_setting('plt_gerar_horarios_pck.dt_horario_w')::timestamp );
			if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
				ds_comando_update_w	:=	' update w_rep_t ' ||
								' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
								' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
								' where nm_usuario = :nm_usuario ' ||
								' and ie_tipo_item = :ie_tipo ' ||
								' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
								' and nvl(ie_pendente_liberacao,''X'') = :ie_pendente_liberacao ' ||								
								' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

							

				CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
											'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
											'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
											'ie_tipo=HM' || ds_sep_bv_w ||
											'ie_pendente_liberacao=' || current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15) || ds_sep_bv_w ||
											'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );

			end if;
			end;
		end loop;
		close c01;
	else
		loop
		fetch c02 into	nr_prescricao_w,
				nr_seq_procedimento_w,
				current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				nr_seq_horario_w,
				ie_status_horario_w,
				current_setting('plt_gerar_horarios_pck.dt_horario_w')::timestamp;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			nr_horario_w := plt_gerar_horarios_pck.get_posicao_horario( current_setting('plt_gerar_horarios_pck.dt_horario_w')::timestamp );
			if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
				ds_comando_update_w	:=	' update w_rep_t ' ||
								' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
								' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
								' where nm_usuario = :nm_usuario ' ||
								' and ie_tipo_item = :ie_tipo ' ||
								' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
								' and nvl(ie_pendente_liberacao,''X'') = :ie_pendente_liberacao ' ||								
								' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';
							
				CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
											'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
											'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
											'ie_tipo=HM' || ds_sep_bv_w ||
											'ie_pendente_liberacao=' || current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15) || ds_sep_bv_w ||											
											'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );

			end if;
			end;

		end loop;
		close c02;
	end if;

	CALL Atualizar_plt_controle(nm_usuario_p, nr_atendimento_p, current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10), 'HM', 'N',null);	
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_gerar_horarios_pck.plt_sincronizar_hemoterap ( nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, ie_prescr_usuario_p text, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) FROM PUBLIC;
