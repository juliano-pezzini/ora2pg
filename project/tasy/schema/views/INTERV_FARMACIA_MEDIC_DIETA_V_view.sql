-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW interv_farmacia_medic_dieta_v (nr_prescricao, nr_prescr_interf_farm, nr_ordernacao, ie_tipo, ie_acm, ie_urgencia, nr_agrupamento, qt_hora_aplicacao, qt_min_aplicacao, ds_atencao_quimio, ds_definicao_ccih, ds_medic_protocolo, ds_protocolo, nr_dia_util, ie_regra_disp, ds_disp_farm_itens, ie_necessita_disp_kit, ie_medicacao_paciente, ds_dose_diferenciada, qt_dose_especial, ds_dose_um_inter, dt_lib_material, ie_gerar_horario, hr_dose_especial, ds_horarios_grid, ds_horarios_aprazados, ds_horarios_susp, ds_inconsistencia_farm, ie_item_superior, ds_material, ie_alteracao_medic, ds_observacao_far_grid, ie_origem_inf, ds_principio_ativo, nr_receita, ds_observacao_grid, ds_diluicao, nr_sequencia, nr_seq_kit_estoque, ie_se_necessario, nm_usuario_subst, ds_via_acesso, ds_via_aplicacao, qt_dose_especial_grid, ie_via_aplicacao, cd_unidade_medida_dose, cd_intervalo, qt_vel_infusao, cd_material, ie_suspenso, qt_dose, ie_bomba_infusao, qt_solucao, ie_regra_df) AS select 	a.nr_prescricao,
	a.nr_prescr_interf_farm, 
	1 nr_ordernacao, 
	'M' ie_tipo, 
	b.ie_acm, 
	b.ie_urgencia, 
	b.nr_agrupamento, 
	b.qt_hora_aplicacao, 
	b.qt_min_aplicacao, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'OB'),1,255) ds_atencao_quimio, 
	substr(obter_desc_ult_def_inf(b.nr_prescricao,b.nr_sequencia),1,255) ds_definicao_ccih, 
	substr(OBTER_DESC_PROTOCOLO_MEDIC(b.NR_SEQ_PROTOCOLO,b.cd_protocolo),1,50) ds_medic_protocolo, 
	substr(Obter_desc_protocolo(b.cd_protocolo),1,100) ds_protocolo, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) nr_dia_util, 
	substr(obter_um_dosagem_prescr(b.nr_prescricao,b.nr_sequencia),1,100) ie_regra_disp, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) ds_disp_farm_itens,	 
	b.ie_necessita_disp_kit, 
	b.ie_medicacao_paciente, 
	b.ds_dose_diferenciada, 
	b.qt_dose_especial, 
	substr(obter_um_dosagem_prescr(b.NR_PRESCRICAO,b.NR_SEQUENCIA),1,100) ds_dose_um_inter, 
	to_char(b.dt_lib_material,'dd/mm/yyyy hh24:mi:ss') dt_lib_material, 
	b.ie_gerar_horario, 
	b.hr_dose_especial, 
	substr(b.ds_horarios,1,255) ds_horarios_grid, 
	substr(obter_horarios_aprazados(b.nr_prescricao, b.nr_sequencia),1,255) ds_horarios_aprazados, 
	substr(obter_horarios_suspensos(b.nr_prescricao,b.nr_sequencia),1,255) ds_horarios_susp, 
	substr(obter_dados_inconsist_farm(b.nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia_farm, 
	b.ie_item_superior, 
	substr(obter_desc_material(b.cd_material),1,80) ds_material, 
	substr(obter_se_alteracao_medicamento(b.nr_prescricao,b.nr_sequencia),1,255) ie_alteracao_medic, 
	substr(b.ds_observacao_far,1,255) ds_observacao_far_grid, 
	b.ie_origem_inf, 
	substr(obter_princ_ativo_matmed(b.cd_material),1,100) ds_principio_ativo, 
	b.nr_receita, 
	substr(b.ds_observacao,1,255) ds_observacao_grid, 
	substr(obter_diluicao_medic(b.nr_sequencia,b.nr_prescricao),1,255) ds_diluicao, 
	b.nr_sequencia, 
	b.nr_seq_kit_estoque, 
	b.ie_se_necessario, 
	CASE WHEN coalesce(b.nr_seq_substituto,0)=0 THEN  ''  ELSE b.nm_usuario END  nm_usuario_subst, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'V'),1,255) ds_via_acesso, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'A'),1,255) ds_via_aplicacao, 
	substr(replace(converte_fracao_dose(cd_unidade_medida_dose,qt_dose_especial),'.',','),1,30) qt_dose_especial_grid, 
	b.ie_via_aplicacao, 
	b.cd_unidade_medida_dose, 
	b.cd_intervalo, 
	b.qt_vel_infusao, 
	b.cd_material, 
	b.ie_suspenso, 
    b.qt_dose, 
	b.ie_bomba_infusao, 
	b.qt_solucao, 
	coalesce(b.ie_regra_disp,'S') ie_regra_df 
