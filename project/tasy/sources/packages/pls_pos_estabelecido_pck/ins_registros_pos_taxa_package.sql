-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.ins_registros_pos_taxa ( tb_proc_nr_seq_pos_estab_p INOUT pls_util_cta_pck.t_number_table, tb_proc_nr_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_proc_vl_taxa_pos_p INOUT pls_util_cta_pck.t_number_table, tb_proc_ie_tipo_taxa_p INOUT pls_util_cta_pck.t_varchar2_table_1, ie_tipo_item_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	if (tb_proc_nr_seq_pos_estab_p.count > 0) then
		
		if (ie_tipo_item_p = 'P') then
			
			forall i in tb_proc_nr_seq_pos_estab_p.first..tb_proc_nr_seq_pos_estab_p.last
				insert into pls_conta_pos_proc_tx(	nr_sequencia, ie_tipo_taxa, vl_taxa_manutencao,
						dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
						nm_usuario_nrec, nr_seq_regra_pos_estab, nr_seq_conta_pos_proc)
				values (	nextval('pls_conta_pos_proc_tx_seq'), tb_proc_ie_tipo_taxa_p(i), tb_proc_vl_taxa_pos_p(i),
						clock_timestamp(), nm_usuario_p, clock_timestamp(),
						nm_usuario_p, tb_proc_nr_seq_regra_p(i), tb_proc_nr_seq_pos_estab_p(i));
		
		else
		
			forall i in tb_proc_nr_seq_pos_estab_p.first..tb_proc_nr_seq_pos_estab_p.last
				insert into pls_conta_pos_mat_tx(	nr_sequencia, ie_tipo_taxa, vl_taxa_manutencao,
						dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
						nm_usuario_nrec, nr_seq_regra_pos_estab, nr_seq_conta_mat_pos)
				values (	nextval('pls_conta_pos_mat_tx_seq'), tb_proc_ie_tipo_taxa_p(i), tb_proc_vl_taxa_pos_p(i),
						clock_timestamp(), nm_usuario_p, clock_timestamp(),
						nm_usuario_p, tb_proc_nr_seq_regra_p(i), tb_proc_nr_seq_pos_estab_p(i));
		
		end if;
		commit;
	
	end if;
	tb_proc_nr_seq_pos_estab_p.delete;
	tb_proc_nr_seq_regra_p.delete;	
	tb_proc_vl_taxa_pos_p.delete;	
	tb_proc_ie_tipo_taxa_p.delete;	
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.ins_registros_pos_taxa ( tb_proc_nr_seq_pos_estab_p INOUT pls_util_cta_pck.t_number_table, tb_proc_nr_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_proc_vl_taxa_pos_p INOUT pls_util_cta_pck.t_number_table, tb_proc_ie_tipo_taxa_p INOUT pls_util_cta_pck.t_varchar2_table_1, ie_tipo_item_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;