-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_obter_solucao ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_solucoes_continuas_p text, ie_prescr_setor_p text, ie_formato_solucoes_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

 
nr_seq_wadep_w		bigint;
nr_prescricao_w		bigint;
nr_seq_solucao_w	integer;
ds_solucao_w		varchar(255);
ie_acm_sn_w		varchar(1);
ds_prescricao_w		varchar(240);
ds_componentes_w	varchar(240);
ie_status_solucao_w	varchar(15);
ie_suspensa_w		varchar(1);
dt_prev_prox_etapa_w	timestamp;
ie_lib_pend_rep_w	varchar(1);
cd_unid_med_qtde_w	varchar(30);
ie_via_administracao_w	varchar(5);
qt_solucao_total_w	double precision;
ds_intervalo_w		varchar(240);

c01 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_solucao, 
	ds_solucao, 
	ie_acm_sn,	 
	ds_prescricao, 
	ds_componentes, 
	ie_status_solucao, 
	null, 
	dt_prev_prox_etapa, 
	ie_tipo_dosagem, 
	ie_via_aplicacao, 
	qt_solucao_total, 
	ds_intervalo 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_seq_solucao, 
		substr(coalesce(x.ds_solucao,obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)),1,240) ds_solucao, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn, 
		substr(obter_desc_vol_etapa_adep2(a.nr_prescricao,x.nr_seq_solucao,x.ie_acm,x.ie_se_necessario),1,240) ds_prescricao, 
		substr(obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p),1,240) ds_componentes, 
		substr(obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		x.dt_prev_prox_etapa, 
		x.ie_tipo_dosagem, 
		x.ie_via_aplicacao, 
		x.qt_solucao_total, 
		substr(obter_interv_solucao_vipe(x.ie_acm,x.ie_se_necessario,x.ie_urgencia,x.nr_etapas,x.qt_hora_fase) || CASE WHEN coalesce(x.ie_classif_agora::text, '') = '' THEN ''  ELSE ' - ' END  || obter_desc_intervalo(x.ie_classif_agora),1,240) ds_intervalo 
	from	prescr_solucao x, 
		prescr_medica a 
	where	x.nr_prescricao = a.nr_prescricao 
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
	and	a.nr_atendimento = nr_atendimento_p 
	and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S' 
	and	coalesce(x.nr_seq_dialise::text, '') = '' 
	and	((x.ie_status in ('I','INT')) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (x.dt_status between dt_inicial_horarios_p and dt_final_horarios_p)) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) 
	and	((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) 
	/*and	exists (select	1 
			from	prescr_mat_hor z 
			where	z.nr_prescricao = x.nr_prescricao 
			and	z.nr_seq_solucao = x.nr_seq_solucao 
			and	z.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p 
			)*/
 
	and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' 
	and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	((ie_solucoes_continuas_p = 'S') or (obter_se_sol_continua(a.nr_prescricao,x.nr_seq_solucao,x.ds_solucao) = 'N')) 
	and	((ie_regra_inclusao_p = 'S') or 
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SOL', 
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
																		null) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_seq_solucao, 
		x.ds_solucao, 
		x.ie_acm, 
		x.ie_se_necessario, 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		obter_desc_intervalo(x.ie_classif_agora), 
		x.ie_suspenso, 
		x.dt_prev_prox_etapa, 
		x.ie_tipo_dosagem, 
		x.ie_via_aplicacao, 
		x.qt_solucao_total, 
		CASE WHEN coalesce(x.ie_classif_agora::text, '') = '' THEN ''  ELSE ' - ' END , 
		x.ie_urgencia, 
		x.nr_etapas, 
		x.qt_hora_fase 
	) alias58 
group by 
	nr_prescricao, 
	nr_seq_solucao, 
	ds_solucao, 
	ie_acm_sn,	 
	ds_prescricao, 
	ds_componentes, 
	ie_status_solucao, 
	null, 
	dt_prev_prox_etapa, 
	ie_tipo_dosagem, 
	ie_via_aplicacao, 
	qt_solucao_total, 
	ds_intervalo;
	
