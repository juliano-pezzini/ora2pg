-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_contas_prot_web ( nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_ger_hono_incos_p text) AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:  Consistir todas as contas do protocolo na digitação de contas médicas 
---------------------------------------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ x ] Portal [ ] Relatórios [ ] Outros: 
 ---------------------------------------------------------------------------------------------------------------------------------------------------- 
Pontos de atenção:  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/ 
 
nr_seq_protocolo_w		bigint;	
nr_seq_conta_w			bigint;		
 
C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_conta 
	where	nr_seq_protocolo = nr_seq_protocolo_w;
	

BEGIN 
 
nr_seq_protocolo_w := nr_seq_protocolo_p;
 
open C01;
loop 
fetch C01 into 
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
		CALL pls_desfazer_consistir_conta(nr_seq_conta_w,cd_estabelecimento_p,nm_usuario_p);	
	end;
end loop;
close C01;
 
CALL pls_consistir_conta_web(nr_seq_protocolo_w , null, 'D', nm_usuario_p, cd_estabelecimento_p, ie_ger_hono_incos_p);
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_contas_prot_web ( nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_ger_hono_incos_p text) FROM PUBLIC;

