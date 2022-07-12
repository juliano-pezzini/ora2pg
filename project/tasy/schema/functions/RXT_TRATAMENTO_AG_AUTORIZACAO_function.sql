-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_tratamento_ag_autorizacao ( nr_seq_tratamento_p rxt_tratamento.nr_sequencia%TYPE ) RETURNS varchar AS $body$
DECLARE


nr_count_w smallint;


BEGIN

    SELECT COUNT(nr_sequencia)
    INTO STRICT nr_count_w
    FROM rxt_tratamento tratamento
    WHERE tratamento.nr_sequencia = nr_seq_tratamento_p
    AND coalesce(tratamento.dt_liberacao::text, '') = ''
    AND EXISTS (
        SELECT 1
        FROM autorizacao_convenio
        WHERE nr_seq_rxt_tratamento = tratamento.nr_sequencia
    )
    AND obter_se_tratamento_autorizado(tratamento.nr_sequencia) = 'N';

    IF (nr_count_w > 0) THEN
        RETURN 'S';
    END IF;

    RETURN 'N';

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_tratamento_ag_autorizacao ( nr_seq_tratamento_p rxt_tratamento.nr_sequencia%TYPE ) FROM PUBLIC;

