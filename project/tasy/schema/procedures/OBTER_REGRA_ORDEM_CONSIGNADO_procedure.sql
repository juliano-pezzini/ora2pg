-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_ordem_consignado ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_operacao_estoque_p bigint, cd_material_p bigint, cd_cgc_p text, cd_convenio_p bigint, cd_setor_prescricao_p bigint, ie_gera_ordem_p INOUT text, cd_local_entrega_p INOUT bigint, cd_centro_custo_p INOUT bigint, pr_desconto_p INOUT bigint, nm_usuario_dest_p INOUT text, cd_perfil_comunic_p INOUT bigint, cd_pessoa_solicitante_p INOUT text, ie_gera_oc_reposicao_p INOUT text) AS $body$
DECLARE


cd_grupo_material_w		smallint;
cd_subgrupo_w			smallint;
cd_classe_material_w		integer;
ie_gera_ordem_w			varchar(01);
nr_regras_w			integer;
cd_local_entrega_w		bigint;
cd_centro_custo_w		bigint;
pr_desconto_w			bigint;
nm_usuario_dest_w		varchar(255);
cd_pessoa_solicitante_w		varchar(10);
ie_regra_oc_consig_vazia_w	varchar(15);
cd_perfil_comunic_w		integer;
ie_gera_oc_reposicao_w		varchar(1);

c01 CURSOR FOR
	SELECT	ie_gera_ordem,
		cd_local_entrega,
		cd_centro_custo,
		pr_desconto,
		nm_usuario_dest,
		cd_pessoa_solicitante,
		cd_perfil_comunic,
		coalesce(ie_gera_oc_reposicao,'N')
	from	regra_ordem_consignado
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_local_estoque = cd_local_estoque_p
	and	cd_operacao_estoque = cd_operacao_estoque_p
	and	coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_w) = cd_subgrupo_w
	and	coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
	and	coalesce(cd_material, cd_material_p) = cd_material_p
	and	coalesce(cd_fornecedor, cd_cgc_p) = cd_cgc_p
	and	coalesce(cd_convenio, cd_convenio_p) = cd_convenio_p
	and	coalesce(cd_setor_prescricao, cd_setor_prescricao_p) = cd_setor_prescricao_p
	order by
		coalesce(cd_fornecedor, '0'),
		coalesce(cd_convenio, 0),
		coalesce(cd_setor_prescricao, 0),
		coalesce(cd_material, 0),
		coalesce(cd_classe_material, 0),
		coalesce(cd_subgrupo_material, 0),
		coalesce(cd_grupo_material, 0);


BEGIN

select	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material
into STRICT	cd_grupo_material_w,
	cd_subgrupo_w,
	cd_classe_material_w
from	estrutura_material_v
where 	cd_material = cd_material_p;

select	coalesce(ie_regra_oc_consig_vazia,'S')
into STRICT	ie_regra_oc_consig_vazia_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;

select	count(*)
into STRICT	nr_regras_w
from	regra_ordem_consignado
where	cd_estabelecimento = cd_estabelecimento_p;

if (nr_regras_w = 0) then
	if (ie_regra_oc_consig_vazia_w = 'N') then
		ie_gera_ordem_w	:= 'N';
	else
		ie_gera_ordem_w	:= 'S';
	end if;
else
	begin
	open	c01;
	loop
	fetch	c01 into
		ie_gera_ordem_w,
		cd_local_entrega_w,
		cd_centro_custo_w,
		pr_desconto_w,
		nm_usuario_dest_w,
		cd_pessoa_solicitante_w,
		cd_perfil_comunic_w,
		ie_gera_oc_reposicao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close 	c01;

	end;
end if;

ie_gera_ordem_p		:= ie_gera_ordem_w;
cd_local_entrega_p	:= cd_local_entrega_w;
cd_centro_custo_p	:= cd_centro_custo_w;
pr_desconto_p		:= pr_desconto_w;
nm_usuario_dest_p	:= nm_usuario_dest_w;
cd_pessoa_solicitante_p	:= cd_pessoa_solicitante_w;
cd_perfil_comunic_p	:= cd_perfil_comunic_w;
ie_gera_oc_reposicao_p	:= ie_gera_oc_reposicao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_ordem_consignado ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_operacao_estoque_p bigint, cd_material_p bigint, cd_cgc_p text, cd_convenio_p bigint, cd_setor_prescricao_p bigint, ie_gera_ordem_p INOUT text, cd_local_entrega_p INOUT bigint, cd_centro_custo_p INOUT bigint, pr_desconto_p INOUT bigint, nm_usuario_dest_p INOUT text, cd_perfil_comunic_p INOUT bigint, cd_pessoa_solicitante_p INOUT text, ie_gera_oc_reposicao_p INOUT text) FROM PUBLIC;

