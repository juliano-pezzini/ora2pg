-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_ficha_tecnica ( cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1)	:= 'N';


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	ficha_tecnica a
	where	a.cd_material		= cd_material_p
	and	a.cd_estabelecimento	= cd_estabelecimento_p;

	if (ie_retorno_w = 'N') then

		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	custo_material a
		where	a.cd_estabelecimento	= cd_estabelecimento_p
		and	a.cd_material		= cd_material_p;

	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_ficha_tecnica ( cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
