-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_int_mov_estoque ( ie_integracao_p regra_integr_movto_estoque.ie_integracao%type, cd_operacao_estoque_p regra_integr_movto_estoque.cd_operacao_estoque%type, cd_local_estoque_p regra_integr_movto_estoque.cd_local_estoque%type, cd_grupo_material_p regra_integr_movto_estoque.cd_grupo_material%type, cd_subgrupo_material_p regra_integr_movto_estoque.cd_subgrupo_material%type, cd_classe_material_p regra_integr_movto_estoque.cd_classe_material%type, cd_material_p regra_integr_movto_estoque.cd_material%type, ie_entrada_saida_p regra_integr_movto_estoque.ie_entrada_saida%type) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_w		regra_integr_movto_estoque.nr_sequencia%type;


BEGIN

if (ie_integracao_p IS NOT NULL AND ie_integracao_p::text <> '') then
	select	max(r.nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	regra_integr_movto_estoque r
	where	r.ie_situacao = 'A'
	and	r.ie_integra = 'S'
	and	r.ie_integracao	= ie_integracao_p
	and	coalesce(r.cd_operacao_estoque,cd_operacao_estoque_p)	= cd_operacao_estoque_p
	and	coalesce(r.cd_local_estoque,cd_local_estoque_p)		= cd_local_estoque_p
	and	coalesce(r.cd_grupo_material,cd_grupo_material_p)		= cd_grupo_material_p
	and	coalesce(r.cd_subgrupo_material,cd_subgrupo_material_p)	= cd_subgrupo_material_p
	and	coalesce(r.cd_classe_material,cd_classe_material_p)		= cd_classe_material_p
	and	coalesce(r.cd_material,cd_material_p)			= cd_material_p
	and (r.ie_entrada_saida					= ie_entrada_saida_p or ie_entrada_saida = 'A');
end if;

return  nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_int_mov_estoque ( ie_integracao_p regra_integr_movto_estoque.ie_integracao%type, cd_operacao_estoque_p regra_integr_movto_estoque.cd_operacao_estoque%type, cd_local_estoque_p regra_integr_movto_estoque.cd_local_estoque%type, cd_grupo_material_p regra_integr_movto_estoque.cd_grupo_material%type, cd_subgrupo_material_p regra_integr_movto_estoque.cd_subgrupo_material%type, cd_classe_material_p regra_integr_movto_estoque.cd_classe_material%type, cd_material_p regra_integr_movto_estoque.cd_material%type, ie_entrada_saida_p regra_integr_movto_estoque.ie_entrada_saida%type) FROM PUBLIC;

