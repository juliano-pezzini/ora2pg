-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW abramge_ii_hmsm_v (ds_registro, tp_registro, ie_servico, cd_registro, cd_origem, nr_lote, nr_interno_conta, nr_parcela, cd_convenio, nm_convenio, tp_prestador, cd_prestador, nm_prestador, dt_geracao, nr_remessa, cd_plano, cd_paciente, cd_autorizacao, cd_acomodacao, dt_entrada, dt_saida, dt_inicio_cobranca, dt_fim_cobranca, ie_tipo_atendimento, cd_cid, cd_proc_principal, cd_medico_convenio, nr_crm, uf_crm, nr_crm_req, uf_crm_req, nr_seq_item, cd_item, nm_item, ie_emergencia, ie_extra, dt_item, ie_funcao_medico, qt_item, vl_item, ie_cirurgia_multipla, vl_total_item, qt_item_conta, nm_paciente, nr_fatura, qt_conta, vl_total_lote, nr_seq_protocolo, ds_espaco, nr_registro, cd_cgc_prestador, cd_motivo_alta, ie_laudo_especial, ie_laudo_prorrogacao, dt_autorizacao, dt_validade_carteirinha, nr_prontuario, nm_medico_resp, ie_tipo_doc_paciente, nr_doc_paciente, ie_matmed, nr_crm_resp, uf_crm_resp, nr_cpf_resp, cd_senha, cd_especialidade, vl_proc_principal, ie_tipo_cirurgia, cd_unidade_atend, qt_diaria_enfermaria, qt_diaria_uti, cd_leitora, ie_fim_registro, ie_tipo_atend_tasy, cd_interno_protocolo, nr_guia, cd_senha_guia, tp_internacao, cd_unidade_medida, ie_tipo_faturamento, ie_folha_sala) AS SELECT		'HEADER               ' 	DS_REGISTRO,
		1				TP_REGISTRO,
		'CSMH'				IE_SERVICO,
		0				CD_REGISTRO,
		somente_numero(coalesce(A.CD_INTERNO,0))	CD_ORIGEM,
		0				NR_LOTE,
		0				NR_INTERNO_CONTA,
		0				NR_PARCELA,
		somente_numero(coalesce(A.CD_REGIONAL,0))	CD_CONVENIO,
		substr(UPPER(A.NM_CONVENIO),1,30)
						NM_CONVENIO,
		'J'				TP_PRESTADOR,
		A.CD_CGC_HOSPITAL		CD_PRESTADOR,
		substr(UPPER(A.NM_HOSPITAL),1,40)
						NM_PRESTADOR,
		A.DT_REMESSA			DT_GERACAO,
		A.nr_remessa			NR_REMESSA,
		0				CD_PLANO,
		' '				CD_PACIENTE,
		' '				CD_AUTORIZACAO,
		0				CD_ACOMODACAO,
		LOCALTIMESTAMP			DT_ENTRADA,
		LOCALTIMESTAMP			DT_SAIDA,
		LOCALTIMESTAMP			DT_INICIO_COBRANCA,
		LOCALTIMESTAMP			DT_FIM_COBRANCA,
		0				IE_TIPO_ATENDIMENTO,
		null				CD_CID,
		0				CD_PROC_PRINCIPAL,
		' '				CD_MEDICO_CONVENIO,
		' '				NR_CRM,
		' '				UF_CRM,
		' '				NR_CRM_REQ,
		' '				UF_CRM_REQ,
		1				NR_SEQ_ITEM,
		' '				CD_ITEM,
		' '				NM_ITEM,
		' '				IE_EMERGENCIA,
		' '				IE_EXTRA,
		LOCALTIMESTAMP			DT_ITEM,
		0				IE_FUNCAO_MEDICO,
		0				QT_ITEM,
		0				VL_ITEM,
		0				IE_CIRURGIA_MULTIPLA,
            	0		      		VL_TOTAL_ITEM,
            	0	      			QT_ITEM_CONTA,
	      	' '				NM_PACIENTE,
            	' '	      			NR_FATURA,
            	0				QT_CONTA,
            	0				VL_TOTAL_LOTE,
		A.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		'                   '	DS_ESPACO,
		1				NR_REGISTRO,
		' '				CD_CGC_PRESTADOR,
		0 				CD_MOTIVO_ALTA,
		' '				IE_LAUDO_ESPECIAL,
		' '				IE_LAUDO_PRORROGACAO,
		LOCALTIMESTAMP			dt_autorizacao,
		LOCALTIMESTAMP			dt_validade_carteirinha,
		0				nr_prontuario,
		' '				nm_medico_resp,
		' '				ie_tipo_doc_paciente,
		' '				nr_doc_paciente,
		' '				ie_matmed,
		0				nr_crm_resp,
		' '				uf_crm_resp,
		' '				nr_cpf_resp,
		' '				cd_senha,
		0				cd_especialidade,
		0				vl_proc_principal,
		0				ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		0				ie_tipo_atend_tasy,
		coalesce(somente_numero(A.nr_protocolo),0)
						cd_interno_protocolo,
		0				nr_guia,
		' '				cd_senha_guia,
		0				tp_internacao,
		' '				cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM		W_INTERF_CONTA_HEADER A

