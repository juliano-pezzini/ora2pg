-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atributo_cot_compra ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_atributo_p text) RETURNS varchar AS $body$
DECLARE


ds_resultado_w	varchar(80);


BEGIN

if (upper(nm_atributo_p) = 'CD_MATERIAL') then
	select cd_material
	into STRICT ds_resultado_w
	from	cot_compra_item
	where nr_cot_compra = nr_cot_compra_p
	  and nr_item_cot_compra = nr_item_cot_compra_p;
elsif (upper(nm_atributo_p) = 'CD_UNIDADE_MEDIDA_COMPRA') then
	select cd_unidade_medida_compra
	into STRICT ds_resultado_w
	from	cot_compra_item
	where nr_cot_compra = nr_cot_compra_p
	  and nr_item_cot_compra = nr_item_cot_compra_p;
end if;

Return ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atributo_cot_compra ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_atributo_p text) FROM PUBLIC;
