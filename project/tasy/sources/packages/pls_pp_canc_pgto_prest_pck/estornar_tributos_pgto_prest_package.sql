-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_canc_pgto_prest_pck.estornar_tributos_pgto_prest ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_prest_estor_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_item_lote_est_w	pls_util_cta_pck.t_number_table;
tb_nr_base_atual_trib_w	pls_util_cta_pck.t_number_table;
tb_cd_tributo_w		pls_util_cta_pck.t_number_table;
tb_dt_comp_base_calc_w	pls_util_cta_pck.t_date_table;
tb_ie_tipo_contrat_w	pls_util_cta_pck.t_varchar2_table_5;
tb_nr_seq_evento_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_trib_w	pls_util_cta_pck.t_number_table;
tb_nr_tipo_prest_w	pls_util_cta_pck.t_number_table;
tb_vl_base_w		pls_util_cta_pck.t_number_table;
tb_vl_base_adic_w	pls_util_cta_pck.t_number_table;
tb_vl_base_nao_ret_w	pls_util_cta_pck.t_number_table;
tb_vl_item_w		pls_util_cta_pck.t_number_table;
tb_vl_nao_retido_w	pls_util_cta_pck.t_number_table;
tb_vl_trib_adic_w	pls_util_cta_pck.t_number_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;

c01 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		nr_seq_prest_estor_pc	pls_pp_prestador.nr_sequencia%type) FOR
	SELECT	c.nr_sequencia nr_seq_item_lote_est,
		d.nr_sequencia nr_seq_base_atual_trib,
		d.cd_tributo,
		d.dt_comp_base_calc,
		d.ie_tipo_contratacao,
		d.nr_seq_evento,
		d.nr_seq_prestador,
		d.nr_seq_regra_trib,
		d.nr_seq_tipo_prestador,
		d.vl_base * -1,
		d.vl_base_adic * -1,
		d.vl_base_nao_retido * -1,
		d.vl_item * -1,
		d.vl_nao_retido * -1,
		d.vl_trib_adic * -1,
		d.vl_tributo * -1
	from	pls_pp_prest_event_prest a,
		pls_pp_it_prest_event_val b,
		pls_pp_item_lote c,
		pls_pp_base_atual_trib d
	where	a.nr_seq_pp_prest = nr_seq_prest_estor_pc
	and	b.nr_seq_prest_even_val = a.nr_seq_pp_prest_even_val
	and	c.nr_seq_lote = nr_seq_lote_pc
	and	c.nr_sequencia = b.nr_seq_item_lote
	and	d.nr_seq_lote = nr_seq_lote_pc
	and	d.nr_seq_item_lote = c.nr_seq_origem_estorno;


BEGIN
-- abre um cursor com todos os tributos do pagamento que esta sendo cancelado

open c01(nr_seq_lote_p, nr_seq_prest_estor_p);
loop
	fetch c01 bulk collect into	tb_nr_item_lote_est_w, tb_nr_base_atual_trib_w, tb_cd_tributo_w,
					tb_dt_comp_base_calc_w, tb_ie_tipo_contrat_w, tb_nr_seq_evento_w,
					tb_nr_seq_prest_w, tb_nr_seq_regra_trib_w, tb_nr_tipo_prest_w,
					tb_vl_base_w, tb_vl_base_adic_w, tb_vl_base_nao_ret_w,
					tb_vl_item_w, tb_vl_nao_retido_w, tb_vl_trib_adic_w,
					tb_vl_tributo_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_item_lote_est_w.count = 0;

	-- insere os registros de estorno da base de calculo dos tributos

	forall i in tb_nr_item_lote_est_w.first..tb_nr_item_lote_est_w.last
		insert into pls_pp_base_atual_trib(
			nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
			nm_usuario, nm_usuario_nrec, cd_tributo,
			dt_comp_base_calc, ie_cancelado, ie_tipo_contratacao,
			nr_seq_evento, nr_seq_item_lote, nr_seq_lote,
			nr_seq_origem_estorno, nr_seq_prestador, nr_seq_regra_trib,
			nr_seq_tipo_prestador, vl_base, vl_base_adic,
			vl_base_nao_retido, vl_item, vl_nao_retido,
			vl_trib_adic, vl_tributo
		) values (
			nextval('pls_pp_base_atual_trib_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, tb_cd_tributo_w(i),
			tb_dt_comp_base_calc_w(i), 'S', tb_ie_tipo_contrat_w(i),
			tb_nr_seq_evento_w(i), tb_nr_item_lote_est_w(i), nr_seq_lote_p,
			tb_nr_base_atual_trib_w(i), tb_nr_seq_prest_w(i), tb_nr_seq_regra_trib_w(i),
			tb_nr_tipo_prest_w(i), tb_vl_base_w(i), tb_vl_base_adic_w(i),
			tb_vl_base_nao_ret_w(i), tb_vl_item_w(i), tb_vl_nao_retido_w(i),
			tb_vl_trib_adic_w(i), tb_vl_tributo_w(i)
		);
	commit;
end loop;
close c01;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_canc_pgto_prest_pck.estornar_tributos_pgto_prest ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_prest_estor_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
