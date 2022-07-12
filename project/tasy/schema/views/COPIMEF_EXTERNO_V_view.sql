-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW copimef_externo_v (ds_registro, tp_registro, ie_servico, cd_registro, cd_origem, nr_lote, nr_interno_conta, nr_parcela, cd_convenio, nm_convenio, tp_prestador, cd_prestador, nm_prestador, dt_geracao, nr_remessa, cd_plano, cd_paciente, cd_autorizacao, cd_acomodacao, dt_entrada, dt_saida, dt_inicio_cobranca, dt_fim_cobranca, ie_tipo_atendimento, cd_cid, cd_proc_principal, cd_medico_convenio, nr_crm, uf_crm, nr_crm_req, uf_crm_req, nr_seq_item, cd_item, nm_item, ie_emergencia, ie_extra, dt_item, ie_funcao_medico, qt_item, vl_item, ie_cirurgia_multipla, vl_total_item, qt_item_conta, nm_paciente, nr_fatura, qt_conta, vl_total_lote, nr_seq_protocolo, ds_espaco, nr_registro, ie_matmed, ds_ma_me_tx, ie_tipo_atend_tasy, cd_motivo_alta, dt_mesano_referencia, cd_cgc_prestador) AS SELECT	DISTINCT
	'HEADER		' 	DS_REGISTRO,
	0                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	0                        	CD_REGISTRO,
	0				CD_ORIGEM,
	0				NR_LOTE,
	0			      	NR_INTERNO_CONTA,
	0		           	NR_PARCELA,
	0				CD_CONVENIO,
	'COPIMEF'			NM_CONVENIO,
	'J'				TP_PRESTADOR,
	'00192087000146'		CD_PRESTADOR,
	' '				NM_PRESTADOR,
	LOCALTIMESTAMP			DT_GERACAO,
	1				NR_REMESSA,
	' '                       	CD_PLANO,
	' '                       	CD_PACIENTE,
	' '				CD_AUTORIZACAO,
	0                        	CD_ACOMODACAO,
	LOCALTIMESTAMP                 	DT_ENTRADA,
	LOCALTIMESTAMP                 	DT_SAIDA,
	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
	0                        	IE_TIPO_ATENDIMENTO,
	NULL                     	CD_CID,
	' '                        	CD_PROC_PRINCIPAL,
	' '				CD_MEDICO_CONVENIO,
	' '				NR_CRM,
	' '				UF_CRM,
	' '				NR_CRM_REQ,
	' '				UF_CRM_REQ,
	0		           	NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '				NM_ITEM,
	' '				IE_EMERGENCIA,
	' '				IE_EXTRA,
	LOCALTIMESTAMP			DT_ITEM,
	'0'				IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0                        	IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	' '				NM_PACIENTE,
	' '	      			NR_FATURA,
	0				QT_CONTA,
	0				VL_TOTAL_LOTE,
	0				NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	0				IE_TIPO_ATEND_TASY,
	0 				CD_MOTIVO_ALTA,
	NULL				DT_MESANO_REFERENCIA,
	'00192087000146'		CD_CGC_PRESTADOR


UNION ALL

SELECT	DISTINCT
	'CABECALHO	         ' 	DS_REGISTRO,
	1                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	1                        	CD_REGISTRO,
	0				CD_ORIGEM,
	0				NR_LOTE,
	0			      	NR_INTERNO_CONTA,
	0		           	NR_PARCELA,
	0				CD_CONVENIO,
	' '				NM_CONVENIO,
	' '				TP_PRESTADOR,
	' '				CD_PRESTADOR,
	' '				NM_PRESTADOR,
	LOCALTIMESTAMP			DT_GERACAO,
	1				NR_REMESSA,
	' '				CD_PLANO,
	' '				CD_PACIENTE,
	' '				CD_AUTORIZACAO,
	0				CD_ACOMODACAO,
	LOCALTIMESTAMP			DT_ENTRADA,
	LOCALTIMESTAMP			DT_SAIDA,
	LOCALTIMESTAMP			DT_INICIO_COBRANCA,
	LOCALTIMESTAMP			DT_FIM_COBRANCA,
	0				IE_TIPO_ATENDIMENTO,
	NULL				CD_CID,
	' '				CD_PROC_PRINCIPAL,
	' '				CD_MEDICO_CONVENIO,
	' '				NR_CRM,
	' '				UF_CRM,
	' '				NR_CRM_REQ,
	' '				UF_CRM_REQ,
	0		           	NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '				NM_ITEM,
	' '				IE_EMERGENCIA,
	' '				IE_EXTRA,
	LOCALTIMESTAMP			DT_ITEM,
	'0'				IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0                        	IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	' '				NM_PACIENTE,
	' '	      			NR_FATURA,
	0				QT_CONTA,
	0				VL_TOTAL_LOTE,
	0				NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	0				IE_TIPO_ATEND_TASY,
	0				CD_MOTIVO_ALTA,
	NULL				DT_MESANO_REFERENCIA,
	'00192087000146'		CD_CGC_PRESTADOR


