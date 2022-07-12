-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.vipe_obter_interv ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_so_proc_setor_usuario_p text, ie_so_interv_setor_usuario_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


	nr_seq_wadep_w		bigint;
	nr_seq_pe_prescr_w	bigint;
	nr_seq_pe_proc_w	bigint;
	cd_intervencao_w	varchar(255);
	ds_intervencao_w	varchar(255);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	ds_intervalo_w		varchar(255);
	ie_status_w		varchar(1);
	ds_interv_prescr_w	varchar(15);
	dt_fim_w		timestamp;

	c01 CURSOR FOR
	SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_seq_pe_prescr,nr_seq_pe_proc,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_pe_prescr  ELSE null END   ELSE null END ,
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_seq_pe_prescr,nr_seq_pe_proc,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_pe_proc  ELSE null END   ELSE null END ,
		cd_intervencao,
		ds_intervencao,
		ie_acm_sn,
		cd_intervalo,
		ds_prescricao,
		--decode(ie_acm_sn, 'S', decode(obter_se_agrupar_acm_sn_adep(nr_seq_pe_prescr,nr_seq_pe_proc,ie_agrupar_acm_sn_p), 'N', decode(ie_suspenso, 'S', ie_suspenso, null), null), null) ie_status
		null,
		ds_intervalo
	from	(
		SELECT	a.nr_sequencia nr_seq_pe_prescr,
			c.nr_seq_pe_proc,
			c.nr_seq_proc cd_intervencao,
			substr(y.ds_procedimento,1,240) ds_intervencao,
			obter_se_acm_sn(null,x.ie_se_necessario) ie_acm_sn,
			x.cd_intervalo,
			substr(obter_desc_inf_sae_adep(x.ie_se_necessario,w.ds_prescricao),1,240) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo
		FROM pe_procedimento y, pe_prescr_proc_hor c, pe_prescricao a, pe_prescr_proc x
LEFT OUTER JOIN intervalo_prescricao w ON (x.cd_intervalo = w.cd_intervalo)
WHERE y.nr_sequencia = x.nr_seq_proc and y.nr_sequencia = c.nr_seq_proc and x.nr_seq_prescr = c.nr_seq_pe_prescr and x.nr_sequencia = c.nr_seq_pe_proc and x.nr_seq_prescr = a.nr_sequencia and c.nr_seq_pe_prescr = a.nr_sequencia and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(x.ie_adep,'N') = 'S' and ((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = '')) and obter_se_exibir_interv_adep(ie_so_proc_setor_usuario_p, ie_so_interv_setor_usuario_p, x.nr_seq_proc, cd_perfil_p, cd_setor_usuario_p, nm_usuario_p) = 'S' and coalesce(c.ie_situacao,'A') = 'A' and (((obter_se_acm_sn(null,x.ie_se_necessario) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((obter_se_acm_sn(null,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) and ((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SAE',
																			cd_estabelecimento_p,
																			cd_setor_usuario_p,
																			cd_perfil_p,
																			null,
																			null,
																			null,
																			null,
																			null,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																			null) = 'S')))  -- nr_seq_exame_p
 group by
			a.nr_sequencia,
			c.nr_seq_pe_proc,
			c.nr_seq_proc,
			y.ds_procedimento,
			x.ie_se_necessario,
			x.cd_intervalo,
			w.ds_prescricao,
			x.ie_suspenso
		) alias41
	group by
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_seq_pe_prescr,nr_seq_pe_proc,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_pe_prescr  ELSE null END   ELSE null END ,
		CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_seq_pe_prescr,nr_seq_pe_proc,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_pe_proc  ELSE null END   ELSE null END ,
		cd_intervencao,
		ds_intervencao,
		ie_acm_sn,
		cd_intervalo,
		ds_prescricao,
		--decode(ie_acm_sn, 'S', decode(obter_se_agrupar_acm_sn_adep(nr_seq_pe_prescr,nr_seq_pe_proc,ie_agrupar_acm_sn_p), 'N', decode(ie_suspenso, 'S', ie_suspenso, null), null), null);
		null,
		ds_intervalo;

	c02 CURSOR FOR
	SELECT	nr_seq_pe_prescr,
		nr_seq_pe_proc,
		cd_intervencao,
		ds_intervencao,
		ie_acm_sn,
		cd_intervalo,
		ds_prescricao,
		--ie_suspenso
		null,
		ds_intervalo
	from	(
		SELECT	a.nr_sequencia nr_seq_pe_prescr,
			c.nr_seq_pe_proc,
			c.nr_seq_proc cd_intervencao,
			substr(y.ds_procedimento,1,240) ds_intervencao,
			obter_se_acm_sn(null,x.ie_se_necessario) ie_acm_sn,
			x.cd_intervalo,
			substr(obter_desc_inf_sae_adep(x.ie_se_necessario,w.ds_prescricao),1,240) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo
		FROM pe_procedimento y, pe_prescr_proc_hor c, pe_prescricao a, pe_prescr_proc x
LEFT OUTER JOIN intervalo_prescricao w ON (x.cd_intervalo = w.cd_intervalo)
WHERE y.nr_sequencia = x.nr_seq_proc and y.nr_sequencia = c.nr_seq_proc and x.nr_seq_prescr = c.nr_seq_pe_prescr and x.nr_sequencia = c.nr_seq_pe_proc and x.nr_seq_prescr = a.nr_sequencia and c.nr_seq_pe_prescr = a.nr_sequencia and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(x.ie_adep,'N') = 'M' and ((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = '')) and obter_se_exibir_interv_adep(ie_so_proc_setor_usuario_p, ie_so_interv_setor_usuario_p, x.nr_seq_proc, cd_perfil_p, cd_setor_usuario_p, nm_usuario_p) = 'S' and coalesce(c.ie_situacao,'A') = 'A' and (((obter_se_acm_sn(null,x.ie_se_necessario) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
			 ((obter_se_acm_sn(null,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) and ((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or
			 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SAE',
																			cd_estabelecimento_p,
																			cd_setor_usuario_p,
																			cd_perfil_p,
																			null,
																			null,
																			null,
																			null,
																			null,
																			null,
																			null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																			null) = 'S')))  -- nr_seq_exame_p
 group by
			a.nr_sequencia,
			c.nr_seq_pe_proc,
			c.nr_seq_proc,
			y.ds_procedimento,
			x.ie_se_necessario,
			x.cd_intervalo,
			w.ds_prescricao,
			x.ie_suspenso
		) alias39
	group by
		nr_seq_pe_prescr,
		nr_seq_pe_proc,
		cd_intervencao,
		ds_intervencao,
		ie_acm_sn,
		cd_intervalo,
		ds_prescricao,
		--ie_suspenso;
		null,
		ds_intervalo;

	
BEGIN
	dt_fim_w	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_validade_limite_p);
	open c01;
	loop
	fetch c01 into	nr_seq_pe_prescr_w,
			nr_seq_pe_proc_w,
			cd_intervencao_w,
			ds_intervencao_w,
			ie_acm_sn_w,
			cd_intervalo_w,
			ds_intervalo_w,
			ie_status_w,
			ds_interv_prescr_w;
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
			ds_prescricao,
			ie_status_item,
			nr_agrupamento,
			ie_diferenciado,
			nr_seq_proc_interno,
			ds_interv_prescr)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'E',
			nr_seq_pe_prescr_w,
			nr_seq_pe_proc_w,
			cd_intervencao_w,
			SUBSTR(ds_intervencao_w, 1, 240),
			ie_acm_sn_w,
			cd_intervalo_w,
			ds_intervalo_w,
			ie_status_w,
			0,
			'N',
			0,
			ds_interv_prescr_w);
		end;
	end loop;
	close c01;

	open c02;
	loop
	fetch c02 into	nr_seq_pe_prescr_w,
			nr_seq_pe_proc_w,
			cd_intervencao_w,
			ds_intervencao_w,
			ie_acm_sn_w,
			cd_intervalo_w,
			ds_intervalo_w,
			ie_status_w,
			ds_interv_prescr_w;
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
			ds_prescricao,
			ie_status_item,
			nr_agrupamento,
			ie_diferenciado,
			nr_seq_proc_interno,
			ds_interv_prescr)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'E',
			nr_seq_pe_prescr_w,
			nr_seq_pe_proc_w,
			cd_intervencao_w,
			SUBSTR(ds_intervencao_w, 1, 240),
			ie_acm_sn_w,
			cd_intervalo_w,
			ds_intervalo_w,
			ie_status_w,
			0,
			'N',
			0,
			ds_interv_prescr_w);
		end;
	end loop;
	close c02;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.vipe_obter_interv ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_so_proc_setor_usuario_p text, ie_so_interv_setor_usuario_p text, cd_setor_paciente_p bigint) FROM PUBLIC;