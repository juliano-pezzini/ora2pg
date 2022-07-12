-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clipboard_util_pkg.get_content_diagnosis ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint ) RETURNS varchar AS $body$
DECLARE


        ds_content_w   varchar(32000);
        diag_w         varchar(1000);
        clasfn_w       varchar(1000);
        dept_w         varchar(1000);
        tm_prd_w       varchar(1000);
        ot_cm_w        varchar(1000);
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
                obter_desc_cid_doenca(cd_doenca),
                substr(obter_valor_dominio(58,(select max(ie_classificacao_doenca) from diagnostico_doenca x
                where x.IE_DIAG_PRINC_DEPART = 'S' and x.nr_atendimento = nr_atendimento_p)),1,255),
                GET_DATA_MEDICAL_DEPARTMENT(cd_departamento_med,'DS'),
                pkg_date_formaters.to_varchar(dt_inicio, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario
                )
                || '~'
                || pkg_date_formaters.to_varchar(dt_fim, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario
                ),
                obter_status_problema(ie_status_problema)
            INTO STRICT
                diag_w,
                clasfn_w,
                dept_w,
                tm_prd_w,
                ot_cm_w
            FROM
                diagnostico_doenca a
            WHERE
                nr_atendimento = nr_atendimento_p
                AND nr_seq_interno = i.data_w;

            FOR r_c01 IN c01 LOOP IF ( ie_record_type_p = 'DIAGNOSIS' ) THEN
                IF ( r_c01.ie_field = 'DISC_NM' ) THEN
                    IF (diag_w IS NOT NULL AND diag_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || diag_w;

                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'MED_DEPT' ) THEN
                    IF (dept_w IS NOT NULL AND dept_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || dept_w;

                    END IF;

                END IF;

                IF ( r_c01.ie_field = 'CLASIFITN' ) THEN
                    IF (clasfn_w IS NOT NULL AND clasfn_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || clasfn_w;

                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'OUTCOME' ) THEN
                    IF (ot_cm_w IS NOT NULL AND ot_cm_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || ot_cm_w;

                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'TIME_PERIOD' ) THEN
                    IF ( (tm_prd_w IS NOT NULL AND tm_prd_w::text <> '') AND position('~' in tm_prd_w) != 1 ) THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || tm_prd_w;

                    END IF;
                END IF;

            END IF;
            END LOOP;

            ds_content_w := ds_content_w || '</br>';
        END LOOP;

        RETURN ds_content_w;
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clipboard_util_pkg.get_content_diagnosis ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint ) FROM PUBLIC;
