-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_conta ( ie_atend_pcmso_p pls_cp_cta_filtro_conta.ie_atend_pcmso%type, ie_carater_internacao_p pls_cp_cta_filtro_conta.ie_carater_internacao%type, ie_internado_p pls_cp_cta_filtro_conta.ie_internado%type, ie_origem_conta_p pls_cp_cta_filtro_conta.ie_origem_conta%type, ie_ref_guia_internacao_p pls_cp_cta_filtro_conta.ie_ref_guia_internacao%type, ie_regime_internacao_p pls_cp_cta_filtro_conta.ie_regime_internacao%type, ie_tipo_consulta_p pls_cp_cta_filtro_conta.ie_tipo_consulta%type, ie_tipo_guia_p pls_cp_cta_filtro_conta.ie_tipo_guia%type, nr_seq_categoria_p pls_cp_cta_filtro_conta.nr_seq_categoria%type, nr_seq_cbo_saude_p pls_cp_cta_filtro_conta.nr_seq_cbo_saude%type, nr_seq_clinica_p pls_cp_cta_filtro_conta.nr_seq_clinica%type, nr_seq_grupo_doenca_p pls_cp_cta_filtro_conta.nr_seq_grupo_doenca%type, nr_seq_tipo_acomodacao_p pls_cp_cta_filtro_conta.nr_seq_tipo_acomodacao%type, nr_seq_tipo_atendimento_p pls_cp_cta_filtro_conta.nr_seq_tipo_atendimento%type, qt_dias_inter_final_p pls_cp_cta_filtro_conta.qt_dias_inter_final%type, qt_dias_inter_inicio_p pls_cp_cta_filtro_conta.qt_dias_inter_inicio%type, nr_seq_tipo_atend_princ_p pls_cp_cta_filtro_conta.nr_seq_tipo_atend_princ%type, ie_acomodacao_autorizada_p pls_cp_cta_filtro_conta.ie_acomodacao_autorizada%type, ie_regime_atendimento_p pls_cp_cta_filtro_conta.ie_regime_atendimento%type, ie_regime_atendimento_princ_p pls_cp_cta_filtro_conta.ie_regime_atendimento_princ%type, ie_saude_ocupacional_p pls_cp_cta_filtro_conta.ie_saude_ocupacional%type, valor_bind_p INOUT sql_pck.t_dado_bind, ds_campos_p out text) AS $body$
DECLARE

				
dados_restricao_w	varchar(2000);
ds_campos_w		varchar(500);


BEGIN
-- Inicializar o retorno

dados_restricao_w := null;
ds_campos_w := null;

-- Atendimento PCMSO 

-- so verifica caso NAO seja nulo e seja diferente de Ambos

if (ie_atend_pcmso_p != 'A') then
	
	dados_restricao_w := dados_restricao_w || ' and exists ( select 1 ' || pls_util_pck.enter_w ||
					  '		from	pls_segurado seg ' || pls_util_pck.enter_w ||
					  '		where 	seg.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_segurado ' || pls_util_pck.enter_w ||
					  '		and 	seg.ie_pcmso = :ie_atend_pcmso_pc ) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_atend_pcmso_pc', ie_atend_pcmso_p, valor_bind_p);
end if;

-- Carater internacao

if (ie_carater_internacao_p IS NOT NULL AND ie_carater_internacao_p::text <> '') then
	
	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_carater_internacao, ' || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('protocolo') || '.cd_versao_tiss ';
else

	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||	
			'null ie_carater_internacao, ' || pls_util_pck.enter_w ||
			'null cd_versao_tiss ';
end if;

-- Internado, somente e verificado caso o checkbox esteja checado

if (ie_internado_p = 'S') then
	
	ds_campos_w := 	ds_campos_w || ', ' || pls_util_pck.enter_w ||
			' pls_obter_se_internado( ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_sequencia, null, ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') ||
			'.ie_tipo_guia,' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') ||'.nr_seq_tipo_atendimento, null, ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') ||
			'.cd_estabelecimento, ''N'') ie_internado ';
			
else
	ds_campos_w := ds_campos_w || ', ' || pls_util_pck.enter_w ||
	'null ie_internado ';
end if;

-- Origem conta

