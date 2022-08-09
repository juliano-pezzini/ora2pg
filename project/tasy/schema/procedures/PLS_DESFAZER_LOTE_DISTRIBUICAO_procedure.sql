-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lote_distribuicao (nr_seq_lote_p bigint) AS $body$
BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	delete 	from pls_conta_proc_plant
	where	nr_seq_lote_plant = nr_seq_lote_p;

	delete 	from pls_lote_prest_plant
	where	nr_seq_lote = nr_seq_lote_p;

	update	pls_lote_plantonista
	set	dt_geracao 	 = NULL
	where	nr_sequencia 	= nr_seq_lote_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lote_distribuicao (nr_seq_lote_p bigint) FROM PUBLIC;
