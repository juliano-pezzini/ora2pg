-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE core_table_item_insertion ( nm_value_p text, nm_table_p text, nr_seq_col_ref_p text, ie_status_p text DEFAULT 'A', cd_listbox_value_p INOUT bigint  DEFAULT NULL) AS $body$
DECLARE

    nm_value_w   bigint;
    query        varchar(1000);

BEGIN
    EXECUTE 'select max(nr_sequencia) from '
                      || nm_table_p
                      || ' where '
                      || lower(nr_seq_col_ref_p)
                      || ' ='''
                      || lower(nm_value_p)
                      || ''''
    INTO STRICT nm_value_w;

    IF ( coalesce(nm_value_w, 0) = 0 ) THEN
        query := 'insert into '
                 || nm_table_p
                 || ' ( nr_sequencia,dt_atualizacao,nm_usuario,';
        IF ( nm_table_p = 'FORMA_CHEGADA' ) THEN
            query := query || 'cd_empresa,';
        END IF;
        query := query
                 || nr_seq_col_ref_p
                 || ',IE_SITUACAO) values( '
                 || nm_table_p
                 || '_seq.nextval,sysdate,wheb_usuario_pck.get_nm_usuario,';
        IF ( nm_table_p = 'FORMA_CHEGADA' ) THEN
            query := query || 'wheb_usuario_pck.get_cd_estabelecimento,';
        END IF;
        query := query
                 || ''''
                 || nm_value_p
                 || ''','''
                 || coalesce(ie_status_p, 'A')
                 || ''')';

        EXECUTE query;
        EXECUTE 'select max(nr_sequencia) from ' || nm_table_p
        INTO STRICT nm_value_w;
        COMMIT;
    END IF;

    cd_listbox_value_p := nm_value_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE core_table_item_insertion ( nm_value_p text, nm_table_p text, nr_seq_col_ref_p text, ie_status_p text DEFAULT 'A', cd_listbox_value_p INOUT bigint  DEFAULT NULL) FROM PUBLIC;