c02 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_solucao, 
	ds_solucao, 
	ie_acm_sn,	 
	ds_prescricao, 
	ds_componentes, 
	ie_status_solucao, 
	null, 
	dt_prev_prox_etapa, 
	ie_lib_pend_rep, 
	ie_tipo_dosagem, 
	ie_via_aplicacao, 
	qt_solucao_total, 
	ds_intervalo 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_seq_solucao, 
		substr(coalesce(x.ds_solucao,obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)),1,240) ds_solucao, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn, 
		substr(obter_desc_vol_etapa_adep2(a.nr_prescricao,x.nr_seq_solucao,x.ie_acm,x.ie_se_necessario),1,240) ds_prescricao, 
		substr(obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p),1,240) ds_componentes, 
		substr(obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		x.dt_prev_prox_etapa, 
		substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep, 
		x.ie_tipo_dosagem, 
		x.ie_via_aplicacao, 
		x.qt_solucao_total, 
		substr(obter_interv_solucao_vipe(x.ie_acm,x.ie_se_necessario,x.ie_urgencia,x.nr_etapas,x.qt_hora_fase) || CASE WHEN coalesce(x.ie_classif_agora::text, '') = '' THEN ''  ELSE ' - ' END  || obter_desc_intervalo(x.ie_classif_agora),1,240) ds_intervalo 
	from	prescr_solucao x, 
		prescr_medica a 
	where	x.nr_prescricao = a.nr_prescricao 
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
	and	a.nr_atendimento = nr_atendimento_p 
	--and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S' 
	and	((coalesce(a.dt_liberacao::text, '') = '') or (coalesce(a.dt_liberacao_farmacia::text, '') = '')) 
	and	coalesce(x.nr_seq_dialise::text, '') = '' 
	and	coalesce(x.dt_status::text, '') = '' 
	and	coalesce(x.ie_status::text, '') = '' 
	and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' 
	and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	((ie_solucoes_continuas_p = 'S') or (obter_se_sol_continua(a.nr_prescricao,x.nr_seq_solucao,x.ds_solucao) = 'N')) 
	and	((ie_regra_inclusao_p = 'S') or 
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SOL', 
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
																		null) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_seq_solucao, 
		x.ds_solucao, 
		x.ie_acm, 
		x.ie_se_necessario, 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		x.ie_suspenso, 
		obter_desc_intervalo(x.ie_classif_agora), 
		x.dt_prev_prox_etapa, 
		CASE WHEN coalesce(x.ie_classif_agora::text, '') = '' THEN ''  ELSE ' - ' END , 
		a.dt_liberacao_medico, 
		a.dt_liberacao, 
		a.dt_liberacao_farmacia, 
		x.ie_tipo_dosagem, 
		x.ie_via_aplicacao, 
		x.qt_solucao_total, 
		x.ie_urgencia, 
		x.nr_etapas, 
		x.qt_hora_fase 
	) alias51 
group by 
	nr_prescricao, 
	nr_seq_solucao, 
	ds_solucao, 
	ie_acm_sn,	 
	ds_prescricao, 
	ds_componentes, 
	ie_status_solucao, 
	null, 
	dt_prev_prox_etapa, 
	ie_lib_pend_rep, 
	ie_tipo_dosagem, 
	ie_via_aplicacao, 
	qt_solucao_total, 
	ds_intervalo;
	
