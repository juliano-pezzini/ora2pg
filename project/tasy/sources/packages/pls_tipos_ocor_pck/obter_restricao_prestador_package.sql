-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_tipos_ocor_pck.obter_restricao_prestador ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_filtro_prest_p pls_tipos_ocor_pck.dados_filtro_prest, ie_tipo_tabela_p text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Monta as restricoes e binds dos campos de filtro de prestador
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
ds_alias_prestador_w	varchar(5);
ds_alias_prest_inter_w	varchar(5);
ds_alias_w		varchar(5);
ds_select_prest_w	varchar(500);
ds_acesso_prest_w	varchar(1000);
ds_filtro_prest_w	varchar(3000);
ds_filtro_grupo_w	varchar(3000);


BEGIN
-- Inicializar o retorno

dados_restricao_w.ds_campos	:= null;
dados_restricao_w.ds_tabelas	:= null;
dados_restricao_w.ds_restricao	:= null;
ds_alias_prestador_w := 'prest';
ds_alias_prest_inter_w := 'inter';

-- E obrigatorio que o campo IE_TIPO_PRESTADOR esteja informado para que a regra seja verificada.

if (dados_filtro_prest_p.ie_tipo_prestador IS NOT NULL AND dados_filtro_prest_p.ie_tipo_prestador::text <> '') then

	-- obtem o alias da tabela

	ds_alias_w := pls_tipos_ocor_pck.obter_alias_tab(	dados_filtro_p.ie_processo_excecao, dados_regra_p.ie_incidencia_selecao,
					dados_filtro_p.ie_incidencia_selecao, ie_tipo_tabela_p);

	-- Aqui verifca qual prestador da conta sera utilizado, se for o prestador de pagamento entao sera utilizado a function especifica para ele, caso contrario sera utilizado uma function

	-- que engloba os outros tipos de prestador. Caso uma dessas functions nao retorne nada nao deve ser filtrado.

	if (dados_filtro_prest_p.ie_tipo_prestador = 'P') then

		-- Procedimento

		if	((dados_regra_p.ie_incidencia_selecao = 'P' or coalesce(dados_filtro_p.ie_incidencia_selecao, 'X') = 'P') and (coalesce(ie_tipo_tabela_p, 'X') != 'MAT')) and (ds_alias_w != current_setting('pls_tipos_ocor_pck.ds_alias_conta')::varchar(10)) then
			-- Se for para gerar a ocorrencia para procedimento entao deve ser olhado se o prestador e o prestador de pagamento do procedimento

			-- ou de algum participante do mesmo.

			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and 	' || ds_alias_prestador_w || '.nr_sequencia in ( ' || ds_alias_w || '.nr_seq_prestador_pgto, '|| pls_util_pck.enter_w ||
						'					 nvl(' || ds_alias_w || '.nr_seq_prestador_pgto, ' || ds_alias_w || '.nr_seq_prestador_exec), '|| pls_util_pck.enter_w ||
						'					 ' || ds_alias_w || '.nr_seq_prest_pgto_medico, '|| pls_util_pck.enter_w ||
						'					(select	max(b.nr_seq_prestador_pgto) '|| pls_util_pck.enter_w ||
						'					 from	pls_proc_participante b '|| pls_util_pck.enter_w ||
						'					 where	b.nr_seq_conta_proc = ' || ds_alias_w || '.nr_sequencia '|| pls_util_pck.enter_w ||
						'					 and	b.ie_status <> ''C'' '|| pls_util_pck.enter_w ||
						'					 and 	b.nr_seq_prestador_pgto = ' || ds_alias_prestador_w || '.nr_sequencia)) ';
		-- Material

		elsif	((dados_regra_p.ie_incidencia_selecao = 'M' or coalesce(dados_filtro_p.ie_incidencia_selecao, 'X') = 'M') and (coalesce(ie_tipo_tabela_p, 'X') != 'PROC')) and (ds_alias_w != current_setting('pls_tipos_ocor_pck.ds_alias_conta')::varchar(10)) then
			-- Se for para gerar a ocorrencia para os materiais entao sera olhado o fornecedor do material da conta.

			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	exists ( ' || pls_util_pck.enter_w ||
						'		select	a.nr_seq_prest_fornec ' || pls_util_pck.enter_w ||
						'		from	pls_conta_mat a ' || pls_util_pck.enter_w ||
						'		where	a.nr_sequencia = ' || ds_alias_w || '.nr_seq_conta_mat ' || pls_util_pck.enter_w ||
						'		and	a.nr_seq_prest_fornec = ' || ds_alias_prestador_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
						'		) ';
		-- conta

		else
			-- Quando for para gerar a ocorrencia na conta entao deve ser verificado se o prestador que esta sendo filtrado na regra e prestador de pagamento de algum item na conta.

			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	exists ( ' || pls_util_pck.enter_w ||
						'		select	1 '|| pls_util_pck.enter_w ||
						'		from 	pls_conta_proc a '|| pls_util_pck.enter_w ||
						'		where 	a.nr_seq_conta = ' || ds_alias_w || '.nr_seq_conta '|| pls_util_pck.enter_w ||
						'		and 	' || ds_alias_prestador_w || '.nr_sequencia in (a.nr_seq_prestador_pgto, '|| pls_util_pck.enter_w ||
						'									nvl(a.nr_seq_prestador_pgto, ' || ds_alias_w || '.nr_seq_prestador_exec), '|| pls_util_pck.enter_w ||
						'									a.nr_seq_prest_pgto_medico, '|| pls_util_pck.enter_w ||
						'									(select	max(b.nr_seq_prestador_pgto) '|| pls_util_pck.enter_w ||
						'									 from	pls_proc_participante b '|| pls_util_pck.enter_w ||
						'									 where	b.nr_seq_conta_proc = a.nr_sequencia '|| pls_util_pck.enter_w ||
						'									 and	b.ie_status <> ''C'' '|| pls_util_pck.enter_w ||
						'									 and b.nr_seq_prestador_pgto = ' || ds_alias_prestador_w || '.nr_sequencia)) '|| pls_util_pck.enter_w ||
						'		union all '|| pls_util_pck.enter_w ||
						'		select	a.nr_seq_prest_fornec '|| pls_util_pck.enter_w ||
						'		from	pls_conta_mat a '|| pls_util_pck.enter_w ||
						'		where	a.nr_seq_conta = ' || ds_alias_w || '.nr_seq_conta '|| pls_util_pck.enter_w ||
						'		and	a.nr_seq_prest_fornec = ' || ds_alias_prestador_w || '.nr_sequencia '|| pls_util_pck.enter_w ||
						'		) ';

		end if;

	-- Atendimento

	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'A') then
		-- se for importacao XML

		if (dados_regra_p.ie_evento = 'IMP') then
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prestador_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prestador_imp_prot ';
		else
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prestador_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prestador_prot ';
		end if;
	-- Executor

	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'E') then
		if (dados_regra_p.ie_evento = 'IMP') then
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prestador_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prestador_exec_imp ';
		else
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prestador_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prestador_exec ';
		end if;
	--  Solicitante.

	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'S') then
		if (dados_regra_p.ie_evento = 'IMP') then
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prestador_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prestador_imp ';
		else
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prestador_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prestador_conta ';
		end if;
	-- Intercambio

	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'I') then
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	' || ds_alias_prest_inter_w || '.nr_sequencia = ' || ds_alias_w || '.nr_seq_prest_inter ';
	-- Participante

	-- O participante tem uma tratativa especial, como ele esta a nivel de procedimento (ou material), ele e pesquisado da forma mais apropriada, conforme a incidencia do filtro

	-- Tambem e utilizado a nova tabela temporaria, que possui todos os prestadores envolvidos no atendimento, simplificando a consulta e otimizando ela.

	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'R') then
	
		-- se a incidencia for Procedimento

		if	((dados_regra_p.ie_incidencia_selecao = 'P') or coalesce(dados_filtro_p.ie_incidencia_selecao, 'X') = 'P') and (coalesce(ie_tipo_tabela_p, 'X') != 'MAT') and (ds_alias_w != current_setting('pls_tipos_ocor_pck.ds_alias_conta')::varchar(10)) then
			
			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	exists	(select	1 '|| pls_util_pck.enter_w ||
						'		 from	pls_cta_prestador_tmp	b ' || pls_util_pck.enter_w ||
						'		 where	b.nr_seq_conta_proc	= ' || ds_alias_w || '.nr_sequencia '|| pls_util_pck.enter_w ||
						'		 and	b.ie_tipo_prestador	= ''PP''' || pls_util_pck.enter_w || -- prestador Participante
						'		 and	b.nr_seq_prestador	= ' || ds_alias_prestador_w || '.nr_sequencia) ';
		-- Se nao for incidencia de Procedimento e nem de material, sera considerado como "Conta"

		elsif (coalesce(dados_filtro_p.ie_incidencia_selecao, 'X') != 'M') then

			ds_acesso_prest_w :=	ds_acesso_prest_w || pls_util_pck.enter_w ||
						'and	exists	(select	1 '|| pls_util_pck.enter_w ||
						'		 from	pls_cta_prestador_tmp	b ' || pls_util_pck.enter_w ||
						'		 where	b.nr_seq_conta		= ' || ds_alias_w || '.nr_sequencia '|| pls_util_pck.enter_w ||
						'		 and	b.ie_tipo_prestador	= ''PP''' || pls_util_pck.enter_w || -- prestador Participante
						'		 and	b.nr_seq_prestador	= ' || ds_alias_prestador_w || '.nr_sequencia) ';
		end if;
		
	end if;

	-- Neste momento ja devemos ter alguma informacao na restricao do prestador para saber qual prestador sera utilizado na verificacao e nao ser feito um acesso full na PLS_PRESTADOR

	if (ds_acesso_prest_w IS NOT NULL AND ds_acesso_prest_w::text <> '') then
		
		-- Montar o subselect base.

		-- Se for prestador de intercambio entao a base

		-- deve ser diferente da base dos outros tipos de prestador

		if (dados_filtro_prest_p.ie_tipo_prestador = 'I') then
			ds_select_prest_w :=	'and	exists (' || pls_util_pck.enter_w ||
						'		select	1 ' || pls_util_pck.enter_w ||
						'		from	pls_prestador_intercambio ' || ds_alias_prest_inter_w || pls_util_pck.enter_w ||
						'		where	1 = 1 ';
			-- Prestador intercambio

			if (dados_filtro_prest_p.nr_seq_prest_inter IS NOT NULL AND dados_filtro_prest_p.nr_seq_prest_inter::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_prest_inter_w || '.nr_sequencia = :nr_seq_prest_inter ';
							
				valor_bind_p := sql_pck.bind_variable(	':nr_seq_prest_inter', dados_filtro_prest_p.nr_seq_prest_inter, valor_bind_p);
			end if;
			-- Grupo prestador intercambio

			if (dados_filtro_prest_p.nr_seq_grupo_prest_int IS NOT NULL AND dados_filtro_prest_p.nr_seq_grupo_prest_int::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	exists (	select	1 ' || pls_util_pck.enter_w ||
							'			from	pls_preco_prestador_int grupo_int ' || pls_util_pck.enter_w ||
							'			where	grupo_int.nr_seq_grupo = ' || dados_filtro_prest_p.nr_seq_grupo_prest_int || pls_util_pck.enter_w ||
							'			and	grupo_int.nr_seq_prest_inter = ' || ds_alias_prest_inter_w || '.nr_sequencia) ';
			end if;
			-- Tipo prestador de intercambio

			if (dados_filtro_prest_p.ie_tipo_pessoa_prest_int <> 'A') then
				if (dados_filtro_prest_p.ie_tipo_pessoa_prest_int = 'PF') then
					ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_prest_inter_w || '.nr_cpf is not null  ';
				elsif (dados_filtro_prest_p.ie_tipo_pessoa_prest_int = 'PJ') then
					ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_prest_inter_w || '.cd_cgc_intercambio is not null  ';
				end if;
			end if;
		else
			ds_select_prest_w :=	'and	exists (' || pls_util_pck.enter_w ||
						'		select	1 ' || pls_util_pck.enter_w ||
						'		from	pls_prestador ' || ds_alias_prestador_w || pls_util_pck.enter_w ||
						'		where	1 = 1 ';
						
			-- Codigo do prestador

			if (dados_filtro_prest_p.cd_prestador IS NOT NULL AND dados_filtro_prest_p.cd_prestador::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_prestador_w || '.cd_prestador = :cd_prestador ';

				valor_bind_p := sql_pck.bind_variable(	':cd_prestador', dados_filtro_prest_p.cd_prestador, valor_bind_p);
			end if;

			-- Classificacao do prestador

			if (dados_filtro_prest_p.nr_seq_classificacao IS NOT NULL AND dados_filtro_prest_p.nr_seq_classificacao::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_prestador_w || '.nr_seq_classificacao = :nr_seq_classificacao ';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_classificacao', dados_filtro_prest_p.nr_seq_classificacao, valor_bind_p);
			end if;

			-- Sequencia do prestador

			if (dados_filtro_prest_p.nr_seq_prestador IS NOT NULL AND dados_filtro_prest_p.nr_seq_prestador::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_prestador_w || '.nr_sequencia = :nr_seq_prestador ';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_prestador', dados_filtro_prest_p.nr_seq_prestador, valor_bind_p);
			end if;

			-- Tipo do prestador

			if (dados_filtro_prest_p.nr_seq_tipo_prestador IS NOT NULL AND dados_filtro_prest_p.nr_seq_tipo_prestador::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	' || ds_alias_prestador_w || '.nr_seq_tipo_prestador = :nr_seq_tipo_prestador ';

				valor_bind_p := sql_pck.bind_variable(	':nr_seq_tipo_prestador', dados_filtro_prest_p.nr_seq_tipo_prestador, valor_bind_p);
			end if;

			-- Especialidade do prestador

			if (dados_filtro_prest_p.cd_especialidade_medica IS NOT NULL AND dados_filtro_prest_p.cd_especialidade_medica::text <> '') then
				ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
							'and	 exists	(	select	1 ' || pls_util_pck.enter_w ||
							'			from	pls_prestador_med_espec espec ' || pls_util_pck.enter_w ||
							'			where	espec.nr_seq_prestador = ' || ds_alias_prestador_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
							'			and	espec.cd_especialidade = :cd_especialidade_medica ' || pls_util_pck.enter_w ||
							'			and	' || ds_alias_w || '.dt_atendimento_conta between espec.dt_inicio_vigencia_ref and espec.dt_fim_vigencia_ref) ';

				valor_bind_p := sql_pck.bind_variable(	':cd_especialidade_medica', dados_filtro_prest_p.cd_especialidade_medica, valor_bind_p);
			end if;

			-- Tipo pessoa prestador

			if (coalesce(dados_filtro_prest_p.ie_tipo_pesssoa_prest,'A') <> 'A') then
				if (dados_filtro_prest_p.ie_tipo_pesssoa_prest = 'PF') then
					ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_prestador_w || '.cd_pessoa_fisica is not null  ';
				elsif (dados_filtro_prest_p.ie_tipo_pesssoa_prest = 'PJ') then
					ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
								'and	' || ds_alias_prestador_w || '.cd_cgc is not null  ';
				end if;
			end if;
			
			-- Grupo de prestadores

			if (dados_filtro_prest_p.nr_seq_grupo_prestador IS NOT NULL AND dados_filtro_prest_p.nr_seq_grupo_prestador::text <> '') then
				if (ds_filtro_prest_w IS NOT NULL AND ds_filtro_prest_w::text <> '') or (dados_filtro_prest_p.ie_tipo_prestador	in ('R','P'))then
					ds_filtro_prest_w :=	ds_filtro_prest_w || pls_util_pck.enter_w ||
								'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_prestador_w || '.nr_sequencia ) ';

					valor_bind_p := sql_pck.bind_variable(	':nr_seq_grupo_prestador', dados_filtro_prest_p.nr_seq_grupo_prestador, valor_bind_p);
				else
					
					if (dados_filtro_prest_p.ie_tipo_prestador = 'A') then
						-- se for importacao XML

						if (dados_regra_p.ie_evento = 'IMP') then
							ds_filtro_grupo_w :=	ds_filtro_grupo_w || pls_util_pck.enter_w ||
										'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_w || '.nr_seq_prestador_imp_prot ) ';
										
						else
							ds_filtro_grupo_w :=	ds_filtro_grupo_w || pls_util_pck.enter_w ||
										'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_w || '.nr_seq_prestador_prot ) ';
										
						end if;
					-- Executor

					elsif (dados_filtro_prest_p.ie_tipo_prestador = 'E') then
						if (dados_regra_p.ie_evento = 'IMP') then
							ds_filtro_grupo_w :=	ds_filtro_grupo_w || pls_util_pck.enter_w ||
										'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_w || '.nr_seq_prestador_exec_imp ) ';
						else
							ds_filtro_grupo_w :=	ds_filtro_grupo_w || pls_util_pck.enter_w ||
										'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_w || '.nr_seq_prestador_exec ) ';
						end if;
					--  Solicitante.

					elsif (dados_filtro_prest_p.ie_tipo_prestador = 'S') then
						if (dados_regra_p.ie_evento = 'IMP') then
							ds_filtro_grupo_w :=	ds_filtro_grupo_w || pls_util_pck.enter_w ||
										'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_w || '.nr_seq_prestador_imp ) ';
						else
							ds_filtro_grupo_w :=	ds_filtro_grupo_w || pls_util_pck.enter_w ||
										'and	exists	(	select	grup_prest.nr_seq_grupo '|| pls_util_pck.enter_w ||
								'			from	pls_grup_prest_preco_v grup_prest '|| pls_util_pck.enter_w ||
								'			where	grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador '|| pls_util_pck.enter_w ||
								'			and	grup_prest.nr_seq_prestador = ' || ds_alias_w || '.nr_seq_prestador_conta ) ';
						end if;
					end if;
					dados_restricao_w.ds_restricao :=	ds_filtro_grupo_w || pls_util_pck.enter_w;
					valor_bind_p := sql_pck.bind_variable(	':nr_seq_grupo_prestador', dados_filtro_prest_p.nr_seq_grupo_prestador, valor_bind_p);
				end if;
			end if;
		end if;
		
		if (ds_filtro_prest_w IS NOT NULL AND ds_filtro_prest_w::text <> '') then
			-- No caso dos prestadores nao deve ser acicionada a restricao pois se o filtro estiver vazio entao sera feito um acesso full na PLS_PRESTADOR e nos nao queremos isso.

			dados_restricao_w.ds_restricao :=	dados_restricao_w.ds_restricao || pls_util_pck.enter_w ||
								ds_select_prest_w ||
								ds_acesso_prest_w ||
								ds_filtro_prest_w ||
								pls_util_pck.enter_w || '		)';
		end if;
	end if;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_tipos_ocor_pck.obter_restricao_prestador ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_filtro_prest_p pls_tipos_ocor_pck.dados_filtro_prest, ie_tipo_tabela_p text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
