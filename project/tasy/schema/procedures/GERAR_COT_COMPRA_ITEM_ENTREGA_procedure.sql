-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cot_compra_item_entrega ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w		smallint;
nr_item_cot_compra_w	integer;
qt_material_w		double precision;
dt_limite_entrega_w		timestamp;


BEGIN

select	qt_material,
	dt_limite_entrega
into STRICT	qt_material_w,
	dt_limite_entrega_w
from	cot_compra_item
where	nr_cot_compra		= nr_cot_compra_p
and	nr_item_cot_compra	= nr_item_cot_compra_p;

select	count(*)
into STRICT	qt_existe_w
from	cot_compra_item_entrega
where	nr_cot_compra		= nr_cot_compra_p
and	nr_item_cot_compra	= nr_item_cot_compra_p;
if (qt_existe_w = 0) then
	select	coalesce(max(nr_item_cot_compra),0) + 1
	into STRICT	nr_item_cot_compra_w
	from	cot_compra_item_entrega
	where	nr_cot_compra		= nr_cot_compra_p
	and	nr_item_cot_compra	= nr_item_cot_compra_p;

	insert into cot_compra_item_entrega(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_cot_compra,
			nr_item_cot_compra,
			dt_entrega,
			qt_entrega,
			ds_observacao)
		values (nextval('cot_compra_item_entrega_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_cot_compra_p,
			nr_item_cot_compra_p,
			dt_limite_entrega_w,
			qt_material_w,
			null);
elsif (qt_existe_w = 1) then
	update	cot_compra_item_entrega
	set	qt_entrega	= qt_material_w,
		dt_entrega	= dt_limite_entrega_w
	where	nr_cot_compra	= nr_cot_compra_p
	and	nr_item_cot_compra = nr_item_cot_compra_p;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cot_compra_item_entrega ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_usuario_p text) FROM PUBLIC;
