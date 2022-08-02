-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recalcular_tributo_ordem ( nr_ordem_compra_p bigint, nr_item_oci_p bigint) AS $body$
DECLARE


cd_tributo_w			integer;
vl_tributo_w			double precision;
pr_tributo_w			double precision;
qt_material_w			double precision;
vl_unitario_material_w		double precision;
pr_descontos_w			double precision;
qt_registro_w			integer;

C01 CURSOR FOR
	SELECT	cd_tributo,
		pr_tributo
	from	ordem_compra_item_trib
	where	nr_ordem_compra	= nr_ordem_compra_p
	and	nr_item_oci	= nr_item_oci_p;

BEGIN

select	count(*)
into STRICT	qt_registro_w
from	ordem_compra_item_trib
where	nr_ordem_compra	= nr_ordem_compra_p
and	nr_item_oci	= nr_item_oci_p;
if (qt_registro_w > 0) then
	begin
	OPEN C01;
	LOOP
	FETCH C01 INTO
		cd_tributo_w,
		pr_tributo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	qt_material,
			vl_unitario_material,
			pr_descontos
		into STRICT	qt_material_w,
			vl_unitario_material_w,
			pr_descontos_w
		from	ordem_compra_item
		where	nr_ordem_compra = nr_ordem_compra_p
		and	nr_item_oci	= nr_item_oci_p;

		vl_tributo_w	:= (pr_tributo_w / 100) * ((qt_material_w *
				vl_unitario_material_w) - (qt_material_w *
				vl_unitario_material_w) * (pr_descontos_w / 100));

		update	ordem_compra_item_trib
		set	vl_tributo = vl_tributo_w
		where	nr_ordem_compra = nr_ordem_compra_p
		and	nr_item_oci	= nr_item_oci_p
		and	cd_tributo	= cd_tributo_w;
		commit;

		end;
	END LOOP;
	CLOSE C01;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recalcular_tributo_ordem ( nr_ordem_compra_p bigint, nr_item_oci_p bigint) FROM PUBLIC;

