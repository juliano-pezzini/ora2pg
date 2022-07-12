-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_item_sc_reg_preco ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE


ie_possui_w			varchar(1) := 'N';
qt_existe_w			bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_compra a,
	reg_lic_compra_item b
where	a.nr_sequencia		= b.nr_seq_reg_lic_compra
and	b.nr_solic_compra		= nr_solic_compra_p
and	b.nr_item_solic_compra	= nr_item_solic_compra_p;

if (qt_existe_w > 0) then
	ie_possui_w := 'S';
end if;

return	ie_possui_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_item_sc_reg_preco ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) FROM PUBLIC;
