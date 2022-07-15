-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_sincronizar_coleta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, ie_aba_p text, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

				 
ds_sep_bv_w		varchar(50);
ie_tipo_w		varchar(1) := 'L';		
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
	c.nr_seq_procedimento, 
	c.nr_sequencia, 
	substr(obter_status_hor_proced(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial),1,15), 
	c.cd_procedimento, 
	substr(adep_obter_desc_exame_lab(x.ie_acm,x.ie_se_necessario,z.nm_exame),1,255) ds_procedimento, 
	c.nr_seq_proc_interno, 
	obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
	x.cd_intervalo, 
	x.qt_procedimento, 
	v.ds_material_exame ds_prescricao, 
	coalesce(x.ie_suspenso,'N') ie_suspenso, 
	c.dt_suspensao dt_suspensao 
FROM exame_laboratorio z, procedimento y, prescr_proc_hor c, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN material_exame_lab v ON (x.cd_material_exame = v.cd_material_exame)
WHERE z.nr_seq_exame = x.nr_seq_exame and y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and y.cd_procedimento = c.cd_procedimento and y.ie_origem_proced = c.ie_origem_proced and x.nr_prescricao = c.nr_prescricao and x.nr_sequencia = c.nr_seq_procedimento and x.nr_prescricao = a.nr_prescricao and c.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr > dt_validade_limite_p and (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '') and coalesce(x.nr_seq_proc_interno::text, '') = '' and (x.nr_seq_exame IS NOT NULL AND x.nr_seq_exame::text <> '') and coalesce(x.nr_seq_solic_sangue::text, '') = '' and coalesce(x.nr_seq_derivado::text, '') = '' and coalesce(x.nr_seq_exame_sangue::text, '') = '' and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S')) and coalesce(c.ie_situacao,'A') = 'A' and ((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) and ((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) and ((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'LAB', 
																	cd_estabelecimento_p, 
																	cd_setor_usuario_p, 
																	cd_perfil_p, 
																	null, 
																	c.cd_procedimento, 
																	c.ie_origem_proced, 
																	c.nr_seq_proc_interno, 
																	a.cd_setor_atendimento, 
																	x.cd_setor_atendimento, 
																	null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																	x.nr_seq_exame) = 'S')))  -- nr_seq_exame 
  and c.dt_horario = dt_horario_p and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' group by 
	a.nr_prescricao, 
	c.nr_seq_procedimento, 
	c.nr_sequencia, 
	c.dt_fim_horario, 
	c.dt_suspensao, 
	c.ie_dose_especial, 
	c.cd_procedimento, 
	x.ie_acm, 
	x.ie_se_necessario,		 
	z.nm_exame, 
	c.nr_seq_proc_interno, 
	x.cd_intervalo, 
	x.qt_procedimento, 
	v.ds_material_exame, 
	x.ie_suspenso 

union all
 
SELECT	a.nr_prescricao, 
	c.nr_seq_procedimento, 
	c.nr_sequencia, 
	substr(obter_status_hor_proced(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial),1,15), 
	c.cd_procedimento, 
	substr(adep_obter_desc_exame_lab(x.ie_acm,x.ie_se_necessario,z.nm_exame),1,255) ds_procedimento, 
	c.nr_seq_proc_interno, 
	obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
	x.cd_intervalo, 
	x.qt_procedimento, 
	v.ds_material_exame ds_prescricao, 
	coalesce(x.ie_suspenso,'N') ie_suspenso, 
	c.dt_suspensao dt_suspensao 
