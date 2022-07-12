-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medicamento_material (cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


cd_medicamento_w    bigint	:= 0;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select 	max(cd_medicamento)
	into STRICT	cd_medicamento_w
	from 	material
	where	cd_material	= cd_material_p;

end if;

return	cd_medicamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medicamento_material (cd_material_p bigint) FROM PUBLIC;