union all

SELECT		'CABECALHO CONTA      '	DS_REGISTRO,
		2				TP_REGISTRO,
		'CSMH'				IE_SERVICO,
		1				CD_REGISTRO,
		somente_numero(coalesce(x.cd_interno,0))	CD_ORIGEM,
		B.NR_SEQ_PROTOCOLO		NR_LOTE,
		B.NR_INTERNO_CONTA		NR_INTERNO_CONTA,
		1				NR_PARCELA,
		0				CD_CONVENIO,
		' '				NM_CONVENIO,
		'J'				TP_PRESTADOR,
		B.CD_CGC_HOSPITAL		CD_PRESTADOR,
		' '				NM_PRESTADOR,
		LOCALTIMESTAMP			DT_GERACAO,
		1				NR_REMESSA,
		somente_numero(coalesce(B.CD_PLANO_CONVENIO,CD_CATEGORIA_CONVENIO))
						CD_PLANO,
		substr(B.CD_USUARIO_CONVENIO,1,18)
						CD_PACIENTE,
		CASE WHEN B.IE_TIPO_ATENDIMENTO=3 THEN ' '  ELSE substr(B.NR_DOC_CONVENIO,1,10) END
						CD_AUTORIZACAO,
		B.CD_TIPO_ACOMODACAO		CD_ACOMODACAO,
		B.DT_ENTRADA			DT_ENTRADA,
		coalesce(B.DT_ALTA,B.DT_PERIODO_FINAL)
						DT_SAIDA,
		B.DT_PERIODO_INICIAL		DT_INICIO_COBRANCA,
		coalesce(B.DT_ALTA,B.DT_PERIODO_FINAL)
						DT_FIM_COBRANCA,
		B.IE_CLINICA			IE_TIPO_ATENDIMENTO,
		B.CD_CID_PRINCIPAL		CD_CID,
		somente_numero(coalesce(B.CD_PROC_PRINCIPAL,0))
						CD_PROC_PRINCIPAL,
		B.CD_CONV_MEDICO_RESP	CD_MEDICO_CONVENIO,
		B.NR_CRM_MEDICO_RESP		NR_CRM,
		B.UF_CRM_MEDICO_RESP		UF_CRM,
		B.NR_CRM_MEDICO_RESP		NR_CRM_REQ,
		B.UF_CRM_MEDICO_RESP		UF_CRM_REQ,
		1				NR_SEQ_ITEM,
		' '				CD_ITEM,
		' '				NM_ITEM,
		' '				IE_EMERGENCIA,
		' '				IE_EXTRA,
		LOCALTIMESTAMP			DT_ITEM,
		0				IE_FUNCAO_MEDICO,
		0				QT_ITEM,
		0				VL_ITEM,
		0				IE_CIRURGIA_MULTIPLA,
            	0		      		VL_TOTAL_ITEM,
            	0	      			QT_ITEM_CONTA,
	     	substr(UPPER(B.NM_PACIENTE),1,40) NM_PACIENTE,
            	' '	      			NR_FATURA,
            	0				QT_CONTA,
            	0				VL_TOTAL_LOTE,
		B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		' '				DS_ESPACO,
		1				NR_REGISTRO,
		B.CD_CGC_HOSPITAL		CD_CGC_PRESTADOR,
		CASE WHEN B.IE_TIPO_ATENDIMENTO=3 THEN 0  ELSE B.CD_MOTIVO_ALTA END 		CD_MOTIVO_ALTA,
		'N'				IE_LAUDO_ESPECIAL,
		'N'				IE_LAUDO_PRORROGACAO,
		c.dt_autorizacao		dt_autorizacao,
		B.dt_validade_carteira	dt_validade_carteirinha,
		B.nr_prontuario		nr_prontuario,
		substr(B.nm_medico_resp,1,40)nm_medico_resp,
		CASE WHEN B.nr_cpf_paciente IS NULL THEN         		CASE WHEN B.nr_identidade IS NULL THEN '   '  ELSE 'CI ' END   ELSE 'CPF' END 
						ie_tipo_doc_paciente,
		coalesce(B.nr_cpf_paciente,somente_numero(B.nr_identidade))
						nr_doc_paciente,
		' '				ie_matmed,
		0				nr_crm_resp,
		' '				uf_crm_resp,
		' '				nr_cpf_resp,
		' '				cd_senha,
		0				cd_especialidade,
		0				vl_proc_principal,
		0				ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		B.ie_tipo_atendimento	ie_tipo_atend_tasy,
		coalesce(somente_numero(x.nr_protocolo),0)
						cd_interno_protocolo,
		coalesce(somente_numero(B.nr_doc_convenio),0)
						nr_guia,
		B.cd_senha_guia		cd_senha_guia,
		B.IE_CLINICA			tp_internacao,
		' '				cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM w_interf_conta_header x, w_interf_conta_cab b
