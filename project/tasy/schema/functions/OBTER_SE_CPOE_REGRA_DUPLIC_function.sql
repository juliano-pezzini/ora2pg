-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cpoe_regra_duplic (ie_tipo_item_p text, cd_perfil_p bigint, cd_setor_atendimento_p bigint, cd_material_p bigint default null) RETURNS varchar AS $body$
DECLARE

				
ds_retorno_w			varchar(1);
ie_existe_regra_w		varchar(1);
nr_seq_regra_w			bigint;
cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w	SubGrupo_Material.cd_subgrupo_material%type;
cd_classe_material_w	Classe_material.cd_classe_material%type;
ie_possui_regra_w		varchar(1) := 'N';
nr_seq_consist_w		cpoe_regra_consistencia.nr_sequencia%type;


BEGIN

select	max(b.nr_sequencia),
		max(c.nr_sequencia)
into STRICT	nr_seq_regra_w,
		nr_seq_consist_w
from	cpoe_regra_consistencia c,
		cpoe_regra_duplicidade b
where	c.nr_sequencia = b.nr_seq_regra
and		coalesce(c.cd_perfil, cd_perfil_p) = cd_perfil_p
and		coalesce(c.cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p
and		coalesce(c.cd_estabelecimento, obter_estabelecimento_ativo) = obter_estabelecimento_ativo;


if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	select 	coalesce(max('N'), 'S')
	into STRICT 	ds_retorno_w
	from	cpoe_regra_duplicidade b
	where	b.nr_sequencia = nr_seq_regra_w
	and		((ie_consiste_dupl_sol = 'N' and ie_tipo_item_p in ('MAT','MCOMP1', 'MCOMP2', 'MCOMP3','MCOMP4', 'MCOMP5', 'MCOMP6', 'MCOMPADD',
																'PMAT1', 'PMAT2', 'PMAT3', 'PMAT4', 'PMAT5',
																'GMAT1', 'GMAT2', 'GMAT3',
																'DPROD1', 'DPROD2', 'DPROD3', 'DPROD4', 'DPROD5',
																'MSOL1', 'MSOL2', 'MSOL3', 'MSOL4', 'MSOL5',
																'MCOMP1', 'MCOMP2', 'MCOMP3', 'MCOMP4', 'MCOMP5', 'MCOMP6')) or (ie_consiste_dupl_exa = 'N' and ie_tipo_item_p = 'P') or (ie_consiste_dupl_nut = 'N' and ie_tipo_item_p in ('E','J','L','O','S')) or (ie_consiste_dupl_gas = 'N' and ie_tipo_item_p = 'G') or (ie_consiste_dupl_rec = 'N' and ie_tipo_item_p = 'R') or (ie_consiste_dupl_hem = 'N' and ie_tipo_item_p in ('HBC', 'HP')) or (ie_consiste_dupl_dia = 'N' and ie_tipo_item_p in ('DI', 'DP')) or (ie_consiste_dupl_mat = 'N' and ie_tipo_item_p = 'M')or (ie_consiste_dupl_ana = 'N' and ie_tipo_item_p = 'AP'));

	if (ds_retorno_w = 'S') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
		
		select 	max(cd_grupo_material),
				max(cd_subgrupo_material),
				max(cd_classe_material)
		into STRICT 	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w
		from	Estrutura_Material_V
		where	cd_material = cd_material_p;
		
		select 	coalesce(max('S'),'N')
		into STRICT 	ie_possui_regra_w
		from 	cpoe_regra_duplic_item
		where	nr_seq_regra = nr_seq_consist_w;
		
		if (ie_possui_regra_w = 'S') then
			
			select	coalesce(max('N'),'S')
			into STRICT	ds_retorno_w
			from 	cpoe_regra_duplic_item
			where 	nr_seq_regra = nr_seq_consist_w
			and 	coalesce(cd_material,cd_material_p) = cd_material_p
			and 	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
			and 	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
			and 	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w;
		end if;
	end if;
else
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cpoe_regra_duplic (ie_tipo_item_p text, cd_perfil_p bigint, cd_setor_atendimento_p bigint, cd_material_p bigint default null) FROM PUBLIC;
