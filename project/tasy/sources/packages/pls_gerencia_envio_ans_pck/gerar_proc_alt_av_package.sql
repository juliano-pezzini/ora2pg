-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.gerar_proc_alt_av ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


_ora2pg_r RECORD;
qt_registro_w			integer;
tb_seq_cta_val_w		pls_util_cta_pck.t_number_table;
tb_total_apresentado_w		pls_util_cta_pck.t_number_table;
tb_total_tab_propria_w		pls_util_cta_pck.t_number_table;
tb_total_pago_w			pls_util_cta_pck.t_number_table;
tb_total_glosa_w		pls_util_cta_pck.t_number_table;
tb_seq_proc_w			pls_util_cta_pck.t_number_table;
tb_seq_mat_w			pls_util_cta_pck.t_number_table;
tb_seq_prest_fornec_w		pls_util_cta_pck.t_number_table;
vl_glosa_w			pls_moni_tiss_cta_val_av.vl_total_glosa%type;
vl_liberado_w			pls_moni_tiss_cta_val_av.vl_total_glosa%type;
ie_gera_vl_pgto_w		varchar(1) := 'S';
cd_tabela_ref_w			pls_monitor_tiss_proc_val.cd_tabela_ref%type;
nr_seq_regra_tab_w		pls_regra_tabela_tiss.nr_sequencia%type;
ie_origem_tab_ref_w		pls_monitor_tiss_proc_val.ie_origem_tab_ref%type;

-- busca todos os procedimentos de contas que tiveram ao de alterar o valor e foram atualizadas

