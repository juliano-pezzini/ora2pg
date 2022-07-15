-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_deposito_cheque_cr () AS $body$
DECLARE


cont_w			bigint := 0;
nr_seq_cheque_w		bigint;

c01 CURSOR FOR
SELECT	a.nr_seq_cheque
from	cheque_cr a
where	coalesce(a.dt_devolucao::text, '') = ''
and	not exists (	select	1
			from	deposito_cheque x,
				deposito y
			where	x.nr_seq_cheque		= a.nr_seq_cheque
			and	x.nr_seq_deposito	= y.nr_sequencia
			and	(y.DT_DEPOSITO IS NOT NULL AND y.DT_DEPOSITO::text <> ''))
and ((DT_DEVOLUCAO_BANCO IS NOT NULL AND DT_DEVOLUCAO_BANCO::text <> '')
	or	(DT_REAPRESENTACAO IS NOT NULL AND DT_REAPRESENTACAO::text <> '')
	or 	DT_SEG_DEVOLUCAO	is not  null);


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_cheque_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	update	cheque_cr
	set	DT_DEVOLUCAO_BANCO	 = NULL,
		DT_REAPRESENTACAO	 = NULL,
		DT_SEG_DEVOLUCAO	 = NULL
	where	nr_seq_cheque		= nr_seq_cheque_w;

	cont_w	:= cont_w + 1;

end loop;
close c01;

RAISE NOTICE 'Cheques alterados: %', cont_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_deposito_cheque_cr () FROM PUBLIC;

