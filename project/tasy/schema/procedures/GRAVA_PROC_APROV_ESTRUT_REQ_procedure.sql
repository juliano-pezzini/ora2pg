-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_proc_aprov_estrut_req ( nr_requisicao_p bigint, cd_material_p bigint, cd_perfil_ativo_p bigint, cd_estabelecimento_p bigint, cd_processo_aprov_p INOUT bigint) AS $body$
DECLARE

 
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
cd_centro_custo_w			bigint;
cd_local_estoque_w		bigint;
cd_local_estoque_destino_w		bigint;
cd_operacao_estoque_w		smallint;
ie_tipo_requisicao_w		varchar(3);
ie_urgente_w			varchar(1);
ie_consignado_w			varchar(10);
ie_padronizado_w			varchar(10);
ie_material_estoque_w		varchar(01);
ie_curva_abc_w			varchar(01);
cd_processo_aprov_w		bigint;
cd_setor_atendimento_w		integer;

c01 CURSOR FOR 
SELECT	b.cd_processo_aprov 
from	Processo_Aprov_Estrut a, 
	processo_aprovacao b 
where	a.cd_processo_aprov = b.cd_processo_aprov 
and	b.ie_situacao <> 'I' 
and	((coalesce(a.cd_perfil::text, '') = '') or (coalesce(cd_perfil_ativo_p::text, '') = '') or (a.cd_perfil = cd_perfil_ativo_p)) 
and	coalesce(a.cd_estabelecimento, cd_estabelecimento_p)			= cd_estabelecimento_p 
and	coalesce(b.cd_estabelecimento, cd_estabelecimento_p)			= cd_estabelecimento_p 
and	coalesce(a.cd_material, cd_material_p)				= cd_material_p 
and (coalesce(a.cd_setor_atendimento::text, '') = '' or a.cd_setor_atendimento			= cd_setor_atendimento_w) 
and (coalesce(a.cd_centro_custo::text, '') = '' or a.cd_centro_custo			= cd_centro_custo_w) 
and (coalesce(a.cd_local_estoque::text, '') = '' or a.cd_local_estoque			= cd_local_estoque_w) 
and (coalesce(a.cd_local_estoque_destino::text, '') = '' or a.cd_local_estoque_destino 	= cd_local_estoque_destino_w) 
and (coalesce(a.cd_operacao_estoque::text, '') = '' or a.cd_operacao_estoque 	 	= cd_operacao_estoque_w) 
and	coalesce(a.cd_classe_material, cd_classe_material_w) 			= cd_classe_material_w 
and	coalesce(a.cd_subgrupo_material, cd_subgrupo_material_w) 		= cd_subgrupo_material_w 
and	coalesce(a.cd_grupo_material, cd_grupo_material_w) 			= cd_grupo_material_w 
and	coalesce(a.ie_consignado, ie_consignado_w) 				= ie_consignado_w 
and	((ie_padronizado = 'T') or (ie_padronizado 			= ie_padronizado_w)) 
and	((ie_material_estoque = 'A') or (ie_material_estoque 		= ie_material_estoque_w)) 
and	((ie_urgente = 'A') or (ie_urgente 				= ie_urgente_w)) 
and	(( coalesce(ie_curva_abc,'N') = 'N') or (ie_curva_abc_w = 'N') or (ie_curva_abc = ie_curva_abc_w)) 
and	((coalesce(a.vl_compra_mes, 0) = 0) or (coalesce(a.vl_compra_mes, 0) < Obter_vl_compra_mes_proc_aprov(a.nr_sequencia, a.cd_processo_aprov))) 
and	a.cd_processo_aprov in( 
		SELECT	x.cd_processo_aprov 
		from	processo_aprov_resp x 
		where	x.ie_requisicao		= 'S' 
		and	((ie_tipo_requisicao_w	<> '2') or 
			((ie_tipo_requisicao_w	= '2') and (coalesce(x.ie_desconsidera_req_transf,'N') = 'N')))) 
		 
order by	coalesce(cd_material,0), 
	coalesce(cd_classe_material,0), 
	coalesce(cd_subgrupo_material,0), 
	coalesce(cd_grupo_material,0), 
	coalesce(cd_local_estoque,0), 
	coalesce(cd_centro_custo,0), 
	coalesce(a.cd_perfil,0);


BEGIN 
 
select	cd_setor_atendimento, 
	cd_centro_custo, 
	cd_local_estoque, 
	cd_local_estoque_destino, 
	b.cd_operacao_estoque, 
	coalesce(ie_tipo_requisicao,0), 
	coalesce(ie_urgente,'N') 
into STRICT	cd_setor_atendimento_w, 
	cd_centro_custo_w, 
	cd_local_estoque_w, 
	cd_local_estoque_destino_w, 
	cd_operacao_estoque_w, 
	ie_tipo_requisicao_w, 
	ie_urgente_w 
from	operacao_estoque a, 
	requisicao_material b 
where	a.cd_operacao_estoque = b.cd_operacao_estoque 
and	nr_requisicao = nr_requisicao_p;
 
 
select	a.cd_grupo_material, 
	a.cd_subgrupo_material, 
	a.cd_classe_material, 
	coalesce(a.ie_consignado,0), 
	substr(obter_se_material_padronizado(cd_estabelecimento_p, cd_material_p),1,1) ie_padronizado, 
	substr(obter_se_material_estoque(cd_estabelecimento_p, 0, cd_material_p),1,1) ie_material_estoque, 
	substr(obter_curva_abc_estab(cd_estabelecimento_p,cd_material_p,'N',trunc(clock_timestamp(),'mm')),1,1) 
into STRICT	cd_grupo_material_w, 
	cd_subgrupo_material_w, 
	cd_classe_material_w, 
	ie_consignado_w, 
	ie_padronizado_w, 
	ie_material_estoque_w, 
	ie_curva_abc_w 
from	estrutura_material_v a 
where	a.cd_material = cd_material_p;
 
if (ie_curva_abc_w = 'X') then 
	ie_curva_abc_w			:= 'N';
end if;
 
open C01;
loop 
fetch C01 into 
	cd_processo_aprov_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	cd_processo_aprov_p := cd_processo_aprov_w;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_proc_aprov_estrut_req ( nr_requisicao_p bigint, cd_material_p bigint, cd_perfil_ativo_p bigint, cd_estabelecimento_p bigint, cd_processo_aprov_p INOUT bigint) FROM PUBLIC;
