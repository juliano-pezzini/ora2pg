-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.gerencia_id_final_item ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, cd_versao_tiss_conv_p pls_protocolo_conta_imp.cd_versao_tiss_conv%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


-- vari_veis para alimentar a tabela tempor_ria

tb_nr_seq_conta_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_item_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_desp_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_cd_tipo_tab_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_tipo_item_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_cd_procedimento_w	pls_util_cta_pck.t_varchar2_table_10;
tb_cd_proced_number_w	pls_util_cta_pck.t_number_table;
tb_cd_proced_conv_w	pls_util_cta_pck.t_number_table;
tb_dt_execucao_w	pls_util_cta_pck.t_date_table;
tb_ie_tipo_rel_prest_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_mat_conv_w	pls_util_cta_pck.t_number_table;
tb_ie_orig_proc_conv_w	pls_util_cta_pck.t_number_table;

tb_cd_proced_conv_fim_w		pls_util_cta_pck.t_number_table;
tb_ie_orig_proc_conv_fim_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_desp_conv_fim_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_pacote_conv_fim_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_mat_conv_fim_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_tiss_tabela_conv_w	pls_util_cta_pck.t_number_table;

C01 CURSOR(	nr_seq_protocolo_pc	pls_protocolo_conta_imp.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia nr_seq_conta,
		c.nr_sequencia nr_seq_item,
		c.ie_tipo_despesa_conv,
		c.cd_tipo_tabela_conv,
		c.ie_tipo_item_conv,
		c.cd_procedimento,
		pls_util_pck.obter_somente_numero(c.cd_procedimento) cd_proced_number_conv,
		c.dt_execucao,
		(SELECT max(ie_tipo_relacao)
		from  pls_prestador
		where  nr_sequencia = coalesce(b.nr_seq_prest_exec_conv, a.nr_seq_prestador_conv)) ie_tipo_relacao_prest,
		c.nr_seq_material_ini_conv,
		c.cd_procedimento_conv,
		c.ie_origem_proced_conv
	from	pls_protocolo_conta_imp a,
		pls_conta_imp b,
		pls_conta_item_imp c
	where 	a.nr_sequencia = nr_seq_protocolo_pc
	and	b.nr_seq_protocolo = a.nr_sequencia
	and	c.nr_seq_conta = b.nr_sequencia;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_procedimento_conv,
		a.ie_origem_proced_conv,
		a.ie_tipo_despesa_conv,
		a.nr_seq_pacote_conv,
		a.nr_seq_material_conv,
		a.nr_seq_tiss_tabela_conv
	from	pls_conta_item_imp_tmp a;


BEGIN
-- carrega os par_metros para vari_veis globais da package

CALL CALL CALL CALL CALL CALL pls_conv_xml_cta_pck.carrega_parametros(cd_estabelecimento_p, 'C');

-- copia os dados que ser_o utilizados para realizar a identificacao dos procedimentos e materiais para a 

-- tabela pls_conta_item_imp_tmp. Feito isso por quest_es de performance, visto que n_o _ saud_vel ficar

-- atualizando dados em massa de uma tabela que est_ sendo utilizada no cursor durante toda a execucao

EXECUTE 'truncate table pls_conta_item_imp_tmp';

tb_nr_seq_conta_w.delete;
tb_nr_seq_item_w.delete;
tb_ie_tipo_desp_conv_w.delete;
tb_cd_tipo_tab_conv_w.delete;
tb_ie_tipo_item_conv_w.delete;
tb_cd_procedimento_w.delete;
tb_cd_proced_conv_w.delete;
tb_dt_execucao_w.delete;
tb_ie_tipo_rel_prest_w.delete;
tb_nr_seq_mat_conv_w.delete;
tb_cd_proced_number_w.delete;
tb_nr_seq_tiss_tabela_conv_w.delete;


open C01(nr_seq_protocolo_p);
loop
	fetch C01 bulk collect into 	tb_nr_seq_conta_w, tb_nr_seq_item_w, tb_ie_tipo_desp_conv_w,
					tb_cd_tipo_tab_conv_w, tb_ie_tipo_item_conv_w, tb_cd_procedimento_w,
					tb_cd_proced_number_w, tb_dt_execucao_w, tb_ie_tipo_rel_prest_w,
					tb_nr_seq_mat_conv_w, tb_cd_proced_conv_w, tb_ie_orig_proc_conv_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_item_w.count = 0;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		
		insert 	into pls_conta_item_imp_tmp(
			nr_seq_protocolo, nr_seq_conta, nr_sequencia,
			ie_tipo_despesa_conv, cd_tipo_tabela_conv, ie_tipo_item_conv,
			cd_procedimento, cd_proced_number_conv, dt_execucao, 
			ie_tipo_rel_prest_conv, nr_seq_material_conv, cd_procedimento_conv, 
			ie_origem_proced_conv
		) values (
			nr_seq_protocolo_p, tb_nr_seq_conta_w(i), tb_nr_seq_item_w(i), 
			tb_ie_tipo_desp_conv_w(i), tb_cd_tipo_tab_conv_w(i), tb_ie_tipo_item_conv_w(i), 
			tb_cd_procedimento_w(i), tb_cd_proced_number_w(i), tb_dt_execucao_w(i), 
			tb_ie_tipo_rel_prest_w(i), tb_nr_seq_mat_conv_w(i), tb_cd_proced_conv_w(i), 
			tb_ie_orig_proc_conv_w(i)
		);
	commit;
end loop;
close C01;

CALL pls_conv_xml_cta_pck.identificacao_final_proc(cd_versao_tiss_conv_p, nm_usuario_p);

CALL pls_conv_xml_cta_pck.identificacao_final_mat(cd_versao_tiss_conv_p);

tb_nr_seq_item_w.delete;

open C02;
loop
	fetch C02 bulk collect into     tb_nr_seq_item_w, tb_cd_proced_conv_fim_w, tb_ie_orig_proc_conv_fim_w,
					tb_ie_tipo_desp_conv_fim_w, tb_nr_seq_pacote_conv_fim_w, tb_nr_seq_mat_conv_fim_w,
					tb_nr_seq_tiss_tabela_conv_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_item_w.count = 0;
	
	forall	i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		update	pls_conta_item_imp
		set	cd_procedimento_conv = tb_cd_proced_conv_fim_w(i),
			ie_origem_proced_conv = tb_ie_orig_proc_conv_fim_w(i),
			ie_tipo_despesa_conv = pls_util_pck.elimina_zero_esquerda_char(tb_ie_tipo_desp_conv_fim_w(i)),
			nr_seq_pacote_conv = tb_nr_seq_pacote_conv_fim_w(i),
			nr_seq_material_conv = tb_nr_seq_mat_conv_fim_w(i),
			nr_seq_tiss_tabela_conv = tb_nr_seq_tiss_tabela_conv_w(i)
		where	nr_sequencia = tb_nr_seq_item_w(i);
	commit;
end loop;
close C02;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.gerencia_id_final_item ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, cd_versao_tiss_conv_p pls_protocolo_conta_imp.cd_versao_tiss_conv%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
