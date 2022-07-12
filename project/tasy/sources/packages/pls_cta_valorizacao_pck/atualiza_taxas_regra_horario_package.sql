-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Rotina onde e realizado o update do campo nr_seq_regra_horario nos  procedimentos.



CREATE OR REPLACE PROCEDURE pls_cta_valorizacao_pck.atualiza_taxas_regra_horario ( tb_seq_proc_p dbms_sql.number_table, tb_regras_p dbms_sql.number_table) AS $body$
BEGIN
	if (tb_seq_proc_p.count > 0 ) then
		--Faz update dos registros(delimitados)

		forall i in tb_seq_proc_p.first..tb_seq_proc_p.last				
			update	pls_conta_proc
			set	nr_seq_regra_horario	= tb_regras_p(i)		
			where	nr_sequencia		= tb_seq_proc_p(i);
			commit;
	end if;	
null;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_valorizacao_pck.atualiza_taxas_regra_horario ( tb_seq_proc_p dbms_sql.number_table, tb_regras_p dbms_sql.number_table) FROM PUBLIC;