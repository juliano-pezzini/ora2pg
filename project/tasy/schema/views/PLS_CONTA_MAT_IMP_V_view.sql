-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_mat_imp_v (nr_seq_conta, nr_sequencia, cd_guia_referencia, qt_ok, nr_nota_cobranca, nr_fatura, cd_congenere, ie_tipo_conta, dt_atendimento, nr_seq_prestador_exec, nr_seq_segurado, cd_medico_executor, nr_seq_material) AS select	--  Retorna materiais, importados ou integrados, usa union por questões de performance e organização
	nr_seq_conta,
	nr_sequencia,
	cd_guia_referencia,
	qt_ok,
	nr_nota_cobranca,
	pls_obter_nr_fatura(nr_seq_fatura) nr_fatura,
	cd_congenere,
	ie_tipo_conta,
	dt_atendimento,
	to_char(nr_seq_prestador_exec) nr_seq_prestador_exec,
	nr_seq_segurado,
	cd_medico_executor,
	nr_seq_material
FROM	pls_conta_mat_v
where	ie_status <> 'D';
