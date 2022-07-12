-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ocor_imp_pck.obter_restricao_padrao_filtro ( ie_considera_selecao_p boolean, ie_incidencia_selecao_p text, ie_tipo_tabela_select_p text, ie_processo_excecao_p text, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_filtro_p pls_oc_cta_filtro.nr_sequencia%type, ie_incidencia_filtro_p text, nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, valor_bind_p INOUT sql_pck.t_dado_bind, ds_campo_p INOUT text, ds_tabela_p INOUT text) AS $body$
DECLARE


_ora2pg_r RECORD;
dados_restricao_w	varchar(1000);
ds_alias_protocolo_w	varchar(10);
ds_alias_conta_w	varchar(10);
ds_alias_proc_w		varchar(10);
ds_alias_mat_w		varchar(10);


BEGIN
-- Retornar as restriaaes padrao que serao aplicadas durante o processamentos dos

-- filtros. Essa rotina a utilizada em todas as procedures dos filtros, inclusive na que trata os

-- filtros padraes.


-- Inicializar o retorno

dados_restricao_w := null;

-- Verificaaaes dos parametros, caso tenha valor informado sera adicionado a restriaao para o mesmo.

-- Sempre esta verificaaao por primeiro.

if (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '') then

	ds_alias_protocolo_w := pls_ocor_imp_pck.obter_alias_tabela('pls_protocolo_conta_imp');
	ds_alias_conta_w := pls_ocor_imp_pck.obter_alias_tabela('pls_conta_imp');
	ds_alias_proc_w := pls_ocor_imp_pck.obter_alias_tabela('pls_conta_proc_imp');
	ds_alias_mat_w := pls_ocor_imp_pck.obter_alias_tabela('pls_conta_mat_imp');

	-- Verifica a data de inacio e fim de vigancia

	-- se ambas forem informadas faz um between, senao testa pelo maior ou menor logo abaixo no else

	if (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '' AND dt_fim_vigencia_p IS NOT NULL AND dt_fim_vigencia_p::text <> '') then
		
		-- A data de atendimento da conta deve ser maior ou igual a data de inacio de vigancia da regra

		dados_restricao_w := 	dados_restricao_w || pls_util_pck.enter_w ||
					'and	' || ds_alias_conta_w || '.dt_atendimento_conv between :dt_inicio_vigencia ' ||
					'and fim_dia(:dt_fim_vigencia) ';
		valor_bind_p := sql_pck.bind_variable(	':dt_inicio_vigencia', dt_inicio_vigencia_p, valor_bind_p);
		valor_bind_p := sql_pck.bind_variable(	':dt_fim_vigencia', dt_fim_vigencia_p, valor_bind_p);
	
	elsif (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') then
		-- A data de atendimento da conta deve ser maior ou igual a data de inacio de vigancia da regra

		dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
					'and	' || ds_alias_conta_w || '.dt_atendimento_conv >= :dt_inicio_vigencia ';
		valor_bind_p := sql_pck.bind_variable(	':dt_inicio_vigencia', dt_inicio_vigencia_p, valor_bind_p);
		
	elsif (dt_fim_vigencia_p IS NOT NULL AND dt_fim_vigencia_p::text <> '') then
		-- A data de atendimento da conta deve ser maior ou igual a data de inacio de vigancia da regra

		dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
					'and	' || ds_alias_conta_w || '.dt_atendimento_conta <= fim_dia(:dt_fim_vigencia) ';
		valor_bind_p := sql_pck.bind_variable(	':dt_fim_vigencia', dt_fim_vigencia_p, valor_bind_p);
	end if;
	
	-- se nao for para considerar a seleaao, aplica os filtros padraes

	-- caso contrario, restringe somente pelo que ja esta informado na tabela de seleaao

	if (ie_considera_selecao_p = false) then
	
		-- Se for para filtrar por estabelecimento sera verificado o estabelecimento do protocolo apenas.

		if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
			dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
						'and 	' || ds_alias_protocolo_w || '.cd_estabelecimento = :cd_estabelecimento';
			valor_bind_p := sql_pck.bind_variable(	':cd_estabelecimento', cd_estabelecimento_p, valor_bind_p);
		end if;
		
		-- Se houver namero do lote informado buscar os protocolos do lote.

		if (nr_seq_lote_protocolo_p IS NOT NULL AND nr_seq_lote_protocolo_p::text <> '') then
			dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_protocolo_w || '.nr_seq_lote_protocolo = :nr_seq_lote_protocolo';
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_lote_protocolo', nr_seq_lote_protocolo_p, valor_bind_p);
		end if;

		-- Se houver protocolo informado buscar apenas aquele protocolo.

		if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
			dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_protocolo_w || '.nr_sequencia = :nr_seq_protocolo';
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_protocolo', nr_seq_protocolo_p, valor_bind_p);
		end if;
		
		-- Se houver conta informada sa ira consistir a conta e seus itens.

		if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
			dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_conta_w || '.nr_sequencia = :nr_seq_conta';
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_conta', nr_seq_conta_p, valor_bind_p);
		end if;
		
		-- Se for informado o procedimento entao ira consistir somente aquele procedimento. Comum nos itens da analise durante a execuaao de aaaes como aceite ou ajuste de valores.

		if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
			-- se for incidancia de procedimento, filtra direto, senao faz um exists (caso seja incidancia por conta ou por material)

			-- nao considera quando se trabalha somente com materiais

			if	((ie_incidencia_selecao_p in ('P', 'PM')) and (ie_tipo_tabela_select_p != 'MAT')) then
				dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_proc_w || '.nr_sequencia = :nr_seq_conta_proc';
			else
				dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
							'and	exists (select	1 ' || pls_util_pck.enter_w || 
							'		from	pls_conta_proc_imp procx ' || pls_util_pck.enter_w || 
							'		where	procx.nr_seq_conta = ' || ds_alias_conta_w || '.nr_seq_conta' || pls_util_pck.enter_w || 
							'		and	procx.nr_sequencia = :nr_seq_conta_proc)';
			end if;
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_conta_proc', nr_seq_conta_proc_p, valor_bind_p);
		end if;
		
		-- Se for informado o material entao ira consistir somente aquele material. Comum nos itens da analise durante a execuaao de aaaes como aceite ou ajuste de valores.

		if (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
			-- se for incidancia de material, filtra direto, senao faz um exists (caso seja incidancia por conta ou por procedimento)

			-- nao considera quando se trabalha somente com procedimentos

			if	((ie_incidencia_selecao_p in ('M', 'PM')) and (ie_tipo_tabela_select_p != 'PROC')) then
				dados_restricao_w := 	dados_restricao_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_mat_w || '.nr_sequencia = :nr_seq_conta_mat';
			else
				dados_restricao_w := 	dados_restricao_w || pls_util_pck.enter_w ||
							'and	exists (select	1 ' || pls_util_pck.enter_w || 
							'		from	pls_conta_mat_imp matx ' || pls_util_pck.enter_w || 
							'		where	matx.nr_seq_conta = ' || ds_alias_conta_w || '.nr_seq_conta' || pls_util_pck.enter_w || 
							'		and	matx.nr_sequencia = :nr_seq_conta_mat)';
			end if;
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_conta_mat', nr_seq_conta_mat_p, valor_bind_p);
		end if;
		
		-- Liberaaao de Ocorrancias X Guia XML

		-- Sempre que for importaaao do XML deve ser verificado se nao existe liberaaao para ocorrancia para a guia.

		dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
					'and	not exists(	select	1' || pls_util_pck.enter_w ||
					'			from	pls_guia_lib_ocor_web lib_guia' || pls_util_pck.enter_w ||
					'			where	lib_guia.nr_seq_guia = ' || ds_alias_conta_w || '.nr_seq_guia_conv' || pls_util_pck.enter_w ||
					'			and	lib_guia.nr_seq_ocorrencia = :nr_seq_ocorrencia' || pls_util_pck.enter_w ||
					'			and	lib_guia.dt_inicio_vigencia <= sysdate' || pls_util_pck.enter_w ||
					'			and	lib_guia.dt_fim_vigencia is null' || pls_util_pck.enter_w ||
					'			union all' || pls_util_pck.enter_w ||
					'			select	1' || pls_util_pck.enter_w ||
					'			from	pls_guia_lib_ocor_web lib_guia' || pls_util_pck.enter_w ||
					'			where	lib_guia.nr_seq_guia = ' || ds_alias_conta_w || '.nr_seq_guia_conv' || pls_util_pck.enter_w ||
					'			and	lib_guia.nr_seq_ocorrencia = :nr_seq_ocorrencia' || pls_util_pck.enter_w ||
					'			and	lib_guia.dt_inicio_vigencia <= sysdate' || pls_util_pck.enter_w ||
					'			and	lib_guia.dt_fim_vigencia >= sysdate' || pls_util_pck.enter_w ||
					'		   )';
		valor_bind_p := sql_pck.bind_variable(	':nr_seq_ocorrencia', nr_seq_ocorrencia_p, valor_bind_p);
	end if;
	
	-- obtam as restriaaes relacionadas a tabela de seleaao

	dados_restricao_w :=	dados_restricao_w || pls_util_pck.enter_w ||
				SELECT * FROM pls_ocor_imp_pck.obter_restricao_reg_selecao(	ie_considera_selecao_p, ie_tipo_tabela_select_p, nr_id_transacao_p, nr_seq_filtro_p, ie_incidencia_filtro_p, ie_processo_excecao_p, ie_incidencia_selecao_p, valor_bind_p, ds_campo_p, ds_tabela_p) INTO STRICT _ora2pg_r;
 valor_bind_p := _ora2pg_r.valor_bind_p; ds_campo_p := _ora2pg_r.ds_campo_p; ds_tabela_p := _ora2pg_r.ds_tabela_p;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ocor_imp_pck.obter_restricao_padrao_filtro ( ie_considera_selecao_p boolean, ie_incidencia_selecao_p text, ie_tipo_tabela_select_p text, ie_processo_excecao_p text, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_filtro_p pls_oc_cta_filtro.nr_sequencia%type, ie_incidencia_filtro_p text, nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, valor_bind_p INOUT sql_pck.t_dado_bind, ds_campo_p INOUT text, ds_tabela_p INOUT text) FROM PUBLIC;
