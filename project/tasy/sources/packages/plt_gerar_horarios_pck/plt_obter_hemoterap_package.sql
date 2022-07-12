-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE plt_gerar_horarios_pck.plt_obter_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_prescr_usuario_p text, nr_seq_regra_p bigint, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) AS $body$
DECLARE


	nr_seq_wadep_w			bigint;
	nr_prescricao_w			bigint;
	nr_seq_procedimento_w		integer;
	cd_procedimento_w		bigint;
	ds_procedimento_w		varchar(255);
	nr_seq_lab_w			varchar(20);
	ie_acm_sn_w			varchar(1);
	cd_intervalo_w			varchar(7);
	qt_procedimento_w		double precision;
	ds_prescricao_w			varchar(100);
	ie_status_solucao_w		varchar(3);
	ie_status_w			varchar(1);
	nr_seq_proc_interno_w		bigint;
	ie_classif_adep_w		varchar(15);
	current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)		varchar(1);
	ie_liberado_w			varchar(1);
	ds_interv_prescr_w		varchar(240);
	nr_seq_solic_sangue_w		bigint;
	ie_origem_proced_w		bigint;
	ie_erro_w			integer;
	ie_copiar_w			varchar(1);
	dt_fim_w			timestamp;
	dt_extensao_w			timestamp;
	ie_plano_atual_w		varchar(1);
	ie_horario_susp_w		varchar(1);
	ie_retrogrado_w			varchar(1);
	ie_pend_assinatura_w 		varchar(1);
	ie_estendido_w			varchar(1);
	dt_validade_prescr_w		timestamp;
	ds_cor_titulo_w			varchar(20);
	ie_curta_duracao_w		varchar(1);
	cd_funcao_origem_w		bigint;
	cd_classif_setor_w		integer;
	ie_interv_farm_w		varchar(1);
	ie_recem_nato_w			varchar(1);
	
	
	c01 REFCURSOR;

	
