-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.vipe_obter_cig ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


	nr_seq_wadep_w		bigint;
	nr_prescricao_w		bigint;
	nr_seq_procedimento_w	integer;
	cd_procedimento_w	bigint;
	ds_procedimento_w	varchar(255);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_procedimento_w	double precision;
	ds_prescricao_w		varchar(100);
	ie_status_w		varchar(1);
	nr_seq_proc_interno_w	bigint;
	ie_classif_adep_w	varchar(15);
	current_setting('vipe_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)	varchar(1);
	ds_interv_prescr_w	varchar(15);
	dt_fim_w		timestamp;
	ie_permite_acao_w	varchar(1);
	nr_seq_prot_glic_w	bigint;

	c01 CURSOR FOR
	SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_procedimento  ELSE null END   ELSE null END ,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END  ie_status,
		nr_seq_proc_interno,
		ds_intervalo,
		ie_permite_acao,
		nr_seq_prot_glic
	from	(
		SELECT	a.nr_prescricao,
			c.nr_seq_procedimento,
			c.cd_procedimento,
			z.ds_valor_dominio ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
			x.cd_intervalo,
			x.qt_procedimento,
			substr(adep_obter_dados_prescr_proc(a.nr_prescricao,c.nr_seq_procedimento,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			c.nr_seq_proc_interno,
			substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo,
			obter_se_habilita_opcao('C',cd_perfil_p) ie_permite_acao,
			x.nr_seq_prot_glic
		from	valor_dominio z,
			procedimento y,
			proc_interno w,
			prescr_procedimento x,
			prescr_proc_hor c,
			prescr_medica a
		where	z.cd_dominio = 1903
		and	z.vl_dominio = w.ie_ctrl_glic
		and	y.cd_procedimento = x.cd_procedimento
		and	y.ie_origem_proced = x.ie_origem_proced
		and	y.cd_procedimento = c.cd_procedimento
		and	y.ie_origem_proced = c.ie_origem_proced
		and	w.nr_sequencia = x.nr_seq_proc_interno
		and	w.nr_sequencia = c.nr_seq_proc_interno
		and	x.nr_prescricao = c.nr_prescricao
		and	x.nr_sequencia = c.nr_seq_procedimento
		and	x.nr_prescricao = a.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S'
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		--and	obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) is not null
		and	w.ie_tipo <> 'G'
		and	w.ie_tipo <> 'BS'
		and	coalesce(w.ie_ivc,'N') <> 'S'
		and	w.ie_ctrl_glic = 'CIG'
		and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
		--and	x.nr_seq_prot_glic is null
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = ''
		and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = ''))
		and	((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S'))
		and	coalesce(c.ie_situacao,'A') = 'A'
		and	(((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((get_ie_considera_horario = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')) or
			 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
		and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
		and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
		and	((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'CIG',
																			cd_estabelecimento_p,
																			cd_setor_usuario_p,
																			cd_perfil_p,
																			null,
																			c.cd_procedimento,
																			c.ie_origem_proced,
																			c.nr_seq_proc_interno,
																			a.cd_setor_atendimento,
																			x.cd_setor_atendimento,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																			x.nr_seq_exame) = 'S')))		  -- nr_seq_exame_p
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'))
		group by
			a.nr_prescricao,
			c.nr_seq_procedimento,
			c.cd_procedimento,
			z.ds_valor_dominio,
			x.ie_acm,
			x.ie_se_necessario,
			x.cd_intervalo,
			x.qt_procedimento,
			x.ie_suspenso,
			c.nr_seq_proc_interno,
			x.nr_seq_prot_glic
		) alias62
	group by
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_procedimento  ELSE null END   ELSE null END ,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END ,
		nr_seq_proc_interno,
		ds_intervalo,
		ie_permite_acao,
		nr_seq_prot_glic;

	c02 CURSOR FOR
	SELECT	nr_prescricao,
		nr_seq_procedimento,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		CASE WHEN ie_suspenso='S' THEN ie_suspenso  ELSE null END ,
		nr_seq_proc_interno,
		ie_lib_pend_rep,
		ds_intervalo,
		ie_permite_acao,
		nr_seq_prot_glic
	from	(
		SELECT	a.nr_prescricao,
			x.nr_sequencia nr_seq_procedimento,
			x.cd_procedimento,
			z.ds_valor_dominio ds_procedimento,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
			x.cd_intervalo,
			x.qt_procedimento,
			substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			x.nr_seq_proc_interno,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo,
			obter_se_habilita_opcao('C',cd_perfil_p) ie_permite_acao,
			x.nr_seq_prot_glic
		from	valor_dominio z,
			procedimento y,
			proc_interno w,
			prescr_procedimento x,
			prescr_medica a
		where	z.cd_dominio = 1903
		and	z.vl_dominio = w.ie_ctrl_glic
		and	y.cd_procedimento = x.cd_procedimento
		and	y.ie_origem_proced = x.ie_origem_proced
		and	w.nr_sequencia = x.nr_seq_proc_interno
		and	x.nr_prescricao = a.nr_prescricao
		and	Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S'
		and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and	a.nr_atendimento = nr_atendimento_p
		and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		--and	obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) is not null
		and	w.ie_tipo <> 'G'
		and	w.ie_tipo <> 'BS'
		and	coalesce(w.ie_ivc,'N') <> 'S'
		and	w.ie_ctrl_glic = 'CIG'
		and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
		--and	x.nr_seq_prot_glic is null
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = ''
		and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
		and	((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = ''))
		and	((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S'))
		and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
		and	((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'CIG',
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
																			x.nr_seq_exame) = 'S')))		  -- nr_seq_exame_p
		and	not exists (
				select	1
				from	prescr_proc_hor c
				where	c.cd_procedimento = y.cd_procedimento
				and	c.ie_origem_proced = y.ie_origem_proced
				and	c.nr_prescricao = x.nr_prescricao
				and	c.nr_seq_procedimento = x.nr_sequencia
				and	c.nr_prescricao = a.nr_prescricao
				and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')))
		and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		group by
			a.nr_prescricao,
			x.nr_sequencia,
			x.cd_procedimento,
			z.ds_valor_dominio,
			x.ie_acm,
			x.ie_se_necessario,
			x.cd_intervalo,
			x.qt_procedimento,
			x.ie_suspenso,
			x.nr_seq_proc_interno,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			x.nr_seq_prot_glic
		) alias41
	group by
		nr_prescricao,
		nr_seq_procedimento,
		cd_procedimento,
		ds_procedimento,
		ie_acm_sn,
		cd_intervalo,
		qt_procedimento,
		ds_prescricao,
		CASE WHEN ie_suspenso='S' THEN ie_suspenso  ELSE null END ,
		nr_seq_proc_interno,
		ie_lib_pend_rep,
		ds_intervalo,
		ie_permite_acao,
		nr_seq_prot_glic;

	
BEGIN
	dt_fim_w	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_validade_limite_p);
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
			nr_seq_proc_interno_w,
			ds_interv_prescr_w,
			ie_permite_acao_w,
			nr_seq_prot_glic_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	nextval('w_vipe_t_seq')
		into STRICT	nr_seq_wadep_w
		;

		insert into w_vipe_t(
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
			ie_diferenciado,
			ds_interv_prescr,
			ie_permite_acao,
			nr_seq_prot_glic)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'C',
			nr_prescricao_w,
			nr_seq_procedimento_w,
			cd_procedimento_w,
			SUBSTR(ds_procedimento_w, 1, 240),
			ie_acm_sn_w,
			cd_intervalo_w,
			qt_procedimento_w,
			ds_prescricao_w,
			ie_status_w,
			nr_seq_proc_interno_w,
			0,
			'N',
			ds_interv_prescr_w,
			ie_permite_acao_w,
			nr_seq_prot_glic_w);
		end;
	end loop;
	close c01;

	if (ie_lib_pend_rep_p = 'S') then
		begin
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
				nr_seq_proc_interno_w,
				current_setting('vipe_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				ds_interv_prescr_w,
				ie_permite_acao_w,
				nr_seq_prot_glic_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			select	nextval('w_vipe_t_seq')
			into STRICT	nr_seq_wadep_w
			;

			insert into w_vipe_t(
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
				ie_diferenciado,
				ie_pendente_liberacao,
				ds_interv_prescr,
				ie_permite_acao,
				nr_seq_prot_glic)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'C',
				nr_prescricao_w,
				nr_seq_procedimento_w,
				cd_procedimento_w,
				SUBSTR(ds_procedimento_w, 1, 240),
				ie_acm_sn_w,
				cd_intervalo_w,
				qt_procedimento_w,
				ds_prescricao_w,
				ie_status_w,
				nr_seq_proc_interno_w,
				0,
				'N',
				current_setting('vipe_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				ds_interv_prescr_w,
				ie_permite_acao_w,
				nr_seq_prot_glic_w);
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
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.vipe_obter_cig ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;
