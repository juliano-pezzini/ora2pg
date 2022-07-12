-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estoque_minimo_material (cd_estabelecimento_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


qt_estoque_minimo_w	double precision;


BEGIN
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	max(qt_estoque_minimo)
	into STRICT	qt_estoque_minimo_w
	from	material_estab
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_material	= cd_material_p;

	if (coalesce(qt_estoque_minimo_w::text, '') = '') then

		select	max(qt_estoque_minimo)
		into STRICT	qt_estoque_minimo_w
		from	material
		where	cd_material = cd_material_p;

	end if;

end if;

return qt_estoque_minimo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estoque_minimo_material (cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;

