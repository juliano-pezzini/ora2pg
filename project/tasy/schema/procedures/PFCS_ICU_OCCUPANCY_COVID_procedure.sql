-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_icu_occupancy_covid ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_icu_p text, ie_unid_inter_p text) AS $body$
DECLARE


c01 CURSOR(cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FOR
SELECT	b.dt_entrada_unidade dt_entry_unit,
	a.cd_pessoa_fisica id_patient,
	coalesce(get_formatted_person_name(a.cd_pessoa_fisica, 'list'), obter_nome_pf(a.cd_pessoa_fisica)) nm_patient,
	pfcs_obter_lista_dados_classif(a.cd_pessoa_fisica) ds_classification,
	obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_gender,
	pf.dt_nascimento dt_birthdate,
        pfcs_get_age_range(pf.dt_nascimento) ds_age_range,
	a.nr_atendimento nr_encounter,
	a.dt_entrada dt_entrance
from	unidade_atendimento	c,
	atend_paciente_unidade	b,
	atendimento_paciente	a,
	pessoa_fisica pf
where	a.nr_atendimento	= b.nr_atendimento
and	c.cd_setor_atendimento	= cd_setor_atendimento_p
and	c.cd_unidade_basica	= cd_unidade_basica_p
and	c.cd_unidade_compl	= cd_unidade_compl_p
and	c.cd_setor_atendimento	= b.cd_setor_atendimento
and	c.cd_unidade_basica	= b.cd_unidade_basica
and	c.cd_unidade_compl	= b.cd_unidade_compl
and	b.nr_seq_interno	= obter_atepacu_paciente(c.nr_atendimento,'IAA')
and	c.ie_situacao		= 'A'
and	a.cd_pessoa_fisica	= pf.cd_pessoa_fisica;

c02 CURSOR FOR
SELECT	d.cd_setor_atendimento cd_department,
	d.ds_setor_atendimento ds_department,
	c.cd_unidade_basica || ' ' || c.cd_unidade_compl ds_location,
	substr(obter_valor_dominio(82, c.ie_status_unidade),1,255) ds_status,
	c.ie_status_unidade ie_status,
	c.ie_temporario ie_temporary,
	c.cd_unidade_basica,
	c.cd_unidade_compl,
	d.cd_classif_setor ie_type,
	c.nr_seq_interno,
	c.nr_atendimento,
	obter_cnpj_estabelecimento(coalesce(d.cd_estabelecimento,d.cd_estabelecimento_base)) cd_cnpj,
	substr(obter_nome_estabelecimento(coalesce(d.cd_estabelecimento,d.cd_estabelecimento_base)),1,255) ds_empresa,
	obter_se_leito_tem_respirador(c.cd_setor_atendimento, c.cd_unidade_basica, c.cd_unidade_compl) ie_has_respirator,
	substr(obter_valor_dominio(1, d.cd_classif_setor),1,255) ds_classification,
	d.cd_classif_setor ie_classification
from	setor_atendimento	d,
	unidade_atendimento	c
where	c.cd_setor_atendimento	= d.cd_setor_atendimento
and	c.ie_situacao		= 'A'
and	d.ie_situacao		= 'A'
and	c.ie_status_unidade in ('L','P')
and	d.cd_classif_setor = '4'
and	coalesce(d.cd_estabelecimento,d.cd_estabelecimento_base) = cd_estabelecimento_p;

c03 CURSOR FOR
SELECT	d.cd_setor_atendimento cd_department,
	d.ds_setor_atendimento ds_department,
	c.cd_unidade_basica || ' ' || c.cd_unidade_compl ds_location,
	substr(obter_valor_dominio(82, c.ie_status_unidade),1,255) ds_status,
	c.ie_status_unidade ie_status,
	c.ie_temporario ie_temporary,
	c.cd_unidade_basica,
	c.cd_unidade_compl,
	d.cd_classif_setor ie_type,
	c.nr_seq_interno,
	c.nr_atendimento,
	obter_cnpj_estabelecimento(coalesce(d.cd_estabelecimento,d.cd_estabelecimento_base)) cd_cnpj,
	substr(obter_nome_estabelecimento(coalesce(d.cd_estabelecimento,d.cd_estabelecimento_base)),1,255) ds_empresa,
	obter_se_leito_tem_respirador(c.cd_setor_atendimento, c.cd_unidade_basica, c.cd_unidade_compl) ie_has_respirator,
	substr(obter_valor_dominio(1, d.cd_classif_setor),1,255) ds_classification,
	d.cd_classif_setor ie_classification
from	setor_atendimento	d,
	unidade_atendimento	c
where	c.cd_setor_atendimento	= d.cd_setor_atendimento
and	c.ie_situacao		= 'A'
and	d.ie_situacao		= 'A'
and	c.ie_status_unidade in ('L','P')
and	d.cd_classif_setor = '3'
and	coalesce(d.cd_estabelecimento,d.cd_estabelecimento_base) = cd_estabelecimento_p;

pfcs_panel_detail_seq_w			pfcs_panel_detail.nr_sequencia%type;
pfcs_detail_bed_seq_w			pfcs_detail_bed.nr_sequencia%type;
pfcs_panel_seq_w			pfcs_panel.nr_sequencia%type;
qt_unit_w				numeric(20) := 0;
qt_unit_occupied_w			numeric(20) := 0;
qt_with_respirator_w			numeric(20) := 0;
cd_cnpj_w				estabelecimento.cd_cgc%type;
ds_empresa_w				varchar(255);
ie_achou_uti_w				varchar(1) := 'N';
ie_achou_w				varchar(1) := 'N';
nr_seq_operational_level_w  pfcs_operational_level.nr_sequencia%type;
BEGIN
nr_seq_operational_level_w := pfcs_get_structure_level(
    cd_establishment_p => cd_estabelecimento_p,
    ie_level_p => 'O',
    ie_info_p => 'C');

if (coalesce(ie_icu_p,'N') = 'S') then
	for c02_w in c02 loop
		begin

		qt_unit_w 	:= qt_unit_w + 1;
		cd_cnpj_w 	:= c02_w.cd_cnpj;
		ds_empresa_w	:= c02_w.ds_empresa;

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

		select	nextval('pfcs_detail_bed_seq')
		into STRICT	pfcs_detail_bed_seq_w
		;

		insert into pfcs_detail_bed(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_detail,
			ds_location,
			cd_department,
			ds_department,
			ds_status,
			ie_status,
			ie_type,
			ie_respirator,
			ie_classification,
			ds_classification)
		values (
			pfcs_detail_bed_seq_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			pfcs_panel_detail_seq_w,
			c02_w.ds_location,
			c02_w.cd_department,
			c02_w.ds_department,
			c02_w.ds_status,
			c02_w.ie_status,
			c02_w.ie_type,
			c02_w.ie_has_respirator,
			c02_w.ie_classification,
			c02_w.ds_classification);

		if (c02_w.ie_status = 'P') then
            qt_unit_occupied_w := qt_unit_occupied_w + 1;
			for c01_w in c01(c02_w.cd_department, c02_w.cd_unidade_basica, c02_w.cd_unidade_compl) loop
				begin

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
                    ds_age_range)
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
                    c01_w.ds_age_range);

				update pfcs_detail_bed
				set dt_entry_unit = c01_w.dt_entry_unit
				where nr_sequencia = pfcs_detail_bed_seq_w;

				end;
			end loop;

			commit;
        else
            if (coalesce(c02_w.ie_has_respirator,'N') = 'S') then
                qt_with_respirator_w := qt_with_respirator_w + 1;
            end if;
		end if;

        end;
	end loop;
