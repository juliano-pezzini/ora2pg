-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_tem_nota_clin (NR_ATENDIMENTO_P ATENDIMENTO_PACIENTE.NR_ATENDIMENTO%TYPE, DT_AVALIACAO_P timestamp) RETURNS varchar AS $body$
DECLARE

RETORNO_W varchar(10);

BEGIN
    BEGIN
       SELECT obter_desc_expressao(928855,null)
       INTO STRICT   RETORNO_W
       FROM   EVOLUCAO_PACIENTE A
       WHERE  NR_ATENDIMENTO = NR_ATENDIMENTO_P
       AND    TRUNC(A.DT_EVOLUCAO) = TRUNC(DT_AVALIACAO_P)
       AND    EXISTS (SELECT 1
                      FROM   TIPO_EVOLUCAO X
                      WHERE  X.CD_TIPO_EVOLUCAO = A.IE_EVOLUCAO_CLINICA 
                      AND    X.IE_REGISTRO_CRONOLOGICO = 'S')  LIMIT 1;
    EXCEPTION
      WHEN no_data_found THEN
        RETORNO_W := obter_desc_expressao(928857,null);
    END;
RETURN RETORNO_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_tem_nota_clin (NR_ATENDIMENTO_P ATENDIMENTO_PACIENTE.NR_ATENDIMENTO%TYPE, DT_AVALIACAO_P timestamp) FROM PUBLIC;

