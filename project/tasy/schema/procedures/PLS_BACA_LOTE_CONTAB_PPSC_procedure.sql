-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_lote_contab_ppsc () AS $body$
DECLARE


nr_sequencia_w			bigint;
qt_registro_w			bigint	:= 0;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_ppsc_movimento
	where	coalesce(nr_lote_contabil::text, '') = '';

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_ppsc_movimento_item
	where	coalesce(nr_lote_contabil::text, '') = '';


BEGIN
open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (qt_registro_w >= 500) then
		commit;
		qt_registro_w := 0;
	end if;

	update	pls_ppsc_movimento
	set	nr_lote_contabil = 0
	where	nr_sequencia	= nr_sequencia_w;

	qt_registro_w := qt_registro_w + 1;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (qt_registro_w >= 500) then
		commit;
		qt_registro_w := 0;
	end if;

	update	pls_ppsc_movimento_item
	set	nr_lote_contabil = 0
	where	nr_sequencia	= nr_sequencia_w;

	qt_registro_w := qt_registro_w + 1;
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_lote_contab_ppsc () FROM PUBLIC;

