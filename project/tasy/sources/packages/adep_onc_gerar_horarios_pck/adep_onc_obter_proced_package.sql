-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_onc_gerar_horarios_pck.adep_onc_obter_proced ( nm_usuario_p text, nr_atendimento_p bigint, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_associados_p text, ie_data_lib_proced_p text, ie_opcao_filtro_p text, dt_filtro_p timestamp, nr_ciclo_p bigint, ie_lib_pend_rep_p text, dt_inicial_horario_p timestamp, dt_final_horario_p timestamp) AS $body$
DECLARE


	nr_seq_wadep_w		bigint;
	nr_prescricao_w		bigint;
	nr_seq_procedimento_w	numeric(20);
	nr_seq_proced_prescr_w	numeric(20);
	cd_procedimento_w	bigint;
	ds_procedimento_w	varchar(255);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_procedimento_w	double precision;
	ds_prescricao_w		varchar(240);
	ds_diluicao_w		varchar(2000);
	ie_status_w		varchar(1);
	ie_associados_w		varchar(1);
	nr_seq_proc_interno_w	bigint;
	ds_componentes_w	varchar(240);
	nr_ciclo_w		smallint;
	ds_dia_ciclo_w		varchar(5);
	nr_seq_onc_w		bigint;
	dt_oncologia_w		timestamp;
	nr_seq_proc_cpoe_w	prescr_procedimento.nr_seq_proc_cpoe%type;	
	
	c01 CURSOR FOR
	SELECT	CASE WHEN GetDesagrupaProcedimento='N' THEN CASE WHEN obter_se_agrupar_proced_adep(nr_prescricao,nr_seq_procedimento,ie_acm_sn,ie_agrupar_acm_sn_p,ie_associados,ie_agrupar_associados_p)='N' THEN nr_prescricao  ELSE null END   ELSE nr_prescricao END ,
		CASE WHEN GetDesagrupaProcedimento='N' THEN CASE WHEN obter_se_agrupar_proced_adep(nr_prescricao,nr_seq_procedimento,ie_acm_sn,ie_agrupar_acm_sn_p,ie_associados,ie_agrupar_associados_p)='N' THEN CASE WHEN ie_associados='N' THEN nr_seq_proced_prescr  ELSE nr_seq_procedimento END   ELSE null END   ELSE nr_seq_proced_prescr END ,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,	
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		null,
		ie_associados,
		nr_seq_proc_interno,
		ds_diluicao,
		ds_mat_med_assoc,
		nr_ciclo,
		ds_dia_ciclo,
		nr_seq_ordem_adep,
		dt_oncologia,
		nr_seq_proc_cpoe
	from	(
		SELECT	a.nr_prescricao,
			c.nr_seq_procedimento,
			c.nr_seq_procedimento||a.nr_prescricao nr_seq_proced_prescr,
			c.cd_procedimento,
			substr(CASE WHEN get_usa_apelido_exame='N' THEN y.ds_procedimento  ELSE coalesce(x.ds_rotina,y.ds_procedimento) END , 1,240) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_procedimento,
			substr(adep_obter_dados_prescr_proc(a.nr_prescricao,c.nr_seq_procedimento,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(obter_se_associado_dif(a.nr_prescricao,c.nr_seq_procedimento),1,1) ie_associados,
			c.nr_seq_proc_interno,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80) ds_diluicao,
			substr(obter_mat_med_assoc_proc(a.nr_prescricao,c.nr_seq_procedimento,'S'),1,240) ds_mat_med_assoc,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real) ds_dia_ciclo,
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0) nr_seq_ordem_adep,
			coalesce(b.dt_real,b.dt_prevista) dt_oncologia,
			x.nr_seq_proc_cpoe
		from	procedimento y,
			prescr_procedimento x,
			prescr_proc_hor c,
			prescr_medica a,
			paciente_atendimento b,
			paciente_setor p
		where	y.cd_procedimento = x.cd_procedimento
		and	y.ie_origem_proced = x.ie_origem_proced
		and	y.cd_procedimento = c.cd_procedimento
		and	y.ie_origem_proced = c.ie_origem_proced
		and	x.nr_prescricao = c.nr_prescricao
		and	x.nr_sequencia = c.nr_seq_procedimento
		and	x.nr_prescricao = a.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	a.nr_seq_atend	= b.nr_seq_atendimento
		and	b.nr_seq_paciente = p.nr_seq_paciente
		and	coalesce(a.ie_recem_nato,'N')	= 'N'
		and	coalesce(x.nr_seq_proc_princ::text, '') = ''
		and	a.nr_atendimento = nr_atendimento_p
		and	p.cd_pessoa_fisica = a.cd_pessoa_fisica
		and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
		and	coalesce(x.nr_seq_proc_interno::text, '') = ''
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = ''
		and 	coalesce(x.nr_Seq_origem::text, '') = ''
		and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'	
		and ((ie_opcao_filtro_p in ('Q','C')) or
			 ((ie_opcao_filtro_p = 'D') and (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p))) or
			 (ie_opcao_filtro_p = 'H' AND c.dt_horario between dt_inicial_horario_p and dt_final_horario_p))
		and	b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)		
		group by
			a.nr_prescricao,
			c.nr_seq_procedimento,
			c.nr_seq_procedimento||a.nr_prescricao,
			c.cd_procedimento,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80),
			y.ds_procedimento,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_procedimento,
			x.ie_suspenso,
			x.ds_rotina,
			c.nr_seq_proc_interno,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real),
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0),
			coalesce(b.dt_real,b.dt_prevista),
			x.nr_seq_proc_cpoe
		