BEGIN
	dt_fim_w	:= dt_validade_limite_p + 5;
	ie_copiar_w 	:= plt_obter_se_item_marcado('HM', nr_seq_regra_p);
	ds_cor_titulo_w	:= plt_obter_cor_titulo('HM',nr_seq_regra_p);

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		open	c01 for
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
				ds_intervalo,
				nr_seq_solic_sangue,
				ie_origem_proced,
				ie_lib_pend_rep,
				ie_liberado,
				ie_erro,
				dt_extensao,
				ie_plano_atual,
				ie_horario_susp,
				ie_retrogrado,
				ie_pend_assinatura,
				ie_estendido,
				dt_validade_prescr,
				ie_curta_duracao,
				cd_funcao_origem,
				ie_prescr_farm,
				ie_recem_nato
		from	(	SELECT	nr_prescricao,
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
							ds_intervalo,
							nr_seq_solic_sangue,
							ie_origem_proced,
							ie_lib_pend_rep,
							ie_liberado,
							ie_erro,
							dt_extensao,
							ie_plano_atual,
							ie_horario_susp,
							ie_retrogrado,
							ie_pend_assinatura,
							ie_estendido,
							dt_validade_prescr,
							ie_curta_duracao,
							cd_funcao_origem,
							ie_prescr_farm,
							ie_recem_nato
					from	(	select	a.nr_prescricao,
										x.nr_sequencia nr_seq_procedimento,
										x.cd_procedimento,
										CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado,y.ds_procedimento) ds_procedimento,
										obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
										x.cd_intervalo,
										x.qt_procedimento,
										substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
										CASE WHEN x.ie_status='P' THEN  'W'  ELSE substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) END  ie_status_solucao,
										coalesce(x.ie_suspenso,'N') ie_suspenso,
										coalesce(x.nr_seq_proc_interno,0) nr_seq_proc_interno,
										'P' ie_classif_adep,		
										x.nr_seq_lab,
										obter_desc_intervalo_prescr(x.cd_intervalo)||CASE WHEN coalesce(x.cd_intervalo::text, '') = '' THEN ''  ELSE ' ' END ||obter_desc_acm_sn(x.ie_acm,x.ie_se_necessario) ds_intervalo,
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
										plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
										CASE WHEN plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia)='N' THEN x.ie_erro  ELSE null END  ie_erro,
										plt_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
										substr(plt_obter_se_plano_atual(a.nr_prescricao),1,1) ie_plano_atual,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END  ie_horario_susp,
										coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
										substr(plt_obter_ie_validade(plt_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
										a.cd_funcao_origem,
										coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N') ie_recem_nato,
										x.dt_status,
										x.dt_suspensao
								FROM procedimento y, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and a.nr_atendimento = nr_atendimento_p and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S' and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
										((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																												cd_estabelecimento_p, 
																												cd_setor_usuario_p, 
																												cd_perfil_p, 
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
										x.cd_procedimento,
										z.ds_derivado,
										y.ds_procedimento,
										x.ie_acm,
										x.ie_se_necessario,		
										x.cd_intervalo,
										x.qt_procedimento,
										x.ie_suspenso,
										x.nr_seq_proc_interno,
										'P',
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
										x.nr_seq_lab,
										x.ie_status,
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										a.dt_liberacao_medico,
										a.dt_liberacao,
										a.dt_liberacao_farmacia,
										x.ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
										x.ie_util_hemocomponente,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END ,
										a.ie_prescr_emergencia,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
										a.cd_funcao_origem,
										a.ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N'),
										x.dt_status,
										x.dt_suspensao) t
					where	plt_obter_se_item_periodo(	dt_validade_limite_p,	dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			t.dt_status,
														dt_inicial_horarios_p,	dt_final_horarios_p,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
														dt_referencia_p,		ie_edicao_p,			ie_exibir_hor_suspensos_p,	t.dt_suspensao,		'HM',
														t.nr_seq_procedimento,	t.nr_prescricao,		'O') = 'S'
					
union all

					select	nr_prescricao,
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
							ds_intervalo,
							nr_seq_solic_sangue,
							ie_origem_proced,
							ie_lib_pend_rep,
							ie_liberado,
							ie_erro,
							dt_extensao,
							ie_plano_atual,
							ie_horario_susp,
							ie_retrogrado,
							ie_pend_assinatura,
							ie_estendido,
							dt_validade_prescr,
							ie_curta_duracao,
							cd_funcao_origem,
							ie_prescr_farm,
							ie_recem_nato
					from	(	select	a.nr_prescricao,
										x.nr_sequencia nr_seq_procedimento,
										x.cd_procedimento,
										CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado, w.ds_proc_exame) ds_procedimento,
										obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
										x.cd_intervalo,
										x.qt_procedimento,
										substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
										CASE WHEN x.ie_status='P' THEN  'W'  ELSE substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) END  ie_status_solucao,
										coalesce(x.ie_suspenso,'N') ie_suspenso,
										x.nr_seq_proc_interno,
										w.ie_classif_adep,
										x.nr_seq_lab,
										obter_desc_intervalo_prescr(x.cd_intervalo)||CASE WHEN coalesce(x.cd_intervalo::text, '') = '' THEN ''  ELSE ' ' END ||obter_desc_acm_sn(x.ie_acm,x.ie_se_necessario) ds_intervalo,
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
										plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
										CASE WHEN plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia)='N' THEN x.ie_erro  ELSE null END  ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
										substr(PLT_obter_se_plano_atual(a.nr_prescricao),1,1) ie_plano_atual,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END  ie_horario_susp,
										coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
										a.cd_funcao_origem,
										coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N') ie_recem_nato,
										x.dt_status,
										x.dt_suspensao
								FROM procedimento y, proc_interno w, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and a.nr_atendimento = nr_atendimento_p and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and w.ie_tipo <> 'G' and coalesce(w.ie_ivc,'N') <> 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'PH') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'ST') = 'S')) and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
										((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM', 
																												cd_estabelecimento_p, 
																												cd_setor_usuario_p, 
																												cd_perfil_p, 
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
										x.cd_procedimento,
										z.ds_derivado,
										w.ds_proc_exame,
										x.ie_acm,
										x.ie_se_necessario,		
										x.cd_intervalo,
										x.qt_procedimento,
										x.ie_suspenso,
										x.nr_seq_proc_interno,
										w.ie_classif_adep,
										x.nr_seq_lab,
										x.ie_status,
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										a.dt_liberacao_medico,
										a.dt_liberacao,
										a.dt_liberacao_farmacia,
										x.ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
										x.ie_util_hemocomponente,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END ,
										a.ie_prescr_emergencia,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
										a.cd_funcao_origem,
										a.ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N'),
										x.dt_status,
										x.dt_suspensao) t
					where	plt_obter_se_item_periodo(	dt_validade_limite_p,	dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			t.dt_status,
														dt_inicial_horarios_p,	dt_final_horarios_p,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
														dt_referencia_p,		ie_edicao_p,			ie_exibir_hor_suspensos_p,	t.dt_suspensao,		'HM',
														t.nr_seq_procedimento,	t.nr_prescricao,		'O') = 'S'
			) alias165
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
				ds_intervalo,
				nr_seq_solic_sangue,
				ie_origem_proced,
				ie_lib_pend_rep,
				ie_liberado,
				ie_erro,
				dt_extensao,
				ie_plano_atual,
				ie_horario_susp,
				ie_retrogrado,
				ie_pend_assinatura,
				ie_estendido,
				dt_validade_prescr,
				ie_curta_duracao,
				cd_funcao_origem,
				ie_prescr_farm,
				ie_recem_nato;	
	else
		open	c01 for
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
				ds_intervalo,
				nr_seq_solic_sangue,
				ie_origem_proced,
				ie_lib_pend_rep,
				ie_liberado,
				ie_erro,
				dt_extensao,
				ie_plano_atual,
				ie_horario_susp,
				ie_retrogrado,
				ie_pend_assinatura,
				ie_estendido,
				dt_validade_prescr,
				ie_curta_duracao,
				cd_funcao_origem,
				ie_prescr_farm,
				ie_recem_nato
		from	(	SELECT	nr_prescricao,
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
							ds_intervalo,
							nr_seq_solic_sangue,
							ie_origem_proced,
							ie_lib_pend_rep,
							ie_liberado,
							ie_erro,
							dt_extensao,
							ie_plano_atual,
							ie_horario_susp,
							ie_retrogrado,
							ie_pend_assinatura,
							ie_estendido,
							dt_validade_prescr,
							ie_curta_duracao,
							cd_funcao_origem,
							ie_prescr_farm,
							ie_recem_nato
					from	(	select	a.nr_prescricao,
										x.nr_sequencia nr_seq_procedimento,
										x.cd_procedimento,
										CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado,y.ds_procedimento) ds_procedimento,
										obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
										x.cd_intervalo,
										x.qt_procedimento,
										substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
										CASE WHEN x.ie_status='P' THEN  'W'  ELSE substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) END  ie_status_solucao,
										coalesce(x.ie_suspenso,'N') ie_suspenso,
										coalesce(x.nr_seq_proc_interno,0) nr_seq_proc_interno,
										'P' ie_classif_adep,		
										x.nr_seq_lab,
										obter_desc_intervalo_prescr(x.cd_intervalo)||CASE WHEN coalesce(x.cd_intervalo::text, '') = '' THEN ''  ELSE ' ' END ||obter_desc_acm_sn(x.ie_acm,x.ie_se_necessario) ds_intervalo,
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
										plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
										CASE WHEN plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia)='N' THEN x.ie_erro  ELSE null END  ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
										substr(PLT_obter_se_plano_atual(a.nr_prescricao),1,1) ie_plano_atual,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END  ie_horario_susp,
										coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
										a.cd_funcao_origem,
										coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N') ie_recem_nato,
										x.dt_status,
										x.dt_suspensao
								FROM procedimento y, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and x.nr_prescricao = a.nr_prescricao and a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10) and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and coalesce(x.nr_seq_proc_interno::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and PLT_Gerar_Horarios_PCK.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S' and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S')) and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
										((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																											cd_estabelecimento_p, 
																											cd_setor_usuario_p, 
																											cd_perfil_p, 
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
										x.cd_procedimento,
										z.ds_derivado,
										y.ds_procedimento,
										x.ie_acm,
										x.ie_se_necessario,		
										x.cd_intervalo,
										x.qt_procedimento,
										x.ie_suspenso,
										x.nr_seq_proc_interno,
										'P',
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
										x.nr_seq_lab,
										x.ie_status,
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										a.dt_liberacao_medico,
										a.dt_liberacao,
										a.dt_liberacao_farmacia,
										x.ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
										x.ie_util_hemocomponente,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END ,
										a.ie_prescr_emergencia,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
										a.cd_funcao_origem,
										a.ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N'),
										x.dt_status,
										x.dt_suspensao) t
					where	plt_obter_se_item_periodo(	dt_validade_limite_p,	dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			t.dt_status,
														dt_inicial_horarios_p,	dt_final_horarios_p,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
														dt_referencia_p,		ie_edicao_p,			ie_exibir_hor_suspensos_p,	t.dt_suspensao,		'HM',
														t.nr_seq_procedimento,	t.nr_prescricao,		'O') = 'S'
					
union all

					select	nr_prescricao,
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
							ds_intervalo,
							nr_seq_solic_sangue,
							ie_origem_proced,
							ie_lib_pend_rep,
							ie_liberado,
							ie_erro,
							dt_extensao,
							ie_plano_atual,
							ie_horario_susp,
							ie_retrogrado,
							ie_pend_assinatura,
							ie_estendido,
							dt_validade_prescr,
							ie_curta_duracao,
							cd_funcao_origem,
							ie_prescr_farm,
							ie_recem_nato
					from	(	select	a.nr_prescricao,
										x.nr_sequencia nr_seq_procedimento,
										x.cd_procedimento,
										CASE WHEN coalesce(x.ie_util_hemocomponente::text, '') = '' THEN null  ELSE '('|| substr(obter_valor_dominio(2247,x.ie_util_hemocomponente),1,20) ||') ' END  || coalesce(z.ds_derivado, w.ds_proc_exame) ds_procedimento,
										obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
										x.cd_intervalo,
										x.qt_procedimento,
										substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
										CASE WHEN x.ie_status='P' THEN  'W'  ELSE substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) END  ie_status_solucao,
										coalesce(x.ie_suspenso,'N') ie_suspenso,
										x.nr_seq_proc_interno,
										w.ie_classif_adep,
										x.nr_seq_lab,
										obter_desc_intervalo_prescr(x.cd_intervalo)||CASE WHEN coalesce(x.cd_intervalo::text, '') = '' THEN ''  ELSE ' ' END ||obter_desc_acm_sn(x.ie_acm,x.ie_se_necessario) ds_intervalo,
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
										plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
										CASE WHEN plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia)='N' THEN x.ie_erro  ELSE null END  ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
										substr(PLT_obter_se_plano_atual(a.nr_prescricao),1,1) ie_plano_atual,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END  ie_horario_susp,
										coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
										a.cd_funcao_origem,
										coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N') ie_recem_nato,
										x.dt_status,
										x.dt_suspensao
								FROM procedimento y, proc_interno w, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN san_derivado z ON (x.nr_seq_derivado = z.nr_sequencia)
