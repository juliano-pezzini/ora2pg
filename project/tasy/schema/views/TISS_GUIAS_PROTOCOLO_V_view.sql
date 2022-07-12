-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_guias_protocolo_v (ds_versao, cd_autorizacao, ds_carater_internacao, ds_tipo_saida, ie_tipo_atendimento, nr_interno_conta, nr_seq_protocolo, nr_atendimento, dt_entrada, ie_tipo_saida, cd_medico_executor, ie_guia_principal, ie_tipo_protocolo) AS select	'2.01.01' ds_versao,
	c.cd_autorizacao,
	CASE WHEN b.ie_carater_inter_sus='1' THEN 'E'  ELSE 'U' END  DS_CARATER_INTERNACAO,
	'A' ds_tipo_saida,
	CASE WHEN b.ie_tipo_atendimento=1 THEN  '7' WHEN b.ie_tipo_atendimento=3 THEN  '4' WHEN b.ie_tipo_atendimento=7 THEN  '6' WHEN b.ie_tipo_atendimento=8 THEN '4' END  ie_tipo_atendimento,
	a.nr_interno_conta,
	a.nr_seq_protocolo,
	a.nr_atendimento,
	b.dt_entrada,
	CASE WHEN coalesce(d.ie_obito,'N')='S' THEN 6  ELSE 5 END  ie_tipo_saida,
	coalesce(e.cd_medico_executor, b.cd_medico_atendimento) cd_medico_executor,
	CASE WHEN count(*)=1 THEN 'S'  ELSE 'N' END  ie_guia_principal,
	f.ie_tipo_protocolo
FROM protocolo_convenio f, procedimento_paciente e, conta_paciente_guia c, conta_paciente a, atendimento_paciente b
LEFT OUTER JOIN motivo_alta d ON (b.cd_motivo_alta = d.cd_motivo_alta)
WHERE a.nr_atendimento	= b.nr_atendimento and a.nr_interno_conta	= c.nr_interno_conta  and e.nr_interno_conta	= c.nr_interno_conta and e.nr_doc_convenio	= c.cd_autorizacao and a.nr_seq_protocolo	= f.nr_seq_protocolo
group	by c.cd_autorizacao,
	CASE WHEN b.ie_carater_inter_sus='1' THEN 'E'  ELSE 'U' END ,
	CASE WHEN b.ie_tipo_atendimento=1 THEN  '7' WHEN b.ie_tipo_atendimento=3 THEN  '4' WHEN b.ie_tipo_atendimento=7 THEN  '6' WHEN b.ie_tipo_atendimento=8 THEN '4' END ,
	a.nr_interno_conta,
	a.nr_seq_protocolo,
	a.nr_atendimento,
	b.dt_entrada,
	CASE WHEN coalesce(d.ie_obito,'N')='S' THEN 6  ELSE 5 END ,
	coalesce(e.cd_medico_executor, b.cd_medico_atendimento),
	f.ie_tipo_protocolo

union all

select	'2.01.01' ds_versao,
	'Não Informada' cd_autorizacao,
	CASE WHEN b.ie_carater_inter_sus='1' THEN 'E'  ELSE 'U' END  DS_CARATER_INTERNACAO,
	'A' ds_tipo_saida,
	CASE WHEN b.ie_tipo_atendimento=1 THEN  '7' WHEN b.ie_tipo_atendimento=3 THEN  '4' WHEN b.ie_tipo_atendimento=7 THEN  '6' WHEN b.ie_tipo_atendimento=8 THEN '4' END  ie_tipo_atendimento,
	a.nr_interno_conta,
	a.nr_seq_protocolo,
	a.nr_atendimento,
	b.dt_entrada,
	CASE WHEN coalesce(d.ie_obito,'N')='S' THEN 6  ELSE 5 END  ie_tipo_saida,
	b.cd_medico_atendimento cd_medico_executor,
	'S' ie_guia_principal,
	c.ie_tipo_protocolo
FROM procedimento_paciente e, protocolo_convenio c, conta_paciente a, atendimento_paciente b
LEFT OUTER JOIN motivo_alta d ON (b.cd_motivo_alta = d.cd_motivo_alta)
WHERE a.nr_atendimento	= b.nr_atendimento and a.nr_seq_protocolo	= c.nr_seq_protocolo  and a.nr_interno_conta	= e.nr_interno_conta and coalesce(e.nr_doc_convenio, 'Não Informada') = 'Não Informada'
group 	by CASE WHEN b.ie_carater_inter_sus='1' THEN 'E'  ELSE 'U' END ,
	CASE WHEN b.ie_tipo_atendimento=1 THEN  '7' WHEN b.ie_tipo_atendimento=3 THEN  '4' WHEN b.ie_tipo_atendimento=7 THEN  '6' WHEN b.ie_tipo_atendimento=8 THEN '4' END ,
	a.nr_interno_conta,
	a.nr_seq_protocolo,
	a.nr_atendimento,
	b.dt_entrada,
	CASE WHEN coalesce(d.ie_obito,'N')='S' THEN 6  ELSE 5 END ,
	b.cd_medico_atendimento,
	c.ie_tipo_protocolo;

