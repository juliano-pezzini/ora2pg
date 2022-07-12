-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.vipe_sincronizar_sne ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, dt_horario_p timestamp, nr_horario_p integer, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


	ds_sep_bv_w		varchar(50);
	nr_prescricao_w		bigint;
	nr_seq_solucao_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(15);
	ds_comando_update_w	varchar(4000);
	nr_ordem_w		bigint;
	current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp		timestamp;
	nr_horario_w		integer;
	nr_Seq_servico_w	bigint;
	ie_utiliza_servico_w	varchar(1) := vipe_gerar_horarios_pck.get_ie_utiliza_serv_dieta();
	dt_fim_w		timestamp;
	ie_pintar_w		varchar(1);
	cd_material_w		bigint;
	ie_status_w		varchar(15);
	cd_intervalo_w		varchar(50);
	qt_dose_w		double precision;
	ds_prescricao_w		varchar(4000);
	ie_ciente_w		varchar(1);
	ds_teste_w		varchar(255);

	c01 CURSOR FOR
	SELECT	a.nr_prescricao,
		x.nr_sequencia,
		substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15),
		c.dt_horario,
		c.nr_sequencia nr_seq_servico,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'SNE') ie_pintar,
		x.cd_material,
		substr(obter_status_solucao_prescr(2,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
		x.cd_intervalo,
		x.qt_dose,
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
		coalesce(c.ie_ciente,x.ie_ciente) ie_ciente,
		CASE WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='S' THEN 4 WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='T' THEN 3 WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='A' THEN 2 WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='I' THEN 1  ELSE 0 END  nr_ordem
	FROM prescr_medica a, prescr_material x
LEFT OUTER JOIN prescr_mat_hor c ON (x.nr_prescricao = c.nr_prescricao AND x.nr_sequencia = c.nr_seq_material)
WHERE x.nr_prescricao = a.nr_prescricao   and coalesce(c.ie_situacao,'A') = 'A' and coalesce(c.ie_adep,'S') = 'S' and ((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S') or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (not exists (SELECT 1 from prescr_mat_hor w where w.nr_prescricao = x.nr_prescricao and w.nr_seq_material = x.nr_sequencia)) and ((coalesce(a.dt_liberacao,a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao,a.dt_liberacao_medico))::text <> '')))) and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and ((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S') or
		((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.ie_prescr_nutricao, 'N') = 'S'))) and x.ie_agrupador = 8 and ie_utiliza_servico_w <> 'S' and Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S' and ((x.ie_status in ('I','INT')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
		 ((get_ie_considera_horario = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'))) and ((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T')) and ((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or
		((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SNE',
																		cd_estabelecimento_p,
																		cd_setor_usuario_p,
																		cd_perfil_p,
																		x.cd_material,
																		null,
																		null,
																		null,
																		a.cd_setor_atendimento,
																		null,
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																		null) = 'S'))) 	 -- nr_seq_exame_p
	--and	c.dt_horario between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w
  and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) group by
		c.dt_horario,
		x.cd_material,
		x.qt_dose,
		c.nr_sequencia,
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100),
		substr(obter_status_solucao_prescr(2,a.nr_prescricao,x.nr_sequencia),1,3),
		a.nr_prescricao,
		x.cd_intervalo,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'SNE'),
		x.nr_sequencia,
		substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15),
		coalesce(c.ie_ciente,x.ie_ciente),
		CASE WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='S' THEN 4 WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='T' THEN 3 WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='A' THEN 2 WHEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,null),1,15)='I' THEN 1  ELSE 0 END
	
