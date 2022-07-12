-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_cotacao_mat ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	select     a.nr_cot_compra
	into STRICT	   ds_retorno_w
	from   	   cot_compra_item a,
		   cot_compra b
	where  	   a.cd_material = cd_material_p
	and	   a.nr_cot_compra = b.nr_cot_compra
	and	   b.cd_estabelecimento	= cd_estabelecimento_p
	and	   b.dt_cot_compra = (SELECT max(dt_cot_compra) from cot_compra);
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_cotacao_mat ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