FROM  	prescr_material b, 
	prescr_medica a 
where 	a.nr_prescricao = b.nr_prescricao 
and	b.ie_agrupador	= 1 
and	exists (select 	1 
	  	from	prescr_material y, 
			prescr_medica x 
		where	x.nr_prescricao 	= y.nr_prescricao 
		and	y.nr_seq_interf_farm	= b.nr_sequencia 
		and	x.nr_prescr_interf_farm = a.nr_prescricao 
		and	y.ie_agrupador = 1)  

union all
 
select 	a.nr_prescricao, 
	a.nr_prescr_interf_farm, 
	2 nr_ordernacao, 
	'M' ie_tipo, 
	b.ie_acm, 
	b.ie_urgencia, 
	b.nr_agrupamento, 
	b.qt_hora_aplicacao, 
	b.qt_min_aplicacao, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'OB'),1,255) ds_atencao_quimio, 
	substr(obter_desc_ult_def_inf(b.nr_prescricao,b.nr_sequencia),1,255) ds_definicao_ccih, 
	substr(OBTER_DESC_PROTOCOLO_MEDIC(b.NR_SEQ_PROTOCOLO,b.cd_protocolo),1,50) ds_medic_protocolo, 
	substr(Obter_desc_protocolo(b.cd_protocolo),1,100) ds_protocolo, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) nr_dia_util, 
	substr(obter_um_dosagem_prescr(b.nr_prescricao,b.nr_sequencia),1,100) ie_regra_disp, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) ds_disp_farm_itens,	 
	b.ie_necessita_disp_kit, 
	b.ie_medicacao_paciente, 
	b.ds_dose_diferenciada, 
	b.qt_dose_especial, 
	substr(obter_um_dosagem_prescr(b.NR_PRESCRICAO,b.NR_SEQUENCIA),1,100) ds_dose_um_inter, 
	to_char(b.dt_lib_material,'dd/mm/yyyy hh24:mi:ss') dt_lib_material, 
	b.ie_gerar_horario, 
	b.hr_dose_especial, 
	substr(b.ds_horarios,1,255) ds_horarios_grid, 
	substr(obter_horarios_aprazados(b.nr_prescricao, b.nr_sequencia),1,255) ds_horarios_aprazados, 
	substr(obter_horarios_suspensos(b.nr_prescricao,b.nr_sequencia),1,255) ds_horarios_susp, 
	substr(obter_dados_inconsist_farm(b.nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia_farm, 
	b.ie_item_superior, 
	substr(obter_desc_material(b.cd_material),1,80) ds_material, 
	substr(obter_se_alteracao_medicamento(b.nr_prescricao,b.nr_sequencia),1,255) ie_alteracao_medic, 
	substr(b.ds_observacao_far,1,255) ds_observacao_far_grid, 
	b.ie_origem_inf, 
	substr(obter_princ_ativo_matmed(b.cd_material),1,100) ds_principio_ativo, 
	b.nr_receita, 
	substr(b.ds_observacao,1,255) ds_observacao_grid, 
	substr(obter_diluicao_medic(b.nr_sequencia,b.nr_prescricao),1,255) ds_diluicao, 
	b.nr_sequencia, 
	b.nr_seq_kit_estoque, 
	b.ie_se_necessario, 
	CASE WHEN coalesce(b.nr_seq_substituto,0)=0 THEN  ''  ELSE b.nm_usuario END  nm_usuario_subst, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'V'),1,255) ds_via_acesso, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'A'),1,255) ds_via_aplicacao, 
	substr(replace(converte_fracao_dose(cd_unidade_medida_dose,qt_dose_especial),'.',','),1,30) qt_dose_especial_grid, 
	b.ie_via_aplicacao, 
	b.cd_unidade_medida_dose, 
	b.cd_intervalo, 
	b.qt_vel_infusao, 
	b.cd_material, 
	b.ie_suspenso, 
    b.qt_dose, 
	b.ie_bomba_infusao, 
	b.qt_solucao, 
	coalesce(b.ie_regra_disp,'S') ie_regra_df 
