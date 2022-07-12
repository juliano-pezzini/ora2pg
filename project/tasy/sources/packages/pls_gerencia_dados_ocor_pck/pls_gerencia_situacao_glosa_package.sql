-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_dados_ocor_pck.pls_gerencia_situacao_glosa ( nr_seq_conta_glosa_p pls_conta_glosa.nr_sequencia%type, ie_situacao_p pls_conta_glosa.ie_situacao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_ocor_benef_p pls_ocorrencia_benef.nr_sequencia%type, ie_opcao_p text) AS $body$
BEGIN
 
-- tratamento para a glosa 
if (nr_seq_conta_glosa_p IS NOT NULL AND nr_seq_conta_glosa_p::text <> '') then 
 
	update	pls_conta_glosa 
	set	ie_situacao		= ie_situacao_p, 
		ie_forma_inativacao	= pls_gerencia_dados_ocor_pck.obter_forma_inativacao_ocor( ie_situacao_p, ie_forma_inativacao,ie_opcao_p ), 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		ie_lib_manual		= CASE WHEN ie_situacao_p='A' THEN 'S'  ELSE 'N' END  
	where  nr_sequencia		= nr_seq_conta_glosa_p;
end if;
 
-- tratamento para a ocorrência vinculada a glosa 
if (nr_seq_ocor_benef_p IS NOT NULL AND nr_seq_ocor_benef_p::text <> '') then 
 
	update	pls_conta_glosa 
	set	ie_situacao		= ie_situacao_p, 
		ie_forma_inativacao	= pls_gerencia_dados_ocor_pck.obter_forma_inativacao_ocor( ie_situacao_p, ie_forma_inativacao,ie_opcao_p ), 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		ie_lib_manual		= CASE WHEN ie_situacao_p='A' THEN 'S'  ELSE 'N' END  
	where  nr_seq_ocorrencia_benef	= nr_seq_ocor_benef_p;
end if;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_dados_ocor_pck.pls_gerencia_situacao_glosa ( nr_seq_conta_glosa_p pls_conta_glosa.nr_sequencia%type, ie_situacao_p pls_conta_glosa.ie_situacao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_ocor_benef_p pls_ocorrencia_benef.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;