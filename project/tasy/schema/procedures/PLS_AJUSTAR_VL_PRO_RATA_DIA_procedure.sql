-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_vl_pro_rata_dia () AS $body$
DECLARE


nr_seq_mensalidade_w			bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_lote_mensalidade a,
		pls_mensalidade b
	where	a.nr_sequencia	= b.nr_seq_lote
	and	exists (SELECT	1
			from	pls_regra_pro_rata_dia x,
				pls_mensalidade_seg_item y,
				pls_mensalidade_segurado z
			where	z.nr_seq_mensalidade		= b.nr_sequencia
			and	x.ie_tipo_item_mensalidade	= y.ie_tipo_item
			and	y.nr_seq_mensalidade_seg	= z.nr_sequencia)
	and	trunc(a.dt_mesano_referencia,'month')	between to_date('01/09/2010') and to_date('31/10/2010');


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_mensalidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	CALL pls_gerar_pro_rata_dia(nr_seq_mensalidade_w);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_vl_pro_rata_dia () FROM PUBLIC;