from  	prescr_material b, 
	prescr_medica a 
where 	a.nr_prescricao	= b.nr_prescricao 
and	b.ie_agrupador 	= 1 
and	b.nr_seq_interf_farm is not null 

union all
 
select 	a.nr_prescricao, 
	a.nr_prescr_interf_farm, 
	1 nr_ordernacao, 
	'S' ie_tipo, 
	b.ie_acm, 
	b.ie_urgencia, 
	b.nr_agrupamento, 
	b.qt_hora_aplicacao, 
	b.qt_min_aplicacao, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'OB'),1,255) ds_atencao_quimio, 
	substr(obter_desc_ult_def_inf(b.nr_prescricao,b.nr_sequencia),1,255) ds_definicao_ccih, 
	substr(OBTER_DESC_PROTOCOLO_MEDIC(b.NR_SEQ_PROTOCOLO,b.cd_protocolo),1,50) ds_medic_protocolo, 
	substr(Obter_desc_protocolo(b.cd_protocolo),1,100) ds_protocolo, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) nr_dia_util, 
	substr(obter_um_dosagem_prescr(b.nr_prescricao,b.nr_sequencia),1,100) ie_regra_disp, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) ds_disp_farm_itens,	 
	b.ie_necessita_disp_kit, 
	b.ie_medicacao_paciente, 
	b.ds_dose_diferenciada, 
	b.qt_dose_especial, 
	substr(obter_um_dosagem_prescr(b.NR_PRESCRICAO,b.NR_SEQUENCIA),1,100) ds_dose_um_inter, 
	to_char(b.dt_lib_material,'dd/mm/yyyy hh24:mi:ss') dt_lib_material, 
	b.ie_gerar_horario, 
	b.hr_dose_especial, 
	substr(b.ds_horarios,1,255) ds_horarios_grid, 
	substr(obter_horarios_aprazados(b.nr_prescricao, b.nr_sequencia),1,255) ds_horarios_aprazados, 
	substr(obter_horarios_suspensos(b.nr_prescricao,b.nr_sequencia),1,255) ds_horarios_susp, 
	substr(obter_dados_inconsist_farm(b.nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia_farm, 
	b.ie_item_superior, 
	substr(obter_desc_material(b.cd_material),1,80) ds_material, 
	substr(obter_se_alteracao_medicamento(b.nr_prescricao,b.nr_sequencia),1,255) ie_alteracao_medic, 
	substr(b.ds_observacao_far,1,255) ds_observacao_far_grid, 
	b.ie_origem_inf, 
	substr(obter_princ_ativo_matmed(b.cd_material),1,100) ds_principio_ativo, 
	b.nr_receita, 
	substr(b.ds_observacao,1,255) ds_observacao_grid, 
	substr(obter_diluicao_medic(b.nr_sequencia,b.nr_prescricao),1,255) ds_diluicao, 
	b.nr_sequencia, 
	b.nr_seq_kit_estoque, 
	b.ie_se_necessario, 
	CASE WHEN coalesce(b.nr_seq_substituto,0)=0 THEN  ''  ELSE b.nm_usuario END  nm_usuario_subst, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'V'),1,255) ds_via_acesso, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'A'),1,255) ds_via_aplicacao, 
	substr(replace(converte_fracao_dose(cd_unidade_medida_dose,qt_dose_especial),'.',','),1,30) qt_dose_especial_grid, 
	b.ie_via_aplicacao, 
	b.cd_unidade_medida_dose, 
	b.cd_intervalo, 
	b.qt_vel_infusao, 
	b.cd_material, 
	b.ie_suspenso, 
    b.qt_dose, 
	b.ie_bomba_infusao, 
	b.qt_solucao, 
	coalesce(b.ie_regra_disp,'S') ie_regra_df 
