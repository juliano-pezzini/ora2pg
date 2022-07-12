-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_horarios_proced_ass ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text ) AS $body$
DECLARE

	dt_horario_w	timestamp;
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();	
	c01 CURSOR FOR
	SELECT	c.dt_horario
	from	prescr_medica a,
			prescr_procedimento p,
			prescr_material x,
			prescr_mat_hor c,
			material k
	where	a.nr_prescricao = p.nr_prescricao
	and		a.nr_prescricao = x.nr_prescricao
	and		a.nr_prescricao = c.nr_prescricao
	and		p.nr_prescricao = x.nr_prescricao
	and		p.nr_sequencia	= x.nr_sequencia_proc
	and		x.nr_prescricao = c.nr_prescricao
	and		x.nr_sequencia	= c.nr_seq_material
	and		k.cd_material = c.cd_material
	and		k.cd_material = x.cd_material
	and		obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and		a.nr_atendimento = nr_atendimento_p
	and		a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and		(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
	and		coalesce(p.nr_seq_proc_interno::text, '') = ''
	and		coalesce(p.nr_seq_exame::text, '') = ''
	and		coalesce(p.nr_seq_solic_sangue::text, '') = ''
	and		coalesce(p.nr_seq_derivado::text, '') = ''
	and 	coalesce(p.nr_Seq_origem::text, '') = ''
	and 	ie_palm_p = 'S'
	and		get_ie_exibe_mat_assoc_proced in ('S','X')
	and		k.ie_tipo_material	in (0,2,3,6,8,9)
	and		coalesce(p.ie_administrar,'S') = 'S'		
	and		coalesce(p.nr_seq_exame_sangue::text, '') = ''
	and		((ie_exibir_suspensos_p = 'S') or ((coalesce(x.dt_suspensao::text, '') = '') and (coalesce(p.dt_suspensao::text, '') = '')))	
	and		coalesce(c.ie_situacao,'A') = 'A'
	and		c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p	
	and		((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
	and		((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and		((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))	
	and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and		((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	group by
			c.dt_horario
	
union all

	SELECT	c.dt_horario
	from	proc_interno w,
			prescr_procedimento p,
			prescr_material x,
			prescr_mat_hor c,
			prescr_medica a,
			material k
	where	w.nr_sequencia = p.nr_seq_proc_interno
	and		a.nr_prescricao = p.nr_prescricao
	and		a.nr_prescricao = x.nr_prescricao
	and		a.nr_prescricao = c.nr_prescricao
	and		p.nr_prescricao = x.nr_prescricao
	and		p.nr_sequencia = x.nr_sequencia_proc
	and		x.nr_prescricao = c.nr_prescricao
	and		x.nr_sequencia	= c.nr_seq_material
	and		k.cd_material = c.cd_material
	and		k.cd_material = x.cd_material
	and		obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and		a.nr_atendimento = nr_atendimento_p
	and		a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and		(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
	and		(p.nr_seq_proc_interno IS NOT NULL AND p.nr_seq_proc_interno::text <> '')
	and		coalesce(p.nr_seq_prot_glic::text, '') = ''
	and		coalesce(p.nr_seq_exame::text, '') = ''
	and		coalesce(p.nr_seq_solic_sangue::text, '') = ''
	and		coalesce(p.nr_seq_derivado::text, '') = ''
	and 	ie_palm_p = 'S'
	and		get_ie_exibe_mat_assoc_proced in ('S','X')
	and		k.ie_tipo_material	in (0,2,3,6,8,9)
	and 	coalesce(p.nr_Seq_origem::text, '') = ''
	and		coalesce(p.ie_administrar,'S') = 'S'
	and		coalesce(p.nr_seq_exame_sangue::text, '') = ''		
	and		((ie_exibir_suspensos_p = 'S') or (coalesce(p.dt_suspensao::text, '') = ''))	
	and		coalesce(c.ie_situacao,'A') = 'A'	
	and		c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
	and		((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
	and		((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and		((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))	
	and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'	
	and		((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))	
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
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_horarios_proced_ass ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text ) FROM PUBLIC;
