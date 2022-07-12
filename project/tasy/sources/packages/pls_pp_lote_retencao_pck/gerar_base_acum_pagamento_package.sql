-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_retencao_pck.gerar_base_acum_pagamento ( nr_seq_lote_ret_p pls_pp_lr_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_vl_item_w		pls_util_cta_pck.t_number_table;
tb_vl_base_calc_w	pls_util_cta_pck.t_number_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_ie_tipo_contrat_w	pls_util_cta_pck.t_varchar2_table_5;
tb_cd_pessoa_fisica_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_tipo_prest_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_lote_pgto_w	pls_util_cta_pck.t_number_table;

c01 CURSOR(	cd_tributo_pc		tributo.cd_tributo%type,
		dt_competencia_pc	pls_pp_lr_lote.dt_mes_competencia%type) FOR
	SELECT	b.nr_sequencia nr_seq_base_acum,
		b.cd_pessoa_fisica,
		b.nr_seq_prestador,
		b.nr_seq_tipo_prestador,
		b.ie_tipo_contratacao,
		b.vl_item,
		b.vl_base,
		b.vl_tributo,
		b.nr_seq_lote_pgto_orig
	from	pls_pp_base_acum_trib b,
		pls_pp_prestador_tmp a
	where	b.dt_competencia = dt_competencia_pc
	and	b.ie_origem = 'NP'
	and	b.cd_tributo = cd_tributo_pc
	and	a.nr_seq_prestador = b.nr_seq_prestador
	and	a.ie_tipo_prestador = 'PF';

BEGIN
-- abre um cursor com todos os tributos de INSS e IR
for r_c_trib_w in current_setting('pls_pp_lote_retencao_pck.c_tributo')::loop CURSOR

	-- para cada um dos tributos vai atrás dos valores de base de cálculo utilizadas no pagamento
	open c01(	r_c_trib_w.cd_tributo, current_setting('pls_pp_lote_retencao_pck.dt_mes_competencia_lote_w')::pls_pp_lr_lote.dt_mes_competencia%type);
	loop
		fetch c01 bulk collect into	tb_nr_sequencia_w, tb_cd_pessoa_fisica_w, tb_nr_seq_prest_w,
						tb_nr_seq_tipo_prest_w, tb_ie_tipo_contrat_w, tb_vl_item_w,
						tb_vl_base_calc_w, tb_vl_tributo_w, tb_nr_seq_lote_pgto_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_nr_sequencia_w.count = 0;

		forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
			insert into pls_pp_lr_base_trib(
				nr_sequencia, dt_atualizacao_nrec, dt_atualizacao,
				nm_usuario_nrec, nm_usuario, cd_tributo,
				ie_tipo_contratacao, nr_seq_prestador, vl_base,
				vl_tributo, vl_item, cd_pessoa_fisica, 
				nr_seq_tipo_prestador, ie_origem, nr_seq_lote_ret,
				nr_seq_lote_pgto, vl_base_adic, vl_trib_adic,
				vl_base_nao_retido, vl_nao_retido
			) values (
				nextval('pls_pp_lr_base_trib_seq'), clock_timestamp(), clock_timestamp(),
				nm_usuario_p, nm_usuario_p, r_c_trib_w.cd_tributo,
				tb_ie_tipo_contrat_w(i), tb_nr_seq_prest_w(i), tb_vl_base_calc_w(i), 
				tb_vl_tributo_w(i), tb_vl_item_w(i), tb_cd_pessoa_fisica_w(i), 
				tb_nr_seq_tipo_prest_w(i), 'NP', nr_seq_lote_ret_p,
				tb_nr_seq_lote_pgto_w(i), 0, 0,
				0, 0
			);
		commit;
	end loop;
	close c01;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_retencao_pck.gerar_base_acum_pagamento ( nr_seq_lote_ret_p pls_pp_lr_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
