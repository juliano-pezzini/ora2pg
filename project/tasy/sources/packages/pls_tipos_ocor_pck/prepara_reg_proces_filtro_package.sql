-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.prepara_reg_proces_filtro ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Faz os devidos tratamentos preparando os registros da tabela de selecao para
	serem processados pelos filtros
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN
-- se for regra ou filtro de excecao e necessario fazer uma preparacao nos registros que serao selecionados

if (dados_regra_p.ie_excecao = 'S' or dados_filtro_p.ie_excecao = 'S') then

	-- regras de excecao com filtros de excecao buscam todos os registros que foram invalidados e foram envolvidos em um processamento de excecao.

	-- em resumo, tudo o que foi invalidado por uma excecao

	-- no final do processamento dos filtros todos os registros invalidos sao eliminados

	if (dados_regra_p.ie_excecao = 'S' and dados_filtro_p.ie_excecao = 'S') then

		-- se for filtro de procedimento ou material

		if (dados_filtro_p.ie_incidencia_selecao in ('P', 'M')) then

			update	pls_selecao_ocor_cta
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'N'
			and	ie_marcado_excecao = 'S'
			and 	ie_tipo_registro = dados_filtro_p.ie_incidencia_selecao;
		else

			update	pls_selecao_ocor_cta
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'N'
			and	ie_marcado_excecao = 'S';
		end if;
	else
		-- se for filtro de procedimento ou material

		if (dados_filtro_p.ie_incidencia_selecao in ('P', 'M')) then

			update	pls_selecao_ocor_cta
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'S'
			and 	ie_tipo_registro = dados_filtro_p.ie_incidencia_selecao;
		else

			update	pls_selecao_ocor_cta
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'S';
		end if;
	end if;

	
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.prepara_reg_proces_filtro ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro) FROM PUBLIC;