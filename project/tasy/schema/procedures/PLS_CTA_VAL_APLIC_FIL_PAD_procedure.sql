-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cta_val_aplic_fil_pad ( dados_consistencia_p pls_tipos_cta_val_pck.dados_consistencia, nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Responsável por aplicar os filtros padrões em regras que não utilizarem fitros.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Cuidar com os ALIAS... Dar nome padronizado, para facilitar identificação e não repetir..

Alterações:

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
var_cur_w 		integer;
var_exec_w		integer;
var_retorno_w		integer;
ds_select_w		varchar(4000);
dados_restricao_w	pls_tipos_cta_val_pck.dados_restricao_select;
ds_ret_null_w		varchar(1);

qt_cnt_w		integer;
nr_seq_conta_w		dbms_sql.number_table;
nr_seq_conta_proc_w	dbms_sql.number_table;
nr_seq_selecao_w	dbms_sql.clob_table;


BEGIN

-- Obter o select padrão conforme a incidencia da regra.
dados_restricao_w	:= pls_val_cta_obter_restr_padrao(	'RESTRICAO', dados_consistencia_p, nr_id_transacao_p,
								null, null, cd_estabelecimento_p, nm_usuario_p);

ds_select_w		:= pls_tipos_cta_val_pck.pls_val_cta_montar_sel_pad(dados_restricao_w, nm_usuario_p);

/* Selecionar todas as contas ou itens, conforme incidência */

var_cur_w := dbms_sql.open_cursor;

dbms_sql.parse(var_cur_w, ds_select_w, 1);

-- Atualizar o valor das binds dos selects padrão.
dados_restricao_w	:=	pls_val_cta_obter_restr_padrao(	'BINDS', dados_consistencia_p, nr_id_transacao_p,
								var_cur_w, null, cd_estabelecimento_p, nm_usuario_p);

qt_cnt_w := pls_cta_consistir_pck.qt_registro_transacao_w;

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
						'FP', null);

	-- Quando número de linhas que foram aplicadas no array for diferente do definido significa que esta foi a última iteração do loop e que todas as linhas foram
	-- passadas.
	exit when var_retorno_w != qt_cnt_w;
end loop;
dbms_sql.close_cursor(var_cur_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_val_aplic_fil_pad ( dados_consistencia_p pls_tipos_cta_val_pck.dados_consistencia, nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
