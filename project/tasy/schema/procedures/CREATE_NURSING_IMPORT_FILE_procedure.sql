-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_nursing_import_file ( NR_SEQ_IMPORT_P nursing_care_import_files.nr_seq_import%TYPE, DS_ARQUIVO_P nursing_care_import_files.ds_arquivo%TYPE, DS_NAME_FILE_P nursing_care_import_files.ds_name_file%TYPE, NR_SEQUENCIA_P INOUT nursing_care_import_files.nr_sequencia%TYPE ) AS $body$
DECLARE

    NM_USUARIO_W nursing_care_import_items.nm_usuario%TYPE;

BEGIN
    NM_USUARIO_W := wheb_usuario_pck.get_nm_usuario();
    SELECT nextval('nursing_care_import_files_seq') INTO STRICT NR_SEQUENCIA_P;

    INSERT INTO NURSING_CARE_IMPORT_FILES(
        NR_SEQUENCIA,
        NR_SEQ_IMPORT,
        DS_ARQUIVO,
        DS_NAME_FILE,
        NM_USUARIO,
        NM_USUARIO_NREC,
        DT_ATUALIZACAO,
        DT_ATUALIZACAO_NREC
    ) VALUES (
        NR_SEQUENCIA_P,
        NR_SEQ_IMPORT_P,
        DS_ARQUIVO_P,
        DS_NAME_FILE_P,
        NM_USUARIO_W,
        NM_USUARIO_W,
        clock_timestamp(),
        clock_timestamp()
    );
    commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_nursing_import_file ( NR_SEQ_IMPORT_P nursing_care_import_files.nr_seq_import%TYPE, DS_ARQUIVO_P nursing_care_import_files.ds_arquivo%TYPE, DS_NAME_FILE_P nursing_care_import_files.ds_name_file%TYPE, NR_SEQUENCIA_P INOUT nursing_care_import_files.nr_sequencia%TYPE ) FROM PUBLIC;
