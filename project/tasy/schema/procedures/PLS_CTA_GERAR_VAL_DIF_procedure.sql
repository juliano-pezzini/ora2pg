-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cta_gerar_val_dif ( nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type default null) AS $body$
DECLARE


dados_regra_w			pls_tipos_cta_val_pck.dados_regra;
dados_consistencia_w		pls_tipos_cta_val_pck.dados_consistencia;
qt_registro_w			integer;
dados_filtro_null_w		pls_tipos_cta_val_pck.dados_filtro;
qt_conta_lote_w			integer;

-- cursor com as regras
C01 CURSOR FOR
	SELECT	regra.nr_sequencia nr_seq_validacao,
		rcta.nr_sequencia nr_seq_regra,
		rcta.ie_utiliza_filtro,
		regra.cd_validacao,
		nextval('pls_rp_cta_selecao_seq') nr_id_transacao
	from	pls_rp_cta_combinada		rcta,
		pls_rp_cta_tipo_validacao	regra
	where	rcta.ie_situacao = 'A'
	and	regra.nr_sequencia = rcta.nr_seq_tipo_validacao;

BEGIN

-- se foram passados os valores básicos de parâmetro
if (nr_seq_lote_conta_p IS NOT NULL AND nr_seq_lote_conta_p::text <> '') or (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') or (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') or (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') or (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then

	if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') then
		-- se não tiver registros na tabela manda gerar
		select	count(1)
		into STRICT	qt_conta_lote_w
		from	pls_cta_lote_proc_cta_temp;

		if (qt_conta_lote_w = 0) then
			CALL gera_cta_temp_lote_processo(nr_seq_lote_processo_p);
		end if;
	end if;

	-- limpa as regras do procedimento
	CALL pls_grava_log_execucao_temp('Início pls_cta_val_limpa_regra', 'val_dif', nm_usuario_p);
	CALL pls_tipos_cta_val_pck.pls_cta_val_limpa_regra(	nr_seq_lote_conta_p, nr_seq_protocolo_p,
							nr_seq_lote_processo_p, nr_seq_conta_p, nr_seq_analise_p,
							nr_seq_conta_proc_p, cd_estabelecimento_p,
							nm_usuario_p);
	CALL pls_grava_log_execucao_temp('Fim pls_cta_val_limpa_regra', 'val_dif', nm_usuario_p);

	-- passagem de parâmetros em um tipo para facilitar referente a quantidade de parâmetros.
	dados_consistencia_w.nr_seq_lote		:= nr_seq_lote_conta_p;
	dados_consistencia_w.nr_seq_lote_processo	:= nr_seq_lote_processo_p;
	dados_consistencia_w.nr_seq_protocolo		:= nr_seq_protocolo_p;
	dados_consistencia_w.nr_seq_conta		:= nr_seq_conta_p;
	dados_consistencia_w.nr_seq_conta_proc		:= nr_seq_conta_proc_p;
	dados_consistencia_w.nr_seq_analise		:= nr_seq_analise_p;

	for r_C01_w in C01 loop

		dados_regra_w.nr_seq_validacao := r_C01_w.nr_seq_validacao;
		dados_regra_w.nr_seq_regra := r_C01_w.nr_seq_regra;
		dados_regra_w.ie_utiliza_filtro := r_C01_w.ie_utiliza_filtro;
		dados_regra_w.cd_validacao := r_C01_w.cd_validacao;

		-- Essa procedure é responsável por inserir registros na tabela PLS_RP_CTA_SELECAO
		-- para que o cursor das contas e dos itens seja válido
		CALL pls_grava_log_execucao_temp('Início pls_cta_val_aplicar_filtros', 'val_dif', nm_usuario_p);
		qt_registro_w := pls_cta_val_aplicar_filtros(	dados_consistencia_w, dados_regra_w, r_C01_w.nr_id_transacao, nm_usuario_p, cd_estabelecimento_p, qt_registro_w);
		CALL pls_grava_log_execucao_temp('Fim pls_cta_val_aplicar_filtros', 'val_dif', nm_usuario_p);

		-- se retornar registro precisamos fazer algo.
		if (qt_registro_w > 0) then

			CALL pls_grava_log_execucao_temp('Início pls_cta_val_aplica_validacao', 'val_dif', nm_usuario_p);
			CALL pls_cta_val_aplica_validacao(	dados_regra_w, r_C01_w.nr_id_transacao, cd_estabelecimento_p,
							nm_usuario_p);
			CALL pls_grava_log_execucao_temp('Fim pls_cta_val_aplica_validacao', 'val_dif', nm_usuario_p);

			CALL pls_grava_log_execucao_temp('Início pls_cta_val_aplica_regra', 'val_dif', nm_usuario_p);
			--aqui serão atualizados os procedimentos selecionados na regra de valorização especial
			CALL pls_tipos_cta_val_pck.pls_cta_val_aplica_regra(	r_C01_w.nr_id_transacao, dados_regra_w,
									nm_usuario_p);
			CALL pls_grava_log_execucao_temp('Fim pls_cta_val_aplica_regra', 'val_dif', nm_usuario_p);
		end if;

		CALL pls_grava_log_execucao_temp('Início gerencia_selecao', 'val_dif', nm_usuario_p);
		-- limpa os registros da tabela de seleção
		CALL pls_tipos_cta_val_pck.gerencia_selecao(	r_C01_w.nr_id_transacao, pls_util_cta_pck.num_table_vazia_w,
								pls_util_cta_pck.num_table_vazia_w, pls_util_cta_pck.clob_table_vazia_w,
								null, nm_usuario_p, 'LT', dados_filtro_null_w);
		CALL pls_grava_log_execucao_temp('Fim gerencia_selecao', 'val_dif', nm_usuario_p);
		commit;
	end loop; -- Regras de valorização;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_gerar_val_dif ( nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type default null) FROM PUBLIC;

