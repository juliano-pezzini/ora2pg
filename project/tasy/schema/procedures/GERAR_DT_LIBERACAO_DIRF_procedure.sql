-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dt_liberacao_dirf ( nr_seq_lote_dirf_p bigint) AS $body$
BEGIN

update	dirf_lote_mensal
set	dt_geracao = clock_timestamp()
where	nr_sequencia = nr_seq_lote_dirf_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dt_liberacao_dirf ( nr_seq_lote_dirf_p bigint) FROM PUBLIC;

