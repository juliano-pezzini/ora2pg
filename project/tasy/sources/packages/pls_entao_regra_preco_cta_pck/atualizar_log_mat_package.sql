-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_entao_regra_preco_cta_pck.atualizar_log_mat ( nm_usuario_p usuario.nm_usuario%type, ie_destino_regra_p pls_cp_cta_log_mat.ie_destino_regra%type) AS $body$
BEGIN

if (current_setting('pls_entao_regra_preco_cta_pck.tb_nr_seq_conta_mat_log_w')::pls_util_cta_pck.t_number_table.count > 0) then

	forall i in current_setting('pls_entao_regra_preco_cta_pck.tb_nr_seq_conta_mat_log_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_conta_mat_log_w.last
		insert into pls_cp_cta_log_mat(
			nr_sequencia, nr_seq_conta_mat, dt_atualizacao,
			nm_usuario, ds_log, vl_material,
			ie_destino_regra
		) values (
			nextval('pls_cp_cta_log_mat_seq'), current_setting('pls_entao_regra_preco_cta_pck.tb_nr_seq_conta_mat_log_w')::pls_util_cta_pck.t_number_table(i), current_setting('pls_entao_regra_preco_cta_pck.tb_dt_atualizacao_log_w')::pls_util_cta_pck.t_date_table(i),
			nm_usuario_p, current_setting('pls_entao_regra_preco_cta_pck.tb_ds_log_w')::pls_util_cta_pck.t_varchar2_table_4000(i), current_setting('pls_entao_regra_preco_cta_pck.tb_vl_material_log_w')::pls_util_cta_pck.t_number_table(i),
			ie_destino_regra_p
		);
	commit;
end if;

current_setting('pls_entao_regra_preco_cta_pck.tb_nr_seq_conta_mat_log_w')::pls_util_cta_pck.t_number_table.delete;
current_setting('pls_entao_regra_preco_cta_pck.tb_dt_atualizacao_log_w')::pls_util_cta_pck.t_date_table.delete;
current_setting('pls_entao_regra_preco_cta_pck.tb_ds_log_w')::pls_util_cta_pck.t_varchar2_table_4000.delete;
current_setting('pls_entao_regra_preco_cta_pck.tb_vl_material_log_w')::pls_util_cta_pck.t_number_table.delete;

PERFORM set_config('pls_entao_regra_preco_cta_pck.nr_cont_log_w', 0, false);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_entao_regra_preco_cta_pck.atualizar_log_mat ( nm_usuario_p usuario.nm_usuario%type, ie_destino_regra_p pls_cp_cta_log_mat.ie_destino_regra%type) FROM PUBLIC;