LEFT OUTER JOIN w_interf_conta_autor c ON (B.nr_interno_conta = c.nr_interno_conta)
WHERE B.nr_seq_protocolo	= x.nr_seq_protocolo  and coalesce(c.nr_sequencia,0) =
		(select coalesce(min(y.nr_sequencia),0)
			from w_interf_conta_autor y
			where B.nr_interno_conta = y.nr_interno_conta)
 
union all

SELECT     	'ITEM DA CONTA         ' 	DS_REGISTRO,
           	3                        	TP_REGISTRO,
           	'CSMH'                  	IE_SERVICO,
           	2                        	CD_REGISTRO,
           	somente_numero(coalesce(x.cd_interno,0))	CD_ORIGEM,
           	c.NR_SEQ_PROTOCOLO      	NR_LOTE,
           	c.NR_INTERNO_CONTA      	NR_INTERNO_CONTA,
           	max(c.NR_SEQ_ITEM)         	NR_PARCELA,
           	0                       	CD_CONVENIO,
           	' '                       	NM_CONVENIO,
           	' '                       	TP_PRESTADOR,
           	' '                       	CD_PRESTADOR,
           	' '                       	NM_PRESTADOR,
           	LOCALTIMESTAMP                 	DT_GERACAO,
           	1                        	NR_REMESSA,
           	0                       	CD_PLANO,
           	' '                       	CD_PACIENTE,
           	' '                       	CD_AUTORIZACAO,
           	0                        	CD_ACOMODACAO,
           	LOCALTIMESTAMP                 	DT_ENTRADA,
           	LOCALTIMESTAMP                 	DT_SAIDA,
           	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
           	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
           	0                        	IE_TIPO_ATENDIMENTO,
           	null                     	CD_CID,
           	0                        	CD_PROC_PRINCIPAL,
		' '				CD_MEDICO_CONVENIO,
           	' '                       	NR_CRM,
           	' '                       	UF_CRM,
		' '				NR_CRM_REQ,
		' '				UF_CRM_REQ,
           	max(c.NR_SEQ_ITEM)         	NR_SEQ_ITEM,
           	c.CD_ITEM_CONVENIO		CD_ITEM,
           	substr(upper(c.DS_ITEM),1,50)
						NM_ITEM,
           	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END 
						IE_EMERGENCIA,
           	CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END 
                       			IE_EXTRA,
           	TRUNC(W.DT_PERIODO_INICIAL,'dd')  	DT_ITEM,
           	c.CD_FUNCAO_EXECUTOR       	IE_FUNCAO_MEDICO,
           	SUM(c.QT_ITEM)             	QT_ITEM,
           	SUM(coalesce(c.vl_honorario,0) + coalesce(c.vl_custo_oper,0))
						VL_ITEM,
           	0                        	IE_CIRURGIA_MULTIPLA,
           	0		      		VL_TOTAL_ITEM,
           	0	      			QT_ITEM_CONTA,
	     	substr(UPPER(W.NM_PACIENTE),1,40) NM_PACIENTE,
           	' '	      			NR_FATURA,
           	0				QT_CONTA,
          	0				VL_TOTAL_LOTE,
	     	c.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		' '				DS_ESPACO,
           	1                        	NR_REGISTRO,
		' '				CD_CGC_PRESTADOR,
		0				CD_MOTIVO_ALTA,
		' '				IE_LAUDO_ESPECIAL,
		' '				IE_LAUDO_PRORROGACAO,
		LOCALTIMESTAMP			dt_autorizacao,
		LOCALTIMESTAMP			dt_validade_carteirinha,
		0				nr_prontuario,
		' '				nm_medico_resp,
		' '				ie_tipo_doc_paciente,
		' '				nr_doc_paciente,
		' '				ie_matmed,
		somente_numero(c.nr_crm_executor)
						nr_crm_resp,
		c.uf_crm_executor		uf_crm_resp,
		c.nr_cpf_executor		nr_cpf_resp,
		substr(c.nr_doc_convenio,1,10)	cd_senha,
		c.cd_especialidade		cd_especialidade,
		0				vl_proc_principal,
		CASE WHEN c.pr_via_acesso=100 THEN 1 WHEN c.pr_via_acesso=70 THEN 2  ELSE 3 END 
						ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		w.ie_tipo_atendimento	ie_tipo_atend_tasy,
		coalesce(somente_numero(x.nr_protocolo),0)
						cd_interno_protocolo,
		coalesce(somente_numero(c.nr_doc_convenio),0)
						nr_guia,
		w.cd_senha_guia		cd_senha_guia,
		0				tp_internacao,
		'Un'				cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM w_interf_conta_header x, w_interf_conta_cab w, w_interf_conta_item c
