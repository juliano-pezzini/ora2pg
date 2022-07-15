-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajuste_dt_liberacao () AS $body$
DECLARE


nr_seq_contrato_w	bigint;
nr_seq_segurado_w	bigint;
nr_seq_segurado_preco_w	bigint;
dt_aprovacao_w		timestamp;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_aprovacao
	from	pls_contrato
	where	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	nr_seq_contrato = nr_seq_contrato_w;

c03 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_segurado_preco a
	where	nr_seq_segurado = nr_seq_segurado_w
	and	coalesce(a.dt_liberacao::text, '') = '';


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_contrato_w,
	dt_aprovacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
	fetch c02 into
		nr_seq_segurado_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		open c03;
		loop
		fetch c03 into
			nr_seq_segurado_preco_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */

			update	pls_segurado_preco
			set	dt_liberacao = dt_aprovacao_w
			where	nr_sequencia = nr_seq_segurado_preco_w;

		end loop;
		close c03;

	end loop;
	close c02;

commit;

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajuste_dt_liberacao () FROM PUBLIC;

