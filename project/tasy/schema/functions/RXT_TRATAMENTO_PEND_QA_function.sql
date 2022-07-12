-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_tratamento_pend_qa ( nr_seq_tratamento_p rxt_tratamento.nr_sequencia%TYPE ) RETURNS varchar AS $body$
DECLARE


nr_count_w smallint;


BEGIN

    SELECT COUNT(tratamento.nr_sequencia)
    INTO STRICT nr_count_w
    FROM
        rxt_tratamento tratamento
    WHERE tratamento.nr_sequencia = nr_seq_tratamento_p
    AND NOT EXISTS (
        SELECT fase.nr_sequencia
        FROM rxt_fase_tratamento fase
        WHERE fase.nr_seq_tratamento = tratamento.nr_sequencia
        AND coalesce(rxt_obter_se_trat_liberado(fase.nr_sequencia)::text, '') = ''
        )
    AND tratamento.ie_necessita_qa = 'S'
    AND (tratamento.ie_qa_registrado = 'N' OR coalesce(tratamento.ie_qa_registrado::text, '') = '')
    AND rxt_tratamento_ag_autorizacao(tratamento.nr_sequencia) <> 'S'
    AND coalesce(tratamento.dt_liberacao::text, '') = ''
    AND coalesce(tratamento.dt_suspensao::text, '') = ''
    AND coalesce(tratamento.dt_cancelamento::text, '') = ''
    AND rxt_tratamento_finalizado(tratamento.nr_sequencia) <> 'S';

    IF (nr_count_w > 0) THEN
        RETURN 'S';
    ELSE
        RETURN 'N';
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_tratamento_pend_qa ( nr_seq_tratamento_p rxt_tratamento.nr_sequencia%TYPE ) FROM PUBLIC;

