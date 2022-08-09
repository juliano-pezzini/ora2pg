-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_rep_gerar_npt_adulta ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_funcao_origem_p funcao.cd_funcao%type, cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null) AS $body$
DECLARE

		
--- Variaveis  NUT_PAC		
cd_intervalo_w				nut_pac.cd_intervalo%type;
cd_perfil_ativo_w			nut_pac.cd_perfil_ativo%type;
ds_justificativa_w			nut_pac.ds_justificativa%type;
ds_orientacao_w				nut_pac.ds_orientacao%type;
dt_atualizacao_w			nut_pac.dt_atualizacao%type;
dt_atualizacao_nrec_w		nut_pac.dt_atualizacao_nrec%type;
dt_suspensao_w				nut_pac.dt_suspensao%type;
hr_prim_horario_w			nut_pac.hr_prim_horario%type;
ie_acm_w					nut_pac.ie_acm%type;
ie_bomba_infusao_w			nut_pac.ie_bomba_infusao%type;
ie_calculo_auto_w			nut_pac.ie_calculo_auto%type;
ie_forma_w					nut_pac.ie_forma%type;
ie_via_administracao_w		nut_pac.ie_via_administracao%type;
nm_usuario_w				nut_pac.nm_usuario%type;
nm_usuario_nrec_w			nut_pac.nm_usuario_nrec%type;
nm_usuario_susp_w			nut_pac.nm_usuario_susp%type;
nr_seq_fator_ativ_w			nut_pac.nr_seq_fator_ativ%type;
nr_seq_fator_stress_w		nut_pac.nr_seq_fator_stress%type;
nr_seq_protocolo_w			nut_pac.nr_seq_protocolo%type;
pr_carboidrato_w			nut_pac.pr_carboidrato%type;
pr_conc_glic_solucao_w		nut_pac.pr_conc_glic_solucao%type;
pr_conc_lipidio_solucao_w	nut_pac.pr_conc_lipidio_solucao%type;
pr_conc_proteina_solucao_w	nut_pac.pr_conc_proteina_solucao%type;
pr_lipidio_w				nut_pac.pr_lipidio%type;
pr_npt_w					nut_pac.pr_npt%type;
pr_proteina_w				nut_pac.pr_proteina%type;
qt_altura_cm_w				nut_pac.qt_altura_cm%type;
qt_descontar_hidrico_w		nut_pac.qt_descontar_hidrico%type;
qt_dia_npt_w				nut_pac.qt_dia_npt%type;
qt_fase_npt_w				nut_pac.qt_fase_npt%type;
qt_gotejo_npt_w				nut_pac.qt_gotejo_npt%type;
qt_grama_nitrogenio_w		nut_pac.qt_grama_nitrogenio%type;
qt_grama_proteina_kg_dia_w	nut_pac.qt_grama_proteina_kg_dia%type;
qt_hora_inf_w				nut_pac.qt_hora_inf%type;
qt_idade_ano_w				nut_pac.qt_idade_ano%type;
qt_idade_dia_w				nut_pac.qt_idade_dia%type;
qt_idade_mes_w				nut_pac.qt_idade_mes%type;
qt_kcal_carboidrato_w		nut_pac.qt_kcal_carboidrato%type;
qt_kcal_kg_w				nut_pac.qt_kcal_kg%type;
qt_kcal_lipidio_w			nut_pac.qt_kcal_lipidio%type;
qt_kcal_nao_proteico_w		nut_pac.qt_kcal_nao_proteico%type;
qt_kcal_proteico_w			nut_pac.qt_kcal_proteico%type;
qt_kcal_proteina_w			nut_pac.qt_kcal_proteina%type;
qt_kcal_total_w				nut_pac.qt_kcal_total%type;
qt_kcal_total_origem_w		nut_pac.qt_kcal_total_origem%type;
qt_min_inf_w				nut_pac.qt_min_inf%type;
qt_multiplicador_w			nut_pac.qt_multiplicador%type;
qt_nec_hidrica_diaria_w		nut_pac.qt_nec_hidrica_diaria%type;
qt_nec_hidrica_diaria_ped_w	nut_pac.qt_nec_hidrica_diaria_ped%type;
qt_nec_kcal_dia_w			nut_pac.qt_nec_kcal_dia%type;
qt_nec_kcal_kg_dia_w		nut_pac.qt_nec_kcal_kg_dia%type;
qt_osmolaridade_total_w		nut_pac.qt_osmolaridade_total%type;
qt_peso_w					nut_pac.qt_peso%type;
qt_peso_ajustado_w			nut_pac.qt_peso_ajustado%type;
qt_peso_calorico_w			nut_pac.qt_peso_calorico%type;
qt_peso_ideal_w				nut_pac.qt_peso_ideal%type;
qt_rel_cal_nit_w			nut_pac.qt_rel_cal_nit%type;
qt_tmb_w					nut_pac.qt_tmb%type;
qt_vel_inf_glicose_w		nut_pac.qt_vel_inf_glicose%type;
qt_volume_diario_w			nut_pac.qt_volume_diario%type;
nr_seq_nut_pac_w			nut_pac.nr_sequencia%type;

