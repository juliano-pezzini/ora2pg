-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_sincronizar_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE
				
				 
ds_sep_bv_w		varchar(50);				
nr_prescricao_w		bigint;
nr_seq_procedimento_w	integer;
nr_seq_horario_w	bigint;
ie_status_horario_w	varchar(15);
cd_procedimento_w	bigint;
ds_procedimento_w	varchar(255);
nr_seq_proc_interno_w	bigint;
ie_acm_sn_w		varchar(1);
cd_intervalo_w		varchar(7);
qt_procedimento_w	double precision;
ds_prescricao_w		varchar(100);
ds_mat_med_assoc_w	varchar(2000);
ie_suspenso_w		varchar(1);
dt_suspensao_w		timestamp;
ds_comando_update_w	varchar(4000);

c01 CURSOR FOR	 
SELECT	a.nr_prescricao, 
	x.nr_sequencia, 
	'N' 
from	san_derivado z, 
	procedimento y, 
	prescr_procedimento x, 
	prescr_medica a 
where	z.nr_sequencia = x.nr_seq_derivado 
and	y.cd_procedimento = x.cd_procedimento 
and	y.ie_origem_proced = x.ie_origem_proced 
and	x.nr_prescricao = a.nr_prescricao 
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
and	a.nr_atendimento = nr_atendimento_p 
and	a.dt_validade_prescr > dt_validade_limite_p 
and	coalesce(x.nr_seq_proc_interno::text, '') = '' 
and	coalesce(x.nr_seq_exame::text, '') = '' 
and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') 
and	(x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') 
and	coalesce(x.nr_seq_exame_sangue::text, '') = '' 
and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	x.ie_status = 'N' 
and	((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) 
and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'HM', 
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
																	x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
and	x.dt_status = dt_horario_p 
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
group by 
	a.nr_prescricao, 
	x.nr_sequencia, 
	'N' 

union all
 
SELECT	a.nr_prescricao, 
	x.nr_sequencia, 
	'N' 
from	san_derivado z, 
	procedimento y, 
	proc_interno w, 
	prescr_procedimento x, 
	prescr_medica a 
where	z.nr_sequencia = x.nr_seq_derivado 
and	y.cd_procedimento = x.cd_procedimento 
and	y.ie_origem_proced = x.ie_origem_proced 
and	w.nr_sequencia = x.nr_seq_proc_interno 
and	x.nr_prescricao = a.nr_prescricao 
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
and	a.nr_atendimento = nr_atendimento_p 
and	a.dt_validade_prescr > dt_validade_limite_p 
and	w.ie_tipo <> 'G' 
and	w.ie_tipo <> 'BS' 
and	coalesce(w.ie_ivc,'N') <> 'S' 
and	coalesce(w.ie_ctrl_glic,'NC') = 'NC' 
and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') 
and	coalesce(x.nr_seq_prot_glic::text, '') = '' 
and	coalesce(x.nr_seq_exame::text, '') = '' 
and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') 
and	(x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') 
and	coalesce(x.nr_seq_exame_sangue::text, '') = '' 
and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	x.ie_status = 'N' 
and	((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) 
and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
and	((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'HM', 
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
																	x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
and	x.dt_status = dt_horario_p 
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))	 
group by 
	a.nr_prescricao, 
	x.nr_sequencia, 
	'N';
	

BEGIN 
ds_sep_bv_w := obter_separador_bv;
open c01;
loop 
fetch c01 into	nr_prescricao_w, 
		nr_seq_procedimento_w, 
		ie_status_horario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_comando_update_w	:=	' update w_adep_t ' || 
					' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' || 
					' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' || 
					' where nm_usuario = :nm_usuario ' || 
					' and ie_tipo_item = :ie_tipo ' || 
					' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' || 
					' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';
				 
	CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w || 
								'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w || 
								'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
								'ie_tipo=HM' || ds_sep_bv_w || 
								'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_sincronizar_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

