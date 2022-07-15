-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_calculate_box_time_total ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


	c01 CURSOR FOR

	SELECT	x.nr_sequencia cd_group_pa,
		x.ds_grupo ds_group_pa,
		y.nr_sequencia,
		y.ds_local ds_unit_pa,
		a.cd_pessoa_fisica id_patient,
		coalesce(get_formatted_person_name(a.cd_pessoa_fisica, 'list'), obter_nome_pf(a.cd_pessoa_fisica)) nm_patient,
		pfcs_obter_lista_dados_classif(a.cd_pessoa_fisica) ds_classification,
		obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_gender,
		a.dt_nascimento dt_birthdate,
        obter_dados_pf(a.cd_pessoa_fisica, 'I') qt_idade_paciente,
		a.dt_entrada dt_entrance,
		a.nr_atendimento nr_encounter,
		z.qt_time qt_time_rule,
		round(((clock_timestamp() - a.dt_entrada) * 1440)) qt_time_box_pa
	FROM pa_local y, pep_atendimento_ps_v a, pa_grupo_local x
LEFT OUTER JOIN pfcs_time_unit_pa z ON (x.nr_sequencia = z.cd_rule)
WHERE y.nr_seq_grupo_pa = x.nr_sequencia and y.nr_sequencia = a.nr_seq_local_pa  and y.ie_situacao = 'A' and x.ie_situacao = 'A' and a.cd_estabelecimento = (cd_estabelecimento_p)::numeric and x.cd_estabelecimento = (cd_estabelecimento_p)::numeric and get_if_encounter_still_pa(a.nr_atendimento) = 'S' and coalesce(a.dt_alta::text, '') = ''
     
union
 
        SELECT	null cd_group_pa,
            obter_desc_expressao(344145,null) ds_group_pa,
            y.nr_sequencia,
            y.ds_local ds_unit_pa,
            a.cd_pessoa_fisica id_patient,
            coalesce(get_formatted_person_name(a.cd_pessoa_fisica, 'list'), obter_nome_pf(a.cd_pessoa_fisica)) nm_patient,
            pfcs_obter_lista_dados_classif(a.cd_pessoa_fisica) ds_classification,
            obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_gender,
            a.dt_nascimento dt_birthdate,
            obter_dados_pf(a.cd_pessoa_fisica, 'I') qt_idade_paciente,
            a.dt_entrada dt_entrance, 
            a.nr_atendimento nr_encounter,
            null qt_time_rule,
            round(((clock_timestamp() - a.dt_entrada) * 1440)) qt_time_box_pa
        from	
            pa_local y,
            pep_atendimento_ps_v a
        where	y.nr_sequencia = a.nr_seq_local_pa
        and coalesce(y.nr_seq_grupo_pa::text, '') = ''
        and	y.ie_situacao = 'A'
        and	a.cd_estabelecimento = (cd_estabelecimento_p)::numeric 
        and	get_if_encounter_still_pa(a.nr_atendimento) = 'S'
        and coalesce(a.dt_alta::text, '') = '';

	qt_total_above_rule_w				bigint := 0;
	qt_total_below_rule_w				bigint := 0;
	ie_over_threshold_w				varchar(1) := 'N';
	pfcs_panel_detail_seq_w				pfcs_panel_detail.nr_sequencia%type;
	nr_seq_operational_level_w			pfcs_operational_level.nr_sequencia%type;
	nr_seq_panel_w					pfcs_panel.nr_sequencia%type;

	
BEGIN

		nr_seq_operational_level_w := pfcs_get_structure_level(
				cd_establishment_p => cd_estabelecimento_p,
				ie_level_p => 'O',
				ie_info_p => 'C');

		for c01_w in c01 loop

			begin

				if (c01_w.qt_time_rule IS NOT NULL AND c01_w.qt_time_rule::text <> '') and (c01_w.qt_time_rule < c01_w.qt_time_box_pa) then
					qt_total_above_rule_w := qt_total_above_rule_w + 1;
					ie_over_threshold_w := 'S';
				else
					qt_total_below_rule_w := qt_total_below_rule_w + 1;
					ie_over_threshold_w := 'N';
				end if;

				select	nextval('pfcs_panel_detail_seq')
				into STRICT	pfcs_panel_detail_seq_w
				;

				insert into pfcs_panel_detail(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					ie_situation,
					nr_seq_indicator,
					nr_seq_operational_level)
				values (
					pfcs_panel_detail_seq_w,
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					'T',
					nr_seq_indicator_p,
					nr_seq_operational_level_w);

				insert into pfcs_detail_patient(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_detail,
					nr_encounter,
					dt_entrance,
					id_patient,
					nm_patient,
					ds_gender,
					ds_classification,
					dt_birthdate,
                    ds_age_range,
					cd_group_pa,
					ds_group_pa,
					ds_unit_pa,
					qt_time_box_pa,
					ie_over_threshold)
				values (
					nextval('pfcs_detail_patient_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					pfcs_panel_detail_seq_w,
					c01_w.nr_encounter,
					c01_w.dt_entrance,
					c01_w.id_patient,
					c01_w.nm_patient,
					c01_w.ds_gender,
					c01_w.ds_classification,
					c01_w.dt_birthdate,
                    c01_w.qt_idade_paciente,
					c01_w.cd_group_pa,
					c01_w.ds_group_pa,
					c01_w.ds_unit_pa,
					c01_w.qt_time_box_pa,
					ie_over_threshold_w);

			end;

		end loop;

		commit;

		 := pfcs_pck.pfcs_generate_results(
				vl_indicator_p => qt_total_above_rule_w, vl_indicator_aux_p => qt_total_below_rule_w, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

		CALL pfcs_pck.pfcs_update_detail(
				nr_seq_indicator_p => nr_seq_indicator_p,
				nr_seq_panel_p => nr_seq_panel_w,
				nr_seq_operational_level_p => nr_seq_operational_level_w,
				nm_usuario_p => nm_usuario_p);

		CALL pfcs_pck.pfcs_activate_records(
				nr_seq_indicator_p => nr_seq_indicator_p,
				nr_seq_operational_level_p => nr_seq_operational_level_w,
				nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_calculate_box_time_total ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