if (ie_origem_conta_p IS NOT NULL AND ie_origem_conta_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_origem_conta = :ie_origem_conta_pc'||
				pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_origem_conta_pc', ie_origem_conta_p, valor_bind_p);
end if;

-- Guia referencia de internacao (guia principal)

-- ambos NAO precisa verificar, qualquer outra coisa busca no campo para verificar depois

if (ie_ref_guia_internacao_p != 'A') then
	
	ds_campos_w := ds_campos_w || ', '  || pls_util_pck.enter_w ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_vinc_internacao ie_ref_guia_internacao ';
else	

	ds_campos_w := ds_campos_w || ', ' || pls_util_pck.enter_w ||
	'null ie_ref_guia_internacao ';
end if;

-- Regime de internacao

if (ie_regime_internacao_p IS NOT NULL AND ie_regime_internacao_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_regime_internacao = :ie_regime_internacao_pc'||
				pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_regime_internacao_pc', ie_regime_internacao_p, valor_bind_p);
end if;

-- Tipo consulta

if (ie_tipo_consulta_p IS NOT NULL AND ie_tipo_consulta_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_tipo_consulta = :ie_tipo_consulta_pc'|| pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_tipo_consulta_pc', ie_tipo_consulta_p, valor_bind_p);
end if;

-- Tipo guia

if (ie_tipo_guia_p IS NOT NULL AND ie_tipo_guia_p::text <> '') then

	dados_restricao_w := dados_restricao_w || ' and	' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_tipo_guia = :ie_tipo_guia_pc'|| pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_tipo_guia_pc', ie_tipo_guia_p, valor_bind_p);
end if;

-- Categoria acomodacao

if (nr_seq_categoria_p IS NOT NULL AND nr_seq_categoria_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and exists( select 1 ' || pls_util_pck.enter_w ||
						  '		from 	pls_regra_categoria x ' || pls_util_pck.enter_w ||
						  '		where 	x.nr_seq_tipo_acomodacao = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_tipo_acomodacao ' || pls_util_pck.enter_w ||
						  '		and 	x.nr_seq_categoria = :nr_seq_categoria_pc) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_categoria_pc', nr_seq_categoria_p, valor_bind_p);
end if;

-- CBO saude

if (nr_seq_cbo_saude_p IS NOT NULL AND nr_seq_cbo_saude_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_cbo_saude = :nr_seq_cbo_saude_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_cbo_saude_pc', nr_seq_cbo_saude_p, valor_bind_p);
end if;

-- Tipo internacao

if (nr_seq_clinica_p IS NOT NULL AND nr_seq_clinica_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_clinica = :nr_seq_clinica_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_clinica_pc', nr_seq_clinica_p, valor_bind_p);
end if;

-- Grupo CID

if (nr_seq_grupo_doenca_p IS NOT NULL AND nr_seq_grupo_doenca_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and exists( select 1 ' || pls_util_pck.enter_w ||
						  ' 		from 	pls_diagnostico_conta 	diag, ' || pls_util_pck.enter_w ||
						  '			pls_preco_doenca	grupo ' || pls_util_pck.enter_w ||
						  '		where	diag.nr_seq_conta = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_sequencia' || pls_util_pck.enter_w ||
						  '		and	diag.cd_doenca = grupo.cd_doenca_cid ' || pls_util_pck.enter_w ||
						  '		and 	grupo.nr_seq_grupo = :nr_seq_grupo_doenca_pc )' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_grupo_doenca_pc', nr_seq_grupo_doenca_p, valor_bind_p);
end if;

-- Tipo acomodacao

if (nr_seq_tipo_acomodacao_p IS NOT NULL AND nr_seq_tipo_acomodacao_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_tipo_acomodacao = :nr_seq_tipo_acomodacao_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_tipo_acomodacao_pc', nr_seq_tipo_acomodacao_p, valor_bind_p);
end if;

-- Tipo atendimento

if (nr_seq_tipo_atendimento_p IS NOT NULL AND nr_seq_tipo_atendimento_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_tipo_atendimento = :nr_seq_tipo_atendimento_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_tipo_atendimento_pc', nr_seq_tipo_atendimento_p, valor_bind_p);
end if;

-- Regime atendimento

if (ie_regime_atendimento_p IS NOT NULL AND ie_regime_atendimento_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_regime_atendimento = :ie_regime_atendimento_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_regime_atendimento_pc', ie_regime_atendimento_p, valor_bind_p);
end if;

-- Saude ocupacional

if (ie_saude_ocupacional_p IS NOT NULL AND ie_saude_ocupacional_p::text <> '') then
	
	dados_restricao_w := dados_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.ie_saude_ocupacional = :ie_saude_ocupacional_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_saude_ocupacional_pc', ie_saude_ocupacional_p, valor_bind_p);
end if;

-- Quantidade de dias de internacao inicial/final

-- se qualquer um dos dois for nulo busca a quantidade de dias de internacao para verificar

if (qt_dias_inter_inicio_p IS NOT NULL AND qt_dias_inter_inicio_p::text <> '') or (qt_dias_inter_final_p IS NOT NULL AND qt_dias_inter_final_p::text <> '') then
	
	ds_campos_w := ds_campos_w || ', '|| pls_util_pck.enter_w ||
			'trunc(nvl( ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.dt_alta, ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.dt_emissao) - ' ||
			pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') ||'.dt_entrada) qt_dias_internacao ';
else

	ds_campos_w := ds_campos_w || ', '|| pls_util_pck.enter_w ||
			' null qt_dias_internacao ';
end if;

-- tipo de atendimento da conta principal

if (nr_seq_tipo_atend_princ_p IS NOT NULL AND nr_seq_tipo_atend_princ_p::text <> '') then

	dados_restricao_w := dados_restricao_w || ' and exists( select	1 ' || pls_util_pck.enter_w ||
						  ' 		from 	pls_conta x ' || pls_util_pck.enter_w ||
						  '		where	x.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_conta_princ ' || pls_util_pck.enter_w ||
						  '		and	x.nr_seq_tipo_atendimento = :nr_seq_tipo_atend_princ_pc ) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_tipo_atend_princ_pc', nr_seq_tipo_atend_princ_p, valor_bind_p);
end if;

-- regime de atendimento da conta principal

if (ie_regime_atendimento_princ_p IS NOT NULL AND ie_regime_atendimento_princ_p::text <> '') then

	dados_restricao_w := dados_restricao_w || ' and exists( select	1 ' || pls_util_pck.enter_w ||
						  ' 		from 	pls_conta x ' || pls_util_pck.enter_w ||
						  '		where	x.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_conta_princ ' || pls_util_pck.enter_w ||
						  '		and	x.ie_regime_atendimento = :ie_regime_atendimento_princ_pc ) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_regime_atendimento_princ_pc', ie_regime_atendimento_princ_p, valor_bind_p);
end if;

-- Padrao acomodacao autorizada, verifica se for diferente de Nenhum

if (ie_acomodacao_autorizada_p != 'N') then

	dados_restricao_w := dados_restricao_w || ' and exists( select	1 ' || pls_util_pck.enter_w ||
						  ' 		from 	pls_tipo_acomodacao x ' || pls_util_pck.enter_w ||
						  '		where	x.nr_sequencia = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_tipo_acomodacao ' || pls_util_pck.enter_w ||
						  '		and	x.ie_tipo_acomodacao = :ie_acomodacao_autorizada_pc ) ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':ie_acomodacao_autorizada_pc', ie_acomodacao_autorizada_p, valor_bind_p);
end if;

ds_campos_p := ds_campos_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_conta ( ie_atend_pcmso_p pls_cp_cta_filtro_conta.ie_atend_pcmso%type, ie_carater_internacao_p pls_cp_cta_filtro_conta.ie_carater_internacao%type, ie_internado_p pls_cp_cta_filtro_conta.ie_internado%type, ie_origem_conta_p pls_cp_cta_filtro_conta.ie_origem_conta%type, ie_ref_guia_internacao_p pls_cp_cta_filtro_conta.ie_ref_guia_internacao%type, ie_regime_internacao_p pls_cp_cta_filtro_conta.ie_regime_internacao%type, ie_tipo_consulta_p pls_cp_cta_filtro_conta.ie_tipo_consulta%type, ie_tipo_guia_p pls_cp_cta_filtro_conta.ie_tipo_guia%type, nr_seq_categoria_p pls_cp_cta_filtro_conta.nr_seq_categoria%type, nr_seq_cbo_saude_p pls_cp_cta_filtro_conta.nr_seq_cbo_saude%type, nr_seq_clinica_p pls_cp_cta_filtro_conta.nr_seq_clinica%type, nr_seq_grupo_doenca_p pls_cp_cta_filtro_conta.nr_seq_grupo_doenca%type, nr_seq_tipo_acomodacao_p pls_cp_cta_filtro_conta.nr_seq_tipo_acomodacao%type, nr_seq_tipo_atendimento_p pls_cp_cta_filtro_conta.nr_seq_tipo_atendimento%type, qt_dias_inter_final_p pls_cp_cta_filtro_conta.qt_dias_inter_final%type, qt_dias_inter_inicio_p pls_cp_cta_filtro_conta.qt_dias_inter_inicio%type, nr_seq_tipo_atend_princ_p pls_cp_cta_filtro_conta.nr_seq_tipo_atend_princ%type, ie_acomodacao_autorizada_p pls_cp_cta_filtro_conta.ie_acomodacao_autorizada%type, ie_regime_atendimento_p pls_cp_cta_filtro_conta.ie_regime_atendimento%type, ie_regime_atendimento_princ_p pls_cp_cta_filtro_conta.ie_regime_atendimento_princ%type, ie_saude_ocupacional_p pls_cp_cta_filtro_conta.ie_saude_ocupacional%type, valor_bind_p INOUT sql_pck.t_dado_bind, ds_campos_p out text) FROM PUBLIC;