LEFT OUTER JOIN regra_honorario z ON (c.ie_responsavel_credito = Z.cd_regra)
WHERE c.NR_INTERNO_CONTA = W.NR_INTERNO_CONTA and w.nr_seq_protocolo = x.nr_seq_protocolo  and c.ie_tipo_item	= 1 and c.qt_item		<> 0 and c.vl_honorario 		<> 0 and coalesce(Z.ie_entra_conta,'S') = 'S' AND c.cd_item in (select x.cd_procedimento
		from estrutura_procedimento_v x
		where (x.cd_area_procedimento in (1,4,11,13) or x.cd_especialidade in (23000007,15000001))) GROUP BY	somente_numero(coalesce(x.cd_interno,0)),
		c.NR_SEQ_PROTOCOLO,
           		c.NR_INTERNO_CONTA,
           		c.CD_ITEM_CONVENIO,
           		substr(upper(c.DS_ITEM),1,50),
           		CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END ,
           		CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END ,
           		TRUNC(W.DT_PERIODO_INICIAL,'dd'),
           		c.CD_FUNCAO_EXECUTOR,
	     		W.NM_PACIENTE,
           		c.NR_SEQ_PROTOCOLO,
		somente_numero(c.nr_crm_executor),
		c.uf_crm_executor,
		substr(c.nr_doc_convenio,1,10),
		c.cd_especialidade,
		CASE WHEN c.pr_via_acesso=100 THEN 1 WHEN c.pr_via_acesso=70 THEN 2  ELSE 3 END ,
		w.ie_tipo_atendimento,
		c.nr_cpf_executor,
		coalesce(somente_numero(x.nr_protocolo),0),
		coalesce(somente_numero(c.nr_doc_convenio),0),
		w.cd_senha_guia
having		SUM(c.QT_ITEM) <> 0

union all

