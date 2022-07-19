-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_recalcular_vl_inter_conta ( nr_seq_conta_p bigint, ie_commit_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	pe.nr_seq_conta_proc nr_sequencia, 
		pe.nr_seq_conta 
	from	pls_conta_pos_estabelecido pe, 
		pls_conta c 
	where	pe.nr_seq_conta = c.nr_sequencia 
	and	c.nr_sequencia	= nr_seq_conta_p 
	and	(pe.nr_seq_conta_proc IS NOT NULL AND pe.nr_seq_conta_proc::text <> '') 
	and	((pe.ie_situacao	= 'A') or (coalesce(pe.ie_situacao::text, '') = '')) 
	and	not exists (SELECT 1 
				from	pls_fatura_proc fp 
				where	fp.nr_seq_conta_pos_estab = pe.nr_sequencia) 
	and	not exists (select 1 
				from	pls_fatura_mat fp 
				where	fp.nr_seq_conta_pos_estab = pe.nr_sequencia);

C02 CURSOR FOR 
	SELECT	pe.nr_seq_conta_mat nr_seq_conta_mat, 
		pe.nr_seq_conta 
	from 	pls_conta_pos_estabelecido pe, 
		pls_conta c 
	where	pe.nr_seq_conta = c.nr_sequencia 
	and	c.nr_sequencia	= nr_seq_conta_p 
	and	(pe.nr_seq_conta_mat IS NOT NULL AND pe.nr_seq_conta_mat::text <> '') 
	and	((pe.ie_situacao	= 'A') or (coalesce(pe.ie_situacao::text, '') = '')) 
	and 	not exists (SELECT	1 
				from	pls_fatura_proc fp 
				where	fp.nr_seq_conta_pos_estab = pe.nr_sequencia) 
	and	not exists (select	1 
				from	pls_fatura_mat fp 
				where	fp.nr_seq_conta_pos_estab = pe.nr_sequencia);

BEGIN 
 
for r_c01_w in C01() loop 
	begin 
	CALL pls_gerar_valor_pos_estab( r_c01_w.nr_seq_conta, nm_usuario_p, 'F',r_c01_w.nr_sequencia, null, 'A');
	 
	if (coalesce(ie_commit_p,'N') = 'S') then 
		commit;
	end if;
	end;
end loop;
 
for r_c02_w in C02() loop 
	begin 
	CALL pls_gerar_valor_pos_estab( r_c02_w.nr_seq_conta, nm_usuario_p, 'F',null, r_c02_w.nr_seq_conta_mat, 'C');
 
	if (coalesce(ie_commit_p,'N') = 'S') then 
		commit;
	end if;
	end;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_vl_inter_conta ( nr_seq_conta_p bigint, ie_commit_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