FROM exame_laboratorio z, procedimento y, proc_interno w, prescr_proc_hor c, prescr_medica a, prescr_procedimento x
LEFT OUTER JOIN material_exame_lab v ON (x.cd_material_exame = v.cd_material_exame)
WHERE z.nr_seq_exame = x.nr_seq_exame and y.cd_procedimento = x.cd_procedimento and y.ie_origem_proced = x.ie_origem_proced and y.cd_procedimento = c.cd_procedimento and y.ie_origem_proced = c.ie_origem_proced and w.nr_sequencia = x.nr_seq_proc_interno and w.nr_sequencia = c.nr_seq_proc_interno and x.nr_prescricao = c.nr_prescricao and x.nr_sequencia = c.nr_seq_procedimento and x.nr_prescricao = a.nr_prescricao and c.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr > dt_validade_limite_p and (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '') and w.ie_tipo <> 'G' and w.ie_tipo <> 'BS' and w.ie_ivc <> 'S' and (x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') and coalesce(x.nr_seq_prot_glic::text, '') = '' and (x.nr_seq_exame IS NOT NULL AND x.nr_seq_exame::text <> '') and coalesce(x.nr_seq_solic_sangue::text, '') = '' and coalesce(x.nr_seq_derivado::text, '') = '' and coalesce(x.nr_seq_exame_sangue::text, '') = '' and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S')) and coalesce(c.ie_situacao,'A') = 'A' and ((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) and ((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) and ((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'LAB', 
																	cd_estabelecimento_p, 
																	cd_setor_usuario_p, 
																	cd_perfil_p, 
																	null, 
																	c.cd_procedimento, 
																	c.ie_origem_proced, 
																	c.nr_seq_proc_interno,
																	a.cd_setor_atendimento, 
																	x.cd_setor_atendimento, 
																	null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																	x.nr_seq_exame) = 'S'))) 		 -- nr_seq_exame_p 
  and c.dt_horario = dt_horario_p and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' group by 
	a.nr_prescricao, 
	c.nr_seq_procedimento, 
	c.nr_sequencia, 
	c.dt_fim_horario, 
	c.dt_suspensao, 
	c.ie_dose_especial, 
	c.cd_procedimento, 
	x.ie_acm, 
	x.ie_se_necessario,		 
	z.nm_exame, 
	c.nr_seq_proc_interno, 
	x.cd_intervalo, 
	x.qt_procedimento, 
	v.ds_material_exame, 
	x.ie_suspenso 
order by 
	dt_suspensao;
	

BEGIN 
ds_sep_bv_w	:= obter_separador_bv;
 
if (ie_aba_p = 'L') then 
	begin 
	ie_tipo_w	:= 'P';
	end;
end if;
 
open c01;
loop 
fetch c01 into	nr_prescricao_w, 
		nr_seq_procedimento_w, 
		nr_seq_horario_w, 
		ie_status_horario_w, 
		cd_procedimento_w, 
		ds_procedimento_w, 
		nr_seq_proc_interno_w, 
		ie_acm_sn_w,		 
		cd_intervalo_w, 
		qt_procedimento_w, 
		ds_prescricao_w, 
		ie_suspenso_w, 
		dt_suspensao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_comando_update_w	:=	' update w_adep_t ' || 
					' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' || 
					' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' || 
					' where nm_usuario = :nm_usuario ' || 
					' and ie_tipo_item = :ie_tipo ' || 
					' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' || 
					' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					 
					' and cd_item = :cd_item ' || 
					' and nvl(nr_seq_proc_interno,nvl(:nr_seq_proc_interno,0)) = nvl(:nr_seq_proc_interno,0) ' || 
					' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' || 
					' and nvl(qt_item,0) = nvl(:qt_item,0) ' || 
					' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';
				 
	CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w || 
								'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w || 
								'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
								'ie_tipo=' || ie_tipo_w || ds_sep_bv_w || 
								'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w || 
								'cd_item=' || to_char(cd_procedimento_w) || ds_sep_bv_w || 
								'nr_seq_proc_interno=' || to_char(nr_seq_proc_interno_w) || ds_sep_bv_w || 
								'cd_intervalo=' || cd_intervalo_w || ds_sep_bv_w || 
								'qt_item=' || to_char(qt_procedimento_w) || ds_sep_bv_w || 
								'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w );
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_sincronizar_coleta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, ie_aba_p text, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

