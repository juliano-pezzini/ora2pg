-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_int_nv_conta_mat ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_conta_mat_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_imp_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_item_conta_w		pls_util_cta_pck.t_number_table;
tb_qt_executado_w		pls_util_cta_pck.t_number_table;
tb_dt_inicio_w			pls_util_cta_pck.t_date_table;
tb_dt_fim_w			pls_util_cta_pck.t_date_table;
tb_tx_reducao_acrescimo_w	pls_util_cta_pck.t_number_table;
tb_vl_unitario_w		pls_util_cta_pck.t_number_table;
tb_vl_total_w			pls_util_cta_pck.t_number_table;
tb_cd_unidade_medida_w		pls_util_cta_pck.t_varchar2_table_5;
tb_nr_registro_anvisa_w		pls_util_cta_pck.t_varchar2_table_15;
tb_cd_ref_fabricante_w		pls_util_cta_pck.t_varchar2_table_200;
tb_nr_aut_funcionamento_w	pls_util_cta_pck.t_varchar2_table_50;
tb_nr_seq_material_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_tipo_tabela_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_tipo_despesa_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_dt_execucao_conv_w		pls_util_cta_pck.t_date_table;
tb_nr_seq_fornec_mat_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_setor_atend_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_seq_prestador_conv_w	pls_util_cta_pck.t_varchar2_table_50;
tb_cd_procedimento_w		pls_util_cta_pck.t_varchar2_table_10;
tb_cd_tipo_tabela_w		pls_util_cta_pck.t_varchar2_table_2;
tb_ds_procedimento_w		pls_util_cta_pck.t_varchar2_table_200;
tb_ie_tipo_despesa_w		pls_util_cta_pck.t_varchar2_table_2;
tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_tiss_tabela_conv_w	pls_util_cta_pck.t_number_table;
tb_cd_material_conv_w		pls_util_cta_pck.t_number_table;
tb_seq_cobertura_w		pls_util_cta_pck.t_number_table;
tb_tipo_cobertura_w		pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_item_tiss_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_item_tiss_vinculo_w	pls_util_cta_pck.t_number_table;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;


