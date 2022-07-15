-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_atualiza_dt_fim_reconc ( nr_sequencia_p bigint, dt_fim_p timestamp ) AS $body$
BEGIN

	begin
	
	update   hist_saude_reconciliacao
	set      dt_fim         = dt_fim_p
        where    nr_sequencia   = nr_sequencia_p;
	
	end;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_atualiza_dt_fim_reconc ( nr_sequencia_p bigint, dt_fim_p timestamp ) FROM PUBLIC;

