-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_sel_val_42 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_val_regra_atrib_p pls_tipos_ocor_pck.dados_val_regra_atrib) RETURNS PLS_TIPOS_OCOR_PCK.DADOS_SELECT AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Obter os dados para montagem do select que sera efetuado na validacao da Regra de Atributo
	da ocorrencia combinada.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

* FICAR ATENTO AO ALIAS DO CAMPO QUE SERA USADO PARA VERIFICAR. SEMPRE USAR COMO ATRIB PARA NAO GERAR PROBLEMAS NO ORDER BY;

** As tabelas que nao estiverem no select padrao devem ser adicionadas no campo DADOS_RETORNO_W.DS_TABELAS;

*** Para as tabelas que ja estiverem no select nao precisa e NAO DEVE ser adicionado nada ao campo DADOS_RETORNO_W.DS_TABELAS;

Alteracoes
-------------------------------------------------------------------------------------------------------------------

jjung OS 601992 - 16/09/2013 - Criacao da function
-------------------------------------------------------------------------------------------------------------------

jjkruk OS 791940 - 08/10/2014 - Removida restricao ie_classificacao = 'P' do CID
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_retorno_w	pls_tipos_ocor_pck.dados_select;


BEGIN

-- So continua as verificacoes caso seja informada uma regra valida.
if (dados_val_regra_atrib_p.nr_sequencia IS NOT NULL AND dados_val_regra_atrib_p.nr_sequencia::text <> '') then


	-- Se a regra nao tiver um atributo informado entao nao executar o case, pois como sao varios valores possiveis e sabemos que todos

	-- serao negados nao precisamos fazer todas estas verificacoes adicionais.
	if (dados_val_regra_atrib_p.ie_atributo IS NOT NULL AND dados_val_regra_atrib_p.ie_atributo::text <> '') then

		-- Conforme o atributo selecionado para a regra sera incrementado o select padrao conforme o retorno desta function.
		case(dados_val_regra_atrib_p.ie_atributo)
			-- Data/hora saida internacao (DT_ALTA)

			-- Tabela: PLS_CONTA
			when 1 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_alta_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.dt_alta_imp atrib ';
					else
						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.dt_alta atrib ';
					end if;
				end;
			-- CID Principal (CD_DOENCA)

			-- Tabela: PLS_DIAGNOSTICO_CONTA
			when 2 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo cd_doenca_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	(select max(diag.cd_doenca_imp) '|| pls_tipos_ocor_pck.enter_w ||
										'	from pls_diagnostico_conta diag '|| pls_tipos_ocor_pck.enter_w ||
										'	where 	diag.nr_seq_conta = conta.nr_sequencia) atrib ';
					else
						-- Adicionar o campo cd_doenca ao comando select

						--Alterei o tratamento devido ao fato de poder nao existir o cd_doenda e neste caso e necessario considerar tambem dgkorz
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	(select max(diag.cd_doenca) '|| pls_tipos_ocor_pck.enter_w ||
										'	from pls_diagnostico_conta diag '|| pls_tipos_ocor_pck.enter_w ||
										'	where 	diag.nr_seq_conta = conta.nr_sequencia) atrib ';

					end if;
				end;
			-- Se obito em mulher (IE_OBITO_MULHER)

			-- Tabela: PLS_CONTA
			when 3 then
				begin
					-- Adicionar o campo ie_obito_mulher ao comando select
					dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
									'	conta.ie_obito_mulher  atrib ';
				end;
			-- Qtd. obito neonatal Precoce (QT_OBITO_PRECOCE)

			-- Tabela: PLS_CONTA
			when 4 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo qt_obito_precoce_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.qt_obito_precoce_imp atrib ';
					else
						-- Adicionar o campo qt_obito_precoce ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.qt_obito_precoce atrib ';
					end if;
				end;
			-- Qtd. obito neonatal Tardio (QT_OBITO_TARDIO)

			-- Tabela: PLS_CONTA
			when 5 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo qt_obito_tardio_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.qt_obito_tardio_imp atrib ';
					else
						-- Adicionar o campo qt_obito_tardio ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.qt_obito_tardio atrib ';
					end if;
				end;
			-- Qtd. nasc. vivos a termo (QT_NASC_VIVOS_TERMO)

			-- Tabela: PLS_CONTA
			when 6 then
				begin
					-- Adicionar o campo qt_nasc_vivos_termo ao comando select
					dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
									'	conta.qt_nasc_vivos_termo atrib ';
				end;
			-- Qtd. nasc. mortos (QT_NASC_MORTOS)

			-- Tabela: PLS_CONTA
			when 7 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo qt_nasc_mortos_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.qt_nasc_mortos_imp atrib ';
					else
						-- Adicionar o campo qt_nasc_mortos ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.qt_nasc_mortos atrib ';
					end if;
				end;
			-- CID 10 obito (CD_DOENCA)

			-- Tabela: PLS_DIAGNOST_CONTA_OBITO
			when 8 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo cd_doenca_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.cd_doenca_imp atrib ';

						-- Acessar a tabela PLS_DIAGNOST_CONTA_OBITO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnost_conta_obito diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOST_CONTA_OBITO
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta = conta.nr_sequencia ';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.cd_doenca atrib ';

						-- Acessar a tabela PLS_DIAGNOST_CONTA_OBITO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnost_conta_obito diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOST_CONTA_OBITO
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta = nvl(conta.nr_seq_conta_princ,conta.nr_sequencia) ';
					end if;
				end;
			-- Nr Declaracao obito (NR_DECLARACAO_OBITO)

			-- Tabela: PLS_DIAGNOST_CONTA_OBITO
			when 9 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					
					
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo nr_declaracao_obito_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.nr_declaracao_obito_imp atrib ';

						-- Acessar a tabela PLS_DIAGNOST_CONTA_OBITO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnost_conta_obito diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOST_CONTA_OBITO

						-- Incluido outer join para que gere ocorrencia quando nao existe registo, OS 726741
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta(+) = conta.nr_sequencia ';
					else
						-- Adicionar o campo nr_declaracao_obito ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.nr_declaracao_obito atrib ';

						-- Acessar a tabela PLS_DIAGNOST_CONTA_OBITO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnost_conta_obito diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOST_CONTA_OBITO

						-- Incluido outer join para que gere ocorrencia quando nao existe registo, OS 726741
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta(+) = nvl(conta.nr_seq_conta_princ,conta.nr_sequencia) ';
					end if;
				end;
			-- Numero da carteira (CD_USUARIO_PLANO)

			-- Tabela: PLS_CONTA; PLS_SEGURADO_CARTEIRA
			when 10 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo cd_usuario_plano_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_usuario_plano_imp atrib ';
					else
						-- Adicionar o campo cd_usuario_plano ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_usuario_plano atrib ';
					end if;
				end;
			-- Nr Decl. Nasc. Vivo (NR_DECL_NASC_VIVO)

			-- Tabela: PLS_DIAGNOSTICO_NASC_VIVO
			when 11 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
										
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo nr_decl_nasc_vivo_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.nr_decl_nasc_vivo_imp atrib ';

						-- Acessar a tabela PLS_DIAGNOSTICO_NASC_VIVO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnostico_nasc_vivo diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOSTICO_NASC_VIVO

						-- Incluido outer join para que gere ocorrencia quando nao existe registo, OS 726741
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta(+) = conta.nr_sequencia ';
					elsif (dados_regra_p.ie_evento = 'PW') then -- Complemento

						-- Adicionar o campo nr_decl_nasc_vivo_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.nr_decl_nasc_vivo atrib ';

						-- Acessar a tabela PLS_DIAGNOSTICO_NASC_VIVO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnostico_nasc_vivo diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOSTICO_NASC_VIVO

						-- Incluido outer join para que gere ocorrencia quando nao existe registo, OS 726741
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta(+) = conta.nr_sequencia ';
								
					else
						-- Adicionar o campo nr_decl_nasc_vivo_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	diag.nr_decl_nasc_vivo atrib ';

						-- Acessar a tabela PLS_DIAGNOSTICO_NASC_VIVO, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_diagnostico_nasc_vivo diag ';

						-- Montar os filtros de acesso a tabela PLS_DIAGNOSTICO_NASC_VIVO

						-- Incluido outer join para que gere ocorrencia quando nao existe registo, OS 726741
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	diag.nr_seq_conta(+) = nvl(conta.nr_seq_conta_princ,conta.nr_sequencia) ';
					end if;
				end;
			-- Indicacao clinica (DS_INDICACAO_CLINICA)

			-- Tabela: PLS_CONTA
			when 12 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo ds_indicacao_clinica_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ds_indicacao_clinica_imp atrib ';
					else
						-- Adicionar o campo ds_indicacao_clinica ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ds_indicacao_clinica atrib ';
					end if;
				end;
			-- Hora inicial (DT_INICIO_PROC)

			-- Tabela: PLS_CONTA_PROC
			when 13 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_inicio_proc_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	proc.dt_inicio_proc_imp atrib ';

						-- Acessar a tabela PLS_CONTA_PROC_OCOR_V, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_conta_proc_ocor_v proc ';

						-- Montar os filtros de acesso a tabela PLS_CONTA_PROC_OCOR_V
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	proc.nr_seq_conta = conta.nr_sequencia ';
					else
						-- Adicionar o campo dt_inicio_proc ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	proc.dt_inicio_proc atrib ';

						-- Acessar a tabela PLS_CONTA_PROC_OCOR_V, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_conta_proc_ocor_v proc ';

						-- Montar os filtros de acesso a tabela PLS_CONTA_PROC_OCOR_V
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	proc.nr_seq_conta = conta.nr_sequencia ';
					end if;
				end;
			-- Hora final (DT_FIM_PROC)

			-- Tabela: PLS_CONTA_PROC
			when 14 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_fim_proc_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	proc.dt_fim_proc_imp atrib ';

						-- Acessar a tabela PLS_CONTA_PROC_OCOR_V, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_conta_proc_ocor_v proc ';

						-- Montar os filtros de acesso a tabela PLS_CONTA_PROC_OCOR_V
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	proc.nr_seq_conta = conta.nr_sequencia ';
					else
						-- Adicionar o campo dt_fim_proc ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	proc.dt_fim_proc atrib ';

						-- Acessar a tabela PLS_CONTA_PROC_OCOR_V, de onde sera buscado o campo para verificacao;
						dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	pls_conta_proc_ocor_v proc ';

						-- Montar os filtros de acesso a tabela PLS_CONTA_PROC_OCOR_V
						dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
										'and	proc.nr_seq_conta = conta.nr_sequencia ';
					end if;
				end;
			-- Data/hora de internacao (DT_ENTRADA)

			-- Tabela: PLS_CONTA
			when 15 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_entrada_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.dt_entrada_imp atrib ';
					else
						-- Adicionar o campo dt_entrada ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.dt_entrada atrib ';
					end if;
				end;
			-- Nr Guia referencia (CD_GUIA_REFERENCIA, CD_GUIA_SOLIC_IMP)

			-- Tabela: PLS_CONTA
			when 16 then
				begin
					-- Adicionar o campo cd_guia_referencia ao comando select
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_guia_solic_imp atrib ';
					else
						-- Usa cd_guia_ref pois a pls_conta_v tem tratamento sobre o cd_guia_referencia
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_guia_ref atrib ';
					end if;


				end;
			-- CRM medico (NR_CRM_SOLIC;NR_CRM_EXEC)

			-- Tabela: PLS_CONTA
			when 17 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo nvl(conta.nr_crm_solic_imp, conta.nr_crm_exec_imp) ao comando select

						-- Para esta validacao sera dada prioridade ao crm do solicitante, se nao tiver este verifica crm do executor
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	nvl(conta.nr_crm_solic_imp, conta.nr_crm_exec_imp) atrib ';
					else
						-- Adicionar o campo nvl(conta.nr_crm_solic, conta.nr_crm_exec) ao comando select

						-- Para esta validacao sera dada prioridade ao crm do solicitante, se nao tiver este verifica crm do executor
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	nvl(conta.nr_crm_solic, conta.nr_crm_exec) atrib ';
					end if;
				end;
			-- Matracula do estipulante na requisicao (CD_MATRICULA_ESTIPULANTE)

			-- Tabela: PLS_EXECUCAO_REQUISICAO; PLS_REQUISICAO
			when 18 then
				begin
					-- Adicionar o campo cd_matricula_estipulante ao comando select
					dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
									'	req.cd_matricula_estipulante atrib ';

					-- Adiciona as tabelas PLS_EXECUCAO_REQUISICAO e PLS_REQUISICAO, para buscar o campo.
					dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
									'	pls_execucao_requisicao exec, ' || pls_tipos_ocor_pck.enter_w ||
									'	pls_requisicao req ';

					-- Para acessar a requisicao deve ser primeiramente acessada a execucao, pela guia da conta que foi gerada a partir da requisicao.
					dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
									'and	exec.nr_seq_guia = conta.nr_seq_guia ' || pls_tipos_ocor_pck.enter_w ||
									'and	req.nr_sequencia = exec.nr_seq_requisicao ';
				end;
			-- Matricula do estipulante no beneficiario (CD_MATRICULA_ESTIPULANTE)

			-- Tabela: PLS_EXECUCAO_REQUISICAO; PLS_REQUISICAO
			when 19 then
				begin
					-- Adicionar o campo cd_matricula_estipulante ao comando select
					dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
									'	benef.cd_matricula_estipulante atrib ';

					-- o campo de matricula do estipulante no beneficiario deve ser buscado da PLS_SEGURADO
					dados_retorno_w.ds_tabelas :=	', ' || pls_tipos_ocor_pck.enter_w ||
									'	pls_segurado_conta_v benef ';

					-- Montar o acesso a view  PLS_SEGURADO_CONTA_V referente a tabela PLS_SEGURADO.
					dados_retorno_w.ds_restricao :=	pls_tipos_ocor_pck.enter_w ||
									'and	benef.nr_sequencia = conta.nr_seq_segurado ';
				end;
			-- Senha da autorizacao (CD_SENHA)

			-- Tabela: PLS_CONTA
			when 20 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo cd_senha_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_senha_imp atrib ';
					else
						-- Adicionar o campo cd_senha ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_senha atrib ';
					end if;
				end;
			-- Medico executor (CD_MEDICO_EXECUTOR)

			-- Tabela: PLS_CONTA
			when 21 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Verificar se existe informacao do medico executor na importacao.
			 			dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_medico_executor_imp atrib ';
					else
						-- Quando a conta ja estiver integrada ao Tasy, entao o medico executor pode ser informado no campo

						-- CD_MEDICO_EXECUTOR, ou caso exista valor no campo IE_MEDICO_EXEC_INFORMADO.
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
											'	nvl(conta.cd_medico_executor, '|| pls_tipos_ocor_pck.enter_w ||
											'	decode(conta.ie_medico_exec_informado,''S'',1,null) '|| pls_tipos_ocor_pck.enter_w ||
											'	) atrib ';
					end if;
				end;
	 		when 22 then
				begin

				-- Verificar se existe informacao do motivo saida consulta.
				dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
								'	conta.nr_seq_saida_consulta atrib ';

				end;

			-- Observacao DS_OBSERVACAO, DS_OBSERVACAO_IMP

			-- Tabela: PLS_CONTA
			when 23 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_alta_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ds_observacao_imp atrib ';
					else
						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ds_observacao atrib ';
					end if;
				end;
				
			-- Observacao NR_SEQ_CLINICA, NR_SEQ_CLINICA_IMP

			-- Tabela: PLS_CONTA
			when 24 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML

					--if	(dados_regra_p.ie_evento = 'IMP') then


						-- Adicionar o campo dt_alta_imp ao comando select

						--dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||

										--'	conta.nr_seq_clinica_imp atrib ';

					--else

						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.nr_seq_clinica atrib ';
					--end if;
				end;
				
			-- Observacao NR_SEQ_TIPO_ATENDIMENTO, IE_TIPO_ATENDIMENTO_IMP

			-- Tabela: PLS_CONTA
			when 25 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_alta_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_tipo_atendimento_imp atrib ';
					else
						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.nr_seq_tipo_atendimento atrib ';
					end if;
				end;
				
			-- Observacao IE_CARATER_INTERNACAO, IE_CARATER_INTERNACAO_IMP

			-- Tabela: PLS_CONTA
			when 26 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_alta_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_carater_internacao_imp atrib ';
					else
						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_carater_internacao atrib ';
					end if;
				end;
				
			-- Observacao IE_REGIME_INTERNACAO, IE_REGIME_INTERNACAO_IMP

			-- Tabela: PLS_CONTA
			when 27 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_alta_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_regime_internacao_imp atrib ';
					else
						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_regime_internacao atrib ';
					end if;
				end;
				
				
			-- Observacao IE_TIPO_CONSULTA, IE_TIPO_CONSULTA_IMP

			-- Tabela: PLS_CONTA
			when 28 then
				begin
					-- Verificar o evento em que a ocorrencia esta sendo gerada.

					-- Se for importacao olha para os campos IMP, se nao para os campos quentes.

					-- Importacao XML
					if (dados_regra_p.ie_evento = 'IMP') then

						-- Adicionar o campo dt_alta_imp ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_tipo_consulta_imp atrib ';
					else
						-- Adicionar o campo dt_alta ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_tipo_consulta atrib ';
					end if;
				end;

			-- Nr Guia referencia (CD_GUIA, CD_GUIA_IMP)

			-- Tabela: PLS_CONTA
			when 29 then
				begin
					-- Adicionar o campo cd_guia_imp ao comando select
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_guia_imp atrib ';
					else
						-- Adicionar o campo cd_guia ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_guia atrib ';
					end if;


				end;
				
			-- Nr Guia referencia (CD_GUIA_PRESTADOR, CD_GUIA_PRESTADOR_IMP)

			-- Tabela: PLS_CONTA
			when 30 then
				begin
					-- Adicionar o campo cd_guia_prestador_imp ao comando select
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_guia_prestador_imp atrib ';
					else
						-- Adicionar o campo cd_guia_prestador ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_guia_prestador atrib ';
					end if;


				end;
			--Tipo de faturamento (IE_TIPO_FATURAMENTO, IE_TIPO_FATURAMENTO_IMP)

			--Tabela PLS_CONTA
			when 31 then
				begin
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_tipo_faturamento_imp atrib ';
					else
						-- Adicionar o campo cd_guia_prestador ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_tipo_faturamento atrib ';
					end if;
				end;
			when 32 then
				begin
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_cnes_executor_imp atrib ';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.cd_cnes atrib ';
					end if;
				end;
			when 33 then
				begin
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_recem_nascido_imp atrib ';
					else
						-- Adicionar o campo cd_guia_prestador ao comando select
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_recem_nascido atrib ';
					end if;
				end;
			when 34 then
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_motivo_encerramento atrib';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.nr_seq_saida_int atrib';
					end if;
                        when 35	then
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.nr_protocolo_prestador atrib';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.nr_protocolo_prestador atrib';
					end if;
			when 36	then
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_regime_atendimento atrib';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_regime_atendimento atrib';
					end if;
			when 37	then
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_saude_ocupacional atrib';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_saude_ocupacional atrib';
					end if;
			when 38	then
					if (dados_regra_p.ie_evento = 'IMP') then
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_cobertura_especial atrib';
					else
						dados_retorno_w.ds_campos :=	', ' || pls_tipos_ocor_pck.enter_w ||
										'	conta.ie_cobertura_especial atrib';
					end if;
			else
				begin
					-- Tratamento para o atributo #@DS_ATRIB#@, ainda nao foi desenvolvido.
					CALL wheb_mensagem_pck.exibir_mensagem_abort(262202,'DS_ATRIB=' || dados_val_regra_atrib_p.ie_atributo ||
											' - ' || obter_valor_dominio(4244, dados_val_regra_atrib_p.ie_atributo));
				end;

		end case;
	end if;
end if;

return	dados_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_sel_val_42 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_val_regra_atrib_p pls_tipos_ocor_pck.dados_val_regra_atrib) FROM PUBLIC;

