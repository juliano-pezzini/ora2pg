-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION validate_batch_patient (cd_material_p MATERIAL.CD_MATERIAL%type, nr_prescricao_p PRESCR_MEDICA.NR_PRESCRICAO%type, nr_atendimento_p ATENDIMENTO_PACIENTE.NR_ATENDIMENTO%TYPE ) RETURNS varchar AS $body$
DECLARE


cd_paciente_w           PRESCR_MEDICA.CD_PESSOA_FISICA%TYPE;
cd_paciente_batch_w     PRESCR_MEDICA.CD_PESSOA_FISICA%TYPE;
dt_data_atual_w         CONSTANT timestamp := clock_timestamp();
ds_return_w             varchar(200) := NULL;
ie_situacao_ativo_s     MATERIAL_LOTE_FORNEC.IE_SITUACAO%TYPE := 'A';

BEGIN

IF PKG_I18N.GET_USER_LOCALE = 'es_AR' THEN
    IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN
        SELECT  ATENDIMENTO_PACIENTE.CD_PESSOA_FISICA
        INTO STRICT    cd_paciente_w
        FROM    ATENDIMENTO_PACIENTE
        WHERE   ATENDIMENTO_PACIENTE.NR_ATENDIMENTO = nr_atendimento_p;
    ELSE
        SELECT  PRESCR_MEDICA.CD_PESSOA_FISICA
        INTO STRICT    cd_paciente_w
        FROM    PRESCR_MEDICA
        WHERE   PRESCR_MEDICA.NR_PRESCRICAO = nr_prescricao_p;
    END IF;

    IF (coalesce(cd_paciente_w::text, '') = '') THEN
        ds_return_w := NULL;
    END IF;

    SELECT  MAX(B.CD_PACIENTE_LOTE_EXCLUS)
    INTO STRICT    cd_paciente_batch_w
    FROM    MATERIAL_LOTE_FORNEC A,
            MATERIAL_LOTE_FORNEC_PAC B
    WHERE   A.NR_SEQUENCIA = B.NR_SEQ_LOTE_FORNEC
    AND     A.CD_MATERIAL = cd_material_p
    AND     A.DT_VALIDADE >= dt_data_atual_w
    AND     A.IE_SITUACAO = ie_situacao_ativo_s
    AND (B.DT_FIM_VIGENCIA >= dt_data_atual_w
        OR   coalesce(B.DT_FIM_VIGENCIA::text, '') = '')
    AND     B.DT_INICIO_VIGIENCIA <= dt_data_atual_w
    AND     coalesce(B.DT_CANCEL_VIGENCIA::text, '') = '';

    IF ((cd_paciente_batch_w IS NOT NULL AND cd_paciente_batch_w::text <> '') AND cd_paciente_batch_w <> cd_paciente_w) THEN
        ds_return_w := obter_desc_expressao(1069438);
    END IF;
END IF;

  RETURN ds_return_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION validate_batch_patient (cd_material_p MATERIAL.CD_MATERIAL%type, nr_prescricao_p PRESCR_MEDICA.NR_PRESCRICAO%type, nr_atendimento_p ATENDIMENTO_PACIENTE.NR_ATENDIMENTO%TYPE ) FROM PUBLIC;

