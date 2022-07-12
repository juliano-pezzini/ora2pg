-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_entao_regra_preco_cta_pck.gerencia_aplicacao_entao ( ie_destino_regra_p text, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/*
 ie_destino_regra_p 	P -> Prestador
			R -> Reembolso
			C -> Coparticipação
			I -> Intercâmbio
*/
BEGIN
-- verifica se foi passado algum parâmetro, caso não tenha sido passado não faz nada
-- esta validação é para evitar que seja processado toda a tabela por não ter uma restrição
if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') or (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') or (nr_seq_lote_conta_p IS NOT NULL AND nr_seq_lote_conta_p::text <> '') or (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') or (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') or (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') or (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	
	-- carrega os parâmetros necessários para processar os dados
	CALL CALL CALL CALL CALL CALL pls_entao_regra_preco_cta_pck.carrega_parametros(cd_estabelecimento_p);
	
	-- se não foi passado um procedimento específico processa as regras de materiais
	if (coalesce(nr_seq_conta_proc_p::text, '') = '') then
		-- processa as regras de material para todos os eventos
		CALL pls_entao_regra_preco_cta_pck.processa_regra_material(	ie_destino_regra_p, nr_seq_lote_conta_p,
						nr_seq_protocolo_p, nr_seq_lote_processo_p,
						nr_seq_conta_p, nr_seq_conta_proc_p,
						nr_seq_conta_mat_p, nr_seq_analise_p,
						cd_acao_analise_p, cd_estabelecimento_p,
						nm_usuario_p);
	end if;

	-- se não foi passado uma conta de material específica processa as regras de procedimento,
	-- participante e serviço
	if (coalesce(nr_seq_conta_mat_p::text, '') = '') then

		-- processa as regras de procedimentos para todos os eventos
		CALL pls_entao_regra_preco_cta_pck.processa_regra_procedimento(	ie_destino_regra_p, nr_seq_lote_conta_p,
						nr_seq_protocolo_p, nr_seq_lote_processo_p,
						nr_seq_conta_p, nr_seq_conta_proc_p,
						nr_seq_conta_mat_p, nr_seq_analise_p,
						cd_acao_analise_p, cd_estabelecimento_p,
						nm_usuario_p);

		-- processa as regras de serviços para todos os eventos
		CALL pls_entao_regra_preco_cta_pck.processa_regra_servico(	ie_destino_regra_p, nr_seq_lote_conta_p,
					nr_seq_protocolo_p, nr_seq_lote_processo_p,
					nr_seq_conta_p, nr_seq_conta_proc_p,
					nr_seq_conta_mat_p, nr_seq_analise_p,
					cd_acao_analise_p, cd_estabelecimento_p,
					nm_usuario_p);

		-- só é válida valorização por participante quando o destino da regra for Prestador.
		-- para reembolso, coparticipação e Intercâmbio não deve ser executado.
		if (ie_destino_regra_p = 'P') then

			-- processa as regras de participantes para todos os eventos
			CALL pls_entao_regra_preco_cta_pck.processa_regra_participante(	ie_destino_regra_p, nr_seq_lote_conta_p,
							nr_seq_protocolo_p, nr_seq_lote_processo_p,
							nr_seq_conta_p, nr_seq_conta_proc_p,
							nr_seq_conta_mat_p, nr_seq_analise_p,
							cd_acao_analise_p, cd_estabelecimento_p,
							nm_usuario_p);
		end if;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_entao_regra_preco_cta_pck.gerencia_aplicacao_entao ( ie_destino_regra_p text, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
