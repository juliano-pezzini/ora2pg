-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_opme_convenio (nr_sequencia_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1):= 'N';
ie_opme_w		varchar(1);

C01 CURSOR FOR
	SELECT	ie_opme
	from	conv_regra_mat_opme
	where	cd_convenio = cd_convenio_p
	and	coalesce(cd_material,cd_material_p)				= cd_material_p
	and 	coalesce(cd_classe_material, cd_classe_material_p)		= cd_classe_material_p
	and 	coalesce(cd_subgrupo_material, cd_subgrupo_material_p) 	= cd_subgrupo_material_p
	and 	coalesce(cd_grupo_material, cd_grupo_material_p) 	 	= cd_grupo_material_p
	order by coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0);

BEGIN

ie_retorno_w:= 'N';

open C01;
loop
fetch C01 into
	ie_opme_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_opme_w:= ie_opme_w;
	end;
end loop;
close C01;

ie_retorno_w:= coalesce(ie_opme_w, ie_retorno_w);

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_opme_convenio (nr_sequencia_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, cd_convenio_p bigint) FROM PUBLIC;

