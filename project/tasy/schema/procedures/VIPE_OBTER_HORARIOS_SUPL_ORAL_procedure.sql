-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_obter_horarios_supl_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

					 
dt_horario_w	timestamp;
					
c01 CURSOR FOR 
SELECT	c.dt_horario 
from	prescr_material x, 
	prescr_mat_hor c, 
	prescr_medica a 
where	x.nr_prescricao		= c.nr_prescricao 
and	x.nr_sequencia		= c.nr_seq_material 
and	x.nr_prescricao		= a.nr_prescricao 
and	c.nr_prescricao 	= a.nr_prescricao 
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
and	a.nr_atendimento	= nr_atendimento_p 
and	a.dt_validade_prescr	> dt_validade_limite_p 
and	((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S') or 
	((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S'))) 
and	x.ie_agrupador		= 12 
and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	coalesce(c.ie_situacao,'A')	= 'A' 
and	c.ie_agrupador		= 12 
and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p 
and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) 
and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) 
and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) 
and	((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SO', 
																	cd_estabelecimento_p, 
																	cd_setor_usuario_p, 
																	cd_perfil_p, 
																	c.cd_material, 
																	null, 
																	null, 
																	null, 
																	a.cd_setor_Atendimento, 
																	null, 
																	null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																	null) = 'S'))) -- nr_seq_exame_p 
and	((ie_prescr_setor_p = 'N') or ((ie_prescr_setor_p = 'S') and (a.cd_setor_atendimento = Obter_Unidade_Atendimento(nr_atendimento_p, 'IA', 'CS')))) 
and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')) 
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
-- REVOKE ALL ON PROCEDURE vipe_obter_horarios_supl_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

