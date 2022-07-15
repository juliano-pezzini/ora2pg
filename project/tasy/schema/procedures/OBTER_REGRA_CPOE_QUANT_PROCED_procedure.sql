-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_cpoe_quant_proced ( cd_intervalo_p text, ie_lado_p text, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, ie_regra_intervalo_p INOUT text, ie_regra_lado_p INOUT text, qt_procedimento_p INOUT bigint, ie_permite_edicao_p INOUT text ) AS $body$
DECLARE


    cd_grupo_proc_w          prescr_proc_quant.cd_grupo_proc%TYPE;
    cd_especialidade_w       prescr_proc_quant.cd_especialidade%TYPE;
    cd_area_procedimento_w   prescr_proc_quant.cd_area_procedimento%TYPE;
    cd_convenio_w            prescr_proc_quant.cd_convenio%TYPE;
    ie_achou_w               prescr_proc_quant.ie_permite_edicao%TYPE;
    cd_procedimento_w        prescr_proc_quant.cd_procedimento%TYPE;
    ie_origem_proced_w       proc_interno.ie_origem_proced%TYPE;
    nr_atendimento_w         atendimento_paciente.nr_atendimento%TYPE;

    c01 CURSOR FOR
    SELECT
        qt_procedimento,
		CASE WHEN coalesce(cd_intervalo::text, '') = '' THEN  'N'  ELSE 'S' END ,
		CASE WHEN coalesce(ie_lado::text, '') = '' THEN  'N'  ELSE 'S' END ,
		ie_permite_edicao
    FROM
        prescr_proc_quant
    WHERE
        COALESCE(cd_intervalo, coalesce(cd_intervalo_p, 'XPTO')) = coalesce(cd_intervalo_p, 'XPTO')
        AND coalesce(coalesce(ie_lado, ie_lado_p), 'XPTO') = coalesce(ie_lado_p, 'XPTO')
        AND coalesce(cd_procedimento, cd_procedimento_w) = cd_procedimento_w
        AND COALESCE(cd_area_procedimento, cd_area_procedimento_w) = cd_area_procedimento_w
        AND COALESCE(cd_especialidade, cd_especialidade_w) = cd_especialidade_w
        AND COALESCE(cd_grupo_proc, cd_grupo_proc_w) = cd_grupo_proc_w
        AND COALESCE(cd_convenio, coalesce(cd_convenio_w, 0)) = coalesce(cd_convenio_w, 0)
        AND COALESCE(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p, 0)) = coalesce(nr_seq_proc_interno_p, 0)
        AND ( ( coalesce(cd_procedimento::text, '') = '' )
              OR ( coalesce(ie_origem_proced, ie_origem_proced_w) = ie_origem_proced_w ) )
    ORDER BY
        coalesce(nr_seq_proc_interno, 0),
        coalesce(cd_procedimento, 0),
        coalesce(cd_intervalo, 0),
        coalesce(ie_lado, 0) DESC,
        coalesce(cd_area_procedimento, 0),
        coalesce(cd_especialidade,0),
        coalesce(cd_grupo_proc, 0),
        coalesce(cd_convenio, 0);


BEGIN
    nr_atendimento_w := coalesce(nr_atendimento_p, 0);

     SELECT
        MAX(CD_PROCEDIMENTO),
        MAX(IE_ORIGEM_PROCED)
    INTO STRICT cd_procedimento_w,
         ie_origem_proced_w
    FROM
        proc_interno 
    WHERE nr_sequencia = nr_seq_proc_interno_p;

    SELECT
        MAX(cd_grupo_proc),
        MAX(cd_especialidade),
        MAX(cd_area_procedimento)
    INTO STRICT
        cd_grupo_proc_w,
        cd_especialidade_w,
        cd_area_procedimento_w
    FROM
        estrutura_procedimento_v
    WHERE
        cd_procedimento = cd_procedimento_w
        AND ie_origem_proced = ie_origem_proced_w;

    SELECT
        MAX(obter_convenio_atendimento(nr_atendimento_w))
    INTO STRICT cd_convenio_w
;

    OPEN c01;
    LOOP
        FETCH c01
		INTO 
		qt_procedimento_p,
		ie_regra_intervalo_p,
		ie_regra_lado_p,
		ie_permite_edicao_p;
        EXIT WHEN NOT FOUND; /* apply on c01 */
        BEGIN
            ie_achou_w := 'S';
        END;
    END LOOP;

    CLOSE c01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_cpoe_quant_proced ( cd_intervalo_p text, ie_lado_p text, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, ie_regra_intervalo_p INOUT text, ie_regra_lado_p INOUT text, qt_procedimento_p INOUT bigint, ie_permite_edicao_p INOUT text ) FROM PUBLIC;