c03 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_solucao, 
	ds_solucao, 
	ie_acm_sn,	 
	ds_prescricao, 
	ds_componentes, 
	ie_status_solucao, 
	null, 
	dt_prev_prox_etapa, 
	ie_tipo_dosagem, 
	ie_via_aplicacao, 
	qt_solucao_total 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_seq_solucao, 
		substr(coalesce(x.ds_solucao,obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)),1,240) ds_solucao, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn, 
		substr(obter_desc_vol_etapa_adep2(a.nr_prescricao,x.nr_seq_solucao,x.ie_acm,x.ie_se_necessario),1,240) ds_prescricao, 
		substr(obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p),1,240) ds_componentes, 
		substr(obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao),1,3) ie_status_solucao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		x.dt_prev_prox_etapa, 
		x.ie_tipo_dosagem, 
		x.ie_via_aplicacao, 
		x.qt_solucao_total 
	from	prescr_solucao x, 
		prescr_mat_hor c, 
		prescr_medica a 
	where	x.nr_prescricao = c.nr_prescricao 
	and	x.nr_seq_solucao = c.nr_seq_solucao 
	and	x.nr_prescricao = a.nr_prescricao 
	and	c.nr_prescricao = a.nr_prescricao 
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
	and	a.nr_atendimento = nr_atendimento_p 
	--and	a.dt_validade_prescr > dt_validade_limite_p 
	and	obter_se_prescr_lib_vipe(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p,c.dt_lib_horario) = 'S' 
	and	coalesce(x.nr_seq_dialise::text, '') = '' 
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	coalesce(c.ie_situacao,'A') = 'A' 
	and	coalesce(c.ie_adep,'S') = 'S' 
	and	c.ie_agrupador = 4 
	--and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p 
	--and	((ie_agrupar_dose_esp_p = 'S') or (nvl(c.ie_dose_especial,'N') = 'N')) 
	--and	adep_obter_se_gerar_sol_hor(c.dt_horario, c.dt_inicio_horario, c.dt_fim_horario, c.dt_suspensao, dt_inicial_horarios_p, dt_final_horarios_p) = 'S' 
	and	((x.ie_status in ('I','INT')) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (adep_obter_se_gerar_sol_hor(c.dt_horario, c.dt_inicio_horario, c.dt_fim_horario, c.dt_suspensao, dt_inicial_horarios_p, dt_final_horarios_p) = 'S')) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))	 
	--and	((nvl(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario is not null)) 
	and	((ie_exibir_sol_realizadas_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) 
	and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) 
	and	((ie_solucoes_continuas_p = 'S') or (obter_se_sol_continua(a.nr_prescricao,x.nr_seq_solucao,x.ds_solucao) = 'N')) 
	and	((ie_regra_inclusao_p = 'S') or 
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SOL', 
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
																		null) = 'S'))) -- nr_seq_exame_p 
	and	((ie_prescr_setor_p = 'N') or 
		 (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))	 
	and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')) 
	group by 
		a.nr_prescricao, 
		x.nr_seq_solucao, 
		x.ds_solucao, 
		x.ie_acm, 
		x.ie_se_necessario, 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		x.ie_suspenso, 
		x.dt_prev_prox_etapa, 
		x.ie_tipo_dosagem, 
		x.ie_via_aplicacao, 
		x.qt_solucao_total 
	) alias59 
group by 
	nr_prescricao, 
	nr_seq_solucao, 
	ds_solucao, 
	ie_acm_sn,	 
	ds_prescricao, 
	ds_componentes, 
	ie_status_solucao, 
	null, 
	dt_prev_prox_etapa, 
	ie_tipo_dosagem, 
	ie_via_aplicacao, 
	qt_solucao_total;	
 

