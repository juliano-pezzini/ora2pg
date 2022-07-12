-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clipboard_util_pkg.get_content_hosp_hist ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint ) RETURNS varchar AS $body$
DECLARE


        ds_content_w      varchar(32000);
        entr_dt_w         varchar(1000);
        disc_dt_w         varchar(1000);
        med_dept_w        varchar(1000);
        pessoa_fisica_w   varchar(1000);
        dept_w            varchar(1000);
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
        SELECT
            cd_pessoa_fisica
        INTO STRICT pessoa_fisica_w
        FROM
            atendimento_paciente
        WHERE
            nr_atendimento = nr_atendimento_p;

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
                pkg_date_formaters.to_varchar(c.dt_entrada_unidade, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck
                .get_nm_usuario),
                pkg_date_formaters.to_varchar(c.dt_saida_unidade, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck
                .get_nm_usuario),
                dm.ds_departamento,
                e.ds_setor_atendimento
            INTO STRICT
                entr_dt_w,
                disc_dt_w,
                med_dept_w,
                dept_w
            FROM setor_atendimento e, convenio d, atend_categoria_convenio b, atendimento_paciente a, atend_paciente_unidade c
LEFT OUTER JOIN departamento_medico dm ON (c.cd_departamento = dm.cd_departamento)
WHERE a.nr_atendimento = c.nr_atendimento AND c.nr_seq_interno = obter_atepacu_paciente(a.nr_atendimento, 'A') AND b.nr_seq_interno = obter_atecaco_atendimento(a.nr_atendimento) AND c.cd_setor_atendimento = e.cd_setor_atendimento AND b.cd_convenio = d.cd_convenio  AND a.cd_pessoa_fisica = cd_pessoa_fisica AND c.nr_seq_interno = i.data_w;

            FOR r_c01 IN c01 LOOP IF ( ie_record_type_p = 'HOSP_HIST' ) THEN
                IF ( r_c01.ie_field = 'HOSP_DATE' ) THEN
                    IF (entr_dt_w IS NOT NULL AND entr_dt_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || entr_dt_w;

                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'DIS_DATE' ) THEN
                    IF (disc_dt_w IS NOT NULL AND disc_dt_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || disc_dt_w;

                    END IF;

                END IF;

                IF ( r_c01.ie_field = 'MED_DEPT' ) THEN
                    IF (med_dept_w IS NOT NULL AND med_dept_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || med_dept_w;

                    END IF;
                END IF;

                IF ( r_c01.ie_field = 'DEPT' ) THEN
                    IF (dept_w IS NOT NULL AND dept_w::text <> '') THEN
                        ds_content_w := ds_content_w
                                        || '</br>'
                                        || coalesce(r_c01.nm_field, r_c01.ds_expressao)
                                        || ' - '
                                        || dept_w;

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
-- REVOKE ALL ON FUNCTION clipboard_util_pkg.get_content_hosp_hist ( nr_atendimento_p bigint, nr_sequencia_p text, ie_record_type_p text, config_option_p bigint ) FROM PUBLIC;
