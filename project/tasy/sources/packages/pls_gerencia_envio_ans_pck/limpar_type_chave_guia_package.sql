-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.limpar_type_chave_guia ( tb_cd_ans_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_cd_cnes_prest_exec_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_cd_cpf_cgc_prest_exec_p INOUT pls_util_cta_pck.t_varchar2_table_15, tb_cd_guia_operadora_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_cd_guia_prestador_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_dt_cancelamento_p INOUT pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_p INOUT pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_recurso_p INOUT pls_util_cta_pck.t_date_table, tb_dt_pagamento_previsto_p INOUT pls_util_cta_pck.t_date_table, tb_dt_pagamento_recurso_p INOUT pls_util_cta_pck.t_date_table, tb_ie_reembolso_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_ie_tipo_registro_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_nr_seq_conta_p INOUT pls_util_cta_pck.t_number_table, tb_ie_identif_prest_exec_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_dt_processamento_p INOUT pls_util_cta_pck.t_date_table) AS $body$
BEGIN

tb_cd_ans_p.delete;
tb_cd_cnes_prest_exec_p.delete;
tb_cd_cpf_cgc_prest_exec_p.delete;
tb_cd_guia_operadora_p.delete;
tb_cd_guia_prestador_p.delete;
tb_dt_cancelamento_p.delete;
tb_dt_conta_fechada_p.delete;
tb_dt_conta_fechada_recurso_p.delete;
tb_dt_pagamento_previsto_p.delete;
tb_dt_pagamento_recurso_p.delete;
tb_ie_reembolso_p.delete;
tb_ie_tipo_registro_p.delete;
tb_nr_seq_conta_p.delete;
tb_ie_identif_prest_exec_p.delete;
tb_dt_processamento_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.limpar_type_chave_guia ( tb_cd_ans_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_cd_cnes_prest_exec_p INOUT pls_util_cta_pck.t_varchar2_table_10, tb_cd_cpf_cgc_prest_exec_p INOUT pls_util_cta_pck.t_varchar2_table_15, tb_cd_guia_operadora_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_cd_guia_prestador_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_dt_cancelamento_p INOUT pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_p INOUT pls_util_cta_pck.t_date_table, tb_dt_conta_fechada_recurso_p INOUT pls_util_cta_pck.t_date_table, tb_dt_pagamento_previsto_p INOUT pls_util_cta_pck.t_date_table, tb_dt_pagamento_recurso_p INOUT pls_util_cta_pck.t_date_table, tb_ie_reembolso_p INOUT pls_util_cta_pck.t_varchar2_table_20, tb_ie_tipo_registro_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_nr_seq_conta_p INOUT pls_util_cta_pck.t_number_table, tb_ie_identif_prest_exec_p INOUT pls_util_cta_pck.t_varchar2_table_1, tb_dt_processamento_p INOUT pls_util_cta_pck.t_date_table) FROM PUBLIC;
