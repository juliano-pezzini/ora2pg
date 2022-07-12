-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_discharge_date (nr_seq_encounter_p bigint) RETURNS timestamp AS $body$
DECLARE

        dt_discharge_w pfcs_service_request.dt_authored_on%type;

BEGIN
        select  max(svc.dt_authored_on)
        into STRICT    dt_discharge_w
        from    pfcs_service_request svc
        where   svc.cd_service = PFCS_PCK_CONSTANTS.CD_DISCHARGE
        and     svc.si_status = PFCS_PCK_CONSTANTS.SI_STATUS_COMPLETED
        and     svc.si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
        and     svc.nr_seq_encounter = nr_seq_encounter_p;

        return dt_discharge_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_discharge_date (nr_seq_encounter_p bigint) FROM PUBLIC;