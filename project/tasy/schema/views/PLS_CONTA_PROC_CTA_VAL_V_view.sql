-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_proc_cta_val_v (cd_area_procedimento, cd_especialidade, cd_grupo_proc, cd_procedimento, cd_procedimento_imp, dt_dia_semana, dt_dia_semana_imp, dt_fim_proc, dt_fim_proc_imp, dt_inicio_proc, dt_inicio_proc_imp, dt_procedimento, dt_procedimento_imp, dt_procedimento_imp_trunc, dt_procedimento_trunc, hr_fim_proc, hr_fim_proc_imp, hr_inicio_proc, hr_inicio_proc_imp, ie_origem_proced, ie_tipo_despesa, ie_tipo_despesa_imp, nr_seq_conta, nr_seq_grupo_rec, nr_sequencia, vl_procedimento, vl_procedimento_imp, nr_seq_preco_pacote, ie_origem_conta, vl_procedimento_ptu_imp, vl_material_ptu_imp, vl_co_ptu_imp, ie_coparticipacao, qt_procedimento_imp, qt_procedimento, ie_co_preco_operadora, vl_custo_operacional, ie_status, nr_seq_proc_ref, nr_seq_regra, nr_seq_regra_valor, vl_materiais, vl_total_partic, nr_seq_honorario_crit, nr_seq_hon_crit_medico, nr_seq_regra_vinculo, vl_liberado, cd_estabelecimento_prot, nr_seq_lote_conta, nr_seq_protocolo, nr_seq_prestador_prot, nr_seq_prestador_exec, nr_seq_prestador_conta, nr_seq_segurado, cd_guia_referencia, nr_seq_rp_combinada, nr_seq_analise) AS select	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	cd_procedimento_imp,
	dt_dia_semana,
	dt_dia_semana_imp,
	dt_fim_proc,
	dt_fim_proc_imp,
	dt_inicio_proc,
	dt_inicio_proc_imp,
	dt_procedimento,
	dt_procedimento_imp,
	dt_procedimento_imp_trunc,
	dt_procedimento_trunc,
	hr_fim_proc,
	hr_fim_proc_imp,
	hr_inicio_proc,
	hr_inicio_proc_imp,
	ie_origem_proced,
	ie_tipo_despesa,
	ie_tipo_despesa_imp,
	nr_seq_conta,
	nr_seq_grupo_rec,
	nr_sequencia,
	vl_procedimento,
	vl_procedimento_imp,
	nr_seq_preco_pacote,
	ie_origem_conta,
	vl_procedimento_ptu_imp,
	vl_material_ptu_imp,
	vl_co_ptu_imp,
	ie_coparticipacao,
	qt_procedimento_imp,
	qt_procedimento,
	ie_co_preco_operadora,
	vl_custo_operacional,
	ie_status,
	nr_seq_proc_ref,
	nr_seq_regra,
	nr_seq_regra_valor,
	vl_materiais,
	vl_total_partic,
	nr_seq_honorario_crit,
	nr_seq_hon_crit_medico,
	nr_seq_regra_vinculo,
	vl_liberado,
	cd_estabelecimento_prot,
	nr_seq_lote_conta,
	nr_seq_protocolo,
	nr_seq_prestador_prot,
	nr_seq_prestador_exec,
	nr_seq_prestador_conta,
	nr_seq_segurado,
	cd_guia_referencia,
	nr_seq_rp_combinada,
	nr_seq_analise
FROM	pls_conta_proc_v
where	ie_status in ('A', 'C', 'L', 'P', 'S', 'U')
and	ie_status_conta in ('A', 'F', 'L', 'P', 'U');
