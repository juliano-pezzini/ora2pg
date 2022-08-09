-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_ajustar_contrato_fat () AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_contrato_w		bigint;
nr_seq_contrato_w	bigint;

C01 CURSOR FOR
	SELECT	nr_contrato,
		nr_sequencia
	from	pls_lote_fat_excecao
	where	(nr_contrato IS NOT NULL AND nr_contrato::text <> '');

C02 CURSOR FOR
	SELECT	nr_contrato,
		nr_sequencia
	from	pls_regra_fat_pagador
	where	(nr_contrato IS NOT NULL AND nr_contrato::text <> '');

C03 CURSOR FOR
	SELECT	nr_contrato,
		nr_sequencia
	from	pls_regra_arquivo_fatura
	where	(nr_contrato IS NOT NULL AND nr_contrato::text <> '');


BEGIN
open C01;
loop
fetch C01 into
	nr_contrato_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select  max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from    pls_contrato
	where   nr_contrato = nr_contrato_w;

	update	pls_lote_fat_excecao
	set	nr_seq_contrato = nr_seq_contrato_w
	where	nr_sequencia	= nr_sequencia_w;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_contrato_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	select  max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from    pls_contrato
	where   nr_contrato = nr_contrato_w;

	update	pls_regra_fat_pagador
	set	nr_seq_contrato = nr_seq_contrato_w
	where	nr_sequencia	= nr_sequencia_w;
	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	nr_contrato_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	select  max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from    pls_contrato
	where   nr_contrato = nr_contrato_w;

	update	pls_regra_arquivo_fatura
	set	nr_seq_contrato = nr_seq_contrato_w
	where	nr_sequencia	= nr_sequencia_w;
	end;
end loop;
close C03;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_ajustar_contrato_fat () FROM PUBLIC;
