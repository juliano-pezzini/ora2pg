-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_cpoe_mat_assoc_hemo ( nr_seq_cpoe_hemo_p cpoe_hemoterapia.nr_sequencia%type, nm_usuario_p cpoe_hemoterapia.nm_usuario%type, cd_perfil_p cpoe_hemoterapia.cd_perfil_ativo%type, ds_retorno_p INOUT text) AS $body$
DECLARE


nr_sequencia_mat_w		cpoe_material.nr_sequencia%type;
cd_material_w			cpoe_material.cd_material%type;
qt_dose_w				cpoe_material.qt_dose%type;
ie_via_aplicacao_w		cpoe_material.ie_via_aplicacao%type;
cd_unidade_medida_w		cpoe_material.cd_unidade_medida%type;
cd_mat_recons_w		cpoe_material.cd_mat_recons%type;
qt_dose_recons_w		cpoe_material.qt_dose_recons%type;
cd_unid_med_recons_w		cpoe_material.cd_unid_med_dose_recons%type;
cd_mat_dil_w		cpoe_material.cd_mat_dil%type;
qt_dose_dil_w		cpoe_material.qt_dose_dil%type;
cd_unid_med_dil_w		cpoe_material.cd_unid_med_dose_dil%type;
cd_intervalo_w		cpoe_material.cd_intervalo%type;
ie_administracao_w		cpoe_material.ie_administracao%type;
dt_inicio_w		cpoe_material.dt_inicio%type;
hr_prim_horario_w		cpoe_material.hr_prim_horario%type;
ie_urgencia_w		cpoe_material.ie_urgencia%type;
ds_horarios_w		cpoe_material.ds_horarios%type;
ds_obser_hemo_w		cpoe_material.ds_observacao%type;
dt_liberacao_w		cpoe_material.dt_liberacao%type;
dt_fim_w		cpoe_material.dt_fim%type;
nr_atendimento_w		cpoe_material.nr_atendimento%type;
cd_pessoa_fisica_w		cpoe_material.cd_pessoa_fisica%type;
cd_setor_atendimento_w	cpoe_material.cd_setor_atendimento%type;
ie_motivo_prescricao_w	cpoe_material.ie_motivo_prescricao%type;
ds_retorno_w			varchar(2);

c01 CURSOR FOR
SELECT	cd_material,
	qt_dose,
	ie_via_aplicacao,
	cd_unidade_medida,
	cd_mat_recons,
	qt_dose_recons,
	cd_unid_med_recons,
	cd_mat_dil,
	qt_dose_dil,
	cd_unid_med_dil,
	cd_intervalo,
	ie_administracao,
	to_date(to_char(dt_inicio,'dd/mm/yyyy') || ' ' || hr_prim_horario,'dd/mm/yyyy hh24:mi:ss'),
	hr_prim_horario,
	ie_urgencia,
	ds_horarios,
	ds_obser_hemo,
	dt_liberacao,
	to_date(to_char(dt_inicio,'dd/mm/yyyy') || ' ' || hr_prim_horario,'dd/mm/yyyy hh24:mi:ss') + 1 dt_fim,
	nr_atendimento,
	cd_pessoa_fisica,
	cd_setor_atendimento,
	ie_motivo_prescricao
from	cpoe_material_hemoterapia_v
where	nr_seq_hemo  = nr_seq_cpoe_hemo_p
order by	nr_agrupamento;


BEGIN

	if (nr_seq_cpoe_hemo_p IS NOT NULL AND nr_seq_cpoe_hemo_p::text <> '') then
		open c01;
		loop
		fetch c01 into	cd_material_w,
						qt_dose_w,
						ie_via_aplicacao_w,
						cd_unidade_medida_w,
						cd_mat_recons_w,
						qt_dose_recons_w,
						cd_unid_med_recons_w,
						cd_mat_dil_w,
						qt_dose_dil_w,
						cd_unid_med_dil_w,
						cd_intervalo_w,
						ie_administracao_w,
						dt_inicio_w,
						hr_prim_horario_w,
						ie_urgencia_w,
						ds_horarios_w,
						ds_obser_hemo_w,
						dt_liberacao_w,
						dt_fim_w,
						nr_atendimento_w,
						cd_pessoa_fisica_w,
						cd_setor_atendimento_w,
						ie_motivo_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
				select	nextval('cpoe_material_seq')
				into STRICT	nr_sequencia_mat_w
				;

				insert 	into cpoe_material(
							nr_sequencia,
							nr_atendimento,
							cd_material,
							qt_dose,
							cd_unidade_medida,
							cd_mat_recons,
							qt_dose_recons,
							cd_unid_med_dose_recons,
							cd_mat_dil,
							qt_dose_dil,
							cd_unid_med_dose_dil,
							ds_observacao,
							ie_via_aplicacao,
							cd_intervalo,
							hr_prim_horario,
							ds_horarios,
							dt_inicio,
							ie_urgencia,
							ie_duracao,
							ie_evento_unico,
							ie_administracao,
							dt_fim,
							dt_liberacao,
							ie_controle_tempo,
							nr_seq_hemoterapia,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec,
							cd_perfil_ativo,
							cd_pessoa_fisica,
							cd_setor_atendimento,
							ie_motivo_prescricao,
							ie_material)
						values (
							nr_sequencia_mat_w,
							nr_atendimento_w,
							cd_material_w,
							qt_dose_w,
							cd_unidade_medida_w,
							cd_mat_recons_w,
							qt_dose_recons_w,
							cd_unid_med_recons_w,
							cd_mat_dil_w,
							qt_dose_dil_w,
							cd_unid_med_dil_w,
							ds_obser_hemo_w,
							ie_via_aplicacao_w,
							cd_intervalo_w,
							hr_prim_horario_w,
							ds_horarios_w,
							dt_inicio_w,
							ie_urgencia_w,
							'P',
							'N',
							ie_administracao_w,
							dt_fim_w,
							dt_liberacao_w,
							'N',
							nr_seq_cpoe_hemo_p,
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							cd_perfil_p,
							cd_pessoa_fisica_w,
							cd_setor_atendimento_w,
							ie_motivo_prescricao_w,
							'N');
				commit;

				ds_retorno_w := 'M';
			end;
		end loop;
		close c01;
	end if;

	ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_cpoe_mat_assoc_hemo ( nr_seq_cpoe_hemo_p cpoe_hemoterapia.nr_sequencia%type, nm_usuario_p cpoe_hemoterapia.nm_usuario%type, cd_perfil_p cpoe_hemoterapia.cd_perfil_ativo%type, ds_retorno_p INOUT text) FROM PUBLIC;
