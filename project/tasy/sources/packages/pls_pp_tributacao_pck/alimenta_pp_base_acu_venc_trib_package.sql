-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.alimenta_pp_base_acu_venc_trib ( nr_cont_p INOUT integer, tb_nr_seq_lote_ant_p INOUT pls_util_cta_pck.t_number_table, tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tributo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_calc_p INOUT pls_util_cta_pck.t_number_table, tb_cd_pf_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_dt_comp_base_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_tipo_prest_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_prest_p INOUT pls_util_cta_pck.t_number_table, tb_ie_tipo_trib_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_vl_base_adic_p INOUT pls_util_cta_pck.t_number_table, nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (tb_nr_sequencia_p.count > 0) then

	forall i in tb_nr_sequencia_p.first..tb_nr_sequencia_p.last
		insert into pls_pp_base_acum_trib(
			nr_sequencia, dt_atualizacao_nrec, dt_atualizacao,
			nm_usuario_nrec, nm_usuario, nr_seq_venc_trib,
			ie_origem, cd_pessoa_fisica, vl_base,
			vl_item, vl_tributo, dt_competencia, 
			ie_tipo_contratacao, cd_tributo, nr_seq_tipo_prestador,
			nr_seq_prestador, ie_tipo_tributo, vl_base_adic,
			vl_base_nao_retido, vl_nao_retido, vl_trib_adic,
			nr_seq_lote_pgto_ant, nr_seq_lote_pgto_orig
		) values (
			nextval('pls_pp_base_acum_trib_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, tb_nr_sequencia_p(i),
			'PP', tb_cd_pf_p(i), tb_vl_base_calc_p(i), 
			tb_vl_base_calc_p(i), tb_vl_tributo_p(i), tb_dt_comp_base_p(i), 
			'S', cd_tributo_p, tb_nr_seq_tipo_prest_p(i),
			tb_nr_seq_prest_p(i), tb_ie_tipo_trib_p(i), tb_vl_base_adic_p(i),
			0, 0, 0,
			tb_nr_seq_lote_ant_p(i), nr_seq_lote_p
		);
	commit;
end if;

nr_cont_p := 0;
tb_nr_seq_lote_ant_p.delete;
tb_nr_sequencia_p.delete;
tb_vl_tributo_p.delete;
tb_vl_base_calc_p.delete;
tb_cd_pf_p.delete;
tb_dt_comp_base_p.delete;
tb_nr_seq_tipo_prest_p.delete;
tb_nr_seq_prest_p.delete;
tb_ie_tipo_trib_p.delete;
tb_vl_base_adic_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.alimenta_pp_base_acu_venc_trib ( nr_cont_p INOUT integer, tb_nr_seq_lote_ant_p INOUT pls_util_cta_pck.t_number_table, tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_vl_tributo_p INOUT pls_util_cta_pck.t_number_table, tb_vl_base_calc_p INOUT pls_util_cta_pck.t_number_table, tb_cd_pf_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_dt_comp_base_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_tipo_prest_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_prest_p INOUT pls_util_cta_pck.t_number_table, tb_ie_tipo_trib_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_vl_base_adic_p INOUT pls_util_cta_pck.t_number_table, nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
