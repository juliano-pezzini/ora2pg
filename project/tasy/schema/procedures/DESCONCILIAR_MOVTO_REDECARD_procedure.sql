-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desconciliar_movto_redecard ( nr_seq_ext_movto_p bigint) AS $body$
DECLARE


nr_seq_extrato_parcela_w	bigint;
nr_seq_movto_concil_w		bigint;
nr_seq_ext_movto_w		bigint;
vl_conciliado_fin_w		double precision;
vl_conciliado_w			double precision;

C01 CURSOR FOR
	SELECT	nr_seq_extrato_parcela,
		vl_conciliado
	from	ext_cartao_cr_movto_concil
	where	nr_seq_ext_movto = nr_seq_ext_movto_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_ext_movto,
		vl_conciliado
	from	ext_cartao_cr_movto_concil
	where	nr_seq_extrato_parcela = nr_seq_extrato_parcela_w
	and	nr_seq_ext_movto <> nr_seq_ext_movto_p
	order by nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_extrato_parcela_w,
	vl_conciliado_fin_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	/* desconciliar movto de credito */

	open C02;
	loop
	fetch C02 into
		nr_seq_movto_concil_w,
		nr_seq_ext_movto_w,
		vl_conciliado_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		update	extrato_cartao_cr_movto
		set	vl_aconciliar		= 0,
			vl_saldo_concil_cred	= vl_saldo_concil_cred + vl_conciliado_w,
			vl_saldo_concil_fin     = 0
		where	nr_sequencia		= nr_seq_ext_movto_w;

		delete	from ext_cartao_cr_movto_concil
		where	nr_sequencia = nr_seq_movto_concil_w;

		end;
	end loop;
	close C02;

	delete	from ext_cartao_cr_movto_concil
	where	nr_sequencia = nr_seq_extrato_parcela_w;

	delete	from extrato_cartao_cr_parcela
	where	nr_sequencia = nr_seq_extrato_parcela_w;

	update	extrato_cartao_cr_movto
	set	vl_aconciliar		= 0,
		vl_saldo_concil_cred	= 0,
		vl_saldo_concil_fin     = vl_saldo_concil_fin + vl_conciliado_fin_w,
		ie_pagto_indevido	= 'N'
	where	nr_sequencia		= nr_seq_ext_movto_p;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desconciliar_movto_redecard ( nr_seq_ext_movto_p bigint) FROM PUBLIC;