SELECT     	'ITEM DA CONTA         ' 	DS_REGISTRO,
           	3                        	TP_REGISTRO,
           	'CSMH'                  	IE_SERVICO,
           	2                        	CD_REGISTRO,
           	somente_numero(coalesce(x.cd_interno,0))	CD_ORIGEM,
           	c.NR_SEQ_PROTOCOLO      	NR_LOTE,
           	c.NR_INTERNO_CONTA      	NR_INTERNO_CONTA,
           	max(c.NR_SEQ_ITEM)         	NR_PARCELA,
           	0                       	CD_CONVENIO,
           	' '                       	NM_CONVENIO,
           	' '                       	TP_PRESTADOR,
           	' '                       	CD_PRESTADOR,
           	' '                       	NM_PRESTADOR,
           	LOCALTIMESTAMP                 	DT_GERACAO,
           	1                        	NR_REMESSA,
           	0                       	CD_PLANO,
           	' '                       	CD_PACIENTE,
           	' '                       	CD_AUTORIZACAO,
           	0                        	CD_ACOMODACAO,
           	LOCALTIMESTAMP                 	DT_ENTRADA,
           	LOCALTIMESTAMP                 	DT_SAIDA,
           	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
           	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
           	0                        	IE_TIPO_ATENDIMENTO,
           	null                     	CD_CID,
           	0                        	CD_PROC_PRINCIPAL,
		' '				CD_MEDICO_CONVENIO,
           	' '                       	NR_CRM,
           	' '                       	UF_CRM,
		' '				NR_CRM_REQ,
		' '				UF_CRM_REQ,
           	max(c.NR_SEQ_ITEM)         	NR_SEQ_ITEM,
           	c.CD_ITEM_CONVENIO		CD_ITEM,
           	substr(upper(c.DS_ITEM),1,50)
						NM_ITEM,
           	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END 
						IE_EMERGENCIA,
           	CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END 
                       			IE_EXTRA,
           	TRUNC(W.DT_PERIODO_INICIAL,'dd')  	DT_ITEM,
           	c.CD_FUNCAO_EXECUTOR       	IE_FUNCAO_MEDICO,
           	SUM(c.QT_ITEM)             	QT_ITEM,
           	SUM(c.vl_total_item)       	VL_ITEM,
           	0                        	IE_CIRURGIA_MULTIPLA,
           	0		      		VL_TOTAL_ITEM,
           	0	      			QT_ITEM_CONTA,
	     	substr(UPPER(W.NM_PACIENTE),1,40) NM_PACIENTE,
           	' '	      			NR_FATURA,
           	0				QT_CONTA,
          	0				VL_TOTAL_LOTE,
	     	c.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		' '				DS_ESPACO,
           	1                        	NR_REGISTRO,
		' '				CD_CGC_PRESTADOR,
		0				CD_MOTIVO_ALTA,
		' '				IE_LAUDO_ESPECIAL,
		' '				IE_LAUDO_PRORROGACAO,
		LOCALTIMESTAMP			dt_autorizacao,
		LOCALTIMESTAMP			dt_validade_carteirinha,
		0				nr_prontuario,
		' '				nm_medico_resp,
		' '				ie_tipo_doc_paciente,
		' '				nr_doc_paciente,
		CASE WHEN c.cd_tipo_item_interf=4 THEN '1' WHEN c.cd_tipo_item_interf=5 THEN '2'  ELSE ' ' END 
						ie_matmed,
		0				nr_crm_resp,
		' '				uf_crm_resp,
		' '				nr_cpf_resp,
		substr(c.nr_doc_convenio,1,10)	cd_senha,
		c.cd_especialidade		cd_especialidade,
		0				vl_proc_principal,
		0				ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		w.ie_tipo_atendimento	ie_tipo_atend_tasy,
		coalesce(somente_numero(x.nr_protocolo),0)
						cd_interno_protocolo,
		coalesce(somente_numero(c.nr_doc_convenio),0)
						nr_guia,
		w.cd_senha_guia		cd_senha_guia,
		0				tp_internacao,
		CASE WHEN c.ie_tipo_item=1 THEN 'Un'  ELSE c.cd_unidade_medida END  cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM		w_interf_conta_header x,
		W_INTERF_CONTA_ITEM C,
		W_INTERF_CONTA_CAB W
WHERE       	c.NR_INTERNO_CONTA = W.NR_INTERNO_CONTA
and		w.nr_seq_protocolo = x.nr_seq_protocolo
and (c.ie_tipo_item	= 2 or (c.ie_tipo_item	= 1 and
		c.cd_item not in (select x.cd_procedimento
		from estrutura_procedimento_v x
		where (x.cd_area_procedimento in (1,4,11,13) or x.cd_especialidade in (23000007,15000001)))))
and		c.vl_total_item	<> 0
and		c.qt_item		<> 0
GROUP BY	somente_numero(coalesce(x.cd_interno,0)),
		c.NR_SEQ_PROTOCOLO,
           	c.NR_INTERNO_CONTA,
           	c.CD_ITEM_CONVENIO,
           	substr(upper(c.DS_ITEM),1,50),
           	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END ,
           	CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END ,
           	TRUNC(W.DT_PERIODO_INICIAL,'dd'),
           	c.CD_FUNCAO_EXECUTOR,
	     	W.NM_PACIENTE,
           	c.NR_SEQ_PROTOCOLO,
		CASE WHEN c.cd_tipo_item_interf=4 THEN '1' WHEN c.cd_tipo_item_interf=5 THEN '2'  ELSE ' ' END ,
		substr(c.nr_doc_convenio,1,10),
		c.cd_especialidade,
		w.ie_tipo_atendimento,
		coalesce(somente_numero(x.nr_protocolo),0),
		coalesce(somente_numero(c.nr_doc_convenio),0),
		w.cd_senha_guia,
		CASE WHEN c.ie_tipo_item=1 THEN 'Un'  ELSE c.cd_unidade_medida END 
