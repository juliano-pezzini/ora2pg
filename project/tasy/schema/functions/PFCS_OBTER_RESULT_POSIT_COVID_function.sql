-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_obter_result_posit_covid ( nr_atendimento_p bigint ) RETURNS varchar AS $body$
DECLARE

    ds_resultado_w varchar(8);

BEGIN
     -- quick covid exam
    SELECT
        upper(coalesce(MAX(a.ie_atend_covid_posit), 'ND'))
    INTO STRICT 
        ds_resultado_w
    FROM
        atend_paciente_adic a
        INNER JOIN atendimento_paciente b ON a.nr_atendimento = b.nr_atendimento
        INNER JOIN paciente_exame e ON b.cd_pessoa_fisica = e.cd_pessoa_fisica
    WHERE (a.ie_atend_covid_posit IS NOT NULL AND a.ie_atend_covid_posit::text <> '')
        AND coalesce(e.dt_inativacao::text, '') = ''
        AND a.nr_atendimento = nr_atendimento_p;

    -- normal covid exam
    IF ds_resultado_w = 'ND' THEN
         -- search if is a covid exame if it is return 'ND' else 'SE'
        SELECT
            CASE WHEN COUNT(1)=0 THEN  'SE'  ELSE 'ND' END
        INTO STRICT
            ds_resultado_w
        FROM
            prescr_procedimento   pp
            INNER JOIN prescr_medica pm ON pp.nr_prescricao = pm.nr_prescricao
        WHERE
            pfcs_lab_obter_se_exame_covid(nr_seq_exame) = 'S'
            AND pm.nr_atendimento = nr_atendimento_p
			      AND (pm.dt_liberacao IS NOT NULL AND pm.dt_liberacao::text <> '');

        -- if it is an exame covid 19   find if the diagnostic is a Positive or Negative. if is Positive return 'S' else if Negative return 'N' else 'ND'   
        IF ds_resultado_w = 'ND'  THEN
            SELECT
                CASE WHEN substr(UPPER(coalesce(MAX(elri.ds_resultado), 'ND')),1,7)=substr(UPPER(obter_desc_expressao(296109)),1,7) THEN  'S' WHEN substr(UPPER(coalesce(MAX(elri.ds_resultado), 'ND')),1,7)=substr(UPPER(obter_desc_expressao(328863)),1,7) THEN  'N'  ELSE 'ND' END 
                INTO STRICT ds_resultado_w
            FROM
                prescr_procedimento   pp
                INNER JOIN prescr_medica pm ON pp.nr_prescricao = pm.nr_prescricao
                INNER JOIN exame_lab_result_item elri ON pp.nr_sequencia = elri.nr_seq_prescr
                INNER JOIN exame_lab_resultado elr ON pm.nr_prescricao = elr.nr_prescricao AND elri.nr_seq_resultado = elr.nr_seq_resultado
            WHERE
                pfcs_lab_obter_se_exame_covid(pp.nr_seq_exame) = 'S'
                AND pm.nr_atendimento = nr_atendimento_p
                AND pp.ie_status_atend >= 35
                AND (pm.dt_liberacao IS NOT NULL AND pm.dt_liberacao::text <> '');
         END IF;
     END IF;

    RETURN ds_resultado_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_obter_result_posit_covid ( nr_atendimento_p bigint ) FROM PUBLIC;

