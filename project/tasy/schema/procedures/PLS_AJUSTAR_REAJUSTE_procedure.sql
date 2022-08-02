-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_reajuste ( nr_seq_reajuste_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reaj_preco_w		bigint;
nr_seq_preco_w			bigint;
nr_seq_tabela_w			bigint;
vl_preco_inicial_w		double precision;
vl_base_w			double precision;
vl_preco_reajustado_w		double precision;
pr_reajustado_w			double precision;

C01 CURSOR FOR
	SELECT	d.nr_sequencia,
		c.nr_sequencia,
		b.nr_seq_tabela,
		c.vl_preco_inicial,
		d.vl_base
	from	pls_reajuste a,
		pls_reajuste_tabela b,
		pls_plano_preco c,
		pls_reajuste_preco d
	where	a.nr_sequencia	= b.nr_seq_reajuste
	and	b.nr_seq_tabela	= c.nr_seq_tabela
	and	c.nr_sequencia	= d.nr_seq_preco
	and	a.nr_sequencia	= nr_seq_reajuste_p
	and	d.nr_seq_reajuste	= nr_seq_reajuste_p
	and	c.vl_preco_inicial	<> d.vl_base;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_reaj_preco_w,
	nr_seq_preco_w,
	nr_seq_tabela_w,
	vl_preco_inicial_w,
	vl_base_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	vl_preco_inicial_w + dividir_sem_round((vl_preco_inicial_w)::numeric, 100) * 6.76,
		dividir_sem_round((vl_preco_inicial_w)::numeric, 100) * 6.76
	into STRICT	vl_preco_reajustado_w,
		pr_reajustado_w
	;

	update	pls_reajuste_preco
	set	vl_base		= vl_preco_inicial_w,
		vl_reajustado	= vl_preco_reajustado_w
	where	nr_sequencia	= nr_seq_reaj_preco_w;

	update	pls_plano_preco
	set	vl_preco_atual	= vl_preco_reajustado_w
	where	nr_sequencia	= nr_seq_preco_w;

	update	pls_segurado_preco
	set	vl_preco_ant	= vl_preco_inicial_w,
		vl_preco_atual	= vl_preco_reajustado_w,
		vl_desconto	= coalesce(vl_desconto,0),
		vl_reajuste	= pr_reajustado_w
	where	nr_seq_reajuste	= nr_seq_reaj_preco_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_reajuste ( nr_seq_reajuste_p bigint, nm_usuario_p text) FROM PUBLIC;