union all

		select	a.nr_prescricao,
			c.nr_seq_procedimento,
			c.nr_seq_procedimento||a.nr_prescricao nr_seq_proced_prescr,
			c.cd_procedimento,
			substr(CASE WHEN get_usa_apelido_exame='N' THEN coalesce(w.ds_proc_exame,y.ds_procedimento)  ELSE coalesce(x.ds_rotina,coalesce(w.ds_proc_exame,y.ds_procedimento)) END , 1,240) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_procedimento,
			substr(adep_obter_dados_prescr_proc(a.nr_prescricao,c.nr_seq_procedimento,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(obter_se_associado_dif(a.nr_prescricao,c.nr_seq_procedimento),1,1) ie_associados,
			c.nr_seq_proc_interno,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80) ds_diluicao,
			substr(obter_mat_med_assoc_proc(a.nr_prescricao,c.nr_seq_procedimento,'S'),1,240) ds_mat_med_assoc,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real) ds_dia_ciclo,
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0) nr_seq_ordem_adep,
			coalesce(b.dt_real,b.dt_prevista) dt_oncologia,
			x.nr_seq_proc_cpoe
		from	procedimento y,
			proc_interno w,
			prescr_procedimento x,
			prescr_proc_hor c,
			prescr_medica a,
			paciente_atendimento b,
			paciente_setor p
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
		and	a.nr_seq_atend	= b.nr_seq_atendimento
		and	b.nr_seq_paciente = p.nr_seq_paciente
		and	coalesce(a.ie_recem_nato,'N')	= 'N'
		and	coalesce(x.nr_seq_proc_princ::text, '') = ''
		and	a.nr_atendimento = nr_atendimento_p
		and	p.cd_pessoa_fisica = a.cd_pessoa_fisica
		and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
		and	w.ie_tipo <> 'G'
		and	w.ie_tipo <> 'BS'
		and	coalesce(w.ie_ivc,'N') <> 'S'
		and	coalesce(w.ie_ctrl_glic,'NC') = 'NC'
		and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
		and	coalesce(x.nr_seq_prot_glic::text, '') = ''
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and 	coalesce(x.nr_Seq_origem::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = ''
		and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
		and ((ie_opcao_filtro_p in ('Q','C')) or
			 ((ie_opcao_filtro_p = 'D') and (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p))) or
			 (ie_opcao_filtro_p = 'H' AND c.dt_horario between dt_inicial_horario_p and dt_final_horario_p))
		and	b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)		
		group by
			a.nr_prescricao,
			c.nr_seq_procedimento,
			c.nr_seq_procedimento||a.nr_prescricao,
			c.cd_procedimento,
			w.ds_proc_exame,
			y.ds_procedimento,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80),
			x.qt_procedimento,
			x.ie_suspenso,
			x.ds_rotina,
			c.nr_seq_proc_interno,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real),
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0),
			coalesce(b.dt_real,b.dt_prevista),
			x.nr_seq_proc_cpoe
		) alias109
	group by
		CASE WHEN GetDesagrupaProcedimento='N' THEN CASE WHEN obter_se_agrupar_proced_adep(nr_prescricao,nr_seq_procedimento,ie_acm_sn,ie_agrupar_acm_sn_p,ie_associados,ie_agrupar_associados_p)='N' THEN nr_prescricao  ELSE null END   ELSE nr_prescricao END ,
		CASE WHEN GetDesagrupaProcedimento='N' THEN CASE WHEN obter_se_agrupar_proced_adep(nr_prescricao,nr_seq_procedimento,ie_acm_sn,ie_agrupar_acm_sn_p,ie_associados,ie_agrupar_associados_p)='N' THEN CASE WHEN ie_associados='N' THEN nr_seq_proced_prescr  ELSE nr_seq_procedimento END   ELSE null END   ELSE nr_seq_proced_prescr END ,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,	
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		null,
		ds_diluicao,
		ie_associados,
		nr_seq_proc_interno,
		ds_mat_med_assoc,
		nr_ciclo,
		ds_dia_ciclo,
		nr_seq_ordem_adep,
		dt_oncologia,
		nr_seq_proc_cpoe;
		
	c02 CURSOR FOR
	SELECT	nr_prescricao,
		nr_seq_procedimento,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,	
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		null,
		ie_associados,
		nr_seq_proc_interno,
		ds_diluicao,
		ds_mat_med_assoc,
		nr_ciclo,
		ds_dia_ciclo,
		nr_seq_ordem_adep,
		dt_oncologia,
		nr_seq_proc_cpoe
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_procedimento,
			x.nr_sequencia||a.nr_prescricao nr_seq_proced_prescr,
			x.cd_procedimento,
			substr(CASE WHEN get_usa_apelido_exame='N' THEN y.ds_procedimento  ELSE coalesce(x.ds_rotina,y.ds_procedimento) END , 1,240) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_procedimento,
			substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(obter_se_associado_dif(a.nr_prescricao,x.nr_sequencia),1,1) ie_associados,
			x.nr_seq_proc_interno,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80) ds_diluicao,
			substr(obter_mat_med_assoc_proc(a.nr_prescricao,x.nr_sequencia,'S'),1,240) ds_mat_med_assoc,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real) ds_dia_ciclo,
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0) nr_seq_ordem_adep,
			coalesce(b.dt_real,b.dt_prevista) dt_oncologia,
			x.nr_seq_proc_cpoe
		from	procedimento y,
			prescr_procedimento x,
			prescr_medica a,
			paciente_atendimento b,
			paciente_setor p
		where	y.cd_procedimento = x.cd_procedimento
		and	y.ie_origem_proced = x.ie_origem_proced
		and	x.nr_prescricao = a.nr_prescricao
		and	a.nr_seq_atend	= b.nr_seq_atendimento
		and	b.nr_seq_paciente = p.nr_seq_paciente
		and	coalesce(a.ie_recem_nato,'N')	= 'N'
		and	coalesce(x.nr_seq_proc_princ::text, '') = ''
		and 	coalesce(x.dt_suspensao::text, '') = ''
		and 	coalesce(a.dt_suspensao::text, '') = ''					
		and	a.nr_atendimento = nr_atendimento_p
		and	a.cd_pessoa_fisica = p.cd_pessoa_fisica
		and	(a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')
		and	((coalesce(a.dt_liberacao::text, '') = '') or (coalesce(a.dt_liberacao_farmacia::text, '') = ''))
		and	coalesce(x.nr_seq_proc_interno::text, '') = ''
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = ''
		and 	coalesce(x.nr_Seq_origem::text, '') = ''
		and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((ie_opcao_filtro_p	in ('Q','C')) or (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p)))
		and	b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)
		and	not exists (
				select	1
				from	prescr_proc_hor c
				where	c.cd_procedimento = y.cd_procedimento
				and	c.ie_origem_proced = y.ie_origem_proced
				and	c.nr_prescricao = x.nr_prescricao
				and	c.nr_seq_procedimento = x.nr_sequencia
				and	c.nr_prescricao = a.nr_prescricao
				and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')		
		group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.nr_sequencia||a.nr_prescricao,
			x.cd_procedimento,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80),
			y.ds_procedimento,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			x.qt_procedimento,
			x.ie_suspenso,
			x.ds_rotina,
			x.nr_seq_proc_interno,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real),
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0),
			coalesce(b.dt_real,b.dt_prevista),
			x.nr_seq_proc_cpoe
		
