-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION has_items_no_pbs (NR_ATENDIMENTO_P CPOE_MATERIAL.NR_ATENDIMENTO%TYPE) RETURNS varchar AS $body$
DECLARE

    COUNT_ITEMS CPOE_MATERIAL.NR_ATENDIMENTO%TYPE;

BEGIN
    SELECT  coalesce(SUM(HAS), 0)
    INTO STRICT    COUNT_ITEMS
    FROM (
        SELECT  1 HAS
        FROM    CPOE_MATERIAL A,
                ATEND_CATEGORIA_CONVENIO B,
                MATERIAL C
        WHERE   A.NR_ATENDIMENTO = B.NR_ATENDIMENTO
        AND     B.CD_CONVENIO = (   SELECT (X.CD_CONVENIO)
                                    FROM    CONVENIO_PLANO X
                                    WHERE   B.CD_CONVENIO = X.CD_CONVENIO
                                    AND     X.CD_PLANO = B.CD_PLANO_CONVENIO
                                    AND     X.IE_EPS = 'S')
        AND     coalesce(A.DT_SUSPENSAO::text, '') = ''
        AND     coalesce(A.DT_LIBERACAO::text, '') = ''
        AND     A.CD_MATERIAL = C.CD_MATERIAL
        AND     C.IE_NOPBS = 'S'
        AND     A.NR_ATENDIMENTO = NR_ATENDIMENTO_P


UNION ALL


        SELECT  1 HAS
        FROM    CPOE_PROCEDIMENTO A,
                ATEND_CATEGORIA_CONVENIO B
        WHERE   A.NR_ATENDIMENTO = B.NR_ATENDIMENTO
        AND     B.CD_CONVENIO = (   SELECT (X.CD_CONVENIO)
                                    FROM    CONVENIO_PLANO X
                                    WHERE   B.CD_CONVENIO = X.CD_CONVENIO
                                    AND     X.CD_PLANO = B.CD_PLANO_CONVENIO
                                    AND     X.IE_EPS = 'S')
        AND     coalesce(A.DT_SUSPENSAO::text, '') = ''
        AND     coalesce(A.DT_LIBERACAO::text, '') = ''
        AND     A.NR_SEQ_PROC_INTERNO = (   SELECT  X.NR_SEQUENCIA
                                            FROM    PROC_INTERNO X,
                                                    PROCEDIMENTO Y
                                            WHERE   X.NR_SEQUENCIA = A.NR_SEQ_PROC_INTERNO
                                            AND     X.CD_PROCEDIMENTO_LOC = Y.CD_PROCEDIMENTO_LOC
                                            AND     Y.IE_NOPBS = 'S'
                                            AND     Y.IE_ORIGEM_PROCED = 4)
        AND     A.NR_ATENDIMENTO = NR_ATENDIMENTO_P
    ) alias11;

    IF (COUNT_ITEMS > 0) THEN
        RETURN 'S';
    END IF;
    RETURN 'N';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION has_items_no_pbs (NR_ATENDIMENTO_P CPOE_MATERIAL.NR_ATENDIMENTO%TYPE) FROM PUBLIC;