--- Variaveis NUT_PAC_ELEMENTO
nr_seq_elemento_w			nut_pac_elemento.nr_seq_elemento%type;
cd_unidade_medida_w			nut_pac_elemento.cd_unidade_medida%type;
qt_elem_kg_dia_w			nut_pac_elemento.qt_elem_kg_dia%type;
qt_diaria_w					nut_pac_elemento.qt_diaria%type;
pr_total_w					nut_pac_elemento.pr_total%type;
qt_kcal_w					nut_pac_elemento.qt_kcal%type;
ie_prim_fase_w				nut_pac_elemento.ie_prim_fase%type;
ie_seg_fase_w				nut_pac_elemento.ie_seg_fase%type;
ie_terc_fase_w				nut_pac_elemento.ie_terc_fase%type;
ie_npt_w					nut_pac_elemento.ie_npt%type;
qt_osmolaridade_w			nut_pac_elemento.qt_osmolaridade%type;
qt_protocolo_w				nut_pac_elemento.qt_protocolo%type;
ie_unid_med_w				nut_pac_elemento.ie_unid_med%type;
pr_concentracao_w			nut_pac_elemento.pr_concentracao%type;
ie_prod_adicional_w			nut_pac_elemento.ie_prod_adicional%type;
qt_volume_final_w			nut_pac_elemento.qt_volume_final%type;
ie_quar_fase_w				nut_pac_elemento.ie_quar_fase%type;
ie_editado_w				nut_pac_elemento.ie_editado%type;

--- Variaveis NUT_PAC_ELEM_MAT
nr_seq_elem_mat_w			nut_pac_elem_mat.nr_seq_elem_mat%type;
nr_seq_elem_mat_ww			nut_pac_elem_mat.nr_seq_elem_mat%type;
qt_volume_w					nut_pac_elem_mat.qt_volume%type;
qt_vol_1_fase_w				nut_pac_elem_mat.qt_vol_1_fase%type;
qt_vol_2_fase_w				nut_pac_elem_mat.qt_vol_2_fase%type;
qt_vol_3_fase_w				nut_pac_elem_mat.qt_vol_3_fase%type;
qt_vol_cor_w				nut_pac_elem_mat.qt_vol_cor%type;
cd_material_w				nut_pac_elem_mat.cd_material%type;
qt_dose_w					nut_pac_elem_mat.qt_dose%type;
ie_somar_volume_w			nut_pac_elem_mat.ie_somar_volume%type;
qt_vol_4_fase_w				nut_pac_elem_mat.qt_vol_4_fase%type;
ie_supera_limite_uso_w		nut_pac_elem_mat.ie_supera_limite_uso%type;

--- Variaveis CPOE
nr_seq_npt_cpoe_w			cpoe_dieta.nr_sequencia%type;
qt_tempo_aplic_w			cpoe_dieta.qt_tempo_aplic%type;
dt_inicio_w					cpoe_dieta.dt_inicio%type;

nr_seq_npt_cpoe_elem_w		cpoe_npt_elemento.nr_sequencia%type;
ie_tipo_elemento_w			cpoe_npt_elemento.ie_tipo_elemento%type;

nr_seq_npt_cpoe_prod_w		cpoe_npt_produto.nr_sequencia%type;

