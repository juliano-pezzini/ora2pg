-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_material_gaso_v (nr_seq_gasoterapia, nr_atendimento, cd_material, cd_unidade_medida, cd_intervalo, hr_prim_horario, ds_horarios, qt_dose_mat, dt_inicio, dt_fim, dt_liberacao) AS select	nr_sequencia nr_seq_gasoterapia,
		nr_atendimento,
		cd_mat_equip1 cd_material,
		cd_unid_med_dose1 cd_unidade_medida,
		coalesce(cd_intervalo_mat1, cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_mat1,hr_prim_horario) hr_prim_horario,
		coalesce(ds_horarios_mat1,ds_horarios) ds_horarios,
		qt_dose_mat1 qt_dose_mat,
		dt_inicio,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao
FROM	cpoe_gasoterapia
where	cd_mat_equip1 is not null

union all

select	nr_sequencia nr_seq_gasoterapia,
		nr_atendimento,
		cd_mat_equip2 cd_material,
		cd_unid_med_dose2 cd_unidade_medida,
		coalesce(cd_intervalo_mat2, cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_mat2,hr_prim_horario) hr_prim_horario,
		coalesce(ds_horarios_mat2,ds_horarios) ds_horarios,
		qt_dose_mat2 qt_dose_mat,
		dt_inicio,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao
from	cpoe_gasoterapia
where	cd_mat_equip2 is not null

union all

select	nr_sequencia nr_seq_gasoterapia,
		nr_atendimento,
		cd_mat_equip3 cd_material,
		cd_unid_med_dose3 cd_unidade_medida,
		coalesce(cd_intervalo_mat3, cd_intervalo) cd_intervalo,
		coalesce(hr_prim_hor_mat3,hr_prim_horario) hr_prim_horario,
		coalesce(ds_horarios_mat3,ds_horarios) ds_horarios,
		qt_dose_mat3 qt_dose_mat,
		dt_inicio,
		CASE WHEN dt_lib_suspensao IS NULL THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  dt_fim,
		dt_liberacao
from	cpoe_gasoterapia
where	cd_mat_equip3 is not null;
