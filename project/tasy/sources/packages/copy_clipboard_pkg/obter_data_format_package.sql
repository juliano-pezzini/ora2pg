-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/* Function to get the formatted data */

CREATE OR REPLACE FUNCTION copy_clipboard_pkg.obter_data_format ( ie_record_type_p text, nr_sequencia_p bigint, nr_atendimento_p bigint ) RETURNS varchar AS $body$
DECLARE


        ds_txt_w           varchar(2000);
        diag_option_w      bigint;
        record_type_w      varchar(2000);
        staff_option_w     bigint;
        date_entrada_w     timestamp;
        medico_resp_w      varchar(2000);
        medico_refer_w     varchar(2000);
        pessoa_fisica_w    varchar(2000);
        asist_w            varchar(2000);
        p_s_nur_team_w     varchar(2000);
        nm_medico_w        varchar(2000);
        nr_cirugia_w       bigint;
        ie_pres_option_w   bigint;
        ie_dpc_option_w    bigint;

BEGIN
        SELECT
            ie_diagnosis_option,
            ie_staff_option,
            ie_pres_option
        INTO STRICT
            diag_option_w,
            staff_option_w,
            ie_pres_option_w
        FROM
            clipboard_config;

        SELECT
            dt_entrada,
            cd_medico_resp,
            cd_medico_referido,
            cd_pessoa_fisica
        INTO STRICT
            date_entrada_w,
            medico_resp_w,
            medico_refer_w,
            pessoa_fisica_w
        FROM
            atendimento_paciente
        WHERE
            nr_atendimento = nr_atendimento_p;

        IF ( ie_record_type_p = 'DIA' ) THEN
            IF ( diag_option_w = 1 ) THEN
                SELECT
                    cd_doenca
                INTO STRICT ds_txt_w
                FROM
                    paciente_antec_clinico
                WHERE
                    nr_sequencia = nr_sequencia_p
                    AND nr_atendimento = nr_atendimento_p;

            ELSIF ( diag_option_w = 2 ) THEN
                SELECT
                    cd_doenca
                    || ','
                    || cd_setor_atendimento
                INTO STRICT ds_txt_w
                FROM
                    paciente_antec_clinico
                WHERE
                    nr_sequencia = nr_sequencia_p
                    AND nr_atendimento = nr_atendimento_p;

            ELSIF ( diag_option_w = 3 ) THEN
                SELECT
                    cd_doenca
                    || ','
                    || obter_desc_expressao(nr_seq_doenca)
                    || ','
                    || cd_setor_atendimento
                    || ', From '
                    || trim(both dt_inicio)
                    || ','
                    || ie_status
                INTO STRICT ds_txt_w
                FROM
                    paciente_antec_clinico
                WHERE
                    nr_sequencia = nr_sequencia_p
                    AND nr_atendimento = nr_atendimento_p;

            END IF;
        END IF;

        IF ( ie_record_type_p = 'STA' ) THEN

            SELECT
                clipboard_info_concat(pessoa_fisica_w)
            INTO STRICT p_s_nur_team_w
;

            SELECT
                clipboard_medico_concat(nr_atendimento_p)
            INTO STRICT nm_medico_w
