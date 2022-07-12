-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hlc_copimef_v (ds_registro, tp_registro, ie_servico, cd_registro, cd_origem, nr_lote, nr_interno_conta, nr_parcela, cd_convenio, nm_convenio, tp_prestador, cd_prestador, nm_prestador, dt_geracao, nr_remessa, cd_plano, cd_paciente, cd_autorizacao, cd_acomodacao, dt_entrada, dt_saida, dt_inicio_cobranca, dt_fim_cobranca, ie_tipo_atendimento, cd_cid, cd_proc_principal, cd_medico_convenio, nr_crm, uf_crm, nr_crm_req, uf_crm_req, nr_seq_item, cd_item, nm_item, ie_emergencia, ie_extra, dt_item, ie_funcao_medico, qt_item, vl_item, ie_cirurgia_multipla, vl_total_item, qt_item_conta, nm_paciente, nr_fatura, qt_conta, vl_total_lote, nr_seq_protocolo, ds_espaco, nr_registro, ie_matmed, ds_ma_me_tx, ie_tipo_atend_tasy, cd_motivo_alta, dt_mesano_referencia, cd_cgc_prestador) AS SELECT	'HEADER               ' 	DS_REGISTRO,
	1				TP_REGISTRO,
	'CSMH'				IE_SERVICO,
	0				CD_REGISTRO,
	(coalesce(A.CD_INTERNO,0))::numeric 	CD_ORIGEM,
	0				NR_LOTE,
	NR_INTERNO_CONTA,
	0				NR_PARCELA,
	SOMENTE_NUMERO(coalesce(A.CD_REGIONAL,0)) CD_CONVENIO,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(A.NM_CONVENIO)),1,30) NM_CONVENIO,
	'J'				TP_PRESTADOR,
	A.CD_CGC_HOSPITAL		CD_PRESTADOR,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(A.NM_HOSPITAL)),1,40) NM_PRESTADOR,
	A.DT_REMESSA			DT_GERACAO,
	A.NR_REMESSA			NR_REMESSA,
	' '				CD_PLANO,
	' '				CD_PACIENTE,
	' '				CD_AUTORIZACAO,
	0				CD_ACOMODACAO,
	LOCALTIMESTAMP				DT_ENTRADA,
	LOCALTIMESTAMP				DT_SAIDA,
	LOCALTIMESTAMP				DT_INICIO_COBRANCA,
	LOCALTIMESTAMP				DT_FIM_COBRANCA,
	0				IE_TIPO_ATENDIMENTO,
	NULL				CD_CID,
	' '				CD_PROC_PRINCIPAL,
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
	LOCALTIMESTAMP				DT_ITEM,
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
	'                   '		DS_ESPACO,
	1				NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	0				IE_TIPO_ATEND_TASY,
	0 CD_MOTIVO_ALTA,
	C.dt_mesano_referencia,
	'00192087000146' cd_cgc_prestador
FROM	W_INTERF_CONTA_HEADER A,
	CONTA_PACIENTE C
WHERE	C.NR_SEQ_PROTOCOLO = A.NR_SEQ_PROTOCOLO
and 	exists (select 	1
		FROM	W_INTERF_CONTA_ITEM q,
			W_INTERF_CONTA_CAB r,
			conta_paciente t
		WHERE   q.NR_INTERNO_CONTA	= r.NR_INTERNO_CONTA
		and 	q.nr_interno_conta	= t.nr_interno_conta
		and 	t.nr_interno_conta	= C.nr_interno_conta
		AND	q.IE_TIPO_ITEM	= 1
		AND	q.CD_ITEM IN (	SELECT	X.CD_PROCEDIMENTO
					FROM	ESTRUTURA_PROCEDIMENTO_V X
					WHERE	X.CD_AREA_PROCEDIMENTO IN (1,4,13)))

UNION

