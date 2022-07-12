-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consist_carac_item_pck.buscar_procedimentos ( dados_regra_p dados_regra) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Ler a regra passada por parâmetro e processá-la, gravando o vínculo entre as
	regras e os procedimentos liberados na tabela PLS_CONTA_PROC_REGRA_LIB.
	Irá buscar os procedimentos da conta ou protocolo ou ainda de um lote inteiro,
	conforme passado por parâmetro.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações
-------------------------------------------------------------------------------------------------------------------
jjung OS 629123 - 11/11/2013 -  Criação da procedure.
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_sql_w		varchar(4000);

var_cur_w 		integer;
var_exec_w		integer;
var_retorno_w		integer;

dados_restricao_w	dados_restricao;


BEGIN

-- Obter a restrição que será montada para buscar os procedimentos liberados para a regra.
dados_restricao_w := pls_cta_consist_carac_item_pck.obter_restricao_alimentacao('RESTRICAO', var_cur_w, 'P', dados_regra_p);

-- Só faz o select na PLS_CONTA_PROC_V  se tiver alguma restricção montada. Se não existir significa que deu algum problema na montagem da restrição.
if	(((dados_restricao_w.ds_restricao_lote IS NOT NULL AND dados_restricao_w.ds_restricao_lote::text <> '') or
	(dados_restricao_w.ds_restricao_protocolo IS NOT NULL AND dados_restricao_w.ds_restricao_protocolo::text <> '') or
	(dados_restricao_w.ds_restricao_conta IS NOT NULL AND dados_restricao_w.ds_restricao_conta::text <> '') or
	(dados_restricao_w.ds_restricao_lote_processo IS NOT NULL AND dados_restricao_w.ds_restricao_lote_processo::text <> '') or
	(dados_restricao_w.ds_restricao_proc IS NOT NULL AND dados_restricao_w.ds_restricao_proc::text <> '')) and
	(dados_restricao_w.ds_campos_sql IS NOT NULL AND dados_restricao_w.ds_campos_sql::text <> '')) then

	-- Montar o select com as restrições da regra.
	ds_sql_w :=	'select ' || dados_restricao_w.ds_campos_sql || pls_util_pck.enter_w ||
			'from	pls_conta_proc_v proc ' || pls_util_pck.enter_w ||
			'where	1 = 1 ' ||
			dados_restricao_w.ds_restricao_lote ||
			dados_restricao_w.ds_restricao_protocolo ||
			dados_restricao_w.ds_restricao_conta ||
			dados_restricao_w.ds_restricao_lote_processo ||
			dados_restricao_w.ds_restricao_proc;

	var_cur_w := dbms_sql.open_cursor;
	begin
		-- Fazer o parse no comando
		dbms_sql.parse(var_cur_w, ds_sql_w, 1);

		-- Atualizar o valor das binds para executar o comando.
		dados_restricao_w := pls_cta_consist_carac_item_pck.obter_restricao_alimentacao('BINDS', var_cur_w, 'P', dados_regra_p);

		-- Defifnir que o retorno do select será gravado em listas.
		dbms_sql.define_array(var_cur_w, 1, current_setting('pls_cta_consist_carac_item_pck.tb_proc_w')::dbms_sql.number_table, current_setting('pls_cta_consist_carac_item_pck.qt_reg_transacao_w')::integer, 1);
		dbms_sql.define_array(var_cur_w, 2, current_setting('pls_cta_consist_carac_item_pck.tb_mat_w')::dbms_sql.number_table, current_setting('pls_cta_consist_carac_item_pck.qt_reg_transacao_w')::integer, 1);
		dbms_sql.define_array(var_cur_w, 3, current_setting('pls_cta_consist_carac_item_pck.tb_regra_w')::dbms_sql.number_table, current_setting('pls_cta_consist_carac_item_pck.qt_reg_transacao_w')::integer, 1);
		dbms_sql.define_array(var_cur_w, 4, current_setting('pls_cta_consist_carac_item_pck.tb_regra_carac_w')::dbms_sql.number_table, current_setting('pls_cta_consist_carac_item_pck.qt_reg_transacao_w')::integer, 1);

		-- Executar o comando.
		var_exec_w := dbms_sql.execute(var_cur_w);
		loop
		-- O fetch rows irá preencher os buffers do Oracle com as linhas que serão passadas para a lista quando o COLUMN_VALUE for chamado.
		var_retorno_w := dbms_sql.fetch_rows(var_cur_w);

			-- Zerar as listas a cada execução. para que o mesmo registro não seja gravado novamente na tabela.
			CALL CALL pls_cta_consist_carac_item_pck.limpar_listas();

			-- Obter as listas que foram populadas.
			dbms_sql.column_value(var_cur_w, 1, current_setting('pls_cta_consist_carac_item_pck.tb_proc_w')::dbms_sql.number_table);
			dbms_sql.column_value(var_cur_w, 2, current_setting('pls_cta_consist_carac_item_pck.tb_mat_w')::dbms_sql.number_table);
			dbms_sql.column_value(var_cur_w, 3, current_setting('pls_cta_consist_carac_item_pck.tb_regra_w')::dbms_sql.number_table);
			dbms_sql.column_value(var_cur_w, 4, current_setting('pls_cta_consist_carac_item_pck.tb_regra_carac_w')::dbms_sql.number_table);

			-- Grava as listas no banco em um único comando DML.
			CALL pls_cta_consist_carac_item_pck.gravar_listas();

			-- Quando número de linhas que foram aplicadas no array for diferente do definido significa que esta foi a última iteração do loop e que todas as linhas foram
			-- passadas.
			exit when var_retorno_w != current_setting('pls_cta_consist_carac_item_pck.qt_reg_transacao_w')::integer;
		end loop; -- Contas filtradas
		dbms_sql.close_cursor(var_cur_w);
	exception
		when others then

		-- Fechar os cursores que continuam abertos, os cursores que utilizam FOR - LOOP não necessitam serem fechados, serão fechados automáticamente.
		dbms_sql.close_cursor(var_cur_w);

		-- Formata a mensagem de erro que será gerada para o usuário.
		CALL CALL pls_cta_consist_carac_item_pck.tratar_erro(ds_sql_w, null);
	end;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consist_carac_item_pck.buscar_procedimentos ( dados_regra_p dados_regra) FROM PUBLIC;