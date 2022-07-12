-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_emergency_department.calc_encounters_histogram (cd_establishment_p bigint, nm_user_p text) AS $body$
DECLARE

		pfcs_panel_seq_w	pfcs_panel.nr_sequencia%type;
		qt_hours_w			integer := 22;
		qt_weeks_w			integer := 4;
		qt_rows_w			integer := 0;
		ds_hour_w			varchar(64);
		dt_actual_w			timestamp;
		dt_start_w			timestamp;
		type  qt_encounters_w is table of bigint index by varchar(64);
		hours_w	qt_encounters_w;
		
		cur_encounters CURSOR FOR
		SELECT
			coalesce(hst.dt_period_start,hst.dt_atualizacao) period_start, 
			coalesce(case when enc.period_end <> hst.dt_period_end then
						enc.period_end else
						hst.dt_period_end end, clock_timestamp()) period_end,
			hst.nr_seq_encounter,
			sec.cd_classif_setor
		from
			pfcs_patient_loc_hist hst
			inner join unidade_atendimento uni on uni.nr_seq_location = hst.nr_seq_location
			inner join setor_atendimento sec  on sec.cd_setor_atendimento = uni.cd_setor_atendimento
			inner join pfcs_encounter enc on enc.nr_sequencia = hst.nr_seq_encounter
		where 
			coalesce(hst.dt_period_end,clock_timestamp()) between trunc(clock_timestamp() - interval '30 days') and clock_timestamp()
			and hst.ie_situacao = PFCS_PCK_CONSTANTS.IE_ACTIVE
			and hst.si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
			and (hst.dt_period_start IS NOT NULL AND hst.dt_period_start::text <> '')
			and sec.cd_classif_setor = PFCS_PCK_CONSTANTS.CD_ED
			and sec.cd_estabelecimento = cd_establishment_p
		group by
			coalesce(hst.dt_period_start,hst.dt_atualizacao), 
			coalesce(case when enc.period_end <> hst.dt_period_end then
						enc.period_end else
						hst.dt_period_end end, clock_timestamp()),
			hst.nr_seq_encounter,
			sec.cd_classif_setor;


BEGIN

		dt_start_w := to_date(to_char(clock_timestamp(), 'MM-DD-YY HH24'),'MM-DD-YY HH24');

        for c01_w in cur_encounters loop

            for qt_hours_increment in 0 .. qt_hours_w loop

                ds_hour_w := to_char(clock_timestamp() - (qt_hours_increment / 24), 'MM-DD-YY HH24');
                dt_actual_w := clock_timestamp() - (qt_hours_increment / 24);

                if not hours_w.EXISTS(ds_hour_w) then
                    hours_w(ds_hour_w) := 0;
                end if;

                if dt_actual_w >= c01_w.period_start and dt_actual_w <= coalesce(c01_w.period_end,clock_timestamp()) then
                    hours_w(ds_hour_w) := hours_w(ds_hour_w) + 1;
                end if;

                if qt_hours_increment > 0 then

                    ds_hour_w := to_char(clock_timestamp() + (qt_hours_increment / 24), 'MM-DD-YY HH24');
                    dt_actual_w := clock_timestamp() + (qt_hours_increment / 24);

                    if not hours_w.EXISTS(ds_hour_w) then
                        hours_w(ds_hour_w) := 0;
                    end if;

                    for qt_weeks_increment in 1 .. qt_weeks_w loop

                        if dt_actual_w - (qt_weeks_increment * 7) >= c01_w.period_start and
                           dt_actual_w - (qt_weeks_increment * 7) <= coalesce(c01_w.period_end,clock_timestamp()) then
                         hours_w(ds_hour_w) := hours_w(ds_hour_w) + 1;
                        end if;

                    end loop;

                end if;

            end loop;
        end loop;

        ds_hour_w := hours_w.FIRST;
        while (ds_hour_w IS NOT NULL AND ds_hour_w::text <> '') loop

			qt_rows_w := qt_rows_w + 1;

             := pfcs_pck.pfcs_generate_results(
            vl_indicator_p =>  case when to_date(ds_hour_w,'MM-DD-YY HH24') > dt_start_w then
									round(hours_w(ds_hour_w) / qt_weeks_w) else hours_w(ds_hour_w) end, vl_indicator_help_p => case when qt_rows_w > qt_hours_w + 1 then qt_rows_w - qt_hours_w - 1 else qt_hours_w - qt_rows_w + 1 end, ds_reference_value_p => ds_hour_w, ds_reference_aux_p => case when to_date(ds_hour_w,'MM-DD-YY HH24') > dt_start_w then
									   PFCS_PCK_CONSTANTS.CD_SIMULATION else null end, nr_seq_operational_level_p => cd_establishment_p, nr_seq_indicator_p => PFCS_PCK_INDICATORS.NR_ED_ESTIMATED_ENCOUNTERS, nm_usuario_p => nm_user_p, nr_seq_panel_p => pfcs_panel_seq_w);

            ds_hour_w := hours_w.NEXT(ds_hour_w);
        end loop;

        CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => PFCS_PCK_INDICATORS.NR_ED_ESTIMATED_ENCOUNTERS,
            nr_seq_operational_level_p => cd_establishment_p,
            nm_usuario_p => nm_user_p);

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_emergency_department.calc_encounters_histogram (cd_establishment_p bigint, nm_user_p text) FROM PUBLIC;