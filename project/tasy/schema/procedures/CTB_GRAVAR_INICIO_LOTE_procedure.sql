-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gravar_inicio_lote ( nr_lote_contabil_p bigint, ie_opcao_p text) AS $body$
DECLARE


/*
Opções:
D - Desfazer
G - Gerar
*/
BEGIN

if (ie_opcao_p = 'G') then
	update	lote_contabil
	set	dt_inicio_geracao = clock_timestamp()
	where	nr_lote_contabil = nr_lote_contabil_p;
elsif (ie_opcao_p = 'D') then
	update	lote_contabil
	set	dt_inicio_geracao  = NULL
	where	nr_lote_contabil = nr_lote_contabil_p;

	CALL ctb_desvincular_movimento(nr_lote_contabil_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gravar_inicio_lote ( nr_lote_contabil_p bigint, ie_opcao_p text) FROM PUBLIC;

