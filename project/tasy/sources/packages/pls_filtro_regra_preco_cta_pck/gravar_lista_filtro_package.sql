-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_preco_cta_pck.gravar_lista_filtro ( nr_id_transacao_p pls_cp_cta_selecao.nr_id_transacao%type, nr_seq_filtro_p pls_cp_cta_filtro.nr_sequencia%type, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, tb_nr_seq_conta_p pls_util_cta_pck.t_number_table, tb_nr_seq_conta_proc_p pls_util_cta_pck.t_number_table, tb_nr_seq_conta_mat_p pls_util_cta_pck.t_number_table, tb_nr_seq_partic_p pls_util_cta_pck.t_number_table, ie_valido_p pls_cp_cta_selecao.ie_valido%type) AS $body$
BEGIN

if (tb_nr_seq_conta_p.count > 0) then

	forall i in tb_nr_seq_conta_p.first..tb_nr_seq_conta_p.last
		insert into pls_cp_cta_selecao(	nr_sequencia, nr_id_transacao,
				nr_seq_conta, nr_seq_conta_proc, 
				nr_seq_conta_mat, nr_seq_proc_partic,
				nr_seq_filtro, ie_valido, 
				ie_valido_temp, ie_excecao, 
				ie_tipo_registro)
		values (	nextval('pls_cp_cta_selecao_seq'), nr_id_transacao_p,
				tb_nr_seq_conta_p(i), tb_nr_seq_conta_proc_p(i),
				tb_nr_seq_conta_mat_p(i), tb_nr_seq_partic_p(i),
				nr_seq_filtro_p, ie_valido_p,
				'S', 'N', 
				ie_tipo_regra_p);
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_preco_cta_pck.gravar_lista_filtro ( nr_id_transacao_p pls_cp_cta_selecao.nr_id_transacao%type, nr_seq_filtro_p pls_cp_cta_filtro.nr_sequencia%type, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, tb_nr_seq_conta_p pls_util_cta_pck.t_number_table, tb_nr_seq_conta_proc_p pls_util_cta_pck.t_number_table, tb_nr_seq_conta_mat_p pls_util_cta_pck.t_number_table, tb_nr_seq_partic_p pls_util_cta_pck.t_number_table, ie_valido_p pls_cp_cta_selecao.ie_valido%type) FROM PUBLIC;