C01 CURSOR(nr_seq_lote_protocolo_pc	pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta_mat,
		a.nr_seq_conta nr_seq_conta_imp,
		a.nr_seq_item_conta,
		a.qt_executado,
		a.dt_inicio,
		a.dt_fim,
		a.tx_reducao_acrescimo,
		a.vl_unitario,
		a.vl_total,
		a.cd_unidade_medida,
		a.nr_registro_anvisa,
		a.cd_ref_fabricante,
		a.nr_aut_funcionamento,
		a.nr_seq_material_conv,
		a.cd_tipo_tabela_conv,
		a.ie_tipo_despesa_conv,
		a.dt_execucao_conv,
		a.nr_seq_fornec_mat_conv,
		a.nr_seq_setor_atend_conv,
		a.cd_seq_prestador_conv,
		b.cd_procedimento,
		b.cd_tipo_tabela,
		b.ds_procedimento,
		b.ie_tipo_despesa,
		(SELECT	max(x.nr_sequencia)
		from	pls_conta x
		where	x.nr_seq_imp	= c.nr_sequencia) nr_seq_conta,
		b.nr_seq_tiss_tabela_conv,
		a.cd_material_conv,
		a.nr_seq_cobertura,
		a.ie_tipo_cobertura,
		b.nr_seq_item_tiss,
		b.nr_seq_item_tiss_vinculo
	from	pls_protocolo_conta_imp d,
		pls_conta_imp c,
		pls_conta_item_imp b,
		pls_conta_mat_imp a
	where	d.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_pc
	and	c.nr_seq_protocolo	= d.nr_sequencia
	and	b.nr_seq_conta		= c.nr_sequencia
	and	a.nr_seq_conta		= b.nr_seq_conta
	and	a.nr_seq_item_conta	= b.nr_sequencia;

BEGIN

open C01(nr_seq_lote_protocolo_p);
loop
	--Carregar as vari_veis conforme informa__es obtidas atrav_s do Cursor

	fetch C01 bulk collect into	tb_nr_seq_conta_mat_w, tb_nr_seq_conta_imp_w,
					tb_nr_seq_item_conta_w, tb_qt_executado_w,
					tb_dt_inicio_w, tb_dt_fim_w,
					tb_tx_reducao_acrescimo_w, tb_vl_unitario_w,
					tb_vl_total_w, tb_cd_unidade_medida_w,
					tb_nr_registro_anvisa_w, tb_cd_ref_fabricante_w,
					tb_nr_aut_funcionamento_w, tb_nr_seq_material_conv_w,
					tb_cd_tipo_tabela_conv_w, tb_ie_tipo_despesa_conv_w,
					tb_dt_execucao_conv_w, tb_nr_seq_fornec_mat_conv_w,
					tb_nr_seq_setor_atend_conv_w, tb_cd_seq_prestador_conv_w,
					tb_cd_procedimento_w, tb_cd_tipo_tabela_w,
					tb_ds_procedimento_w, tb_ie_tipo_despesa_w,
					tb_nr_seq_conta_w, tb_nr_seq_tiss_tabela_conv_w,
					tb_cd_material_conv_w, tb_seq_cobertura_w,
					tb_tipo_cobertura_w, tb_nr_seq_item_tiss_w,
					tb_nr_seq_item_tiss_vinculo_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_conta_mat_w.count = 0;

	--Integrar as informa__es  da tabela  PLS_CONTA_MAT_IMP para a PLS_CONTA_MAT

	--Inseridas as informa__es correspondentes na tabela.

	--Os campos _IMP da PLS_CONTA_MAT tamb_m devem ser populados para consultas posteriores

	forall i in tb_nr_seq_conta_mat_w.first..tb_nr_seq_conta_mat_w.last
		insert	into pls_conta_mat(cd_material, cd_material_imp,
			cd_ref_fabricante, cd_ref_fabricante_imp,
			cd_sequencial_prestador, cd_tipo_tabela_imp,
			cd_unidade_medida, cd_unidade_medida_imp,
			ds_aut_funcionamento, ds_aut_funcionamento_imp,
			ds_log, ds_material_imp,
			dt_atendimento, dt_atendimento_imp, 
			dt_atendimento_imp_referencia, dt_atendimento_imp_trunc, 
			dt_atendimento_referencia, dt_atendimento_trunc, 
			dt_atualizacao, dt_atualizacao_nrec, 
			dt_fim_atend, dt_fim_atend_imp,
			dt_inicio_atend, dt_inicio_atend_imp,
			ie_origem_preco, ie_origem_preco_imp, 
			ie_situacao, ie_status,
			ie_tipo_despesa, ie_tipo_despesa_imp, 
			nm_usuario, nm_usuario_nrec, 
			nr_registro_anvisa, nr_registro_anvisa_imp, 
			nr_seq_conta, nr_seq_imp, 
			nr_seq_material, nr_sequencia, 
			qt_material, qt_material_imp,
			tx_reducao_acrescimo, tx_reducao_acrescimo_imp, 
			vl_liberado, vl_material,
			vl_material_imp, vl_material_imp_xml,
			vl_unitario, vl_unitario_imp,
			nr_seq_setor_atend, nr_seq_tiss_tabela,
			nr_seq_cobertura, ie_tipo_cobertura
		) values (tb_cd_material_conv_w(i), tb_cd_material_conv_w(i),
			tb_cd_ref_fabricante_w(i), tb_cd_ref_fabricante_w(i),
			tb_cd_seq_prestador_conv_w(i), tb_cd_tipo_tabela_w(i),
			tb_cd_unidade_medida_w(i), tb_cd_unidade_medida_w(i),
			tb_nr_aut_funcionamento_w(i), tb_nr_aut_funcionamento_w(i),
			'pls_int_xml_cta_pck.pls_int_nv_conta_mat()', tb_ds_procedimento_w(i),
			tb_dt_execucao_conv_w(i), tb_dt_execucao_conv_w(i),
			tb_dt_execucao_conv_w(i), trunc(tb_dt_execucao_conv_w(i)),
			tb_dt_execucao_conv_w(i), trunc(tb_dt_execucao_conv_w(i)),
			clock_timestamp(), clock_timestamp(),
			tb_dt_fim_w(i), tb_dt_fim_w(i),
			tb_dt_inicio_w(i), tb_dt_inicio_w(i),
			tb_cd_tipo_tabela_conv_w(i), tb_cd_tipo_tabela_w(i),
			'I', 'U',
			tb_ie_tipo_despesa_conv_w(i), pls_util_pck.elimina_zero_esquerda_char(tb_ie_tipo_despesa_w(i)),
			nm_usuario_p, nm_usuario_p,
			tb_nr_registro_anvisa_w(i), tb_nr_registro_anvisa_w(i),
			tb_nr_seq_conta_w(i), tb_nr_seq_conta_mat_w(i),
			tb_nr_seq_material_conv_w(i), nextval('pls_conta_mat_seq'),
			0, tb_qt_executado_w(i),
			tb_tx_reducao_acrescimo_w(i), tb_tx_reducao_acrescimo_w(i),
			0, 0,
			tb_vl_total_w(i), tb_vl_total_w(i),
			tb_vl_unitario_w(i), tb_vl_unitario_w(i),
			tb_nr_seq_setor_atend_conv_w(i), tb_nr_seq_tiss_tabela_conv_w(i),
			tb_seq_cobertura_w(i), tb_tipo_cobertura_w(i)
			);
	commit;
	
	--Devido a necessidade de criar registro de regra para cada procedimento integrado(campos com seq_item_tiss), n_o se faz poss_vel utiliza__o de forall aqui. Caso algum dia detecte-se alguma necessidade 

	--de melhorar performance neses ponto, ser_ necess_rio pensar em estrat_gia diferente.

	for i in tb_nr_seq_conta_mat_w.first..tb_nr_seq_conta_mat_w.last loop
			
		select 	max(nr_sequencia) 
		into STRICT	nr_seq_conta_mat_w
		from 	pls_conta_mat
		where 	nr_seq_conta = tb_nr_seq_conta_w(i)
		and 	nr_seq_imp = tb_nr_seq_conta_mat_w(i);
			
		if (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then
			-- Se existe a regra, so atualiza, sen_o gera novamente

			CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_conta_mat_w, nm_usuario_p);
			
			CALL pls_cta_proc_mat_regra_pck.atualiza_seq_tiss_mat(nr_seq_conta_mat_w, tb_nr_seq_item_tiss_w(i), tb_nr_seq_item_tiss_vinculo_w(i), nm_usuario_p);
		end if;
			
	end loop;
	
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_int_nv_conta_mat ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;