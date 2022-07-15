-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativa_item_cot_sem_preco ( nr_cot_compra_p bigint) AS $body$
DECLARE


nr_item_cot_compra_w		bigint;

c01 CURSOR FOR
SELECT	distinct(a.nr_item_cot_compra)
from	cot_compra_forn_item a,
       	cot_compra_item b
where	a.nr_cot_compra		= b.nr_cot_compra
and	a.nr_item_cot_compra	= b.nr_item_cot_compra
and	b.nr_cot_compra		= nr_cot_compra_p
and	coalesce(b.ie_situacao,'A')	= 'A'
and not exists (
	SELECT	d.nr_cot_compra
	from	cot_compra_forn_item d
	where	d.nr_cot_compra		= a.nr_cot_compra
	and	d.nr_item_cot_compra	= a.nr_item_cot_compra
	and	d.vl_unitario_material	<> 0);


BEGIN

open C01;
loop
fetch c01 into
	nr_item_cot_compra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	cot_compra_item
	set	ie_situacao = 'I'
	where	nr_cot_compra = nr_cot_compra_p
	and	nr_item_cot_compra = nr_item_cot_compra_w;
	end;
end loop;
close c01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativa_item_cot_sem_preco ( nr_cot_compra_p bigint) FROM PUBLIC;