UNION ALL

SELECT 'ITEM DA CONTA         ' 	DS_REGISTRO,
	2                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	2                        	CD_REGISTRO,
	0				CD_ORIGEM,
	C.NR_SEQ_PROTOCOLO      	NR_LOTE,
	C.NR_INTERNO_CONTA      	NR_INTERNO_CONTA,
	0		           	NR_PARCELA,
	0                       	CD_CONVENIO,
	' '                       	NM_CONVENIO,
	' '                       	TP_PRESTADOR,
	' '               		CD_PRESTADOR,
	' '                		NM_PRESTADOR,
	LOCALTIMESTAMP                 	DT_GERACAO,
	1                        	NR_REMESSA,
	' '                       	CD_PLANO,
	' '                       	CD_PACIENTE,
	' '				CD_AUTORIZACAO,
	0                        	CD_ACOMODACAO,
	LOCALTIMESTAMP                 	DT_ENTRADA,
	LOCALTIMESTAMP                 	DT_SAIDA,
	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
	0                        	IE_TIPO_ATENDIMENTO,
	W.CD_CID_PRINCIPAL		CD_CID,
	' '                        	CD_PROC_PRINCIPAL,
	' '				CD_MEDICO_CONVENIO,
	' '				NR_CRM,
	' '				UF_CRM,
	SUBSTR(W.NR_CRM_MEDICO_RESP,1,6)NR_CRM_REQ,
	W.UF_CRM_MEDICO_RESP		UF_CRM_REQ,
	MAX(C.NR_SEQ_ITEM)		NR_SEQ_ITEM,
	C.CD_ITEM_CONVENIO		CD_ITEM,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(C.DS_ITEM)),1,42)NM_ITEM,
	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END  IE_EMERGENCIA,
	CASE WHEN C.PR_HORA_EXTRA=0 THEN 'N' WHEN C.PR_HORA_EXTRA=1 THEN 'N' WHEN C.PR_HORA_EXTRA IS NULL THEN 'N'  ELSE 'S' END  IE_EXTRA,
	TRUNC(W.DT_ENTRADA,'dd') 	DT_ITEM,
	SUBSTR(C.CD_FUNCAO_EXECUTOR,1,1)IE_FUNCAO_MEDICO,
	SUM(C.QT_ITEM)              QT_ITEM,
	SUM(coalesce(C.VL_HONORARIO,0) + coalesce(C.VL_CUSTO_OPER,0)) VL_ITEM,
	0                        	IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(W.NM_PACIENTE)),1,40) NM_PACIENTE,
	' '	      			NR_FATURA,
	0				QT_CONTA,
	0				VL_TOTAL_LOTE,
	C.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	W.IE_TIPO_ATENDIMENTO	IE_TIPO_ATEND_TASY,
	0				CD_MOTIVO_ALTA,
	D.DT_MESANO_REFERENCIA	DT_MESANO_REFERENCIA,
	C.CD_CGC_PRESTADOR		CD_CGC_PRESTADOR
FROM	W_INTERF_CONTA_ITEM C,
	W_INTERF_CONTA_CAB W,
	CONTA_PACIENTE D
WHERE   C.NR_INTERNO_CONTA	= W.NR_INTERNO_CONTA
and	D.NR_INTERNO_CONTA	= C.NR_INTERNO_CONTA
AND	C.IE_TIPO_ITEM		= 1
AND	C.CD_ITEM IN (	SELECT	X.CD_PROCEDIMENTO
			FROM	ESTRUTURA_PROCEDIMENTO_V X
			WHERE	X.CD_AREA_PROCEDIMENTO IN (1,4,13))
GROUP	BY C.NR_SEQ_PROTOCOLO,
	C.NR_INTERNO_CONTA,
	C.CD_ITEM_CONVENIO,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(C.DS_ITEM)),1,42),
	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END ,
	CASE WHEN C.PR_HORA_EXTRA=0 THEN 'N' WHEN C.PR_HORA_EXTRA=1 THEN 'N' WHEN C.PR_HORA_EXTRA IS NULL THEN 'N'  ELSE 'S' END ,
	TRUNC(W.DT_ENTRADA,'DD'),
	SUBSTR(C.CD_FUNCAO_EXECUTOR,1,1),
	C.NR_SEQ_PROTOCOLO,
	W.IE_TIPO_ATENDIMENTO,
	W.CD_CID_PRINCIPAL,
	SUBSTR(C.NR_DOC_CONVENIO,1,10),
	W.CD_CONV_MEDICO_RESP,
	W.NR_CRM_MEDICO_RESP,
	W.UF_CRM_MEDICO_RESP,
	W.NR_CRM_MEDICO_RESP,
	W.UF_CRM_MEDICO_RESP,
	D.DT_MESANO_REFERENCIA,
	C.CD_CGC_PRESTADOR,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(W.NM_PACIENTE)),1,40)

