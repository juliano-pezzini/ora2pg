-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_obter_horarios_ccg ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

					 
dt_horario_w	timestamp;
					
c01 CURSOR FOR 
SELECT	c.dt_horario 
from	proc_interno w, 
	prescr_procedimento x, 
	prescr_proc_hor c, 
	prescr_medica a 
where	w.nr_sequencia = x.nr_seq_proc_interno 
and	w.nr_sequencia = c.nr_seq_proc_interno 
and	x.nr_prescricao = c.nr_prescricao 
and	x.nr_sequencia = c.nr_seq_procedimento 
and	x.nr_prescricao = a.nr_prescricao 
and	c.nr_prescricao = a.nr_prescricao 
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
and	a.nr_atendimento = nr_atendimento_p 
and	a.dt_validade_prescr > dt_validade_limite_p 
and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '') 
and	w.ie_tipo <> 'G' 
and	w.ie_tipo <> 'BS' 
and	coalesce(w.ie_ivc,'N') <> 'S' 
and	w.ie_ctrl_glic = 'CCG' 
and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') 
and	(x.nr_seq_prot_glic IS NOT NULL AND x.nr_seq_prot_glic::text <> '') 
and	coalesce(x.nr_seq_exame::text, '') = '' 
and	coalesce(x.nr_seq_solic_sangue::text, '') = '' 
and	coalesce(x.nr_seq_derivado::text, '') = '' 
and	coalesce(x.nr_seq_exame_sangue::text, '') = '' 
and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S')) 
and	coalesce(c.ie_situacao,'A') = 'A' 
and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p 
and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) 
and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) 
and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) 
and	((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'CCG', 
																	cd_estabelecimento_p, 
																	cd_setor_usuario_p, 
																	cd_perfil_p, 
																	null, 
																	c.cd_procedimento, 
																	c.ie_origem_proced, 
																	c.nr_seq_proc_interno, 
																	a.cd_setor_Atendimento, 
																	x.cd_setor_Atendimento, 
																	null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																	x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 
group by 
	c.dt_horario;	
	 

BEGIN 
open c01;
loop 
fetch c01 into dt_horario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	insert into w_vipe_horarios_t( 
		nm_usuario, 
		dt_horario) 
	values ( 
		nm_usuario_p, 
		dt_horario_w);
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_obter_horarios_ccg ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

