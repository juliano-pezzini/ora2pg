-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_sprint_activities ( NRS_SEQ_REQUISITOS_P text, NR_SEQ_CADASTRO_SPRINT CADASTRO_SPRINT_ATIVIDADE.NR_SEQUENCIA%TYPE, DT_INICIO_P CADASTRO_SPRINT_ATIVIDADE.DT_INICIO_ATIVIDADE%TYPE, DT_FIM_P CADASTRO_SPRINT_ATIVIDADE.DT_PREVISTA_ATIVIDADE%TYPE ) AS $body$
DECLARE


    CONST_DATA_ATUAL                CONSTANT CADASTRO_SPRINT_ATIVIDADE.DT_PREVISTA_ATIVIDADE%TYPE := clock_timestamp();
    CONST_USUARIO                   CONSTANT CADASTRO_SPRINT_ATIVIDADE.NM_USUARIO%TYPE := WHEB_USUARIO_PCK.GET_NM_USUARIO;
    CONST_SITUACAO_PENDENTE         CONSTANT CADASTRO_SPRINT_ATIVIDADE.IE_SITUACAO%TYPE := 'C';
    CONST_TIPO_ATIVIDADE_PROJETO    CONSTANT CADASTRO_SPRINT_ATIVIDADE.IE_CLASSIFICACAO%TYPE := '1';

BEGIN
    IF (coalesce(nrs_seq_requisitos_p::text, '') = '') THEN
        CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(22181);
    END IF;

    INSERT INTO CADASTRO_SPRINT_ATIVIDADE(
        NR_SEQUENCIA,
        NR_SEQ_CADASTRO_SPRINT,
        DS_ATIVIDADE,
        DT_ATUALIZACAO,
        NM_USUARIO,
        CD_PESSOA_RESPONSAVEL,
        IE_SITUACAO,
        IE_CLASSIFICACAO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC,
        DT_INICIO_ATIVIDADE,
        DT_PREVISTA_ATIVIDADE,
        NR_SEQ_REQUISITO,
        CD_VERSAO
    )
        SELECT
            nextval('cadastro_sprint_atividade_seq'),
            NR_SEQ_CADASTRO_SPRINT,
            NR_SEQUENCIA,
            CONST_DATA_ATUAL,
            CONST_USUARIO,
            CD_RESPONSAVEL,
            CONST_SITUACAO_PENDENTE,
            CONST_TIPO_ATIVIDADE_PROJETO,
            CONST_DATA_ATUAL,
            CONST_USUARIO,
            DT_INICIO_P,
            DT_FIM_P,
            NR_SEQUENCIA,
            CD_VERSAO
	
        FROM
            LATAM_REQUISITO A
        WHERE
            A.NR_SEQUENCIA IN (WITH RECURSIVE cte AS (

                SELECT
                    (REGEXP_SUBSTR(NRS_SEQ_REQUISITOS_P, '[^,]+', 1, LEVEL))::numeric 
                
                (REGEXP_SUBSTR(NRS_SEQ_REQUISITOS_P, '[^,]+', 1, LEVEL) IS NOT NULL AND (REGEXP_SUBSTR(NRS_SEQ_REQUISITOS_P, '[^,]+', 1, LEVEL))::text <> '')
              UNION ALL

                SELECT
                    (REGEXP_SUBSTR(NRS_SEQ_REQUISITOS_P, '[^,]+', 1, LEVEL))::numeric 
                
                (REGEXP_SUBSTR(NRS_SEQ_REQUISITOS_P, '[^,]+', 1, LEVEL) IS NOT NULL AND (REGEXP_SUBSTR(NRS_SEQ_REQUISITOS_P, '[^,]+', 1, LEVEL))::text <> '')
             JOIN cte c ON ()

) SELECT * FROM cte;
);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_sprint_activities ( NRS_SEQ_REQUISITOS_P text, NR_SEQ_CADASTRO_SPRINT CADASTRO_SPRINT_ATIVIDADE.NR_SEQUENCIA%TYPE, DT_INICIO_P CADASTRO_SPRINT_ATIVIDADE.DT_INICIO_ATIVIDADE%TYPE, DT_FIM_P CADASTRO_SPRINT_ATIVIDADE.DT_PREVISTA_ATIVIDADE%TYPE ) FROM PUBLIC;
