-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




CREATE OR REPLACE PROCEDURE pls_gerenciar_reembolso_pck.aplica_filtro_quantidade ( dados_regra_p pls_gerenciar_reembolso_pck.dados_regra, dados_filtro_p pls_gerenciar_reembolso_pck.dados_filtro, dados_consistencia_p pls_gerenciar_reembolso_pck.dados_consistencia, nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, ie_select_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerenciar a aplicacao do filtro de quantidade.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


dados_filtro_qtd_w	pls_gerenciar_reembolso_pck.dados_filtro_qtd;
dados_restricao_w	pls_gerenciar_reembolso_pck.dados_restricao_select;
dados_restricao_qtd_w	pls_gerenciar_reembolso_pck.dados_select;

valor_bind_w		sql_pck.t_dado_bind;
PERFORM_completo_w	varchar(32000);
cursor_w		sql_pck.t_cursor;
qt_regras_w		integer;

c_filtro CURSOR( nr_seq_filtro_pc	pls_regra_reemb_filtro.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.qt_periodo,		
		a.ie_tipo_periodo,
		a.qt_inicial,
		a.qt_final,
		a.ie_tipo_consistencia
	from	pls_regra_reemb_fil_qtd a
	where	a.nr_seq_regra_filtro = nr_seq_filtro_pc;
	
BEGIN

-- Se nao tiver informacoes da regra nao sera possivel aplicar os filtros

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	select	count(1)
	into STRICT	qt_regras_w
	from	pls_regra_reemb_fil_qtd a
	where	a.nr_seq_regra_filtro = dados_filtro_p.nr_sequencia;
		
	if (qt_regras_w > 0) then		

		-- Update na tabela de selecao

		CALL CALL pls_gerenciar_reembolso_pck.gerencia_selecao(nr_id_transacao_p,null,null,'S',nm_usuario_p,'2',dados_filtro_p);
		
		-- Passa por todos os filtros da regra

		for	r_c_filtro in c_filtro(dados_filtro_p.nr_sequencia) loop
				
			dados_filtro_qtd_w.nr_sequencia		:= r_c_filtro.nr_sequencia;
			dados_filtro_qtd_w.qt_periodo		:= r_c_filtro.qt_periodo;
			dados_filtro_qtd_w.ie_tipo_periodo	:= r_c_filtro.ie_tipo_periodo;
			dados_filtro_qtd_w.qt_inicial		:= r_c_filtro.qt_inicial;
			dados_filtro_qtd_w.qt_final		:= r_c_filtro.qt_final;
			dados_filtro_qtd_w.ie_tipo_consistencia	:= r_c_filtro.ie_tipo_consistencia;
			
			valor_bind_w := pls_gerenciar_reembolso_pck.obter_restricao_padrao_reemb(dados_consistencia_p, nr_id_transacao_p, dados_filtro_p, valor_bind_w);	

			valor_bind_w := pls_gerenciar_reembolso_pck.obter_restricao_quantidade(dados_filtro_qtd_w, valor_bind_w);	
					
			dados_restricao_w.ds_restricao_proc := dados_restricao_w.ds_restricao_proc || dados_restricao_qtd_w.ds_restricao || dados_restricao_qtd_w.ds_restricao_proc;
			dados_restricao_w.ds_restricao_mat := dados_restricao_w.ds_restricao_mat || dados_restricao_qtd_w.ds_restricao || dados_restricao_qtd_w.ds_restricao_mat;
			
			-- Monta select

			PERFORM_completo_w := pls_gerenciar_reembolso_pck.montar_select_padrao_reemb(ie_select_p,dados_restricao_w);	
			
			valor_bind_w := sql_pck.executa_sql_cursor(select_completo_w, valor_bind_w);
			
			CALL pls_gerenciar_reembolso_pck.aplicar_filtro_cursor(cursor_w,dados_filtro_p,nr_id_transacao_p,nm_usuario_p);				
							
		end loop;
		
		-- Exclui registro que nao e mais utilizado da tabela de selecao

		CALL CALL pls_gerenciar_reembolso_pck.gerencia_selecao(nr_id_transacao_p,null,null,'S',nm_usuario_p,'3',dados_filtro_p);
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerenciar_reembolso_pck.aplica_filtro_quantidade ( dados_regra_p pls_gerenciar_reembolso_pck.dados_regra, dados_filtro_p pls_gerenciar_reembolso_pck.dados_filtro, dados_consistencia_p pls_gerenciar_reembolso_pck.dados_consistencia, nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, ie_select_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;