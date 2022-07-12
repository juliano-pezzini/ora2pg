-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clipboard_util_pkg.get_content_sncp ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint ) RETURNS varchar AS $body$
DECLARE


        ds_content_w    varchar(32000);
        diag_w          varchar(1000);
        st_dt_w         varchar(32000);
        result_w        varchar(32000);
        rel_fact_w      varchar(32000);
        format_w        varchar(32000);
        ds_content_w1   varchar(32000);
        nm_exp_w        varchar(2000);
        dt_exp_w        varchar(2000);
        eval_exp_w      varchar(2000);
        rel_fac_w       varchar(2000);
        num_diag_w      varchar(2000);

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
            FOR r_c01 IN c01 LOOP IF ( ie_record_type_p = 'SNCP' ) THEN
                IF ( r_c01.ie_field = 'DIAG' ) THEN
                    ds_content_w := clipboard_util_pkg.obter_sncp_format(i.data_w, r_c01.ie_field, config_option_p);
                    SELECT
                        nm_field
                    INTO STRICT nm_exp_w
                    FROM
                        TABLE( clipboard_util_pkg.get_clipboard_rule('SNCP') )
                    WHERE
                        nr_seq = config_option_p
                        AND ie_field = 'DIAG';

                END IF;

                IF ( r_c01.ie_field = 'DIAG_DATE' ) THEN
                    ds_content_w := clipboard_util_pkg.obter_sncp_format(i.data_w, r_c01.ie_field, config_option_p);
                    SELECT
                        nm_field
                    INTO STRICT dt_exp_w
                    FROM
                        TABLE( clipboard_util_pkg.get_clipboard_rule('SNCP') )
                    WHERE
                        nr_seq = config_option_p
                        AND ie_field = 'DIAG_DATE';

                END IF;

                IF ( r_c01.ie_field = 'EVALUATN' ) THEN
                    ds_content_w := clipboard_util_pkg.obter_sncp_format(i.data_w, r_c01.ie_field, config_option_p);
                    SELECT
                        nm_field
                    INTO STRICT eval_exp_w
                    FROM
                        TABLE( clipboard_util_pkg.get_clipboard_rule('SNCP') )
                    WHERE
                        nr_seq = config_option_p
                        AND ie_field = 'EVALUATN';

                END IF;

                IF ( r_c01.ie_field = 'REL_FAC' ) THEN
                    ds_content_w := clipboard_util_pkg.obter_sncp_format(i.data_w, r_c01.ie_field, config_option_p);
                    SELECT
                        nm_field
                    INTO STRICT rel_fac_w
                    FROM
                        TABLE( clipboard_util_pkg.get_clipboard_rule('SNCP') )
                    WHERE
                        nr_seq = config_option_p
                        AND ie_field = 'REL_FAC';

                END IF;

                IF ( r_c01.ie_field = 'NUM_DIAG' ) THEN
                    ds_content_w := clipboard_util_pkg.obter_sncp_format(i.data_w, r_c01.ie_field, config_option_p);
                    SELECT
                        nm_field
                    INTO STRICT num_diag_w
                    FROM
                        TABLE( clipboard_util_pkg.get_clipboard_rule('SNCP') )
                    WHERE
                        nr_seq = config_option_p
                        AND ie_field = 'NUM_DIAG';

               END IF;

            END IF;
            END LOOP;

            ds_content_w1 := ds_content_w1
                             || ds_content_w
                             || '</br>';
        END LOOP;

        RETURN replace(replace(replace(replace(replace(ds_content_w1, obter_desc_expressao(822287), coalesce(nm_exp_w, obter_desc_expressao(822287
        ))), obter_desc_expressao(288452), coalesce(dt_exp_w, obter_desc_expressao(288452))), obter_desc_expressao(315181), coalesce(eval_exp_w
        , obter_desc_expressao(315181))), obter_desc_expressao(307595), coalesce(rel_fac_w, obter_desc_expressao(307595))),
		    obter_desc_expressao(1062798), coalesce(num_diag_w, obter_desc_expressao(1062798)));

    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clipboard_util_pkg.get_content_sncp ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint ) FROM PUBLIC;
