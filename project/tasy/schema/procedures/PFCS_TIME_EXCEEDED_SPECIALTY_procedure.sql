-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_time_exceeded_specialty ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


	c01 CURSOR FOR
	SELECT	x.vl_dominio ie_clinic,
			coalesce(ds_valor_dominio_cliente,ds_valor_dominio) ds_clinic
 	from	valor_dominio_v x
	where	x.cd_dominio = 17;

	c02 CURSOR(ie_clinic_p bigint)	FOR
	SELECT	a.ie_clinica ie_clinic,
		a.cd_pessoa_fisica id_patient,
		coalesce(get_formatted_person_name(a.cd_pessoa_fisica, 'list'), obter_nome_pf(a.cd_pessoa_fisica)) nm_patient,
		pfcs_obter_lista_dados_classif(a.cd_pessoa_fisica) ds_classification,
		obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_gender,
		pf.dt_nascimento dt_birthdate,
        obter_dados_pf(a.cd_pessoa_fisica, 'I') qt_idade_paciente,
		a.nr_atendimento nr_encounter,
		a.dt_entrada dt_entrance,
		round((clock_timestamp() - a.dt_entrada) * 1440) qt_time_total_pa
	from	atendimento_paciente a, pessoa_fisica pf
	where	coalesce(a.dt_atend_medico::text, '') = ''
	and	a.ie_tipo_atendimento = 3
	and	(a.ie_clinica IS NOT NULL AND a.ie_clinica::text <> '')
	and	a.ie_clinica = ie_clinic_p
	and	a.cd_estabelecimento = (cd_estabelecimento_p)::numeric
	and	a.cd_pessoa_fisica = pf.cd_pessoa_fisica
    and coalesce(a.dt_alta::text, '') = ''
	and	get_if_encounter_still_pa(a.nr_atendimento) = 'S';

	qt_patient_w				bigint := 0;
	pfcs_panel_detail_seq_w			pfcs_panel_detail.nr_sequencia%type;
	nr_seq_operational_level_w		pfcs_operational_level.nr_sequencia%type;
	nr_seq_panel_w				pfcs_panel.nr_sequencia%type;

	
BEGIN

		nr_seq_operational_level_w := pfcs_get_structure_level(
			cd_establishment_p => cd_estabelecimento_p,
			ie_level_p => 'O',
			ie_info_p => 'C');

		for c01_w in c01 loop

			begin

				for c02_w in c02(c01_w.ie_clinic) loop

					begin

						qt_patient_w := qt_patient_w + 1;

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
							ie_clinic,
							ds_clinic,
							qt_time_total_pa)
						values (
							nextval('pfcs_detail_patient_seq'),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							pfcs_panel_detail_seq_w,
							c02_w.nr_encounter,
							c02_w.dt_entrance,
							c02_w.id_patient,
							c02_w.nm_patient,
							c02_w.ds_gender,
							c02_w.ds_classification,
							c02_w.dt_birthdate,
                            c02_w.qt_idade_paciente,
							c01_w.ie_clinic,
							c01_w.ds_clinic,
							c02_w.qt_time_total_pa);

					end;

				end loop;

				commit;

				if (qt_patient_w > 0) then
					begin
					 := pfcs_pck.pfcs_generate_results(
						vl_indicator_p => qt_patient_w, cd_reference_value_p => c01_w.ie_clinic, ds_reference_value_p => c01_w.ds_clinic, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

					CALL pfcs_pck.pfcs_update_detail(
						nr_seq_indicator_p => nr_seq_indicator_p,
						nr_seq_panel_p => nr_seq_panel_w,
						nr_seq_operational_level_p => nr_seq_operational_level_w,
						nm_usuario_p => nm_usuario_p);
					end;
				end if;

				qt_patient_w := 0;
			end;

		end loop;

		CALL pfcs_pck.pfcs_activate_records(
			nr_seq_indicator_p => nr_seq_indicator_p,
			nr_seq_operational_level_p => nr_seq_operational_level_w,
			nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_time_exceeded_specialty ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;
