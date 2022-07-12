-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_horarios_npt_adulta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text, ie_html_p text) AS $body$
DECLARE

	dt_horario_w	timestamp;
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();	
	c01 CURSOR FOR
		SELECT	b.dt_horario
		from	nut_paciente_hor b,
				nut_pac x,
				prescr_medica a	
		where	x.nr_prescricao = a.nr_prescricao
		and		b.nr_seq_nut_protocolo	= x.nr_sequencia
		and		obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
		and		a.nr_atendimento = nr_atendimento_p
		and		a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
		and		((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S') or
				 ((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.ie_prescr_nutricao, 'N') = 'S')))
		and		b.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p		
		and		coalesce(x.dt_suspensao::text, '') = ''
		and		((a.dt_liberacao_farmacia IS NOT NULL AND a.dt_liberacao_farmacia::text <> '') or (Get_NPTAntesFarmacia = 'N'))
		and		((coalesce(b.ie_horario_especial,'N') = 'N') or (b.dt_fim_horario IS NOT NULL AND b.dt_fim_horario::text <> ''))
		and		((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w		= 'S'))			
		and		((ie_regra_inclusao_p = 'S') or
				 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'NAN',
												cd_estabelecimento_p, 
												cd_setor_usuario_p,
												cd_perfil_p, 
												null, 
												null, 
												null, 
												null,
												a.cd_Setor_atendimento,
												null,
												null,			-- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
												null) = 'S'))) -- nr_seq_exame_p
		and		((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
		and		((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
		and		coalesce(ie_npt_adulta, 'S') = 'S'				
		and     ((x.ie_status = 'N') or (ie_html_p = 'S'))
		group by
			b.dt_horario;
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
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_horarios_npt_adulta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text, ie_html_p text) FROM PUBLIC;
