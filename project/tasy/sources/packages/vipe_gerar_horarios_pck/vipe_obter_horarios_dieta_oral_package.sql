-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.vipe_obter_horarios_dieta_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


	current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp	timestamp;
	dt_fim_w	timestamp;
	cd_setor_atendimento_w	bigint;

	c01 CURSOR FOR
	SELECT	c.dt_horario
	from	prescr_dieta x,
		prescr_dieta_hor c,
		prescr_medica a
	where	x.nr_prescricao = c.nr_prescricao
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S'
	and	((obter_se_prescr_lib_vipe(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p,c.dt_lib_horario) = 'S') or
		((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = ''))
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
	and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_atendimento_w))
	and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'))
	group by
		c.dt_horario;

	
BEGIN
	dt_fim_w	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_validade_limite_p);
	cd_setor_atendimento_w	:= vipe_gerar_horarios_pck.obter_setor_atend(nr_atendimento_p);
	open c01;
	loop
	fetch c01 into current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into w_vipe_horarios_t(
			nm_usuario,
			dt_horario)
		values (
			nm_usuario_p,
			current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp);
		end;
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.vipe_obter_horarios_dieta_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;
