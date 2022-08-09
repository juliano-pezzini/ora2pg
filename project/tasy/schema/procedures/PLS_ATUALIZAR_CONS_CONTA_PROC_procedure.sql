-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_cons_conta_proc ( nr_sequencia_p bigint, ie_gravar_log_p text, nr_seq_conta_proc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_gravar_log_p IS NOT NULL AND ie_gravar_log_p::text <> '') and (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then 
	begin 
	 
	CALL pls_atualiza_valor_proc( 
		nr_sequencia_p, 
		ie_gravar_log_p, 
		nm_usuario_p,'S',null,null);
	 
	commit;
	 
	CALL pls_consistir_conta_proc( 
		nr_seq_conta_proc_p, 
		cd_estabelecimento_p, 
		'N', 
		nm_usuario_p);
	 
	commit;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_cons_conta_proc ( nr_sequencia_p bigint, ie_gravar_log_p text, nr_seq_conta_proc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
