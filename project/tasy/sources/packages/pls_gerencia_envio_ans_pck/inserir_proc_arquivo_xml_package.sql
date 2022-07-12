-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure responsvel por inserir as procedimentos nas tabelas utilizadas na gerao do XML



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.inserir_proc_arquivo_xml ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_proc_w		pls_util_cta_pck.t_number_table;
tb_cd_procedimento_w		pls_util_cta_pck.t_number_table;
tb_ie_origem_proced_w		pls_util_cta_pck.t_number_table;
tb_cd_grupo_proc_w		pls_util_cta_pck.t_varchar2_table_5;
tb_qt_apresentado_w		pls_util_cta_pck.t_number_table;
tb_qt_pago_w			pls_util_cta_pck.t_number_table;
tb_vl_pago_w			pls_util_cta_pck.t_number_table;
tb_vl_apresentado_w		pls_util_cta_pck.t_number_table;
tb_cd_tabela_ref_w		pls_util_cta_pck.t_varchar2_table_2;
tb_ie_tipo_diaria_w		pls_util_cta_pck.t_varchar2_table_5;
tb_cd_dente_w			pls_util_cta_pck.t_varchar2_table_20;
tb_cd_face_dente_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_regiao_boca_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_tipo_despesa_w		pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_pacote_w		pls_util_cta_pck.t_number_table;
tb_seq_tiss_guia_w		pls_util_cta_pck.t_number_table;
tb_vl_coparticipacao_w		pls_util_cta_pck.t_number_table;

C01 CURSOR( 	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT 	a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.cd_procedimento,
		a.ie_origem_proced,
		-- para o grupo proc 000 no envia no arquivo, apenas para saber que o item no tem grupo de procedimento

		CASE WHEN a.cd_grupo_proc='000' THEN  null  ELSE a.cd_grupo_proc END   cd_grupo_proc,
		a.qt_procedimento qt_apresentado,
		a.qt_liberado qt_pago,
		a.vl_liberado vl_pago,
		a.vl_procedimento vl_apresentado,
		CASE WHEN c.ie_tipo_registro='3' THEN  a.cd_tabela_ref  ELSE pls_gerencia_envio_ans_pck.obter_cod_tabela_envio_xml( c.nr_seq_lote_monitor, a.cd_tabela_ref, a.cd_grupo_proc, cd_versao_tiss_w, null) END  cd_tabela_ref,
		a.ie_tipo_diaria,
		a.cd_dente,
		a.cd_face_dente,
		a.cd_regiao_boca,
		a.ie_tipo_despesa,
		a.nr_seq_pacote,
		c.nr_sequencia,
		a.vl_coparticipacao
	from	pls_monitor_tiss_guia c,
		pls_monitor_tiss_cta_val b,
		pls_monitor_tiss_proc_val a
	where	c.nr_seq_lote_monitor = nr_seq_lote_pc
	--and	c.ie_tipo_registro in ('1', '2')

	and	b.nr_seq_lote_monitor = c.nr_seq_lote_monitor
	and	b.nr_seq_conta = c.nr_seq_conta
	and	a.nr_seq_cta_val = b.nr_sequencia;


BEGIN

open C01(nr_seq_lote_p);
loop
	tb_nr_seq_conta_w.delete;
	tb_nr_seq_proc_w.delete;
	tb_cd_procedimento_w.delete;
	tb_ie_origem_proced_w.delete;
	tb_cd_grupo_proc_w.delete;
	tb_qt_apresentado_w.delete;
	tb_qt_pago_w.delete;
	tb_vl_pago_w.delete;
	tb_vl_apresentado_w.delete;
	tb_cd_tabela_ref_w.delete;
	tb_ie_tipo_diaria_w.delete;
	tb_cd_dente_w.delete;
	tb_cd_face_dente_w.delete;
	tb_cd_regiao_boca_w.delete;
	tb_ie_tipo_despesa_w.delete;
	tb_nr_seq_pacote_w.delete;
	tb_seq_tiss_guia_w.delete;
	tb_vl_coparticipacao_w.delete;

	fetch C01 bulk collect into 	tb_nr_seq_conta_w, tb_nr_seq_proc_w, tb_cd_procedimento_w,
					tb_ie_origem_proced_w, tb_cd_grupo_proc_w, tb_qt_apresentado_w,
					tb_qt_pago_w, tb_vl_pago_w, tb_vl_apresentado_w,
					tb_cd_tabela_ref_w, tb_ie_tipo_diaria_w, tb_cd_dente_w,
					tb_cd_face_dente_w, tb_cd_regiao_boca_w, tb_ie_tipo_despesa_w,
					tb_nr_seq_pacote_w, tb_seq_tiss_guia_w, tb_vl_coparticipacao_w
	limit current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer;

	exit when tb_nr_seq_conta_w.count = 0;

	forall i in tb_nr_seq_conta_w.first .. tb_nr_seq_conta_w.last

		insert into pls_monitor_tiss_proc(
			nr_sequencia, cd_grupo_proc, cd_procedimento,
			cd_tabela_ref, dt_atualizacao, dt_atualizacao_nrec,
			ie_origem_proced, nm_usuario, nm_usuario_nrec,
			nr_seq_conta, nr_seq_conta_proc, nr_seq_guia_monitor,
			qt_procedimento, vl_procedimento, qt_liberado,
			vl_liberado, ie_tipo_diaria, cd_dente,
			cd_regiao_boca, cd_face_dente, ie_tipo_despesa,
			nr_seq_pacote, vl_coparticipacao
		) values (
			nextval('pls_monitor_tiss_proc_seq'), tb_cd_grupo_proc_w(i), tb_cd_procedimento_w(i),
			tb_cd_tabela_ref_w(i), clock_timestamp(), clock_timestamp(),
			tb_ie_origem_proced_w(i), nm_usuario_p, nm_usuario_p,
			tb_nr_seq_conta_w(i), tb_nr_seq_proc_w(i), tb_seq_tiss_guia_w(i),
			tb_qt_apresentado_w(i), tb_vl_apresentado_w(i), tb_qt_pago_w(i),
			tb_vl_pago_w(i), tb_ie_tipo_diaria_w(i), tb_cd_dente_w(i),
			tb_cd_regiao_boca_w(i), tb_cd_face_dente_w(i), tb_ie_tipo_despesa_w(i),
			tb_nr_seq_pacote_w(i), tb_vl_coparticipacao_w(i));
		commit;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.inserir_proc_arquivo_xml ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
