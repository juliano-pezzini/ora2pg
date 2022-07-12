-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.inserir_dmp_dados_resumo_imp ( dt_protocolo_p pls_dmp_dados_resumo_imp.dt_protocolo%type, nr_protocolo_p pls_dmp_dados_resumo_imp.nr_protocolo%type, nr_lote_p pls_dmp_dados_resumo_imp.nr_lote%type, vl_informado_p pls_dmp_dados_resumo_imp.vl_informado%type, vl_processado_p pls_dmp_dados_resumo_imp.vl_processado%type, vl_liberado_p pls_dmp_dados_resumo_imp.vl_liberado%type, vl_glosa_p pls_dmp_dados_resumo_imp.vl_glosa%type, nm_usuario_p pls_dmp_dados_resumo_imp.nm_usuario%type, nr_seq_dmp_dados_pagto_p pls_dmp_dados_resumo_imp.nr_seq_dmp_dados_pagto%type, nr_sequencia_p INOUT pls_dmp_dados_resumo_imp.nr_sequencia%type) AS $body$
DECLARE
 					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Realizar a insersao de informacoes na importacao do xml

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	Essa rotina foi feita apenas para a importacao de XML, que e realizada de forma
	unitaria, conforme a leitura do arquivo. Ela nao e otimizada para utilizar em 
	processamento em lote.
	
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

insert into pls_dmp_dados_resumo_imp(	nr_sequencia,
					dt_protocolo,
					nr_protocolo,
					nr_lote,
					vl_informado,
					vl_processado,
					vl_liberado,
					vl_glosa,					
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_dmp_dados_pagto)
values (	nextval('pls_dmp_dados_resumo_imp_seq'),
		dt_protocolo_p,
		nr_protocolo_p,
		nr_lote_p,
		vl_informado_p,
		vl_processado_p,
		vl_liberado_p,
		vl_glosa_p,		
		clock_timestamp(),
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_dmp_dados_pagto_p) returning nr_sequencia into nr_sequencia_p;
		
		
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.inserir_dmp_dados_resumo_imp ( dt_protocolo_p pls_dmp_dados_resumo_imp.dt_protocolo%type, nr_protocolo_p pls_dmp_dados_resumo_imp.nr_protocolo%type, nr_lote_p pls_dmp_dados_resumo_imp.nr_lote%type, vl_informado_p pls_dmp_dados_resumo_imp.vl_informado%type, vl_processado_p pls_dmp_dados_resumo_imp.vl_processado%type, vl_liberado_p pls_dmp_dados_resumo_imp.vl_liberado%type, vl_glosa_p pls_dmp_dados_resumo_imp.vl_glosa%type, nm_usuario_p pls_dmp_dados_resumo_imp.nm_usuario%type, nr_seq_dmp_dados_pagto_p pls_dmp_dados_resumo_imp.nr_seq_dmp_dados_pagto%type, nr_sequencia_p INOUT pls_dmp_dados_resumo_imp.nr_sequencia%type) FROM PUBLIC;