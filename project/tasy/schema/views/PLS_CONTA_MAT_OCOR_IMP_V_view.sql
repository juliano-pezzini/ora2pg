-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_mat_ocor_imp_v (nr_sequencia, nr_seq_material, dt_atendimento, dt_atendimento_conta, cd_guia_referencia, cd_medico_executor, nr_seq_segurado, nr_seq_prestador_exec, cd_cid_principal_conta, cd_cat_cid_principal_conta, nr_seq_cbo_saude, ie_tipo_guia, nr_seq_conta, qt_executado) AS select	nr_sequencia,
	nr_seq_material,
	dt_atendimento,
	dt_atendimento dt_atendimento_conta,
	cd_guia_referencia,
	cd_medico_executor,
	nr_seq_segurado,
	nr_seq_prestador_exec,
	cd_cid_principal_conta,
	cd_cat_cid_principal_conta,
	nr_seq_cbo_saude,
	ie_tipo_guia,
	nr_seq_conta,
	qt_executado
FROM	pls_conta_mat_imp_n_v;
