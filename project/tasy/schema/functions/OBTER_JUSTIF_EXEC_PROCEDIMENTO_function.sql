-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_justif_exec_procedimento ( nr_seq_proc_pac_p integer ) RETURNS varchar AS $body$
DECLARE

    ds_justificativa_exec_w procedimento_paciente_dado.ds_justificativa_exec%TYPE := NULL;

BEGIN
    IF (nr_seq_proc_pac_p IS NOT NULL AND nr_seq_proc_pac_p::text <> '') THEN
        SELECT
            ds_justificativa_exec
        INTO STRICT ds_justificativa_exec_w
        FROM
            procedimento_paciente_dado
        WHERE
            nr_seq_proc = nr_seq_proc_pac_p;

    END IF;

    RETURN ds_justificativa_exec_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_justif_exec_procedimento ( nr_seq_proc_pac_p integer ) FROM PUBLIC;
