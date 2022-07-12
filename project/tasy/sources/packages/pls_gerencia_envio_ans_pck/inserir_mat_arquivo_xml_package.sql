-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Procedure responsvel por inserir os materiais nas tabelas utilizadas na gerao do XML



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.inserir_mat_arquivo_xml ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_mat_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_material_w		pls_util_cta_pck.t_number_table;
tb_cd_material_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_grupo_proc_w		pls_util_cta_pck.t_varchar2_table_5;
tb_qt_apresentado_w		pls_util_cta_pck.t_number_table;
tb_qt_pago_w			pls_util_cta_pck.t_number_table;
tb_vl_pago_w			pls_util_cta_pck.t_number_table;
tb_vl_apresentado_w		pls_util_cta_pck.t_number_table;
tb_cd_tabela_ref_w		pls_util_cta_pck.t_varchar2_table_2;
tb_ie_tipo_diaria_w		pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_despesa_w		pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_pacote_w		pls_util_cta_pck.t_number_table;
tb_seq_tiss_guia_w		pls_util_cta_pck.t_number_table;
tb_cd_cgc_fornecedor_w		pls_util_cta_pck.t_varchar2_table_20;
tb_vl_pago_fornecedor_w		pls_util_cta_pck.t_number_table;
tb_vl_coparticipacao_w		pls_util_cta_pck.t_number_table;
tb_cd_unidade_medida_w	pls_util_cta_pck.t_varchar2_table_5;

C01 CURSOR( 	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT 	a.nr_seq_conta,
		a.nr_seq_conta_mat,
		a.nr_seq_material,
		a.cd_material,
		-- Para o grupo proc 000 no envia no arquivo, apenas para saber que o item no tem grupo de procedimento

		CASE WHEN a.cd_grupo_proc='000' THEN  null  ELSE a.cd_grupo_proc END  cd_grupo_proc,
		a.qt_material qt_apresentado,
		a.qt_liberado qt_pago,
		a.vl_liberado vl_pago,
		a.vl_material vl_apresentado,
		CASE WHEN c.ie_tipo_registro='3' THEN  a.cd_tabela_ref  ELSE pls_gerencia_envio_ans_pck.obter_cod_tabela_envio_xml( c.nr_seq_lote_monitor, a.cd_tabela_ref, a.cd_grupo_proc, cd_versao_tiss_w, a.cd_material_tuss) END  cd_tabela_ref,
		a.ie_tipo_despesa,
		a.nr_seq_pacote,
		c.nr_sequencia,
		a.cd_cgc_fornecedor,
		a.vl_pago_fornecedor,
		a.vl_coparticipacao,
		a.cd_unidade_medida
	from	pls_monitor_tiss_guia c,
		pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_mat_val a
	where	c.nr_seq_lote_monitor = nr_seq_lote_pc
	--and	c.ie_tipo_registro in ('1', '2')

	and	b.nr_seq_lote_monitor = c.nr_seq_lote_monitor
	and	b.nr_seq_conta = c.nr_seq_conta
	and	a.nr_seq_cta_val = b.nr_sequencia;


BEGIN
open C01(nr_seq_lote_p);
loop
	tb_nr_seq_conta_w.delete;
	tb_nr_seq_conta_mat_w.delete;
	tb_nr_seq_material_w.delete;
	tb_cd_material_w.delete;
	tb_cd_grupo_proc_w.delete;
	tb_qt_apresentado_w.delete;
	tb_qt_pago_w.delete;
	tb_vl_pago_w.delete;
	tb_vl_apresentado_w.delete;
	tb_cd_tabela_ref_w.delete;
	tb_ie_tipo_diaria_w.delete;
	tb_ie_tipo_despesa_w.delete;
	tb_nr_seq_pacote_w.delete;
	tb_seq_tiss_guia_w.delete;
	tb_cd_cgc_fornecedor_w.delete;
	tb_vl_pago_fornecedor_w.delete;
	tb_vl_coparticipacao_w.delete;
	tb_cd_unidade_medida_w.delete;

	fetch C01 bulk collect into 	tb_nr_seq_conta_w, tb_nr_seq_conta_mat_w, tb_nr_seq_material_w,
					tb_cd_material_w, tb_cd_grupo_proc_w, tb_qt_apresentado_w,
					tb_qt_pago_w, tb_vl_pago_w, tb_vl_apresentado_w,
					tb_cd_tabela_ref_w,	tb_ie_tipo_despesa_w,
					tb_nr_seq_pacote_w, tb_seq_tiss_guia_w,
					tb_cd_cgc_fornecedor_w, tb_vl_pago_fornecedor_w,
					tb_vl_coparticipacao_w, tb_cd_unidade_medida_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_conta_w.count = 0;

	forall i in tb_nr_seq_conta_w.first .. tb_nr_seq_conta_w.last

		insert into pls_monitor_tiss_mat(
			nr_sequencia, nr_seq_guia_monitor, nr_seq_conta,
			nr_seq_conta_mat, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, cd_tabela_ref,
			vl_material, qt_material, qt_liberado,
			vl_liberado, cd_grupo_proc, cd_material,
			nr_seq_material, ie_tipo_despesa, nr_seq_pacote,
			vl_pago_fornecedor, cd_cgc_fornecedor, vl_coparticipacao,
			cd_unidade_medida
		) values (
			nextval('pls_monitor_tiss_mat_seq'), tb_seq_tiss_guia_w(i), tb_nr_seq_conta_w(i),
			tb_nr_seq_conta_mat_w(i), clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, tb_cd_tabela_ref_w(i),
			tb_vl_apresentado_w(i), tb_qt_apresentado_w(i), tb_qt_pago_w(i),
			tb_vl_pago_w(i), tb_cd_grupo_proc_w(i), tb_cd_material_w(i),
			tb_nr_seq_material_w(i), tb_ie_tipo_despesa_w(i), tb_nr_seq_pacote_w(i),
			tb_vl_pago_fornecedor_w(i), tb_cd_cgc_fornecedor_w(i), tb_vl_coparticipacao_w(i),
			tb_cd_unidade_medida_w(i));
		commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.inserir_mat_arquivo_xml ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;