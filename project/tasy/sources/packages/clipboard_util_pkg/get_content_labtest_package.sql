-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clipboard_util_pkg.get_content_labtest ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint, cd_procedimento_p bigint, nr_seq_interno_p bigint, nr_exam_p bigint ) RETURNS varchar AS $body$
DECLARE


        ds_content_w    varchar(32000);
        exam_w          varchar(32000);
        dt_coleta_w     varchar(32000);
        ds_mat_w        varchar(32000);
        result_w        varchar(32000);
        test_concl_w   varchar(32000);
        ds_content_w1   varchar(32000);
        name_exp_w      varchar(32000);
        col_dt_w        varchar(32000);
        test_item_w     varchar(32000);
        test_result_w   varchar(32000);
        test_conclu_w   varchar(32000);
        c01 CURSOR FOR
        SELECT
            *
        FROM
            TABLE( clipboard_util_pkg.get_clipboard_rule(ie_record_type_p) )
        WHERE
            nr_seq = config_option_p
        ORDER BY
            nr_seq_display ASC;


  i RECORD;
BEGIN
        FOR i IN (WITH RECURSIVE cte AS (

            SELECT
                regexp_substr(nr_sequencia_p, '[^,]+', 1, level) AS data_w

            (regexp_substr(nr_sequencia_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_sequencia_p, '[^,]+', 1, level))::text <> '')
          UNION ALL

            SELECT
                regexp_substr(nr_sequencia_p, '[^,]+', 1, level) AS data_w
            
            (regexp_substr(nr_sequencia_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_sequencia_p, '[^,]+', 1, level))::text <> '')
         JOIN cte c ON ()

) SELECT * FROM cte;
) LOOP
            SELECT
                clipboard_util_pkg.lbtest_data(nr_atendimento_p, i.data_w, 'TEST_NAME', nr_seq_interno_p, cd_procedimento_p,nr_exam_p)
            INTO STRICT exam_w
;


            SELECT
                clipboard_util_pkg.lbtest_data(nr_atendimento_p, i.data_w, 'COL_DATE', nr_seq_interno_p, cd_procedimento_p,nr_exam_p)
            INTO STRICT dt_coleta_w
;

            SELECT
                clipboard_util_pkg.lbtest_data(nr_atendimento_p, i.data_w, 'TEST_ITEMS', nr_seq_interno_p, cd_procedimento_p,nr_exam_p)
            INTO STRICT ds_mat_w
;

         
            SELECT
                clipboard_util_pkg.lbtest_data(nr_atendimento_p, i.data_w, 'TEST_RESULTS', nr_seq_interno_p, cd_procedimento_p,nr_exam_p)
            INTO STRICT result_w
;

            SELECT
                clipboard_util_pkg.lbtest_data(nr_atendimento_p, i.data_w, 'TEST_CONCL', nr_seq_interno_p, cd_procedimento_p,nr_exam_p)
            INTO STRICT test_concl_w
;

            ds_content_w1 := NULL;
            FOR r_c01 IN c01 LOOP IF ( ie_record_type_p = 'LAB_TEST' ) THEN
                IF ( r_c01.ie_field = 'TEST_NAME' ) THEN
                    IF (exam_w IS NOT NULL AND exam_w::text <> '') THEN
                        ds_content_w1 := NULL;
                        SELECT
                            nm_field
                        INTO STRICT name_exp_w
                        FROM
                            TABLE( clipboard_util_pkg.get_clipboard_rule('LAB_TEST') )
                        WHERE
                            nr_seq = config_option_p
                            AND ie_field = 'TEST_NAME';

                        ds_content_w1 := ds_content_w1 || exam_w;
                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'COL_DATE' ) THEN
                    IF (dt_coleta_w IS NOT NULL AND dt_coleta_w::text <> '') THEN
                        ds_content_w1 := NULL;
                        SELECT
                            nm_field
                        INTO STRICT col_dt_w
                        FROM
                            TABLE( clipboard_util_pkg.get_clipboard_rule('LAB_TEST') )
                        WHERE
                            nr_seq = config_option_p
                            AND ie_field = 'COL_DATE';

                        ds_content_w1 := ds_content_w1 || dt_coleta_w;
                    END IF;

                END IF;

                IF ( r_c01.ie_field = 'TEST_ITEMS' ) THEN
                    IF (ds_mat_w IS NOT NULL AND ds_mat_w::text <> '') THEN
                        ds_content_w1 := NULL;
                        SELECT
                            nm_field
                        INTO STRICT test_item_w
                        FROM
                            TABLE( clipboard_util_pkg.get_clipboard_rule('LAB_TEST') )
                        WHERE
                            nr_seq = config_option_p
                            AND ie_field = 'TEST_ITEMS';

                        ds_content_w1 := ds_content_w1 || ds_mat_w;
                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'TEST_RESULTS' ) THEN
                    IF (result_w IS NOT NULL AND result_w::text <> '') THEN
                        ds_content_w1 := NULL;
                        SELECT
                            nm_field
                        INTO STRICT test_result_w
                        FROM
                            TABLE( clipboard_util_pkg.get_clipboard_rule('LAB_TEST') )
                        WHERE
                            nr_seq = config_option_p
                            AND ie_field = 'TEST_RESULTS';

                        ds_content_w1 := ds_content_w1 || result_w;
                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'TEST_CONCL' ) THEN
                    IF (test_concl_w IS NOT NULL AND test_concl_w::text <> '') THEN
                        ds_content_w1 := NULL;
                        SELECT
                            nm_field
                        INTO STRICT test_conclu_w
                        FROM
                            TABLE( clipboard_util_pkg.get_clipboard_rule('LAB_TEST') )
                        WHERE
                            nr_seq = config_option_p
                            AND ie_field = 'TEST_CONCL';

                        ds_content_w1 := ds_content_w1 || test_concl_w;
                    END IF;
                END IF;

            END IF;
            END LOOP;

            ds_content_w := substr(ds_content_w
                            || ds_content_w1
                            || '</br>',1,4000);
        END LOOP;



        RETURN substr(replace(replace(replace(replace(replace(replace(ds_content_w, chr(38)||'1', coalesce(name_exp_w, obter_desc_expressao(761511)))
        , chr(38)||'2', obter_desc_expressao(314503)), chr(38)||'3', coalesce(col_dt_w, obter_desc_expressao(288414))), chr(38)||'4', coalesce(test_item_w, obter_desc_expressao(622546))), chr(38)||'5', coalesce(test_result_w, obter_desc_expressao(1023729))), chr(38)||'6', coalesce(test_conclu_w, obter_desc_expressao(285638)
        )),1,4000);

    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clipboard_util_pkg.get_content_labtest ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint, cd_procedimento_p bigint, nr_seq_interno_p bigint, nr_exam_p bigint ) FROM PUBLIC;