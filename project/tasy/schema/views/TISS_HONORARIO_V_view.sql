-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_honorario_v (tp_registro, ds_registro, nr_seq_protocolo, nr_interno_conta, nr_registro_ans, nr_atendimento, cd_autorizacao, dt_autorizacao, dt_guia, cd_usuario_convenio, nm_beneficiario, ds_plano, cd_cgc_prestador, nm_prestador, cd_pessoa_fisica, dt_procedimento, cd_edicao_amb, cd_procedimento, qt_procedimento, vl_unitario_item, vl_total_item) AS select	1					TP_REGISTRO,
	'CONTA'					DS_REGISTRO,
	a.nr_seq_protocolo			NR_SEQ_PROTOCOLO,
	a.nr_interno_conta			NR_INTERNO_CONTA,
	d.cd_ans				NR_REGISTRO_ANS,
	a.nr_atendimento			NR_ATENDIMENTO,
	substr(h.cd_autorizacao,1,10)		CD_AUTORIZACAO,
	b.dt_autorizacao			DT_AUTORIZACAO,
	e.dt_remessa				DT_GUIA,
	a.cd_usuario_convenio			CD_USUARIO_CONVENIO,
	a.nm_paciente				NM_BENEFICIARIO,
	substr(obter_desc_plano(a.cd_convenio, a.cd_plano_convenio),1,20) DS_PLANO,
	e.cd_cgc_hospital			CD_CGC_PRESTADOR,
	e.nm_hospital				NM_PRESTADOR,
	c.cd_pessoa_fisica			CD_PESSOA_FISICA,
	LOCALTIMESTAMP					DT_PROCEDIMENTO,
	substr(OBTER_EDICAO_AMB(d.cd_estabelecimento, a.cd_convenio, a.cd_categoria_convenio, b.dt_autorizacao),1,20)
CD_EDICAO_AMB,
	0					CD_PROCEDIMENTO,
	0					QT_PROCEDIMENTO,
	0					VL_UNITARIO_ITEM,
	0					VL_TOTAL_ITEM
FROM conta_paciente_guia h, conta_paciente f, w_interf_conta_header e, estabelecimento d, atendimento_paciente c, w_interf_conta_cab a
LEFT OUTER JOIN w_interf_conta_autor b ON (a.nr_interno_conta = b.nr_interno_conta)
WHERE a.nr_atendimento	= c.nr_atendimento and h.nr_atendimento	= c.nr_atendimento and f.nr_interno_conta	= h.nr_interno_conta and c.cd_estabelecimento	= d.cd_estabelecimento and e.nr_seq_protocolo	= a.nr_seq_protocolo

union all

select	2					TP_REGISTRO,
	'ITEM'					DS_REGISTRO,
	a.nr_seq_protocolo			NR_SEQ_PROTOCOLO,
	a.nr_interno_conta			NR_INTERNO_CONTA,
	c.cd_ans				NR_REGISTRO_ANS,
	a.nr_atendimento			NR_ATENDIMENTO,
	substr(h.cd_autorizacao,1,10)		CD_AUTORIZACAO,
	LOCALTIMESTAMP					DT_AUTORIZACAO,
	LOCALTIMESTAMP					DT_GUIA,
	' '					CD_USUARIO_CONVENIO,
	' '					NM_BENEFICIARIO,
	' '					DS_PLANO,
	' '					CD_CGC_PRESTADOR,
	' '					NM_PRESTADOR,
	b.cd_pessoa_fisica			CD_PESSOA_FISICA,
	a.dt_item				DT_PROCEDIMENTO,
	substr(OBTER_EDICAO_AMB(c.cd_estabelecimento, a.cd_convenio, d.cd_categoria_convenio, a.dt_autorizacao),1,20)
CD_EDICAO_AMB,
	a.cd_item				CD_PROCEDIMENTO,
	a.qt_item				QT_PROCEDIMENTO,
	a.vl_unitario_item			VL_UNITARIO_ITEM,
	a.vl_total_item				VL_TOTAL_ITEM
from	estabelecimento c,
	conta_paciente_guia h,
	conta_paciente f,
	atendimento_paciente b,
	w_interf_conta_cab d,
	w_interf_conta_item a
where	a.nr_atendimento	= b.nr_atendimento
and	h.nr_atendimento	= b.nr_atendimento
and	f.nr_interno_conta	= h.nr_interno_conta
and	b.cd_estabelecimento	= c.cd_estabelecimento
and	b.nr_atendimento	= d.nr_atendimento
and	a.nr_interno_conta	= d.nr_interno_conta;