WHERE y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and x.nr_prescricao = a.nr_prescricao and a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10) and a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint and a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w and w.ie_tipo <> 'G' and coalesce(w.ie_ivc,'N') <> 'S' and coalesce(w.ie_ctrl_glic,'NC') = 'NC' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and coalesce(x.nr_seq_exame::text, '') = '' and plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S' and (x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') and ((x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'PH') = 'S')) and ((coalesce(x.nr_seq_exame_sangue::text, '') = '') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'BS') = 'S') or (Obter_se_exibe_proced(x.nr_prescricao,x.nr_sequencia,x.ie_tipo_proced,'ST') = 'S')) and ((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'S') or
										((current_setting('plt_gerar_horarios_pck.ie_regra_incl_hemoterapia_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'HM',
																												cd_estabelecimento_p, 
																												cd_setor_usuario_p, 
																												cd_perfil_p, 
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
										x.cd_procedimento,
										z.ds_derivado,
										w.ds_proc_exame,
										x.ie_acm,
										x.ie_se_necessario,		
										x.cd_intervalo,
										x.qt_procedimento,
										x.ie_suspenso,
										x.nr_seq_proc_interno,
										w.ie_classif_adep,
										x.nr_seq_lab,
										x.ie_status,
										substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
										x.nr_seq_solic_sangue,
										x.ie_origem_proced,
										a.dt_liberacao_medico,
										a.dt_liberacao,
										a.dt_liberacao_farmacia,
										x.ie_erro,
										PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
										x.ie_util_hemocomponente,
										CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END ,
										a.ie_prescr_emergencia,
										substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
										substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
										a.dt_validade_prescr,
										obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
										a.cd_funcao_origem,
										a.ie_prescr_farm,
										coalesce(a.ie_recem_nato, 'N'),
										x.dt_status,
										x.dt_suspensao) t
					where	plt_obter_se_item_periodo(	dt_validade_limite_p,	dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,		t.dt_status,
														dt_inicial_horarios_p,	dt_final_horarios_p,	ie_prescr_usuario_p,		nm_usuario_p,	ie_estendidos_p,
														dt_referencia_p,		ie_edicao_p,			ie_exibir_hor_suspensos_p,	t.dt_suspensao,	'HM',
														t.nr_seq_procedimento,	t.nr_prescricao,		'O') = 'S') alias168
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
			ds_intervalo,
			nr_seq_solic_sangue,
			ie_origem_proced,
			ie_lib_pend_rep,
			ie_liberado,
			ie_erro,
			dt_extensao,
			ie_plano_atual,
			ie_horario_susp,
			ie_retrogrado,
			ie_pend_assinatura,
			ie_estendido,
			dt_validade_prescr,
			ie_curta_duracao,
			cd_funcao_origem,
			ie_prescr_farm,
			ie_recem_nato;
	end if;
	
	loop
	fetch c01 into	nr_prescricao_w,
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
			ds_interv_prescr_w,
			nr_seq_solic_sangue_w,
			ie_origem_proced_w,
			current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
			ie_liberado_w,
			ie_erro_w,
			dt_extensao_w,
			ie_plano_atual_w,
			ie_horario_susp_w,
			ie_retrogrado_w,
			ie_pend_assinatura_w,
			ie_estendido_w,
			dt_validade_prescr_w,
			ie_curta_duracao_w,
			cd_funcao_origem_w,
			ie_interv_farm_w,
			ie_recem_nato_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	coalesce(Obter_classif_setor_atend(nr_atendimento_p),0)
		into STRICT	cd_classif_setor_w
		;
			
		if (ie_estendido_w	= 'P') and (coalesce(dt_extensao_w::text, '') = '') then
			dt_extensao_w	:= dt_validade_prescr_w;
		end if;	
		
		if (((ie_estendido_w = 'P') and
			 ((coalesce(cd_funcao_origem_w,924) <> 950) or (ie_curta_duracao_w = 'N'))) or (cd_classif_setor_w = 1)) then
			ie_estendido_w	:= 'N';
		end if;
		
		select	nextval('w_rep_t_seq')
		into STRICT	nr_seq_wadep_w
		;
		
		insert into w_rep_t(
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
			ds_interv_prescr,
			nr_seq_solic_sangue,
			ie_origem_proced,
			ie_pendente_liberacao,
			ie_liberado,
			ie_erro,
			ie_copiar,
			dt_extensao,
			nr_prescricoes,
			ie_plano_atual,
			ie_horario_susp,
			ie_retrogrado,
			ie_pend_assinatura,
			dt_atualizacao,
			ie_estendido,
			ds_cor_titulo,
			ie_curta_duracao,
			ie_interv_farm,
			ie_item_rn)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'HM',
			nr_prescricao_w,
			nr_seq_procedimento_w,
			cd_procedimento_w,
			ds_procedimento_w,
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
			ds_interv_prescr_w,
			nr_seq_solic_sangue_w,
			ie_origem_proced_w,
			current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
			ie_liberado_w,
			ie_erro_w,
			CASE WHEN ie_status_w='S' THEN 'N'  ELSE ie_copiar_w END ,
			dt_extensao_w,
			nr_prescricao_w,
			ie_plano_atual_w,
			ie_horario_susp_w,
			ie_retrogrado_w,
			ie_pend_assinatura_w,
			clock_timestamp(),
			ie_estendido_w,
			ds_cor_titulo_w,
			ie_curta_duracao_w,
			ie_interv_farm_w,
			ie_recem_nato_w);
		end;
	end loop;
	close c01;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_gerar_horarios_pck.plt_obter_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_prescr_usuario_p text, nr_seq_regra_p bigint, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) FROM PUBLIC;