from  	prescr_material b, 
	prescr_medica a 
where 	a.nr_prescricao = b.nr_prescricao 
and	b.ie_agrupador	= 12 
and	exists (select 	1 
	  	from	prescr_material y, 
			prescr_medica x 
		where	x.nr_prescricao 	= y.nr_prescricao 
		and	y.nr_seq_interf_farm	= b.nr_sequencia 
		and	x.nr_prescr_interf_farm = a.nr_prescricao 
		and	y.ie_agrupador = 12)	  

union all
 
select 	a.nr_prescricao, 
	a.nr_prescr_interf_farm, 
	2 nr_ordernacao, 
	'S' ie_tipo, 
	b.ie_acm, 
	b.ie_urgencia, 
	b.nr_agrupamento, 
	b.qt_hora_aplicacao, 
	b.qt_min_aplicacao, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'OB'),1,255) ds_atencao_quimio, 
	substr(obter_desc_ult_def_inf(b.nr_prescricao,b.nr_sequencia),1,255) ds_definicao_ccih, 
	substr(OBTER_DESC_PROTOCOLO_MEDIC(b.NR_SEQ_PROTOCOLO,b.cd_protocolo),1,50) ds_medic_protocolo, 
	substr(Obter_desc_protocolo(b.cd_protocolo),1,100) ds_protocolo, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) nr_dia_util, 
	substr(obter_um_dosagem_prescr(b.nr_prescricao,b.nr_sequencia),1,100) ie_regra_disp, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) ds_disp_farm_itens,	 
	b.ie_necessita_disp_kit, 
	b.ie_medicacao_paciente, 
	b.ds_dose_diferenciada, 
	b.qt_dose_especial, 
	substr(obter_um_dosagem_prescr(b.NR_PRESCRICAO,b.NR_SEQUENCIA),1,100) ds_dose_um_inter, 
	to_char(b.dt_lib_material,'dd/mm/yyyy hh24:mi:ss') dt_lib_material, 
	b.ie_gerar_horario, 
	b.hr_dose_especial, 
	substr(b.ds_horarios,1,255) ds_horarios_grid, 
	substr(obter_horarios_aprazados(b.nr_prescricao, b.nr_sequencia),1,255) ds_horarios_aprazados, 
	substr(obter_horarios_suspensos(b.nr_prescricao,b.nr_sequencia),1,255) ds_horarios_susp, 
	substr(obter_dados_inconsist_farm(b.nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia_farm, 
	b.ie_item_superior, 
	substr(obter_desc_material(b.cd_material),1,80) ds_material, 
	substr(obter_se_alteracao_medicamento(b.nr_prescricao,b.nr_sequencia),1,255) ie_alteracao_medic, 
	substr(b.ds_observacao_far,1,255) ds_observacao_far_grid, 
	b.ie_origem_inf, 
	substr(obter_princ_ativo_matmed(b.cd_material),1,100) ds_principio_ativo, 
	b.nr_receita, 
	substr(b.ds_observacao,1,255) ds_observacao_grid, 
	substr(obter_diluicao_medic(b.nr_sequencia,b.nr_prescricao),1,255) ds_diluicao, 
	b.nr_sequencia, 
	b.nr_seq_kit_estoque, 
	b.ie_se_necessario, 
	CASE WHEN coalesce(b.nr_seq_substituto,0)=0 THEN  ''  ELSE b.nm_usuario END  nm_usuario_subst, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'V'),1,255) ds_via_acesso, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'A'),1,255) ds_via_aplicacao, 
	substr(replace(converte_fracao_dose(cd_unidade_medida_dose,qt_dose_especial),'.',','),1,30) qt_dose_especial_grid, 
	b.ie_via_aplicacao, 
	b.cd_unidade_medida_dose, 
	b.cd_intervalo, 
	b.qt_vel_infusao, 
	b.cd_material, 
	b.ie_suspenso, 
    b.qt_dose, 
	b.ie_bomba_infusao, 
	b.qt_solucao, 
	coalesce(b.ie_regra_disp,'S') ie_regra_df 
