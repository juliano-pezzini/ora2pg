-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_obter_npt_adulta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

 
nr_seq_wadep_w		bigint;
nr_prescricao_w		bigint;
nr_seq_npt_w		bigint;
ds_npt_w		varchar(255);
ie_status_solucao_w	varchar(3);
ie_lib_pend_rep_w	varchar(1);
					
c01 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_npt, 
	ds_npt, 
	ie_status_solucao 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_sequencia nr_seq_npt, 
		CASE WHEN x.ie_forma='P' THEN  'Protocolo ' || y.ds_npt  ELSE obter_valor_dominio(1988,x.ie_forma) END  ds_npt, 
		substr(obter_status_solucao_prescr(6,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao 
	FROM prescr_medica a, nut_pac x
LEFT OUTER JOIN protocolo_npt y ON (x.nr_seq_protocolo = y.nr_sequencia)
WHERE x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr > dt_validade_limite_p and obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S' and x.ie_npt_adulta = 'S' and ((x.ie_status in ('I','INT')) or 
		 ((obter_se_acm_sn(null,null) = 'N') and (x.dt_status between dt_inicial_horarios_p and dt_final_horarios_p)) or 
		 ((obter_se_acm_sn(null,null) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or 
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'NAN', 
																		cd_estabelecimento_p, 
																		cd_setor_usuario_p, 
																		cd_perfil_p, 
																		null, 
																		null, 
																		null, 
																		null, 
																		a.cd_setor_Atendimento, 
																		null, 
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		null) = 'S')))  -- nr_seq_exame_p 
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.ie_forma, 
		y.ds_npt 
	) alias38 
group by 
	nr_prescricao, 
	nr_seq_npt, 
	ds_npt, 
	ie_status_solucao;
	
c02 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_npt, 
	ds_npt, 
	ie_status_solucao, 
	ie_lib_pend_rep 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_sequencia nr_seq_npt, 
		CASE WHEN x.ie_forma='P' THEN  'Protocolo ' || y.ds_npt  ELSE obter_valor_dominio(1988,x.ie_forma) END  ds_npt, 
		substr(obter_status_solucao_prescr(6,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao, 
		substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep 
	FROM prescr_medica a, nut_pac x
LEFT OUTER JOIN protocolo_npt y ON (x.nr_seq_protocolo = y.nr_sequencia)
WHERE x.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr > dt_validade_limite_p and obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S' and x.ie_npt_adulta = 'S' and coalesce(x.dt_status::text, '') = '' and coalesce(x.ie_status::text, '') = '' and obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or 
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'NAN', 
																		cd_estabelecimento_p, 
																		cd_setor_usuario_p, 
																		cd_perfil_p, 
																		null, 
																		null, 
																		null, 
																		null, 
																		a.cd_setor_Atendimento, 
																		null, 
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		null) = 'S')))  -- nr_seq_exame_p 
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.ie_forma, 
		y.ds_npt, 
		a.dt_liberacao_medico, 
		a.dt_liberacao, 
		a.dt_liberacao_farmacia 
	) alias28 
group by 
	nr_prescricao, 
	nr_seq_npt, 
	ds_npt, 
	ie_status_solucao, 
	ie_lib_pend_rep;	
 

BEGIN 
open c01;
loop 
fetch c01 into	nr_prescricao_w, 
		nr_seq_npt_w, 
		ds_npt_w, 
		ie_status_solucao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	select	nextval('w_vipe_t_seq') 
	into STRICT	nr_seq_wadep_w 
	;
	 
	insert into w_vipe_t( 
		nr_sequencia, 
		nm_usuario, 
		ie_tipo_item, 
		nr_prescricao, 
		nr_seq_item,		 
		cd_item, 
		ds_item, 
		ie_acm_sn, 
		ie_diferenciado, 
		nr_agrupamento, 
		nr_seq_proc_interno, 
		ie_status_item) 
	values ( 
		nr_seq_wadep_w, 
		nm_usuario_p, 
		'NAN', 
		nr_prescricao_w, 
		nr_seq_npt_w, 
		nr_seq_npt_w, 
		ds_npt_w, 
		'N', 
		'N', 
		0, 
		0, 
		ie_status_solucao_w);
	end;
end loop;
close c01;
 
if (ie_lib_pend_rep_p = 'S') then 
	begin 
	open c02;
	loop 
	fetch c02 into	nr_prescricao_w, 
			nr_seq_npt_w, 
			ds_npt_w, 
			ie_status_solucao_w, 
			ie_lib_pend_rep_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		select	nextval('w_vipe_t_seq') 
		into STRICT	nr_seq_wadep_w 
		;
		 
		insert into w_vipe_t( 
			nr_sequencia, 
			nm_usuario, 
			ie_tipo_item, 
			nr_prescricao, 
			nr_seq_item,		 
			cd_item, 
			ds_item, 
			ie_acm_sn, 
			ie_diferenciado, 
			nr_agrupamento, 
			nr_seq_proc_interno, 
			ie_status_item, 
			ie_pendente_liberacao) 
		values ( 
			nr_seq_wadep_w, 
			nm_usuario_p, 
			'NAN', 
			nr_prescricao_w, 
			nr_seq_npt_w, 
			nr_seq_npt_w, 
			ds_npt_w, 
			'N', 
			'N', 
			0, 
			0, 
			ie_status_solucao_w, 
			ie_lib_pend_rep_w);
		end;
	end loop;
	close c02;	
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_obter_npt_adulta ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