ie_retrogrado_w			prescr_medica.ie_prescr_emergencia%type;		
cd_pessoa_fisica_w		prescr_medica.cd_pessoa_fisica%type;
dt_liberacao_enf_w		timestamp;
nm_usuario_lib_enf_w	prescr_medica.nm_usuario_lib_enf%type;
cd_medico_w				prescr_medica.cd_medico%type;

c01 CURSOR FOR   --- Busca os dados principais da NPT
SELECT	nr_sequencia,
	cd_intervalo,
	cd_perfil_ativo,
	ds_justificativa,
	ds_orientacao,
	dt_atualizacao,
	dt_atualizacao_nrec,
	dt_suspensao,
	hr_prim_horario,
	ie_acm,
	ie_bomba_infusao,
	ie_calculo_auto,
	ie_forma,
	ie_via_administracao,
	nm_usuario,
	nm_usuario_nrec,
	nm_usuario_susp,
	nr_seq_fator_ativ,
	nr_seq_fator_stress,
	nr_seq_protocolo,
	pr_carboidrato,
	pr_conc_glic_solucao,
	pr_conc_lipidio_solucao,
	pr_conc_proteina_solucao,
	pr_lipidio,
	pr_npt,
	pr_proteina,
	qt_altura_cm,
	qt_descontar_hidrico,
	qt_dia_npt,
	qt_fase_npt,
	qt_gotejo_npt,
	qt_grama_nitrogenio,
	qt_grama_proteina_kg_dia,
	qt_hora_inf,
	qt_idade_ano,
	qt_idade_dia,
	qt_idade_mes,
	qt_kcal_carboidrato,
	qt_kcal_kg,
	qt_kcal_lipidio,
	qt_kcal_nao_proteico,
	qt_kcal_proteico,
	qt_kcal_proteina,
	qt_kcal_total,
	qt_min_inf,
	qt_osmolaridade_total,
	qt_peso,
	qt_peso_ajustado,
	qt_peso_ideal,
	qt_rel_cal_nit,
	qt_tmb,
	qt_vel_inf_glicose,
	qt_volume_diario
from	nut_pac
where	nr_prescricao = nr_prescricao_p
and	coalesce(ie_npt_adulta,'S') = 'S';

c02 CURSOR FOR   --- Busca os elementos
SELECT	nr_seq_elemento,
	dt_atualizacao,
	nm_usuario,
	cd_unidade_medida,
	qt_elem_kg_dia,
	qt_diaria,
	pr_total,
	qt_kcal,
	ie_prim_fase,
	ie_seg_fase,
	ie_terc_fase,
	ie_npt,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	qt_osmolaridade,
	qt_protocolo,
	ie_unid_med,
	pr_concentracao,
	ie_prod_adicional,
	qt_volume_final,
	ie_quar_fase,
	ie_editado,
	qt_grama_nitrogenio
from	nut_pac_elemento
where	nr_seq_nut_pac = nr_seq_nut_pac_w;

c03 CURSOR FOR   --- Busca os produtos
SELECT	cd_material,
	dt_atualizacao,
	nm_usuario,
	nr_seq_elem_mat,
	qt_volume,
	qt_vol_1_fase,
	qt_vol_2_fase,
	qt_vol_3_fase,
	qt_vol_cor,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	qt_protocolo,
	qt_dose,
	cd_unidade_medida,
	ie_prod_adicional,
	ie_somar_volume,
	qt_vol_4_fase,
	ie_supera_limite_uso
from	nut_pac_elem_mat
where	nr_seq_nut_pac = nr_seq_nut_pac_w;
		

BEGIN

select 	max(coalesce(ie_prescr_emergencia,'N')),
		max(cd_pessoa_fisica),
		max(dt_liberacao),
		max(nm_usuario_lib_enf),
		max(cd_medico)
into STRICT	ie_retrogrado_w,
		cd_pessoa_fisica_w,
		dt_liberacao_enf_w,
		nm_usuario_lib_enf_w,
		cd_medico_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

