-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_caixa_saldo_diario (nr_seq_caixa_p bigint, dt_referencia_p timestamp) AS $body$
DECLARE


vl_saldo_anterior_w		double precision;
vl_entrada_w			double precision;
vl_saida_w			double precision;
vl_atualizado_w			double precision;
nr_sequencia_w			bigint;
nr_seq_caixa_w			bigint;
dt_saldo_w			timestamp;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_caixa,
		dt_saldo
	from	caixa_saldo_diario
	where	dt_saldo >= trunc(dt_referencia_p, 'dd')
	and	nr_seq_caixa = nr_seq_caixa_p
	order 	by dt_saldo;


BEGIN
open c01;
loop
fetch c01 into
	nr_sequencia_w,
	nr_seq_caixa_w,
	dt_saldo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	coalesce(a.vl_saldo,0)
	into STRICT	vl_saldo_anterior_w
	from	caixa_saldo_diario a
	where	a.nr_seq_caixa	= nr_seq_caixa_w
	and	a.dt_saldo	= 	(SELECT	max(x.dt_saldo)
					from	caixa_saldo_diario x
					where	x.nr_seq_caixa = a.nr_seq_caixa
					and	x.dt_saldo < dt_saldo_w);
	exception
		when no_data_found then
			vl_saldo_anterior_w := 0;
	end;

	select	coalesce(sum(a.vl_transacao),0) * -1
	into STRICT	vl_saida_w
	from	transacao_financeira b,
		movto_trans_financ a
	where	a.nr_seq_caixa 		= nr_seq_caixa_w
	and	a.dt_referencia_saldo 	= dt_saldo_w
	and	b.nr_sequencia 		= a.nr_seq_trans_financ
	and	b.ie_saldo_caixa	= 'S'
	and	b.ie_caixa in ('T','D','A');

	select	coalesce(sum(a.vl_transacao),0)
	into STRICT	vl_entrada_w
	from	transacao_financeira b,
		movto_trans_financ a
	where	a.nr_seq_caixa 		= nr_seq_caixa_w
	and	a.dt_referencia_saldo 	= dt_saldo_w
	and	b.nr_sequencia 		= a.nr_seq_trans_financ
	and	b.ie_saldo_caixa 	= 'E'
	and	b.ie_caixa in ('T','D','A');

	vl_atualizado_w := vl_saldo_anterior_w + (vl_saida_w + vl_entrada_w);

	update	caixa_saldo_diario
	set	vl_saldo_inicial 	= vl_saldo_anterior_w,
		vl_saldo 		= vl_atualizado_w
	where	nr_sequencia		= nr_sequencia_w;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_caixa_saldo_diario (nr_seq_caixa_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

