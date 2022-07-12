-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.ins_atualiza_vl_tx_contab ( tb_seq_pos_estab_tx_p INOUT pls_util_cta_pck.t_number_table, tb_vl_taxa_p INOUT pls_util_cta_pck.t_number_table, tb_seq_conta_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type, ie_tipos_item_p text) AS $body$
BEGIN

	if (tb_seq_pos_estab_tx_p.count > 0) then
		
		if (ie_tipos_item_p = 'P') then
		
			forall i in tb_seq_pos_estab_tx_p.first..tb_seq_pos_estab_tx_p.last
				insert into pls_conta_pos_proc_tx_ctb(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						nr_seq_proc_pos_tx, vl_taxa,nr_seq_conta)
				values (	nextval('pls_conta_pos_proc_tx_ctb_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 
						tb_seq_pos_estab_tx_p(i), tb_vl_taxa_p(i), tb_seq_conta_p(i));

			
		else
			forall i in tb_seq_pos_estab_tx_p.first..tb_seq_pos_estab_tx_p.last
				insert into pls_conta_pos_mat_tx_ctb(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						nr_seq_pos_mat_tx,vl_taxa,nr_seq_conta)
				values (	nextval('pls_conta_pos_mat_tx_ctb_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 
						tb_seq_pos_estab_tx_p(i), tb_vl_taxa_p(i), tb_seq_conta_p(i));
		
		end if;
		commit;
		
	end if;
	tb_seq_pos_estab_tx_p.delete;
	tb_vl_taxa_p.delete;
	tb_seq_conta_p.delete;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.ins_atualiza_vl_tx_contab ( tb_seq_pos_estab_tx_p INOUT pls_util_cta_pck.t_number_table, tb_vl_taxa_p INOUT pls_util_cta_pck.t_number_table, tb_seq_conta_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type, ie_tipos_item_p text) FROM PUBLIC;
