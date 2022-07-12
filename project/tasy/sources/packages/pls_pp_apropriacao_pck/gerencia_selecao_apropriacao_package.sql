-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_apropriacao_pck.gerencia_selecao_apropriacao ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_id_transacao_w	pls_pp_rp_aprop_selecao.nr_id_transacao%type;

BEGIN

-- verifica se foi passado algum parâmetro, caso não tenha sido passado não faz nada esta validação é para evitar que 
-- seja processado toda a tabela por não ter uma restrição
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	
	-- carrega os parâmetros necessários para processar os dados
	CALL pls_pp_lote_pagamento_pck.carrega_parametros(nr_seq_lote_p, cd_estabelecimento_p);
	
	for r_c_dados_lote_w in pls_pp_lote_pagamento_pck.c_dados_lote(nr_seq_lote_p) loop
		
		-- gera a transação para o processamento do lote
		select 	nextval('pls_id_transacao_pp_rp_apr_seq')
		into STRICT	nr_id_transacao_w
		;
	
		-- processa os filtros da regra e deixa os registros válidos na tabela pls_pp_rp_aprop_selecao
		CALL CALL CALL CALL CALL pls_pp_apropriacao_pck.gerencia_aplicacao_filtro(	r_c_dados_lote_w.nr_seq_lote, r_c_dados_lote_w.nr_seq_regra_periodo,
						nr_id_transacao_w, r_c_dados_lote_w.cd_condicao_pagamento,
						nm_usuario_p);

		-- grava na tabela pls_pp_item_lote os itens de produção médica que pertencem ao lote
		CALL pls_pp_apropriacao_pck.insere_item_apropriacao(	nr_id_transacao_w, nr_seq_lote_p, r_c_dados_lote_w.nr_seq_regra_periodo,
						nm_usuario_p);

		-- limpa a tabela de seleção
		CALL CALL CALL CALL CALL pls_pp_apropriacao_pck.limpar_transacao(nr_id_transacao_w);
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_apropriacao_pck.gerencia_selecao_apropriacao ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
