-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.delete_proc_regra_opme (tb_seq_proc_excluir_p INOUT pls_util_cta_pck.t_number_table) AS $body$
BEGIN

	if (tb_seq_proc_excluir_p.count > 0) then
		
		forall i in tb_seq_proc_excluir_p.first..tb_seq_proc_excluir_p.last
			delete	FROM pls_fatura_proc
			where	nr_seq_conta_proc	= tb_seq_proc_excluir_p(i);

		forall i in tb_seq_proc_excluir_p.first..tb_seq_proc_excluir_p.last
			delete	FROM pls_conta_pos_proc
			where	nr_seq_conta_proc	= tb_seq_proc_excluir_p(i);
			
		forall i in tb_seq_proc_excluir_p.first..tb_seq_proc_excluir_p.last
			delete	FROM pls_analise_fluxo_item
			where	nr_seq_conta_proc	= tb_seq_proc_excluir_p(i);
		
		forall i in tb_seq_proc_excluir_p.first..tb_seq_proc_excluir_p.last
			delete	FROM pls_ocorrencia_benef
			where	nr_seq_conta_proc	= tb_seq_proc_excluir_p(i);
		
		forall i in tb_seq_proc_excluir_p.first..tb_seq_proc_excluir_p.last
			delete	FROM pls_hist_analise_conta
			where	nr_seq_conta_proc	= tb_seq_proc_excluir_p(i);
			
		forall i in tb_seq_proc_excluir_p.first..tb_seq_proc_excluir_p.last
			delete	FROM pls_conta_proc
			where	nr_sequencia		= tb_seq_proc_excluir_p(i);
		
	end if;
	tb_seq_proc_excluir_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.delete_proc_regra_opme (tb_seq_proc_excluir_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;
