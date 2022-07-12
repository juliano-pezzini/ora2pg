-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE import_drug_master_jp_l10_pkg.insert_import_log ( nr_seq_version_p bigint, nm_usuario_p text, ds_log_p text ) AS $body$
DECLARE

        int_import_log_w   int_import_log%rowtype;
        import_seq_log_w   int_import_log.nr_sequencia%type;

BEGIN
        select  nextval('int_import_log_seq')
        into STRICT    int_import_log_w.nr_sequencia
;

        int_import_log_w.nr_record := nr_seq_version_p;
        int_import_log_w.ds_log := ds_log_p;
        int_import_log_w.ie_type_log := 1;
        int_import_log_w.dt_atualizacao := clock_timestamp();
        int_import_log_w.dt_atualizacao_nrec := clock_timestamp();
        int_import_log_w.nm_usuario := nm_usuario_p;
        int_import_log_w.nm_usuario_nrec := nm_usuario_p;

        insert into int_import_log values (int_import_log_w.*);
        commit;
    end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_drug_master_jp_l10_pkg.insert_import_log ( nr_seq_version_p bigint, nm_usuario_p text, ds_log_p text ) FROM PUBLIC;