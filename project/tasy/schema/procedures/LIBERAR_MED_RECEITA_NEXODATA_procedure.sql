-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_med_receita_nexodata ( nr_seq_med_p bigint) AS $body$
BEGIN
    UPDATE MED_RECEITA SET
        DT_LIBERACAO = clock_timestamp()
    WHERE 1=1
    AND coalesce(DT_LIBERACAO::text, '') = '' 
    AND NR_SEQUENCIA = nr_seq_med_p;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_med_receita_nexodata ( nr_seq_med_p bigint) FROM PUBLIC;
