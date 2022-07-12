-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_mat_tab ( cd_estabelacimento_p bigint, cd_material_p bigint, cd_tabela_p bigint) RETURNS bigint AS $body$
DECLARE


vl_material_w		double precision := 0;


BEGIN

select	coalesce(max(a.vl_preco_venda),0)
into STRICT	vl_material_w
from	preco_material a
where	a.cd_estabelecimento = cd_estabelacimento_p
and	a.cd_material = cd_material_p
and	a.cd_tab_preco_mat = cd_tabela_p
and	a.dt_inicio_vigencia =	(SELECT	max(x.dt_inicio_vigencia)
				from	preco_material x
				where	x.cd_estabelecimento = cd_estabelacimento_p
				and	x.cd_material = cd_material_p
				and	x.cd_tab_preco_mat = cd_tabela_p);


return	vl_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_mat_tab ( cd_estabelacimento_p bigint, cd_material_p bigint, cd_tabela_p bigint) FROM PUBLIC;
