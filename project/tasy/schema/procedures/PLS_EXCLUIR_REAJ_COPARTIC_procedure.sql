-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_reaj_copartic ( nr_seq_reajuste_p bigint) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_reaj_copartic
	where	nr_seq_reajuste = nr_seq_reajuste_p
	and	coalesce(dt_liberacao::text, '') = '';

nr_seq_lote_w	bigint;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_lote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	delete	from	pls_reajuste_copartic
	where	nr_seq_lote = nr_seq_lote_w;

	delete	from	pls_lote_reaj_copartic
	where	nr_sequencia = nr_seq_lote_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_reaj_copartic ( nr_seq_reajuste_p bigint) FROM PUBLIC;
