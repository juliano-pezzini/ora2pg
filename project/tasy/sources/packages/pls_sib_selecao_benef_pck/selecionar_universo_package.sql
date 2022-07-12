-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sib_selecao_benef_pck.selecionar_universo ( nr_seq_lote_p pls_sib_lote.nr_sequencia%type, ie_tipo_lote_p pls_sib_lote.ie_tipo_lote%type, ie_tipo_movimento_p pls_sib_lote.ie_tipo_movimento%type, ie_gerar_correcao_p pls_sib_lote.ie_gerar_correcao%type, dt_referencia_p pls_sib_lote.dt_referencia%type, dt_inicio_mov_p pls_sib_lote.dt_inicio_mov%type, dt_fim_mov_p pls_sib_lote.dt_fim_mov%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	delete from pls_sib_selecao_temp;
	commit;
	
	if (ie_tipo_lote_p = 'M') then --Movimentação
		CALL pls_sib_selecao_benef_pck.selecionar_movimentacao(trunc(dt_inicio_mov_p,'dd'), fim_dia(dt_fim_mov_p), cd_estabelecimento_p);
	elsif (ie_tipo_lote_p = 'I') then --Inclusão Todos
		CALL pls_sib_selecao_benef_pck.selecionar_todos_ativos(dt_referencia_p, cd_estabelecimento_p);
	elsif (ie_tipo_lote_p = 'E') then --Exclusão Outros
		CALL pls_sib_selecao_benef_pck.selecionar_todos_ativos(dt_referencia_p, cd_estabelecimento_p);
	end if;
	
	CALL pls_sib_selecao_benef_pck.remover_benef_migrado(dt_referencia_p);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_selecao_benef_pck.selecionar_universo ( nr_seq_lote_p pls_sib_lote.nr_sequencia%type, ie_tipo_lote_p pls_sib_lote.ie_tipo_lote%type, ie_tipo_movimento_p pls_sib_lote.ie_tipo_movimento%type, ie_gerar_correcao_p pls_sib_lote.ie_gerar_correcao%type, dt_referencia_p pls_sib_lote.dt_referencia%type, dt_inicio_mov_p pls_sib_lote.dt_inicio_mov%type, dt_fim_mov_p pls_sib_lote.dt_fim_mov%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;