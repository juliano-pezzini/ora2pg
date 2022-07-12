-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_orientacao ( cd_material_p bigint, cd_pessoa_fisica_p text default null) RETURNS char AS $body$
DECLARE


ie_retorno_w	char(1) := 'N';


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	ie_retorno_w := Obter_se_apres_orient_mat(cd_material_p, cd_pessoa_fisica_p);
end if;

if (coalesce(ie_retorno_w,'S') = 'S') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	material where		cd_material	= cd_material_p
	and		coalesce(ie_mostrar_orientacao,'S')	= 'S'
	and		(ds_orientacao_usuario IS NOT NULL AND ds_orientacao_usuario::text <> '') LIMIT 1;

	if (ie_retorno_w = 'N') then

		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	material_reacao
		where	cd_material	= cd_material_p
		and		(ds_reacao IS NOT NULL AND ds_reacao::text <> '') LIMIT 1;
	end if;
end if;

return ie_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_orientacao ( cd_material_p bigint, cd_pessoa_fisica_p text default null) FROM PUBLIC;