BEGIN 
--if	(ie_formato_solucoes_p = 'I') then 
--	begin 
	open c01;
	loop 
	fetch c01 into	nr_prescricao_w, 
			nr_seq_solucao_w, 
			ds_solucao_w, 
			ie_acm_sn_w,		 
			ds_prescricao_w, 
			ds_componentes_w, 
			ie_status_solucao_w, 
			ie_suspensa_w, 
			dt_prev_prox_etapa_w, 
			cd_unid_med_qtde_w, 
			ie_via_administracao_w, 
			qt_solucao_total_w, 
			ds_intervalo_w;
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
			ds_item, 
			ie_acm_sn, 
			ds_prescricao, 
			ds_diluicao, 
			ie_status_item, 
			ie_suspenso, 
			dt_prev_term, 
			nr_seq_proc_interno, 
			nr_agrupamento, 
			ie_diferenciado, 
			nr_prescricoes, 
			cd_item, 
			cd_unid_med_qtde, 
			ie_via_aplicacao, 
			qt_item, 
			ds_interv_prescr) 
			values ( 
			nr_seq_wadep_w, 
			nm_usuario_p, 
			'SOL', 
			nr_prescricao_w, 
			nr_seq_solucao_w, 
			ds_solucao_w, 
			ie_acm_sn_w, 
			ds_prescricao_w, 
			ds_componentes_w, 
			ie_status_solucao_w, 
			ie_suspensa_w, 
			dt_prev_prox_etapa_w, 
			0, 
			0, 
			'N', 
			nr_prescricao_w, 
			0, 
			cd_unid_med_qtde_w, 
			ie_via_administracao_w, 
			qt_solucao_total_w, 
			ds_intervalo_w);
		end;
	end loop;
	close c01;
 
	if (ie_lib_pend_rep_p = 'S') then 
		begin 
		open c02;
		loop 
		fetch c02 into	nr_prescricao_w, 
				nr_seq_solucao_w, 
				ds_solucao_w, 
				ie_acm_sn_w,		 
				ds_prescricao_w, 
				ds_componentes_w, 
				ie_status_solucao_w, 
				ie_suspensa_w, 
				dt_prev_prox_etapa_w, 
				ie_lib_pend_rep_w, 
				cd_unid_med_qtde_w, 
				ie_via_administracao_w, 
				qt_solucao_total_w, 
				ds_intervalo_w;
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
				ds_item, 
				ie_acm_sn, 
				ds_prescricao, 
				ds_diluicao, 
				ie_status_item, 
				ie_suspenso, 
				dt_prev_term, 
				nr_seq_proc_interno, 
				nr_agrupamento, 
				ie_diferenciado, 
				nr_prescricoes, 
				ie_pendente_liberacao, 
				cd_item, 
				cd_unid_med_qtde, 
				ie_via_aplicacao, 
				qt_item, 
				ds_interv_prescr) 
			values ( 
				nr_seq_wadep_w, 
				nm_usuario_p, 
				'SOL', 
				nr_prescricao_w, 
				nr_seq_solucao_w, 
				ds_solucao_w, 
				ie_acm_sn_w, 
				ds_prescricao_w, 
				ds_componentes_w, 
				ie_status_solucao_w, 
				ie_suspensa_w, 
				dt_prev_prox_etapa_w, 
				0, 
				0, 
				'N', 
				nr_prescricao_w, 
				ie_lib_pend_rep_w, 
				0, 
				cd_unid_med_qtde_w, 
				ie_via_administracao_w, 
				qt_solucao_total_w, 
				ds_intervalo_w);
			end;
		end loop;
		close c02;	
		end;
	end if;
/*	end; 
elsif	(ie_formato_solucoes_p = 'H') then 
	begin 
	open c03; 
	loop 
	fetch c03 into	nr_prescricao_w, 
			nr_seq_solucao_w, 
			ds_solucao_w, 
			ie_acm_sn_w,		 
			ds_prescricao_w, 
			ds_componentes_w, 
			ie_status_solucao_w, 
			ie_suspensa_w, 
			dt_prev_prox_etapa_w, 
			cd_unid_med_qtde_w, 
			ie_via_administracao_w, 
			qt_solucao_total_w; 
	exit when c03%notfound; 
		begin 
		select	w_vipe_t_seq.nextval 
		into	nr_seq_wadep_w 
		from	dual; 
		 
		insert into w_vipe_t ( 
			nr_sequencia, 
			nm_usuario, 
			ie_tipo_item, 
			nr_prescricao, 
			nr_seq_item, 
			ds_item, 
			ie_acm_sn, 
			ds_prescricao, 
			ds_diluicao, 
			ie_status_item, 
			ie_suspenso, 
			dt_prev_term, 
			nr_seq_proc_interno, 
			nr_agrupamento, 
			ie_diferenciado, 
			nr_prescricoes, 
			cd_item, 
			cd_unid_med_qtde, 
			ie_via_aplicacao, 
			qt_item) 
		values ( 
			nr_seq_wadep_w, 
			nm_usuario_p, 
			'SOL', 
			nr_prescricao_w, 
			nr_seq_solucao_w, 
			ds_solucao_w, 
			ie_acm_sn_w, 
			ds_prescricao_w, 
			ds_componentes_w, 
			ie_status_solucao_w, 
			ie_suspensa_w, 
			dt_prev_prox_etapa_w, 
			0, 
			0, 
			'N', 
			nr_prescricao_w, 
			0, 
			cd_unid_med_qtde_w, 
			ie_via_administracao_w, 
			qt_solucao_total_w); 
		end; 
	end loop; 
	close c03;	 
	end; 
end if;*/
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_obter_solucao ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_solucoes_continuas_p text, ie_prescr_setor_p text, ie_formato_solucoes_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