from  	prescr_material b, 
	prescr_medica a 
where 	a.nr_prescricao	= b.nr_prescricao 
and	b.ie_agrupador 	= 12 
and	b.nr_seq_interf_farm is not null 

union all
 
select 	a.nr_prescricao, 
	a.nr_prescr_interf_farm, 
	1 nr_ordernacao, 
	'2' ie_tipo, 
	b.ie_acm, 
	b.ie_urgencia, 
	b.nr_agrupamento, 
	b.qt_hora_aplicacao, 
	b.qt_min_aplicacao, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'OB'),1,255) ds_atencao_quimio, 
	substr(obter_desc_ult_def_inf(b.nr_prescricao,b.nr_sequencia),1,255) ds_definicao_ccih, 
	substr(OBTER_DESC_PROTOCOLO_MEDIC(b.NR_SEQ_PROTOCOLO,b.cd_protocolo),1,50) ds_medic_protocolo, 
	substr(Obter_desc_protocolo(b.cd_protocolo),1,100) ds_protocolo, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) nr_dia_util, 
	substr(obter_um_dosagem_prescr(b.nr_prescricao,b.nr_sequencia),1,100) ie_regra_disp, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) ds_disp_farm_itens,	 
	b.ie_necessita_disp_kit, 
	b.ie_medicacao_paciente, 
	b.ds_dose_diferenciada, 
	b.qt_dose_especial, 
	substr(obter_um_dosagem_prescr(b.NR_PRESCRICAO,b.NR_SEQUENCIA),1,100) ds_dose_um_inter, 
	to_char(b.dt_lib_material,'dd/mm/yyyy hh24:mi:ss') dt_lib_material, 
	b.ie_gerar_horario, 
	b.hr_dose_especial, 
	substr(b.ds_horarios,1,255) ds_horarios_grid, 
	substr(obter_horarios_aprazados(b.nr_prescricao, b.nr_sequencia),1,255) ds_horarios_aprazados, 
	substr(obter_horarios_suspensos(b.nr_prescricao,b.nr_sequencia),1,255) ds_horarios_susp, 
	substr(obter_dados_inconsist_farm(b.nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia_farm, 
	b.ie_item_superior, 
	substr(obter_desc_material(b.cd_material),1,80) ds_material, 
	substr(obter_se_alteracao_medicamento(b.nr_prescricao,b.nr_sequencia),1,255) ie_alteracao_medic, 
	substr(b.ds_observacao_far,1,255) ds_observacao_far_grid, 
	b.ie_origem_inf, 
	substr(obter_princ_ativo_matmed(b.cd_material),1,100) ds_principio_ativo, 
	b.nr_receita, 
	substr(b.ds_observacao,1,255) ds_observacao_grid, 
	substr(obter_diluicao_medic(b.nr_sequencia,b.nr_prescricao),1,255) ds_diluicao, 
	b.nr_sequencia, 
	b.nr_seq_kit_estoque, 
	b.ie_se_necessario, 
	CASE WHEN coalesce(b.nr_seq_substituto,0)=0 THEN  ''  ELSE b.nm_usuario END  nm_usuario_subst, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'V'),1,255) ds_via_acesso, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'A'),1,255) ds_via_aplicacao, 
	substr(replace(converte_fracao_dose(cd_unidade_medida_dose,qt_dose_especial),'.',','),1,30) qt_dose_especial_grid, 
	b.ie_via_aplicacao, 
	b.cd_unidade_medida_dose, 
	b.cd_intervalo, 
	b.qt_vel_infusao, 
	b.cd_material, 
	b.ie_suspenso, 
    b.qt_dose, 
	b.ie_bomba_infusao, 
	b.qt_solucao, 
	coalesce(b.ie_regra_disp,'S') ie_regra_df 
from  	prescr_material b, 
	prescr_medica a 
where 	a.nr_prescricao = b.nr_prescricao 
and	b.ie_agrupador	= 8 
and	exists (select 	1 
	  	from	prescr_material y, 
			prescr_medica x 
		where	x.nr_prescricao 	= y.nr_prescricao 
		and	y.nr_seq_interf_farm	= b.nr_sequencia 
		and	x.nr_prescr_interf_farm = a.nr_prescricao 
		and	y.ie_agrupador = 8)	  

