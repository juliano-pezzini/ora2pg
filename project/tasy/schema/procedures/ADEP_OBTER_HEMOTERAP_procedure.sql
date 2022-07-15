-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_obter_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

 
nr_seq_wadep_w		bigint;
nr_prescricao_w		bigint;
nr_seq_procedimento_w	integer;
cd_procedimento_w	bigint;
ds_procedimento_w	varchar(255);
nr_seq_lab_w		varchar(20);
ie_acm_sn_w		varchar(1);
cd_intervalo_w		varchar(7);
qt_procedimento_w	double precision;
ds_prescricao_w		varchar(100);
ie_status_solucao_w	varchar(3);
ie_status_w		varchar(1);
nr_seq_proc_interno_w	bigint;
ie_classif_adep_w	varchar(15);
ie_lib_pend_rep_w	varchar(1);
ie_horario_w		varchar(1);
					
c01 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_procedimento, 
	cd_procedimento, 
	ds_procedimento, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_procedimento, 
	ds_prescricao, 
	ie_status_solucao, 
	ie_suspenso, 
	nr_seq_proc_interno, 
	ie_classif_adep, 
	nr_seq_lab 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_sequencia nr_seq_procedimento, 
		x.cd_procedimento, 
		z.ds_derivado ds_procedimento, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao, 
		substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		coalesce(x.nr_seq_proc_interno,0) nr_seq_proc_interno, 
		'P' ie_classif_adep, 
		x.nr_seq_lab 
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
	and	((x.ie_status in ('I','INT')) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (x.dt_status between dt_inicial_horarios_p and dt_final_horarios_p)) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))		 
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
																		a.cd_Setor_atendimento, 
																		x.cd_Setor_atendimento, 
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_procedimento, 
		z.ds_derivado, 
		x.ie_acm, 
		x.ie_se_necessario,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		x.ie_suspenso, 
		x.nr_seq_proc_interno, 
		'P', 
		x.nr_seq_lab 
	
union all
 
	select	a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_procedimento, 
		z.ds_derivado ds_procedimento, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao, 
		substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		x.nr_seq_proc_interno, 
		w.ie_classif_adep, 
		x.nr_seq_lab 
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
	and	((x.ie_status in ('I','INT')) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (x.dt_status between dt_inicial_horarios_p and dt_final_horarios_p)) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))		 		 
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
																		a.cd_Setor_atendimento, 
																		x.cd_Setor_atendimento, 
																		null,	-- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_procedimento, 
		z.ds_derivado, 
		x.ie_acm, 
		x.ie_se_necessario,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		x.ie_suspenso, 
		x.nr_seq_proc_interno, 
		w.ie_classif_adep, 
		x.nr_seq_lab 
	) alias94 
group by 
	nr_prescricao, 
	nr_seq_procedimento, 
	cd_procedimento, 
	ds_procedimento, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_procedimento, 
	ds_prescricao, 
	ie_status_solucao, 
	ie_suspenso, 
	nr_seq_proc_interno, 
	ie_classif_adep, 
	nr_seq_lab;
	
c02 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_procedimento, 
	cd_procedimento, 
	ds_procedimento, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_procedimento, 
	ds_prescricao, 
	ie_status_solucao, 
	ie_suspenso, 
	nr_seq_proc_interno, 
	ie_classif_adep, 
	ie_lib_pend_rep, 
	nr_seq_lab, 
	ie_horario 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_sequencia nr_seq_procedimento, 
		x.cd_procedimento, 
		z.ds_derivado ds_procedimento, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao, 
		substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		coalesce(x.nr_seq_proc_interno,0) nr_seq_proc_interno, 
		'P' ie_classif_adep, 
		substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep, 
		x.nr_seq_lab, 
		CASE WHEN coalesce(x.ds_horarios::text, '') = '' THEN  'N'  ELSE 'S' END  ie_horario 
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
	and	coalesce(x.dt_status::text, '') = '' 
	and	coalesce(x.ie_status::text, '') = '' 
	and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' 
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
																		a.cd_Setor_atendimento, 
																		x.cd_Setor_atendimento, 
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_procedimento, 
		z.ds_derivado, 
		x.ie_acm, 
		x.ie_se_necessario,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		x.ie_suspenso, 
		x.nr_seq_proc_interno, 
		'P', 
		a.dt_liberacao_medico, 
		a.dt_liberacao, 
		a.dt_liberacao_farmacia, 
		x.nr_seq_lab, 
		x.ds_horarios 
	