having		SUM(c.QT_ITEM) <> 0

union all

SELECT     	'TOTAL DA CONTA        ' 	DS_REGISTRO,
           	4                        	TP_REGISTRO,
           	'CSMH'                  	IE_SERVICO,
           	3                        	CD_REGISTRO,
           	somente_numero(coalesce(y.cd_interno,0))	CD_ORIGEM,
           	B.NR_SEQ_PROTOCOLO      	NR_LOTE,
           	B.NR_INTERNO_CONTA      	NR_INTERNO_CONTA,
           	1                        	NR_PARCELA,
           	0                       	CD_CONVENIO,
           	' '                       	NM_CONVENIO,
           	' '                       	TP_PRESTADOR,
           	' '                       	CD_PRESTADOR,
           	' '                       	NM_PRESTADOR,
           	LOCALTIMESTAMP                 	DT_GERACAO,
           	1                        	NR_REMESSA,
           	0                       	CD_PLANO,
           	' '                       	CD_PACIENTE,
           	' '                       	CD_AUTORIZACAO,
           	0                        	CD_ACOMODACAO,
           	LOCALTIMESTAMP                 	DT_ENTRADA,
           	LOCALTIMESTAMP                 	DT_SAIDA,
           	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
           	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
           	0                        	IE_TIPO_ATENDIMENTO,
           	null                     	CD_CID,
           	0                        	CD_PROC_PRINCIPAL,
		' '				CD_MEDICO_CONVENIO,
           	' '                       	NR_CRM,
           	' '                       	UF_CRM,
		B.NR_CRM_MEDICO_RESP		NR_CRM_REQ,
		B.UF_CRM_MEDICO_RESP		UF_CRM_REQ,
           	1                        	NR_SEQ_ITEM,
           	' '				CD_ITEM,
           	' '                       	NM_ITEM,
           	' '     			IE_EMERGENCIA,
           	' '                       	IE_EXTRA,
           	LOCALTIMESTAMP			DT_ITEM,
           	0                        	IE_FUNCAO_MEDICO,
           	0				QT_ITEM,
           	0				VL_ITEM,
           	0				IE_CIRURGIA_MULTIPLA,
           	sum(CASE WHEN x.cd_area_procedimento=1 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=4 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=11 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=13 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE CASE WHEN x.cd_especialidade=15000001 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_especialidade=23000007 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE e.vl_total_item END  END ) VL_TOTAL_ITEM,
           	0			QT_ITEM_CONTA,
	     	substr(UPPER(B.NM_PACIENTE),1,40)
						NM_PACIENTE,
           	' '	      			NR_FATURA,
           	0				QT_CONTA,
           	0				VL_TOTAL_LOTE,
	     	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		' '				DS_ESPACO,
           	1                        	NR_REGISTRO,
		' '				CD_CGC_PRESTADOR,
		0				CD_MOTIVO_ALTA,
		' '				IE_LAUDO_ESPECIAL,
		' '				IE_LAUDO_PRORROGACAO,
		LOCALTIMESTAMP			dt_autorizacao,
		LOCALTIMESTAMP			dt_validade_carteirinha,
		0				nr_prontuario,
		' '				nm_medico_resp,
		' '				ie_tipo_doc_paciente,
		' '				nr_doc_paciente,
		' '				ie_matmed,
		0				nr_crm_resp,
		' '				uf_crm_resp,
		' '				nr_cpf_resp,
		' '				cd_senha,
		0				cd_especialidade,
		0				vl_proc_principal,
		0				ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		B.ie_tipo_atendimento	ie_tipo_atend_tasy,
		coalesce(somente_numero(y.nr_protocolo),0)
						cd_interno_protocolo,
		coalesce(somente_numero(B.nr_doc_convenio),0)
						nr_guia,
		B.cd_senha_guia		cd_senha_guia,
		0				tp_internacao,
		' '				cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM w_interf_conta_header y, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = x.CD_PROCEDIMENTO AND E.IE_ORIGEM_PROCED = x.IE_ORIGEM_PROCED)
LEFT OUTER JOIN regra_honorario z ON (E.IE_RESPONSAVEL_CREDITO = Z.cd_regra)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA and B.nr_seq_protocolo	= y.nr_seq_protocolo    and coalesce(Z.ie_entra_conta,'S') = 'S' GROUP BY	somente_numero(coalesce(y.cd_interno,0)),
		B.NR_SEQ_PROTOCOLO,
           	B.NR_INTERNO_CONTA,
		substr(UPPER(B.NM_PACIENTE),1,40),
		B.NR_CRM_MEDICO_RESP,
		B.UF_CRM_MEDICO_RESP,
		B.ie_tipo_atendimento,
		coalesce(somente_numero(y.nr_protocolo),0),
		coalesce(somente_numero(B.nr_doc_convenio),0),
		B.cd_senha_guia

