-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.inserir_dmp_deb_cred_imp ( nm_usuario_p pls_dmp_deb_cred_imp.nm_usuario%type, nr_seq_dmp_dados_pagto_p pls_dmp_deb_cred_imp.nr_seq_dmp_dados_pagto%type, ie_indicador_p pls_dmp_deb_cred_imp.ie_indicador%type, ie_tipo_deb_cred_p pls_dmp_deb_cred_imp.ie_tipo_deb_cred%type, ds_debito_credito_p pls_dmp_deb_cred_imp.ds_debito_credito%type, vl_debito_credito_p pls_dmp_deb_cred_imp.vl_debito_credito%type, nr_sequencia_p INOUT pls_dmp_deb_cred_imp.nr_sequencia%type) AS $body$
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

insert into pls_dmp_deb_cred_imp(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_dmp_dados_pagto,
					ie_indicador,
					ie_tipo_deb_cred,
					ds_debito_credito,
					vl_debito_credito)
values (	nextval('pls_dmp_deb_cred_imp_seq'),
		clock_timestamp(),
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_dmp_dados_pagto_p,
		ie_indicador_p,
		ie_tipo_deb_cred_p,
		ds_debito_credito_p,
		vl_debito_credito_p) returning nr_sequencia into nr_sequencia_p;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.inserir_dmp_deb_cred_imp ( nm_usuario_p pls_dmp_deb_cred_imp.nm_usuario%type, nr_seq_dmp_dados_pagto_p pls_dmp_deb_cred_imp.nr_seq_dmp_dados_pagto%type, ie_indicador_p pls_dmp_deb_cred_imp.ie_indicador%type, ie_tipo_deb_cred_p pls_dmp_deb_cred_imp.ie_tipo_deb_cred%type, ds_debito_credito_p pls_dmp_deb_cred_imp.ds_debito_credito%type, vl_debito_credito_p pls_dmp_deb_cred_imp.vl_debito_credito%type, nr_sequencia_p INOUT pls_dmp_deb_cred_imp.nr_sequencia%type) FROM PUBLIC;
