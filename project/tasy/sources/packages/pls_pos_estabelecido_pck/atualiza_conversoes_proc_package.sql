-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.atualiza_conversoes_proc ( tb_seq_item_p INOUT pls_util_cta_pck.t_number_table, tb_proc_conv_p INOUT pls_util_cta_pck.t_number_table, tb_origem_proc_conv_p INOUT pls_util_cta_pck.t_number_table, tb_proc_conv_xml_p INOUT pls_util_cta_pck.t_number_table, tb_origem_proc_conv_xml_p INOUT pls_util_cta_pck.t_number_table, tb_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_seq_regra_xml_p INOUT pls_util_cta_pck.t_number_table) AS $body$
BEGIN

	if ( tb_seq_item_p.count > 0) then
	
		forall i in tb_seq_item_p.first..tb_seq_item_p.last
			update	w_pls_conta_pos_proc
			set	cd_procedimento_conv	= tb_proc_conv_p(i),
				ie_origem_proced_conv 	= tb_origem_proc_conv_p(i),
				cd_procedimento_conv_xml = tb_proc_conv_xml_p(i),
				ie_origem_conv_xml 	= tb_origem_proc_conv_xml_p(i),
				nr_seq_regra_conv	= tb_seq_regra_p(i),
				nr_seq_regra_conv_xml	= tb_seq_regra_xml_p(i)
			where	nr_sequencia = tb_seq_item_p(i);
			
	end if;
	
	tb_seq_item_p.delete;
	tb_proc_conv_p.delete;
	tb_origem_proc_conv_p.delete;
	tb_proc_conv_xml_p.delete;
	tb_origem_proc_conv_xml_p.delete;
	tb_seq_regra_p.delete;
	tb_seq_regra_xml_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.atualiza_conversoes_proc ( tb_seq_item_p INOUT pls_util_cta_pck.t_number_table, tb_proc_conv_p INOUT pls_util_cta_pck.t_number_table, tb_origem_proc_conv_p INOUT pls_util_cta_pck.t_number_table, tb_proc_conv_xml_p INOUT pls_util_cta_pck.t_number_table, tb_origem_proc_conv_xml_p INOUT pls_util_cta_pck.t_number_table, tb_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_seq_regra_xml_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;
