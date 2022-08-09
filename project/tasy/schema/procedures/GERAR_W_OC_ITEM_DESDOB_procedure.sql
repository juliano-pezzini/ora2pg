-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_oc_item_desdob ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_material_w	double precision;


BEGIN

select	qt_material
into STRICT	qt_material_w
from	ordem_compra_item
where	nr_ordem_compra	= nr_ordem_compra_p
and	nr_item_oci	= nr_item_oci_p;

delete from w_ordem_compra_item_desdob
where	nm_usuario = nm_usuario_p
and	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

insert into w_ordem_compra_item_desdob(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_ordem_compra,
	nr_item_oci,
	qt_material)
values (nextval('w_ordem_compra_item_desdob_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_ordem_compra_p,
	nr_item_oci_p,
	qt_material_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_oc_item_desdob ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nm_usuario_p text) FROM PUBLIC;
