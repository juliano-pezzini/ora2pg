-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE datamodel_validation ( nr_sequencia_p bigint ) AS $body$
DECLARE


    start_time          bigint;
    end_time            bigint;
    exec_starttime      TIMESTAMP;
    exec_endtime        TIMESTAMP;
    query_plan_w        varchar(4000);
    is_valid_datamodel  varchar(2);
    user_message        varchar(500);
    nm_usuario_w        usuario.nm_usuario%type;
    c_model CURSOR FOR
    SELECT
        *
    FROM
        data_model
    WHERE
        coalesce(nr_sequencia_p::text, '') = ''
        OR nr_sequencia = nr_sequencia_p
        AND coalesce(ie_situacao, 'A') = 'A';

    model_data          c_model%rowtype;

    

BEGIN
    nm_usuario_w := coalesce(Obter_Usuario_Ativo, user);
    OPEN c_model;
    SELECT
        CURRENT_TIMESTAMP
    INTO STRICT exec_starttime
;

    LOOP
        FETCH c_model INTO model_data;
        EXIT WHEN NOT FOUND; /* apply on c_model */
        IF (model_data.ds_sql IS NOT NULL AND model_data.ds_sql::text <> '') THEN
            BEGIN
                BEGIN
                    DELETE FROM plan_table
                    WHERE
                        statement_id = 'DM_' || model_data.nr_sequencia;

                    EXECUTE 'EXPLAIN PLAN SET STATEMENT_ID = '''
                                      || 'DM_'
                                      || model_data.nr_sequencia
                                      || ''' into PLAN_TABLE FOR  '
                                      || to_char(model_data.ds_sql);

                    DECLARE
                        c_plan CURSOR FOR
                        SELECT
                            *
                        FROM
                            plan_table
                        WHERE
                            statement_id = 'DM_' || to_char(model_data.nr_sequencia);

                        plantable_data_w c_plan%rowtype;
                    BEGIN
                        query_plan_w := NULL;
                        OPEN c_plan;
                        LOOP
                            FETCH c_plan INTO plantable_data_w;
                            EXIT WHEN NOT FOUND; /* apply on c_plan */
                            query_plan_w := query_plan_w
                                            || 'Operation: '
                                            || plantable_data_w.operation
                                            || ', Options: '
                                            || plantable_data_w.options
                                            || ', Object Name: '
                                            || plantable_data_w.object_name
                                            || ', Object Type: '
                                            || plantable_data_w.object_type
                                            || ', Optimizer: '
                                            || plantable_data_w.optimizer
                                            || ', Cost: '
                                            || to_char(plantable_data_w.cost)
                                            || ', Cardinality: '
                                            || to_char(plantable_data_w.cardinality)
                                            || ', ';

                        END LOOP;

                        CLOSE c_plan;
                    END;

                END;

                SELECT
                    dbms_utility.get_time
                INTO STRICT start_time
;

                EXECUTE to_char(model_data.ds_sql);
                SELECT
                    dbms_utility.get_time
                INTO STRICT end_time
;

                is_valid_datamodel := 'S';
                user_message := 'The datamodel is valid';
            EXCEPTION
                WHEN SQLSTATE '50006' THEN
                    is_valid_datamodel := 'N';
                    user_message := 'Please check and correct the DataModel'
                                    || 'OBJECT_NAME:'
                                    || model_data.object_name
                                    || ' is having invalid identifier. Exception: '
                                    || sqlerrm;
					UPDATE data_model
                    SET
                        ie_situacao = 'I'
                    WHERE
                        nr_sequencia = model_data.nr_sequencia;

                WHEN OTHERS THEN
                    is_valid_datamodel := 'N';
                    user_message := 'Please check and correct the DataModel'
                                    || 'OBJECT_NAME:'
                                    || model_data.object_name
                                    || ' is invalid. Exception: '
                                    || sqlerrm;
					UPDATE data_model
                    SET
                        ie_situacao = 'I'
                    WHERE
                        nr_sequencia = model_data.nr_sequencia;

            END;
        ELSE
            is_valid_datamodel := 'N';
            user_message := 'Invalid datamodel. OBJECT_NAME:'
                            || model_data.object_name
                            || 'Please check and correct the DataModel';
					UPDATE data_model
                    SET
                        ie_situacao = 'I'
                    WHERE
                        nr_sequencia = model_data.nr_sequencia;
        END IF;

        SELECT
            CURRENT_TIMESTAMP
        INTO STRICT exec_endtime
;

        INSERT INTO dar_validation_data(
            nr_sequencia,
            NR_SEQ_MODEL,
            sql_exec_time,
            ie_valid_sql,
            ie_message,
            query_plan,
            nm_usuario,
            dt_atualizacao,
            nm_usuario_nrec,
            DS_EXEC_DURATION
        ) VALUES (
            nextval('dar_validation_data_seq'),
            model_data.nr_sequencia,
            end_time - start_time,
            is_valid_datamodel,
            user_message,
            query_plan_w,
            nm_usuario_w,
            clock_timestamp(),
            nm_usuario_w,
            time_format_rec(exec_endtime,exec_starttime)
        );

    END LOOP;
    CLOSE c_model;
    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE datamodel_validation ( nr_sequencia_p bigint ) FROM PUBLIC;

