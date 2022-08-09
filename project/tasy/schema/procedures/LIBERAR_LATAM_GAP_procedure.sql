-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_latam_gap (NR_SEQUENCIA_P LATAM_GAP.NR_SEQUENCIA%type) AS $body$
BEGIN
    update  LATAM_GAP
    set     DT_LIBERACAO = clock_timestamp()
    where   NR_SEQUENCIA = NR_SEQUENCIA_P;

    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_latam_gap (NR_SEQUENCIA_P LATAM_GAP.NR_SEQUENCIA%type) FROM PUBLIC;