SELECT	'CABECALHO CONTA      '		DS_REGISTRO,
	2				TP_REGISTRO,
	'CSMH'				IE_SERVICO,
	1				CD_REGISTRO,
	0				CD_ORIGEM,
	B.NR_SEQ_PROTOCOLO		NR_LOTE,
	B.NR_INTERNO_CONTA		NR_INTERNO_CONTA,
	B.IE_TIPO_ATENDIMENTO		NR_PARCELA,
	0				CD_CONVENIO,
	' '				NM_CONVENIO,
	'J'				TP_PRESTADOR,
	' '				CD_PRESTADOR,
	' '				NM_PRESTADOR,
	LOCALTIMESTAMP				DT_GERACAO,
	1				NR_REMESSA,
	substr(B.CD_PLANO_CONVENIO,1,3)	CD_PLANO,
	SUBSTR(B.CD_USUARIO_CONVENIO,1,18) CD_PACIENTE,
	SUBSTR(B.NR_DOC_CONVENIO,1,10)	CD_AUTORIZACAO,
	B.CD_TIPO_ACOMODACAO		CD_ACOMODACAO,
	B.DT_ENTRADA			DT_ENTRADA,
	coalesce(B.DT_ALTA,B.DT_PERIODO_FINAL) DT_SAIDA,
	B.DT_PERIODO_INICIAL		DT_INICIO_COBRANCA,
	coalesce(B.DT_ALTA,B.DT_PERIODO_FINAL) DT_FIM_COBRANCA,
	B.IE_TIPO_ATENDIMENTO		IE_TIPO_ATENDIMENTO,
	B.CD_CID_PRINCIPAL		CD_CID,
	B.CD_PROC_PRINCIPAL		CD_PROC_PRINCIPAL,
	B.CD_CONV_MEDICO_RESP 		CD_MEDICO_CONVENIO,
	substr(B.NR_CRM_MEDICO_RESP,1,6) NR_CRM,
	B.UF_CRM_MEDICO_RESP		UF_CRM,
	B.NR_CRM_MEDICO_RESP		NR_CRM_REQ,
	B.UF_CRM_MEDICO_RESP		UF_CRM_REQ,
	1				NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '				NM_ITEM,
	' '				IE_EMERGENCIA,
	' '				IE_EXTRA,
	LOCALTIMESTAMP				DT_ITEM,
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
	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1				NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	B.IE_TIPO_ATENDIMENTO		IE_TIPO_ATEND_TASY,
	B.CD_MOTIVO_ALTA,
	C.dt_mesano_referencia,
	'00192087000146' cd_cgc_prestador
FROM	W_INTERF_CONTA_CAB B,
	conta_paciente c
where	C.nr_interno_conta	= b.nr_interno_conta
and 	exists (select 	1
		FROM	W_INTERF_CONTA_ITEM q,
			W_INTERF_CONTA_CAB r,
			conta_paciente t
		WHERE   q.NR_INTERNO_CONTA	= r.NR_INTERNO_CONTA
		and 	q.nr_interno_conta	= t.nr_interno_conta
		and 	t.nr_interno_conta	= C.nr_interno_conta
		AND	q.IE_TIPO_ITEM	= 1
		AND	q.CD_ITEM IN (	SELECT	X.CD_PROCEDIMENTO
					FROM	ESTRUTURA_PROCEDIMENTO_V X
					WHERE	X.CD_AREA_PROCEDIMENTO IN (1,4,13)))

UNION

SELECT 	'ITEM DA CONTA         ' 	DS_REGISTRO,
	3                        	TP_REGISTRO,
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
	SUBSTR(C.NR_DOC_CONVENIO,1,10)	CD_AUTORIZACAO,
	0                        	CD_ACOMODACAO,
	LOCALTIMESTAMP                 	DT_ENTRADA,
	LOCALTIMESTAMP                 	DT_SAIDA,
	LOCALTIMESTAMP                 	DT_INICIO_COBRANCA,
	LOCALTIMESTAMP                 	DT_FIM_COBRANCA,
	0                        	IE_TIPO_ATENDIMENTO,
	NULL                     	CD_CID,
	' '                        	CD_PROC_PRINCIPAL,
	W.CD_CONV_MEDICO_RESP		CD_MEDICO_CONVENIO,
	substr(W.NR_CRM_MEDICO_RESP,1,6) NR_CRM,
	W.UF_CRM_MEDICO_RESP		UF_CRM,
	W.NR_CRM_MEDICO_RESP		NR_CRM_REQ,
	W.UF_CRM_MEDICO_RESP		UF_CRM_REQ,
	MAX(C.NR_SEQ_ITEM)           	NR_SEQ_ITEM,
	C.CD_ITEM_CONVENIO		CD_ITEM,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(C.DS_ITEM)),1,42)NM_ITEM,
	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END  IE_EMERGENCIA,
	CASE WHEN C.PR_HORA_EXTRA=0 THEN 'N' WHEN C.PR_HORA_EXTRA=1 THEN 'N' WHEN C.PR_HORA_EXTRA IS NULL THEN 'N'  ELSE 'S' END  IE_EXTRA,
	TRUNC(W.DT_ENTRADA,'dd') 	DT_ITEM,
	somente_numero(substr(C.CD_FUNCAO_EXECUTOR,1,1)) IE_FUNCAO_MEDICO,
	SUM(C.QT_ITEM)               	QT_ITEM,
	SUM(coalesce(C.VL_HONORARIO,0) + coalesce(C.VL_CUSTO_OPER,0)) VL_ITEM,
	0                        	IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(W.NM_PACIENTE)),1,40)	NM_PACIENTE,
	' '	      			NR_FATURA,
	0				QT_CONTA,
	0				VL_TOTAL_LOTE,
	C.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	W.IE_TIPO_ATENDIMENTO		IE_TIPO_ATEND_TASY,
	0 CD_MOTIVO_ALTA,
	d.dt_mesano_referencia,
	C.cd_cgc_prestador
