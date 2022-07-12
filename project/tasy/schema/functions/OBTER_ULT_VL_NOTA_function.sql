-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_vl_nota ( cd_material_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	select min(b.vl_unitario_item_nf)
	into STRICT   ds_retorno_w
	from   nota_fiscal a,
	       nota_fiscal_item b
	where  a.nr_sequencia = b.nr_sequencia
	and    b.cd_material = cd_material_p
	and	a.nr_sequencia = nr_sequencia_p;



end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_vl_nota ( cd_material_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

