-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_obter_supl_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE

 
nr_seq_wadep_w		bigint;
nr_prescricao_w		bigint;
nr_seq_material_w	integer;
cd_material_w		integer;
ds_material_w		varchar(255);
ie_acm_sn_w		varchar(1);
cd_intervalo_w		varchar(7);
qt_dose_w		double precision;
ds_prescricao_w		varchar(100);
ie_status_w		varchar(1);
ie_lib_pend_rep_w	varchar(1);
cd_unid_med_qtde_w	varchar(30);
ie_via_administracao_w	varchar(5);
ds_interv_prescr_w	varchar(15);
					
c01 CURSOR FOR 
SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END , 
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,	 
	cd_material, 
	ds_material, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_dose, 
	ds_prescricao, 
	--decode(ie_acm_sn, 'S', decode(obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p), 'N', decode(ie_suspenso, 'S', ie_suspenso, null), null), null) ie_status, 
	CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END  ie_status, 
	cd_unidade_medida_dose, 
	ie_via_aplicacao, 
	ds_intervalo 
from	( 
	SELECT	a.nr_prescricao, 
		c.nr_seq_material, 
		c.cd_material, 
		y.ds_material, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
		x.cd_intervalo, 
		x.qt_dose, 
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao, 
		coalesce(x.ie_suspenso,'N') ie_suspenso, 
		x.cd_unidade_medida_dose, 
		x.ie_via_aplicacao, 
		substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo 
	from	material y, 
		prescr_material x, 
		prescr_mat_hor c, 
		prescr_medica a 
	where	y.cd_material = x.cd_material 
	and	y.cd_material = c.cd_material 
	and	x.nr_prescricao = c.nr_prescricao 
	and	x.nr_sequencia = c.nr_seq_material	 
	and	x.nr_prescricao = a.nr_prescricao 
	and	c.nr_prescricao = a.nr_prescricao 
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
	and	a.nr_atendimento = nr_atendimento_p 
	and	a.dt_validade_prescr > dt_validade_limite_p 
	and	((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S') or 
		((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))	 
	and	x.ie_agrupador = 12 
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	(((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or 
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))	 
	and	coalesce(c.ie_situacao,'A') = 'A' 
	and	c.ie_agrupador = 12	 
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
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')) 
	group by 
		a.nr_prescricao, 
		c.nr_seq_material, 
		c.cd_material, 
		y.ds_material, 
		x.ie_acm, 
		x.ie_se_necessario,		 
		x.cd_intervalo, 
		x.qt_dose, 
		x.ie_suspenso, 
		x.cd_unidade_medida_dose, 
		x.ie_via_aplicacao		 
	) alias53 
group by 
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END , 
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,	 
	cd_material, 
	ds_material, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_dose, 
	ds_prescricao, 
	--decode(ie_acm_sn, 'S', decode(obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p), 'N', decode(ie_suspenso, 'S', ie_suspenso, null), null), null), 
	CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END , 
	cd_unidade_medida_dose, 
	ie_via_aplicacao, 
	ds_intervalo;
	
c02 CURSOR FOR 
SELECT	nr_prescricao, 
	nr_seq_material, 
	cd_material, 
	ds_material, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_dose, 
	ds_prescricao, 
	CASE WHEN ie_suspenso='N' THEN null  ELSE ie_suspenso END , 
	ie_lib_pend_rep, 
	cd_unidade_medida_dose, 
	ie_via_aplicacao, 
	ds_intervalo	 
from	( 
	SELECT	a.nr_prescricao, 
		x.nr_sequencia nr_seq_material, 
		x.cd_material, 
		y.ds_material, 
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
		x.cd_intervalo, 
		x.qt_dose, 
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao, 
		x.ie_suspenso, 
		substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep, 
		x.cd_unidade_medida_dose, 
		x.ie_via_aplicacao, 
		substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo		 
	from	material y, 
		prescr_material x, 
		prescr_medica a 
	where	y.cd_material = x.cd_material 
	and	x.nr_prescricao = a.nr_prescricao 
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' 
	and	a.nr_atendimento = nr_atendimento_p 
	and	a.dt_validade_prescr > dt_validade_limite_p 
	--and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'	 
	and	x.ie_agrupador = 12 
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) 
	and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S' 
	and	((ie_regra_inclusao_p = 'S') or 
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SO', 
																		cd_estabelecimento_p, 
																		cd_setor_usuario_p, 
																		cd_perfil_p, 
																		x.cd_material, 
																		null, 
																		null, 
																		null, 
																		a.cd_setor_Atendimento, 
																		null, 
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																		null) = 'S'))) -- nr_seq_exame_p 
	and	not exists ( 
			select	1 
			from	prescr_mat_hor c 
			where	c.cd_material = y.cd_material 
			and	c.nr_prescricao = x.nr_prescricao 
			and	c.nr_seq_material = x.nr_sequencia 
			and	c.ie_agrupador = 12 
			and	x.ie_agrupador = 12 
			and	c.nr_prescricao = a.nr_prescricao 
			and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S') 
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) 
	group by 
		a.nr_prescricao, 
		x.nr_sequencia, 
		x.cd_material, 
		y.ds_material, 
		x.ie_acm, 
		x.ie_se_necessario,		 
		x.cd_intervalo, 
		x.qt_dose, 
		x.ie_suspenso, 
		a.dt_liberacao_medico, 
		a.dt_liberacao, 
		a.dt_liberacao_farmacia, 
		x.cd_unidade_medida_dose, 
		x.ie_via_aplicacao		 
	) alias25 