union all

		select	a.nr_prescricao,
			x.nr_sequencia nr_seq_procedimento,
			x.nr_sequencia||a.nr_prescricao nr_seq_proced_prescr,
			x.cd_procedimento,
			substr(CASE WHEN get_usa_apelido_exame='N' THEN coalesce(w.ds_proc_exame,y.ds_procedimento)  ELSE coalesce(x.ds_rotina,coalesce(w.ds_proc_exame,y.ds_procedimento)) END , 1,240) ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			x.qt_procedimento,
			substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(obter_se_associado_dif(a.nr_prescricao,x.nr_sequencia),1,1) ie_associados,
			x.nr_seq_proc_interno,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80) ds_diluicao,
			substr(obter_mat_med_assoc_proc(a.nr_prescricao,x.nr_sequencia,'S'),1,240) ds_mat_med_assoc,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real) ds_dia_ciclo,
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0) nr_seq_ordem_adep,
			coalesce(b.dt_real,b.dt_prevista) dt_oncologia,
			x.nr_seq_proc_cpoe
		from	procedimento y,
			proc_interno w,
			prescr_procedimento x,
			prescr_medica a,
			paciente_atendimento b,
			paciente_setor p
		where	y.cd_procedimento = x.cd_procedimento
		and	y.ie_origem_proced = x.ie_origem_proced
		and	w.nr_sequencia = x.nr_seq_proc_interno
		and	x.nr_prescricao = a.nr_prescricao
		and	a.nr_seq_atend	= b.nr_seq_atendimento
		and	p.nr_seq_paciente = b.nr_seq_paciente
		and	(a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')
		and 	coalesce(x.dt_suspensao::text, '') = ''
		and 	coalesce(a.dt_suspensao::text, '') = ''					
		and	((coalesce(a.dt_liberacao::text, '') = '') or (coalesce(a.dt_liberacao_farmacia::text, '') = ''))		
		and	coalesce(a.ie_recem_nato,'N')	= 'N'
		and	coalesce(x.nr_seq_proc_princ::text, '') = ''
		and	a.nr_atendimento = nr_atendimento_p
		and	p.cd_pessoa_fisica = a.cd_pessoa_fisica
		and	w.ie_tipo <> 'G'
		and	w.ie_tipo <> 'BS'
		and	coalesce(w.ie_ivc,'N') <> 'S'
		and	coalesce(w.ie_ctrl_glic,'NC') = 'NC'
		and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
		and	coalesce(x.nr_seq_prot_glic::text, '') = ''
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and 	coalesce(x.nr_Seq_origem::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = ''
		and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
		and	((ie_opcao_filtro_p	in ('Q','C')) or (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p)))
		and	b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)
		and	not exists (
				select	1
				from	prescr_proc_hor c
				where	c.cd_procedimento = y.cd_procedimento
				and	c.ie_origem_proced = y.ie_origem_proced
				and	c.nr_prescricao = x.nr_prescricao
				and	c.nr_seq_procedimento = x.nr_sequencia
				and	c.nr_prescricao = a.nr_prescricao
				and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')		
		group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.nr_sequencia||a.nr_prescricao,
			x.cd_procedimento,
			w.ds_proc_exame,
			y.ds_procedimento,
			x.ie_acm,
			x.ie_se_necessario,		
			x.cd_intervalo,
			substr(Obter_item_princ_disp(x.nr_prescricao, x.nr_seq_prescr_sol, x.nr_seq_prescr_mat),1,80),
			x.qt_procedimento,
			x.ie_suspenso,
			x.ds_rotina,
			x.nr_seq_proc_interno,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real),
			coalesce(coalesce(x.nr_Seq_ordem_adep,x.nr_agrupamento),0),
			coalesce(b.dt_real,b.dt_prevista),
			x.nr_seq_proc_cpoe
		) alias109
	group by
		nr_prescricao,
		nr_seq_procedimento,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,	
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		null,
		ds_diluicao,
		ie_associados,
		nr_seq_proc_interno,
		ds_mat_med_assoc,
		nr_ciclo,
		ds_dia_ciclo,
		nr_seq_ordem_adep,
		dt_oncologia,
		nr_seq_proc_cpoe;		

	
