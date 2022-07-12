-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_operating_rooms.calc_rooms_in_setup (cd_establishment_p bigint, nm_user_p text) AS $body$
DECLARE

        pfcs_panel_seq_w pfcs_panel.nr_sequencia%type;
        qt_or_in_setup_w integer;

BEGIN
        select  count(tsk.nr_sequencia)
        into STRICT    qt_or_in_setup_w
        from    pfcs_task tsk
        where   tsk.si_status in (PFCS_PCK_CONSTANTS.SI_STATUS_ACCEPTED, PFCS_PCK_CONSTANTS.SI_STATUS_IN_PROGRESS)
        and     tsk.si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
        and     clock_timestamp() between tsk.period_start and coalesce(tsk.period_end, clock_timestamp())
        and     tsk.cd_establishment = cd_establishment_p
        and     tsk.cd_task_code = PFCS_PCK_CONSTANTS.CD_TASK_OR_SETUP;

         := pfcs_pck.pfcs_generate_results(
            vl_indicator_p => qt_or_in_setup_w, nr_seq_indicator_p => PFCS_PCK_INDICATORS.NR_OR_ROOM_SETUP, nr_seq_operational_level_p => cd_establishment_p, nm_usuario_p => nm_user_p, nr_seq_panel_p => pfcs_panel_seq_w);

        CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => PFCS_PCK_INDICATORS.NR_OR_ROOM_SETUP,
            nr_seq_operational_level_p => cd_establishment_p,
            nm_usuario_p => nm_user_p);
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_operating_rooms.calc_rooms_in_setup (cd_establishment_p bigint, nm_user_p text) FROM PUBLIC;