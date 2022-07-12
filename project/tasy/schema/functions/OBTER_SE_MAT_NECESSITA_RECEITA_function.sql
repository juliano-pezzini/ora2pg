-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_necessita_receita (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ie_receita_w	varchar(1);


BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	max(ie_receita)
	into STRICT	ie_receita_w
	from	material
	where	cd_material = cd_material_p;

end if;

return ie_receita_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_necessita_receita (cd_material_p bigint) FROM PUBLIC;

