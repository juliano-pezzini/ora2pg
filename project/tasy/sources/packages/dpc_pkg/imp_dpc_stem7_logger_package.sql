-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.imp_dpc_stem7_logger (nr_seq_edition_p bigint, si_status_p text, ds_log_p text) AS $body$
BEGIN
        IF si_status_p = '2' THEN
            ROLLBACK;
        END IF;

        UPDATE  DPC_EDITION_STEM7
        SET     SI_STATUS = si_status_p, 
                DS_LOG = ds_log_p
        WHERE   NR_SEQUENCIA = nr_seq_edition_p;

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        rollback;
        CALL wheb_mensagem_pck.exibir_mensagem_abort(1023582);
END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.imp_dpc_stem7_logger (nr_seq_edition_p bigint, si_status_p text, ds_log_p text) FROM PUBLIC;