end if;
if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then
	ie_achou_uti_w := 'S';
	cd_reference_aux_p => '4' := pfcs_pck.pfcs_generate_results(
		vl_indicator_p => qt_unit_occupied_w, vl_indicator_aux_p => qt_unit_w, vl_indicator_help_p => qt_with_respirator_w, ds_reference_value_p => ds_empresa_w, cd_reference_value_p => cd_cnpj_w, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w, ds_reference_aux_p => substr(obter_valor_dominio(1, 4),1,255), cd_reference_aux_p => '4');

	CALL pfcs_pck.pfcs_update_detail(
			nr_seq_indicator_p => nr_seq_indicator_p,
			nr_seq_panel_p => pfcs_panel_seq_w,
			nr_seq_operational_level_p => nr_seq_operational_level_w,
			nm_usuario_p => nm_usuario_p);

end if;

qt_unit_w		:= 0;
qt_unit_occupied_w	:= 0;
cd_cnpj_w 		:= '';
ds_empresa_w 		:= '';
qt_with_respirator_w	:= 0;

if (coalesce(ie_unid_inter_p,'N') = 'S') then
	for c03_w in c03 loop
		begin

		qt_unit_w 	:= qt_unit_w + 1;
		cd_cnpj_w 	:= c03_w.cd_cnpj;
		ds_empresa_w	:= c03_w.ds_empresa;

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

		select	nextval('pfcs_detail_bed_seq')
		into STRICT	pfcs_detail_bed_seq_w
		;

		insert into pfcs_detail_bed(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_detail,
			ds_location,
			cd_department,
			ds_department,
			ds_status,
			ie_status,
			ie_type,
			ie_respirator,
			ie_classification,
			ds_classification)
		values (
			pfcs_detail_bed_seq_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			pfcs_panel_detail_seq_w,
			c03_w.ds_location,
			c03_w.cd_department,
			c03_w.ds_department,
			c03_w.ds_status,
			c03_w.ie_status,
			c03_w.ie_type,
			c03_w.ie_has_respirator,
			c03_w.ie_classification,
			c03_w.ds_classification);

		if (c03_w.ie_status = 'P') then
            qt_unit_occupied_w := qt_unit_occupied_w + 1;
			for c01_w in c01(c03_w.cd_department, c03_w.cd_unidade_basica, c03_w.cd_unidade_compl) loop
				begin

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
                    ds_age_range)
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
                    c01_w.ds_age_range);

				update pfcs_detail_bed
				set dt_entry_unit = c01_w.dt_entry_unit
				where nr_sequencia = pfcs_detail_bed_seq_w;

				end;
			end loop;

			commit;
        else
            if (coalesce(c03_w.ie_has_respirator,'N') = 'S') then
                qt_with_respirator_w := qt_with_respirator_w + 1;
            end if;
		end if;

		end;
	end loop;

