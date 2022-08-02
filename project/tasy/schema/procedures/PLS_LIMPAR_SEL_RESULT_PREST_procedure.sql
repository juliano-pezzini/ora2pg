-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_limpar_sel_result_prest ( nr_seq_simulacao_p pls_smp.nr_sequencia%type) AS $body$
BEGIN

	CALL pls_smp_pck.limpar_selecao_result_prest(nr_seq_simulacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_limpar_sel_result_prest ( nr_seq_simulacao_p pls_smp.nr_sequencia%type) FROM PUBLIC;

