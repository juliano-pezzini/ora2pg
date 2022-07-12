-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_mat_proc_v (nr_sequencia, cd_convenio, ie_emite_conta, nr_interno_conta, cd_mat_proc, ds_mat_proc, cd_unidade_medida_consumo, dt_atendimento, dt_conta, dt_conta_dia, qt_mat_proc, vl_unitario, vl_mat_proc, cd_mat_proc_conv, ds_mat_proc_conv, cd_unidade_medida_convenio, qt_mat_proc_conv, vl_mat_proc_conv, tx_conversao_qtde, cd_setor_atendimento, ds_setor_atendimento, ds_classif_setor, nr_seq_proc_pacote, vl_unitario_convenio, cd_classif_setor, vl_desconto, vl_bruto, cd_simpro, cd_lab_brasindice, ds_lab_brasindice, nr_seq_protocolo, qt_material_conv_div) AS select	nr_sequencia,
	cd_convenio, 
	ie_emite_conta, 
	nr_interno_conta, 
	cd_material cd_mat_proc, 
	ds_material ds_mat_proc, 
	cd_unidade_medida_consumo, 
	dt_atendimento, 
	dt_conta, 
	dt_conta_dia, 
	qt_material qt_mat_proc, 
	vl_unitario, 
	vl_material vl_mat_proc, 
	cd_material_convenio cd_mat_proc_conv, 
	ds_material_convenio ds_mat_proc_conv, 
	cd_unidade_medida_convenio, 
	qt_material_convenio qt_mat_proc_conv, 
	vl_material_convenio vl_mat_proc_conv, 
	tx_conversao_qtde, 
	cd_setor_atendimento, 
	ds_setor_atendimento, 
	ds_classif_setor, 
	nr_seq_proc_pacote, 
	vl_unitario_convenio, 
	cd_classif_setor, 
	vl_desconto, 
	vl_bruto, 
	cd_simpro, 
	cd_lab_brasindice, 
	ds_lab_brasindice, 
	nr_seq_protocolo, 
	qt_material_conv_div 
FROM	Conta_Paciente_Material_v 

union all
 
select	nr_sequencia, 
	cd_convenio, 
	ie_emite_conta, 
	nr_interno_conta, 
	cd_procedimento, 
	ds_procedimento, 
	null, 
	dt_procedimento, 
	dt_conta, 
	dt_conta_dia, 
	qt_procedimento, 
	vl_unitario, 
	vl_procedimento, 
	cd_procedimento_convenio, 
	ds_procedimento_convenio, 
	null, 
	qt_proced_convenio, 
	vl_proced_convenio, 
	tx_conversao_qtde, 
	cd_setor_atendimento, 
	ds_setor_atendimento, 
	ds_classif_setor, 
	nr_seq_proc_pacote, 
	vl_unitario_convenio, 
	null, 
	vl_desconto, 
	vl_bruto, 
	0, 
	'', 
	'', 
	nr_seq_protocolo, 
	null 
from	Conta_Paciente_procedimento_v;