c01 CURSOR(	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	e.nr_sequencia nr_seq_cta_val,
		a.nr_sequencia nr_seq_conta_proc,
		CASE WHEN coalesce(a.vl_provisao,0)=0 THEN  CASE WHEN coalesce(a.vl_procedimento_imp,0)=0 THEN a.vl_procedimento  ELSE a.vl_procedimento_imp END   ELSE a.vl_provisao END  vl_provisao,
		a.vl_liberado,
		a.vl_glosa,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_seq_pacote,
		a.ie_tipo_despesa,
		a.nr_seq_conta
	from	pls_monitor_tiss_cta_val e,
		pls_conta_proc	a
	where	e.nr_seq_lote_monitor = nr_seq_lote_pc
	and	e.ie_tipo_evento = 'AV'
	and	e.ie_conta_atualizada = 'S'
	and	a.nr_seq_conta = e.nr_seq_conta
	and 	a.ie_status != 'D';

BEGIN

qt_registro_w := 0;
for r_c01_w in c01(nr_seq_lote_p, cd_estabelecimento_p) loop

	ie_gera_vl_pgto_w	:= 'S';
	vl_glosa_w		:= r_c01_w.vl_glosa;
	vl_liberado_w		:= r_c01_w.vl_liberado;

	-- O ie_tipo_envio recebe sempre 'PC', pois se o CNPJ for igual j ir retornar 'N'

	ie_gera_vl_pgto_w := pls_gerencia_envio_ans_pck.obter_se_envia_pagamento('PC', r_c01_w.nr_seq_conta, cd_estabelecimento_p);

	if (ie_gera_vl_pgto_w = 'N') then
		vl_liberado_w := 0;
	end if;

	if (coalesce(vl_glosa_w,0) > coalesce(r_C01_w.vl_provisao, 0)) then
		vl_glosa_w	:= r_C01_w.vl_provisao;
	end if;

	SELECT * FROM pls_gerencia_envio_ans_pck.obter_tipo_tabela_tiss(	r_c01_w.cd_procedimento, r_c01_w.ie_origem_proced, r_c01_w.nr_seq_pacote, r_c01_w.ie_tipo_despesa, null, cd_estabelecimento_p, cd_tabela_ref_w, nr_seq_regra_tab_w, ie_origem_tab_ref_w) INTO STRICT cd_tabela_ref_w, nr_seq_regra_tab_w, ie_origem_tab_ref_w;

	tb_seq_cta_val_w(qt_registro_w) := r_c01_w.nr_seq_cta_val;
	tb_total_apresentado_w(qt_registro_w) := r_c01_w.vl_provisao;
	tb_total_pago_w(qt_registro_w) := vl_liberado_w;
	tb_total_glosa_w(qt_registro_w) := vl_glosa_w;
	tb_seq_proc_w(qt_registro_w) := r_c01_w.nr_seq_conta_proc;
	tb_seq_mat_w(qt_registro_w) := null;
	tb_seq_prest_fornec_w(qt_registro_w) := null;

	-- se for tabela prpria

	if (cd_tabela_ref_w = '00') then
		tb_total_tab_propria_w(qt_registro_w) := r_c01_w.vl_provisao;
	else
		tb_total_tab_propria_w(qt_registro_w) := 0;
	end if;

	-- se j atingiu a quantidade de registros manda para o banco de dados

	if ( qt_registro_w >= current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer ) then
		-- inserir procedimento

		CALL pls_gerencia_envio_ans_pck.inserir_proc_mat_alt_av(	tb_seq_cta_val_w, tb_total_apresentado_w,
						tb_total_tab_propria_w, tb_total_pago_w,
						tb_total_glosa_w, tb_seq_proc_w,
						tb_seq_mat_w, tb_seq_prest_fornec_w,
						nm_usuario_p);
		-- limpa as variveis

		SELECT * FROM pls_gerencia_envio_ans_pck.limpar_type_proc_mat_alt_av(	tb_seq_cta_val_w, tb_total_apresentado_w, tb_total_tab_propria_w, tb_total_pago_w, tb_total_glosa_w, tb_seq_proc_w, tb_seq_mat_w, tb_seq_prest_fornec_w) INTO STRICT _ora2pg_r;
 	tb_seq_cta_val_w := _ora2pg_r.tb_seq_cta_val_p; tb_total_apresentado_w := _ora2pg_r.tb_total_apresentado_p; tb_total_tab_propria_w := _ora2pg_r.tb_total_tab_propria_p; tb_total_pago_w := _ora2pg_r.tb_total_pago_p; tb_total_glosa_w := _ora2pg_r.tb_total_glosa_p; tb_seq_proc_w := _ora2pg_r.tb_seq_proc_p; tb_seq_mat_w := _ora2pg_r.tb_seq_mat_p; tb_seq_prest_fornec_w := _ora2pg_r.tb_seq_prest_fornec_p;
		qt_registro_w := 0;
	else
		qt_registro_w := qt_registro_w + 1;
	end if;
end loop;

-- se faltou inserir algum manda para o banco

CALL pls_gerencia_envio_ans_pck.inserir_proc_mat_alt_av(	tb_seq_cta_val_w, tb_total_apresentado_w,
				tb_total_tab_propria_w, tb_total_pago_w,
				tb_total_glosa_w, tb_seq_proc_w,
				tb_seq_mat_w, tb_seq_prest_fornec_w, nm_usuario_p);
-- limpa as variveis

SELECT * FROM pls_gerencia_envio_ans_pck.limpar_type_proc_mat_alt_av(	tb_seq_cta_val_w, tb_total_apresentado_w, tb_total_tab_propria_w, tb_total_pago_w, tb_total_glosa_w, tb_seq_proc_w, tb_seq_mat_w, tb_seq_prest_fornec_w) INTO STRICT _ora2pg_r;
 	tb_seq_cta_val_w := _ora2pg_r.tb_seq_cta_val_p; tb_total_apresentado_w := _ora2pg_r.tb_total_apresentado_p; tb_total_tab_propria_w := _ora2pg_r.tb_total_tab_propria_p; tb_total_pago_w := _ora2pg_r.tb_total_pago_p; tb_total_glosa_w := _ora2pg_r.tb_total_glosa_p; tb_seq_proc_w := _ora2pg_r.tb_seq_proc_p; tb_seq_mat_w := _ora2pg_r.tb_seq_mat_p; tb_seq_prest_fornec_w := _ora2pg_r.tb_seq_prest_fornec_p;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.gerar_proc_alt_av ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
