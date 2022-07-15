-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_nr_seq_saldo_caixa () AS $body$
DECLARE


dt_referencia_saldo_w	timestamp;
nr_sequencia_w		bigint;
nr_seq_caixa_w		bigint;
nr_seq_saldo_caixa_w	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_caixa,
	trunc(dt_referencia_saldo, 'dd')
from	movto_trans_financ
where	(nr_seq_caixa IS NOT NULL AND nr_seq_caixa::text <> '')
and	coalesce(nr_seq_saldo_caixa::text, '') = '';


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	nr_seq_caixa_w,
	dt_referencia_saldo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	max(nr_sequencia)
	into STRICT	nr_seq_saldo_caixa_w
	from	caixa_saldo_diario
	where	nr_seq_caixa		= nr_seq_caixa_w
	and	trunc(dt_saldo, 'dd')	= dt_referencia_saldo_w;

	update	movto_trans_financ
	set	nr_seq_saldo_caixa	= nr_seq_saldo_caixa_w
	where	coalesce(nr_seq_saldo_caixa::text, '') = ''
	and	nr_sequencia		= nr_sequencia_w;

	commit;

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_nr_seq_saldo_caixa () FROM PUBLIC;

