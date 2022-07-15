-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atua_dt_final_cta_pend_hist (nr_seq_pend_hist_p bigint, dt_final_estagio_p timestamp) AS $body$
BEGIN
	Update  cta_pendencia_hist
	set     dt_final_estagio = dt_final_estagio_p
	where   nr_sequencia = nr_seq_pend_hist_p;

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atua_dt_final_cta_pend_hist (nr_seq_pend_hist_p bigint, dt_final_estagio_p timestamp) FROM PUBLIC;

