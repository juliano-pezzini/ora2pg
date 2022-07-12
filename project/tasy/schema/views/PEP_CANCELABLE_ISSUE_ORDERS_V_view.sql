-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pep_cancelable_issue_orders_v (nr_seq_evento, nr_seq_protocolo, nr_seq_gqa_acao, table_name, nr_atendimento, nr_seq_pendencia, nr_seq_pend_regra, cd_doenca, dt_diagnostico, nr_seq_prescricao, nr_prescricao, nr_seq_prescr_diag, nr_seq_cpoe, ie_tipo_item, nr_seq_pe_prescr_proc, ds_issue_type) AS SELECT
	D.NR_SEQUENCIA NR_SEQ_EVENTO,
	F.NR_SEQ_PROTOCOLO_INT_PAC NR_SEQ_PROTOCOLO,
	E.NR_SEQUENCIA NR_SEQ_GQA_ACAO,
	A.TABLE_NAME,
	C.NR_ATENDIMENTO,
	G.NR_SEQ_PENDENCIA,
	G.NR_SEQUENCIA NR_SEQ_PEND_REGRA,
	A.CD_DOENCA,
	A.DT_DIAGNOSTICO,
	A.NR_SEQ_PRESCRICAO,
	A.NR_PRESCRICAO,
	null NR_SEQ_PRESCR_DIAG,
	null NR_SEQ_CPOE,
	null IE_TIPO_ITEM,
	null NR_SEQ_PE_PRESCR_PROC,
	'ORDER_NOT_EXECUTED' DS_ISSUE_TYPE
FROM (
	SELECT 'DIAGNOSTICO_DOENCA' TABLE_NAME, 
		NR_SEQ_PEND_PAC_ACAO, 
		null nr_prescricao, 
		null nr_seq_prescricao, 
		cd_doenca, 
		dt_diagnostico 
	FROM 	DIAGNOSTICO_DOENCA WHERE DT_LIBERACAO IS NULL AND DT_INATIVACAO IS NULL  
UNION ALL

	SELECT 'PE_PRESCRICAO'      TABLE_NAME, 
		NR_SEQ_PEND_PAC_ACAO, 
		null nr_prescricao, 
		nr_sequencia nr_seq_prescricao, 
		null cd_doenca, 
		null dt_diagnostico 
	FROM 	PE_PRESCRICAO      WHERE DT_LIBERACAO IS NULL AND IE_SITUACAO <> 'I'  
UNION ALL

	SELECT 'PRESCR_MEDICA'      TABLE_NAME, 
		NR_SEQ_PEND_PAC_ACAO, 
		nr_prescricao, 
		null nr_seq_prescricao, 
		null cd_doenca, 
		null dt_diagnostico 
	FROM 	PRESCR_MEDICA      WHERE DT_LIBERACAO IS NULL AND DT_SUSPENSAO IS NULL
	)			 A,
	GQA_PEND_PAC_ACAO        B,
	GQA_PENDENCIA_PAC        C,
	PROTOCOLO_INT_PAC_EVENTO D,
	GQA_ACAO                 E,
	PROTOCOLO_INT_PAC_ETAPA  F,
	GQA_PENDENCIA_REGRA      G
WHERE B.NR_SEQUENCIA                 = A.NR_SEQ_PEND_PAC_ACAO
 AND B.NR_SEQ_PEND_PAC               = C.NR_SEQUENCIA
 AND C.NR_SEQ_PROTOCOLO_INT_PAC_EVEN = D.NR_SEQUENCIA
 AND B.NR_SEQ_REGRA_ACAO             = E.NR_SEQUENCIA
 AND D.nr_seq_prt_int_pac_etapa      = F.NR_SEQUENCIA
 AND G.nr_sequencia                  = E.NR_SEQ_PEND_REGRA


UNION

