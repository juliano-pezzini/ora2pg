-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.atualiza_registro_arred ( tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_trib_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_nao_ret_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_ba_nao_ret_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_trib_adic_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_ba_trib_adic_arred_p INOUT pls_util_cta_pck.t_number_table, nr_cont_p INOUT integer) AS $body$
BEGIN

if (tb_nr_sequencia_p.count > 0) then

	forall i in tb_nr_sequencia_p.first..tb_nr_sequencia_p.last
		update	pls_pp_base_atual_trib
		set	vl_base = vl_base + tb_vl_base_arred_p(i),
			vl_tributo = vl_tributo + tb_vl_trib_arred_p(i),
			vl_nao_retido = vl_nao_retido + tb_vl_nao_ret_arred_p(i),
			vl_base_nao_retido = vl_base_nao_retido + tb_vl_ba_nao_ret_arred_p(i),
			vl_trib_adic = vl_trib_adic + tb_vl_trib_adic_arred_p(i),
			vl_base_adic = vl_base_adic + tb_vl_ba_trib_adic_arred_p(i)
		where	nr_sequencia = tb_nr_sequencia_p(i);
	commit;
end if;

tb_nr_sequencia_p.delete;
tb_vl_base_arred_p.delete;
tb_vl_trib_arred_p.delete;
tb_vl_nao_ret_arred_p.delete;
tb_vl_ba_nao_ret_arred_p.delete;
tb_vl_trib_adic_arred_p.delete;
tb_vl_ba_trib_adic_arred_p.delete;
nr_cont_p := 0;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.atualiza_registro_arred ( tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_trib_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_nao_ret_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_ba_nao_ret_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_trib_adic_arred_p INOUT pls_util_cta_pck.t_number_table, tb_vl_ba_trib_adic_arred_p INOUT pls_util_cta_pck.t_number_table, nr_cont_p INOUT integer) FROM PUBLIC;
