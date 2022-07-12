-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.gerencia_id_inicial_item ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

				
-- dados dos itens

tb_nr_seq_conta_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_item_w	pls_util_cta_pck.t_number_table;
tb_cd_procedimento_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_tipo_item_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_tipo_despesa_w	pls_util_cta_pck.t_varchar2_table_10;
tb_dt_execucao_w	pls_util_cta_pck.t_date_table;

C01 CURSOR(	nr_seq_protocolo_pc	pls_protocolo_conta_imp.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta,
		b.nr_sequencia nr_seq_item,
		b.cd_procedimento,
		b.ie_tipo_item,
		b.dt_execucao,
		b.ie_tipo_despesa
	from	pls_conta_imp a,
		pls_conta_item_imp b
	where	a.nr_seq_protocolo = nr_seq_protocolo_pc
	and 	b.nr_seq_conta = a.nr_sequencia;


BEGIN
-- copia os dados que ser_o utilizados para realizar a convers_o para a tabela pls_conta_item_imp_tmp

-- feito isso por quest_es de performance, visto que n_o _ saud_vel ficar atualizando dados em massa de uma tabela

-- que est_ sendo utilizada no cursor durante toda a execucao

EXECUTE 'truncate table pls_conta_item_imp_tmp';

tb_nr_seq_conta_w.delete;
tb_nr_seq_item_w.delete;
tb_cd_procedimento_w.delete;
tb_ie_tipo_item_w.delete;
tb_dt_execucao_w.delete;
tb_ie_tipo_despesa_w.delete;

open C01(nr_seq_protocolo_p);
loop
	fetch C01 bulk collect into 	tb_nr_seq_conta_w, tb_nr_seq_item_w, tb_cd_procedimento_w,
					tb_ie_tipo_item_w, tb_dt_execucao_w, tb_ie_tipo_despesa_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_item_w.count = 0;
	
	forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last 
		insert 	into pls_conta_item_imp_tmp(
			nr_seq_protocolo, nr_seq_conta, nr_sequencia, 
			cd_procedimento, ie_tipo_item, dt_execucao,
			ie_tipo_despesa			
		) values (
			nr_seq_protocolo_p, tb_nr_seq_conta_w(i), tb_nr_seq_item_w(i), 
			tb_cd_procedimento_w(i), tb_ie_tipo_item_w(i), tb_dt_execucao_w(i),
			tb_ie_tipo_despesa_w(i)
		);
	commit;
end loop;
close C01;

-- faz a identificacao inicial de todos os procedimentos do protocolo

CALL pls_conv_xml_cta_pck.identificacao_inicial_proc(cd_estabelecimento_p);

-- faz a identificacao de todos os materiais

CALL pls_conv_xml_cta_pck.identificacao_inicial_mat();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.gerencia_id_inicial_item ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;