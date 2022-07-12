-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_tipos_ocor_pck.obter_restricao_profissional ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_filtro_prof_p pls_tipos_ocor_pck.dados_filtro_prof, ie_tipo_tabela_p text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Monta as restricoes e binds dos campos de filtro de profissional
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


dados_restricao_w	pls_tipos_ocor_pck.dados_select;
ds_alias_w		varchar(5);
ds_alias_partic_w	varchar(5);
ds_select_prof_w	varchar(1000);
ds_filtro_prof_w	varchar(3000);


BEGIN

-- Inicializar o retorno

dados_restricao_w.ds_campos	:= null;
dados_restricao_w.ds_tabelas	:= null;
dados_restricao_w.ds_restricao	:= null;
ds_select_prof_w := null;
ds_filtro_prof_w := null;
ds_alias_partic_w := 'pt';

-- E obrigatorio saber qual sera o medico a ser verificado, caso nao for informado nao sera aplicada a restricao.

if (dados_filtro_prof_p.ie_medico IS NOT NULL AND dados_filtro_prof_p.ie_medico::text <> '') then

	-- obtem o alias da tabela

	ds_alias_w := pls_tipos_ocor_pck.obter_alias_tab(	dados_filtro_p.ie_processo_excecao, dados_regra_p.ie_incidencia_selecao,
					dados_filtro_p.ie_incidencia_selecao, ie_tipo_tabela_p);

	-- Aqui e verificado qual o profissional da conta que sera usado para verificacao dos dados do filtro.

	-- Solicitante

	if (dados_filtro_prof_p.ie_medico = 'S') then
		-- Codigo do medico

		if (dados_filtro_prof_p.cd_medico IS NOT NULL AND dados_filtro_prof_p.cd_medico::text <> '') then
			-- Se for durante a importacao

			if (dados_regra_p.ie_evento = 'IMP') then

				ds_filtro_prof_w := 	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_w || '.cd_medico_solicitante_imp = :cd_medico';
			else
				ds_filtro_prof_w := 	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_w || '.cd_medico_solicitante = :cd_medico';
			end if;

			valor_bind_p := sql_pck.bind_variable(	':cd_medico', dados_filtro_prof_p.cd_medico, valor_bind_p);
		end if;

		-- Conselho do profissional

		if (dados_filtro_prof_p.nr_seq_conselho IS NOT NULL AND dados_filtro_prof_p.nr_seq_conselho::text <> '') then
			ds_filtro_prof_w := 	ds_filtro_prof_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_w || '.nr_seq_conselho_solic = :nr_seq_conselho ';

			valor_bind_p := sql_pck.bind_variable(	':nr_seq_conselho', dados_filtro_prof_p.nr_seq_conselho, valor_bind_p);
		end if;

		-- Tipo de medico ( Cooperado ou Nao cooperado) se for nulo ou for A(Ambos)  nao adiciona a restricao

		if (dados_filtro_prof_p.ie_medico_cooperado <> 'A') then

			-- Se for durante a importacao

			if (dados_regra_p.ie_evento = 'IMP') then
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	pls_obter_se_cooperado_ativo(' || ds_alias_w || '.cd_medico_solicitante_imp, ' ||
							ds_alias_w || '.dt_atendimento_conta, null ) = :ie_medico_cooperado ';
			else
				ds_filtro_prof_w := 	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	pls_obter_se_cooperado_ativo(' || ds_alias_w || '.cd_medico_solicitante, ' ||
							ds_alias_w || '.dt_atendimento_conta, null ) = :ie_medico_cooperado ';
			end if;
			-- atribui os binds de acordo com as condicoes

			if (dados_filtro_prof_p.ie_medico_cooperado = 'C') then
				valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'S', valor_bind_p);
			elsif (dados_filtro_prof_p.ie_medico_cooperado = 'N') then
				valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'N', valor_bind_p);
			end if;
		end if;
		
		if (dados_filtro_prof_p.nr_seq_cbo_saude IS NOT NULL AND dados_filtro_prof_p.nr_seq_cbo_saude::text <> '') then
			
			ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_w || '.nr_seq_cbo_saude_solic = :nr_seq_cbo_saude_solic ';
						
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_cbo_saude_solic', dados_filtro_prof_p.nr_seq_cbo_saude, valor_bind_p);
		end if;
	-- Executor

	elsif (dados_filtro_prof_p.ie_medico = 'E') then

		-- Codigo do medico

		if (dados_filtro_prof_p.cd_medico IS NOT NULL AND dados_filtro_prof_p.cd_medico::text <> '') then
			-- Se for durante a importacao

			if (dados_regra_p.ie_evento = 'IMP') then

				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_w || '.cd_medico_executor_imp = :cd_medico';
			else
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_w || '.cd_medico_executor = :cd_medico';
			end if;

			valor_bind_p := sql_pck.bind_variable(	':cd_medico', dados_filtro_prof_p.cd_medico, valor_bind_p);
		end if;

		-- Grau de participacao

		if (dados_filtro_prof_p.nr_seq_grau_partic IS NOT NULL AND dados_filtro_prof_p.nr_seq_grau_partic::text <> '') then
			ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_w || '.nr_seq_grau_partic_conta = :nr_seq_grau_partic';

			valor_bind_p := sql_pck.bind_variable(	':nr_seq_grau_partic', dados_filtro_prof_p.nr_seq_grau_partic, valor_bind_p);
		end if;

		-- Conselho do profissional

		if (dados_filtro_prof_p.nr_seq_conselho IS NOT NULL AND dados_filtro_prof_p.nr_seq_conselho::text <> '') then
			ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_w || '.nr_seq_conselho_exec = :nr_seq_conselho ';

			valor_bind_p := sql_pck.bind_variable(	':nr_seq_conselho', dados_filtro_prof_p.nr_seq_conselho, valor_bind_p);
		end if;

		-- Tipo de medico ( Cooperado ou Nao cooperado) se for nulo ou for A(Ambos)  nao adiciona a restricao

		if (dados_filtro_prof_p.ie_medico_cooperado <> 'A') then

			-- Se for durante a importacao

			if (dados_regra_p.ie_evento = 'IMP') then
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	pls_obter_se_cooperado_ativo(' || ds_alias_w || '.cd_medico_executor_imp, ' ||
							ds_alias_w || '.dt_atendimento_conta, null ) = :ie_medico_cooperado ';
			else
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	pls_obter_se_cooperado_ativo(' || ds_alias_w || '.cd_medico_executor, ' ||
							ds_alias_w || '.dt_atendimento_conta, null ) = :ie_medico_cooperado ';
			end if;
			-- faz a atribuicao de valor da bind de acordo com a situacao

			if (dados_filtro_prof_p.ie_medico_cooperado = 'C') then
				valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'S', valor_bind_p);

			elsif (dados_filtro_prof_p.ie_medico_cooperado = 'N') then
				valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'N', valor_bind_p);
			end if;
		end if;
		
		if (dados_filtro_prof_p.nr_seq_cbo_saude IS NOT NULL AND dados_filtro_prof_p.nr_seq_cbo_saude::text <> '') then
			
			ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_w || '.nr_seq_cbo_saude = :nr_seq_cbo_saude ';
						
			valor_bind_p := sql_pck.bind_variable(	':nr_seq_cbo_saude', dados_filtro_prof_p.nr_seq_cbo_saude, valor_bind_p);
		end if;
	-- Participante

	-- Se for a incidencia da regra pela conta sera verificado todos os procedimentos da conta, se for por procedimento sera olhado para os participantes dos procedimentos em especifico apenas. Se for por material nao faz nada.

	elsif (dados_filtro_prof_p.ie_medico = 'P') then

		if (dados_filtro_p.ie_incidencia_selecao = 'C') and
			((coalesce(dados_regra_p.ie_incidencia_selecao,'C') != 'P') or (current_setting('pls_tipos_ocor_pck.ie_controle_todo_atendimento_w')::varchar(1) = 'S')) then

			-- Montar o subselect que verificara os dados dos participantes dos procedimentos da conta. Apos e adicionado as restricoes dos participantes conforme cadastro do filtro

			ds_select_prof_w :=	ds_select_prof_w || pls_util_pck.enter_w ||
						'and	exists ( '|| pls_util_pck.enter_w ||
						'		select	1 '|| pls_util_pck.enter_w ||
						'		from	pls_proc_participante_v ' || ds_alias_partic_w || pls_util_pck.enter_w ||
						'		where	' || ds_alias_partic_w || '.nr_seq_conta_proc in ( '|| pls_util_pck.enter_w ||
						'						select	y.nr_sequencia '|| pls_util_pck.enter_w ||
						'						from	pls_conta_proc y '|| pls_util_pck.enter_w ||
						'						where	y.nr_seq_conta = ' || ds_alias_w || '.nr_seq_conta) ';

			-- Codigo do medico

			if (dados_filtro_prof_p.cd_medico IS NOT NULL AND dados_filtro_prof_p.cd_medico::text <> '') then

				-- Se for durante a importacao

				if (dados_regra_p.ie_evento = 'IMP') then

					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_partic_w || '.cd_medico_imp = :cd_medico';
				else
					ds_filtro_prof_w := 	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_partic_w || '.cd_medico = :cd_medico';
				end if;

				valor_bind_p := sql_pck.bind_variable(	':cd_medico', dados_filtro_prof_p.cd_medico, valor_bind_p);
			end if;

			-- Grau de participacao

			if (dados_filtro_prof_p.nr_seq_grau_partic IS NOT NULL AND dados_filtro_prof_p.nr_seq_grau_partic::text <> '') then
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_partic_w || '.nr_seq_grau_partic = :nr_seq_grau_partic';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_grau_partic', dados_filtro_prof_p.nr_seq_grau_partic, valor_bind_p);
			end if;

			-- Conselho do profissional

			if (dados_filtro_prof_p.nr_seq_conselho IS NOT NULL AND dados_filtro_prof_p.nr_seq_conselho::text <> '') then
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_partic_w || '.nr_seq_conselho = :nr_seq_conselho ';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_conselho', dados_filtro_prof_p.cd_medico, valor_bind_p);
			end if;

			-- Tipo de medico ( Cooperado ou Nao cooperado) se for nulo ou for A(Ambos)  nao adiciona a restricao

			if (dados_filtro_prof_p.ie_medico_cooperado <> 'A') then

				-- Se for durante a importacao

				if (dados_regra_p.ie_evento = 'IMP') then
					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	pls_obter_se_cooperado_ativo(' || ds_alias_partic_w || '.cd_medico_imp, ' ||
								ds_alias_partic_w || '.dt_procedimento, null ) = :ie_medico_cooperado ';
				else
					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	pls_obter_se_cooperado_ativo(' || ds_alias_partic_w || '.cd_medico, ' ||
								ds_alias_partic_w || '.dt_procedimento, null ) = :ie_medico_cooperado ';
				end if;

				if (dados_filtro_prof_p.ie_medico_cooperado = 'C') then
					valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'S', valor_bind_p);

				elsif (dados_filtro_prof_p.ie_medico_cooperado = 'N') then
					valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'N', valor_bind_p);
				end if;
			else
				--Essa condicao aqui e para evitar que um filtro de excecao seja valido quando nao tiver um filtro por participante totalmente em branco com

				--e apenas o profissional cooperado setado como Ambos. Nessa situacao nao era feito um exists no participante, entao um procedimento sem

				--participante acabava tendo esse filtro de excecao invalido sendo considerado valido

				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	1 = 1';
			end if;
			
			if (dados_filtro_prof_p.nr_seq_cbo_saude IS NOT NULL AND dados_filtro_prof_p.nr_seq_cbo_saude::text <> '') then
			
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_partic_w || '.nr_seq_cbo_saude = :nr_seq_cbo_saude ';
							
				valor_bind_p := sql_pck.bind_variable(	':nr_seq_cbo_saude', dados_filtro_prof_p.nr_seq_cbo_saude, valor_bind_p);
			end if;
			
		-- Procedimento

		elsif	((dados_regra_p.ie_incidencia_selecao in ('P', 'PM') or coalesce(dados_filtro_p.ie_incidencia_selecao, 'X') = 'P') and (coalesce(ie_tipo_tabela_p, 'X') != 'MAT')) then

			-- Montar o subselect que verificara os dados dos participantes do procedimento. Apos e adicionado as restricoes dos participantes conforme cadastro do filtro

			ds_select_prof_w :=	ds_select_prof_w || pls_util_pck.enter_w ||
						'and	exists ( '|| pls_util_pck.enter_w ||
						'		select	1 '|| pls_util_pck.enter_w ||
						'		from	pls_proc_participante_v ' || ds_alias_partic_w || pls_util_pck.enter_w ||
						'		where	' || ds_alias_partic_w || '.nr_seq_conta_proc = ' || ds_alias_w || '.nr_seq_conta_proc ';

			-- Codigo do medico

			if (dados_filtro_prof_p.cd_medico IS NOT NULL AND dados_filtro_prof_p.cd_medico::text <> '') then

				-- Se for durante a importacao

				if (dados_regra_p.ie_evento = 'IMP') then
					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_partic_w || '.cd_medico_imp = :cd_medico';
				else
					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_partic_w || '.cd_medico = :cd_medico';
				end if;

				valor_bind_p := sql_pck.bind_variable(	':cd_medico', dados_filtro_prof_p.cd_medico, valor_bind_p);
			end if;

			-- Grau de participacao

			if (dados_filtro_prof_p.nr_seq_grau_partic IS NOT NULL AND dados_filtro_prof_p.nr_seq_grau_partic::text <> '') then
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_partic_w || '.nr_seq_grau_partic = :nr_seq_grau_partic';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_grau_partic', dados_filtro_prof_p.nr_seq_grau_partic, valor_bind_p);
			end if;

			-- Conselho do profissional

			if (dados_filtro_prof_p.nr_seq_conselho IS NOT NULL AND dados_filtro_prof_p.nr_seq_conselho::text <> '') then
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_partic_w || '.nr_seq_conselho = :nr_seq_conselho ';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_conselho', dados_filtro_prof_p.nr_seq_conselho, valor_bind_p);
			end if;

			-- Tipo de medico ( Cooperado ou Nao cooperado) se for nulo ou for A(Ambos)  nao adiciona a restricao

			if (dados_filtro_prof_p.ie_medico_cooperado <> 'A') then

				-- Se for durante a importacao

				if (dados_regra_p.ie_evento = 'IMP') then
					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	pls_obter_se_cooperado_ativo(' || ds_alias_partic_w || '.cd_medico_imp, ' ||
								ds_alias_partic_w || '.dt_procedimento, null ) = :ie_medico_cooperado ';
				else
					ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	pls_obter_se_cooperado_ativo(' || ds_alias_partic_w || '.cd_medico, ' ||
								ds_alias_partic_w || '.dt_procedimento, null ) = :ie_medico_cooperado ';
				end if;

				if (dados_filtro_prof_p.ie_medico_cooperado = 'C') then
					valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'S', valor_bind_p);

				elsif (dados_filtro_prof_p.ie_medico_cooperado = 'N') then
					valor_bind_p := sql_pck.bind_variable(	':ie_medico_cooperado', 'N', valor_bind_p);
				end if;
			else
				--Essa condicao aqui e para evitar que um filtro de excecao seja valido quando nao tiver um filtro por participante totalmente em branco com

				--e apenas o profissional cooperado setado como Ambos. Nessa situacao nao era feito um exists no participante, entao um procedimento sem

				--participante acabava tendo esse filtro de excecao invalido sendo considerado valido

				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
								'and	1 = 1';
			
			end if;
			
			if (dados_filtro_prof_p.nr_seq_cbo_saude IS NOT NULL AND dados_filtro_prof_p.nr_seq_cbo_saude::text <> '') then
			
				ds_filtro_prof_w :=	ds_filtro_prof_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_partic_w || '.nr_seq_cbo_saude = :nr_seq_cbo_saude ';
							
				valor_bind_p := sql_pck.bind_variable(	':nr_seq_cbo_saude', dados_filtro_prof_p.nr_seq_cbo_saude, valor_bind_p);
			end if;
		end if;
	end if;

	-- so monta a retricao quando tem campos informados

	if (ds_filtro_prof_w IS NOT NULL AND ds_filtro_prof_w::text <> '') then

		if (ds_select_prof_w IS NOT NULL AND ds_select_prof_w::text <> '') then
		
			dados_restricao_w.ds_restricao := 	dados_restricao_w.ds_restricao || pls_util_pck.enter_w ||
								ds_select_prof_w ||
								ds_filtro_prof_w || ')';
		else
			dados_restricao_w.ds_restricao := 	dados_restricao_w.ds_restricao || pls_util_pck.enter_w ||
						ds_filtro_prof_w;
		
		
		end if;
	
	end if;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_tipos_ocor_pck.obter_restricao_profissional ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_filtro_prof_p pls_tipos_ocor_pck.dados_filtro_prof, ie_tipo_tabela_p text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
