-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atual_comp_contab_val_adic ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, dt_mes_competencia_p pls_protocolo_conta.dt_mes_competencia%type, ie_opcao_p text) AS $body$
DECLARE
				
/*ie_opcao_p 
	T - Todos  	 
	P - pls_conta_pos_estab_contab  	 
	C- pls_conta_copartic_contab			 
*/
 

BEGIN 
	--Se optou por atualizar mês competência da pls_conta_pos_estab_contab ou todos. 
	if (ie_opcao_p in ('P','T')) then 
	 
		update	pls_conta_pos_estab_contab 
		set	dt_mes_competencia = dt_mes_competencia_p 
		where	nr_sequencia in (	SELECT	a.nr_sequencia 
						from	pls_conta_pos_estab_contab a, 
							pls_conta_pos_estabelecido b, 
							pls_conta c 
						where	a.nr_seq_conta_pos = b.nr_sequencia 
						and	b.nr_seq_conta = c.nr_sequencia 
						and 	c.nr_seq_protocolo = nr_seq_protocolo_p);
		commit;
	end if;	
	 
	--Se optou por atualizar mês competência da pls_conta_copartic_contab ou todos 
	if (ie_opcao_p in ('C','T')) then 
		 
		update	pls_conta_copartic_contab 
		set	dt_mes_competencia = dt_mes_competencia_p 
		where 	nr_sequencia in (	SELECT	a.nr_sequencia 
						from	pls_conta_copartic_contab a, 
							pls_conta_coparticipacao b, 
							pls_conta c 
						where	a.nr_seq_conta_copartic = b.nr_sequencia 
						and	b.nr_seq_conta = c.nr_sequencia 
						and 	c.nr_seq_protocolo = nr_seq_protocolo_p);
		commit;
		 
	end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atual_comp_contab_val_adic ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, dt_mes_competencia_p pls_protocolo_conta.dt_mes_competencia%type, ie_opcao_p text) FROM PUBLIC;

