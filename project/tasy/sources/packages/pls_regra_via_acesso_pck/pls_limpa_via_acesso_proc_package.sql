-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_regra_via_acesso_pck.pls_limpa_via_acesso_proc ( nr_seq_conta_proc_p dbms_sql.number_table ) AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por limpar os dados referentes a via de acesso dos procedimentos
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	
	

BEGIN

if (nr_seq_conta_proc_p.count > 0) then
	forall i in nr_seq_conta_proc_p.first..nr_seq_conta_proc_p.last
		update	pls_conta_proc
		set	ie_via_acesso		= CASE WHEN coalesce(ie_tx_manual,'N')='S' THEN  ie_via_acesso  ELSE null END ,
			nr_seq_regra_via_acesso	 = NULL,
			tx_item			= CASE WHEN coalesce(ie_tx_manual,'N')='S' THEN  tx_item  ELSE CASE WHEN coalesce(ie_via_acesso,'X')='X' THEN 100  ELSE CASE WHEN coalesce(nr_seq_regra_qtde_exec,0)=0 THEN tx_item  ELSE 100 END  END  END ,
			nr_seq_proc_ref		 = NULL,
			ie_via_obrigatoria	= 'N'
		where	nr_sequencia		= nr_seq_conta_proc_p(i);				

	commit;		
	
	forall i in nr_seq_conta_proc_p.first..nr_seq_conta_proc_p.last
		update	pls_conta_proc_regra
		set	nr_seq_regra_via_obrig	 = NULL
		where	nr_sequencia		= nr_seq_conta_proc_p(i);
	commit;		
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_via_acesso_pck.pls_limpa_via_acesso_proc ( nr_seq_conta_proc_p dbms_sql.number_table ) FROM PUBLIC;