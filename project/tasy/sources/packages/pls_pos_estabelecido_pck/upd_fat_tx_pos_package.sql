-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Rotina respons_vel apenas pela atualizacao dos registros de faturamento de tx_adm de p_s-estabelecido



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.upd_fat_tx_pos ( tb_cta_fat_taxa_p INOUT pls_util_cta_pck.t_number_table, tb_vl_fat_taxa_p INOUT pls_util_cta_pck.t_number_table, tb_seq_resumo_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type, ie_tipo_item_p text) AS $body$
BEGIN
	if (tb_cta_fat_taxa_p.count > 0) then
	
		if (ie_tipo_item_p = 'P') then
			
			forall i in tb_cta_fat_taxa_p.first..tb_cta_fat_taxa_p.last
				update	pls_conta_pos_proc_tx_fat
				set	nr_seq_conta_resumo	= tb_seq_resumo_p(i), 
					vl_taxa			= tb_vl_fat_taxa_p(i)
				where	nr_sequencia		= tb_cta_fat_taxa_p(i);
		
		else
			forall i in tb_cta_fat_taxa_p.first..tb_cta_fat_taxa_p.last
				update	pls_conta_pos_mat_tx_ctb
				set	nr_seq_conta_resumo	= tb_seq_resumo_p(i),
					vl_taxa			= tb_vl_fat_taxa_p(i)
				where	nr_sequencia		= tb_cta_fat_taxa_p(i);
		end if;
	
	end if;
	tb_cta_fat_taxa_p.delete;
	tb_vl_fat_taxa_p.delete;	
	tb_seq_resumo_p.delete;	
			
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.upd_fat_tx_pos ( tb_cta_fat_taxa_p INOUT pls_util_cta_pck.t_number_table, tb_vl_fat_taxa_p INOUT pls_util_cta_pck.t_number_table, tb_seq_resumo_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type, ie_tipo_item_p text) FROM PUBLIC;