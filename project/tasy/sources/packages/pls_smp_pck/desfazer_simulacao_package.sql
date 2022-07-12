-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_smp_pck.desfazer_simulacao ( nr_seq_simulacao_p pls_smp.nr_sequencia%type) AS $body$
BEGIN

-- Desvincula a simulacao do prestador selecionada.
CALL pls_smp_pck.limpar_selecao_result_prest(nr_seq_simulacao_p);

-- apaga as regras de preco
delete	from	pls_smp_result_regra	a
where	exists (	SELECT	1
		from	pls_smp_result_item	b
		where	a.nr_seq_smp_result_regra 	= b.nr_sequencia
		and	exists (	select	1
				from	pls_smp_result_prest	x
				where	x.nr_sequencia	= b.nr_seq_smp_result_prest
				and	x.nr_seq_smp	= nr_seq_simulacao_p));

delete	from	pls_smp_result_item	b
where	exists (	SELECT	1
		from	pls_smp_result_prest	x
		where	x.nr_sequencia	= b.nr_seq_smp_result_prest
		and	x.nr_seq_smp	= nr_seq_simulacao_p);
		
delete from pls_smp_result_prest where nr_seq_smp = nr_seq_simulacao_p;
delete from pls_smp_result_benef where nr_seq_smp = nr_seq_simulacao_p;

update	pls_smp
set	dt_geracao	 = NULL
where	nr_sequencia	= nr_seq_simulacao_p;
	
commit;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_smp_pck.desfazer_simulacao ( nr_seq_simulacao_p pls_smp.nr_sequencia%type) FROM PUBLIC;