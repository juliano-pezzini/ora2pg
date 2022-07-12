-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualizar_moni_tiss_chave_guia ( tb_cd_ans_p pls_util_cta_pck.t_varchar2_table_10, tb_cd_cnes_prest_exec_p pls_util_cta_pck.t_varchar2_table_10, tb_cd_cpf_cgc_prest_exec_p pls_util_cta_pck.t_varchar2_table_15, tb_cd_guia_operadora_p pls_util_cta_pck.t_varchar2_table_20, tb_cd_guia_prestador_p pls_util_cta_pck.t_varchar2_table_20, tb_dt_cancelamento_p pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_p pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_recurso_p pls_util_cta_pck.t_date_table, tb_dt_pagamento_previsto_p pls_util_cta_pck.t_date_table, tb_dt_pagamento_recurso_p pls_util_cta_pck.t_date_table, tb_ie_reembolso_p pls_util_cta_pck.t_varchar2_table_20, tb_ie_tipo_registro_p pls_util_cta_pck.t_varchar2_table_1, tb_nr_seq_conta_p pls_util_cta_pck.t_number_table, tb_ie_identif_prest_exec_p pls_util_cta_pck.t_varchar2_table_1, tb_dt_processamento_p pls_util_cta_pck.t_date_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (tb_dt_processamento_p.count > 0) then
	forall i in tb_dt_processamento_p.first .. tb_dt_processamento_p.last
		insert into	pls_moni_tiss_chave_guia(
				nr_sequencia, cd_ans, cd_cnes_prest_exec,
				cd_cpf_cgc_prest_exec, cd_guia_operadora, cd_guia_prestador,
				dt_cancelamento, dt_conta_fechada, dt_conta_fechada_recurso,
				dt_pagamento_previsto, dt_pagamento_recurso, dt_processamento,
				ie_identif_prest_exec, ie_reembolso, ie_status,
				ie_tipo_registro, nr_seq_conta, dt_atualizacao,
				dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec
		) values (
				nextval('pls_moni_tiss_chave_guia_seq'), tb_cd_ans_p(i), tb_cd_cnes_prest_exec_p(i),
				tb_cd_cpf_cgc_prest_exec_p(i), tb_cd_guia_operadora_p(i), tb_cd_guia_prestador_p(i),
				tb_dt_cancelamento_p(i), tb_dt_conta_fechada_p(i), tb_dt_conta_fechada_recurso_p(i),
				tb_dt_pagamento_previsto_p(i), tb_dt_pagamento_recurso_p(i), trunc(tb_dt_processamento_p(i)),
				tb_ie_identif_prest_exec_p(i), tb_ie_reembolso_p(i), 'E',
				tb_ie_tipo_registro_p(i), tb_nr_seq_conta_p(i), clock_timestamp(),
				clock_timestamp(), nm_usuario_p, nm_usuario_p
		);
		commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualizar_moni_tiss_chave_guia ( tb_cd_ans_p pls_util_cta_pck.t_varchar2_table_10, tb_cd_cnes_prest_exec_p pls_util_cta_pck.t_varchar2_table_10, tb_cd_cpf_cgc_prest_exec_p pls_util_cta_pck.t_varchar2_table_15, tb_cd_guia_operadora_p pls_util_cta_pck.t_varchar2_table_20, tb_cd_guia_prestador_p pls_util_cta_pck.t_varchar2_table_20, tb_dt_cancelamento_p pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_p pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_recurso_p pls_util_cta_pck.t_date_table, tb_dt_pagamento_previsto_p pls_util_cta_pck.t_date_table, tb_dt_pagamento_recurso_p pls_util_cta_pck.t_date_table, tb_ie_reembolso_p pls_util_cta_pck.t_varchar2_table_20, tb_ie_tipo_registro_p pls_util_cta_pck.t_varchar2_table_1, tb_nr_seq_conta_p pls_util_cta_pck.t_number_table, tb_ie_identif_prest_exec_p pls_util_cta_pck.t_varchar2_table_1, tb_dt_processamento_p pls_util_cta_pck.t_date_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
