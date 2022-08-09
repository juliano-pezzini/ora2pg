-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_baixa_titulo_receber_sos (nr_seq_trans_financ_p bigint, cd_tipo_recebimento_p bigint) AS $body$
DECLARE


nr_titulo_w        		bigint;
cd_estabelecimento_w		integer;
vl_saldo_w			double precision;
qt_reg_w			bigint;
qt_total_w			bigint;
/*

Cursor C010 is
select	a.cd_estabelecimento,
	a.nr_titulo,
	a.vl_titulo
from	tit_rec_sos b,
	titulo_receber a
where	a.nr_titulo	= b.TITULO
and	a.vl_saldo_titulo	= 0
and	not exists (	select	1
			from	titulo_receber_liq x
			where	x.nr_titulo	= a.nr_titulo)
group	by a.cd_estabelecimento,
	a.nr_titulo,
	a.vl_titulo;

*/
BEGIN
qt_reg_w		:= 0;
qt_total_w		:= 0;
/*
OPEN C010;
LOOP
FETCH C010 into
	cd_estabelecimento_w,
	nr_titulo_w,
	vl_saldo_w;
exit when c010%notfound;

	qt_total_w	:= qt_total_w + 1;
	qt_reg_w	:= qt_reg_w + 1;

	update	titulo_receber
	set	vl_saldo_titulo	= vl_titulo
	where	nr_titulo		= nr_titulo_w;

	Baixa_Titulo_Receber(
		cd_estabelecimento_w,
		cd_tipo_recebimento_p,
		nr_titulo_w,
		nr_seq_trans_financ_p,
		vl_saldo_w,
		null,
		'TASY',
		null,
		null,
		null,
		0);
	Atualizar_Saldo_Tit_Rec(nr_titulo_w, 'TASY');

	if	(qt_reg_w = 1000) then
		commit;
		qt_reg_w		:= 0;
	end if;

END LOOP;
CLOSE C010;
*/
COMMIT;

RAISE NOTICE 'Títulos baixados: %', qt_total_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_baixa_titulo_receber_sos (nr_seq_trans_financ_p bigint, cd_tipo_recebimento_p bigint) FROM PUBLIC;
