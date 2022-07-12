-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_material_sol_rel_v (nm_solucao, ds_componente, dt_inicio, ds_fim, nr_sequencia_p, dt_liberacao, dt_fim, nm_usuario_susp, nr_atendimento, dt_lib_suspensao, nm_solucao_1, nm_solucao_2, nm_solucao_3, nm_solucao_4, nm_solucao_5, nm_solucao_6, nm_solucao_7, nm_reconstituinte, nm_diluente, nm_rediluente, ds_justificativa, ds_observacao, ds_horarios, ie_via_aplicacao, ie_tipo_solucao, ie_controle_tempo, cd_material, ie_administracao, dt_liberacao_enf, ds_horarios_p, nm_usuario_nrec, ds_ref_calculo, cd_mat_comp1, cd_mat_comp2, cd_mat_comp3, cd_mat_comp4, cd_mat_comp5, cd_mat_comp6, cd_mat_comp7) AS select	substr(obter_desc_material(a.cd_material),1,255)||
		CASE WHEN obter_se_medicam_alto_risco(a.cd_material)='S' THEN '<b> (' || wheb_mensagem_pck.get_texto(391170, null) || ') </b>'  ELSE null END  nm_solucao,		
		trim(both cpoe_obter_comp_mat_rel(ie_controle_tempo, ie_tipo_solucao, qt_dose, cd_unidade_medida, ie_administracao, ie_ref_calculo, ie_bomba_infusao, null,a.ie_via_aplicacao, null,
		null, null,  null, qt_dose_ataque, null,  null, ds_dose_diferenciada, qt_dosagem, ie_tipo_dosagem, null, nr_sequencia, qt_hora_fase, a.ie_urgencia, qt_dose_terapeutica, cd_unid_medic_terap,
		ie_tipo_analgesia, ie_pca_modo_prog)) ds_componente,
		CASE WHEN a.ie_administracao='P' THEN to_date(to_char(cpoe_obter_data_hora_form(a.dt_inicio, a.hr_prim_horario), 'dd/mm/yyyy hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')  ELSE a.dt_liberacao END  dt_inicio,
		CASE WHEN a.dt_fim='' THEN obter_desc_expressao(689989, '')  ELSE to_char(a.dt_fim,'dd/mm/yyyy hh24:mi:ss') END  ds_fim,
		nr_sequencia nr_sequencia_p,
		a.dt_liberacao,
		CASE WHEN dt_lib_suspensao IS NULL THEN  coalesce(dt_fim_cih,dt_fim)  ELSE dt_fim END  dt_fim,
		a.nm_usuario_susp,
		a.nr_atendimento,
		coalesce(a.dt_lib_suspensao,null) dt_lib_suspensao,
		CASE WHEN a.cd_mat_comp1 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp1),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp1, cd_unid_med_dose_comp1,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp1) || CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp1)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_1,
		CASE WHEN a.cd_mat_comp2 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp2),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp2, cd_unid_med_dose_comp2,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp2) || CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp2)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_2,
		CASE WHEN a.cd_mat_comp3 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp3),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp3, cd_unid_med_dose_comp3,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp3)|| CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp3)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_3,
		CASE WHEN a.cd_mat_comp4 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp4),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp4, cd_unid_med_dose_comp4,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp4)|| CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp4)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_4,
		CASE WHEN a.cd_mat_comp5 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp5),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp5, cd_unid_med_dose_comp5,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp5)|| CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp5)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_5,
		CASE WHEN a.cd_mat_comp6 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp6),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp6, cd_unid_med_dose_comp6,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp6)|| CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp6)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_6,		
		CASE WHEN a.cd_mat_comp7 IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_comp7),1,255) ||' '|| cpoe_obter_comp_mat_rel('SI', null, qt_dose_comp7, cd_unid_med_dose_comp7,null, null, null,null, null, null, null, null, null, null, null, null, a.ds_dose_diferenciada_comp7)|| CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_comp7)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_solucao_7,
		CASE WHEN a.cd_mat_recons IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_recons),1,255) ||' '||cpoe_obter_comp_mat_rel('SI', null, qt_dose_recons, cd_unid_med_dose_recons,null, null, null,null, null, null, null,null,null,null,null,null,ds_dose_diferenciada_rec) || CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_recons)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_reconstituinte,
		CASE WHEN a.cd_mat_dil IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_dil),1,255) ||' '||cpoe_obter_comp_mat_rel('SI', null, qt_dose_dil, cd_unid_med_dose_dil,null, null, null,null, null, null, null,  null, null , null , null , null, ds_dose_diferenciada_dil) || CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_dil)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_diluente,
		CASE WHEN a.cd_mat_red IS NULL THEN  null  ELSE substr(obter_desc_material(a.cd_mat_red),1,255) ||' '||cpoe_obter_comp_mat_rel('SI', null, qt_dose_red, cd_unid_med_dose_red,null, null, null,null, null, null, null,null,null,null,null,null,ds_dose_diferenciada_red) || CASE WHEN obter_se_medicam_alto_risco(a.cd_mat_red)='S' THEN '<b> ' || wheb_mensagem_pck.get_texto(391170, null) || '</b>'  ELSE null END  END  nm_rediluente,
		CASE WHEN ds_justificativa IS NULL THEN  null  ELSE substr(SUBSTR(obter_desc_expressao(341044, ''),1,70) || ' ' ||  substr(ds_justificativa,1,3900),1,4000) END  ds_justificativa,
		CASE WHEN ds_observacao IS NULL THEN  null  ELSE substr(obter_desc_expressao(329252, ''),1,255) || ' ' || substr(ds_observacao,1,3500) END  ds_observacao,
		CASE WHEN a.ds_horarios IS NULL THEN  null  ELSE obter_desc_expressao(291449, '') ||': '|| a.ds_horarios END  ds_horarios,
		a.ie_via_aplicacao,
		a.ie_tipo_solucao,
		a.ie_controle_tempo,
		a.cd_material,
		a.ie_administracao,
		a.dt_liberacao_enf,
		a.ds_horarios ds_horarios_p,
		a.nm_usuario_nrec,
		CASE WHEN ds_ref_calculo IS NULL THEN  null  ELSE substr(SUBSTR(obter_desc_expressao(653689, ''),1,70) || ': ' ||  substr(ds_ref_calculo,1,3900),1,4000) END  ds_ref_calculo,
		cd_mat_comp1,
		cd_mat_comp2,
		cd_mat_comp3,
		cd_mat_comp4,
		cd_mat_comp5,
		cd_mat_comp6,
		cd_mat_comp7
FROM  	cpoe_material a
where	a.ie_controle_tempo = 'S';