end if;

if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then
    ie_achou_w := 'S';
    cd_reference_aux_p => '3' := pfcs_pck.pfcs_generate_results(
        vl_indicator_p => qt_unit_occupied_w, vl_indicator_aux_p => qt_unit_w, vl_indicator_help_p => qt_with_respirator_w, ds_reference_value_p => ds_empresa_w, cd_reference_value_p => cd_cnpj_w, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => pfcs_panel_seq_w, ds_reference_aux_p => substr(obter_valor_dominio(1, 3),1,255), cd_reference_aux_p => '3');

    CALL pfcs_pck.pfcs_update_detail(
            nr_seq_indicator_p => nr_seq_indicator_p,
            nr_seq_panel_p => pfcs_panel_seq_w,
            nr_seq_operational_level_p => nr_seq_operational_level_w,
            nm_usuario_p => nm_usuario_p);

end if;

if (coalesce(ie_achou_w,'N') = 'S') or (coalesce(ie_achou_uti_w,'N') = 'S') then
	CALL pfcs_pck.pfcs_activate_records(
			nr_seq_indicator_p => nr_seq_indicator_p,
			nr_seq_operational_level_p => nr_seq_operational_level_w,
			nm_usuario_p => nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_icu_occupancy_covid ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_icu_p text, ie_unid_inter_p text) FROM PUBLIC;
