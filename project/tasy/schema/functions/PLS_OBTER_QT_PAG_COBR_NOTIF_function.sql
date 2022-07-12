-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_pag_cobr_notif ( nr_seq_lote_p bigint) RETURNS bigint AS $body$
DECLARE


qt_pagadores_cobr_w		bigint	:= 0;
nr_titulo_w			bigint;
nr_titulo_cob_w			bigint;
dt_geracao_cobranca_w		timestamp;

C01 CURSOR FOR
	SELECT	c.nr_titulo
	from	pls_notificacao_item	c,
		pls_notificacao_pagador	b
	where	b.nr_seq_lote	= nr_seq_lote_p
	and	b.nr_sequencia	= c.nr_seq_notific_pagador;

TYPE 		fetch_array IS TABLE OF C01%ROWTYPE;
s_array 	fetch_array;
i		integer := 1;
type Vetor is table of fetch_array index by integer;
Vetor_c01_w			Vetor;

BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	max(a.dt_geracao_cobranca)
	into STRICT	dt_geracao_cobranca_w
	from	pls_notificacao_lote	a
	where	a.nr_sequencia	= nr_seq_lote_p;

	if (dt_geracao_cobranca_w IS NOT NULL AND dt_geracao_cobranca_w::text <> '') then
		qt_pagadores_cobr_w	:= 0;

		open C01;
		loop
		FETCH C01 BULK COLLECT INTO s_array LIMIT 1000;
			Vetor_c01_w(i) := s_array;
			i := i + 1;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		END LOOP;
		CLOSE C01;

		for i in 1..Vetor_c01_w.COUNT loop
			s_array := Vetor_c01_w(i);
			for z in 1..s_array.COUNT loop
				begin
				nr_titulo_w		:= s_array[z].nr_titulo;

				nr_titulo_cob_w	:= null;

				select	max(d.nr_titulo)
				into STRICT	nr_titulo_cob_w
				from	cobranca		d
				where	d.nr_titulo	= nr_titulo_w;

				if (nr_titulo_cob_w IS NOT NULL AND nr_titulo_cob_w::text <> '') then
					qt_pagadores_cobr_w	:= qt_pagadores_cobr_w + 1;
				end if;
				end;
			end loop;
		end loop;
	end if;
end if;

return qt_pagadores_cobr_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_pag_cobr_notif ( nr_seq_lote_p bigint) FROM PUBLIC;

