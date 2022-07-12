-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*
	Essa rotina _ utilizada em momentos que antigamente era chamada a gerar contab val adic. Ao gerar o p_s-estabelecido, _ seguido o fluxo de execucao 
	das rotinas da package e essa rotina n_o _ chamada.
*/



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.gerar_valores_adicionais ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, ie_valor_ptu_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

	--Necess_rio carregar as tabelas tempor_rias de procedimentos pois _ necess_rio a carga de algumas informacaes para recalcular os valores cont_beis.

	CALL pls_pos_estabelecido_pck.carrega_procedimentos_geracao(nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
	                              nr_seq_analise_p,	nr_seq_conta_p,	nr_seq_proc_p,
				      nm_usuario_p, cd_estabelecimento_p);
	
	--Necess_rio carregar as tabelas tempor_rias de procedimentos pois _ necess_rio a carga de algumas informacaes para recalcular os valores cont_beis.

	CALL pls_pos_estabelecido_pck.carrega_materiais_geracao(	nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
					nr_seq_analise_p, nr_seq_conta_p, nr_seq_mat_p,
					nm_usuario_p, cd_estabelecimento_p);
	
	--Seta status dos itens tempor_rios carregados anteriormente.

	CALL pls_pos_estabelecido_pck.identifica_item_elegivel_pos(nm_usuario_p, cd_estabelecimento_p);
	
	--geracao dos valores cont_beis de p_s-estabelecido.

	CALL pls_pos_estabelecido_pck.geracao_valores_contabeis( nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_analise_p, nr_seq_conta_p, nm_usuario_p, cd_estabelecimento_p);

	if (ie_valor_ptu_p = 'S') then
		--geracao dos valores PTU

		CALL pls_pos_estabelecido_pck.geracao_valores_ptu( nm_usuario_p, cd_estabelecimento_p);
	end if;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.gerar_valores_adicionais ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, ie_valor_ptu_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;