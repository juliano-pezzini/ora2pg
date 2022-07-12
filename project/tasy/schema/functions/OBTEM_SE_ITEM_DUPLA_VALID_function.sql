-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obtem_se_item_dupla_valid ( cd_material_p material.cd_material%type) RETURNS varchar AS $body$
DECLARE


										
ie_tipo_validacao_w			cpoe_item_dupla_valid.ie_tipo_validacao%type := 'I';
ie_retorno_w				varchar(1);
cd_subgrupo_material_w    classe_material.cd_subgrupo_material%type;
cd_grupo_material_w       subgrupo_material.cd_grupo_material%type;
cd_classe_material_w      material.cd_classe_material%type;


c01 CURSOR FOR
	SELECT	coalesce(ie_tipo_validacao,'I')
	from	cpoe_item_dupla_valid
    where	((cd_material = cd_material_p) or (coalesce(cd_material::text, '') = ''))
    and		((cd_grupo_material = cd_grupo_material_w) or (coalesce(cd_grupo_material::text, '') = ''))
    and		((cd_subgrupo_material = cd_subgrupo_material_w) or (coalesce(cd_subgrupo_material::text, '') = ''))
    and		((cd_classe_material = cd_classe_material_w) or (coalesce(cd_classe_material::text, '') = ''))
    order by coalesce(cd_material, 0),
         coalesce(cd_classe_material, 0),
         coalesce(cd_subgrupo_material, 0),
         coalesce(cd_grupo_material, 0);


BEGIN

    cd_classe_material_w := obter_dados_material(cd_material_p, 'CCLA');
    cd_grupo_material_w := obter_dados_material(cd_material_p, 'CGRU');
    cd_subgrupo_material_w := obter_dados_material(cd_material_p, 'CSUB');

	open c01;
	loop
	fetch c01 into	
		ie_tipo_validacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin		
		if (ie_tipo_validacao_w IS NOT NULL AND ie_tipo_validacao_w::text <> '') then
			begin				
				ie_retorno_w	:= ie_tipo_validacao_w;		
			end;
		end if;		
	end;
	end loop;
	close c01;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obtem_se_item_dupla_valid ( cd_material_p material.cd_material%type) FROM PUBLIC;

