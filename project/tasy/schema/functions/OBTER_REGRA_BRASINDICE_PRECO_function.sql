-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_brasindice_preco ( cd_convenio_p bigint, cd_categoria_p text, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, dt_vigencia_p timestamp, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_preco_w		varchar(3);
nr_seq_familia_w	material.nr_seq_familia%type;

C01 CURSOR FOR
	SELECT	ie_tipo_preco
	from	regra_brasindice_preco
	where	coalesce(cd_categoria,cd_categoria_p)		= cd_categoria_p
	and	coalesce(cd_classe_material,cd_classe_material_p)	= cd_classe_material_p
	and	coalesce(cd_convenio,cd_convenio_p)			= cd_convenio_p
	and	coalesce(cd_grupo_material,cd_grupo_material_p)	= cd_grupo_material_p
	and	coalesce(cd_material,cd_material_p)			= cd_material_p
	and	coalesce(cd_subgrupo_material,cd_subgrupo_material_p)= cd_subgrupo_material_p
	and 	coalesce(nr_seq_familia, coalesce(nr_seq_familia_w,0))    = coalesce(nr_seq_familia_w,0)
	and	dt_vigencia_p between dt_inicio_vigencia and coalesce(dt_final_vigencia,dt_vigencia_p)
	and	cd_estabelecimento				= cd_estabelecimento_p
	and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_p) = 'S'))
	and	((coalesce(ie_tipo_atendimento::text, '') = '') or (ie_tipo_atendimento = coalesce(ie_tipo_atendimento_p,0)))
	order by	coalesce(cd_estabelecimento,0),
		coalesce(cd_convenio,0),
		coalesce(cd_categoria,0),
		coalesce(ie_tipo_atendimento_p,0),
		coalesce(nr_seq_estrutura,0),
		coalesce(cd_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0);		

BEGIN

select 	coalesce(max(nr_seq_familia),0)
into STRICT	nr_seq_familia_w
from 	material
where	cd_material = cd_material_p;

open C01;
loop
fetch C01 into	
	ie_tipo_preco_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_tipo_preco_w := ie_tipo_preco_w;
	end;
end loop;
close C01;


return	ie_tipo_preco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_brasindice_preco ( cd_convenio_p bigint, cd_categoria_p text, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, dt_vigencia_p timestamp, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint) FROM PUBLIC;

