-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_hor_dieta_oral_serv ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint ) AS $body$
DECLARE

	current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp	timestamp;
	ie_gerar_w	varchar(1) := 'S';
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();
	c01 CURSOR FOR	
	SELECT 	x.dt_servico
	from	prescr_dieta d,
		nut_servico b,
		prescr_medica a,
		nut_atend_serv_dia x
	where	d.nr_prescricao	= a.nr_prescricao
	and 	x.nr_atendimento = a.nr_atendimento
	and	x.nr_seq_servico = b.nr_sequencia
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	x.dt_servico between a.dt_inicio_prescr and a.dt_validade_prescr
	and	a.nr_atendimento = nr_atendimento_p
	and	Obter_se_servico_vig_dieta(a.dt_inicio_prescr, a.dt_validade_prescr, a.nr_Atendimento, '1', ie_exibir_hor_realizados_p, ie_exibir_hor_suspensos_p) = 'S'
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	(((coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')) or
		 ((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))
	and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w = 'S'))
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
	and 	((coalesce(b.IE_TIPO_PRESCRICAO_SERVICO::text, '') = '') or (b.IE_TIPO_PRESCRICAO_SERVICO = '1'))
	and	x.dt_servico between dt_inicial_horarios_p and dt_final_horarios_p
	and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(x.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_hor_suspensos_p  = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and x.ie_status_adep = 'Y'
	and	getIe_apresentar_dieta_nao_lib = 'S'
	and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	group by x.dt_servico
	
union

	SELECT 	x.dt_servico
	from	prescr_dieta d,
		nut_servico b,
		nut_atend_serv_dia_rep c,
		prescr_medica a,
		nut_atend_serv_dia x		
	where	d.nr_prescricao	= a.nr_prescricao
	and 	x.nr_atendimento = a.nr_atendimento
	and	x.nr_seq_servico = b.nr_sequencia
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	a.nr_prescricao = c.nr_prescr_oral
	and	c.nr_seq_serv_dia = x.nr_sequencia
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	(((coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')) or
		 ((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))
	and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w = 'S'))
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
	and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(x.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_hor_suspensos_p  = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	x.dt_servico between dt_inicial_horarios_p and dt_final_horarios_p
	and	((coalesce(b.IE_TIPO_PRESCRICAO_SERVICO::text, '') = '') or (b.IE_TIPO_PRESCRICAO_SERVICO = '1'))
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and x.ie_status_adep <> 'Y'
	and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	group by x.dt_servico
	order by 1;
	
BEGIN
	open c01;
	loop
	fetch c01 into current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (getExibeDietaEmJejum = 'N') then
		select	coalesce(max('N'),'S')
		into STRICT	ie_gerar_w
		from	rep_jejum a,
			prescr_medica b where	current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp	between dt_inicio and (dt_fim - 1/1440)
		and	a.nr_prescricao	= b.nr_prescricao
		and	(coalesce(b.dt_liberacao_medico,b.dt_liberacao) IS NOT NULL AND (coalesce(b.dt_liberacao_medico,b.dt_liberacao))::text <> '')
		and	coalesce(b.dt_suspensao::text, '') = ''
		and	coalesce(a.ie_suspenso,'N') <> 'S'
		and	b.nr_atendimento	= nr_atendimento_p LIMIT 1;
	end if;	
	if (ie_gerar_w	= 'S') then
		insert into w_adep_horarios_t(
			nm_usuario,
			dt_horario)
		values (
			nm_usuario_p,
			current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp);
		commit;
	end if;
	end;
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_hor_dieta_oral_serv ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint ) FROM PUBLIC;