open c01;
loop
fetch c01 into	nr_seq_nut_pac_w,
		cd_intervalo_w,
		cd_perfil_ativo_w,
		ds_justificativa_w,
		ds_orientacao_w,
		dt_atualizacao_w,
		dt_atualizacao_nrec_w,
		dt_suspensao_w,
		hr_prim_horario_w,
		ie_acm_w,
		ie_bomba_infusao_w,
		ie_calculo_auto_w,
		ie_forma_w,
		ie_via_administracao_w,
		nm_usuario_w,
		nm_usuario_nrec_w,
		nm_usuario_susp_w,
		nr_seq_fator_ativ_w,
		nr_seq_fator_stress_w,
		nr_seq_protocolo_w,
		pr_carboidrato_w,
		pr_conc_glic_solucao_w,
		pr_conc_lipidio_solucao_w,
		pr_conc_proteina_solucao_w,
		pr_lipidio_w,
		pr_npt_w,
		pr_proteina_w,
		qt_altura_cm_w,
		qt_descontar_hidrico_w,
		qt_dia_npt_w,
		qt_fase_npt_w,
		qt_gotejo_npt_w,
		qt_grama_nitrogenio_w,
		qt_grama_proteina_kg_dia_w,
		qt_hora_inf_w,
		qt_idade_ano_w,
		qt_idade_dia_w,
		qt_idade_mes_w,
		qt_kcal_carboidrato_w,
		qt_kcal_kg_w,
		qt_kcal_lipidio_w,
		qt_kcal_nao_proteico_w,
		qt_kcal_proteico_w,
		qt_kcal_proteina_w,
		qt_kcal_total_w,
		qt_min_inf_w,
		qt_osmolaridade_total_w,
		qt_peso_w,
		qt_peso_ajustado_w,
		qt_peso_ideal_w,
		qt_rel_cal_nit_w,
		qt_tmb_w,
		qt_vel_inf_glicose_w,
		qt_volume_diario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> '  :  ')then
		dt_inicio_w := trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_p, hr_prim_horario_w), 'mi');
	else
		dt_inicio_w := dt_inicio_prescr_p;
	end if;
	
	if (qt_min_inf_w IS NOT NULL AND qt_min_inf_w::text <> '' AND qt_hora_inf_w IS NOT NULL AND qt_hora_inf_w::text <> '') then
		
		if (qt_hora_inf_w > 24) then
			qt_hora_inf_w := 24;
			qt_min_inf_w := 00;
		elsif (qt_hora_inf_w = 24) then
			qt_min_inf_w := 00;
		end if;
		
		if (qt_min_inf_w > 59) and (qt_hora_inf_w < 24) then
			qt_hora_inf_w := 59;
		elsif (qt_min_inf_w > 59) then
			qt_hora_inf_w := 00;
		end if;
	
		qt_tempo_aplic_w := qt_hora_inf_w||':'||qt_min_inf_w;
	else
		qt_tempo_aplic_w := '24:00';
	end if;
	
	select	nextval('cpoe_dieta_seq')
	into STRICT	nr_seq_npt_cpoe_w
	;
	
	insert into cpoe_dieta(
			nr_sequencia,
			ie_tipo_dieta,
			nr_atendimento,
			cd_intervalo,
			cd_perfil_ativo,
			ds_justificativa,
			ds_orientacao,
			dt_atualizacao,
			dt_atualizacao_nrec,
			dt_suspensao,
			hr_prim_horario,
			ie_acm,
			ie_bomba_infusao,
			ie_calculo_auto,
			ie_forma,
			ie_via_administracao,
			nm_usuario,
			nm_usuario_nrec,
			nm_usuario_susp,
			nr_seq_fator_ativ,
			nr_seq_fator_stress,
			nr_seq_protocolo,
			pr_carboidrato,
			pr_conc_glic_solucao,
			pr_conc_lipidio_solucao,
			pr_conc_proteina_solucao,
			pr_lipidio,
			pr_proteina,
			qt_altura_cm,
			qt_dia_npt,
			qt_fase_npt,
			qt_gotejo_npt,
			qt_grama_nitrogenio,
			qt_grama_proteina_kg_dia,
			qt_idade_ano,
			qt_idade_dia,
			qt_idade_mes,
			qt_kcal_carboidrato,
			qt_kcal_kg,
			qt_kcal_lipidio,
			qt_kcal_nao_proteico,
			qt_kcal_proteico,
			qt_kcal_proteina,
			qt_kcal_total,
			qt_osmolaridade_total,
			qt_peso,
			qt_peso_ajustado,
			qt_peso_ideal,
			qt_rel_cal_nit,
			qt_tmb,
			qt_vel_inf_glicose,
			qt_volume_diario,
			qt_tempo_aplic,
			ie_administracao,
			ie_duracao,
			dt_inicio,
			dt_fim,
			dt_prox_geracao,
			dt_liberacao,
			cd_funcao_origem,
			cd_setor_atendimento,
			ie_retrogrado,
			cd_pessoa_fisica,
			dt_liberacao_enf,
			nm_usuario_lib_enf,
			cd_medico)
		values (
			nr_seq_npt_cpoe_w,
			'P',
			nr_atendimento_p,
			cd_intervalo_w,
			cd_perfil_ativo_w,
			ds_justificativa_w,
			ds_orientacao_w,
			dt_atualizacao_w,
			dt_atualizacao_nrec_w,
			dt_suspensao_w,
			hr_prim_horario_w,
			ie_acm_w,
			ie_bomba_infusao_w,
			ie_calculo_auto_w,
			ie_forma_w,
			ie_via_administracao_w,
			nm_usuario_w,
			nm_usuario_nrec_w,
			nm_usuario_susp_w,
			nr_seq_fator_ativ_w,
			nr_seq_fator_stress_w,
			nr_seq_protocolo_w,
			pr_carboidrato_w,
			pr_conc_glic_solucao_w,
			pr_conc_lipidio_solucao_w,
			pr_conc_proteina_solucao_w,
			pr_lipidio_w,
			pr_proteina_w,
			qt_altura_cm_w,
			qt_dia_npt_w,
			qt_fase_npt_w,
			qt_gotejo_npt_w,
			qt_grama_nitrogenio_w,
			qt_grama_proteina_kg_dia_w,
			qt_idade_ano_w,
			qt_idade_dia_w,
			qt_idade_mes_w,
			qt_kcal_carboidrato_w,
			qt_kcal_kg_w,
			qt_kcal_lipidio_w,
			qt_kcal_nao_proteico_w,
			qt_kcal_proteico_w,
			qt_kcal_proteina_w,
			qt_kcal_total_w,
			qt_osmolaridade_total_w,
			qt_peso_w,
			qt_peso_ajustado_w,
			qt_peso_ideal_w,
			qt_rel_cal_nit_w,
			qt_tmb_w,
			qt_vel_inf_glicose_w,
			qt_volume_diario_w,
			qt_tempo_aplic_w,
			'P',
			'P',
			dt_inicio_w,
			dt_validade_prescr_p,
			dt_inicio_w + 12/24,
			dt_liberacao_p,
			cd_funcao_origem_p,
			cd_setor_atendimento_p,
			ie_retrogrado_w,
			cd_pessoa_fisica_w,
			dt_liberacao_enf_w,
			nm_usuario_lib_enf_w,
			cd_medico_w);
	
	update	nut_pac
	set	nr_seq_npt_cpoe = nr_seq_npt_cpoe_w
	where	nr_sequencia = nr_seq_nut_pac_w
	and	nr_prescricao = nr_prescricao_p;
			
	open c02;
	loop
	fetch c02 into	nr_seq_elemento_w,
			dt_atualizacao_w,
			nm_usuario_w,
			cd_unidade_medida_w,
			qt_elem_kg_dia_w,
			qt_diaria_w,
			pr_total_w,
			qt_kcal_w,
			ie_prim_fase_w,
			ie_seg_fase_w,
			ie_terc_fase_w,
			ie_npt_w,
			dt_atualizacao_nrec_w,
			nm_usuario_nrec_w,
			qt_osmolaridade_w,
			qt_protocolo_w,
			ie_unid_med_w,
			pr_concentracao_w,
			ie_prod_adicional_w,
			qt_volume_final_w,
			ie_quar_fase_w,
			ie_editado_w,
			qt_grama_nitrogenio_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		
		select	max(ie_tipo_elemento)
		into STRICT	ie_tipo_elemento_w
		from	nut_elemento
		where	nr_sequencia = nr_seq_elemento_w;
		
		select	nextval('cpoe_npt_elemento_seq')
		into STRICT	nr_seq_npt_cpoe_elem_w
		;
		
		insert into cpoe_npt_elemento(
				nr_sequencia,
				nr_seq_npt_cpoe,
				nr_seq_elemento,
				dt_atualizacao,
				nm_usuario,
				cd_unidade_medida,
				qt_elem_kg_dia,
				qt_diaria,
				pr_total,
				qt_kcal,
				ie_prim_fase,
				ie_seg_fase,
				ie_terc_fase,
				ie_npt,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				qt_osmolaridade,
				qt_protocolo,
				ie_unid_med,
				pr_concentracao,
				ie_prod_adicional,
				qt_volume_final,
				ie_quar_fase,
				ie_editado,
				qt_grama_nitrogenio,
				ie_tipo_elemento)
			values (
				nr_seq_npt_cpoe_elem_w,
				nr_seq_npt_cpoe_w,
				nr_seq_elemento_w,
				dt_atualizacao_w,
				nm_usuario_w,
				cd_unidade_medida_w,
				qt_elem_kg_dia_w,
				qt_diaria_w,
				pr_total_w,
				qt_kcal_w,
				ie_prim_fase_w,
				ie_seg_fase_w,
				ie_terc_fase_w,
				ie_npt_w,
				dt_atualizacao_nrec_w,
				nm_usuario_nrec_w,
				qt_osmolaridade_w,
				qt_protocolo_w,
				ie_unid_med_w,
				pr_concentracao_w,
				ie_prod_adicional_w,
				qt_volume_final_w,
				ie_quar_fase_w,
				ie_editado_w,
				qt_grama_nitrogenio_w,
				ie_tipo_elemento_w);
				
		end;
	end loop;
	close c02;
	
	open c03;
	loop
	fetch c03 into 	cd_material_w,
			dt_atualizacao_w,
			nm_usuario_w,
			nr_seq_elem_mat_w,
			qt_volume_w,
			qt_vol_1_fase_w,
			qt_vol_2_fase_w,
			qt_vol_3_fase_w,
			qt_vol_cor_w,
			dt_atualizacao_nrec_w,
			nm_usuario_nrec_w,
			qt_protocolo_w,
			qt_dose_w,
			cd_unidade_medida_w,
			ie_prod_adicional_w,
			ie_somar_volume_w,
			qt_vol_4_fase_w,
			ie_supera_limite_uso_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		
		select	max(a.nr_sequencia),
			max(b.nr_sequencia)
		into STRICT	nr_seq_npt_cpoe_elem_w,
			nr_seq_elem_mat_ww
		from	cpoe_npt_elemento a,
			nut_elem_material b
		where	a.nr_seq_elemento = b.nr_seq_elemento
		and	b.cd_material = cd_material_w
		and	a.nr_seq_npt_cpoe = nr_seq_npt_cpoe_w;
		
		select	nextval('cpoe_npt_produto_seq')
		into STRICT	nr_seq_npt_cpoe_prod_w
		;
		
		insert into cpoe_npt_produto(
					nr_sequencia,
					nr_seq_npt_cpoe,
					nr_seq_elemento,
					cd_material,
					dt_atualizacao,
					nm_usuario,
					nr_seq_elem_mat,
					qt_volume,
					qt_vol_1_fase,
					qt_vol_2_fase,
					qt_vol_3_fase,
					qt_vol_cor,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					qt_protocolo,
					qt_dose,
					cd_unidade_medida,
					ie_prod_adicional,
					ie_somar_volume,
					qt_vol_4_fase,
					ie_supera_limite_uso)
				values (
					nr_seq_npt_cpoe_prod_w,
					nr_seq_npt_cpoe_w,
					nr_seq_npt_cpoe_elem_w,
					cd_material_w,
					dt_atualizacao_w,
					nm_usuario_w,
					coalesce(nr_seq_elem_mat_w,nr_seq_elem_mat_ww),
					qt_volume_w,
					qt_vol_1_fase_w,
					qt_vol_2_fase_w,
					qt_vol_3_fase_w,
					qt_vol_cor_w,
					dt_atualizacao_nrec_w,
					nm_usuario_nrec_w,
					qt_protocolo_w,
					qt_dose_w,
					cd_unidade_medida_w,
					ie_prod_adicional_w,
					ie_somar_volume_w,
					qt_vol_4_fase_w,
					ie_supera_limite_uso_w);
	
		end;
	end loop;
	close c03;	
	end;
end loop;
close c01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_rep_gerar_npt_adulta ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_funcao_origem_p funcao.cd_funcao%type, cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null) FROM PUBLIC;
