-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.aplica_filtro_padrao ( dados_consistencia_p pls_tipos_ocor_pck.dados_consistencia, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_forma_geracao_ocor_p pls_tipos_ocor_pck.dados_forma_geracao_ocor, dados_filtro_p dados_filtro, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Responsavel por gravar na tabela de selecao todos os registros necessarios para o
processamento de regras que nao utilizam fitros, que contem apenas validacoes.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


-- Declaracao das colecoes. E necessario trabalhar com este tipo de dado quando utiliza-se o FORALL, para que

-- todos os dados da colecao sejam enviados em apenas uma mudanca de contexto PL\SQL - SQL e SQL - PL\SQL novamente.

tb_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_seq_conta_proc_w	pls_util_cta_pck.t_number_table;
tb_seq_conta_mat_w	pls_util_cta_pck.t_number_table;
tb_guia_referencia_w	pls_util_cta_pck.t_varchar2_table_20;
tb_seq_segurado_w	pls_util_cta_pck.t_number_table;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_dt_item_w		pls_util_cta_pck.t_date_table;
tb_dt_item_hora_ini_w	pls_util_cta_pck.t_date_table;
tb_dt_item_hora_fim_w	pls_util_cta_pck.t_date_table;
tb_dt_item_dia_ini_w	pls_util_cta_pck.t_date_table;
tb_dt_item_dia_fim_w	pls_util_cta_pck.t_date_table;
tb_ie_origem_proced_w	pls_util_cta_pck.t_number_table;
tb_cd_procedimento_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_material_w	pls_util_cta_pck.t_number_table;

ds_select_w		varchar(8000);
valor_bind_w		sql_pck.t_dado_bind;
dados_restricao_w	pls_tipos_ocor_pck.dados_select;
cursor_w		sql_pck.t_cursor;


BEGIN

-- Deve ser passado uma regra valida para que a alteracao seja feita.

if (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '') then

	-- inicializa as variaveis tudo com null porque para filtros padrao nao existe necessidade de filtrar nada nesse nivel

	dados_restricao_w.ds_campos := null;
	dados_restricao_w.ds_tabelas := null;
	dados_restricao_w.ds_restricao := null;

	begin
		-- Montar o select padrao juntamente as restricoes.

		valor_bind_w := pls_tipos_ocor_pck.obter_select_filtro(	false, nr_id_transacao_p, dados_consistencia_p, dados_regra_p, dados_forma_geracao_ocor_p, dados_filtro_p, dados_restricao_w, dados_restricao_w, dados_restricao_w, cd_estabelecimento_p, valor_bind_w);
		-- executa o comando sql com os respectivos binds

		valor_bind_w := sql_pck.executa_sql_cursor(	ds_select_w, valor_bind_w);

		loop
			fetch cursor_w bulk collect into	tb_seq_conta_w, tb_seq_conta_proc_w,
								tb_seq_conta_mat_w, tb_guia_referencia_w,
								tb_seq_segurado_w, tb_dt_item_w,
								tb_dt_item_hora_ini_w, tb_dt_item_hora_fim_w,
								tb_dt_item_dia_ini_w, tb_dt_item_dia_fim_w,
								tb_ie_origem_proced_w, tb_cd_procedimento_w,
								tb_nr_seq_material_w, tb_seq_selecao_w
			limit pls_util_pck.qt_registro_transacao_w;
			exit when tb_seq_conta_w.count = 0;

			-- Insere todos os registros das listas na tabela de selecao

			CALL CALL CALL CALL CALL pls_tipos_ocor_pck.gerencia_selecao_filtro(	'FP', tb_seq_conta_w,
							tb_seq_conta_proc_w, tb_seq_conta_mat_w,
							tb_guia_referencia_w, tb_seq_segurado_w,
							tb_dt_item_w, tb_dt_item_hora_ini_w,
							tb_dt_item_hora_fim_w, tb_dt_item_dia_ini_w,
							tb_dt_item_dia_fim_w, tb_ie_origem_proced_w,
							tb_cd_procedimento_w, tb_nr_seq_material_w,
							tb_seq_selecao_w, nr_id_transacao_p,
							'S', nm_usuario_p,
							dados_filtro_p, dados_regra_p);
		end loop;
		close cursor_w;

	exception
	when others then
		if (cursor_w%isopen) then
			close cursor_w;
		end if;
		-- Exibir a mensagem padrao para as ocorrencias combinadas quando temos algum problema e salvar o log no banco.

		CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p, ds_select_w, nr_id_transacao_p, nm_usuario_p);
	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.aplica_filtro_padrao ( dados_consistencia_p pls_tipos_ocor_pck.dados_consistencia, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_forma_geracao_ocor_p pls_tipos_ocor_pck.dados_forma_geracao_ocor, dados_filtro_p dados_filtro, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;