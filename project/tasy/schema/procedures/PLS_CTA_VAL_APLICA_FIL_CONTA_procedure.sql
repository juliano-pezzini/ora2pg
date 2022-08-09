-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cta_val_aplica_fil_conta ( dados_regra_p pls_tipos_cta_val_pck.dados_regra, dados_filtro_p pls_tipos_cta_val_pck.dados_filtro, dados_consistencia_p pls_tipos_cta_val_pck.dados_consistencia, nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


PERFORM_completo_w	varchar(4000);
dados_restricao_w	pls_tipos_cta_val_pck.dados_restricao_select;

ret_null_w		varchar(1);

var_cur_w 		integer;
var_exec_w		integer;
var_retorno_w		integer;

qt_cnt_w		integer;
nr_seq_conta_w		dbms_sql.number_table;
nr_seq_conta_proc_w	dbms_sql.number_table;
nr_seq_selecao_w	dbms_sql.clob_table;

dados_filtro_conta_w	pls_tipos_cta_val_pck.dados_filtro_conta;

-- Dados da PLS_OC_CTA_FILTRO_CONTA responsável por armazenar os dados dos filtros criados pelos usuários
c_filtro CURSOR(nr_seq_filtro_pc	pls_rp_cta_filtro.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_origem_conta
	from	pls_rp_cta_filtro_conta a
	where	a.nr_seq_rp_cta_filtro	= nr_seq_filtro_pc
	and	a.ie_situacao	= 'A';

BEGIN

-- Se não tiver informações da regra não será possível aplicar os filtros.
if (dados_filtro_p.nr_sequencia IS NOT NULL AND dados_filtro_p.nr_sequencia::text <> '') then

	-- Obter o controle padrão para quantidade de registros que será enviada a cada vez para a tabela de seleção.
	qt_cnt_w := pls_cta_consistir_pck.qt_registro_transacao_w;

	-- Atualizar o campo ie_valido_temp para N  na tabela PLS_SELECAO_OCOR_CTA  para todos os registros.
	CALL pls_tipos_cta_val_pck.atualiza_sel_ie_valido_temp(nr_id_transacao_p, dados_filtro_p, 'F');

	-- Abrir vetor com todas as combinações de filtro da regra
	for r_c_filtro in c_filtro(dados_filtro_p.nr_sequencia) loop

		-- Preencher dados do filtro para passar como parâmetro
		dados_filtro_conta_w.nr_sequencia		:= r_c_filtro.nr_sequencia;
		dados_filtro_conta_w.ie_origem_conta		:= r_c_filtro.ie_origem_conta;
		-- Obter restrições
		dados_restricao_w := pls_val_cta_obter_restr_padrao(	'RESTRICAO', dados_consistencia_p, nr_id_transacao_p,
									null, dados_filtro_p, cd_estabelecimento_p,
									nm_usuario_p);

		-- Como a restrição por conta é aplicável para o nível de conta então a restrição montada pelo filtro será aplicada juntamente com a restrição padrão por conta, pois conforme
		-- a regra de granularidade eliminando a conta não precisamos verificar os itens, portanto cada tipo de filtro deve ser aplicado ao seu nível.
		dados_restricao_w.ds_restricao_conta	:= dados_restricao_w.ds_restricao_conta ||
							pls_cta_val_obter_restr_conta(	'RESTRICAO', var_cur_w,
											dados_filtro_conta_w);
		-- Montar select
		PERFORM_completo_w	:= pls_tipos_cta_val_pck.pls_val_cta_montar_sel_pad(dados_restricao_w, nm_usuario_p);

		var_cur_w := dbms_sql.open_cursor;

		begin
			-- Criar cursor com o sql dinâmico
			dbms_sql.parse(var_cur_w, select_completo_w, 1);

			-- Trocar BINDS
			-- Do select original
			dados_restricao_w := pls_val_cta_obter_restr_padrao(	'BINDS', dados_consistencia_p, nr_id_transacao_p,
										var_cur_w, dados_filtro_p, cd_estabelecimento_p,
										nm_usuario_p);
			-- Dos Filtros
			ret_null_w := pls_cta_val_obter_restr_conta(	'BIND', var_cur_w,
									dados_filtro_conta_w);

			-- Definir para o DBMS_SQL que o retorno do select será  preenchido em arrays, definindo a quantidade de linhas que o array terá a cada iteração do loop
			-- e a posição inicial que estes ocuparão no array.
			dbms_sql.define_array(var_cur_w, 1, nr_seq_conta_w, qt_cnt_w, 1);
			dbms_sql.define_array(var_cur_w, 2, nr_seq_conta_proc_w, qt_cnt_w, 1);
			dbms_sql.define_array(var_cur_w, 3, nr_seq_selecao_w, qt_cnt_w, 1);

			var_exec_w := dbms_sql.execute(var_cur_w);
			loop
			-- O fetch rows irá preencher os buffers do Oracle com as linhas que serão passadas para a lista quando o COLUMN_VALUE for chamado.
			var_retorno_w := dbms_sql.fetch_rows(var_cur_w);

				-- zerar as listas para que o mesmo valor não seja inserido mais de uma vez na tabela.
				nr_seq_conta_w		:= pls_util_cta_pck.num_table_vazia_w;
				nr_seq_conta_proc_w	:= pls_util_cta_pck.num_table_vazia_w;
				nr_seq_selecao_w	:= pls_util_cta_pck.clob_table_vazia_w;

				-- Obter as listas que foram populadas.
				dbms_sql.column_value(var_cur_w, 1, nr_seq_conta_w);
				dbms_sql.column_value(var_cur_w, 2, nr_seq_conta_proc_w);
				dbms_sql.column_value(var_cur_w, 3, nr_seq_selecao_w);

				-- Gravar na tabela de seleção as contas selecionadas
				CALL pls_tipos_cta_val_pck.gerencia_selecao(	nr_id_transacao_p, nr_seq_conta_w, nr_seq_conta_proc_w,
									nr_seq_selecao_w, 'S', nm_usuario_p,
									'F', dados_filtro_p);

				-- Quando número de linhas que foram aplicadas no array for diferente do definido significa que esta foi a última iteração do loop e que todas as linhas foram
				-- passadas.
				exit when var_retorno_w != qt_cnt_w;
			end loop; -- Contas filtradas
		exception
			when others then

			-- Tratar erro gerado no sql dinâmico, será inserido registro no log e abortado o processo exibindo mensagem de erro.
			CALL pls_tipos_cta_val_pck.trata_erro_sql_dinamico(	dados_regra_p, select_completo_w,
									nr_id_transacao_p, nm_usuario_p);
		end;
		dbms_sql.close_cursor(var_cur_w);
	end loop; -- filtro
	-- Atualiza o campo ie_valido da tabela PLS_SELECAO_OCOR_CTA para N aonde o ie_valido_temp continuar N
	CALL pls_tipos_cta_val_pck.atualiza_sel_ie_valido(	nr_id_transacao_p, dados_filtro_p, 'F');
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_val_aplica_fil_conta ( dados_regra_p pls_tipos_cta_val_pck.dados_regra, dados_filtro_p pls_tipos_cta_val_pck.dados_filtro, dados_consistencia_p pls_tipos_cta_val_pck.dados_consistencia, nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
