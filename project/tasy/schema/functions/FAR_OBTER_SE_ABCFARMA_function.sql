-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_se_abcfarma (cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w 		varchar(1):= 'N';
qt_parametros_w		integer:=0;
cd_tab_preco_mat_w 	bigint;
qt_preco_w		integer:=0;


BEGIN

select	count(*)
into STRICT	qt_parametros_w
from	far_parametros_gerais
where	cd_estabelecimento = cd_estabelecimento_p
and		coalesce(cd_tab_preco_mat,0) > 0;

if (coalesce(qt_parametros_w,0) > 0) then

	select	cd_tab_preco_mat
	into STRICT	cd_tab_preco_mat_w
	from	far_parametros_gerais
	where	cd_estabelecimento = cd_estabelecimento_p;

	select	count(*)
	into STRICT	qt_preco_w
	from	preco_material
	where	cd_material = cd_material_p
	and		cd_tab_preco_mat = cd_tab_preco_mat_w;

	if (coalesce(qt_preco_w,0) > 0 ) then

		retorno_w:= 'S';

	end if;

end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_se_abcfarma (cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
