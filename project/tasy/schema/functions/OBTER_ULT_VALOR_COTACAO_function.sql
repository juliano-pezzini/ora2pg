-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_valor_cotacao ( cd_material_p bigint, nr_cot_compra_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	select  min(VL_UNITARIO_material)
	into STRICT    ds_retorno_w
	from    cot_compra_resumo a,
		cot_compra_item b,
		cot_compra  c
	where   c.nr_cot_compra = b.nr_cot_compra
	and	a.nr_cot_compra = c.nr_cot_compra
	and	b.nr_cot_compra = a.nr_cot_compra
	and	b.cd_material = cd_material_p
	and	c.nr_cot_compra = nr_cot_compra_p;

end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_valor_cotacao ( cd_material_p bigint, nr_cot_compra_p bigint) FROM PUBLIC;
