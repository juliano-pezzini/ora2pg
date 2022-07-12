-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estq_menor_minimo ( nr_item_oci_p bigint, nr_ordem_compra_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_menor_w		varchar(1)	:= 'N';
cd_material_w		bigint;


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_menor_w
from	ordem_compra_item a,
	material_estab b
where	a.nr_ordem_compra 	= nr_ordem_compra_p
and	a.nr_item_oci		= nr_item_oci_p
and	a.cd_material 		= b.cd_material
and	b.cd_estabelecimento	= cd_estabelecimento_p
and	b.qt_estoque_minimo 	> obter_saldo_disp_estoque(cd_estabelecimento_p,a.cd_material,null,clock_timestamp());

return	ie_menor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estq_menor_minimo ( nr_item_oci_p bigint, nr_ordem_compra_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

