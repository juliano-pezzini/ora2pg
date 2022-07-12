-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_db_utils.migrate_org_struct_tables () AS $body$
DECLARE

        cur_units CURSOR FOR
        SELECT cd_setor_atendimento cd_unit_old,
            cd_estabelecimento cd_establishment,
            cd_setor_externo cd_integration,
            cd_classif_setor cd_type,
            ds_setor_atendimento ds_unit,
            ie_rpa ie_pacu,
            pfcs_pck_utils.get_lang_yes_no(ie_ocup_hospitalar) ie_hospital_occupancy,
            ie_situacao ie_situation
        from setor_atendimento
        where nm_usuario_nrec = PFCS_PCK_CONSTANTS.NM_USER_PFCS;

        cur_beds CURSOR(cd_unit_old_p  bigint) FOR
        SELECT nr_seq_location,
            cd_unidade_basica ds_room,
            cd_unidade_compl ds_bed,
            pfcs_pck_utils.get_lang_yes_no(ie_exibir_cc) ie_operating_room,
            'N' ie_type, -- N for Normal | T for temporary | V for virtual
            pfcs_get_bed_mapping(ie_status_unidade,'T') cd_operational_status,
            ie_situacao ie_situation
        from unidade_atendimento
        where nm_usuario_nrec = PFCS_PCK_CONSTANTS.NM_USER_PFCS
            and cd_setor_atendimento = cd_unit_old_p;

        nr_seq_pfcs_unit_w  pfcs_unit.nr_sequencia%type;
        cd_type_w           pfcs_unit.cd_type%type;

BEGIN
        delete FROM pfcs_bed;
        delete FROM pfcs_unit;
        commit;

        for c01_w in cur_units loop
            select nextval('pfcs_unit_seq')
            into STRICT nr_seq_pfcs_unit_w
;

            cd_type_w := CASE c01_w.cd_type
                WHEN '1' THEN 'ED'
                WHEN '2' THEN 'OR'
                WHEN '3' THEN 'ACU'
                WHEN '4' THEN 'ICU'
                WHEN '8' THEN 'HAH'
                WHEN '9' THEN 'PEDU'
            END;

            if (c01_w.ie_pacu = PFCS_PCK_CONSTANTS.IE_YES_BR) then
                cd_type_w := 'PACU';
            end if;

            INSERT INTO
            PFCS_UNIT(
                nr_sequencia,
                cd_establishment,
                dt_atualizacao,
                dt_atualizacao_nrec,
                nm_usuario,
                nm_usuario_nrec,
                cd_integration,
                cd_type,
                ds_unit,
                ie_situation,
                ie_hospital_occupancy
            ) VALUES (
                nr_seq_pfcs_unit_w,
                c01_w.cd_establishment,
                clock_timestamp(),
                clock_timestamp(),
                PFCS_PCK_CONSTANTS.NM_USER_PFCS,
                PFCS_PCK_CONSTANTS.NM_USER_PFCS,
                c01_w.cd_integration,
                cd_type_w,
                c01_w.ds_unit,
                c01_w.ie_situation,
                c01_w.ie_hospital_occupancy
            );

            for c02_w in cur_beds(c01_w.cd_unit_old) loop
                INSERT INTO
                PFCS_BED(
                    nr_sequencia,
                    nr_seq_pfcs_unit,
                    dt_atualizacao,
                    dt_atualizacao_nrec,
                    nm_usuario,
                    nm_usuario_nrec,
                    ds_room,
                    ds_bed,
                    ie_operating_room,
                    cd_operational_status,
                    ie_situation
                ) VALUES (
                    c02_w.nr_seq_location,
                    nr_seq_pfcs_unit_w,
                    clock_timestamp(),
                    clock_timestamp(),
                    PFCS_PCK_CONSTANTS.NM_USER_PFCS,
                    PFCS_PCK_CONSTANTS.NM_USER_PFCS,
                    c02_w.ds_room,
                    c02_w.ds_bed,
                    c02_w.ie_operating_room,
                    c02_w.cd_operational_status,
                    c02_w.ie_situation
                );
            end loop;
        end loop;

        commit;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_db_utils.migrate_org_struct_tables () FROM PUBLIC;
