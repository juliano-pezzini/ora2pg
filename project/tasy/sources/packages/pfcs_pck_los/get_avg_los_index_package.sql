-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_los.get_avg_los_index ( cd_establishment_p bigint, cd_unit_p bigint default null, cd_unit_classification_p text  DEFAULT NULL) RETURNS bigint AS $body$
DECLARE

        vl_avg_los_index_w double precision;

BEGIN
        select avg( dividir((svc.dt_authored_on-enc.period_start),(enc.dt_expected_discharge-enc.period_start)) )
        into STRICT vl_avg_los_index_w
        from pfcs_encounter enc,
            pfcs_patient pat,
            unidade_atendimento uni,
            setor_atendimento sec,
            pfcs_service_request svc
        where uni.cd_setor_atendimento = sec.cd_setor_atendimento
            and uni.nr_seq_location = svc.nr_seq_location
            and sec.ie_ocup_hospitalar <> PFCS_PCK_CONSTANTS.IE_NO
            and enc.nr_seq_patient = pat.nr_sequencia
            and (enc.period_start IS NOT NULL AND enc.period_start::text <> '')
            and (enc.period_end IS NOT NULL AND enc.period_end::text <> '')
            and svc.nr_seq_encounter = enc.nr_sequencia
            and svc.nr_seq_patient = pat.nr_sequencia
            and svc.cd_service = PFCS_PCK_CONSTANTS.CD_DISCHARGE
            and svc.si_status = PFCS_PCK_CONSTANTS.SI_STATUS_COMPLETED
            and svc.si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
            and trunc(svc.dt_authored_on) = trunc(clock_timestamp())
            and (coalesce(cd_unit_p::text, '') = '' or sec.cd_setor_atendimento = cd_unit_p)
            and (coalesce(cd_unit_classification_p::text, '') = '' or sec.cd_classif_setor = cd_unit_classification_p)
            and sec.cd_estabelecimento = cd_establishment_p
            and (enc.dt_expected_discharge IS NOT NULL AND enc.dt_expected_discharge::text <> '');
        RETURN coalesce(vl_avg_los_index_w, 0);
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_los.get_avg_los_index ( cd_establishment_p bigint, cd_unit_p bigint default null, cd_unit_classification_p text  DEFAULT NULL) FROM PUBLIC;