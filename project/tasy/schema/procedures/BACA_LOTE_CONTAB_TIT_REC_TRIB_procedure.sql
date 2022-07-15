-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_lote_contab_tit_rec_trib () AS $body$
DECLARE


nr_seq_tit_rec_trib_w		bigint;
nr_titulo_w			bigint;
qt_registro_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_titulo
	from	titulo_receber_trib
	where	coalesce(nr_lote_contabil::text, '') = '';


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_tit_rec_trib_w,
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	titulo_receber_trib
	set	nr_lote_contabil	= 0
	where	nr_sequencia		= nr_seq_tit_rec_trib_w
	and	nr_titulo		= nr_titulo_w;

	qt_registro_w	:= qt_registro_w + 1;

	if (qt_registro_w = 300) then
		qt_registro_w	:= 0;
		commit;
	end if;
	end;
end loop;
close C01;

if (qt_registro_w > 0) and (qt_registro_w < 300) then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_lote_contab_tit_rec_trib () FROM PUBLIC;

