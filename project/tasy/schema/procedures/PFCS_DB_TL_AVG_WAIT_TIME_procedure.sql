-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_db_tl_avg_wait_time ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	nr_total_sequence_w                 bigint := 0;
	nr_average_time_w                   pfcs_panel.vl_indicator%type;
	nr_seq_operational_level_w          bigint := 0;
	nr_total_time_avg_w                 bigint := 0;
	nr_seq_panel_w                      pfcs_panel_detail.nr_seq_panel%type;

	--Cursor to fetch location
    cur_get_unit_for_pfcs CURSOR FOR
        SELECT count(1) total,
               sa.ds_setor_atendimento ds_department
        from
            pfcs_encounter enc,
            pfcs_patient pat,
            pfcs_encounter_location el,
            unidade_atendimento uni,
            setor_atendimento sa
		where enc.si_status in ('PLANNED', 'ARRIVED')
			and enc.nr_seq_patient = pat.nr_sequencia
			and pat.ie_active = '1'
			and el.nr_seq_encounter = enc.nr_sequencia
			and el.nr_seq_location = uni.nr_seq_location
      and uni.ie_situacao = 'A'
      and uni.cd_setor_atendimento = sa.cd_setor_atendimento
      and sa.ie_situacao = 'A'
      and sa.cd_classif_setor = '3'
      and sa.cd_estabelecimento_base = cd_estabelecimento_p
      group by sa.ds_setor_atendimento;

	/* Cursor to read from pfcs integration tables */

	cur_get_recom_time_pfcs CURSOR(nr_seq_location_p text) FOR
		SELECT sr.nr_sequencia,
               pfcs_get_tele_time(sr.nr_sequencia, 'R') nr_req_wait_time
		from pfcs_service_request sr,
			pfcs_encounter enc,
			pfcs_patient pat,
            pfcs_encounter_location el,
            unidade_atendimento uni,
            setor_atendimento sa
		where
			sr.si_status = 'ACTIVE'
			and sr.cd_service = 'E0404'
			and sr.nr_seq_encounter = enc.nr_sequencia
			and enc.si_status in ('PLANNED', 'ARRIVED')
			and enc.nr_seq_patient = pat.nr_sequencia
			and pat.ie_active = '1'
            and el.nr_seq_encounter = enc.nr_sequencia
			and el.nr_seq_location =  uni.nr_seq_location
			and pat.nr_sequencia not in (
				SELECT dev.nr_seq_patient
				from pfcs_device dev
				where dev.si_status = 'ACTIVE'
					and dev.ds_device_type = 'Monitor'
					and (dev.nr_seq_patient IS NOT NULL AND dev.nr_seq_patient::text <> '')
			)
            and uni.ie_situacao = 'A'
            and uni.cd_setor_atendimento = sa.cd_setor_atendimento
            and sa.ie_situacao = 'A'
            and sa.cd_classif_setor = '3'
            and sa.cd_estabelecimento_base = cd_estabelecimento_p
            and sa.ds_setor_atendimento = nr_seq_location_p;
BEGIN
	for cur_get_location_for_pfcs in cur_get_unit_for_pfcs loop
	begin
		nr_total_sequence_w  := 0;
		nr_total_time_avg_w := 0;
		for rec_get_recom_time in cur_get_recom_time_pfcs(cur_get_location_for_pfcs.ds_department) loop
		begin
			nr_total_sequence_w  := nr_total_sequence_w + 1;
			nr_total_time_avg_w  := nr_total_time_avg_w + rec_get_recom_time.nr_req_wait_time;
		end;
		end loop;

		if (nr_total_sequence_w = 0) then
			nr_average_time_w := 0;
		else
			nr_average_time_w := round(nr_total_time_avg_w / nr_total_sequence_w);
		end if;

		 := pfcs_pck_v2.pfcs_generate_results(
		vl_indicator_p => nr_average_time_w, ds_reference_value_p => cur_get_location_for_pfcs.ds_department, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => cd_estabelecimento_p, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);
	end;
	end loop;

	CALL pfcs_pck_v2.pfcs_activate_records(
		nr_seq_indicator_p => nr_seq_indicator_p,
		nr_seq_operational_level_p => cd_estabelecimento_p,
		nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_db_tl_avg_wait_time ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

