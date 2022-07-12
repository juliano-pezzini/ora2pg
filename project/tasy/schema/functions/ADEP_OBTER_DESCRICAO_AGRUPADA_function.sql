-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function adep_obter_descricao_agrupada as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION adep_obter_descricao_agrupada ( nr_seq_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM adep_obter_descricao_agrupada_atx ( ' || quote_nullable(nr_seq_cpoe_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION adep_obter_descricao_agrupada_atx ( nr_seq_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000);
dt_suspensao_w		timestamp;
dt_lib_suspensao_w	timestamp;
ie_tipo_proced_w	prescr_procedimento.ie_tipo_proced%type;
BEGIN

		select	max(cpoe_obter_descricao_Agrupada(
						cd_material, -- cd_material_p
						cd_mat_comp1, -- cd_mat_comp1_p
						qt_dose_comp1, -- qt_dose_comp1_p
						cd_unid_med_dose_comp1, -- cd_unid_med_dose_comp1_p
						cd_mat_comp2, -- cd_mat_comp2_p
						qt_dose_comp2, -- qt_dose_comp2_p
						cd_unid_med_dose_comp2, -- cd_unid_med_dose_comp2_p
						cd_mat_comp3, -- cd_mat_comp3_p
						qt_dose_comp3, -- qt_dose_comp3_p
						cd_unid_med_dose_comp3, -- cd_unid_med_dose_comp3_p
						cd_mat_dil, -- cd_mat_dil_p
						qt_dose_dil, -- qt_dose_dil_p
						cd_unid_med_dose_dil, -- cd_unid_med_dose_dil_p
						cd_mat_red, -- cd_mat_red_p
						qt_dose_red, -- qt_dose_red_p
						cd_unid_med_dose_red, -- cd_unid_med_dose_red_p
						dt_liberacao, -- dt_liberacao_p
						qt_dose, -- qt_dose_p
						cd_unidade_medida, -- cd_unidade_medida_p
						ie_via_aplicacao, -- ie_via_aplicacao_p
						cd_intervalo, -- cd_intervalo_p
						dt_lib_suspensao, -- dt_lib_suspensao_p
						dt_suspensao, -- dt_suspensao_p
						ie_administracao, -- ie_administracao_p
						nr_seq_ataque, -- nr_seq_ataque_p
						nr_seq_procedimento, -- nr_seq_procedimento_p
						nr_seq_adicional, -- nr_seq_adicional_p
						nr_seq_hemoterapia, -- nr_seq_hemotherapy_p
						ds_dose_diferenciada, -- ds_dose_diferenciada_p
						ds_dose_diferenciada_dil, -- ds_dose_diferenciada_dil_p
						ds_dose_diferenciada_red, -- ds_dose_diferenciada_red_p
						ds_dose_diferenciada_comp1, -- ds_dose_diferenciada_comp1_p
						ds_dose_diferenciada_comp2, -- ds_dose_diferenciada_comp2_p
						ds_dose_diferenciada_comp3, -- ds_dose_diferenciada_comp3_p
						cd_mat_comp4, -- cd_mat_comp4_p
						qt_dose_comp4, -- qt_dose_comp4_p
						cd_unid_med_dose_comp4, -- cd_unid_med_dose_comp4_p
						ds_dose_diferenciada_comp4, -- ds_dose_diferenciada_comp4_p
						cd_mat_comp5, -- cd_mat_comp5_p
						qt_dose_comp5, -- qt_dose_comp5_p
						cd_unid_med_dose_comp5, -- cd_unid_med_dose_comp5_p
						ds_dose_diferenciada_comp5, -- ds_dose_diferenciada_comp5_p
						cd_mat_comp6, -- cd_mat_comp6_p
						qt_dose_comp6, -- qt_dose_comp6_p
						cd_unid_med_dose_comp6, -- cd_unid_med_dose_comp6_p
						ds_dose_diferenciada_comp6, -- ds_dose_diferenciada_comp6_p
						dt_inicio, -- dt_inicio_p
						dt_fim, -- dt_fim_p
						dt_fim_cih, -- dt_fim_cih_p
						nr_dia_util, -- nr_dia_util_p
						ie_antibiotico, -- ie_antibiotico_p
						ie_tipo_solucao, -- ie_tipo_solucao_p
						cd_mat_comp7, -- cd_mat_comp7_p
						qt_dose_comp7, -- qt_dose_comp7_p
						cd_unid_med_dose_comp7, -- cd_unid_med_dose_comp7_p
						ds_dose_diferenciada_comp7, -- ds_dose_diferenciada_comp7_p
						null, -- cd_mat_recons_p
						null, -- qt_dose_recons_p
						null, -- cd_unid_med_dose_recons_p
						null, -- ds_dose_diferenciada_rec_p
						ds_solucao, -- ds_titulo_p
						null, -- ie_duracao_p
						null, -- ie_ref_calculo_p
						null, -- nr_etapas_p
						null, -- ie_controle_tempo_p
						null, -- qt_dias_solicitado_p
						null, -- qt_dias_liberado_p
						null, -- nr_atendimento_p
						null, -- ie_baixado_por_alta_p
						null, -- dt_alta_medico_p
						'S', -- ie_exibe_dil_p
						'S', -- ie_adep_p
						nr_sequencia, -- nr_seq_cpoe_p
						null, -- ds_horarios_p
						'SOL', -- ie_tipo_item_p
						null, -- ie_reset_atb_p
						null, -- nr_seq_cpoe_anterior_p
						ds_calc_therap_dose, -- ds_calc_therap_dose_p
						qt_final_concentration, -- qt_final_concentration_p
						ie_um_final_conc_pca, -- ie_um_final_conc_pca_p
						null, -- qt_dose_range_min_p
						null, -- qt_dose_range_max_p
						null, -- ie_dose_range_p
						ds_medic_nao_padrao, -- ds_medic_nao_padrao_p
						ie_medicacao_paciente,-- ie_medicacao_paciente_p
						qt_dose_dia)),
						max(dt_suspensao),
						max(dt_lib_suspensao)
		into STRICT		ds_retorno_w,
				dt_suspensao_w,
				dt_lib_suspensao_w
		from		cpoe_material
		where	nr_sequencia = nr_seq_cpoe_p;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_descricao_agrupada ( nr_seq_cpoe_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION adep_obter_descricao_agrupada_atx ( nr_seq_cpoe_p bigint) FROM PUBLIC;
