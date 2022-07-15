-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_calc_post_anesthetic ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_operational_level_w	pfcs_operational_level.nr_sequencia%type;
pfcs_panel_detail_seq_w		pfcs_panel_detail.nr_sequencia%type;
pfcs_detail_bed_seq_w		pfcs_detail_bed.nr_sequencia%type;
qt_total_in_use             pfcs_panel.vl_indicator%type;
nr_seq_panel_w				pfcs_panel_detail.nr_seq_panel%type;

nr_unidades_ocupadas      bigint := 0;
qt_total_unidade          bigint := 0;
nr_unidades_interditadas  bigint := 0;
nr_unidades_temp_ocupadas     bigint := 0;
nr_unidades_temporarias   bigint := 0;

c01 CURSOR FOR
	SELECT	sa.cd_setor_atendimento cd_department,
	sa.ds_setor_atendimento ds_department,
	ua.cd_unidade_basica || ' ' || ua.cd_unidade_compl ds_location,
	substr(obter_valor_dominio(82, ua.ie_status_unidade),1,255) ds_status,
	ua.ie_status_unidade cd_status,
	ua.ie_temporario ie_temporary,
	ua.cd_unidade_basica,
	ua.cd_unidade_compl
from	setor_atendimento	sa,
	unidade_atendimento	ua
where	ua.cd_setor_atendimento	= sa.cd_setor_atendimento
and	ua.ie_situacao		= 'A'
and	sa.ie_situacao		= 'A'
and ie_rpa = 'S'
and	sa.cd_estabelecimento_base = (cd_estabelecimento_p)::numeric;

c02 CURSOR(cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text)  FOR
		SELECT	apu.dt_entrada_unidade dt_entry_unit,
			ap.cd_pessoa_fisica id_patient,
			coalesce(get_formatted_person_name(ap.cd_pessoa_fisica, 'list'), obter_nome_pf(ap.cd_pessoa_fisica)) nm_patient,
			pfcs_obter_lista_dados_classif(ap.cd_pessoa_fisica) ds_classification,
			obter_sexo_pf(ap.cd_pessoa_fisica, 'D') ds_gender,
			pf.dt_nascimento dt_birthdate,
            obter_dados_pf(pf.cd_pessoa_fisica, 'I') qt_idade_paciente,
			ap.nr_atendimento nr_encounter,
			ap.dt_entrada dt_entrance,
			coalesce(get_formatted_person_name(ap.cd_medico_resp, 'capitalizeFirstLetter'), obter_nome_medico(ap.cd_medico_resp,'N')) cd_medico_resp
		from	unidade_atendimento ua,
			atend_paciente_unidade	apu,
			atendimento_paciente	ap,
			pessoa_fisica pf
		where	ap.nr_atendimento	= apu.nr_atendimento
		and	ua.cd_setor_atendimento	= cd_setor_atendimento_p
		and	ua.cd_unidade_basica	= cd_unidade_basica_p
		and	ua.cd_unidade_compl	= cd_unidade_compl_p
		and	ua.cd_setor_atendimento	= apu.cd_setor_atendimento
		and	ua.cd_unidade_basica	= apu.cd_unidade_basica
		and	ua.cd_unidade_compl	= apu.cd_unidade_compl
		and	apu.nr_seq_interno	= obter_atepacu_paciente(ap.nr_atendimento,'A')
    and coalesce(ap.dt_alta::text, '') = ''
		and	ua.ie_situacao		= 'A'
		and	ap.cd_pessoa_fisica	= pf.cd_pessoa_fisica;
BEGIN

nr_seq_operational_level_w := pfcs_get_structure_level(
									cd_establishment_p => cd_estabelecimento_p,
									ie_level_p => 'O',
									ie_info_p => 'C');

for r_c01 in c01 loop
	begin						

		select 	nextval('pfcs_panel_detail_seq')
        into STRICT 	pfcs_panel_detail_seq_w
;

    if (r_c01.ie_temporary = 'S') then
            nr_unidades_temporarias := nr_unidades_temporarias + 1;
            if (r_c01.cd_status = 'P') then
                    nr_unidades_temp_ocupadas := nr_unidades_temp_ocupadas + 1;
            end if;
    else

    if (r_c01.cd_status = 'P') then
                    nr_unidades_ocupadas := nr_unidades_ocupadas + 1;
    elsif (r_c01.cd_status in ('I', 'U')) then
                    nr_unidades_interditadas := nr_unidades_interditadas + 1;
    end if;

	end if;

    qt_total_unidade := qt_total_unidade + 1;

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

			insert into pfcs_detail_bed(
							nr_sequencia,
							nm_usuario,
							dt_atualizacao,
							nm_usuario_nrec,
							dt_atualizacao_nrec,
							nr_seq_detail,
							cd_department,
							ds_department,
							ds_location,
							ds_status,
							cd_status,
							ie_temporary)
						values (
							nextval('pfcs_detail_bed_seq'),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							pfcs_panel_detail_seq_w,
							r_c01.cd_department,
							r_c01.ds_department,
							r_c01.ds_location,
							r_c01.ds_status,
							r_c01.cd_status,
							r_c01.ie_temporary);

	for r_c02 in c02(r_c01.cd_department, r_c01.cd_unidade_basica, r_c01.cd_unidade_compl) loop
		begin

			insert into pfcs_detail_patient(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					id_patient,
					nm_patient,
					dt_birthdate,
                    ds_age_range,
					ds_gender,
					nr_encounter,
					ds_classification,
					dt_entrance,
					ds_service_line,
					nr_seq_detail)
				values (
					nextval('pfcs_detail_patient_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					r_c02.id_patient,
					r_c02.nm_patient,
					r_c02.dt_birthdate,
                    r_c02.qt_idade_paciente,
					r_c02.ds_gender,
					r_c02.nr_encounter,
					r_c02.ds_classification,
					r_c02.dt_entry_unit,
					r_c02.cd_medico_resp,
					pfcs_panel_detail_seq_w);

			update pfcs_detail_bed
			set dt_entry_unit = r_c02.dt_entry_unit
			where nr_sequencia = pfcs_detail_bed_seq_w;

			end;
		end loop;

	end;
end loop;


commit;

 := pfcs_pck.pfcs_generate_results(
	vl_indicator_p => qt_total_unidade, vl_indicator_aux_p => nr_unidades_temporarias, vl_indicator_help_p => nr_unidades_temp_ocupadas, vl_indicator_assist_p => nr_unidades_ocupadas, vl_indicator_collab_p => nr_unidades_interditadas, ds_reference_value_p => '', nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

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
-- REVOKE ALL ON PROCEDURE pfcs_calc_post_anesthetic ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