union all
 
	select	a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_procedimento, 
		z.ds_derivado ds_procedimento, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		substr(adep_obter_dados_prescr_proc(a.nr_prescricao,x.nr_sequencia,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao, 
		substr(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		x.nr_seq_proc_interno, 
		w.ie_classif_adep, 
		substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep, 
		x.nr_seq_lab, 
		CASE WHEN coalesce(x.ds_horarios::text, '') = '' THEN  'N'  ELSE 'S' END  ie_horario 
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
	and	w.ie_ivc <> 'S' 
	and	coalesce(w.ie_ctrl_glic,'NC') = 'NC' 
	and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '') 
	and	coalesce(x.nr_seq_prot_glic::text, '') = '' 
	and	coalesce(x.nr_seq_exame::text, '') = '' 
	and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '') 
	and	(x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '') 
	and	coalesce(x.nr_seq_exame_sangue::text, '') = '' 
	and	coalesce(x.dt_status::text, '') = '' 
	and	coalesce(x.ie_status::text, '') = '' 
	and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' 
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
																		a.cd_Setor_atendimento, 
																		x.cd_Setor_atendimento, 
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		x.nr_seq_exame) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_procedimento, 
		z.ds_derivado, 
		x.ie_acm, 
		x.ie_se_necessario,		 
		x.cd_intervalo, 
		x.qt_procedimento, 
		x.ie_suspenso, 
		x.nr_seq_proc_interno, 
		w.ie_classif_adep, 
		a.dt_liberacao_medico, 
		a.dt_liberacao, 
		a.dt_liberacao_farmacia, 
		x.nr_seq_lab, 
		x.ds_horarios 
	) alias75 
group by 
	nr_prescricao, 
	nr_seq_procedimento, 
	cd_procedimento, 
	ds_procedimento, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_procedimento, 
	ds_prescricao, 
	ie_status_solucao, 
	ie_suspenso, 
	nr_seq_proc_interno, 
	ie_classif_adep, 
	ie_lib_pend_rep, 
	nr_seq_lab, 
	ie_horario;


BEGIN 
open c01;
loop 
fetch c01 into	nr_prescricao_w, 
		nr_seq_procedimento_w, 
		cd_procedimento_w, 
		ds_procedimento_w, 
		ie_acm_sn_w,		 
		cd_intervalo_w, 
		qt_procedimento_w, 
		ds_prescricao_w, 
		ie_status_solucao_w, 
		ie_status_w, 
		nr_seq_proc_interno_w, 
		ie_classif_adep_w, 
		nr_seq_lab_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	select	nextval('w_adep_t_seq') 
	into STRICT	nr_seq_wadep_w 
	;
	 
	insert into w_adep_t( 
		nr_sequencia, 
		nm_usuario, 
		ie_tipo_item, 
		nr_prescricao, 
		nr_seq_item,		 
		cd_item, 
		ds_item, 
		ie_acm_sn,		 
		cd_intervalo, 
		qt_item, 
		ds_prescricao, 
		ie_status_item, 
		nr_seq_proc_interno, 
		ie_classif_adep, 
		nr_agrupamento, 
		ie_diferenciado, 
		nr_seq_lab) 
	values ( 
		nr_seq_wadep_w, 
		nm_usuario_p, 
		'HM', 
		nr_prescricao_w, 
		nr_seq_procedimento_w, 
		cd_procedimento_w, 
		ds_procedimento_w, 
		ie_acm_sn_w, 
		cd_intervalo_w, 
		qt_procedimento_w, 
		ds_prescricao_w, 
		ie_status_solucao_w, 
		nr_seq_proc_interno_w, 
		ie_classif_adep_w, 
		0, 
		'N', 
		nr_seq_lab_w);
	end;
end loop;
close c01;
 
if (ie_lib_pend_rep_p = 'S') then 
	begin 
	open c02;
	loop 
	fetch c02 into	nr_prescricao_w, 
			nr_seq_procedimento_w, 
			cd_procedimento_w, 
			ds_procedimento_w, 
			ie_acm_sn_w,		 
			cd_intervalo_w, 
			qt_procedimento_w, 
			ds_prescricao_w, 
			ie_status_solucao_w, 
			ie_status_w, 
			nr_seq_proc_interno_w, 
			ie_classif_adep_w, 
			ie_lib_pend_rep_w, 
			nr_seq_lab_w, 
			ie_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		select	nextval('w_adep_t_seq') 
		into STRICT	nr_seq_wadep_w 
		;
		 
		insert into w_adep_t( 
			nr_sequencia, 
			nm_usuario, 
			ie_tipo_item, 
			nr_prescricao, 
			nr_seq_item,		 
			cd_item, 
			ds_item, 
			ie_acm_sn,		 
			cd_intervalo, 
			qt_item, 
			ds_prescricao, 
			ie_status_item, 
			nr_seq_proc_interno, 
			ie_classif_adep, 
			nr_agrupamento, 
			ie_diferenciado, 
			ie_pendente_liberacao, 
			nr_seq_lab, 
			ie_horario) 
		values ( 
			nr_seq_wadep_w, 
			nm_usuario_p, 
			'HM', 
			nr_prescricao_w, 
			nr_seq_procedimento_w, 
			cd_procedimento_w, 
			ds_procedimento_w, 
			ie_acm_sn_w, 
			cd_intervalo_w, 
			qt_procedimento_w, 
			ds_prescricao_w, 
			ie_status_solucao_w, 
			nr_seq_proc_interno_w, 
			ie_classif_adep_w, 
			0, 
			'N', 
			ie_lib_pend_rep_w, 
			nr_seq_lab_w, 
			ie_horario_w);
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
-- REVOKE ALL ON PROCEDURE adep_obter_hemoterap ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

