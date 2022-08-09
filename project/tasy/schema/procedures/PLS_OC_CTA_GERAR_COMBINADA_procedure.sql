-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_gerar_combinada ( ie_evento_p text, ie_portal_web_p text, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, ie_tipo_excecao_p text, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_id_transacao_log_p pls_oc_cta_log_ocor.nr_id_transacao%type default null, ie_incidencia_regra_p text default null, ie_conta_sem_proc_mat_p text default null) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Procedure exclusiva para ocorrências  COMBINADAS de conta médica
Analisar as regras das ocorrências que foram marcadas para funcionar através da Regra Combinada.
Objetivos:
1 - Irá verificar as validações e filtros definidos, chamando as functions correspondentes conforme ordem parametrizada
2 - Gerar a ocorrência no item ou conta quando as validações e filtros forem atendidos
3 - Inativar as ocorrências que não serão mais geradas
4 - Gravar novo log criado para identificar em qual regra encaixou
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
1) PERFORMANCE. Irá verificar em nível de item da conta.
Cada select deve ser feito apenas uma vez. Por exemplo, uma conta com 30 mil itens, a tabela PLS_CONTA deve ser
acessada apenas 1 vez.. Ou seja, passar como parâmetro para as functions de validação os dados básicos.
2) INICIALIZAÇÕES. Todo retorno das validações e function deve ser inicializado com S. É muito melhor gerar uma
ocorrência indevidamente do que deixar de gerar.
3) COMMIT. O commit só pode ser feito quando for por para mais de uma conta (importação XML por exemplo)
devvido a cache e lock.
4) ATOMIZAÇÃO. A procedure deve ser o mais legível possível, deve conter nela apenas vetores e chamadas para
outras rotinas, nenhum select individual ou comando DML individual.

Alterações:
-------------------------------------------------------------------------------------------------------------------
 dlehmkuhl OS 688483 - 31/03/2014

Alteração:	Reestruturação geral da rotina para não utilizar dbms_sql e atender a questão de um filtro de exceção
	levar ou não em consideração todo o atendimento da conta.

Motivo:	dbms_sql tem se mostrado instável em diversas situações e então vamos aproveitar o momento para reescrever
	a rotina com maior foco em performance, já que com a possível inclusão de todas as contas no atendimento a
	performance será mais desafiada.
-------------------------------------------------------------------------------------------------------------------
jjung OS 727371 - 22/04/2014

Alteração:	Adicionado o teste para verificar se o cursor continua aberto antes de fechar o mesmo
	no tratamento de exceção.

Motivo:	Se o mesmo já estiver fechado quando o erro ocorrer será lançado um erro no tratamento
	de exceção e não será efetuado o log e limpeza da tabela de seleção.
-------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 782891 - 05/09/2014

Alteração:	Adicionado o parâmetro nr_seq_analise_p no lugar do nr_seq_partic_p pois o mesmo dificilmente
	será utilizado.

Motivo:	Atomização da validação que estava sendo feita por conta durante o processo de reconsistência da análise.
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* IE_EVENTO_P
	CC - Consistência conta
	IMP - Importação XML
	PW - Potal Web
*/
/* IE_PORTAL_WEB_P
	A - Ambos
	CG - Complemento de Guias
	DC - Digitação de Conta
*/
ds_sql_ocor_w			varchar(5000);
dados_sql_regra_ocor_w		pls_tipos_ocor_pck.dados_sql_regra_ocor;
dados_forma_geracao_ocor_w	pls_tipos_ocor_pck.dados_forma_geracao_ocor;
bind_sql_valor_w		sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;

nr_id_transacao_w		pls_selecao_ocor_cta.nr_id_transacao%type;
dados_ocor_w			pls_tipos_ocor_pck.dados_ocor;
dados_regra_w			pls_tipos_ocor_pck.dados_regra;
dados_consistencia_w		pls_tipos_ocor_pck.dados_consistencia;

qt_registro_w			integer;
nr_id_transacao_log_w		pls_oc_cta_log_ocor.nr_id_transacao%type;
ie_conta_sem_proc_mat_w		varchar(1);
dt_inicio_execucao_regra_w	timestamp;
ie_gravar_log_ocor_w		pls_visible_false.ie_gravar_log_ocor%type;


BEGIN