FROM	W_INTERF_CONTA_ITEM C,
	W_INTERF_CONTA_CAB W,
	conta_paciente d
WHERE   C.NR_INTERNO_CONTA	= W.NR_INTERNO_CONTA
and	d.nr_interno_conta	= C.NR_INTERNO_CONTA
AND	C.IE_TIPO_ITEM	= 1
AND	C.CD_ITEM IN (	SELECT	X.CD_PROCEDIMENTO
			FROM	ESTRUTURA_PROCEDIMENTO_V X
			WHERE	X.CD_AREA_PROCEDIMENTO IN (1,4,13))
GROUP	BY C.NR_SEQ_PROTOCOLO,
	C.NR_INTERNO_CONTA,
	C.CD_ITEM_CONVENIO,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(C.DS_ITEM)),1,42),
	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END ,
	CASE WHEN C.PR_HORA_EXTRA=0 THEN 'N' WHEN C.PR_HORA_EXTRA=1 THEN 'N' WHEN C.PR_HORA_EXTRA IS NULL THEN 'N'  ELSE 'S' END ,
	TRUNC(W.DT_ENTRADA,'dd'),
	somente_numero(substr(C.CD_FUNCAO_EXECUTOR,1,1)),
	C.NR_SEQ_PROTOCOLO,
	W.IE_TIPO_ATENDIMENTO,
	SUBSTR(C.NR_DOC_CONVENIO,1,10),
	W.CD_CONV_MEDICO_RESP,
	substr(W.NR_CRM_MEDICO_RESP,1,6),
	W.UF_CRM_MEDICO_RESP,
	W.NR_CRM_MEDICO_RESP,
	W.UF_CRM_MEDICO_RESP,
	d.dt_mesano_referencia,
	C.cd_cgc_prestador,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(W.NM_PACIENTE)),1,40)

UNION

SELECT	'TOTAL DA CONTA        ' 	DS_REGISTRO,
	4                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	3                        	CD_REGISTRO,
	0	            		CD_ORIGEM,
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
	' '                        	CD_PROC_PRINCIPAL,
	' '					CD_MEDICO_CONVENIO,
	' '                       	NR_CRM,
	' '                       	UF_CRM,
	' '				NR_CRM_REQ,
	' '				UF_CRM_REQ,
	1                        	NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '                       	NM_ITEM,
	' '     			IE_EMERGENCIA,
	' '                       	IE_EXTRA,
	LOCALTIMESTAMP				DT_ITEM,
	0                        	IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0				IE_CIRURGIA_MULTIPLA,
	SUM( CASE WHEN X.CD_AREA_PROCEDIMENTO=13 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=1 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=4 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE E.VL_TOTAL_ITEM END  END  END ) VL_TOTAL_LOTE,
	0				QT_ITEM_CONTA,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(B.NM_PACIENTE)),1,40)
	NM_PACIENTE,
	' '	      			NR_FATURA,
	0				QT_CONTA,
	0				VL_TOTAL_LOTE,
	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	B.IE_TIPO_ATENDIMENTO		IE_TIPO_ATEND_TASY,
	0 CD_MOTIVO_ALTA,
	d.dt_mesano_referencia,
	'00192087000146' cd_cgc_prestador
FROM conta_paciente d, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = X.CD_PROCEDIMENTO)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA and d.nr_interno_conta	= e.NR_INTERNO_CONTA  AND X.CD_AREA_PROCEDIMENTO IN (1,4,13)
GROUP	BY B.NR_SEQ_PROTOCOLO,
	B.NR_INTERNO_CONTA,
	SUBSTR(ELIMINA_ACENTUACAO(UPPER(B.NM_PACIENTE)),1,40),
	B.IE_TIPO_ATENDIMENTO,
	d.dt_mesano_referencia

UNION

