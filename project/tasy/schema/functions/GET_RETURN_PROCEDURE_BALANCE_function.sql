-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_return_procedure_balance ( nr_seq_convenio_glosa_p CONVENIO_RETORNO_GLOSA.NR_SEQUENCIA%type ) RETURNS bigint AS $body$
DECLARE


vl_saldo_procedimento_w         PROCEDIMENTO_PACIENTE.VL_PROCEDIMENTO%type;


BEGIN

BEGIN
        SELECT  COALESCE((a2.VL_AMENOR)::numeric , SUM(a2.VL_PROCEDIMENTO - a2.VL_SALDO)) VL_SALDO_PROCED
        INTO STRICT 	vl_saldo_procedimento_w
        FROM    (
                SELECT (SELECT OBTER_VALOR_AMENOR_ULT_RET(NULL, NULL, NULL, a1.NR_INTERNO_CONTA, CASE WHEN a1.IE_AGRUPAR_SETOR='S' THEN  NULL WHEN a1.IE_AGRUPAR_SETOR='C' THEN  NULL  ELSE a1.NR_SEQ_PROCED END , NULL, 1)  c) VL_AMENOR,
                        coalesce((SELECT OBTER_GLOSA_ITEM_PROCMAT(CASE WHEN a1.IE_AGRUPAR_SETOR='S' THEN  NULL WHEN a1.IE_AGRUPAR_SETOR='C' THEN  NULL  ELSE a1.NR_SEQ_PROCED END , NULL, 2, NULL)  c), 0) VL_SALDO,
                        a1.VL_PROCEDIMENTO
                FROM (
                        SELECT (SELECT OBTER_PARAM_FUNCAO_HTML5(27, 102)  c) IE_AGRUPAR_SETOR,
                                b.NR_INTERNO_CONTA,
                                b.NR_SEQUENCIA NR_SEQ_PROCED,
                                b.VL_PROCEDIMENTO
                        FROM    CONVENIO_RETORNO_GLOSA a,
                                PROCEDIMENTO_PACIENTE b
                        WHERE   a.NR_SEQ_PROPACI = b.NR_SEQUENCIA
                        AND     a.NR_SEQUENCIA = nr_seq_convenio_glosa_p
                ) a1
        ) a2
        GROUP BY VL_AMENOR,
                 VL_PROCEDIMENTO,
                 VL_SALDO
        ORDER BY VL_SALDO_PROCED;
EXCEPTION WHEN no_data_found THEN
        vl_saldo_procedimento_w := 0;
END;

RETURN vl_saldo_procedimento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_return_procedure_balance ( nr_seq_convenio_glosa_p CONVENIO_RETORNO_GLOSA.NR_SEQUENCIA%type ) FROM PUBLIC;

