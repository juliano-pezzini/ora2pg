-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.alimenta_campo_espec_conv ( tb_nr_seq_item_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_fornec_mat_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_setor_atend_p INOUT pls_util_cta_pck.t_number_table) AS $body$
BEGIN

if (tb_nr_seq_item_p.count > 0) then

	forall i in tb_nr_seq_item_p.first..tb_nr_seq_item_p.last
		update	pls_conta_item_imp_tmp
		set	nr_seq_fornec_mat_conv = tb_nr_seq_fornec_mat_p(i),
			nr_seq_setor_atend_conv = tb_nr_seq_setor_atend_p(i)
		where	nr_sequencia = tb_nr_seq_item_p(i);
	commit;
end if;

tb_nr_seq_item_p.delete;
tb_nr_seq_fornec_mat_p.delete;
tb_nr_seq_setor_atend_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.alimenta_campo_espec_conv ( tb_nr_seq_item_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_fornec_mat_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_setor_atend_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;