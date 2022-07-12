-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.vipe_obter_jejum ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


	nr_seq_wadep_w	bigint;
	nr_prescricao_w	bigint;
	cd_jejum_w	varchar(255);
	ds_jejum_w	varchar(255);
	ds_vigencia_w	varchar(255);
	dt_fim_w		timestamp;
	ie_permite_acao_w	varchar(1);

	c01 CURSOR FOR
	SELECT	to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || '-' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss') cd_jejum,
		x.ds_tipo ds_jejum,
		'Vigência: ' || to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || ' à ' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss') ds_vigencia,
		obter_se_habilita_opcao('J',cd_perfil_p) ie_permite_acao
	from	rep_tipo_jejum x,
		rep_jejum c,
		prescr_medica a
	where	x.nr_sequencia = c.nr_seq_tipo
	and	c.nr_prescricao = a.nr_prescricao
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S'
	and	((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S') or
		((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))
	and	(((c.dt_inicio between dt_inicial_horarios_p and dt_final_horarios_p) or
		 ((get_ie_considera_horario = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))))
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = ''))
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	group by
		c.dt_inicio,
		c.dt_fim,
		x.ds_tipo;

	
BEGIN
	dt_fim_w	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_validade_limite_p);
	open c01;
	loop
	fetch c01 into	cd_jejum_w,
			ds_jejum_w,
			ds_vigencia_w,
			ie_permite_acao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	nextval('w_vipe_t_seq')
		into STRICT	nr_seq_wadep_w
		;

		insert into w_vipe_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			cd_item,
			ds_item,
			ds_prescricao,
			nr_agrupamento,
			nr_seq_proc_interno,
			ie_acm_sn,
			ie_permite_acao)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'J',
			cd_jejum_w,
			SUBSTR(ds_jejum_w, 1, 240),
			ds_vigencia_w,
			0,
			0,
			'N',
			ie_permite_acao_w);
		end;
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.vipe_obter_jejum ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;
