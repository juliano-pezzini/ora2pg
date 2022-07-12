-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION mprev_base_cubo_pck.obter_restr_benef ( ie_opcao_p text, ie_pessoa_benef_p text, cursor_p INOUT sql_pck.t_cursor, dados_regra_p mprev_base_cubo_pck.dados_regra_benef, ds_select_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Montar o select para buscar os beneficiarios do cubo conforme regra.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes: 
------------------------------------------------------------------------------------------------------------------

jjung OS 721121 - 31/03/2014 - Criacao da function.
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


valor_bind_w	sql_pck.t_dado_bind;
dados_retorno_w	pls_util_pck.dados_select;


BEGIN

-- Se for para filtrar por formacao de preco adiciona a tabela PLS_PLANO no comando, restringe pela formacao de preco e seleciona esta informacao.

if (dados_regra_p.ie_preco IS NOT NULL AND dados_regra_p.ie_preco::text <> '') then

	-- Aqui verifica se e para montar a restricao ou atualizar o valor das binds.

	if (ie_opcao_p = 'RESTRICAO') then
		
		-- So quando for buscar os beneficiarios vai adicionar campos ao comando.

		if (ie_pessoa_benef_p = 'BENEF') then
		
			dados_retorno_w := pls_util_pck.sql_campo('plano.ie_preco', 'ie_preco', dados_retorno_w, true);
			dados_retorno_w := pls_util_pck.sql_campo('substr(plano.ds_plano, 1, 50)', 'ds_preco_plano', dados_retorno_w, true);
		end if;
		
		dados_retorno_w := pls_util_pck.sql_tabela('pls_plano', 'plano', dados_retorno_w, true);
		dados_retorno_w := pls_util_pck.sql_restricao('and	plano.nr_sequencia = benef.nr_seq_plano ', dados_retorno_w, true);
		dados_retorno_w := pls_util_pck.sql_restricao('and	plano.ie_preco = :ie_preco ', dados_retorno_w, true);
	else
		valor_bind_w := sql_pck.bind_variable(':ie_preco', dados_regra_p.ie_preco, valor_bind_w);
	end if;
-- Se nao, quando for para buscar os beneficiarios adiciona o s campos de formacao e descricao do plano por subselect.

elsif (ie_pessoa_benef_p = 'BENEF') then

	dados_retorno_w := pls_util_pck.sql_campo(	'(select	max(plano.ie_preco) ' || pls_util_pck.enter_w ||
				'from		pls_plano plano ' || pls_util_pck.enter_w ||
				'where		plano.nr_sequencia = benef.nr_seq_plano)', 'ie_preco', dados_retorno_w, true);
				
	dados_retorno_w := pls_util_pck.sql_campo(	'(select	substr(max(plano.ds_plano), 1, 50) ' || pls_util_pck.enter_w ||
				'from		pls_plano plano ' || pls_util_pck.enter_w ||
				'where		plano.nr_sequencia = benef.nr_seq_plano)', 'ds_preco_plano', dados_retorno_w, true);
end if;

-- Se for para filtrar por situacao do contrato adiciona a tabela PLS_CONTRATO no comando, restringe pela situacao e seleciona esta informacao.

if (dados_regra_p.ie_situacao_contrato IS NOT NULL AND dados_regra_p.ie_situacao_contrato::text <> '') then
	
	-- Aqui verifica se e para montar a restricao ou atualizar o valor das binds.

	if (ie_opcao_p = 'RESTRICAO') then
	
		if (ie_pessoa_benef_p = 'BENEF') then
		
			dados_retorno_w := pls_util_pck.sql_campo('contrato.ie_situacao', 'ie_situacao_contrato', dados_retorno_w, true);
		end if;
		
		dados_retorno_w := pls_util_pck.sql_tabela('pls_contrato', 'contrato', dados_retorno_w, true);
		dados_retorno_w := pls_util_pck.sql_restricao('and	contrato.nr_sequencia = benef.nr_seq_contrato ', dados_retorno_w, true);
	
		if (dados_regra_p.ie_situacao_contrato = 'A') then
		
			dados_retorno_w := pls_util_pck.sql_restricao('and	contrato.ie_situacao = :ie_situacao_contrato ', dados_retorno_w, true);
			
		elsif (dados_regra_p.ie_situacao_contrato = 'I') then
		
			dados_retorno_w := pls_util_pck.sql_restricao('and	contrato.ie_situacao <> :ie_situacao_contrato ', dados_retorno_w, true);
		end if;
	else
		valor_bind_w := sql_pck.bind_variable(':ie_situacao_contrato', '2', valor_bind_w);
	end if;

-- Se nao, quando for para buscar os beneficiarios adiciona os campos de situacao do contrato por subselect.

elsif (ie_pessoa_benef_p = 'BENEF') then

	dados_retorno_w := pls_util_pck.sql_campo(	'(select	max(contrato.ie_situacao) ' || pls_util_pck.enter_w ||
				'from		pls_contrato contrato ' || pls_util_pck.enter_w ||
				'where		contrato.nr_sequencia = benef.nr_seq_contrato)', 'ie_situacao_contrato', dados_retorno_w, true);
end if;

-- A situacao de atendimento para o beneficiario e fitlrada em ambos os comandos se tiver informado na regra.

if (dados_regra_p.ie_situacao_atend IS NOT NULL AND dados_regra_p.ie_situacao_atend::text <> '') then
	
	-- Aqui verifica se e para montar a restricao ou atualizar o valor das binds.

	if (ie_opcao_p = 'RESTRICAO') then
	
		if (dados_regra_p.ie_situacao_atend = 'A') then
			
			dados_retorno_w := pls_util_pck.sql_restricao('and	benef.ie_situacao_atend = :ie_situacao_atend ', dados_retorno_w, true);
							
		elsif (dados_regra_p.ie_situacao_atend = 'I') then
		
			dados_retorno_w := pls_util_pck.sql_restricao('and	benef.ie_situacao_atend <> :ie_situacao_atend ', dados_retorno_w, true);
		end if;
	else
		valor_bind_w := sql_pck.bind_variable(':ie_situacao_atend', 'A', valor_bind_w);
	end if;
end if;

-- Quando for para executar o comando entao abre o cursor.

if (ie_opcao_p = 'EXECUTAR') then
	
	valor_bind_w := sql_pck.executa_sql_cursor(ds_select_p, valor_bind_w);
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION mprev_base_cubo_pck.obter_restr_benef ( ie_opcao_p text, ie_pessoa_benef_p text, cursor_p INOUT sql_pck.t_cursor, dados_regra_p mprev_base_cubo_pck.dados_regra_benef, ds_select_p text) FROM PUBLIC;