UNION ALL

SELECT	DISTINCT
	'TOTAL DA CONTA	         ' 	DS_REGISTRO,
	3                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	3                        	CD_REGISTRO,
	0				CD_ORIGEM,
	9999999			NR_LOTE,
	9999999			NR_INTERNO_CONTA,
	0		           	NR_PARCELA,
	0				CD_CONVENIO,
	' '				NM_CONVENIO,
	' '				TP_PRESTADOR,
	' '				CD_PRESTADOR,
	' '				NM_PRESTADOR,
	LOCALTIMESTAMP			DT_GERACAO,
	1				NR_REMESSA,
	' '                       	CD_PLANO,
	' '                       	CD_PACIENTE,
	' '				CD_AUTORIZACAO,
	0                        	CD_ACOMODACAO,
	LOCALTIMESTAMP                 	DT_ENTRADA,
	LOCALTIMESTAMP                 	DT_SAIDA,
	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
	0                        	IE_TIPO_ATENDIMENTO,
	NULL                     	CD_CID,
	' '                        	CD_PROC_PRINCIPAL,
	' '				CD_MEDICO_CONVENIO,
	' '				NR_CRM,
	' '				UF_CRM,
	' '				NR_CRM_REQ,
	' '				UF_CRM_REQ,
	0		           	NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '				NM_ITEM,
	' '				IE_EMERGENCIA,
	' '				IE_EXTRA,
	LOCALTIMESTAMP			DT_ITEM,
	'0'				IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0                        	IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	' '				NM_PACIENTE,
	' '	      			NR_FATURA,
	0				QT_CONTA,
	0				VL_TOTAL_LOTE,
	0				NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	0				IE_TIPO_ATEND_TASY,
	0 				CD_MOTIVO_ALTA,
	NULL				DT_MESANO_REFERENCIA,
	'00192087000146'		CD_CGC_PRESTADOR


UNION ALL

SELECT	'TRAILLER              ' 	DS_REGISTRO,
	9                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	9                        	CD_REGISTRO,
	00000				CD_ORIGEM,
	99999999	      		NR_LOTE,
	99999999			NR_INTERNO_CONTA,
	99                       	NR_PARCELA,
	0                       	CD_CONVENIO,
	' '                       	NM_CONVENIO,
	' '                       	TP_PRESTADOR,
	' '                       	CD_PRESTADOR,
	' '                       	NM_PRESTADOR,
	LOCALTIMESTAMP                 	DT_GERACAO,
	1                        	NR_REMESSA,
	' '                       	CD_PLANO,
	' '                       	CD_PACIENTE,
	' '                       	CD_AUTORIZACAO,
	0                        	CD_ACOMODACAO,
	LOCALTIMESTAMP                 	DT_ENTRADA,
	LOCALTIMESTAMP                 	DT_SAIDA,
	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
	0                        	IE_TIPO_ATENDIMENTO,
	NULL                     	CD_CID,
	' '                         CD_PROC_PRINCIPAL,
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
	'0'                        	IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0				IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	' '				NM_PACIENTE,
	' '	      			NR_FATURA,
	COUNT(DISTINCT E.NR_INTERNO_CONTA) QT_CONTA,
	SUM( CASE WHEN X.CD_AREA_PROCEDIMENTO=13 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=1 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=4 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE E.VL_TOTAL_ITEM END  END  END ) VL_TOTAL_LOTE,
	0				NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	9				IE_TIPO_ATEND_TASY,
	0 				CD_MOTIVO_ALTA,
	NULL				DT_MESANO_REFERENCIA,
	'00192087000146'		CD_CGC_PRESTADOR
FROM	ESTRUTURA_PROCEDIMENTO_V X,
	W_INTERF_CONTA_ITEM E
WHERE	E.CD_ITEM			= X.CD_PROCEDIMENTO
AND	E.IE_TIPO_ITEM		= 1
AND	X.CD_AREA_PROCEDIMENTO IN (1,4,13)
ORDER BY NR_INTERNO_CONTA, TP_REGISTRO, CD_ITEM;
