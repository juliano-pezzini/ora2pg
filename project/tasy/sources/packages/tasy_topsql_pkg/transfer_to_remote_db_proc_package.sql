-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tasy_topsql_pkg.transfer_to_remote_db_proc () AS $body$
DECLARE

    l_remote_db_username        varchar(128);
    l_remote_db_password        varchar(128);
    l_remote_db_sqlnet_config   varchar(256);
    l_create_db_link            varchar(1000);
    l_db_link_exists            bigint;
    l_dest_table_name           varchar(128);
    l_db_name                   varchar(8);
    l_con_name                  varchar(30);
    l_tasy_version              varchar(10);
    l_query                     varchar(1000);
    l_oracle_version            integer := DBMS_DB_VERSION.VERSION;
    l_oracle_release            integer := DBMS_DB_VERSION.RELEASE;
    l_oracle_full_version       varchar(10) := TO_CHAR(l_oracle_version) || '.' || TO_CHAR(l_oracle_release);
    l_remove_insert_sql         varchar(2000) :=
            'INSERT INTO tasy_topsql_sqlarea_rep_cust@tasy_topsql_copy('
            || ' customer_name'
            || ',database_name'
            || ',tasy_version'
            || ',oracle_version'
            || ',creation_date'
            || ',sql_id'
            || ',occurences_top_n'
            || ',object_name'
            || ',module'
            || ',action'
            || ',first_sample'
            || ',last_sample'
            || ',last_executions'
            || ',last_elapsed_time'
            || ',last_cpu_time'
            || ',last_disk_reads'
            || ',last_buffer_gets'
            || ',last_user_io_wait_time'
            || ',last_rows_processed'
            || ',total_executions'
            || ',total_elapsed_time'
            || ',total_cpu_time'
            || ',total_disk_reads'
            || ',total_buffer_gets'
            || ',total_user_io_wait_time'
            || ',total_rows_processed'
            || ',sql_text'
            || ',sql_fulltext'
            || ',last_sql_plans'
            || ') SELECT '
            || '''Philips'''
            || ',nvl2(:l_con_name,:l_db_name || ' || ''':''' || ' || :l_con_name,:l_db_name),'
            || ':l_tasy_version,'
            || ':l_oracle_full_version,'
            || 'sysdate'
            || ',sql_id'
            || ',occurences_top_n'
            || ',object_name'
            || ',module'
            || ',action'
            || ',first_sample'
            || ',last_sample'
            || ',last_executions'
            || ',last_elapsed_time'
            || ',last_cpu_time'
            || ',last_disk_reads'
            || ',last_buffer_gets'
            || ',last_user_io_wait_time'
            || ',last_rows_processed'
            || ',total_executions'
            || ',total_elapsed_time'
            || ',total_cpu_time'
            || ',total_disk_reads'
            || ',total_buffer_gets'
            || ',total_user_io_wait_time'
            || ',total_rows_processed'
            || ',sql_text'
            || ',sql_fulltext'
            || ',last_sql_plans'
            || ' FROM tasy_topsql_sqlarea_report';

    
    

BEGIN
    -- Get database link connection attributes
    SELECT
        remote_db_username,
        remote_db_password,
        remote_db_sqlnet_config
    INTO STRICT
        l_remote_db_username,
        l_remote_db_password,
        l_remote_db_sqlnet_config
    FROM
        tasy_topsql_control_tab;

    -- Get database name
    SELECT sys_context('USERENV','DB_NAME') 
    INTO STRICT l_db_name
;

    -- Get container name
    IF l_oracle_version >= 12 THEN
        SELECT sys_context('USERENV','CON_NAME') 
        INTO STRICT l_con_name
;
    END IF;

    -- Get tasy version
    SELECT MAX(SUBSTR(at.cd_versao_atual, -4, 4) || '_' || TO_CHAR(coalesce(avc.nr_service_pack, 0), 'FM00')) cd_versao
    INTO STRICT l_tasy_version
    FROM aplicacao_tasy at
LEFT OUTER JOIN ajuste_versao_cliente avc ON (at.cd_versao_atual = avc.cd_versao)
WHERE at.cd_aplicacao_tasy = 'Tasy';

    IF ((l_remote_db_username IS NOT NULL AND l_remote_db_username::text <> '') AND (l_remote_db_password IS NOT NULL AND l_remote_db_password::text <> '') AND (l_remote_db_sqlnet_config IS NOT NULL AND l_remote_db_sqlnet_config::text <> '')) THEN
        -- Check if database link exists, otherwise creates it
        SELECT COUNT(*)
        INTO STRICT l_db_link_exists
        FROM user_db_links
        WHERE db_link = 'TASY_TOPSQL_COPY';

        IF l_db_link_exists = 0 THEN
            l_create_db_link := 'create database link tasy_topsql_copy connect to ' || 
                l_remote_db_username || ' identified by "' || l_remote_db_password || 
                '" using ''' || l_remote_db_sqlnet_config || '''';
            BEGIN
                EXECUTE l_create_db_link;
            EXCEPTION
                WHEN SQLSTATE '50012' THEN
                    RAISE EXCEPTION '%', 'Unable to create the database link: ' || sqlerrm USING ERRCODE = '45001';
            END;
        END IF;

        BEGIN
            -- Check if the database link is working, otherwise, raise exception
            l_query := 'SELECT table_name '
            || 'FROM user_tables@tasy_topsql_copy '
            || 'WHERE table_name = :b1';

            EXECUTE l_query INTO STRICT l_dest_table_name USING 'TASY_TOPSQL_SQLAREA_REP_CUST';
        EXCEPTION
            WHEN no_data_found THEN
                RAISE EXCEPTION '%', 'Destination table "TASY_TOPSQL_SQLAREA_REP_CUST" was not craeted: ' || sqlerrm USING ERRCODE = '45003';
        END;

        -- If all went well, insert data in remote database
        EXECUTE l_remove_insert_sql 
        USING l_con_name, l_db_name, l_con_name, l_db_name, l_tasy_version, l_oracle_full_version;
    END IF;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_topsql_pkg.transfer_to_remote_db_proc () FROM PUBLIC;