union all
 
select 	a.nr_prescricao, 
	a.nr_prescr_interf_farm, 
	2 nr_ordernacao, 
	'2' ie_tipo, 
	b.ie_acm, 
	b.ie_urgencia, 
	b.nr_agrupamento, 
	b.qt_hora_aplicacao, 
	b.qt_min_aplicacao, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'OB'),1,255) ds_atencao_quimio, 
	substr(obter_desc_ult_def_inf(b.nr_prescricao,b.nr_sequencia),1,255) ds_definicao_ccih, 
	substr(OBTER_DESC_PROTOCOLO_MEDIC(b.NR_SEQ_PROTOCOLO,b.cd_protocolo),1,50) ds_medic_protocolo, 
	substr(Obter_desc_protocolo(b.cd_protocolo),1,100) ds_protocolo, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) nr_dia_util, 
	substr(obter_um_dosagem_prescr(b.nr_prescricao,b.nr_sequencia),1,100) ie_regra_disp, 
	substr(obter_dispensacao_farmacia(b.nr_prescricao, b.nr_sequencia),1,255) ds_disp_farm_itens,	 
	b.ie_necessita_disp_kit, 
	b.ie_medicacao_paciente, 
	b.ds_dose_diferenciada, 
	b.qt_dose_especial, 
	substr(obter_um_dosagem_prescr(b.NR_PRESCRICAO,b.NR_SEQUENCIA),1,100) ds_dose_um_inter, 
	to_char(b.dt_lib_material,'dd/mm/yyyy hh24:mi:ss') dt_lib_material, 
	b.ie_gerar_horario, 
	b.hr_dose_especial, 
	substr(b.ds_horarios,1,255) ds_horarios_grid, 
	substr(obter_horarios_aprazados(b.nr_prescricao, b.nr_sequencia),1,255) ds_horarios_aprazados, 
	substr(obter_horarios_suspensos(b.nr_prescricao,b.nr_sequencia),1,255) ds_horarios_susp, 
	substr(obter_dados_inconsist_farm(b.nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia_farm, 
	b.ie_item_superior, 
	substr(obter_desc_material(b.cd_material),1,80) ds_material, 
	substr(obter_se_alteracao_medicamento(b.nr_prescricao,b.nr_sequencia),1,255) ie_alteracao_medic, 
	substr(b.ds_observacao_far,1,255) ds_observacao_far_grid, 
	b.ie_origem_inf, 
	substr(obter_princ_ativo_matmed(b.cd_material),1,100) ds_principio_ativo, 
	b.nr_receita, 
	substr(b.ds_observacao,1,255) ds_observacao_grid, 
	substr(obter_diluicao_medic(b.nr_sequencia,b.nr_prescricao),1,255) ds_diluicao, 
	b.nr_sequencia, 
	b.nr_seq_kit_estoque, 
	b.ie_se_necessario, 
	CASE WHEN coalesce(b.nr_seq_substituto,0)=0 THEN  ''  ELSE b.nm_usuario END  nm_usuario_subst, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'V'),1,255) ds_via_acesso, 
	substr(obter_dados_medic_quimio(b.nr_seq_atendimento, b.nr_seq_material, 'A'),1,255) ds_via_aplicacao, 
	substr(replace(converte_fracao_dose(cd_unidade_medida_dose,qt_dose_especial),'.',','),1,30) qt_dose_especial_grid, 
	b.ie_via_aplicacao, 
	b.cd_unidade_medida_dose, 
	b.cd_intervalo, 
	b.qt_vel_infusao, 
	b.cd_material, 
	b.ie_suspenso, 
    b.qt_dose, 
	b.ie_bomba_infusao, 
	b.qt_solucao, 
	coalesce(b.ie_regra_disp,'S') ie_regra_df 
from  	prescr_material b, 
	prescr_medica a 
where 	a.nr_prescricao	= b.nr_prescricao 
and	b.ie_agrupador 	= 8 
and	b.nr_seq_interf_farm is not null;

