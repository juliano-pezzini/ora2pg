-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_gerar_combinada_imp ( nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, ie_tipo_excecao_p text, ie_incidencia_regra_p text, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Procedure exclusiva para ocorrências COMBINADAS de conta médica para importação XML
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
*/
ds_sql_ocor_w		varchar(8000);
bind_sql_valor_w	sql_pck.t_dado_bind;
ds_filtro_ocor_w	varchar(2500);
ds_campo_ocor_w		varchar(500);
ds_tabela_ocor_w	varchar(200);
cursor_w		sql_pck.t_cursor;

nr_seq_regra_w			pls_oc_cta_combinada.nr_sequencia%type;
nr_seq_ocorrencia_w		pls_ocorrencia.nr_sequencia%type;
cd_validacao_w			pls_oc_cta_tipo_validacao.cd_validacao%type;
ie_utiliza_filtro_w		pls_oc_cta_combinada.ie_utiliza_filtro%type;
ie_aplicacao_ocorrencia_w	pls_oc_cta_combinada.ie_aplicacao_ocorrencia%type;
dt_inicio_vigencia_w		pls_oc_cta_combinada.dt_inicio_vigencia%type;
dt_fim_vigencia_w		pls_oc_cta_combinada.dt_fim_vigencia%type;
nr_seq_motivo_glosa_w		pls_ocorrencia.nr_seq_motivo_glosa%type;
ie_excecao_w			pls_oc_cta_combinada.ie_excecao%type;
nr_id_transacao_w		pls_oc_cta_selecao_imp.nr_id_transacao%type;
ie_incidencia_selecao_w		varchar(5);

dt_inicio_processo_w	pls_oc_cta_log_tempo_imp.dt_inicio_processo%type;
qt_registro_w		integer;


BEGIN

-- se pelo menos um parâmetro for passado
if (nr_seq_lote_protocolo_p IS NOT NULL AND nr_seq_lote_protocolo_p::text <> '') or (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') or (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	-- Obter as restrições para que seja apenas processadas as regras coforme a forma de geração que está sendo executada.
	SELECT * FROM pls_ocor_imp_pck.obter_restricao_regra(	nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, ie_incidencia_regra_p, nr_id_transacao_p, nr_seq_combinada_p, nr_seq_ocorrencia_p, ie_tipo_excecao_p, cd_estabelecimento_p, bind_sql_valor_w) INTO STRICT _ora2pg_r;
 ds_campo_ocor_w := _ora2pg_r.ds_campo_p; ds_tabela_ocor_w := _ora2pg_r.ds_tabela_p; bind_sql_valor_w := _ora2pg_r.bind_sql_valor_p;

	-- Montar o select para buscar as regras
	ds_sql_ocor_w :=	'select	regra.nr_sequencia,' || pls_util_pck.enter_w ||
				'	regra.nr_seq_ocorrencia,' || pls_util_pck.enter_w ||
				'	val.cd_validacao,' || pls_util_pck.enter_w ||
				'	regra.ie_utiliza_filtro,' || pls_util_pck.enter_w ||
				'	regra.ie_aplicacao_ocorrencia,' || pls_util_pck.enter_w ||
				'	regra.dt_inicio_vigencia,' || pls_util_pck.enter_w ||
				'	regra.dt_fim_vigencia,' || pls_util_pck.enter_w ||
				'	ocor.nr_seq_motivo_glosa,' || pls_util_pck.enter_w ||
				'	nvl(regra.ie_excecao, ''N'') ie_excecao' || pls_util_pck.enter_w ||
				ds_campo_ocor_w || pls_util_pck.enter_w ||
				'from	pls_oc_cta_combinada		regra, ' || pls_util_pck.enter_w ||
				'	pls_oc_cta_tipo_validacao	val, ' || pls_util_pck.enter_w ||
				'	pls_ocorrencia			ocor' ||
				ds_tabela_ocor_w || pls_util_pck.enter_w ||
				'where	regra.ie_evento = ''IMP''' || pls_util_pck.enter_w ||
				'and	val.nr_sequencia = regra.nr_seq_tipo_validacao ' || pls_util_pck.enter_w ||
				'and	ocor.nr_sequencia = regra.nr_seq_ocorrencia ' || pls_util_pck.enter_w ||
				'and	ocor.ie_situacao = ''A''  ' || pls_util_pck.enter_w ||
				'and	ocor.ie_regra_combinada = ''S'' ' || pls_util_pck.enter_w ||
				ds_filtro_ocor_w;

	-- executa o comando e devolve o cursor
	bind_sql_valor_w := sql_pck.executa_sql_cursor(	ds_sql_ocor_w, bind_sql_valor_w);

	loop
		fetch cursor_w
		into 	nr_seq_regra_w, nr_seq_ocorrencia_w, cd_validacao_w,
			ie_utiliza_filtro_w, ie_aplicacao_ocorrencia_w, dt_inicio_vigencia_w,
			dt_fim_vigencia_w, nr_seq_motivo_glosa_w, ie_excecao_w,
			nr_id_transacao_w, ie_incidencia_selecao_w;
		EXIT WHEN NOT FOUND; /* apply on cursor_w */

		-- gravar o início da execução da regra para no final termos o tempo total
		dt_inicio_processo_w := clock_timestamp();

		begin

			-- Essa procedure é responsável por inserir registros na tabela PLS_SELECAO_OCOR_CTA
			-- para que o cursor das contas e dos itens seja válido
			CALL pls_ocor_imp_pck.gerencia_aplicacao_filtro(	nr_seq_lote_protocolo_p, nr_seq_protocolo_p,
									nr_seq_conta_p, nr_seq_conta_proc_p,
									nr_seq_conta_mat_p, nr_seq_ocorrencia_w,
									nr_seq_regra_w, dt_inicio_vigencia_w,
									dt_fim_vigencia_w, cd_validacao_w,
									ie_utiliza_filtro_w, ie_excecao_w,
									nr_id_transacao_w, ie_incidencia_selecao_w,
									cd_estabelecimento_p, nm_usuario_p);

			-- obtém a quantidade de registros que estão válidos na tabela de seleção
			qt_registro_w := pls_ocor_imp_pck.obter_qt_registro_valido(nr_id_transacao_w);

			-- se retornar registro aplica as validações, senão nem precisa fazer nada
			if (qt_registro_w > 0) then


				-- Aplica-se a validação selecionada na regra. A validação será em cima dos registros da tabela de seleção apenas.
				-- A validação não irá em nenhum momento inserir registros na tabela de seleção, ela apenas elimina os valores que não se encaixarem em alguma situação tratada
				-- na validação.
				CALL pls_oc_cta_aplica_valida_imp(	nr_seq_ocorrencia_w, nr_seq_regra_w,
								cd_validacao_w, ie_excecao_w,
								nr_id_transacao_w, cd_estabelecimento_p,
								nm_usuario_p);


				if (coalesce(ie_tipo_excecao_p::text, '') = '') then

					-- Nesta chamada recursiva serão verificadas as exceções da regra para remover os registros que não devem ser gerada a ocorrência
					CALL pls_oc_cta_gerar_combinada_imp(	nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p,
									nr_seq_conta_proc_p, nr_seq_conta_mat_p, 'ER',
									ie_incidencia_selecao_w, nr_id_transacao_w, nr_seq_regra_w,
									null, cd_estabelecimento_p, nm_usuario_p);

					-- Nesta chamada recursiva serão verificadas as exceções da ocorrência, para cada regra da ocorrência serão verificadas todas as regras
					-- de exceção da ocorrência.
					CALL pls_oc_cta_gerar_combinada_imp(	nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p,
									nr_seq_conta_proc_p, nr_seq_conta_mat_p, 'EG',
									ie_incidencia_selecao_w, nr_id_transacao_w, null,
									nr_seq_ocorrencia_w, cd_estabelecimento_p, nm_usuario_p);


					-- Aqui serão verificados os registro que estão na tabela de seleção e gera ou reativa a ocorrência para o item. Será trabalhado apenas com os registros da seleção.
					-- Aqui dentro da rotina será verificado se a ocorrência é para gerar por conta ou por item.
					CALL pls_ocor_imp_pck.gravar_ocorrencias_regra(	nr_id_transacao_w, nr_seq_ocorrencia_w,
											nr_seq_regra_w, cd_validacao_w,
											ie_aplicacao_ocorrencia_w, ie_utiliza_filtro_w,
											nm_usuario_p);
				end if;
			end if;

			if (coalesce(ie_tipo_excecao_p::text, '') = '') then
				-- Elimina todos os registos da tabela temporária de controle de itens de contas que caíram em alguma
				-- regra de exceção
				CALL pls_ocor_imp_pck.limpar_transacao(nr_id_transacao_w);
			end if;

		exception
		when others then

			-- Fechar o cursor se ele tiver aberto. Como o trata_erro_sql_dinamico vai dar um abort então não tem problema
			-- ele tem que ser fechado.
			if (cursor_w%isopen) then
				close cursor_w;
			end if;

			-- se algo der errado, elimina todos os registos da tabela de selecao para a transacao atual.
			CALL pls_ocor_imp_pck.trata_erro_sql_dinamico(	nr_seq_regra_w,
									nr_seq_ocorrencia_w,
									sqlerrm || pls_util_pck.enter_w || dbms_utility.format_error_backtrace,
									nr_id_transacao_w,
									nm_usuario_p,
									'N');
		end;

		-- faz as tratativas para gravação final dos dados da regra
		CALL pls_ocor_imp_pck.registra_tempo_execucao_regra(	nr_seq_lote_protocolo_p, nr_seq_protocolo_p,
								nr_seq_conta_p, nr_seq_conta_proc_p,
								nr_seq_conta_mat_p, nr_seq_regra_w,
								nr_seq_ocorrencia_w, dt_inicio_processo_w,
								clock_timestamp(), nm_usuario_p,
								'N');
	end loop;
	close cursor_w;

	if (coalesce(ie_tipo_excecao_p::text, '') = '') then
		-- para terminar de gravar os registros de tempos da ocorrência combinada
		-- se sobraram registros para serem gravados grava aqui
		CALL pls_ocor_imp_pck.registra_tempo_execucao_regra(	null, null, null, null, null, null,
								null, null, null, null,	'S');
		-- trata o agrupamento de ocorrências para a correta exibição no Portal
		CALL pls_ocor_imp_pck.pls_gerar_agrup_obs_ocor(	nr_seq_lote_protocolo_p, nr_seq_protocolo_p,
								nr_seq_conta_p, nr_seq_conta_proc_p,
								nr_seq_conta_mat_p, nm_usuario_p);
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_gerar_combinada_imp ( nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, ie_tipo_excecao_p text, ie_incidencia_regra_p text, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

