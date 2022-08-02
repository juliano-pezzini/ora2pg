-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_processo_pgto_contest () AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia,
		substr(pls_obter_dados_lote_contest(nr_sequencia,'PC'),1,1) ie_processo_pgto
	from	pls_lote_contestacao;

BEGIN
for r_c01_w in c01 loop
	update	pls_lote_contestacao
	set	ie_processo_pgto	= r_c01_w.ie_processo_pgto
	where	nr_sequencia		= r_c01_w.nr_sequencia;
end loop;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_processo_pgto_contest () FROM PUBLIC;

