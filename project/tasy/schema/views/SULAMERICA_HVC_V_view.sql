-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sulamerica_hvc_v (ds_registro, tp_registro, ie_servico, cd_registro, cd_origem, nr_lote, nr_interno_conta, nr_parcela, cd_convenio, nm_convenio, tp_prestador, cd_prestador, nm_prestador, dt_geracao, nr_remessa, cd_plano, cd_paciente, cd_autorizacao, cd_acomodacao, dt_entrada, dt_saida, dt_inicio_cobranca, dt_fim_cobranca, ie_tipo_atendimento, cd_cid, cd_proc_principal, cd_medico_convenio, nr_crm, uf_crm, nr_crm_req, uf_crm_req, nr_seq_item, cd_item, nm_item, ie_emergencia, ie_extra, dt_item, ie_funcao_medico, qt_item, vl_item, ie_cirurgia_multipla, vl_total_item, qt_item_conta, nm_paciente, nr_fatura, qt_conta, vl_total_lote, nr_seq_protocolo, ds_espaco, nr_registro, cd_cgc_prestador, cd_motivo_alta, ie_laudo_especial, ie_laudo_prorrogacao, dt_autorizacao, dt_validade_carteirinha, nr_prontuario, nm_medico_resp, ie_tipo_doc_paciente, nr_doc_paciente, ie_matmed, nr_crm_resp, uf_crm_resp, cd_senha, cd_especialidade, vl_proc_principal, ie_tipo_cirurgia, cd_unidade_atend, qt_diaria_enfermaria, qt_diaria_uti, cd_leitora, ie_fim_registro, ie_tipo_atend_tasy, cd_interno_protocolo, nr_guia, cd_senha_guia, tp_internacao) AS SELECT
	DS_REGISTRO                    ,
	TP_REGISTRO                    ,
	IE_SERVICO                     ,
	CD_REGISTRO                    ,
	CD_ORIGEM                      ,
	NR_LOTE                        ,
	NR_INTERNO_CONTA               ,
	NR_PARCELA                     ,
	CD_CONVENIO                    ,
	NM_CONVENIO                    ,
	TP_PRESTADOR                   ,
	CD_PRESTADOR                   ,
	NM_PRESTADOR                   ,
	DT_GERACAO                     ,
	NR_REMESSA                     ,
	CD_PLANO                       ,
	CD_PACIENTE                    ,
	CD_AUTORIZACAO                 ,
	CD_ACOMODACAO                  ,
	DT_ENTRADA                     ,
	DT_SAIDA                       ,
	DT_INICIO_COBRANCA             ,
	DT_FIM_COBRANCA                ,
	IE_TIPO_ATENDIMENTO            ,
	CD_CID                         ,
	CD_PROC_PRINCIPAL              ,
	CD_MEDICO_CONVENIO             ,
	NR_CRM                         ,
	UF_CRM                         ,
	NR_CRM_REQ                     ,
	UF_CRM_REQ                     ,
	NR_SEQ_ITEM                    ,
/* OS 28009
	decode(ie_matmed,'1','MT'||to_char(cd_item,'FM000000'),
			     '2','MD'||to_char(cd_item,'FM000000'),cd_item) CD_ITEM, */
	to_char(cd_item,'FM00000000') cd_item,
	NM_ITEM                        ,
	IE_EMERGENCIA                  ,
	IE_EXTRA                       ,
	DT_ITEM                        ,
	IE_FUNCAO_MEDICO               ,
	QT_ITEM                        ,
	VL_ITEM                        ,
	IE_CIRURGIA_MULTIPLA           ,
	VL_TOTAL_ITEM                  ,
	QT_ITEM_CONTA                  ,
	NM_PACIENTE                    ,
	NR_FATURA                      ,
	QT_CONTA                       ,
	VL_TOTAL_LOTE                  ,
	NR_SEQ_PROTOCOLO               ,
	DS_ESPACO                      ,
	NR_REGISTRO                    ,
	CD_CGC_PRESTADOR               ,
	CD_MOTIVO_ALTA                 ,
	IE_LAUDO_ESPECIAL              ,
	IE_LAUDO_PRORROGACAO           ,
	DT_AUTORIZACAO                 ,
	DT_VALIDADE_CARTEIRINHA        ,
	NR_PRONTUARIO                  ,
	NM_MEDICO_RESP                 ,
	IE_TIPO_DOC_PACIENTE           ,
	NR_DOC_PACIENTE                ,
	IE_MATMED                      ,
	NR_CRM_RESP                    ,
	UF_CRM_RESP                    ,
	CD_SENHA                       ,
	CD_ESPECIALIDADE               ,
	VL_PROC_PRINCIPAL              ,
	IE_TIPO_CIRURGIA               ,
	CD_UNIDADE_ATEND               ,
	QT_DIARIA_ENFERMARIA           ,
	QT_DIARIA_UTI                  ,
	CD_LEITORA                     ,
	IE_FIM_REGISTRO                ,
	IE_TIPO_ATEND_TASY             ,
	CD_INTERNO_PROTOCOLO           ,
	NR_GUIA                        ,
	CD_SENHA_GUIA                  ,
	TP_INTERNACAO
FROM	ABRAMGE_II_V;

