-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_horarios_leite ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

	dt_horario_w	timestamp;
	ie_utiliza_serv_w varchar(1) := adep_gerar_horarios_pck.get_usa_servico_dietas();
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();	
	c01 CURSOR FOR
	SELECT	c.dt_horario
	from	prescr_leite_deriv b,
		prescr_material x,
		prescr_mat_hor c,
		prescr_medica a
	where	x.nr_prescricao		= c.nr_prescricao
	and	x.nr_sequencia		= c.nr_seq_material
	and	x.nr_prescricao		= a.nr_prescricao
	and	c.nr_prescricao 	= a.nr_prescricao
	and	x.nr_seq_leite_deriv	= b.nr_sequencia
	and	x.nr_prescricao		= b.nr_prescricao
	and	a.nr_atendimento	= nr_atendimento_p
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'	
	and	a.dt_validade_prescr	between dt_validade_limite_p and dt_fim_w
	and	((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S') or
		 ((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))	
	and	x.ie_agrupador		= 16
	and	coalesce(c.ie_situacao,'A')	= 'A'
	and	c.ie_agrupador		= 16
	and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w = 'S'))
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))	
	and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
	and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
	and	coalesce(a.ie_adep,'S') = 'S'
	and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))	
	and	((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'LD',
																		cd_estabelecimento_p, 
																		cd_setor_usuario_p, 
																		cd_perfil_p, 
																		c.cd_material, 
																		null, 
																		null, 
																		null, 
																		a.cd_setor_Atendimento,
																		null,
																		a.nr_prescricao,
																		null) = 'S'))) -- nr_seq_exame_p
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	group by
		c.dt_horario;		
	tb_datas_w	dbms_sql.date_table;
	
BEGIN
	open c01;
	loop
	fetch C01 bulk collect into tb_datas_w
	limit 100;
	exit when tb_datas_w.count = 0;
		begin
		forall i in tb_datas_w.first..tb_datas_w.last
			insert into w_adep_horarios_t(	nm_usuario,
											dt_horario)
										values (
											nm_usuario_p,
											tb_datas_w(i));
			commit;
		end;
	end loop;
	close c01;
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_horarios_leite ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;
