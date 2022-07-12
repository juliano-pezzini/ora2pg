-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ocor_imp_pck.prepara_reg_proces_filtro ( nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, ie_filtro_excecao_p pls_oc_cta_filtro.ie_excecao%type, ie_incidencia_selecao_filtro_p text) AS $body$
BEGIN
-- Faz os devidos tratamentos preparando os registros da tabela de seleaao para

-- serem processados pelos filtros


-- se for regra ou filtro de exceaao a necessario fazer uma preparaaao nos registros que serao selecionados

if (ie_regra_excecao_p = 'S' or ie_filtro_excecao_p = 'S') then

	-- regras de exceaao com filtros de exceaao buscam todos os registros que foram invalidados e foram envolvidos em um processamento de exceaao.

	-- em resumo, tudo o que foi invalidado por uma exceaao

	-- no final do processamento dos filtros todos os registros invalidos sao eliminados

	if (ie_regra_excecao_p = 'S' and ie_filtro_excecao_p = 'S') then
	
		-- se for filtro de procedimento ou material

		if (ie_incidencia_selecao_filtro_p in ('P', 'M')) then
		
			update	pls_oc_cta_selecao_imp
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'N'
			and	ie_marcado_excecao = 'S'
			and 	ie_tipo_registro = ie_incidencia_selecao_filtro_p;
			commit;
			
		else
			update	pls_oc_cta_selecao_imp
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'N'
			and	ie_marcado_excecao = 'S';
			commit;
		end if;
		
	else
		-- se for filtro de procedimento ou material

		if (ie_incidencia_selecao_filtro_p in ('P', 'M')) then
		
			update	pls_oc_cta_selecao_imp
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'S'
			and 	ie_tipo_registro = ie_incidencia_selecao_filtro_p;
			commit;
		
		else
			update	pls_oc_cta_selecao_imp
			set	ie_excecao = 'S',
				ie_marcado_excecao = 'S'
			where	nr_id_transacao = nr_id_transacao_p
			and	ie_valido = 'S';
			commit;
		end if;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ocor_imp_pck.prepara_reg_proces_filtro ( nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, ie_filtro_excecao_p pls_oc_cta_filtro.ie_excecao%type, ie_incidencia_selecao_filtro_p text) FROM PUBLIC;
