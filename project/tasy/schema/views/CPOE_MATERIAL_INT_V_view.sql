-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_material_int_v (nr_sequencia, nr_atendimento, ie_tipo_item, cd_material, cd_unidade_medida, qt_dose, nr_ocorrencia, ie_via_aplicacao, qt_solucao, dt_inicio, dt_fim, hr_prim_horario, nm_usuario, dt_liberacao, cd_pessoa_fisica, dt_suspensao, dt_lib_suspensao, nr_seq_cpoe_anterior, nr_seq_ataque, ie_retrogrado, ie_material) AS select	nr_sequencia,
		nr_atendimento,
		'MCOMP1' ie_tipo_item,
		cd_mat_comp1 cd_material,
		cd_unid_med_dose_comp1 cd_unidade_medida,
		qt_dose_comp1 qt_dose,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_comp1,qt_dose_comp1,cd_unid_med_dose_comp1),0) qt_solucao,
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario nm_usuario,
		dt_liberacao dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
FROM	cpoe_material
where	cd_mat_comp1 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MCOMP2',
		cd_mat_comp2 cd_material,
		cd_unid_med_dose_comp2,
		qt_dose_comp2,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_comp2,qt_dose_comp2,cd_unid_med_dose_comp2),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_comp2 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MCOMP3',
		cd_mat_comp3 cd_material,
		cd_unid_med_dose_comp3,
		qt_dose_comp3,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_comp3,qt_dose_comp3,cd_unid_med_dose_comp3),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_comp3 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MCOMP4',
		cd_mat_comp4 cd_material,
		cd_unid_med_dose_comp4,
		qt_dose_comp4,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_comp4,qt_dose_comp4,cd_unid_med_dose_comp4),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_comp4 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MCOMP5',
		cd_mat_comp5 cd_material,
		cd_unid_med_dose_comp5,
		qt_dose_comp5,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_comp5,qt_dose_comp5,cd_unid_med_dose_comp5),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_comp5 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MCOMP6',
		cd_mat_comp6 cd_material,
		cd_unid_med_dose_comp6,
		qt_dose_comp6,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_comp6,qt_dose_comp6,cd_unid_med_dose_comp6),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_comp6 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MDIL',
		cd_mat_dil cd_material,
		cd_unid_med_dose_dil,
		qt_dose_dil,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_dil,qt_dose_dil,cd_unid_med_dose_dil),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_dil is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MAT',
		cd_material,
		cd_unidade_medida,
		qt_dose,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_material,qt_dose,cd_unidade_medida),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_material is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MRECONS',
		cd_mat_recons cd_material,
		cd_unid_med_dose_recons,
		qt_dose_recons,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_recons,qt_dose_recons,cd_unid_med_dose_recons),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_recons is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MRED',
		cd_mat_red cd_material,
		cd_unid_med_dose_red,
		qt_dose_red,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_red,qt_dose_red,cd_unid_med_dose_red),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_red is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MSOL1',
		cd_mat_soluc1 cd_material,
		cd_unid_med_dose_sol1,
		qt_dose_soluc1,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_soluc1,qt_dose_soluc1,cd_unid_med_dose_sol1),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_soluc1 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MSOL2',
		cd_mat_soluc2 cd_material,
		cd_unid_med_dose_sol2,
		qt_dose_soluc2,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_soluc2,qt_dose_soluc2,cd_unid_med_dose_sol2),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_soluc2 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MSOL3',
		cd_mat_soluc3 cd_material,
		cd_unid_med_dose_sol3,
		qt_dose_soluc3,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_soluc3,qt_dose_soluc3,cd_unid_med_dose_sol3),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_soluc3 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MSOL4',
		cd_mat_soluc4 cd_material,
		cd_unid_med_dose_sol4,
		qt_dose_soluc4,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_soluc4,qt_dose_soluc4,cd_unid_med_dose_sol4),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_soluc4 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'MSOL5',
		cd_mat_soluc5 cd_material,
		cd_unid_med_dose_sol5,
		qt_dose_soluc5,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_mat_soluc5,qt_dose_soluc5,cd_unid_med_dose_sol5),0),
		dt_inicio,
		coalesce(dt_fim_cih, dt_fim) dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		nr_seq_ataque,
		ie_retrogrado,
		ie_material