BEGIN
	open c01;
	loop
	fetch c01 into	nr_prescricao_w,
			nr_seq_procedimento_w,
			cd_procedimento_w,
			ds_procedimento_w,
			ie_acm_sn_w,		
			cd_intervalo_w,
			qt_procedimento_w,
			ds_prescricao_w,
			ie_status_w,
			ie_associados_w,
			nr_seq_proc_interno_w,
			ds_diluicao_w,
			ds_componentes_w,
			nr_ciclo_w,
			ds_dia_ciclo_w,
			nr_seq_onc_w,
			dt_oncologia_w,
			nr_seq_proc_cpoe_w;
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
			ds_prescricao,
			ie_status_item,
			nr_seq_proc_interno,
			nr_agrupamento,
			ds_diluicao,
			ds_componentes,
			nr_ciclo,
			ds_dia_ciclo,
			nr_seq_onc,
			dt_oncologia,
			nr_seq_cpoe)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'P',
			nr_prescricao_w,
			nr_seq_procedimento_w,
			cd_procedimento_w,
			ds_procedimento_w,
			ie_acm_sn_w,
			cd_intervalo_w,
			qt_procedimento_w,
			ds_prescricao_w,
			ie_status_w,
			nr_seq_proc_interno_w,
			0,
			ds_diluicao_w,
			ds_componentes_w,
			nr_ciclo_w,
			ds_dia_ciclo_w,
			nr_seq_onc_w,
			dt_oncologia_w,
			nr_seq_proc_cpoe_w);
		commit;
		end;
	end loop;
	close c01;
	
	if (ie_lib_pend_rep_p	= 'S') then
	
		open c02;
		loop
		fetch c02 into	nr_prescricao_w,
				nr_seq_procedimento_w,
				cd_procedimento_w,
				ds_procedimento_w,
				ie_acm_sn_w,		
				cd_intervalo_w,
				qt_procedimento_w,
				ds_prescricao_w,
				ie_status_w,
				ie_associados_w,
				nr_seq_proc_interno_w,
				ds_diluicao_w,
				ds_componentes_w,
				nr_ciclo_w,
				ds_dia_ciclo_w,
				nr_seq_onc_w,
				dt_oncologia_w,
				nr_seq_proc_cpoe_w;
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
				ds_prescricao,
				ie_status_item,
				nr_seq_proc_interno,
				nr_agrupamento,
				ds_diluicao,
				ds_componentes,
				nr_ciclo,
				ds_dia_ciclo,
				nr_seq_onc,
				dt_oncologia,
				nr_seq_cpoe)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'P',
				nr_prescricao_w,
				nr_seq_procedimento_w,
				cd_procedimento_w,
				ds_procedimento_w,
				ie_acm_sn_w,
				cd_intervalo_w,
				qt_procedimento_w,
				ds_prescricao_w,
				ie_status_w,
				nr_seq_proc_interno_w,
				0,
				ds_diluicao_w,
				ds_componentes_w,
				nr_ciclo_w,
				ds_dia_ciclo_w,
				nr_seq_onc_w,
				dt_oncologia_w,
				nr_seq_proc_cpoe_w);
			commit;
			end;
		end loop;
		close c02;
	
	end if;	

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_onc_gerar_horarios_pck.adep_onc_obter_proced ( nm_usuario_p text, nr_atendimento_p bigint, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_associados_p text, ie_data_lib_proced_p text, ie_opcao_filtro_p text, dt_filtro_p timestamp, nr_ciclo_p bigint, ie_lib_pend_rep_p text, dt_inicial_horario_p timestamp, dt_final_horario_p timestamp) FROM PUBLIC;