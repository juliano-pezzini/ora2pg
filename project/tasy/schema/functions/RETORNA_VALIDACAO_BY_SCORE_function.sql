-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_validacao_by_score ( nr_atendimento_p nursing_care_encounter.nr_atendimento%TYPE, nr_seq_nivel_p nursing_care_encounter.nr_seq_nivel%TYPE DEFAULT 1) RETURNS varchar AS $body$
DECLARE

    retorno_w nursing_care_version.NM_FORMULARIO%type;
    ie_existe_w nursing_care_version.nr_sequencia%type := 0;
    ie_count nursing_care_encounter.NR_SEQUENCIA%type;
    tipo_formulario_W2 nursing_care_version.ie_tipo_formulario%type;
    qt_pontuacao_a_w nursing_care_encounter.qt_pontuacao_a%type;
    qt_pontuacao_b_w nursing_care_encounter.qt_pontuacao_b%type;
    qt_pontuacao_c_w nursing_care_encounter. qt_pontuacao_c%type;


BEGIN

    BEGIN
        SELECT  query_select.ie_tipo_formulario
          INTO STRICT  tipo_formulario_W2 
          FROM (
                    SELECT v.ie_tipo_formulario
                      FROM nursing_care_encounter   e
                INNER JOIN nursing_care_version     v  ON e.nr_seq_nursing_care = v.nr_sequencia
                     WHERE e.nr_atendimento = nr_atendimento_p
                       AND (e.dt_liberacao IS NOT NULL AND e.dt_liberacao::text <> '')
                       AND e.ie_situacao = 'A'
                       AND e.nr_seq_nivel = nr_seq_nivel_p
                  ORDER BY e.dt_atualizacao DESC
                ) query_select LIMIT 1;

        SELECT CASE 
            WHEN TRUNC(CURRENT_DATE) = (SELECT TRUNC(Max(e.dt_avaliacao))
                                          FROM nursing_care_encounter e
                                         WHERE e.nr_atendimento = nr_atendimento_P) 
                  THEN (SELECT e.QT_PONTUACAO_A
                          FROM nursing_care_encounter e
                         WHERE e.nr_atendimento = nr_atendimento_P
                           AND e.nr_seq_nivel = nr_seq_nivel_p
                           AND e.ie_situacao = 'A'
                           AND e.dt_avaliacao = (SELECT max(e.dt_avaliacao)
                                                   FROM nursing_care_encounter e
                                                  WHERE e.nr_atendimento = nr_atendimento_P
                                                    AND e.nr_seq_nivel = nr_seq_nivel_p
                                                    AND e.ie_situacao = 'A')) 
            ELSE NULL
            END 
        INTO STRICT qt_pontuacao_a_w 
;

        SELECT CASE 
            WHEN TRUNC(CURRENT_DATE) = (SELECT TRUNC(Max(e.dt_avaliacao))
                                          FROM nursing_care_encounter e
                                         WHERE e.nr_atendimento = nr_atendimento_P) 
                  THEN (SELECT e.QT_PONTUACAO_B
                          FROM nursing_care_encounter e
                         WHERE e.nr_atendimento = nr_atendimento_P
                           AND e.nr_seq_nivel = nr_seq_nivel_p
                           AND e.ie_situacao = 'A'
                           AND e.dt_avaliacao = (SELECT max(e.dt_avaliacao)
                                                   FROM nursing_care_encounter e
                                                  WHERE e.nr_atendimento = nr_atendimento_P
                                                    AND e.nr_seq_nivel = nr_seq_nivel_p
                                                    AND e.ie_situacao = 'A')) 
            ELSE NULL 
            END 
        INTO STRICT qt_pontuacao_b_w 
;

        SELECT CASE
            WHEN TRUNC(CURRENT_DATE) = (SELECT TRUNC(Max(e.dt_avaliacao))
                                          FROM nursing_care_encounter e
                                         WHERE e.nr_atendimento = nr_atendimento_P) 
                  THEN (SELECT e.QT_PONTUACAO_C
                          FROM nursing_care_encounter e
                         WHERE e.nr_atendimento = nr_atendimento_P
                           AND e.nr_seq_nivel = nr_seq_nivel_p
                           AND e.ie_situacao = 'A'
                           AND e.dt_avaliacao = (SELECT max(e.dt_avaliacao)
                                                   FROM nursing_care_encounter e
                                                  WHERE e.nr_atendimento = nr_atendimento_P
                                                    AND e.nr_seq_nivel = nr_seq_nivel_p
                                                    AND e.ie_situacao = 'A')) 
            ELSE NULL 
            END 
        INTO STRICT qt_pontuacao_c_w
;

        IF (tipo_formulario_W2 = 'G') THEN
            SELECT CASE 
                WHEN(qt_pontuacao_c_w >= 1 OR qt_pontuacao_a_w >= 3 OR (qt_pontuacao_a_w >= 2  AND qt_pontuacao_b_w >= 3)) THEN 1
                ELSE 0 END
            INTO STRICT ie_existe_w    
;
        END IF;

        IF (tipo_formulario_W2 = 'H') THEN
            SELECT CASE
                WHEN(qt_pontuacao_a_w >= 3 OR qt_pontuacao_b_w>= 4) THEN 1
                ELSE 0 END
            INTO STRICT ie_existe_w
;
        END IF;

        IF (tipo_formulario_W2 = 'I') THEN
            SELECT CASE
                WHEN(qt_pontuacao_a_w >= 4 OR qt_pontuacao_b_w >= 3) THEN 1
                ELSE 0 END
            INTO STRICT ie_existe_w
;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            ie_existe_w := 0;
    END;

    IF (ie_existe_w > 0) THEN
        retorno_w := obter_desc_expressao(928855, NULL);
    ELSE
        retorno_w := obter_desc_expressao(928857, NULL);
    END IF;

	RETURN retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_validacao_by_score ( nr_atendimento_p nursing_care_encounter.nr_atendimento%TYPE, nr_seq_nivel_p nursing_care_encounter.nr_seq_nivel%TYPE DEFAULT 1) FROM PUBLIC;
