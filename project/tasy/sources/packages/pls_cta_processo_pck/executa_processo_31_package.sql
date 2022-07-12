-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Geração de resumo de conta(s).
CREATE OR REPLACE PROCEDURE pls_cta_processo_pck.executa_processo_31 ( nr_seq_lote_conta_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN


CALL pls_analise_cta_pck.vincular_contas_analise(	nr_seq_lote_conta_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
						nr_seq_conta_p, nm_usuario_p, cd_estabelecimento_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_processo_pck.executa_processo_31 ( nr_seq_lote_conta_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
