-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Rotina que permite apenas processar ocorr_ncias e posterior liberacao autom_tica de p_s-estab. Utilizada na consist_ncia de an_lise de p_s que em algumas circunst_ncias somente processa 
   as ocorr_ncias, sem passar por toda geracao de p_s-estab e poder_ ser utilizada por alguma outra rotina futuramente.*/



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.processar_ocor_e_lib_automatic ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

	--Necess_rio carregar as tabelas tempor_rias de procedimentos pois _ necess_rio a carga de algumas informacaes para recalcular os valores cont_beis.

	CALL pls_pos_estabelecido_pck.carrega_procedimentos_geracao(nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
				      nr_seq_analise_p,	nr_seq_conta_p,	nr_seq_proc_p,
				      nm_usuario_p, cd_estabelecimento_p);
	
	--Necess_rio carregar as tabelas tempor_rias de procedimentos pois _ necess_rio a carga de algumas informacaes para recalcular os valores cont_beis.

	CALL pls_pos_estabelecido_pck.carrega_materiais_geracao(	nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
					nr_seq_analise_p, nr_seq_conta_p, nr_seq_mat_p,
					nm_usuario_p, cd_estabelecimento_p);
	
	--Processamento das ocorr_ncias de p_s-estabelecido(OPS - Glosas e ocorr_ncias\Ocorr_ncias\Conta m_dica\P_s-estabelecido)

	CALL pls_pos_estabelecido_pck.processa_ocorrencias_pos_estab( nm_usuario_p, cd_estabelecimento_p);
	
	--Processa liberacaes autom_ticas dos registros de p_s-estabelecido.

	CALL pls_pos_estabelecido_pck.executa_liberacao_automatica( nm_usuario_p, cd_estabelecimento_p);
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.processar_ocor_e_lib_automatic ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
