-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_material ( nr_seq_material_p pls_cp_cta_filtro_mat.nr_seq_material%type, nr_seq_estrut_mat_p pls_cp_cta_filtro_mat.nr_seq_estrut_mat%type, nr_seq_grupo_material_p pls_cp_cta_filtro_mat.nr_seq_grupo_material%type, ie_tipo_despesa_p pls_cp_cta_filtro_mat.ie_tipo_despesa%type, nr_seq_tipo_uso_p pls_cp_cta_filtro_mat.nr_seq_tipo_uso%type, ie_generico_unimed_p pls_cp_cta_filtro_mat.ie_generico_unimed%type, ie_mat_autorizacao_esp_p pls_cp_cta_filtro_mat.ie_mat_autorizacao_esp%type, ie_restringe_hosp_p pls_cp_cta_filtro_mat.ie_restringe_hosp%type, ds_campos_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

					
ds_restricao_mat_w	varchar(2500);
ds_campos_w		varchar(500);


BEGIN

ds_campos_w := null;

-- Sequencia do material

if (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	ds_restricao_mat_w := ds_restricao_mat_w || '	and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material = :nr_seq_material_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_material_pc', nr_seq_material_p, valor_bind_p);
end if;

-- Estrutura de material

if (nr_seq_estrut_mat_p IS NOT NULL AND nr_seq_estrut_mat_p::text <> '') then

	ds_restricao_mat_w := ds_restricao_mat_w || 	'	and exists(	select	1 ' || pls_util_pck.enter_w ||
							'			from 	pls_estrutura_material_tm x ' || pls_util_pck.enter_w ||
							'			where	x.nr_seq_material = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material ' || pls_util_pck.enter_w ||
							'			and	x.nr_seq_estrutura = :nr_seq_estrut_mat_pc) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_estrut_mat_pc', nr_seq_estrut_mat_p, valor_bind_p);
end if;

-- Grupo de material

if (nr_seq_grupo_material_p IS NOT NULL AND nr_seq_grupo_material_p::text <> '') then

	ds_restricao_mat_w := ds_restricao_mat_w || 	'	and exists(	select	1 ' || pls_util_pck.enter_w ||
							'			from 	pls_grupo_material_tm x ' || pls_util_pck.enter_w ||
							'			where	x.nr_seq_material = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material ' || pls_util_pck.enter_w ||
							'			and	x.nr_seq_grupo = :nr_seq_grupo_material_pc) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_grupo_material_pc', nr_seq_grupo_material_p, valor_bind_p);
end if;

-- Tipo despesa

if (ie_tipo_despesa_p IS NOT NULL AND ie_tipo_despesa_p::text <> '') then

	ds_restricao_mat_w := ds_restricao_mat_w || '	and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.ie_tipo_despesa = :ie_tipo_despesa_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_tipo_despesa_pc', ie_tipo_despesa_p, valor_bind_p);
end if;

-- Tipo uso

if (nr_seq_tipo_uso_p IS NOT NULL AND nr_seq_tipo_uso_p::text <> '') then

	ds_restricao_mat_w := ds_restricao_mat_w || 	'	and exists(	select	1 ' || pls_util_pck.enter_w ||
							'			from 	pls_material x ' || pls_util_pck.enter_w ||
							'			where	x.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material ' || pls_util_pck.enter_w ||
							'			and	x.nr_seq_tipo_uso = :nr_seq_tipo_uso_pc) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_tipo_uso_pc', nr_seq_tipo_uso_p, valor_bind_p);
end if;

-- Generico (UNIMED)

-- so verifica se for S

if (ie_generico_unimed_p = 'S') then

	ds_restricao_mat_w := ds_restricao_mat_w || 	'	and exists(	select	1 ' || pls_util_pck.enter_w ||
							'			from 	pls_material x, ' || pls_util_pck.enter_w ||
							'			 	pls_material_unimed y ' || pls_util_pck.enter_w ||
							'			where	x.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material ' || pls_util_pck.enter_w ||
							'			and	y.cd_material = x.nr_seq_material_unimed ' || pls_util_pck.enter_w ||
							'			and	y.ie_generico = ''S'') ' || pls_util_pck.enter_w;
end if;

-- Material especial

-- so verifica se for S

if (ie_mat_autorizacao_esp_p = 'S') then

	ds_campos_w := ds_campos_w || ', ' || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_segurado, ' || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_guia, ' || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.cd_guia_referencia, ' || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material ';
else
	ds_campos_w :=  ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' null nr_seq_segurado, ' || pls_util_pck.enter_w ||
			' null nr_seq_guia, ' || pls_util_pck.enter_w ||
			' null cd_guia_referencia, ' || pls_util_pck.enter_w ||
			' null nr_seq_material ';
end if;

-- Restringe material do hospital, se o checkbox estiver checado

if (ie_restringe_hosp_p = 'S') then

	ds_campos_w := ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' pls_filtro_regra_preco_cta_pck.obter_se_mat_restrito(' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_seq_material, '
						|| pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.dt_atendimento_referencia) ie_restrige_hosp ';
else
	ds_campos_w :=  ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' ''S'' ie_restrige_hosp ';
end if;

ds_campos_p := ds_campos_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_material ( nr_seq_material_p pls_cp_cta_filtro_mat.nr_seq_material%type, nr_seq_estrut_mat_p pls_cp_cta_filtro_mat.nr_seq_estrut_mat%type, nr_seq_grupo_material_p pls_cp_cta_filtro_mat.nr_seq_grupo_material%type, ie_tipo_despesa_p pls_cp_cta_filtro_mat.ie_tipo_despesa%type, nr_seq_tipo_uso_p pls_cp_cta_filtro_mat.nr_seq_tipo_uso%type, ie_generico_unimed_p pls_cp_cta_filtro_mat.ie_generico_unimed%type, ie_mat_autorizacao_esp_p pls_cp_cta_filtro_mat.ie_mat_autorizacao_esp%type, ie_restringe_hosp_p pls_cp_cta_filtro_mat.ie_restringe_hosp%type, ds_campos_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
