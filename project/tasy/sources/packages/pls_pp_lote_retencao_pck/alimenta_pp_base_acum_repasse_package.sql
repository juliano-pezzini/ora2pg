-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_retencao_pck.alimenta_pp_base_acum_repasse ( nr_cont_p INOUT integer, tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tributo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_calc_p INOUT pls_util_cta_pck.t_number_table, tb_vl_item_p INOUT pls_util_cta_pck.t_number_table, tb_cd_pf_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_nr_seq_prest_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_tipo_prest_p INOUT pls_util_cta_pck.t_number_table, tb_nr_repasse_terc_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_adic_p INOUT pls_util_cta_pck.t_number_table, tb_vl_trib_adic_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_nao_ret_p INOUT pls_util_cta_pck.t_number_table, tb_vl_nao_retido_p INOUT pls_util_cta_pck.t_number_table, nr_seq_lote_p pls_pp_lr_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (tb_nr_sequencia_p.count > 0) then

	forall i in tb_nr_sequencia_p.first..tb_nr_sequencia_p.last
		insert into pls_pp_lr_base_trib(
			nr_sequencia, dt_atualizacao_nrec, dt_atualizacao,
			nm_usuario_nrec, nm_usuario, nr_seq_vl_repasse,
			cd_pessoa_fisica, vl_base, vl_item,
			vl_tributo, ie_tipo_contratacao, cd_tributo, 
			nr_seq_prestador, nr_seq_tipo_prestador, ie_origem,
			nr_seq_lote_ret, nr_seq_repasse_terc, vl_base_adic, 
			vl_trib_adic, vl_base_nao_retido, vl_nao_retido
		) values (
			nextval('pls_pp_lr_base_trib_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, tb_nr_sequencia_p(i),
			tb_cd_pf_p(i), tb_vl_base_calc_p(i), tb_vl_item_p(i), 
			tb_vl_tributo_p(i), 'S', cd_tributo_p,
			tb_nr_seq_prest_p(i), tb_nr_seq_tipo_prest_p(i), 'RT',
			nr_seq_lote_p, tb_nr_repasse_terc_p(i), coalesce(tb_vl_base_adic_p(i), 0), 
			coalesce(tb_vl_trib_adic_p(i), 0), coalesce(tb_vl_base_nao_ret_p(i), 0), coalesce(tb_vl_nao_retido_p(i), 0)
		);
	commit;
end if;

nr_cont_p := 0;
tb_nr_sequencia_p.delete;
tb_vl_tributo_p.delete;
tb_vl_base_calc_p.delete;
tb_vl_item_p.delete;
tb_cd_pf_p.delete;
tb_nr_seq_prest_p.delete;
tb_nr_seq_tipo_prest_p.delete;
tb_nr_repasse_terc_p.delete;
tb_vl_base_adic_p.delete;
tb_vl_trib_adic_p.delete;
tb_vl_base_nao_ret_p.delete;
tb_vl_nao_retido_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_retencao_pck.alimenta_pp_base_acum_repasse ( nr_cont_p INOUT integer, tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tributo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_calc_p INOUT pls_util_cta_pck.t_number_table, tb_vl_item_p INOUT pls_util_cta_pck.t_number_table, tb_cd_pf_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_nr_seq_prest_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_tipo_prest_p INOUT pls_util_cta_pck.t_number_table, tb_nr_repasse_terc_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_adic_p INOUT pls_util_cta_pck.t_number_table, tb_vl_trib_adic_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_nao_ret_p INOUT pls_util_cta_pck.t_number_table, tb_vl_nao_retido_p INOUT pls_util_cta_pck.t_number_table, nr_seq_lote_p pls_pp_lr_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
