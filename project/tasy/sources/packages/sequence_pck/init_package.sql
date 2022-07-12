-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sequence_pck.init () AS $body$
DECLARE

    n_count_table bigint;

BEGIN
    select count(1) into STRICT n_count_table from user_tables where table_name = 'FIX_SEQUENCES';
    if (n_count_table > 0) then
      EXECUTE 'drop table fix_sequences';
    end if;

    EXECUTE '
      CREATE TABLE fix_sequences AS
        SELECT
            nm_tabela,
            constraint_name,
            sequence_name,
            last_number as sequence_last_number,
            -1 as table_num_rows,
            -1 as table_pk_max_value,
            increment_by as sequence_increment_by,
            regexp_count(constraint_columns, '';'') + 1 as constraint_number_of_columns,
            constraint_columns as constraint_columns_list
        FROM(
            SELECT
                a.nm_tabela,
                c.constraint_name,
                s.sequence_name,
                s.last_number,
                s.increment_by,
                LISTAGG(cc.column_name, ''; '') WITHIN GROUP (ORDER BY cc.position) constraint_columns
            FROM
                tabela_sistema   b,
                tabela_limpeza   a,
                user_constraints c,
                user_cons_columns cc,
                user_sequences s
            WHERE a.nm_tabela = b.nm_tabela
            AND a.nm_tabela = c.table_name
            AND c.table_name = cc.table_name
            AND c.constraint_name = cc.constraint_name
            AND a.nm_tabela || ''_SEQ'' = s.sequence_name (+)
            AND c.constraint_type IN(''P'',''U'')
            AND dt_avaliacao > sysdate - 5
            AND s.sequence_name is not null
            GROUP BY
                a.nm_tabela,
                c.constraint_name,
                s.sequence_name,
                s.last_number,
                s.increment_by
        )
        ORDER BY
            nm_tabela,
            constraint_name';

        n_count_table := 0;
        EXECUTE 'select count(1) from fix_sequences' into STRICT n_count_table;
        CALL cleanupdb_pck.init_progress(current_setting('sequence_pck.const_cleanupdb')::varchar(20),0,n_count_table);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sequence_pck.init () FROM PUBLIC;