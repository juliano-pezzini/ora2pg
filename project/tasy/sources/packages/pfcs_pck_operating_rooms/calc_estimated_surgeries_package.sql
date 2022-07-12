-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_operating_rooms.calc_estimated_surgeries (cd_establishment_p bigint, nm_user_p text) AS $body$
DECLARE

        pfcs_panel_seq_w        pfcs_panel.nr_sequencia%type;
        qt_estimated_w          integer := 0;

BEGIN
        select  count(appt.nr_sequencia)
        into STRICT    qt_estimated_w
        from    pfcs_appointment appt,
                setor_atendimento sec,
                unidade_atendimento uni
        where   upper(appt.si_status) = PFCS_PCK_CONSTANTS.SI_STATUS_PROPOSED
        and     uni.nr_seq_location = appt.nr_seq_location
        and     uni.cd_setor_atendimento = sec.cd_setor_atendimento
        and     sec.cd_estabelecimento = cd_establishment_p;

         := pfcs_pck.pfcs_generate_results(
            vl_indicator_p => qt_estimated_w, nr_seq_indicator_p => PFCS_PCK_INDICATORS.NR_VC_ESTIMATED_SURGERIES, nr_seq_operational_level_p => cd_establishment_p, nm_usuario_p => nm_user_p, nr_seq_panel_p => pfcs_panel_seq_w);

        CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => PFCS_PCK_INDICATORS.NR_VC_ESTIMATED_SURGERIES,
            nr_seq_operational_level_p => cd_establishment_p,
            nm_usuario_p => nm_user_p);
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_operating_rooms.calc_estimated_surgeries (cd_establishment_p bigint, nm_user_p text) FROM PUBLIC;