group by 
	nr_prescricao, 
	nr_seq_material, 
	cd_material, 
	ds_material, 
	ie_acm_sn,	 
	cd_intervalo, 
	qt_dose, 
	ds_prescricao, 
	CASE WHEN ie_suspenso='N' THEN null  ELSE ie_suspenso END , 
	ie_lib_pend_rep, 
	cd_unidade_medida_dose, 
	ie_via_aplicacao, 
	ds_intervalo;	
 

BEGIN 
open c01;
loop 
fetch c01 into	nr_prescricao_w, 
		nr_seq_material_w, 
		cd_material_w, 
		ds_material_w, 
		ie_acm_sn_w,		 
		cd_intervalo_w, 
		qt_dose_w, 
		ds_prescricao_w, 
		ie_status_w, 
		cd_unid_med_qtde_w, 
		ie_via_administracao_w, 
		ds_interv_prescr_w;
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
		cd_intervalo, 
		qt_item, 
		ds_prescricao, 
		ie_status_item, 
		ie_diferenciado, 
		nr_seq_proc_interno, 
		nr_agrupamento, 
		cd_unid_med_qtde, 
		ie_via_aplicacao, 
		ds_interv_prescr) 
	values ( 
		nr_seq_wadep_w, 
		nm_usuario_p, 
		'S', 
		nr_prescricao_w, 
		nr_seq_material_w, 
		cd_material_w, 
		ds_material_w, 
		ie_acm_sn_w, 
		cd_intervalo_w, 
		qt_dose_w, 
		ds_prescricao_w, 
		ie_status_w, 
		'N', 
		0, 
		0, 
		cd_unid_med_qtde_w, 
		ie_via_administracao_w, 
		ds_interv_prescr_w);
	end;
end loop;
close c01;
 
if (ie_lib_pend_rep_p = 'S') then 
	begin 
	open c02;
	loop 
	fetch c02 into	nr_prescricao_w, 
			nr_seq_material_w, 
			cd_material_w, 
			ds_material_w, 
			ie_acm_sn_w,		 
			cd_intervalo_w, 
			qt_dose_w, 
			ds_prescricao_w, 
			ie_status_w, 
			ie_lib_pend_rep_w, 
			cd_unid_med_qtde_w, 
			ie_via_administracao_w, 
			ds_interv_prescr_w;
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
			cd_intervalo, 
			qt_item, 
			ds_prescricao, 
			ie_status_item, 
			ie_diferenciado, 
			nr_seq_proc_interno, 
			nr_agrupamento, 
			ie_pendente_liberacao, 
			cd_unid_med_qtde, 
			ie_via_aplicacao, 
			ds_interv_prescr) 
		values ( 
			nr_seq_wadep_w, 
			nm_usuario_p, 
			'S', 
			nr_prescricao_w, 
			nr_seq_material_w, 
			cd_material_w, 
			ds_material_w, 
			ie_acm_sn_w, 
			cd_intervalo_w, 
			qt_dose_w, 
			ds_prescricao_w, 
			ie_status_w, 
			'N', 
			0, 
			0, 
			ie_lib_pend_rep_w, 
			cd_unid_med_qtde_w, 
			ie_via_administracao_w, 
			ds_interv_prescr_w);
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
-- REVOKE ALL ON PROCEDURE vipe_obter_supl_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

