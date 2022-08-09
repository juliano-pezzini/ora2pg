-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_query_data ( nr_seq_parent_p data_model.nr_sequencia%type, ds_columns_p data_model_columns.ATRIBUTE_NAME%TYPE, ds_tables_p data_model_columns.TABLE_NAME%TYPE, ds_tables_alias_p data_model_columns.NM_TABLE_ALIAS%TYPE, ds_column_alias_p data_model_columns.ALIAS_NAME%TYPE ) AS $body$
DECLARE


    data_model_exists_w bigint := 0;WITH RECURSIVE cte AS (


    c_sql CURSOR FOR
    SELECT
        trim(both regexp_substr(ds_columns_p, '[^;]+', 1, level)) colName,
		trim(both regexp_substr(ds_column_alias_p, '[^;]+', 1, level)) colAlias
    
    (regexp_substr(ds_columns_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(ds_columns_p, '[^;]+', 1, level))::text <> '')  UNION ALL

    
    c_sql CURSOR FOR
    SELECT
        trim(both regexp_substr(ds_columns_p, '[^;]+', 1, level)) colName,
		trim(both regexp_substr(ds_column_alias_p, '[^;]+', 1, level)) colAlias
    
    (regexp_substr(ds_columns_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(ds_columns_p, '[^;]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

         type c_sql_t is table of c_sql%rowtype;
         c_query_t     c_sql_t;


BEGIN
$if dbms_db_version.version >= 11 $then
    open c_sql;
    loop
        fetch c_sql
         bulk collect
         into c_query_t;
    
         forall i in 1 .. c_query_t.count  
            INSERT INTO data_model_columns(
                nr_sequencia,
                data_model_id,
                table_name,
                nm_table_alias,
                atribute_name,
                alias_name,
				cd_exp_attribute,
                ie_sensivel,
		ds_type,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec
            ) VALUES (
                nextval('data_model_columns_seq'),
                nr_seq_parent_p,
                coalesce(ds_tables_p, NULL),
                coalesce(ds_tables_alias_p, NULL),
                coalesce(c_query_t[i].colName, NULL),
				COALESCE(c_query_t[i].colAlias,c_query_t[i].colName),
                GET_ATTRIBUTE_EXPRESSION(c_query_t[i].colName,ds_tables_p),
                obter_se_informacao_sensivel(ds_tables_p, c_query_t[i].colName),
				coalesce(get_attribute_type(ds_tables_p, c_query_t[i].colName),'FUNCTION'),
                clock_timestamp(),
                Obter_Usuario_Ativo,
                clock_timestamp(),
                Obter_Usuario_Ativo
            );

      EXIT WHEN NOT FOUND; /* apply on c_sql */
    end loop;
    close c_sql;
    $end
;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_query_data ( nr_seq_parent_p data_model.nr_sequencia%type, ds_columns_p data_model_columns.ATRIBUTE_NAME%TYPE, ds_tables_p data_model_columns.TABLE_NAME%TYPE, ds_tables_alias_p data_model_columns.NM_TABLE_ALIAS%TYPE, ds_column_alias_p data_model_columns.ALIAS_NAME%TYPE ) FROM PUBLIC;