union all

SELECT     	'FIM DE LOTE           ' 	DS_REGISTRO,
           	5                        	TP_REGISTRO,
           	'CSMH'                  	IE_SERVICO,
           	4                        	CD_REGISTRO,
           	somente_numero(coalesce(y.cd_interno,0))	CD_ORIGEM,
           	B.NR_SEQ_PROTOCOLO      	NR_LOTE,
           	99999999	      		NR_INTERNO_CONTA,
           	99                       	NR_PARCELA,
           	0                       	CD_CONVENIO,
           	' '                       	NM_CONVENIO,
           	' '                        	TP_PRESTADOR,
           	' '                       	CD_PRESTADOR,
           	' '                       	NM_PRESTADOR,
           	LOCALTIMESTAMP                 	DT_GERACAO,
           	1                        	NR_REMESSA,
           	0                       	CD_PLANO,
           	' '                       	CD_PACIENTE,
           	' '                       	CD_AUTORIZACAO,
           	0                        	CD_ACOMODACAO,
           	LOCALTIMESTAMP                 	DT_ENTRADA,
           	LOCALTIMESTAMP                 	DT_SAIDA,
           	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
           	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
           	0                        	IE_TIPO_ATENDIMENTO,
           	null                     	CD_CID,
           	0                        	CD_PROC_PRINCIPAL,
		' '				CD_MEDICO_CONVENIO,
           	' '                       	NR_CRM,
           	' '                       	UF_CRM,
		' '				NR_CRM_REQ,
		' '				UF_CRM_REQ,
           	1                        	NR_SEQ_ITEM,
           	' '				CD_ITEM,
           	' '                        	NM_ITEM,
           	' '     			IE_EMERGENCIA,
           	' '                       	IE_EXTRA,
           	LOCALTIMESTAMP			DT_ITEM,
           	0                        	IE_FUNCAO_MEDICO,
           	0				QT_ITEM,
           	0				VL_ITEM,
           	0				IE_CIRURGIA_MULTIPLA,
           	0		      		VL_TOTAL_ITEM,
           	0	      			QT_ITEM_CONTA,
	     	' '				NM_PACIENTE,
           	' '	      			NR_FATURA,
           	count(distinct e.nr_interno_conta) QT_CONTA,
           	sum(CASE WHEN x.cd_area_procedimento=1 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=4 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=11 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=13 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE CASE WHEN x.cd_especialidade=15000001 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_especialidade=23000007 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE e.vl_total_item END  END ) VL_TOTAL_ITEM,
	     	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		' '				DS_ESPACO,
           	1                        	NR_REGISTRO,
		' '				CD_CGC_PRESTADOR,
		0				CD_MOTIVO_ALTA,
		' '				IE_LAUDO_ESPECIAL,
		' '				IE_LAUDO_PRORROGACAO,
		LOCALTIMESTAMP			dt_autorizacao,
		LOCALTIMESTAMP			dt_validade_carteirinha,
		0				nr_prontuario,
		' '				nm_medico_resp,
		' '				ie_tipo_doc_paciente,
		' '				nr_doc_paciente,
		' '				ie_matmed,
		0				nr_crm_resp,
		' '				uf_crm_resp,
		' '				nr_cpf_resp,
		' '				cd_senha,
		0				cd_especialidade,
		0				vl_proc_principal,
		0				ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		0				ie_tipo_atend_tasy,
		coalesce(somente_numero(y.nr_protocolo),0)
						cd_interno_protocolo,
		0				nr_guia,
		' '				cd_senha_guia,
		0				tp_internacao,
		' '				cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM w_interf_conta_header y, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = x.CD_PROCEDIMENTO AND E.IE_ORIGEM_PROCED = x.IE_ORIGEM_PROCED)
LEFT OUTER JOIN regra_honorario z ON (e.ie_responsavel_credito = Z.cd_regra)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA and B.nr_seq_protocolo	= y.nr_seq_protocolo    and coalesce(Z.ie_entra_conta,'S') = 'S' GROUP BY	somente_numero(coalesce(y.cd_interno,0)),
		B.NR_SEQ_PROTOCOLO,
		coalesce(somente_numero(y.nr_protocolo),0)

