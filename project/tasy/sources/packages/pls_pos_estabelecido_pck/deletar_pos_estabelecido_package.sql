-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.deletar_pos_estabelecido ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type ) AS $body$
DECLARE


qt_fat_w	integer;
qt_mens_w	integer;

C01 CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_seq_conta_proc
	from	pls_conta_pos_proc
	where	nr_seq_conta = nr_seq_conta_pc
	and	ie_status_faturamento	!= 'A'
	and	(nr_seq_regra_tx_opme IS NOT NULL AND nr_seq_regra_tx_opme::text <> '');
				
BEGIN

CALL exec_sql_dinamico('Tasy',' truncate table w_pls_conta_pos_proc ');
CALL exec_sql_dinamico('Tasy',' truncate table w_pls_conta_pos_mat ');

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	select	count(1)
	into STRICT	qt_fat_w
	from	pls_fatura_proc a,
		pls_conta_pos_proc b
	where	b.nr_sequencia = a.nr_seq_pos_proc
	and	b.nr_seq_conta = nr_seq_conta_p;
	
	if (qt_fat_w = 0) then
		select	count(1)
		into STRICT	qt_fat_w
		from	pls_fatura_mat a,
			pls_conta_pos_mat b
		where	b.nr_sequencia = a.nr_seq_pos_mat
		and	b.nr_seq_conta = nr_seq_conta_p;
	end if;
	
	if (qt_fat_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190837);
	end if;
	
	select	count(1)
	into STRICT	qt_mens_w
	from	pls_mensalidade_item_conta a,
		pls_conta_pos_proc b
	where	b.nr_sequencia = a.nr_seq_pos_proc
	and	b.nr_seq_conta = nr_seq_conta_p;
	
	if (qt_mens_w = 0) then
		select	count(1)
		into STRICT	qt_mens_w
		from	pls_mensalidade_item_conta a,
			pls_conta_pos_mat b
		where	b.nr_sequencia = a.nr_seq_pos_mat
		and	b.nr_seq_conta = nr_seq_conta_p;
	end if;
	
	if (qt_mens_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(338044);
	end if;
	
	for r_c01_w in C01(nr_seq_conta_p) loop
		delete	FROM pls_fatura_proc
		where	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
		
		delete	FROM pls_pos_estab_dados_contab
		where 	nr_seq_pos_proc_contab in (	SELECT	a.nr_sequencia
							from	pls_conta_pos_proc_contab	a,
								pls_conta_pos_proc		b
							where	a.nr_seq_conta_pos_proc		= b.nr_sequencia
							and	b.ie_status_faturamento		!= 'A'
							and 	nr_seq_conta_proc 		= r_c01_w.nr_seq_conta_proc);
		
		delete	FROM pls_conta_pos_proc
		where	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc
		and	ie_status_faturamento	!= 'A';
		
		delete 	FROM pls_analise_fluxo_ocor
		where 	NR_SEQ_FLUXO_ITEM     in (	SELECT 	nr_sequencia
							from	pls_analise_fluxo_item
							where	nr_seq_conta_proc	= r_c01_w.nr_seq_conta_proc);
		
		delete	FROM pls_analise_fluxo_item
		where	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
		
		delete	FROM pls_ocorrencia_benef
		where	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
		
		delete	FROM pls_hist_analise_conta
		where	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
		
		delete	FROM pls_conta_proc	a
		where	a.nr_sequencia = r_c01_w.nr_seq_conta_proc
		and	not exists (	SELECT	1
					from	pls_conta_pos_proc	x
					where	x.nr_seq_conta_proc	= a.nr_sequencia
					and	x.ie_status_faturamento	= 'A');
	end loop;
	
	delete	FROM pls_conta_pos_pac_fat
	where	nr_seq_pos_proc in (	SELECT	nr_sequencia
					from	pls_conta_pos_proc
					where	nr_seq_conta = nr_seq_conta_p
					and	ie_status_faturamento		!= 'A');
					
	delete	FROM pls_conta_pos_pac_fat
	where	nr_seq_pos_mat in (	SELECT	nr_sequencia
					from	pls_conta_pos_mat
					where	nr_seq_conta = nr_seq_conta_p
					and	ie_status_faturamento		!= 'A');
	

	delete	FROM pls_pos_estab_dados_contab
	where 	nr_seq_pos_proc_contab in (	SELECT	a.nr_sequencia
							from	pls_conta_pos_proc_contab	a,
								pls_conta_pos_proc		b
							where	b.nr_sequencia			= a.nr_seq_conta_pos_proc
							and	b.ie_status_faturamento		!= 'A'
							and	a.nr_seq_conta			= nr_seq_conta_p);
	
	delete	FROM pls_pos_estab_dados_contab
	where 	nr_seq_pos_mat_contab in (	SELECT	a.nr_sequencia
							from	pls_conta_pos_mat_contab	a,
								pls_conta_pos_mat		b
							where	b.nr_sequencia			= a.nr_seq_conta_mat_pos
							and	b.ie_status_faturamento		!= 'A'
							and	a.nr_seq_conta			= nr_seq_conta_p);

	delete	FROM pls_conta_pos_proc
	where	nr_seq_conta = nr_seq_conta_p
	and	ie_status_faturamento		!= 'A';
	
	delete	FROM pls_conta_pos_mat
	where	nr_seq_conta = nr_seq_conta_p
	and	ie_status_faturamento		!= 'A';
	
elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	select	count(1)
	into STRICT	qt_fat_w
	from	pls_fatura_proc a,
		pls_conta_pos_proc b
	where	b.nr_sequencia = a.nr_seq_pos_proc
	and	b.nr_seq_conta_proc = nr_seq_conta_proc_p;
	
	if (qt_fat_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190837);
	end if;
	
	select	count(1)
	into STRICT	qt_mens_w
	from	pls_mensalidade_item_conta a,
		pls_conta_pos_proc b
	where	b.nr_sequencia = a.nr_seq_pos_proc
	and	b.nr_seq_conta_proc = nr_seq_conta_proc_p;
	
	if (qt_mens_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(338044);
	end if;
	
	delete	FROM pls_conta_pos_pac_fat
	where	nr_seq_pos_proc in (	SELECT	nr_sequencia
					from	pls_conta_pos_proc
					where	nr_seq_conta_proc = nr_seq_conta_proc_p
					and	ie_status_faturamento		!= 'A');

	delete	FROM pls_pos_estab_dados_contab
	where 	nr_seq_pos_proc_contab in (	SELECT	a.nr_sequencia
						from	pls_conta_pos_proc_contab	a,
							pls_conta_pos_proc		b
						where	a.nr_seq_conta_pos_proc		= b.nr_sequencia
						and 	b.nr_seq_conta_proc 		= nr_seq_conta_proc_p
						and	b.ie_status_faturamento		!= 'A');

	delete	FROM pls_conta_pos_proc
	where	nr_seq_conta_proc = nr_seq_conta_proc_p
	and	ie_status_faturamento		!= 'A';
	
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
	select	count(1)
	into STRICT	qt_fat_w
	from	pls_fatura_mat a,
		pls_conta_pos_mat b
	where	b.nr_sequencia = a.nr_seq_pos_mat
	and	b.nr_seq_conta_mat = nr_seq_conta_mat_p;
	
	if (qt_fat_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190837);
	end if;
	
	select	count(1)
	into STRICT	qt_mens_w
	from	pls_mensalidade_item_conta a,
		pls_conta_pos_mat b
	where	b.nr_sequencia = a.nr_seq_pos_mat
	and	b.nr_seq_conta_mat = nr_seq_conta_mat_p;
	
	if (qt_mens_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(338044);
	end if;
					
	delete	FROM pls_conta_pos_pac_fat
	where	nr_seq_pos_mat in (	SELECT	nr_sequencia
					from	pls_conta_pos_mat
					where	nr_seq_conta_mat = nr_seq_conta_mat_p
					and	ie_status_faturamento		!= 'A');
					
	delete	FROM pls_pos_estab_dados_contab
	where 	nr_seq_pos_mat_contab in (	SELECT	a.nr_sequencia
						from	pls_conta_pos_mat_contab	a,
							pls_conta_pos_mat		b
						where	a.nr_seq_conta_mat_pos		= a.nr_sequencia
						and	b.ie_status_faturamento		!= 'A'
						and 	b.nr_seq_conta_mat 		= nr_seq_conta_mat_p);
	
	delete	FROM pls_conta_pos_mat
	where	nr_seq_conta_mat = nr_seq_conta_mat_p
	and	ie_status_faturamento		!= 'A';

end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.deletar_pos_estabelecido ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type ) FROM PUBLIC;