SELECT	'FIM DE LOTE           ' 	DS_REGISTRO,
	5                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	4                        	CD_REGISTRO,
	0	            		CD_ORIGEM,
	B.NR_SEQ_PROTOCOLO      	NR_LOTE,
	E.NR_INTERNO_CONTA,
	99                       	NR_PARCELA,
	0                       	CD_CONVENIO,
	' '                       	NM_CONVENIO,
	' '                        	TP_PRESTADOR,
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
	' '                        	CD_PROC_PRINCIPAL,
	' '					CD_MEDICO_CONVENIO,
	' '                       	NR_CRM,
	' '                       	UF_CRM,
	' '				NR_CRM_REQ,
	' '				UF_CRM_REQ,
	1                        	NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '                        	NM_ITEM,
	' '     			IE_EMERGENCIA,
	' '                       	IE_EXTRA,
	LOCALTIMESTAMP				DT_ITEM,
	0                        	IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0				IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	' '				NM_PACIENTE,
	' '	      			NR_FATURA,
	COUNT(DISTINCT E.NR_INTERNO_CONTA) QT_CONTA,
	SUM( CASE WHEN X.CD_AREA_PROCEDIMENTO=13 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=1 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=4 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE E.VL_TOTAL_ITEM END  END  END ) VL_TOTAL_LOTE,
	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	0				IE_TIPO_ATEND_TASY,
	0 CD_MOTIVO_ALTA,
	d.dt_mesano_referencia,
	'00192087000146' cd_cgc_prestador
FROM conta_paciente d, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = X.CD_PROCEDIMENTO)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA and d.nr_interno_conta	= e.NR_INTERNO_CONTA  AND X.CD_AREA_PROCEDIMENTO IN (1,4,13)
GROUP	BY B.NR_SEQ_PROTOCOLO,
	E.NR_INTERNO_CONTA,
	d.dt_mesano_referencia
 
UNION

SELECT	'TRAILLER              ' 	DS_REGISTRO,
	6                        	TP_REGISTRO,
	'CSMH'                  	IE_SERVICO,
	9                        	CD_REGISTRO,
	(coalesce(F.CD_INTERNO,0))::numeric 
	CD_ORIGEM,
	99999999	      		NR_LOTE,
	E.NR_INTERNO_CONTA,
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
	' '                         	CD_PROC_PRINCIPAL,
	' '					CD_MEDICO_CONVENIO,
	' '                       	NR_CRM,
	' '                       	UF_CRM,
	' '				NR_CRM_REQ,
	' '				UF_CRM_REQ,
	1                        	NR_SEQ_ITEM,
	' '				CD_ITEM,
	' '                       	NM_ITEM,
	' '     			IE_EMERGENCIA,
	' '                       	IE_EXTRA,
	LOCALTIMESTAMP				DT_ITEM,
	0                        	IE_FUNCAO_MEDICO,
	0				QT_ITEM,
	0				VL_ITEM,
	0				IE_CIRURGIA_MULTIPLA,
	0		      		VL_TOTAL_ITEM,
	0	      			QT_ITEM_CONTA,
	' '				NM_PACIENTE,
	' '	      			NR_FATURA,
	COUNT(DISTINCT E.NR_INTERNO_CONTA) QT_CONTA,
	SUM( CASE WHEN X.CD_AREA_PROCEDIMENTO=13 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=1 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE CASE WHEN X.CD_AREA_PROCEDIMENTO=4 THEN (coalesce(E.VL_HONORARIO,0) + coalesce(E.VL_CUSTO_OPER,0))  ELSE E.VL_TOTAL_ITEM END  END  END ) VL_TOTAL_LOTE,
	B.NR_SEQ_PROTOCOLO		NR_SEQ_PROTOCOLO,
	' '				DS_ESPACO,
	1                        	NR_REGISTRO,
	' '				IE_MATMED,
	' '				DS_MA_ME_TX,
	9				IE_TIPO_ATEND_TASY,
	0 CD_MOTIVO_ALTA,
	d.dt_mesano_referencia,
	'00192087000146' cd_cgc_prestador
FROM	ESTRUTURA_PROCEDIMENTO_V X,
	W_INTERF_CONTA_HEADER F,
	W_INTERF_CONTA_CAB B,
	W_INTERF_CONTA_ITEM E,
	conta_paciente d
WHERE	B.NR_INTERNO_CONTA 	     = E.NR_INTERNO_CONTA
and	d.nr_interno_conta		= e.NR_INTERNO_CONTA
AND	B.NR_SEQ_PROTOCOLO	     = F.NR_SEQ_PROTOCOLO
AND	E.CD_ITEM		         = X.CD_PROCEDIMENTO
AND	E.IE_TIPO_ITEM	         = 1
AND	X.CD_AREA_PROCEDIMENTO IN (1,4,13)
GROUP	BY (coalesce(F.CD_INTERNO,0))::numeric ,
	B.NR_SEQ_PROTOCOLO,
	E.NR_INTERNO_CONTA,
	d.dt_mesano_referencia;