SELECT 
	D.NR_SEQUENCIA NR_SEQ_EVENTO,
	F.NR_SEQ_PROTOCOLO_INT_PAC NR_SEQ_PROTOCOLO,
	E.NR_SEQUENCIA NR_SEQ_GQA_ACAO,
	null TABLE_NAME,
	A.NR_ATENDIMENTO,
	null NR_SEQ_PENDENCIA,
	null NR_SEQ_PEND_REGRA,
	null CD_DOENCA,
	null DT_DIAGNOSTICO,
	null NR_SEQ_PRESCRICAO,
	null NR_PRESCRICAO,
	null NR_SEQ_PRESCR_DIAG,
	A.NR_SEQUENCIA NR_SEQ_CPOE,
	A.IE_TIPO_ITEM,
	null NR_SEQ_PE_PRESCR_PROC,
	'CPOE_ORDER_NOT_EXECUTED' DS_ISSUE_TYPE
FROM 	OBTER_CPOE_PEND_GQA_V 	 A,
	GQA_PEND_PAC_ACAO        B,
	GQA_PENDENCIA_PAC        C,
	PROTOCOLO_INT_PAC_EVENTO D,
	GQA_ACAO                 E,
	PROTOCOLO_INT_PAC_ETAPA  F
WHERE B.NR_SEQUENCIA                 = A.NR_SEQ_PEND_PAC_ACAO
 AND B.NR_SEQ_PEND_PAC               = C.NR_SEQUENCIA
 AND C.NR_SEQ_PROTOCOLO_INT_PAC_EVEN = D.NR_SEQUENCIA
 AND B.NR_SEQ_REGRA_ACAO             = E.NR_SEQUENCIA
 AND D.nr_seq_prt_int_pac_etapa      = F.NR_SEQUENCIA
 AND cpoe_obter_dt_lib_suspensao(A.NR_SEQUENCIA, A.IE_TIPO_ITEM) is null


UNION

SELECT 
	D.NR_SEQUENCIA NR_SEQ_EVENTO,
	F.NR_SEQ_PROTOCOLO_INT_PAC NR_SEQ_PROTOCOLO,
	E.NR_SEQUENCIA NR_SEQ_GQA_ACAO,
	null TABLE_NAME,
	AC.NR_ATENDIMENTO,
	null NR_SEQ_PENDENCIA,
	null NR_SEQ_PEND_REGRA,
	null CD_DOENCA,
	null DT_DIAGNOSTICO,
	null NR_SEQ_PRESCRICAO,
	null NR_PRESCRICAO,
	null NR_SEQ_PRESCR_DIAG,
	AC.NR_SEQUENCIA NR_SEQ_CPOE,
	AC.IE_TIPO_ITEM,
	AB.NR_SEQUENCIA NR_SEQ_PE_PRESCR_PROC,
	'CARE_PLAN_WITH_CPOE_NOT_EXECUTED' DS_ISSUE_TYPE
FROM 	PE_PRESCRICAO            AA,
	PE_PRESCR_PROC           AB,
	OBTER_CPOE_PEND_GQA_V    AC,           
	GQA_PEND_PAC_ACAO        B,
	GQA_PENDENCIA_PAC        C,
	PROTOCOLO_INT_PAC_EVENTO D,
	GQA_ACAO                 E,
	PROTOCOLO_INT_PAC_ETAPA  F
WHERE AA.NR_SEQUENCIA 	             = AB.NR_SEQ_PRESCR
 AND AB.NR_SEQ_CPOE_INTERV           = AC.NR_SEQUENCIA
 AND AC.IE_TIPO_ITEM                 = 'I'
 AND trunc(LOCALTIMESTAMP,'dd') BETWEEN trunc(AA.DT_INICIO_PRESCR,'dd') AND trunc(AA.DT_VALIDADE_PRESCR,'dd')
 AND B.NR_SEQUENCIA                  = AA.NR_SEQ_PEND_PAC_ACAO
 AND B.NR_SEQ_PEND_PAC               = C.NR_SEQUENCIA
 AND C.NR_SEQ_PROTOCOLO_INT_PAC_EVEN = D.NR_SEQUENCIA
 AND B.NR_SEQ_REGRA_ACAO             = E.NR_SEQUENCIA
 AND D.NR_SEQ_PRT_INT_PAC_ETAPA      = F.NR_SEQUENCIA
 AND cpoe_obter_dt_lib_suspensao(AC.NR_SEQUENCIA, AC.IE_TIPO_ITEM) is null


