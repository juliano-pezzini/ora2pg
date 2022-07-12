-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_validade_minima ( cd_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_requisicao_p text default null) RETURNS bigint AS $body$
DECLARE


ds_retorno_w			varchar(1);
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
ie_local_estoque_lote_w		varchar(1);
qt_dias_validade_w		bigint;
cd_perfil_w			integer;
cd_local_estoque_w		smallint	:= null;
cd_local_estoque_destino_w 	smallint	:= null;


BEGIN

cd_perfil_w := coalesce(wheb_usuario_pck.get_cd_perfil,0);

select 	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	estrutura_material_v
where	cd_material = cd_material_p;

if (coalesce(nr_requisicao_p,'X') <> 'X') then
	begin

	select 	cd_local_estoque,
		cd_local_estoque_destino
	into STRICT	cd_local_estoque_w,
		cd_local_estoque_destino_w
	from 	requisicao_material
	where 	nr_requisicao = nr_requisicao_p;

	end;
end if;

select	coalesce(max(qt_dias_validade_lote),0)
into STRICT	qt_dias_validade_w
from	(SELECT	coalesce(qt_dias_validade_lote,0) qt_dias_validade_lote
	from	regra_val_minima_lote
	where	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_p
	and	coalesce(cd_material, cd_material_p) = cd_material_p
	and	coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
	and	coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
	and	coalesce(cd_perfil, cd_perfil_w) = cd_perfil_w
	and	coalesce(nm_usuario_reg, nm_usuario_p) = nm_usuario_p
	and	coalesce(ie_barras,'S') = 'S'
	and	((coalesce(cd_local_origem::text, '') = '') or (cd_local_origem = cd_local_estoque_w))
	and ((coalesce(cd_local_destino::text, '') = '') or (cd_local_destino = cd_local_estoque_destino_w))
	order by cd_material,
		cd_classe_material,
		cd_subgrupo_material,
		cd_grupo_material,
		cd_perfil,
		nm_usuario_reg) alias18 LIMIT 1;

return qt_dias_validade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_validade_minima ( cd_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_requisicao_p text default null) FROM PUBLIC;

