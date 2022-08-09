-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_horario_prescr_md ( ds_dose_diferenciada_p INOUT text, ie_dose_diferenciada_p text, ie_operacao_p text, qt_operacao_p INOUT bigint, ds_caracter_espaco_p text, dt_medic_p timestamp, ds_mascara_data_p text, ie_exclui_hor_dd_zerados_p text, dt_hora_inicio_p timestamp, qt_doses_p INOUT bigint, ds_dt_prescr_p text, dt_inicio_prescr_p timestamp, qt_min_intervalo_p bigint, ie_utiliza_quantidade_p text, nr_hora_validade_p bigint, qt_min_intervalo_aux_p text, dt_validade_prescr_p timestamp, ds_horarios_fixo_p INOUT text, ds_horarios_p INOUT text, nr_intervalo_p INOUT bigint, hr_prescricao_p INOUT timestamp ) AS $body$
DECLARE


    qt_hora_intervalo_w     double precision;
    ds_dose_w               varchar(255);
    ds_hora_aux_w           varchar(255);
    ds_horarios_aux_w       varchar(4000);
    hr_dose_w               timestamp;
    ie_virgula_w            varchar(1);
    nr_cont_w               integer;
    dt_prox_horario_w       timestamp;
    ds_hora_w               varchar(7);
    ie_utiliza_mascara_w    varchar(1);
    k                       integer;
    nr_horas_intervalo_w    double precision;

    ie_controle_w           smallint := 0;
    dt_horario_w            timestamp;
    qt_dia_adic_w           bigint := 0;

    nr_posicao_w          integer;
    nr_pos_inicial_w      integer;
    nr_pos_final_w        integer;
    nr_tam_delimitador_w  integer;
    qt_valor_w            varchar(200);
    ds_delimitador_w      varchar(1) := ',';

    
