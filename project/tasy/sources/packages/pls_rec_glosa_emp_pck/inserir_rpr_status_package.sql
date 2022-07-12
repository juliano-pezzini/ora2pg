-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.inserir_rpr_status ( nr_registro_ans_p pls_rpr_status_imp.nr_registro_ans%type, dt_envio_recurso_p pls_rpr_status_imp.dt_envio_recurso%type, dt_recebimento_recurso_p pls_rpr_status_imp.dt_recebimento_recurso%type, nr_prot_situacao_rec_p pls_rpr_status_imp.nr_prot_situacao_rec%type, dt_situacao_p pls_rpr_status_imp.dt_situacao%type, nm_usuario_p pls_rpr_status_imp.nm_usuario%type, nr_seq_rpr_resposta_p pls_rpr_status_imp.nr_seq_rpr_resposta%type, nr_protocolo_rec_p pls_rpr_status_imp.nr_protocolo_rec%type, nr_lote_p pls_rpr_status_imp.nr_lote%type, ie_situacao_p pls_rpr_status_imp.ie_situacao%type, nr_sequencia_p INOUT pls_rpr_status_imp.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Realizar a insersao de informacoes na importacao da resposta do recurso de glosa em xml

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[]   Objetos do dicionario [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	Essa rotina foi feita apenas para a importacao de XML, que e realizada de forma
	unitaria, conforme a leitura do arquivo. Ela nao e otimizada para utilizar em 
	processamento em lote.
	
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

insert into pls_rpr_status_imp(nr_sequencia,
				nr_registro_ans,
				dt_envio_recurso,
				dt_recebimento_recurso,
				nr_prot_situacao_rec,
				dt_situacao,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_rpr_resposta,
				nr_protocolo_rec,
				nr_lote,
				ie_situacao)
values (nextval('pls_rpr_status_imp_seq'),
	nr_registro_ans_p,
	dt_envio_recurso_p,
	dt_recebimento_recurso_p,
	nr_prot_situacao_rec_p,
	dt_situacao_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_rpr_resposta_p,
	nr_protocolo_rec_p,
	nr_lote_p,
	ie_situacao_p) returning nr_sequencia into nr_sequencia_p;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.inserir_rpr_status ( nr_registro_ans_p pls_rpr_status_imp.nr_registro_ans%type, dt_envio_recurso_p pls_rpr_status_imp.dt_envio_recurso%type, dt_recebimento_recurso_p pls_rpr_status_imp.dt_recebimento_recurso%type, nr_prot_situacao_rec_p pls_rpr_status_imp.nr_prot_situacao_rec%type, dt_situacao_p pls_rpr_status_imp.dt_situacao%type, nm_usuario_p pls_rpr_status_imp.nm_usuario%type, nr_seq_rpr_resposta_p pls_rpr_status_imp.nr_seq_rpr_resposta%type, nr_protocolo_rec_p pls_rpr_status_imp.nr_protocolo_rec%type, nr_lote_p pls_rpr_status_imp.nr_lote%type, ie_situacao_p pls_rpr_status_imp.ie_situacao%type, nr_sequencia_p INOUT pls_rpr_status_imp.nr_sequencia%type) FROM PUBLIC;
