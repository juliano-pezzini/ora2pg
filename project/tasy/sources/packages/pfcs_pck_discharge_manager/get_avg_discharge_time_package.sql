-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_discharge_manager.get_avg_discharge_time (cd_establishment_p bigint, cd_unit_p bigint default null, cd_unit_classification_p text default null) RETURNS timestamp AS $body$
DECLARE


        ds_timezone_w               establishment_locale.ds_timezone%type;
        ie_stepdown_w               setor_atendimento.ie_semi_intensiva%type;
        cd_unit_classification_w    pfcs_unit.cd_type%type;
        dt_current_day_tz_w         timestamp;
        dt_average_time_w           timestamp;

BEGIN
        ds_timezone_w := get_establishment_timezone(cd_establishment_p);
        dt_current_day_tz_w := trunc(timezone_utils.getDate(clock_timestamp(),ds_timezone_w));

        if (cd_unit_classification_p = PFCS_PCK_CONSTANTS.CD_TCU) then
            ie_stepdown_w := PFCS_PCK_CONSTANTS.IE_YES_BR;
            cd_unit_classification_w := PFCS_PCK_CONSTANTS.CD_ICU;
        else
            cd_unit_classification_w := cd_unit_classification_p;
        end if;

        select timezone_utils.getDate((clock_timestamp() - avg(clock_timestamp() - svc.dt_authored_on)),ds_timezone_w)
        into STRICT dt_average_time_w
        from pfcs_encounter enc,
            pfcs_patient pat,
            unidade_atendimento uni,
            setor_atendimento sec,
            pfcs_service_request svc
        where ((sec.cd_classif_setor = cd_unit_classification_w) or (coalesce(cd_unit_classification_w::text, '') = '' and sec.ie_ocup_hospitalar <> PFCS_PCK_CONSTANTS.IE_NO))
            and (sec.cd_setor_atendimento = cd_unit_p or coalesce(cd_unit_p::text, '') = '')
            and sec.cd_estabelecimento = cd_establishment_p
            and (sec.ie_semi_intensiva = ie_stepdown_w or coalesce(ie_stepdown_w::text, '') = '')
            and uni.cd_setor_atendimento = sec.cd_setor_atendimento
            and uni.nr_seq_location = svc.nr_seq_location
            and enc.nr_seq_patient = pat.nr_sequencia
            and (enc.period_start IS NOT NULL AND enc.period_start::text <> '')
            and (enc.period_end IS NOT NULL AND enc.period_end::text <> '')
            and svc.nr_seq_encounter = enc.nr_sequencia
            and svc.nr_seq_patient = pat.nr_sequencia
            and svc.cd_service = PFCS_PCK_CONSTANTS.CD_DISCHARGE
            and svc.si_status = PFCS_PCK_CONSTANTS.SI_STATUS_COMPLETED
            and svc.si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
            and timezone_utils.getDate(svc.dt_authored_on,ds_timezone_w) >= dt_current_day_tz_w;
        return dt_average_time_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_discharge_manager.get_avg_discharge_time (cd_establishment_p bigint, cd_unit_p bigint default null, cd_unit_classification_p text default null) FROM PUBLIC;