from	cpoe_material
where	cd_mat_soluc5 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'DMAT',
		cd_material,
		cd_unidade_medida_dose,
		qt_dose,
		nr_ocorrencia,
		ie_via_aplicacao,
		coalesce(obter_conversao_ml(cd_material,qt_dose,cd_unidade_medida_dose),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_dieta
where	cd_material is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'DPROD1',
		cd_mat_prod1 cd_material,
		cd_unidade_medida_dose,
		qt_dose_prod1,
		nr_ocorrencia,
		ie_via_leite1,
		coalesce(obter_conversao_ml(cd_mat_prod1,qt_dose_prod1,cd_unidade_medida_dose),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_dieta
where	cd_mat_prod1 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'DPROD2',
		cd_mat_prod2 cd_material,
		cd_unidade_medida_dose,
		qt_dose_prod2,
		nr_ocorrencia,
		ie_via_leite2,
		coalesce(obter_conversao_ml(cd_mat_prod2,qt_dose_prod2,cd_unidade_medida_dose),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_dieta
where	cd_mat_prod2 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'DPROD3',
		cd_mat_prod3 cd_material,
		cd_unidade_medida_dose,
		qt_dose_prod3,
		nr_ocorrencia,
		ie_via_leite3,
		coalesce(obter_conversao_ml(cd_mat_prod3,qt_dose_prod3,cd_unidade_medida_dose),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_dieta
where	cd_mat_prod3 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'DPROD4',
		cd_mat_prod4 cd_material,
		cd_unidade_medida_dose,
		qt_dose_prod4,
		nr_ocorrencia,
		ie_via_leite4,
		coalesce(obter_conversao_ml(cd_mat_prod4,qt_dose_prod4,cd_unidade_medida_dose),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_dieta
where	cd_mat_prod4 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'DPROD5',
		cd_mat_prod5 cd_material,
		cd_unidade_medida_dose,
		qt_dose_prod5,
		nr_ocorrencia,
		ie_via_leite5,
		coalesce(obter_conversao_ml(cd_mat_prod5,qt_dose_prod5,cd_unidade_medida_dose),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_dieta
where	cd_mat_prod5 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'PMAT1',
		cd_mat_proc1 cd_material,
		cd_unid_medida_dose_mat1,
		qt_dose_mat1,
		coalesce(obter_ocorrencias_horarios_rep(ds_hor_proc1),nr_ocorrencia),
		ie_via_mat_proc1,
		coalesce(obter_conversao_ml(cd_mat_proc1,qt_dose_mat1,cd_unid_medida_dose_mat1),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_procedimento
where	cd_mat_proc1 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'PMAT2',
		cd_mat_proc2 cd_material,
		cd_unid_medida_dose_mat2,
		qt_dose_mat2,
		coalesce(obter_ocorrencias_horarios_rep(ds_hor_proc2),nr_ocorrencia),
		ie_via_mat_proc2,
		coalesce(obter_conversao_ml(cd_mat_proc2,qt_dose_mat2,cd_unid_medida_dose_mat2),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_procedimento
where	cd_mat_proc2 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'PMAT3',
		cd_mat_proc3 cd_material,
		cd_unid_medida_dose_mat3,
		qt_dose_mat3,
		coalesce(obter_ocorrencias_horarios_rep(ds_hor_proc3),nr_ocorrencia),
		ie_via_mat_proc3,
		coalesce(obter_conversao_ml(cd_mat_proc3,qt_dose_mat3,cd_unid_medida_dose_mat3),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_procedimento
where	cd_mat_proc3 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'PMAT4',
		cd_mat_proc4 cd_material,
		cd_unid_medida_dose_mat4,
		qt_dose_mat4,
		coalesce(obter_ocorrencias_horarios_rep(ds_hor_proc4),nr_ocorrencia),
		ie_via_mat_proc4,
		coalesce(obter_conversao_ml(cd_mat_proc4,qt_dose_mat4,cd_unid_medida_dose_mat4),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_procedimento
where	cd_mat_proc4 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'PMAT5',
		cd_mat_proc5 cd_material,
		cd_unid_medida_dose_mat5,
		qt_dose_mat5,
		coalesce(obter_ocorrencias_horarios_rep(ds_hor_proc5),nr_ocorrencia),
		ie_via_mat_proc5,
		coalesce(obter_conversao_ml(cd_mat_proc5,qt_dose_mat5,cd_unid_medida_dose_mat5),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from	cpoe_procedimento
where	cd_mat_proc5 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'GMAT1',
		cd_mat_equip1 cd_material,
		cd_unid_med_dose1,
		qt_dose_mat1,
		coalesce(obter_ocorrencias_horarios_rep(ds_horarios_mat1),nr_ocorrencia),
		ie_via_aplic1,
		coalesce(obter_conversao_ml(cd_mat_equip1,qt_dose_mat1,cd_unid_med_dose1),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from 	cpoe_gasoterapia
where	cd_mat_equip1 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'GMAT2',
		cd_mat_equip2 cd_material,
		cd_unid_med_dose2,
		qt_dose_mat2,
		coalesce(obter_ocorrencias_horarios_rep(ds_horarios_mat2),nr_ocorrencia),
		ie_via_aplic2,
		coalesce(obter_conversao_ml(cd_mat_equip2,qt_dose_mat2,cd_unid_med_dose2),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from 	cpoe_gasoterapia
where	cd_mat_equip2 is not null

union all

select	nr_sequencia,
		nr_atendimento,
		'GMAT3',
		cd_mat_equip3 cd_material,
		cd_unid_med_dose3,
		qt_dose_mat3,
		coalesce(obter_ocorrencias_horarios_rep(ds_horarios_mat3),nr_ocorrencia),
		ie_via_aplic3,
		coalesce(obter_conversao_ml(cd_mat_equip3,qt_dose_mat3,cd_unid_med_dose3),0),
		dt_inicio,
		dt_fim,
		hr_prim_horario,
		nm_usuario,
		dt_liberacao,
		cd_pessoa_fisica,
		dt_suspensao,
		dt_lib_suspensao,
		nr_seq_cpoe_anterior,
		null,
		ie_retrogrado,
		'N' ie_material
from 	cpoe_gasoterapia
where	cd_mat_equip3 is not null;