union all

SELECT     	'TRAILLER              ' 	DS_REGISTRO,
           	6                        	TP_REGISTRO,
           	'CSMH'                  	IE_SERVICO,
           	9                        	CD_REGISTRO,
           	somente_numero(coalesce(y.cd_interno,0))	CD_ORIGEM,
           	99999999	      		NR_LOTE,
           	99999999	      		NR_INTERNO_CONTA,
           	99                       	NR_PARCELA,
           	0                       	CD_CONVENIO,
           	' '                       	NM_CONVENIO,
           	' '                       	TP_PRESTADOR,
           	' '                       	CD_PRESTADOR,
           	' '                       	NM_PRESTADOR,
           	LOCALTIMESTAMP                 	DT_GERACAO,
           	1                        	NR_REMESSA,
           	0                       	CD_PLANO,
           	' '                       	CD_PACIENTE,
           	' '                       	CD_AUTORIZACAO,
           	0                        	CD_ACOMODACAO,
           	LOCALTIMESTAMP                 	DT_ENTRADA,
           	LOCALTIMESTAMP                 	DT_SAIDA,
           	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
           	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
           	0                        	IE_TIPO_ATENDIMENTO,
           	null                     	CD_CID,
           	0                         	CD_PROC_PRINCIPAL,
		' '				CD_MEDICO_CONVENIO,
           	' '                       	NR_CRM,
           	' '                       	UF_CRM,
	     	' '				NR_CRM_REQ,
		' '				UF_CRM_REQ,
           	1                        	NR_SEQ_ITEM,
           	' '				CD_ITEM,
           	' '                       	NM_ITEM,
           	' '     			IE_EMERGENCIA,
           	' '                       	IE_EXTRA,
           	LOCALTIMESTAMP			DT_ITEM,
           	0                        	IE_FUNCAO_MEDICO,
           	0				QT_ITEM,
           	0				VL_ITEM,
           	0				IE_CIRURGIA_MULTIPLA,
           	0		      		VL_TOTAL_ITEM,
           	0	      			QT_ITEM_CONTA,
	     	' '				NM_PACIENTE,
           	' '	      			NR_FATURA,
           	count(distinct e.nr_interno_conta) QT_CONTA,
           	sum(CASE WHEN x.cd_area_procedimento=1 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=4 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=11 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=13 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE CASE WHEN x.cd_especialidade=15000001 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_especialidade=23000007 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE e.vl_total_item END  END ) VL_TOTAL_ITEM,
	     	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
		' '				DS_ESPACO,
           	1                        	NR_REGISTRO,
		' '				CD_CGC_PRESTADOR,
		0				CD_MOTIVO_ALTA,
		' '				IE_LAUDO_ESPECIAL,
		' '				IE_LAUDO_PRORROGACAO,
		LOCALTIMESTAMP			dt_autorizacao,
		LOCALTIMESTAMP			dt_validade_carteirinha,
		0				nr_prontuario,
		' '				nm_medico_resp,
		' '				ie_tipo_doc_paciente,
		' '				nr_doc_paciente,
		' '				ie_matmed,
		0				nr_crm_resp,
		' '				uf_crm_resp,
		' '				nr_cpf_resp,
		' '				cd_senha,
		0				cd_especialidade,
		0				vl_proc_principal,
		0				ie_tipo_cirurgia,
		0				cd_unidade_atend,
		0				qt_diaria_enfermaria,
		0				qt_diaria_uti,
		0				cd_leitora,
		'F'				ie_fim_registro,
		9				ie_tipo_atend_tasy,
		coalesce(somente_numero(y.nr_protocolo),0)
						cd_interno_protocolo,
		0				nr_guia,
		' '				cd_senha_guia,
		0				tp_internacao,
		' '				cd_unidade_medida,
		'0'				ie_tipo_faturamento,
		'N'				ie_folha_sala
FROM w_interf_conta_header y, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = x.CD_PROCEDIMENTO AND E.IE_ORIGEM_PROCED = x.IE_ORIGEM_PROCED)
LEFT OUTER JOIN regra_honorario z ON (E.IE_RESPONSAVEL_CREDITO = Z.cd_regra)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA and B.nr_seq_protocolo	= y.nr_seq_protocolo    and coalesce(Z.ie_entra_conta,'S') = 'S' GROUP BY	somente_numero(coalesce(y.cd_interno,0)),
		B.NR_SEQ_PROTOCOLO,
		coalesce(somente_numero(y.nr_protocolo),0);

