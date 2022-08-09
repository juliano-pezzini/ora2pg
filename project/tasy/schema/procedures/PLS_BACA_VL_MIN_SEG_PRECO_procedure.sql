-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_vl_min_seg_preco () AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_preco
	from	pls_segurado_preco	a,
		pls_segurado		b
	where	a.nr_seq_segurado	= b.nr_sequencia;

nr_seq_seg_preco_w	bigint;
nr_seq_preco_w		bigint;
vl_minimo_w		double precision;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_seg_preco_w,
	nr_seq_preco_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_minimo_w	:= 0;

	if (coalesce(nr_seq_preco_w,0) <> 0) then
		select	max(vl_minimo)
		into STRICT	vl_minimo_w
		from	pls_plano_preco
		where	nr_sequencia	= nr_seq_preco_w;
	else
		vl_minimo_w	:= 0;
	end if;

	update	pls_segurado_preco
	set	vl_minimo_mensalidade	= vl_minimo_w
	where	nr_sequencia		= nr_seq_seg_preco_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_vl_min_seg_preco () FROM PUBLIC;
