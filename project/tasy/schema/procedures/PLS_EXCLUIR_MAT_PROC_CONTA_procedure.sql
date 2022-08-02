-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_mat_proc_conta ( nr_sequencia_p bigint, nr_seq_conta_p bigint, ie_tipo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE
 			
/* 
	ie_tipo_p:  'P' = procedimentos 
	ie_tipo_p:  'M' = mat/med 
*/
 

BEGIN 
 
CALL pls_desfazer_consistir_conta(nr_seq_conta_p, cd_estabelecimento_p, nm_usuario_p);	
 
if (ie_tipo_p = 'P') then 
	delete from pls_conta_proc 
	where nr_sequencia = nr_sequencia_p;
elsif (ie_tipo_p = 'M') then 
	delete from pls_conta_mat 
	where nr_sequencia = nr_sequencia_p;
end if;	
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_mat_proc_conta ( nr_sequencia_p bigint, nr_seq_conta_p bigint, ie_tipo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

