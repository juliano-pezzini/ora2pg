-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_preco_cta_pck.aplica_filtro_profissional ( ie_considera_selecao_p INOUT boolean, ie_tipo_profissional_p pls_cp_cta_filtro_prof.ie_medico%type, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, ie_destino_regra_p text, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, ie_excecao_p pls_cp_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_cp_cta_filtro.nr_sequencia%type, dt_inicio_vigencia_p pls_cp_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_cp_cta_combinada.dt_fim_vigencia%type, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ds_select_w		varchar(32000);
dados_restricao_w	varchar(10000);
ds_campos_w		varchar(1000);
valor_bind_w		sql_pck.t_dado_bind;
cursor_w		sql_pck.t_cursor;
qt_filtro_processado_w	integer;

tb_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_seq_conta_proc_w	pls_util_cta_pck.t_number_table;
tb_seq_conta_mat_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_partic_w	pls_util_cta_pck.t_number_table;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;

c_filtro CURSOR(	nr_seq_filtro_pc	pls_cp_cta_filtro.nr_sequencia%type,
			ie_tipo_profissional_pc	pls_cp_cta_filtro_prof.ie_medico%type) FOR
	SELECT	a.nr_sequencia,
		a.cd_medico
	from	pls_cp_cta_filtro_prof a
	where	a.nr_seq_cp_cta_filtro = nr_seq_filtro_pc
	and	a.ie_medico = ie_tipo_profissional_pc
	and	a.ie_situacao = 'A';

BEGIN
-- Se NAO tiver informacoes da regra NAO sera possovel aplicar os filtros.

if (nr_seq_filtro_p IS NOT NULL AND nr_seq_filtro_p::text <> '') then
	
	qt_filtro_processado_w := 0;	
	-- Abrir vetor com todas as combinacoes de filtro da regra 

	for r_c_filtro_w in c_filtro(nr_seq_filtro_p, ie_tipo_profissional_p) loop
	
		-- somente a primeira vez que passar no cursor atualiza aPos isto NAO atualiza mais

		if (qt_filtro_processado_w = 0) then
			-- Atualizar o campo auxiliar que sera utilizado para sinalizar os registros que foram processados

			CALL CALL CALL CALL CALL pls_filtro_regra_preco_cta_pck.atualiza_campo_auxiliar( nr_id_transacao_p, nr_seq_filtro_p, ie_excecao_p);
		end if;
		
		begin
			-- restricao para todas as outras situacoes

			valor_bind_w := pls_filtro_regra_preco_cta_pck.obter_restricao_profissional(	r_c_filtro_w.cd_medico, valor_bind_w);
									
			-- Montar o select padrao juntamente as restricoes.

			valor_bind_w := pls_filtro_regra_preco_cta_pck.obter_select_filtro(	ie_considera_selecao_p, 'N', ie_destino_regra_p, ie_tipo_regra_p, nr_id_transacao_p, ie_excecao_p, nr_seq_filtro_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, nr_seq_lote_conta_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, nr_seq_analise_p, cd_estabelecimento_p, null, null, dados_restricao_w, valor_bind_w);

			-- executa o comando sql com os respectivos binds

			valor_bind_w := sql_pck.executa_sql_cursor(	ds_select_w, valor_bind_w);

			loop
				fetch cursor_w bulk collect into	tb_seq_conta_w, tb_seq_conta_proc_w,
									tb_seq_conta_mat_w, tb_nr_seq_partic_w,
									tb_seq_selecao_w
				limit pls_util_pck.qt_registro_transacao_w;
				exit when tb_seq_conta_w.count = 0;
				
				-- Insere/atualiza todos os registros das listas na tabela de selecao

				CALL CALL CALL CALL CALL pls_filtro_regra_preco_cta_pck.gerencia_selecao_filtro(	nr_id_transacao_p, nr_seq_filtro_p,
								ie_tipo_regra_p, ie_excecao_p,
								tb_seq_conta_w, tb_seq_conta_proc_w,
								tb_seq_conta_mat_w, tb_nr_seq_partic_w,
								tb_seq_selecao_w, 'S');
			end loop;
			close cursor_w;
			
		exception
			when others then
			-- se deu algo e o cursor esta aberto fecha ele

			if (cursor_w%isopen) then
				close cursor_w;
			end if;
			
			-- Tratar erro gerado no sql dinamico, sera inserido registro no log e abortado o processo exibindo mensagem de erro.

			CALL CALL CALL CALL CALL CALL pls_filtro_regra_preco_cta_pck.trata_erro_sql_dinamico( 	nr_seq_filtro_p, ds_select_w, nr_id_transacao_p,
							nm_usuario_p, 'S');
		end;
		
		qt_filtro_processado_w := qt_filtro_processado_w + 1;
	end loop;
	
	-- se processou algum filtro

	if (qt_filtro_processado_w > 0) then
		-- Atualizar o campo definitivo que sera utilizado para sinalizar os registros que foram processados

		CALL CALL CALL CALL CALL pls_filtro_regra_preco_cta_pck.atualiza_campo_valido(	nr_id_transacao_p, nr_seq_filtro_p, ie_excecao_p);
		-- seta para utilizar a tabela de selecao

		ie_considera_selecao_p := true;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_preco_cta_pck.aplica_filtro_profissional ( ie_considera_selecao_p INOUT boolean, ie_tipo_profissional_p pls_cp_cta_filtro_prof.ie_medico%type, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, ie_destino_regra_p text, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, ie_excecao_p pls_cp_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_cp_cta_filtro.nr_sequencia%type, dt_inicio_vigencia_p pls_cp_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_cp_cta_combinada.dt_fim_vigencia%type, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
