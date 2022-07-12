-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_envio_ans_extra_pck.totaliza_itens ( nr_seq_cta_val_p pls_monitor_tiss_mat_val.nr_seq_cta_val%type) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	sum(vl_liberado) vl_liberado,
		nr_seq_conta_proc,
		max(nr_sequencia) nr_seq_manter
	from 	pls_monitor_tiss_proc_val
	where 	nr_seq_cta_val = nr_seq_cta_val_p
	group by nr_seq_conta_proc;

C02 CURSOR FOR
	SELECT	sum(vl_liberado) vl_liberado,
		nr_seq_conta_mat,
		max(nr_sequencia) nr_seq_manter
	from 	pls_monitor_tiss_mat_val
	where 	nr_seq_cta_val = nr_seq_cta_val_p
	group by nr_seq_conta_mat;
BEGIN

	for r_c01_w in C01 loop
		update 	pls_monitor_tiss_proc_val
		set 	vl_liberado  = r_c01_w.vl_liberado,
			vl_glosa = vl_procedimento - r_c01_w.vl_liberado
		where 	nr_seq_cta_val = nr_seq_cta_val_p
		and 	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
		
		delete from pls_monitor_tiss_proc_val
		where 	nr_seq_cta_val = nr_seq_cta_val_p
		and 	nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc
		and 	nr_sequencia != r_c01_w.nr_seq_manter;
		
	end loop;
	
	for r_c02_w in C02 loop
		update 	pls_monitor_tiss_mat_val
		set 	vl_liberado  = r_c02_w.vl_liberado,
			vl_glosa = vl_material - r_c02_w.vl_liberado
		where 	nr_seq_cta_val = nr_seq_cta_val_p
		and 	nr_seq_conta_mat = r_c02_w.nr_seq_conta_mat;
		
		delete from pls_monitor_tiss_mat_val
		where 	nr_seq_cta_val = nr_seq_cta_val_p
		and 	nr_seq_conta_mat = r_c02_w.nr_seq_conta_mat
		and 	nr_sequencia != r_c02_w.nr_seq_manter;
		
		
	end loop;
	commit;

	
	
end;

--Caso uma conta tenha seus registros de pagamento presentes no lote, mas tambem ja ha registros de pagamento de recurso, entao o sistema condensa isso,
--removendo o valor liberado no recurso do vl_glosa da conta e adicionando ao valor liberado da mesma, alem de nao enviar o registro do recurso nesse lote mais
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_envio_ans_extra_pck.totaliza_itens ( nr_seq_cta_val_p pls_monitor_tiss_mat_val.nr_seq_cta_val%type) FROM PUBLIC;