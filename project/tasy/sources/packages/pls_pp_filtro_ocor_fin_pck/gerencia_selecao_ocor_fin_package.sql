-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_filtro_ocor_fin_pck.gerencia_selecao_ocor_fin ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
nr_id_transacao_w	pls_pp_rp_ofin_selecao.nr_id_transacao%type;

BEGIN

-- O Oracle 11G tem um bug que apresenta o erro ORA-08176.
-- Até onde foi entendido, esse bug é disparado quando existe o envolvimento de mais de uma tabela temporária dentro de um mesmo select.
-- Se inserirmos um registro na tabela e depois excluírmos este bug desaparece
-- Por isso foi feito este tratamento abaixo
insert 	into pls_pp_rp_ofin_selecao(
	nr_sequencia, ie_excecao, ie_valido,
	ie_valido_temp, nr_id_transacao, nr_seq_evento,
	nr_seq_filtro, nr_seq_prestador
) values (
	-1, 'N', 'N',
	'N', 1, -1,
	-1, -1);
commit;
delete from pls_pp_rp_ofin_selecao where nr_sequencia = -1;
commit;

-- verifica se foi passado algum parâmetro, caso não tenha sido passado não faz nada esta validação é para evitar que 
-- seja processado toda a tabela por não ter uma restrição
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	
	-- carrega os parâmetros necessários para processar os dados
	CALL pls_pp_lote_pagamento_pck.carrega_parametros(nr_seq_lote_p, cd_estabelecimento_p);
	
	for r_c_dados_lote_w in pls_pp_lote_pagamento_pck.c_dados_lote(nr_seq_lote_p) loop
		
		-- gera a transação para o processamento do lote
		select 	nextval('pls_id_transacao_pp_rp_ofi_seq')
		into STRICT	nr_id_transacao_w
		;
	
		-- processa os filtros da regra e deixa os registros válidos na tabela pls_pp_rp_ofin_selecao
		CALL CALL CALL CALL CALL pls_pp_filtro_ocor_fin_pck.gerencia_aplicacao_filtro(	r_c_dados_lote_w.nr_seq_lote, r_c_dados_lote_w.nr_seq_regra_periodo,
						nr_id_transacao_w, r_c_dados_lote_w.cd_condicao_pagamento,
						nm_usuario_p);

		-- grava na tabela pls_pp_item_lote os itens de produção médica que pertencem ao lote
		CALL pls_pp_filtro_ocor_fin_pck.insere_item_ocor_fin(	nr_id_transacao_w, nr_seq_lote_p, r_c_dados_lote_w.nr_seq_regra_periodo,
					nm_usuario_p);
		
		-- limpa a tabela de seleção
		CALL CALL CALL CALL CALL pls_pp_filtro_ocor_fin_pck.limpar_transacao(nr_id_transacao_w);
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_filtro_ocor_fin_pck.gerencia_selecao_ocor_fin ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
