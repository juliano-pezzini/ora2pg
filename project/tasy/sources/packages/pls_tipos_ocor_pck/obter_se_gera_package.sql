-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_tipos_ocor_pck.obter_se_gera ( dados_regra_p dados_regra, dados_filtro_p dados_filtro, ie_gera_p text, ie_filtro_validacao_p text) RETURNS PLS_SELECAO_OCOR_CTA.IE_VALIDO%TYPE AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gerenciar a decisao de gerar ou nao a ocorrencia (dizer se um registro e valido ou nao)
	de acordo com a parametrizacao de regras e filtros de excecao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

ie_filtro_validacao_p :

F - Filtros;
FP - Filtro Padrao (Regra que nao utiliza filtros)
V - Validacoes.

Alteracoes:
------------------------------------------------------------------------------------------------------------------

jjung OS 651768 - 10/10/2013	Criacao da function.
------------------------------------------------------------------------------------------------------------------

jjung OS 651768 - 15/10/2013

Alteracao:	Incluido tratamento para o filtro padrao(quando a regra nao utiliza filtros).

Motivo:	Foi identificado que durante o processo de aplicacao de filtros padroes nao  seria possivel
	parametrizar a variavel DADOS_FILTRO_W para verificar a questao da excecao.
------------------------------------------------------------------------------------------------------------------

jjung OS 693338 - 03/02/2014

Alteracao:	Alterado para funcionar corretamente com a nova estrutura da tabela de selecao, com os campos
	IE_EXCECAO.

Motivo:	Foi identificado que o uso dos campos IE_VALIDO nao estava de acordo com a necessidade.
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */



BEGIN

-- Quando a regra for de excecao entao por padrao, se o item for valido para a regra, ele nao sera mais valido para a ocorrencia, portanto sera retornado que

-- este nao e valido para a ocorrencia.

if (dados_regra_p.ie_excecao = 'S') then

	-- Para os filtros deve ser verificado se o filtro e de excecao ou nao.

	if (ie_filtro_validacao_p = 'F') then

		return 'S';

	-- Para quando a regra nao utiliza filtros, o valor do filtro padrao e para sempre ser como valido, porem se a regra for de excecao entao ele deve ser sempre

	-- como nao valido.

	elsif (ie_filtro_validacao_p = 'FP') then

		return 'S';
	else
		return ie_gera_p;
	end if;
-- Se a regra nao for de excecao, entao se o item for valido para a regra quer dizer que ele e valido para a ocorrencia.

else
	-- Quando for filtros deve ser verificado se o filtro e de excecao ou nao.

	if (ie_filtro_validacao_p = 'F') then

		return 'S';

	-- Para quando a regra nao utiliza filtros, o valor do filtro padrao e para sempre ser como valido, entao se a regra nao for uma excecao temos como retorno o valor S

	elsif (ie_filtro_validacao_p = 'FP') then

		return 'S';
	-- Quando for validacao devera ser verificado a decisao do implementador, se os registros selecionados sao os validos para a regra ou se sao os nao validos.

	else
		-- Para esta situacao e exatamente o que foi definido na regra, se forem os validos entao o registro e valido, se nao, se forem os invalidos entao o registro e invalido.

		return ie_gera_p;
	end if;
end if;

return null;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_tipos_ocor_pck.obter_se_gera ( dados_regra_p dados_regra, dados_filtro_p dados_filtro, ie_gera_p text, ie_filtro_validacao_p text) FROM PUBLIC;
