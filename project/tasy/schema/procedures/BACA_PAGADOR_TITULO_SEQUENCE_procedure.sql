-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pagador_titulo_sequence () AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_pagador_w	bigint;
qt_registro_w		bigint	:= 0;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_pagador
	from	pls_mensalidade	a;


BEGIN
open C01;
loop
fetch c01 into
	nr_sequencia_w,
	nr_seq_pagador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	titulo_receber
	set	nr_seq_pagador		= nr_seq_pagador_w
	where	nr_seq_mensalidade	= nr_sequencia_w
	and	coalesce(nr_seq_pagador::text, '') = '';

	qt_registro_w	:= qt_registro_w + 1;

	if (qt_registro_w >= 300) then
		commit;
		qt_registro_w	:= 0;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pagador_titulo_sequence () FROM PUBLIC;