--Inicializações
dados_ocor_w.nr_sequencia	:= null;
nr_id_transacao_log_w 		:= nr_id_transacao_log_p;

select	coalesce(max(ie_gravar_log_ocor),'N')
into STRICT	ie_gravar_log_ocor_w
from	pls_visible_false;

if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') or (nr_seq_lote_conta_p IS NOT NULL AND nr_seq_lote_conta_p::text <> '') or (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') or (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') or (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '')	then

	-- Gera os dados temporários sobre todos os prestadores pertinentes na validação
	if (coalesce(ie_tipo_excecao_p::text, '') = '') then

		CALL pls_alimenta_tb_tmp.alimenta_prest_cta_tmp(	nr_seq_lote_conta_p,
								nr_seq_protocolo_p,
								nr_seq_conta_p,
								nr_seq_lote_processo_p,
								nr_seq_analise_p);
	end if;

	--Atualizar os dados da consistencia para que os mesmos sejam passados para as outras rotinas de uma  vez só
	dados_consistencia_w.nr_seq_lote		:= nr_seq_lote_conta_p;
	dados_consistencia_w.nr_seq_protocolo		:= nr_seq_protocolo_p;
	dados_consistencia_w.nr_seq_lote_processo	:= nr_seq_lote_processo_p;
	dados_consistencia_w.nr_seq_conta		:= nr_seq_conta_p;
	dados_consistencia_w.nr_seq_conta_proc		:= nr_seq_conta_proc_p;
	dados_consistencia_w.nr_seq_conta_mat		:= nr_seq_conta_mat_p;
	dados_consistencia_w.nr_seq_participante	:= null;
	dados_consistencia_w.nr_seq_analise		:= nr_seq_analise_p;

	-- Alimentar os dados da forma de geração para disseminá-los para as demais rotinas.
	dados_forma_geracao_ocor_w.ie_evento		:= ie_evento_p;
	dados_forma_geracao_ocor_w.ie_portal_web	:= ie_portal_web_p;
	dados_forma_geracao_ocor_w.cd_estabelecimento	:= cd_estabelecimento_p;
	dados_forma_geracao_ocor_w.cd_acao_analise	:= cd_acao_analise_p;
	dados_forma_geracao_ocor_w.nr_id_transacao	:= nr_id_transacao_p;
	dados_forma_geracao_ocor_w.nr_seq_combinada	:= nr_seq_combinada_p;
	dados_forma_geracao_ocor_w.nr_seq_ocorrencia	:= nr_seq_ocorrencia_p;
	dados_forma_geracao_ocor_w.ie_tipo_excecao	:= ie_tipo_excecao_p;

	-- isso só precisa ser processado apenas uma vez, por isso essa condição
	if (coalesce(ie_conta_sem_proc_mat_p::text, '') = '') then
		-- verifica se tem contas sem itens
		ie_conta_sem_proc_mat_w := pls_tipos_ocor_pck.obter_conta_sem_proc_mat(	nr_seq_lote_conta_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
											nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p,
											nr_seq_analise_p, cd_estabelecimento_p, 'T');
	else
		ie_conta_sem_proc_mat_w := ie_conta_sem_proc_mat_p;
	end if;

	-- Obter as restrições para que seja apenas processadas as regras coforme a forma de geração que está sendo executada.
	bind_sql_valor_w := pls_tipos_ocor_pck.obter_restricao_regra(	dados_forma_geracao_ocor_w, nr_id_transacao_p, ie_incidencia_regra_p, dados_consistencia_w, 'N', bind_sql_valor_w);
	-- Montar o select para buscar as regras
	-- por segurança foi deixado um nvl nas datas de vigência
	-- isso foi feito para previnir casos onde o cliente não leu o news e não rodou o baca para atualizar as vigências
	-- no futuro esse nvl pode ser retirado e deixar selecionando apenas os campos _ref
	ds_sql_ocor_w :=	'select	regra.nr_sequencia, ' || pls_util_pck.enter_w ||
				'	regra.nr_seq_ocorrencia, ' || pls_util_pck.enter_w ||
				'	regra.cd_estabelecimento, ' || pls_util_pck.enter_w ||
				'	val.cd_validacao ie_validacao, ' || pls_util_pck.enter_w ||
				'	regra.ie_evento, ' || pls_util_pck.enter_w ||
				'	regra.ie_portal_web, ' || pls_util_pck.enter_w ||
				'	regra.ie_primeira_verificacao, ' || pls_util_pck.enter_w ||
				'	regra.ie_utiliza_filtro, ' || pls_util_pck.enter_w ||
				'	regra.ie_aplicacao_ocorrencia, ' || pls_util_pck.enter_w ||
				'	nvl(regra.dt_inicio_vigencia_ref, regra.dt_inicio_vigencia) dt_inicio, ' || pls_util_pck.enter_w ||
				'	nvl(regra.dt_fim_vigencia_ref, regra.dt_fim_vigencia) dt_fim, ' || pls_util_pck.enter_w ||
				'	ocor.nr_seq_motivo_glosa, ' || pls_util_pck.enter_w ||
				'	regra.ie_excecao,' || pls_util_pck.enter_w ||
				'	''N'' ie_conta_sem_item' || pls_util_pck.enter_w ||
				dados_sql_regra_ocor_w.ds_campos || pls_util_pck.enter_w ||
				'from	pls_oc_cta_combinada		regra, ' || pls_util_pck.enter_w ||
				'	pls_oc_cta_tipo_validacao	val, ' || pls_util_pck.enter_w ||
				'	pls_ocorrencia			ocor' ||
				dados_sql_regra_ocor_w.ds_tabelas || pls_util_pck.enter_w ||
				'where	val.nr_sequencia = regra.nr_seq_tipo_validacao ' || pls_util_pck.enter_w ||
				'and	ocor.nr_sequencia = regra.nr_seq_ocorrencia ' || pls_util_pck.enter_w ||
				'and	ocor.ie_situacao = ''A''  ' || pls_util_pck.enter_w ||
				'and	ocor.ie_regra_combinada = ''S'' ' || pls_util_pck.enter_w ||
				'and	((regra.ie_excecao is null) or (regra.ie_excecao  = ''N'') or sysdate between nvl(regra.dt_inicio_vigencia_ref, regra.dt_inicio_vigencia) and nvl(regra.dt_fim_vigencia_ref, regra.dt_fim_vigencia)) ' || pls_util_pck.enter_w ||
				dados_sql_regra_ocor_w.ds_restricao;

	-- se tem conta sem proc e sem mat, deve executar novamente a mesma regra tendo a conta como sendo a aplicação dos filtros
	-- por isso do union
	if (ie_conta_sem_proc_mat_w = 'S') then

		bind_sql_valor_w.delete;
		-- Obter as restrições para que seja apenas para processar contas que não possuam itens
		bind_sql_valor_w := pls_tipos_ocor_pck.obter_restricao_regra(	dados_forma_geracao_ocor_w, nr_id_transacao_p, ie_incidencia_regra_p, dados_consistencia_w, 'S', bind_sql_valor_w);

		-- por segurança foi deixado um nvl nas datas de vigência
		-- isso foi feito para previnir casos onde o cliente não leu o news e não rodou o baca para atualizar as vigências
		-- no futuro esse nvl pode ser retirado e deixar selecionando apenas os campos _ref
		ds_sql_ocor_w := ds_sql_ocor_w || pls_util_pck.enter_w || 'union all' || pls_util_pck.enter_w ||
				'select	regra.nr_sequencia, ' || pls_util_pck.enter_w ||
				'	regra.nr_seq_ocorrencia, ' || pls_util_pck.enter_w ||
				'	regra.cd_estabelecimento, ' || pls_util_pck.enter_w ||
				'	val.cd_validacao ie_validacao, ' || pls_util_pck.enter_w ||
				'	regra.ie_evento, ' || pls_util_pck.enter_w ||
				'	regra.ie_portal_web, ' || pls_util_pck.enter_w ||
				'	regra.ie_primeira_verificacao, ' || pls_util_pck.enter_w ||
				'	regra.ie_utiliza_filtro, ' || pls_util_pck.enter_w ||
				'	regra.ie_aplicacao_ocorrencia, ' || pls_util_pck.enter_w ||
				'	nvl(regra.dt_inicio_vigencia_ref, regra.dt_inicio_vigencia) dt_inicio, ' || pls_util_pck.enter_w ||
				'	nvl(regra.dt_fim_vigencia_ref, regra.dt_fim_vigencia) dt_fim, ' || pls_util_pck.enter_w ||
				'	ocor.nr_seq_motivo_glosa, ' || pls_util_pck.enter_w ||
				'	regra.ie_excecao,' || pls_util_pck.enter_w ||
				'	''S'' ie_conta_sem_item' || pls_util_pck.enter_w ||
				dados_sql_regra_ocor_w.ds_campos || pls_util_pck.enter_w ||
				'from	pls_oc_cta_combinada		regra, ' || pls_util_pck.enter_w ||
				'	pls_oc_cta_tipo_validacao	val, ' || pls_util_pck.enter_w ||
				'	pls_ocorrencia			ocor' ||
				dados_sql_regra_ocor_w.ds_tabelas || pls_util_pck.enter_w ||
				'where	val.nr_sequencia = regra.nr_seq_tipo_validacao ' || pls_util_pck.enter_w ||
				'and	ocor.nr_sequencia = regra.nr_seq_ocorrencia ' || pls_util_pck.enter_w ||
				'and	ocor.ie_situacao = ''A''  ' || pls_util_pck.enter_w ||
				'and	ocor.ie_regra_combinada = ''S'' ' || pls_util_pck.enter_w ||
				'and	sysdate between nvl(regra.dt_inicio_vigencia_ref, regra.dt_inicio_vigencia) and nvl(regra.dt_fim_vigencia_ref, regra.dt_fim_vigencia) ' || pls_util_pck.enter_w ||
				dados_sql_regra_ocor_w.ds_restricao;
	end if;

	-- executa o comando e devolve o cursor
	bind_sql_valor_w := sql_pck.executa_sql_cursor(	ds_sql_ocor_w, bind_sql_valor_w);

	loop
		fetch cursor_w
		into 	dados_regra_w.nr_sequencia, dados_regra_w.nr_seq_ocorrencia, dados_regra_w.cd_estabelecimento,
			dados_regra_w.ie_validacao, dados_regra_w.ie_evento, dados_regra_w.ie_portal_web,
			dados_regra_w.ie_primeira_verificacao, dados_regra_w.ie_utiliza_filtro, dados_regra_w.ie_aplicacao_ocorrencia,
			dados_regra_w.dt_inicio_vigencia, dados_regra_w.dt_fim_vigencia, dados_ocor_w.nr_seq_motivo_glosa,
			dados_regra_w.ie_excecao, dados_regra_w.ie_conta_sem_item, dados_regra_w.ie_incidencia_selecao;
		EXIT WHEN NOT FOUND; /* apply on cursor_w */

		-- para buscar uma nova transação para cada regra pai boa
		-- feito aqui pois não posso colocar no select acima (que retorna as regras)  porque uso um union all que impede que isso aconteça (erro ORA)
		if (coalesce(nr_id_transacao_p::text, '') = '') then
			select	nextval('pls_selecao_ocor_cta_seq')
			into STRICT	nr_id_transacao_w
			;
		else
			nr_id_transacao_w := nr_id_transacao_p;
		end if;

		-- gravar o início da execução da regra para no final termos o tempo total
		dt_inicio_execucao_regra_w := clock_timestamp();

		-- Atualizar a variável dos dados da ocorrência com o valor da sequência da ocorrência.
		dados_ocor_w.nr_sequencia := dados_regra_w.nr_seq_ocorrencia;

		begin
			-- Essa procedure é responsável por inserir registros na tabela PLS_SELECAO_OCOR_CTA
			-- para que o cursor das contas e dos itens seja válido
			CALL pls_tipos_ocor_pck.gerencia_aplicacao_filtro(	dados_consistencia_w,
									dados_regra_w,
									dados_forma_geracao_ocor_w,
									nr_id_transacao_w,
									nm_usuario_p,
									cd_estabelecimento_p);
			commit;

			-- obtém a quantidade de registros que estão válidos na tabela de seleção
			qt_registro_w := pls_tipos_ocor_pck.obter_qt_registro_valido(nr_id_transacao_w);

			-- se retornar registro aplica as validações, senão nem precisa fazer nada
			if (qt_registro_w > 0) then

				-- Aplica-se a validação selecionada na regra. A validação será em cima dos registros da tabela de seleção apenas.
				-- A validação não irá em nenhum momento inserir registros na tabela de seleção, ela apenas elimina os valores que não se encaixarem em alguma situação tratada
				-- na validação.
				CALL pls_oc_cta_aplica_validacao(	dados_regra_w, nr_id_transacao_w, dados_forma_geracao_ocor_w,
								cd_estabelecimento_p, nm_usuario_p);
				commit;

				if (coalesce(ie_tipo_excecao_p::text, '') = '') then

					-- Nesta chamada recursiva serão verificadas as exceções da regra para remover os registros que não devem ser gerada a ocorrência
					CALL pls_oc_cta_gerar_combinada(	null, null, nr_seq_lote_conta_p,
									nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p,
									nr_seq_conta_proc_p, nr_seq_conta_mat_p, nr_seq_analise_p,
									cd_acao_analise_p, 'ER', nr_id_transacao_w,
									dados_regra_w.nr_sequencia, null, cd_estabelecimento_p,
									nm_usuario_p, nr_id_transacao_log_w, dados_regra_w.ie_incidencia_selecao);
					commit;

					-- Nesta chamada recursiva serão verificadas as exceções da ocorrência, para cada regra da ocorrência serão verificadas todas as regras
					-- de exceção da ocorrência.
					CALL pls_oc_cta_gerar_combinada(	ie_evento_p, ie_portal_web_p, nr_seq_lote_conta_p,
									nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p,
									nr_seq_conta_proc_p, nr_seq_conta_mat_p, nr_seq_analise_p,
									cd_acao_analise_p, 'EG', nr_id_transacao_w,
									null, dados_regra_w.nr_seq_ocorrencia, cd_estabelecimento_p,
									nm_usuario_p, nr_id_transacao_log_w, dados_regra_w.ie_incidencia_selecao);
					commit;


					-- Aqui serão verificados os registro que estão na tabela de seleção e gera ou reativa a ocorrência para o item. Será trabalhado apenas com os registros da seleção.
					-- Aqui dentro da rotina será verificado se a ocorrência é para gerar por conta ou por item.
					CALL pls_tipos_ocor_pck.gravar_ocorrencias_regra(	nr_id_transacao_w, dados_regra_w, dados_ocor_w,
											cd_acao_analise_p, cd_estabelecimento_p, nm_usuario_p);
					commit;
				end if;
			end if;

			if (coalesce(ie_tipo_excecao_p::text, '') = '') then
				-- Elimina todos os registos da tabela temporária de controle de itens de contas que caíram em alguma
				-- regra de exceção
				CALL pls_tipos_ocor_pck.limpar_transacao(nr_id_transacao_w);
			end if;

		exception
		when others then

			-- Fechar o cursor se ele tiver aberto. Como o trata_erro_sql_dinamico vai dar um abort então não tem problema
			-- ele tem que ser fechado.
			if (cursor_w%isopen) then

				close cursor_w;
			end if;

			-- se algo der errado, elimina todos os registos da tabela de selecao para a transacao atual.
			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(	dados_regra_w, sqlerrm || pls_util_pck.enter_w ||
									dbms_utility.format_error_backtrace, nr_id_transacao_w, nm_usuario_p, ie_gravar_log_ocor_w);
		end;

		-- faz as tratativas para gravação final dos dados da regra
		nr_id_transacao_log_w := pls_tipos_ocor_pck.registra_tempo_execucao_regra(	dt_inicio_execucao_regra_w, clock_timestamp(), dados_consistencia_w, dados_regra_w, nm_usuario_p, 'N', nr_id_transacao_log_w);
	end loop; -- Regras de ocorrência;
	close cursor_w;

	if (coalesce(ie_tipo_excecao_p::text, '') = '') then
		-- para terminar de gravar os registros de tempos da ocorrência combinada
		-- se sobraram registros para serem gravados grava aqui
		nr_id_transacao_log_w := pls_tipos_ocor_pck.registra_tempo_execucao_regra(	null, null, null, null, null, 'S', nr_id_transacao_log_w);
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_gerar_combinada ( ie_evento_p text, ie_portal_web_p text, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, ie_tipo_excecao_p text, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_id_transacao_log_p pls_oc_cta_log_ocor.nr_id_transacao%type default null, ie_incidencia_regra_p text default null, ie_conta_sem_proc_mat_p text default null) FROM PUBLIC;
