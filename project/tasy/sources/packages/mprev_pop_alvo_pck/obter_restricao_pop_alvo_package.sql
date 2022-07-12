-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OBTER RESTRICOES POPULACAO ALVO<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



CREATE OR REPLACE FUNCTION mprev_pop_alvo_pck.obter_restricao_pop_alvo ( dados_pop_alvo_p mprev_pop_alvo_pck.pop_alvo, nm_tabela_regra_p text) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w	varchar(4000)	:= null;

	
BEGIN

	-- Aqui atribui o valor para a bind :nr_seq_populacao_pc para utilizar no select dentro da procedure obter_restrincao_padrao_pop_alv.

	current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.bind_variable(':nr_seq_populacao_pc', dados_pop_alvo_p.nr_seq_populacao_alvo, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);

	/* --------------------------------------  REGRA POR PESSOA  -------------------------------------- */


	if (nm_tabela_regra_p = 'MPREV_REGRA_CUBO_PESSOA') then
		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_pessoa) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 7);--'MPREV_REGRA_CUBO_PESSOA'

		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_pessoa) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 7);--'MPREV_REGRA_CUBO_PESSOA'
		end if;
	elsif (nm_tabela_regra_p = 'HDM_REGRA_CUBO_COMPL') then
		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_compl_pf) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 6);--'HDM_REGRA_CUBO_COMPL'

		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_compl_pf) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 6);--'HDM_REGRA_CUBO_COMPL'
		end if;	
	elsif (nm_tabela_regra_p = 'MPREV_REGRA_CUBO_BENEF') then
		/* --------------------------------------  REGRA POR BENEFICIARIO  -------------------------------------- */


		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_benef) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 5);--'MPREV_REGRA_CUBO_BENEF'
		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_benef) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 5);--'MPREV_REGRA_CUBO_BENEF'
		end if;
	elsif (nm_tabela_regra_p = 'MPREV_REGRA_CUBO_CUSTO') then
		/* --------------------------------------  REGRA POR CUSTO  -------------------------------------- */


		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_custo) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 4);--'MPREV_REGRA_CUBO_CUSTO'
		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_custo) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 4);--'MPREV_REGRA_CUBO_CUSTO'
		end if;
	elsif (nm_tabela_regra_p = 'MPREV_REGRA_CUBO_ATEND') then
		/* --------------------------------------  REGRA POR ATENDIMENTO  -------------------------------------- */


		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_atend) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 3);--'MPREV_REGRA_CUBO_ATEND'
		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_atend) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 3);--'MPREV_REGRA_CUBO_ATEND'
		end if;
	elsif (nm_tabela_regra_p = 'MPREV_REGRA_CUBO_DIAG') then
		/* --------------------------------------  REGRA POR DIAGNOSTICO  -------------------------------------- */


		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_diag) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 2);--'MPREV_REGRA_CUBO_DIAG'
		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_diag) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 2);--'MPREV_REGRA_CUBO_DIAG'
		end if;
	elsif (nm_tabela_regra_p ='MPREV_REGRA_CUBO_PROC') then
		/* --------------------------------------  REGRA POR PROCEDIMENTO  -------------------------------------- */


		--EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_proc) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('S', 1);--'MPREV_REGRA_CUBO_PROC'
		end if;
		--NOT EXISTS

		if (upper(dados_pop_alvo_p.ie_regra_exc_proc) = 'S') then
			-- Aqui monta a restricao e atualiza o valor das binds.

			ds_retorno_w :=	ds_retorno_w || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type || mprev_pop_alvo_pck.obter_restricao_padrao_pop_alv('N', 1);--'MPREV_REGRA_CUBO_PROC'
		end if;
	end if;

	return	ds_retorno_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION mprev_pop_alvo_pck.obter_restricao_pop_alvo ( dados_pop_alvo_p mprev_pop_alvo_pck.pop_alvo, nm_tabela_regra_p text) FROM PUBLIC;