;


            IF ( staff_option_w = 1 ) THEN
                ds_txt_w := trim(both date_entrada_w)
                            || ','
                            || 'Attending physician :'
                            || obter_nome_pf(medico_resp_w)
                            || ','
                            || 'Nurse-Primary :'
                            || p_s_nur_team_w;
            ELSIF ( staff_option_w = 2 ) THEN
                ds_txt_w := trim(both date_entrada_w)
                            || ','
                            || 'Attending physician :'
                            || obter_nome_pf(medico_resp_w)
                            || ','
                            || ' Assistant physician:'
                            || nm_medico_w;
            ELSIF ( staff_option_w = 3 ) THEN
                ds_txt_w := trim(both date_entrada_w)
                            || ','
                            || 'Nursing Team :'
                            || p_s_nur_team_w;
            END IF;

        END IF;

        IF ( ie_record_type_p = 'CIR' ) THEN
            nr_cirugia_w := nr_sequencia_p;
            SELECT
                obter_desc_proc_interno(nr_seq_proc_interno)
                || ','
                || dt_inicio_prevista
                || ','
                || obter_ds_setor_atendimento(cd_setor_atendimento)
            INTO STRICT ds_txt_w
            FROM
                cirurgia
            WHERE
                nr_cirurgia = nr_cirugia_w
                AND nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( ie_record_type_p = 'ADM_H' ) THEN
            SELECT
                to_char(a.dt_internacao, 'YYYY')
                || ','
                || abs(round((clock_timestamp() - to_date(b.dt_nascimento)) / 365))
                || 'years old,'
                || a.cd_doenca
                || ' (Hospitalization)'
            INTO STRICT ds_txt_w
            FROM
                historico_saude_internacao   a,
                pessoa_fisica                b
            WHERE
                a.nr_sequencia = nr_sequencia_p
                AND a.cd_pessoa_fisica = b.cd_pessoa_fisica
                AND a.cd_pessoa_fisica = pessoa_fisica_w;

        END IF;

        IF ( ie_record_type_p = 'SUR_H' ) THEN
            SELECT
                to_char(a.dt_inicio, 'YYYY')
                || ','
                || abs(round((clock_timestamp() - to_date(b.dt_nascimento)) / 365))
                || 'years old,'
                || a.ds_procedimento_inf
                || '(Surgery)'
            INTO STRICT ds_txt_w
            FROM
                historico_saude_cirurgia   a,
                pessoa_fisica              b
            WHERE
                a.cd_pessoa_fisica = b.cd_pessoa_fisica
                AND a.nr_atendimento = nr_atendimento_p
                AND a.nr_sequencia = nr_sequencia_p;

        END IF;

        IF ( ie_record_type_p = 'TRF_H' ) THEN
            SELECT
                to_char(a.dt_transfusao, 'YYYY')
                || ','
                || abs(round((clock_timestamp() - to_date(b.dt_nascimento)) / 365))
                || 'years old,'
                || a.nr_seq_derivado
                || '(Transfusion)'
            INTO STRICT ds_txt_w
            FROM
                paciente_transfusao   a,
                pessoa_fisica         b
            WHERE
                a.cd_pessoa_fisica = b.cd_pessoa_fisica
                AND a.cd_pessoa_fisica = pessoa_fisica_w
                AND a.nr_sequencia = nr_sequencia_p;

        END IF;

        IF ( ie_record_type_p = 'FAM_H' ) THEN
            SELECT
                nr_seq_parentesco
                || ','
                || cd_doenca
            INTO STRICT ds_txt_w
            FROM
                paciente_antec_clinico
            WHERE
                nr_atendimento = nr_atendimento_p
                AND nr_sequencia = nr_sequencia_p;

        END IF;

        IF ( ie_record_type_p = 'PRES' ) THEN
            IF ( ie_pres_option_w = 1 ) THEN
                SELECT
                    cd_material
                    || ','
                    || qt_dose
                INTO STRICT ds_txt_w
                FROM
                    paciente_medic_uso
                WHERE
                    nr_sequencia = nr_sequencia_p
                    AND nr_atendimento = nr_atendimento_p;

            ELSIF ( ie_pres_option_w = 2 ) THEN
                SELECT
                    dt_inicio
                    || '('
                    || obter_ds_setor_atendimento(cd_setor_atendimento)
                    || ')'
                    || cd_material
                    || ' '
                    || qt_dose
                    || cd_unid_med
                    || ','
                    || cd_intervalo
                    || ','
                    || ds_reacao
                INTO STRICT ds_txt_w
                FROM
                    paciente_medic_uso
                WHERE
                    nr_sequencia = nr_sequencia_p
                    AND nr_atendimento = nr_atendimento_p;

            END IF;
        END IF;

        IF ( ie_record_type_p = 'DPC' ) THEN
            IF ( ie_dpc_option_w = 1 ) THEN
                SELECT
                    dt_start_dpc
                    || ','
                    || si_category
                INTO STRICT ds_txt_w
                FROM
                    patient_dpc
                WHERE
                    nr_atendimento = nr_atendimento_p
                    AND nr_sequencia = nr_sequencia_p;

            ELSIF ( ie_dpc_option_w = 2 ) THEN
                SELECT
                    dt_start_dpc
                    || ','
                    || si_category
                    || ','
                    || cd_departamento
                    || ','
                    || nr_seq_dpc_score
                    || ','
                    || nr_seq_most_exp_diagnosis
                INTO STRICT ds_txt_w
                FROM
                    patient_dpc
                WHERE
                    nr_atendimento = nr_atendimento_p
                    AND nr_sequencia = nr_sequencia_p;

            END IF;
        END IF;

        
        IF (ie_record_type_p='HOS_H')THEN
        
        select DT_ENTRADA_UNIDADE||','||DT_SAIDA_UNIDADE||','||CD_DEPARTAMENTO||','||CD_SETOR_ATENDIMENTO INTO STRICT ds_txt_w from ATEND_PACIENTE_UNIDADE 
        WHERE nr_atendimento = nr_atendimento_p
                    AND nr_sequencia = nr_sequencia_p;

        END IF;

        
        

        RETURN ds_txt_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION copy_clipboard_pkg.obter_data_format ( ie_record_type_p text, nr_sequencia_p bigint, nr_atendimento_p bigint ) FROM PUBLIC;