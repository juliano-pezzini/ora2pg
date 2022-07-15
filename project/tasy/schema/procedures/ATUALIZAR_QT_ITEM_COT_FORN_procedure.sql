-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_qt_item_cot_forn ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, qt_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_forn_w			bigint;
qt_item_cot_compra_w		integer;
cd_material_cot_w		integer;
cd_material_w			integer;
qt_item_w			double precision;


c01 CURSOR FOR
SELECT	nr_sequencia
from	cot_compra_forn
where	nr_cot_compra = nr_cot_compra_p;

c02 CURSOR FOR
SELECT	distinct
	cd_material
from	cot_compra_forn_item
where	nr_item_cot_compra 	= nr_item_cot_compra_p
and	nr_cot_compra 	= nr_cot_compra_p;



BEGIN

qt_item_w	:= qt_item_p;

open c01;
loop
fetch c01 into
	nr_seq_forn_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin

	select	count(*)
	into STRICT	qt_item_cot_compra_w
	from	cot_compra_forn_item
	where	nr_seq_cot_forn	= nr_seq_forn_w
	and	nr_item_cot_compra	= nr_item_cot_compra_p;

	if (qt_item_cot_compra_w > 1) then

		select	cd_material
		into STRICT	cd_material_cot_w
		from	cot_compra_item
		where	nr_cot_compra 	= nr_cot_compra_p
		and	nr_item_cot_compra 	= nr_item_cot_compra_p;

		open c02;
		loop
		fetch c02 into
			cd_material_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			if (cd_material_w = cd_material_cot_w) then
				qt_item_w := qt_item_p;
			else
				select (round(dividir(qt_item_p, qt_conv_compra_estoque))) * qt_conv_compra_estoque
				into STRICT	qt_item_w
				from	material
				where	cd_material = cd_material_w;
			end if;

			if (coalesce(qt_item_w,0) = 0) then
				qt_item_w := qt_item_p;
			end if;

			update	cot_compra_forn_item
			set	qt_material 		= qt_item_w
			where	nr_cot_compra 	= nr_cot_compra_p
			and	nr_item_cot_compra 	= nr_item_cot_compra_p
			and	nr_seq_cot_forn	= nr_seq_forn_w
			and	cd_material		= cd_material_w;
		end loop;
		close c02;
	else
		update	cot_compra_forn_item
		set	qt_material 		= qt_item_w
		where	nr_cot_compra 	= nr_cot_compra_p
		and	nr_item_cot_compra 	= nr_item_cot_compra_p
		and	nr_seq_cot_forn	= nr_seq_forn_w;
	end if;

	end;
	end loop;
close c01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_qt_item_cot_forn ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, qt_item_p bigint, nm_usuario_p text) FROM PUBLIC;

