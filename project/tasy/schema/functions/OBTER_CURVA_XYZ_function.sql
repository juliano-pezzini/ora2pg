-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_curva_xyz ( cd_estabelecimento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1);
qt_reg_w			smallint;


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	material_estab
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p;


if (qt_reg_w > 0) then
	select	ie_curva_xyz
	into STRICT	ds_retorno_w
	from	material_estab
	where	cd_material = cd_material_p
	and	cd_estabelecimento = cd_estabelecimento_p;
end if;

RETURN	ds_retorno_w;
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_curva_xyz ( cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;
