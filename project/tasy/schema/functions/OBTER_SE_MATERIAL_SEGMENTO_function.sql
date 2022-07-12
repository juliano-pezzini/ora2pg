-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_material_segmento ( nr_seq_segmento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
nr_seq_familia_w			bigint;
qt_existe_w			bigint;
ie_curva_abc_w			varchar(1);


BEGIN

if (cd_material_p > 0) then
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		nr_seq_familia
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		nr_seq_familia_w
	from	estrutura_material_v
	where	cd_material = cd_material_p;

	ie_curva_abc_w := SUBSTR(Obter_Curva_ABC(cd_material_p, 'N',clock_timestamp()),1,1);

	if (nr_seq_segmento_p > 0) then
		select	count(*)
		into STRICT	qt_existe_w
		from	segmento_compras_estrut
		where	nr_seq_segmento = nr_seq_segmento_p
		and (ie_curva_abc = 'T' or ie_curva_abc = ie_curva_abc_w)
		and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
		and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
		and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
		and	coalesce(cd_material, cd_material_p)			= cd_material_p
		and	((coalesce(nr_seq_familia, nr_seq_familia_w)			= nr_seq_familia_w) or (coalesce(nr_seq_familia::text, '') = ''));

		if (qt_existe_w > 0) then
			ds_retorno_w := 'S';
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_material_segmento ( nr_seq_segmento_p bigint, cd_material_p bigint) FROM PUBLIC;
