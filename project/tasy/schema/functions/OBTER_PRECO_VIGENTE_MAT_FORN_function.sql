-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_vigente_mat_forn ( cd_cnpj_p text, cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


vl_item_w		double precision;


BEGIN

select	min(vl_item)
into STRICT	vl_item_w
from	preco_pj
where	cd_cgc = cd_cnpj_p
and	cd_material = cd_material_p
and	((coalesce(dt_vigencia::text, '') = '') or (trunc(dt_vigencia,'dd') <= trunc(clock_timestamp(),'dd')))
and	((coalesce(dt_vigencia_fim::text, '') = '') or (trunc(dt_vigencia_fim,'dd') >= trunc(clock_timestamp(),'dd')))
and	((coalesce(cd_estabelecimento::text, '') = '') or
	(cd_estabelecimento IS NOT NULL AND cd_estabelecimento::text <> '' AND cd_estabelecimento = cd_estabelecimento_p));

return	vl_item_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_vigente_mat_forn ( cd_cnpj_p text, cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
