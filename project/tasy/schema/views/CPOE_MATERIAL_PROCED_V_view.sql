-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_material_proced_v (nr_seq_proced, nr_atendimento, cd_material, qt_dose, ie_via_aplicacao, cd_unidade_medida, cd_intervalo, hr_prim_horario, ds_horarios, dt_inicio, ie_urgencia, ie_duracao, ie_evento_unico, ie_administracao, ie_checar_adep, dt_fim, dt_liberacao, ds_obser_proc, cd_pessoa_fisica, nr_agrupamento, cd_setor_atendimento, ie_motivo_prescricao, cd_diluente, qt_dose_diluente, cd_unidade_medida_diluente, cd_reconst, qt_dose_reconst, cd_unidade_medida_reconst, nr_seq_prot_glic, ie_segunda, ie_terca, ie_quarta, ie_quinta, ie_sexta, ie_sabado, ie_domingo) AS select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc1 cd_material,
		qt_dose_mat1 qt_dose,
		ie_via_mat_proc1 ie_via_aplicacao,
		cd_unid_medida_dose_mat1 cd_unidade_medida,
		coalesce(cd_interv_proc1,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc1,hr_prim_horario) hr_prim_horario,
		coalesce(ds_hor_proc1,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc1,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat1,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc1,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat1,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep1,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc1 ds_obser_proc,
		cd_pessoa_fisica,
		1 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil1 cd_diluente,
		qt_dose_dil1 qt_dose_diluente,
		cd_unid_medida_dose_dil1 cd_unidade_medida_diluente,
		cd_mat_recons1 cd_reconst,
		qt_dose_recons1 qt_dose_reconst,
		cd_unid_medida_dose_recons1 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo
FROM	cpoe_procedimento
where	cd_mat_proc1 is not null

union all

select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc2 cd_material,
		qt_dose_mat2 qt_dose,
		ie_via_mat_proc2 ie_via_aplicacao,
		cd_unid_medida_dose_mat2 cd_unidade_medida,
		coalesce(cd_interv_proc2,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc2,hr_prim_horario) hxr_prim_horario,
		coalesce(ds_hor_proc2,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc2,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat2,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc2,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat2,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep2,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc2 ds_obser_proc,
		cd_pessoa_fisica,
		2 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil2 cd_diluente,
		qt_dose_dil2 qt_dose_diluente,
		cd_unid_medida_dose_dil2 cd_unidade_medida_diluente,
		cd_mat_recons2 cd_reconst,
		qt_dose_recons2 qt_dose_reconst,
		cd_unid_medida_dose_recons2 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo		
from	cpoe_procedimento
where	cd_mat_proc2 is not null

union all

select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc3 cd_material,
		qt_dose_mat3 qt_dose,
		ie_via_mat_proc3 ie_via_aplicacao,
		cd_unid_medida_dose_mat3 cd_unidade_medida,
		coalesce(cd_interv_proc3,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc3,hr_prim_horario) hr_prim_horario,
		coalesce(ds_hor_proc3,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc3,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat3,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc3,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat3,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep3,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc3 ds_obser_proc,
		cd_pessoa_fisica,
		3 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil3 cd_diluente,
		qt_dose_dil3 qt_dose_diluente,
		cd_unid_medida_dose_dil3 cd_unidade_medida_diluente,
		cd_mat_recons3 cd_reconst,
		qt_dose_recons3 qt_dose_reconst,
		cd_unid_medida_dose_recons3 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo 		
from	cpoe_procedimento
where	cd_mat_proc3 is not null

union all

select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc4 cd_material,
		qt_dose_mat4 qt_dose,
		ie_via_mat_proc4 ie_via_aplicacao,
		cd_unid_medida_dose_mat4 cd_unidade_medida,
		coalesce(cd_interv_proc4,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc4,hr_prim_horario) hr_prim_horario,
		coalesce(ds_hor_proc4,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc4,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat4,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc4,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat4,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep4,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc4 ds_obser_proc,
		cd_pessoa_fisica,
		4 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil4 cd_diluente,
		qt_dose_dil4 qt_dose_diluente,
		cd_unid_medida_dose_dil4 cd_unidade_medida_diluente,
		cd_mat_recons4 cd_reconst,
		qt_dose_recons4 qt_dose_reconst,
		cd_unid_medida_dose_recons4 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo		
from	cpoe_procedimento
where	cd_mat_proc4 is not null

union all

select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc5 cd_material,
		qt_dose_mat5 qt_dose,
		ie_via_mat_proc5 ie_via_aplicacao,
		cd_unid_medida_dose_mat5 cd_unidade_medida,
		coalesce(cd_interv_proc5,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc5,hr_prim_horario) hr_prim_horario,
		coalesce(ds_hor_proc5,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc5,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat5,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc5,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat5,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep5,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc5 ds_obser_proc,
		cd_pessoa_fisica,
		5 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil5 cd_diluente,
		qt_dose_dil5 qt_dose_diluente,
		cd_unid_medida_dose_dil5 cd_unidade_medida_diluente,
		cd_mat_recons5 cd_reconst,
		qt_dose_recons5 qt_dose_reconst,
		cd_unid_medida_dose_recons5 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo		
from	cpoe_procedimento
where	cd_mat_proc5 is not null

union all

select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc6 cd_material,
		qt_dose_mat6 qt_dose,
		ie_via_mat_proc6 ie_via_aplicacao,
		cd_unid_medida_dose_mat6 cd_unidade_medida,
		coalesce(cd_interv_proc6,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc6,hr_prim_horario) hr_prim_horario,
		coalesce(ds_hor_proc6,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc6,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat6,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc6,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat6,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep6,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc6 ds_obser_proc,
		cd_pessoa_fisica,
		6 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil6 cd_diluente,
		qt_dose_dil6 qt_dose_diluente,
		cd_unid_medida_dose_dil6 cd_unidade_medida_diluente,
		cd_mat_recons6 cd_reconst,
		qt_dose_recons6 qt_dose_reconst,
		cd_unid_medida_dose_recons6 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo		
from	cpoe_procedimento
where	cd_mat_proc6 is not null

union all

select	nr_sequencia nr_seq_proced,
		nr_atendimento,
		cd_mat_proc7 cd_material,
		qt_dose_mat7 qt_dose,
		ie_via_mat_proc7 ie_via_aplicacao,
		cd_unid_medida_dose_mat7 cd_unidade_medida,
		coalesce(cd_interv_proc7,cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_proc7,hr_prim_horario) hr_prim_horario,
		coalesce(ds_hor_proc7,ds_horarios) ds_horarios,
		coalesce(dt_inicio_proc7,dt_inicio) dt_inicio,
		coalesce(ie_urgencia_mat7,ie_urgencia) ie_urgencia,
		coalesce(ie_dur_proc7,ie_duracao) ie_duracao,
		ie_evento_unico ie_evento_unico,
		coalesce(ie_adm_mat7,ie_administracao) ie_administracao,
		coalesce(ie_assoc_adep7,'N') ie_checar_adep,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao,
		ds_obser_proc7 ds_obser_proc,
		cd_pessoa_fisica,
		7 nr_agrupamento,
		cd_setor_atendimento,
		ie_motivo_prescricao,
		cd_mat_dil7 cd_diluente,
		qt_dose_dil7 qt_dose_diluente,
		cd_unid_medida_dose_dil7 cd_unidade_medida_diluente,
		cd_mat_recons7 cd_reconst,
		qt_dose_recons7 qt_dose_reconst,
		cd_unid_medida_dose_recons7 cd_unidade_medida_reconst,
		nr_seq_prot_glic,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo		
from	cpoe_procedimento
where	cd_mat_proc7 is not null;
