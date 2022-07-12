-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.aplica_filtro_protocolo_ex ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, nm_usuario_p usuario.nm_usuario%type, nr_id_transacao_ex_p pls_selecao_ex_ocor_cta.nr_id_transacao%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	gerencia a aplicacao do filtro de protocolo para todo atendimento em filtro de
	excecao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Nao incluir restricoes nessa procedure, ela e responsavel apenas  por passar no cursor
dos filtros e incluir na selecao das contas que devem ter a ocorrencia gerada.

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


tb_seq_selecao_w	pls_util_cta_pck.t_number_table;

dados_filtro_prot_w	pls_tipos_ocor_pck.dados_filtro_prot;
ds_select_w		varchar(8000);
valor_bind_w		sql_pck.t_dado_bind;
dados_restricao_w	pls_tipos_ocor_pck.dados_select;
cursor_w		sql_pck.t_cursor;

c_filtro CURSOR(	nr_seq_filtro_pc	pls_oc_cta_filtro.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_apresentacao,
		a.cd_versao_tiss,
		a.ie_guia_fisica_apresentada
	from	pls_oc_cta_filtro_prot a
	where	a.nr_seq_oc_cta_filtro	= nr_seq_filtro_pc
	and	a.ie_situacao = 'A';

BEGIN

-- Se nao tiver informacoes da regra nao sera possivel aplicar os filtros.

if (dados_filtro_p.nr_sequencia IS NOT NULL AND dados_filtro_p.nr_sequencia::text <> '') then

	-- Atualizar o campo auxiliar que sera utilizado para sinalizar os registros que foram processados

	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar_ex(nr_id_transacao_ex_p);

	-- Abrir vetor com todas as combinacoes de filtro da regra

	for r_c_filtro in c_filtro(dados_filtro_p.nr_sequencia) loop

		-- Preencher dados do filtro para passar como parametro

		dados_filtro_prot_w.nr_sequencia				:= r_c_filtro.nr_sequencia;
		dados_filtro_prot_w.ie_apresentacao				:= r_c_filtro.ie_apresentacao;
		dados_filtro_prot_w.cd_versao_tiss				:= r_c_filtro.cd_versao_tiss;
		dados_filtro_prot_w.ie_guia_fisica_apresentada	:= r_c_filtro.ie_guia_fisica_apresentada;

		begin
			-- restricao para todas as outras situacoes

			valor_bind_w := pls_tipos_ocor_pck.obter_restricao_protocolo(	dados_regra_p, dados_filtro_p, dados_filtro_prot_w, null, valor_bind_w);

			-- Montar o select padrao juntamente as restricoes.

			valor_bind_w := pls_tipos_ocor_pck.obter_select_filtro_ex(	dados_filtro_p, dados_restricao_w, nr_id_transacao_ex_p, valor_bind_w);

			-- executa o comando sql com os respectivos binds

			valor_bind_w := sql_pck.executa_sql_cursor(	ds_select_w, valor_bind_w);

			loop
				fetch cursor_w bulk collect into tb_seq_selecao_w
				limit pls_util_pck.qt_registro_transacao_w;
				exit when tb_seq_selecao_w.count = 0;

				-- Insere todos os registros das listas na tabela de selecao

				CALL pls_tipos_ocor_pck.gerencia_selecao_filtro_ex(	tb_seq_selecao_w, 'S', nm_usuario_p);

			end loop;
			close cursor_w;

		exception
			when others then

			if (cursor_w%isopen) then
				close cursor_w;
			end if;

			-- Tratar erro gerado no sql dinamico, sera inserido registro no log e abortado o processo exibindo mensagem de erro.

			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(	dados_regra_p, ds_select_w,
									null, nm_usuario_p);
		end;
	end loop;

	-- Atualizar o campo definitivo que sera utilizado para sinalizar os registros que foram processados

	CALL pls_tipos_ocor_pck.atualiza_campo_valido_ex(nr_id_transacao_ex_p);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.aplica_filtro_protocolo_ex ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, nm_usuario_p usuario.nm_usuario%type, nr_id_transacao_ex_p pls_selecao_ex_ocor_cta.nr_id_transacao%type) FROM PUBLIC;
