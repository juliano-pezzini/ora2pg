-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_dados_ocor_pck.pls_gerencia_situacao_ocor ( nr_seq_ocor_benef_p pls_ocorrencia_benef.nr_sequencia%type, ie_situacao_p pls_ocorrencia_benef.ie_situacao%type, nm_usuario_p usuario.nm_usuario%type, ie_opcao_p text) AS $body$
DECLARE

-- traz todas as glosas vinculadas a ocorrência ou ocorrências vinculadas a glosa 
/*Ie_opcao irá determinar se a opção base será 'S' - sistema ou 'U' impacta na ativação da ocorrência*/
 
C01 CURSOR(nr_seq_ocor_benef_p          pls_ocorrencia_benef.nr_sequencia%type) FOR 
	SELECT	a.nr_seq_glosa 
	from 	pls_ocorrencia_benef a 
	where	a.nr_sequencia	= nr_seq_ocor_benef_p 
	and   (a.nr_seq_glosa IS NOT NULL AND a.nr_seq_glosa::text <> '') 
	
union
 
	SELECT	b.nr_sequencia nr_seq_glosa 
	from	pls_conta_glosa b 
	where	b.nr_seq_ocorrencia_benef = nr_seq_ocor_benef_p;

BEGIN 
 
update	pls_ocorrencia_benef 
set   ie_situacao     	= ie_situacao_p, 
    ie_forma_inativacao	= pls_gerencia_dados_ocor_pck.obter_forma_inativacao_ocor( ie_situacao_p, ie_forma_inativacao, ie_opcao_p ), 
 	nm_usuario		= nm_usuario_p, 
 	dt_atualizacao		= clock_timestamp() 
where  nr_sequencia		= nr_seq_ocor_benef_p 
-- Deve inativar também as ocorrências de faturamento que foram geradas através de uma ocorrência de pagamento. 
or	nr_seq_ocor_pag		= nr_seq_ocor_benef_p;
  
-- inativa ou ativa as glosas vinculadas a ocorrência 
for r_C01_w in C01(nr_seq_ocor_benef_p) loop 
  CALL pls_gerencia_dados_ocor_pck.pls_gerencia_situacao_glosa( r_C01_w.nr_seq_glosa, ie_situacao_p, nm_usuario_p, null, ie_opcao_p);
end loop;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_dados_ocor_pck.pls_gerencia_situacao_ocor ( nr_seq_ocor_benef_p pls_ocorrencia_benef.nr_sequencia%type, ie_situacao_p pls_ocorrencia_benef.ie_situacao%type, nm_usuario_p usuario.nm_usuario%type, ie_opcao_p text) FROM PUBLIC;
