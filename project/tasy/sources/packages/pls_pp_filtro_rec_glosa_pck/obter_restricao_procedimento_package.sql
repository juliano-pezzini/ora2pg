-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_filtro_rec_glosa_pck.obter_restricao_procedimento ( ie_origem_proced_p pls_pp_rp_filtro_proc.ie_origem_proced%type, cd_procedimento_p pls_pp_rp_filtro_proc.cd_procedimento%type, cd_grupo_proc_p pls_pp_rp_filtro_proc.cd_grupo_proc%type, cd_especialidade_p pls_pp_rp_filtro_proc.cd_especialidade%type, cd_area_procedimento_p pls_pp_rp_filtro_proc.cd_area_procedimento%type, ie_tipo_despesa_proc_p pls_pp_rp_filtro_proc.ie_tipo_despesa_proc%type, nr_seq_regra_filtro_p pls_pp_cta_combinada.nr_sequencia%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

					
ds_restricao_proc_w	varchar(2500);
ds_tabela_w		varchar(500);
ds_restricao_tab_w	varchar(500);
ds_campos_w		varchar(500);
ds_alias_pro_w		varchar(60);


BEGIN

ds_tabela_w := null;
ds_restricao_tab_w := null;
ds_campos_w := null;
ds_alias_pro_w := pls_pp_filtro_rec_glosa_pck.obter_alias_tabela('procedimento_original');

-- procedimento

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	ds_restricao_proc_w := ds_restricao_proc_w || '	and ' || ds_alias_pro_w || '.ie_origem_proced = :ie_origem_proced_pc ' || pls_util_pck.enter_w ||
						      '	and ' || ds_alias_pro_w || '.cd_procedimento = :cd_procedimento_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':ie_origem_proced_pc', ie_origem_proced_p, valor_bind_p);
	valor_bind_p := sql_pck.bind_variable(':cd_procedimento_pc', cd_procedimento_p, valor_bind_p);
else
	-- traz o que e necessario da view como tabela (grupo, area, etc..)

	-- feito desta forma por motivos de performance.

	-- em testes realizados na base WHEB essa forma de acesso se mostrou mais eficiente

	ds_tabela_w := ds_tabela_w || ', ' || pls_util_pck.enter_w ||
			'	(select	x.ie_origem_proced, ' || pls_util_pck.enter_w ||
			'		x.cd_procedimento ' || pls_util_pck.enter_w ||
			'	from	estrutura_procedimento_v x ' || pls_util_pck.enter_w ||
			'	where	1 = 1 ' || pls_util_pck.enter_w;
	
	-- grupo proc

	if (cd_grupo_proc_p IS NOT NULL AND cd_grupo_proc_p::text <> '') then
		ds_restricao_tab_w := ds_restricao_tab_w || '	and x.cd_grupo_proc = :cd_grupo_proc_pc ' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':cd_grupo_proc_pc', cd_grupo_proc_p, valor_bind_p);
		
	-- especialidade

	elsif (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
		ds_restricao_tab_w := ds_restricao_tab_w || '	and x.cd_especialidade = :cd_especialidade_pc ' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':cd_especialidade_pc', cd_especialidade_p, valor_bind_p);
		
	-- area proc

	elsif (cd_area_procedimento_p IS NOT NULL AND cd_area_procedimento_p::text <> '') then
		ds_restricao_tab_w := ds_restricao_tab_w || '	and x.cd_area_procedimento = :cd_area_procedimento_pc ' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':cd_area_procedimento_pc', cd_area_procedimento_p, valor_bind_p);
	end if;
	
	-- tipo de despesa

	if (ie_tipo_despesa_proc_p IS NOT NULL AND ie_tipo_despesa_proc_p::text <> '') then
		ds_restricao_proc_w := ds_restricao_proc_w || '	and ' || ds_alias_pro_w || '.ie_tipo_despesa = :ie_tipo_despesa_proc_pc ' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':ie_tipo_despesa_proc_pc', ie_tipo_despesa_proc_p, valor_bind_p);
	end if;
end if;

-- se nao tem nenhum filtro de estrutura para processar limpa o campo tabela

if (coalesce(ds_restricao_tab_w::text, '') = '') then
	ds_tabela_w := null;
else	-- senao alimenta as variaveis que serao necessarias
	-- junta a view (tabela) com a restricao necessarias

	ds_tabela_w := ds_tabela_w || ds_restricao_tab_w || ' ) estru ' || pls_util_pck.enter_w;
	
	-- faz a restricao padrao da tabela

	ds_restricao_proc_w := ds_restricao_proc_w || '	and estru.ie_origem_proced = ' || ds_alias_pro_w || '.ie_origem_proced ' || pls_util_pck.enter_w ||
						'	and estru.cd_procedimento = ' || ds_alias_pro_w || '.cd_procedimento ' || pls_util_pck.enter_w;
end if;

-- alimenta os parametros out

ds_tabela_p := ds_tabela_w;
ds_campos_p := ds_campos_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_filtro_rec_glosa_pck.obter_restricao_procedimento ( ie_origem_proced_p pls_pp_rp_filtro_proc.ie_origem_proced%type, cd_procedimento_p pls_pp_rp_filtro_proc.cd_procedimento%type, cd_grupo_proc_p pls_pp_rp_filtro_proc.cd_grupo_proc%type, cd_especialidade_p pls_pp_rp_filtro_proc.cd_especialidade%type, cd_area_procedimento_p pls_pp_rp_filtro_proc.cd_area_procedimento%type, ie_tipo_despesa_proc_p pls_pp_rp_filtro_proc.ie_tipo_despesa_proc%type, nr_seq_regra_filtro_p pls_pp_cta_combinada.nr_sequencia%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