BEGIN
    IF (ds_dose_diferenciada_p IS NOT NULL AND ds_dose_diferenciada_p::text <> '')
        AND ( ie_dose_diferenciada_p IN ( 'O', 'P', 'S' ) )
    THEN
        IF ( ie_operacao_p = 'V' ) THEN
            qt_hora_intervalo_w := dividir_sem_round_md(24, qt_operacao_p);
        ELSIF ( ie_operacao_p = 'H' ) THEN
            qt_hora_intervalo_w := qt_operacao_p;
        ELSIF ( ie_operacao_p = 'X' ) THEN
            qt_hora_intervalo_w := dividir_sem_round_md(24, qt_operacao_p);
        END IF;

        IF ( ie_operacao_p = 'V' ) THEN

            ds_horarios_p := padroniza_horario_md(reordenar_horarios_md(dt_medic_p, ds_horarios_p))
                             || ds_caracter_espaco_p;

        END IF;

        IF ( ie_operacao_p = 'F' ) OR ( ie_operacao_p = 'V' ) OR ( ie_dose_diferenciada_p = 'S'  AND  ie_operacao_p = 'X' ) THEN


            IF ( nr_intervalo_p > qt_operacao_p ) THEN
                qt_operacao_p := nr_intervalo_p;
            END IF;
            ds_horarios_p := ds_horarios_p || ds_caracter_espaco_p;

            ds_dose_diferenciada_p := tiss_substituir_string_md(ds_dose_diferenciada_p, ',', '')
                                      || '-';

            FOR z IN 1..qt_operacao_p LOOP
                ds_dose_w := substr(ds_dose_diferenciada_p, 1, position('-' in ds_dose_diferenciada_p) - 1);

                ds_dose_diferenciada_p := substr(ds_dose_diferenciada_p, position('-' in ds_dose_diferenciada_p) + 1, 255);

                ds_hora_aux_w := substr(ds_horarios_p, 1, position(ds_caracter_espaco_p in ds_horarios_p) - 1);

                ds_horarios_p := substr(ds_horarios_p, position(ds_caracter_espaco_p in ds_horarios_p) + 1, 255);

                IF ( somente_numero_md(ds_dose_w) > 0 ) OR ( coalesce(ie_exclui_hor_dd_zerados_p, 'S') = 'N' ) THEN
                    ds_horarios_aux_w := ds_horarios_aux_w
                                         || ds_hora_aux_w
                                         || ds_caracter_espaco_p;
                END IF;

            END LOOP;

            ds_horarios_p := ds_horarios_aux_w;
        ELSE
            ds_horarios_p := '';
            hr_dose_w := dt_hora_inicio_p;
            ie_virgula_w := 'N';
            nr_cont_w := 0;
            ds_dose_diferenciada_p := tiss_substituir_string_md(ds_dose_diferenciada_p, ',', '')
                                      || '-';
            FOR x IN 1..length(ds_dose_diferenciada_p) LOOP
                IF ( substr(ds_dose_diferenciada_p, x, 1) = '-' ) THEN
                    qt_doses_p := qt_doses_p + 1;
                    ds_hora_w := to_char(hr_dose_w, ds_mascara_data_p);
                    IF ( substr(ds_dose_diferenciada_p, x, 1) <> '0' ) OR ( coalesce(ie_exclui_hor_dd_zerados_p, 'S') = 'N' ) THEN
                        ds_horarios_p := ds_horarios_p
                                         || ds_hora_w
                                         || ds_caracter_espaco_p;
                    END IF;

                    hr_dose_w := hr_dose_w + dividir_sem_round((qt_hora_intervalo_w)::numeric, 24);
                END IF;
            END LOOP;

            nr_intervalo_p := coalesce(qt_doses_p, 0);
        END IF;

    ELSIF ( ie_operacao_p = 'D' ) THEN
        IF ( coalesce(ds_horarios_p::text, '') = '' ) THEN
            nr_intervalo_p := 1;
            IF ( to_char(dt_hora_inicio_p, 'mi') = '00' ) THEN
                ds_horarios_p := to_char(dt_hora_inicio_p, 'hh24');
            ELSE
                ds_horarios_p := to_char(dt_hora_inicio_p, 'hh24:mi');
            END IF;

        ELSE
            nr_intervalo_p := qt_operacao_p;
            ds_horarios_p := ds_horarios_p;
        END IF;
    ELSIF ( ie_operacao_p = 'M' ) THEN
        nr_intervalo_p := 1;
        ds_horarios_p := to_char(dt_hora_inicio_p, 'hh24:mi');
        dt_prox_horario_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(to_date(ds_dt_prescr_p), dt_hora_inicio_p);

            IF length(qt_min_intervalo_aux_p) > 0 THEN
                nr_posicao_w := 1;
                nr_pos_final_w := length(qt_min_intervalo_aux_p) + 1;
                nr_tam_delimitador_w := length(ds_delimitador_w);
                LOOP
                    nr_pos_inicial_w := instr(qt_min_intervalo_aux_p, ds_delimitador_w, nr_posicao_w);
                    IF nr_pos_inicial_w = 0 THEN
                        nr_pos_inicial_w := nr_pos_final_w;
                    END IF;
                    qt_valor_w := substr(qt_min_intervalo_aux_p, nr_posicao_w, nr_pos_inicial_w - nr_posicao_w);
                    nr_intervalo_p := nr_intervalo_p + 1;
                    dt_prox_horario_w := dt_prox_horario_w +  dividir_sem_round_md(qt_valor_w , 1440);
                    EXIT WHEN nr_pos_inicial_w = nr_pos_final_w;
                    nr_posicao_w := nr_pos_inicial_w + nr_tam_delimitador_w;
                    ds_horarios_p := ds_horarios_p
                                 || ds_caracter_espaco_p
                                 || to_char(dt_prox_horario_w, 'hh24:mi');

                END LOOP;

            END IF;

    ELSIF ( ie_operacao_p = 'F' )
        AND (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '')
    THEN
        BEGIN
            nr_intervalo_p := qt_operacao_p;
        END;
    ELSIF ( ie_operacao_p = 'V' )
        AND (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '')
    THEN
        BEGIN
            ie_utiliza_mascara_w := 'S';
            IF ( position(':' in ds_horarios_p) = 0 ) THEN
                ie_utiliza_mascara_w := 'N';
            END IF;

            ds_horarios_aux_w := replace(replace(replace(ds_horarios_p, '  ', ' '), '  ', ' '), '  ', ' ');

            ds_horarios_p := padroniza_horario_prescr_md(reordenar_horarios_md(trunc(dt_medic_p, 'mi'), ds_horarios_aux_w), to_char(
            trunc(dt_inicio_prescr_p, 'mi'), 'dd/mm/yyyy hh24:mi:ss'))
                             || ds_caracter_espaco_p;

            nr_intervalo_p := 0;
            WHILE (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') LOOP
                BEGIN
                    k := position(' ' in ds_horarios_p);
                    IF ( k > 1 )
                        AND ( (substr(ds_horarios_p, 1, k - 1) IS NOT NULL AND (substr(ds_horarios_p, 1, k - 1))::text <> '') )
                    THEN
                        BEGIN
                            ds_hora_w := substr(ds_horarios_p, 1, k - 1);
                            ds_hora_w := replace(ds_hora_w, ds_caracter_espaco_p, '');
                            ds_horarios_p := substr(ds_horarios_p, k + 1, 2000);
                            IF ( ie_controle_w = 0 )
                                AND ( ds_hora_w < to_char(dt_inicio_prescr_p, 'hh24:mi') )
                            THEN
                                qt_dia_adic_w := 1;
                            ELSIF ( position('A' in ds_hora_w) > 0 )
                                AND ( qt_dia_adic_w = 0 )
                            THEN
                                qt_dia_adic_w := 1;
                            ELSIF ( position('AA' in ds_hora_w) > 0 ) THEN
                                qt_dia_adic_w := qt_dia_adic_w + 1;
                            END IF;

                            ie_controle_w := 1;
                            ds_hora_w := replace(ds_hora_w, 'A', '');
                            ds_hora_w := replace(ds_hora_w, 'A', '');
                            dt_horario_w	:= trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_p + qt_dia_adic_w, replace(ds_hora_w,'A','')), 'mi');
                            IF ( dt_horario_w >= trunc(dt_medic_p, 'mi') )
                                AND ( dt_horario_w <= dt_validade_prescr_p )
                            THEN
                                BEGIN
                                    IF ( ie_utiliza_mascara_w = 'N' ) THEN
                                        ds_hora_w := substr(ds_hora_w, 1, 2);
                                    END IF;

                                    ds_horarios_fixo_p := ds_horarios_fixo_p
                                                          || ds_hora_w
                                                          || ds_caracter_espaco_p;
                                    nr_intervalo_p := nr_intervalo_p + 1;
                                END;
                            END IF;

                        END;

                    ELSIF (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') THEN
                        BEGIN
                            ds_horarios_p := '';
                        END;
                    END IF;

                END;
            END LOOP;

            ds_horarios_p := ds_horarios_fixo_p;
        END;
    ELSE
        BEGIN
            IF ( nr_intervalo_p > 0 ) THEN
                IF ( ie_operacao_p = 'H' ) THEN
                    nr_horas_intervalo_w := qt_operacao_p;
                ELSE
                    IF ( coalesce(ie_utiliza_quantidade_p, 'N') = 'N' ) THEN
                        nr_horas_intervalo_w := trunc(dividir_sem_round_md(nr_hora_validade_p, nr_intervalo_p));
                    ELSE
                        nr_horas_intervalo_w := nr_intervalo_p;
                    END IF;
                END IF;
            ELSIF ( ie_operacao_p = 'H' ) THEN
                BEGIN
                    nr_horas_intervalo_w := qt_operacao_p;
                    nr_intervalo_p := ceil(dividir_sem_round_md(nr_hora_validade_p, nr_horas_intervalo_w));
                END;
            ELSIF ( ie_operacao_p = 'X' ) THEN
                BEGIN
                    IF ( coalesce(ie_utiliza_quantidade_p, 'N') = 'N' ) THEN
                        nr_intervalo_p := ceil(dividir_sem_round_md(nr_hora_validade_p ,(dividir_sem_round_md(24, qt_operacao_p))));
                    ELSE
                        nr_intervalo_p := qt_operacao_p;
                    END IF;

                    nr_horas_intervalo_w := floor(dividir_sem_round_md(24, qt_operacao_p));
                    IF ( coalesce(qt_min_intervalo_p, 0) > 0 )
                        AND ( nr_horas_intervalo_w >= floor(dividir_md(qt_min_intervalo_p, 60)) )
                    THEN
                        nr_horas_intervalo_w := dividir_sem_round_md(qt_min_intervalo_p, 60);
                    END IF;

                    IF ( nr_intervalo_p = 0 ) OR ( coalesce(nr_intervalo_p::text, '') = '' ) THEN
                        nr_intervalo_p := 1;
                    END IF;

                END;
            ELSE
                BEGIN
                    nr_intervalo_p := 1;
                    nr_horas_intervalo_w := 0;
                END;
            END IF;

            ds_horarios_p := '';
            hr_prescricao_p := dt_hora_inicio_p;
            FOR i IN 1..nr_intervalo_p LOOP
                BEGIN
                    ds_hora_w := to_char(hr_prescricao_p, ds_mascara_data_p);
                    ds_horarios_p := ds_horarios_p
                                     || ds_hora_w
                                     || ds_caracter_espaco_p;
                    hr_prescricao_p := hr_prescricao_p + ( dividir_sem_round_md(nr_horas_intervalo_w, 24) );
                END;
            END LOOP;

        END;
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_horario_prescr_md ( ds_dose_diferenciada_p INOUT text, ie_dose_diferenciada_p text, ie_operacao_p text, qt_operacao_p INOUT bigint, ds_caracter_espaco_p text, dt_medic_p timestamp, ds_mascara_data_p text, ie_exclui_hor_dd_zerados_p text, dt_hora_inicio_p timestamp, qt_doses_p INOUT bigint, ds_dt_prescr_p text, dt_inicio_prescr_p timestamp, qt_min_intervalo_p bigint, ie_utiliza_quantidade_p text, nr_hora_validade_p bigint, qt_min_intervalo_aux_p text, dt_validade_prescr_p timestamp, ds_horarios_fixo_p INOUT text, ds_horarios_p INOUT text, nr_intervalo_p INOUT bigint, hr_prescricao_p INOUT timestamp ) FROM PUBLIC;
