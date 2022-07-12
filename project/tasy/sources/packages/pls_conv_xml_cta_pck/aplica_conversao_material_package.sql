-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.aplica_conversao_material ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type) AS $body$
DECLARE


tb_nr_seq_item_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_w	pls_util_cta_pck.t_number_table;
tb_dt_execucao_w	pls_util_cta_pck.t_date_table;
tb_cd_procedimento_w	pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_mat_conv_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_conv_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_desp_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_cd_tipo_tab_conv_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_tipo_item_conv_w	pls_util_cta_pck.t_varchar2_table_10;

-- utilizado o pls_util_pck.obter_somente_numero para armazenar o c_digo que ser_ utilizado em comparacoes que envolvem um

-- intervalo de c_digos de material

C01 CURSOR(	nr_seq_protocolo_pc	pls_protocolo_conta_imp.nr_sequencia%type) FOR
	SELECT	c.nr_sequencia nr_seq_item,
		b.nr_sequencia nr_seq_conta,
		c.dt_execucao,
		pls_util_pck.obter_somente_numero(c.cd_procedimento) cd_procedimento,
		c.nr_seq_material_ini_conv,
		a.nr_seq_prestador_conv,
		c.ie_tipo_despesa_conv,
		c.cd_tipo_tabela_conv,
		c.ie_tipo_item_conv
	from	pls_protocolo_conta_imp a,
		pls_conta_imp b,
		pls_conta_item_imp c
	where 	a.nr_sequencia = nr_seq_protocolo_pc
	and	b.nr_seq_protocolo = a.nr_sequencia
	and	c.nr_seq_conta = b.nr_sequencia
	and	c.ie_tipo_item_conv = 'M';


BEGIN

tb_nr_seq_item_w.delete;
tb_dt_execucao_w.delete;
tb_cd_procedimento_w.delete;
tb_nr_seq_mat_conv_w.delete;
tb_nr_seq_prest_conv_w.delete;
tb_ie_tipo_desp_conv_w.delete;
tb_cd_tipo_tab_conv_w.delete;

-- alimenta a tabela tempor_ria com os dados dos itens que ser_o verificados nas regras, o campo cd_procedimento

-- _ feito um pls_util_pck.obter_somente_numero nele e salvo no campo cd_procedimento_conv da tabela tempor_ria isto porque

-- como se trata de material no campo cd_procedimento se encontra o c_digo do material por_m para usar um between

-- precisamos que seja transformado este valor em um number


EXECUTE 'truncate table pls_conta_item_imp_tmp';

open C01(nr_seq_protocolo_p);
loop
	fetch C01 bulk collect into 	tb_nr_seq_item_w, tb_nr_seq_conta_w, tb_dt_execucao_w,
					tb_cd_procedimento_w, tb_nr_seq_mat_conv_w, tb_nr_seq_prest_conv_w,
					tb_ie_tipo_desp_conv_w, tb_cd_tipo_tab_conv_w, tb_ie_tipo_item_conv_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_item_w.count = 0;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
		insert 	into pls_conta_item_imp_tmp(
			nr_seq_protocolo, nr_seq_conta, nr_sequencia, 
			dt_execucao, cd_procedimento_conv, nr_seq_material_conv, 
			nr_seq_prest_prot_conv, ie_tipo_despesa_conv, cd_tipo_tabela_conv,
			ie_tipo_item_conv
		) values (
			nr_seq_protocolo_p, tb_nr_seq_conta_w(i), tb_nr_seq_item_w(i), 
			tb_dt_execucao_w(i), tb_cd_procedimento_w(i), tb_nr_seq_mat_conv_w(i), 
			tb_nr_seq_prest_conv_w(i), tb_ie_tipo_desp_conv_w(i), tb_cd_tipo_tab_conv_w(i),
			tb_ie_tipo_item_conv_w(i)
		);
	commit;		
end loop;
close C01;

-- faz a selecao das regras que ser_o processadas

CALL pls_conv_xml_cta_pck.gerencia_sel_regra_mat();
-- processa as regras selecionadas e faz as alteracoes necess_rias 

CALL pls_conv_xml_cta_pck.processa_regras_conv_mat();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.aplica_conversao_material ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type) FROM PUBLIC;