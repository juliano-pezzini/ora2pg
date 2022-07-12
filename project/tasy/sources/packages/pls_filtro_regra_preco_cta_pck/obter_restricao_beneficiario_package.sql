-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_beneficiario ( ie_tipo_segurado_p pls_cp_cta_filtro_benef.ie_tipo_segurado%type, nr_seq_regra_atend_cart_p pls_cp_cta_filtro_benef.nr_seq_regra_atend_cart%type, cd_convenio_p pls_cp_cta_filtro_benef.cd_convenio%type, cd_categoria_p pls_cp_cta_filtro_benef.cd_categoria%type, nr_seq_grupo_operadora_p pls_cp_cta_filtro_benef.nr_seq_grupo_operadora%type, nr_seq_congenere_p pls_cp_cta_filtro_benef.nr_seq_congenere%type, qt_idade_inicial_p pls_cp_cta_filtro_benef.qt_idade_inicial%type, qt_idade_final_p pls_cp_cta_filtro_benef.qt_idade_final%type, ie_pcmso_p pls_cp_cta_filtro_benef.ie_pcmso%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_benef_w	varchar(2500);
ds_campos_w		varchar(500);
ds_tabela_w		varchar(200);
ds_alias_w		varchar(10);


BEGIN

ds_campos_w := null;
ds_restricao_benef_w := null;
ds_alias_w := 'seg';

-- tipo beneficiario

if (ie_tipo_segurado_p IS NOT NULL AND ie_tipo_segurado_p::text <> '') then
	
	ds_restricao_benef_w := ds_restricao_benef_w || ' and ' || ds_alias_w || '.ie_tipo_segurado = :ie_tipo_segurado_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_tipo_segurado_pc', ie_tipo_segurado_p, valor_bind_p);
end if;

-- regra de carteirinha

if (nr_seq_regra_atend_cart_p IS NOT NULL AND nr_seq_regra_atend_cart_p::text <> '') then

	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' pls_valida_regra_cart(' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_segurado, :nr_seq_regra_atend_cart_pc) ie_cart_valida ';
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_regra_atend_cart_pc', nr_seq_regra_atend_cart_p, valor_bind_p);
else
	
	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' ''S'' ie_cart_valida ';
end if;

-- outro convenio

if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then

	ds_campos_w := ds_campos_w  || ', ' || pls_util_pck.enter_w ||
			' pls_obter_conv_cat_segurado(' || ds_alias_w || '.nr_sequencia, 1) cd_convenio';
else
	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' null cd_convenio ';
end if;

-- outra categoria

if (cd_categoria_p IS NOT NULL AND cd_categoria_p::text <> '') then
	
	ds_campos_w := ds_campos_w  || ', ' || pls_util_pck.enter_w ||
			' pls_obter_conv_cat_segurado(' || ds_alias_w || '.nr_sequencia, 2) cd_categoria';
else
	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' null cd_categoria ';
end if;

-- grupo operadora

-- verifica se congenere do beneficiario pertence ao grupo

if (nr_seq_grupo_operadora_p IS NOT NULL AND nr_seq_grupo_operadora_p::text <> '') then

	-- retorna o resultado da funcao abaixo em um dos campos para verificar se e valido, para isso e necessorio tambem 

	-- passar a tabela segurado e a restricao com o join na mesma, coloco um espaco na variavel restricao benef para NAO 

	-- cair no null e passar a restricao.

	ds_campos_w := ds_campos_w || ', '|| pls_util_pck.enter_w ||
			' pls_se_grupo_preco_operadora( :nr_seq_grupo_operadora_pc, nvl( ' || ds_alias_w || '.nr_seq_congenere , ' ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('protocolo') || '.nr_seq_congenere)) ie_grupo_valido ';
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_grupo_operadora_pc', nr_seq_grupo_operadora_p, valor_bind_p);
else
	
	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' ''S'' ie_grupo_valido ';
end if;

-- seq cooperativa (congenere do beneficiario)

if (nr_seq_congenere_p IS NOT NULL AND nr_seq_congenere_p::text <> '') then

	ds_restricao_benef_w := ds_restricao_benef_w || ' and ' || ds_alias_w || '.nr_seq_congenere = :nr_seq_congenere_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_congenere_pc', nr_seq_congenere_p, valor_bind_p);
end if;

-- se alguma idade estiver informada e necessorio trazer a informacao para verificar posteriormente

if (qt_idade_inicial_p IS NOT NULL AND qt_idade_inicial_p::text <> '') or (qt_idade_final_p IS NOT NULL AND qt_idade_final_p::text <> '') then

	ds_campos_w := ds_campos_w || ', '|| pls_util_pck.enter_w ||
			' pls_obter_dados_segurado( ' || ds_alias_w || '.nr_sequencia, ''ID'' ) qt_idade_seg ';

-- se nenhuma idade estiver informada retorna nulo pois NAO precisa verificar

else
	ds_campos_w := ds_campos_w || ', '|| pls_util_pck.enter_w ||
			' null qt_idade_seg ';
end if;

-- beneficiario possui PCMSO, somente verifica caso o checkbox esteja checado

if (ie_pcmso_p = 'S') then

	ds_restricao_benef_w := ds_restricao_benef_w || ' and ' || ds_alias_w || '.ie_pcmso = :ie_pcmso_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_pcmso_pc', ie_pcmso_p, valor_bind_p);
end if;

-- monta a ligacao

ds_tabela_w := ds_tabela_w || ', ' || pls_util_pck.enter_w ||
		'	pls_segurado ' || ds_alias_w;
	
ds_restricao_benef_w := ' and ' || ds_alias_w || '.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_segurado ' ||
			pls_util_pck.enter_w || ds_restricao_benef_w;


ds_tabela_p := ds_tabela_w;
ds_campos_p := ds_campos_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_beneficiario ( ie_tipo_segurado_p pls_cp_cta_filtro_benef.ie_tipo_segurado%type, nr_seq_regra_atend_cart_p pls_cp_cta_filtro_benef.nr_seq_regra_atend_cart%type, cd_convenio_p pls_cp_cta_filtro_benef.cd_convenio%type, cd_categoria_p pls_cp_cta_filtro_benef.cd_categoria%type, nr_seq_grupo_operadora_p pls_cp_cta_filtro_benef.nr_seq_grupo_operadora%type, nr_seq_congenere_p pls_cp_cta_filtro_benef.nr_seq_congenere%type, qt_idade_inicial_p pls_cp_cta_filtro_benef.qt_idade_inicial%type, qt_idade_final_p pls_cp_cta_filtro_benef.qt_idade_final%type, ie_pcmso_p pls_cp_cta_filtro_benef.ie_pcmso%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
