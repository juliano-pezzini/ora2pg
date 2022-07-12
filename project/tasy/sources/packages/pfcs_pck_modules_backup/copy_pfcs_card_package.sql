-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_modules_backup.copy_pfcs_card (dt_backup_p timestamp) AS $body$
BEGIN
        insert into pfcs_card_bck(
            nr_sequencia,
            nr_seq_dynamic_module,
            nr_seq_dashboard,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            cd_card_type,
            ie_list_view,
            ie_expansible,
            cd_exp_card,
            nr_region,
            ds_position_x,
            ds_position_y,
            qt_rowspan,
            qt_colspan,
            ie_situacao,
            dt_backup
        ) SELECT
            nr_sequencia,
            nr_seq_dynamic_module,
            nr_seq_dashboard,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            cd_card_type,
            ie_list_view,
            ie_expansible,
            cd_exp_card,
            nr_region,
            ds_position_x,
            ds_position_y,
            qt_rowspan,
            qt_colspan,
            ie_situacao,
            dt_backup_p
        from pfcs_card;
        commit;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_modules_backup.copy_pfcs_card (dt_backup_p timestamp) FROM PUBLIC;