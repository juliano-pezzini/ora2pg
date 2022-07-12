-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hdjf_etapas_conta_v (ie_etapa, nr_atendimento, nm_paciente, ds_quebra, ie_status_p, cd_convenio_parametro, ds_convenio, vl_imposto, vl_liquido, vl_margem, vl_marcustooper, vl_material, vl_original, vl_repasse_calc, vl_custo, vl_total, qt_contas, ds_tipo_atend, cd_tipo_atend, dt_item, nr_atend, nr_interno_conta, ie_status_acerto, nr_seq_protocolo, dt_etapa, ds_etapa, nr_seq_etapa) AS select	1 ie_etapa,
	d.nr_atendimento, 
	substr(obter_pessoa_atendimento(d.nr_atendimento, 'N'),1,200) nm_paciente, 
	substr(obter_valor_dominio(1076,obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo)),1,100) ds_quebra, 
	obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo) ie_status_p,b.cd_convenio_parametro, 
	substr(obter_nome_convenio(b.cd_convenio_parametro),1,100) ds_convenio, 
	coalesce(sum(a.vl_imposto),0) vl_imposto, 
	coalesce(sum(a.vl_material+a.vl_procedimento-a.vl_imposto-a.vl_repasse_terceiro),0) vl_liquido, 
	coalesce(sum(a.vl_procedimento+a.vl_material-a.vl_custo-a.vl_imposto),0) vl_margem, 
	coalesce(sum(a.vl_material+a.vl_materiais+a.vl_custo_operacional),0) vl_marcustooper, 
	coalesce(sum(a.vl_material),0) vl_material,coalesce(sum(a.vl_original),0) vl_original,coalesce(sum(a.vl_repasse_calc),0) vl_repasse_calc, 
	coalesce(sum(a.vl_custo),0) vl_custo,coalesce(sum(a.vl_material+a.vl_procedimento),0) vl_total,count(distinct b.nr_interno_conta) qt_contas, 
	substr(obter_valor_dominio(12,obter_tipo_atendimento(b.nr_atendimento)),1,100) ds_tipo_atend,obter_tipo_atendimento(b.nr_atendimento) cd_tipo_atend, 
	d.dt_alta dt_item, 
	d.ie_tipo_atendimento nr_atend, 
	b.nr_interno_conta, 
	b.ie_status_acerto, 
	b.nr_seq_protocolo, 
	t.dt_etapa, 
	substr(obter_descricao_padrao('FATUR_ETAPA', 'DS_ETAPA', t.nr_seq_etapa),1,200) ds_etapa, 
	t.nr_seq_etapa 
FROM conta_paciente_etapa t, atendimento_paciente d, conta_paciente b
LEFT OUTER JOIN conta_paciente_resumo a ON (b.nr_interno_conta = a.nr_interno_conta)
WHERE b.nr_atendimento = d.nr_atendimento and b.nr_interno_conta = t.nr_interno_conta group by		d.nr_atendimento, 
	substr(obter_pessoa_atendimento(d.nr_atendimento, 'N'),1,200), 
	substr(obter_valor_dominio(1076, obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo)),1,100), 
	b.cd_convenio_parametro,substr(obter_nome_convenio(b.cd_convenio_parametro),1,100),obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo), 
	substr(obter_valor_dominio(12,obter_tipo_atendimento(b.nr_atendimento)),1,100),obter_tipo_atendimento(b.nr_atendimento), 
	d.dt_alta, 
	d.ie_tipo_atendimento, 
	b.nr_interno_conta, 
	b.ie_status_acerto, 
	b.nr_seq_protocolo, 
	t.dt_etapa, 
	substr(obter_descricao_padrao('FATUR_ETAPA', 'DS_ETAPA', t.nr_seq_etapa),1,200), 
	t.nr_seq_etapa 

union
 
select	2 ie_etapa, 
		b.nr_atendimento, 
	substr(obter_pessoa_atendimento(b.nr_atendimento, 'N'),1,200) nm_paciente, 
	substr(obter_valor_dominio(1076,obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo)),1,100) ds_quebra, 
	obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo) ie_status_p,b.cd_convenio_parametro, 
	substr(obter_nome_convenio(b.cd_convenio_parametro),1,100) ds_convenio, 
	coalesce(sum(a.vl_imposto),0) vl_imposto, 
	coalesce(sum(a.vl_material+a.vl_procedimento-a.vl_imposto-a.vl_repasse_terceiro),0) vl_liquido, 
	coalesce(sum(a.vl_procedimento+a.vl_material-a.vl_custo-a.vl_imposto),0) vl_margem, 
	coalesce(sum(a.vl_material+a.vl_materiais+a.vl_custo_operacional),0) vl_marcustooper, 
	coalesce(sum(a.vl_material),0) vl_material,coalesce(sum(a.vl_original),0) vl_original,coalesce(sum(a.vl_repasse_calc),0) vl_repasse_calc,coalesce(sum(a.vl_custo),0) vl_custo, 
	coalesce(sum(a.vl_material+a.vl_procedimento),0) vl_total,count(distinct b.nr_interno_conta) qt_contas, 
	substr(obter_valor_dominio(12,obter_tipo_atendimento(b.nr_atendimento)),1,100) ds_tipo_atend,obter_tipo_atendimento(b.nr_atendimento) cd_tipo_atend, 
	b.dt_mesano_referencia dt_item, 
	obter_tipo_atendimento(b.nr_atendimento) nr_atend , 
	b.nr_interno_conta, 
	b.ie_status_acerto, 
	b.nr_seq_protocolo, 
	t.dt_etapa, 
	substr(obter_descricao_padrao('FATUR_ETAPA', 'DS_ETAPA', t.nr_seq_etapa),1,200) ds_etapa, 
	t.nr_seq_etapa 
FROM conta_paciente_etapa t, conta_paciente b
LEFT OUTER JOIN conta_paciente_resumo a ON (b.nr_interno_conta = a.nr_interno_conta)
WHERE b.nr_interno_conta = t.nr_interno_conta group by		b.nr_atendimento, 
	substr(obter_pessoa_atendimento(b.nr_atendimento, 'N'),1,200), 
substr(obter_valor_dominio(1076,obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo)),1,100), 
	b.cd_convenio_parametro,substr(obter_nome_convenio(b.cd_convenio_parametro),1,100),obter_status_conta_protocolo(b.nr_interno_conta,b.ie_status_acerto,b.nr_seq_protocolo), 
	substr(obter_valor_dominio(12, obter_tipo_atendimento(b.nr_atendimento)),1,100),obter_tipo_atendimento(b.nr_atendimento), 
	b.dt_mesano_referencia, 
	obter_tipo_atendimento(b.nr_atendimento), 
	b.nr_interno_conta, 
	b.ie_status_acerto, 
	b.nr_seq_protocolo, 
	t.dt_etapa, 
	substr(obter_descricao_padrao('FATUR_ETAPA', 'DS_ETAPA', t.nr_seq_etapa),1,200), 
	t.nr_seq_etapa 
order by 	4,16,1;
