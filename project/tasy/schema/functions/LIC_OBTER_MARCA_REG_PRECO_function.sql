-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_marca_reg_preco ( nr_seq_reg_preco_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_marca_w			varchar(255);


BEGIN

select	max(ds_marca)
into STRICT	ds_marca_w
from	reg_compra_item
where	nr_seq_reg_compra = nr_seq_reg_preco_p
and	cd_material = cd_material_p;

return	ds_marca_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_marca_reg_preco ( nr_seq_reg_preco_p bigint, cd_material_p bigint) FROM PUBLIC;
