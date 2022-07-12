-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_se_desdobra_req ( nr_requisicao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
ie_desdobrar_w		varchar(1);
qt_existe_w		bigint;

cd_material_w		integer;
cd_local_estoque_w	smallint;
cd_operacao_estoque_w	smallint;
cd_estabelecimento_w	smallint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
nr_seq_familia_w	bigint;
cd_local_destino_w	requisicao_material.cd_local_estoque_destino%type;
ie_controlado_w		varchar(1);

c01 CURSOR FOR
	SELECT	b.cd_material,
		e.cd_grupo_material,
		e.cd_subgrupo_material,
		e.cd_classe_material,
		e.nr_seq_familia,
		a.cd_local_estoque,
		a.cd_operacao_estoque,
		a.cd_estabelecimento,
		a.cd_local_estoque_destino,
		substr(obter_se_medic_controlado(b.cd_material),1,1)
	from	requisicao_material a,
		item_requisicao_material b,
		estrutura_material_v e
	where	a.nr_requisicao = nr_requisicao_p
	and	a.nr_requisicao = b.nr_requisicao
	and	b.cd_material = e.cd_material;


BEGIN

open C01;
loop
fetch C01 into
	cd_material_w,
	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	nr_seq_familia_w,
	cd_local_estoque_w,
	cd_operacao_estoque_w,
	cd_estabelecimento_w,
	cd_local_destino_w,
	ie_controlado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(ie_desdobrar)
	into STRICT	ie_desdobrar_w
	from(	SELECT	ie_desdobrar
		from	regra_desdobramento_req
		where	ie_situacao = 'A'
		and	cd_estabelecimento = cd_estabelecimento_w
		and	coalesce(cd_material,cd_material_w) = cd_material_w
		and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
		and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
		and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
		and	coalesce(cd_operacao_estoque,cd_operacao_estoque_w) = cd_operacao_estoque_w
		and	coalesce(cd_local_estoque,cd_local_estoque_w) = cd_local_estoque_w
		and	coalesce(nr_seq_familia,coalesce(nr_seq_familia_w,0)) = coalesce(nr_seq_familia_w,0)
		and	coalesce(cd_local_destino,coalesce(cd_local_destino_w,0)) = coalesce(cd_local_destino_w,0)
		and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') = ie_controlado_w))
		order by cd_material,
			nr_seq_familia,
			cd_classe_material,
			cd_subgrupo_material,
			cd_grupo_material,
			cd_local_estoque,
			cd_local_destino,
			ie_controlado desc,
			cd_operacao_estoque) LIMIT 1;

	if (ie_desdobrar_w = 'S') then
		ds_retorno_w := 'S';
		exit;
	end if;

	end;
end loop;
close C01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_se_desdobra_req ( nr_requisicao_p bigint) FROM PUBLIC;