UNION

SELECT 
	D.NR_SEQUENCIA NR_SEQ_EVENTO,
	G.NR_SEQ_PROTOCOLO_INT_PAC NR_SEQ_PROTOCOLO,
	E.NR_SEQUENCIA NR_SEQ_GQA_ACAO,
	null TABLE_NAME,
	null NR_ATENDIMENTO,
	null NR_SEQ_PENDENCIA,
	null NR_SEQ_PEND_REGRA,
	null CD_DOENCA,
	null DT_DIAGNOSTICO,
	null NR_SEQ_PRESCRICAO,
	null NR_PRESCRICAO,
	F.NR_SEQUENCIA NR_SEQ_PRESCR_DIAG,
	null NR_SEQ_CPOE,
	null IE_TIPO_ITEM,
	null NR_SEQ_PE_PRESCR_PROC,
	'ACTIVE_CARE_PLAN_DIAGNOSES' DS_ISSUE_TYPE
FROM 	PE_PRESCRICAO            A,                     
	GQA_PEND_PAC_ACAO        B,
	GQA_PENDENCIA_PAC        C,
	PROTOCOLO_INT_PAC_EVENTO D,
	GQA_ACAO                 E,
	PE_PRESCR_DIAG           F,
	PROTOCOLO_INT_PAC_ETAPA  G
WHERE B.NR_SEQUENCIA                = A.NR_SEQ_PEND_PAC_ACAO
AND B.NR_SEQ_PEND_PAC               = C.NR_SEQUENCIA
AND C.NR_SEQ_PROTOCOLO_INT_PAC_EVEN = D.NR_SEQUENCIA
AND B.NR_SEQ_REGRA_ACAO             = E.NR_SEQUENCIA
AND A.NR_SEQUENCIA                  = F.NR_SEQ_PRESCR
AND A.IE_SITUACAO                   = 'A'
AND F.DT_CANCELAMENTO               IS NULL
AND D.nr_seq_prt_int_pac_etapa      = G.NR_SEQUENCIA

UNION

SELECT 
	D.NR_SEQUENCIA NR_SEQ_EVENTO,
	F.NR_SEQ_PROTOCOLO_INT_PAC NR_SEQ_PROTOCOLO,
	E.NR_SEQUENCIA NR_SEQ_GQA_ACAO,
	null TABLE_NAME,
	null NR_ATENDIMENTO,
	null NR_SEQ_PENDENCIA,
	null NR_SEQ_PEND_REGRA,
	null CD_DOENCA,
	null DT_DIAGNOSTICO,
	A.NR_SEQUENCIA NR_SEQ_PRESCRICAO,
	null NR_PRESCRICAO,
	null NR_SEQ_PRESCR_DIAG,
	null NR_SEQ_CPOE,
	null IE_TIPO_ITEM,
	null NR_SEQ_PE_PRESCR_PROC,
	'ACTIVE_CARE_PLANS' DS_ISSUE_TYPE
FROM 	PE_PRESCRICAO            A,                     
	GQA_PEND_PAC_ACAO        B,
	GQA_PENDENCIA_PAC        C,
	PROTOCOLO_INT_PAC_EVENTO D,
	GQA_ACAO                 E,
	PROTOCOLO_INT_PAC_ETAPA  F
WHERE B.NR_SEQUENCIA                = A.NR_SEQ_PEND_PAC_ACAO
AND B.NR_SEQ_PEND_PAC               = C.NR_SEQUENCIA
AND C.NR_SEQ_PROTOCOLO_INT_PAC_EVEN = D.NR_SEQUENCIA
AND B.NR_SEQ_REGRA_ACAO             = E.NR_SEQUENCIA
AND A.IE_SITUACAO                   = 'A'
AND D.nr_seq_prt_int_pac_etapa      = F.NR_SEQUENCIA;