union all

	select	a.nr_prescricao,
		x.nr_sequencia,
		CASE WHEN coalesce(b.dt_liberacao::text, '') = '' THEN 'Y'  ELSE b.ie_status_adep END ,
		b.dt_servico dt_horario,
		b.nr_sequencia nr_seq_servico,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'SNE') ie_pintar,
		x.cd_material,
		substr(obter_status_solucao_prescr(2,a.nr_prescricao,x.nr_sequencia),1,3) ie_status_solucao,
		x.cd_intervalo,
		x.qt_dose,
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
		x.ie_ciente,
		CASE WHEN CASE WHEN coalesce(b.dt_liberacao::text, '') = '' THEN 'Y'  ELSE b.ie_status_adep END ='Y' THEN 1  ELSE 0 END  nr_ordem
	from	prescr_material x,
		nut_atend_serv_dia b,
		prescr_medica a
	where	x.nr_prescricao = a.nr_prescricao
	and 	x.nr_prescricao = b.nr_prescricao
	and 	x.nr_sequencia = b.nr_seq_material
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S') or
		((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))
	and	x.ie_agrupador = 8
	and 	ie_utiliza_servico_w = 'S'
	and	((ie_exibir_sol_realizadas_p = 'S') or (x.ie_status <> 'T'))
	and	((ie_exibir_sol_suspensas_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	Obter_se_setor_vipe(a.cd_setor_atendimento) = 'S'
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(a.dt_suspensao::text, '') = ''))
	and	((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SNE',
																		cd_estabelecimento_p,
																		cd_setor_usuario_p,
																		cd_perfil_p,
																		x.cd_material,
																		null,
																		null,
																		null,
																		a.cd_Setor_atendimento,
																		null,
																		null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada
																		null) = 'S')))	 -- nr_seq_exame_p
	and	b.dt_servico between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	group by
		a.nr_prescricao,
		x.cd_intervalo,
		x.qt_dose,
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,x.nr_sequencia,x.ie_acm,x.ie_se_necessario),1,100),
		substr(obter_status_solucao_prescr(2,a.nr_prescricao,x.nr_sequencia),1,3),
		x.cd_material,
		x.nr_sequencia,
		CASE WHEN coalesce(b.dt_liberacao::text, '') = '' THEN 'Y'  ELSE b.ie_status_adep END ,
		b.dt_servico,
		VIPE_obter_se_colore(a.ie_motivo_prescricao, x.nr_prescricao, x.nr_sequencia, 'SNE'),
		b.nr_sequencia,
		x.ie_ciente,
		CASE WHEN CASE WHEN coalesce(b.dt_liberacao::text, '') = '' THEN 'Y'  ELSE b.ie_status_adep END ='Y' THEN 1  ELSE 0 END 
	order by nr_ordem,
		 dt_horario;

	
BEGIN
	ds_sep_bv_w	:= obter_separador_bv;
	dt_fim_w	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_validade_limite_p);

	open c01;
	loop
	fetch c01 into
		nr_prescricao_w,
		nr_seq_solucao_w,
		ie_status_horario_w,
		current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp,
		nr_Seq_servico_w,
		ie_pintar_w,
		cd_material_w,
		ie_status_w,
		cd_intervalo_w,
		qt_dose_w,
		ds_prescricao_w,
		ie_ciente_w,
		nr_ordem_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_horario_w := vipe_gerar_horarios_pck.obter_posicao_horario(current_setting('vipe_gerar_horarios_pck.dt_horario_w')::timestamp);

		if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then

			ds_comando_update_w	:=	' update w_vipe_t ' ||
							' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' ie_pintar = :ie_pintar, ' ||
							' ie_ciencia = :ie_ciencia ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||
							' and cd_item = :cd_item ' ||
							' and nvl(ie_status_item,''N'') = :ie_status ' ||
							' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
							' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
							' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';

			CALL exec_sql_dinamico_bv('VIPE', ds_comando_update_w,	'vl_hora=S' || to_char(nr_Seq_servico_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
										'ie_pintar=' || ie_pintar_w || ds_sep_bv_w ||
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
										'ie_tipo=SNE' || ds_sep_bv_w ||
										'nr_seq_item=' || to_char(nr_seq_solucao_w) || ds_sep_bv_w ||
										'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w ||
										'ie_status=' || to_char(ie_status_w) || ds_sep_bv_w ||
										'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
										'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w ||
										'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
										'ie_ciencia=' || ie_ciente_w || ds_sep_bv_w);

		else
			ds_comando_update_w	:=	' update w_vipe_t ' ||
							' set nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' ie_pintar = :ie_pintar, ' ||
							' ie_ciencia = :ie_ciencia ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||
							' and cd_item = :cd_item ' ||
							' and nvl(ie_status_item,''N'') = :ie_status ' ||
							' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
							' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
							' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';

			CALL exec_sql_dinamico_bv('VIPE', ds_comando_update_w,	'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
										'ie_pintar=' || ie_pintar_w || ds_sep_bv_w ||
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
										'ie_tipo=SNE' || ds_sep_bv_w ||
										'nr_seq_item=' || to_char(nr_seq_solucao_w) || ds_sep_bv_w ||
										'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w ||
										'ie_status=' || to_char(ie_status_w) || ds_sep_bv_w ||
										'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
										'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w ||
										'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
										'ie_ciencia=' || ie_ciente_w || ds_sep_bv_w);
		end if;
		end;
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.vipe_sincronizar_sne ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_sol_realizadas_p text, ie_exibir_sol_suspensas_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, dt_horario_p timestamp, nr_horario_p integer, ie_exibe_sem_lib_farm_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;
