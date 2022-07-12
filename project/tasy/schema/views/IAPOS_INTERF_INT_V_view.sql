-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW iapos_interf_int_v (tp_registro, nr_interno_conta_cab, dt_periodo_inicial, cd_usuario_convenio, cd_tipo_documento, nr_documento, nm_paciente, cd_tipo_guia, cd_senha_guia, dt_autorizacao, nr_profissional_servico, nm_profissional_servico, cd_cid_principal, ds_observacao, dt_entrada, dt_alta, ds_blanco_cab, nr_interno_conta_det, cd_medico_executor, nm_medico_executor, cd_tipo_nomenclador, cd_item, ds_item, dt_item, qt_item, vl_total_conta, cd_faturacion, tx_item, ds_blanco_det, nr_seq_protocolo, nr_interno_conta) AS SELECT	1 TP_REGISTRO,
        LPAD(A.NR_INTERNO_CONTA, 7, 0) NR_INTERNO_CONTA_CAB,
        A.DT_PERIODO_INICIAL,
        LPAD(A.CD_USUARIO_CONVENIO, 15, 0) CD_USUARIO_CONVENIO,
        'DNI' CD_TIPO_DOCUMENTO,
        LPAD(A.NR_IDENTIDADE, 9, 0) NR_DOCUMENTO,
        RPAD(A.NM_PACIENTE, 30, ' ') NM_PACIENTE,
        RPAD('', 2, ' ') CD_TIPO_GUIA,
        LPAD(
            coalesce(( SELECT MAX(QT_BONUS_APRES)
                FROM PROCEDIMENTO_AUTORIZADO x
                where x.NR_SEQUENCIA_AUTOR = b.NR_SEQ_AUTORIZACAO
                and x.CD_PROCEDIMENTO = b.cd_procedimento_solic),0),
        7,0) CD_SENHA_GUIA,
        B.DT_AUTORIZACAO,
        LPAD(B.NR_CRM_SOLICITANTE, 7, 0) NR_PROFISSIONAL_SERVICO,
        RPAD(B.NM_MEDICO_SOLICITANTE, 30, ' ') NM_PROFISSIONAL_SERVICO,
        RPAD(A.CD_CID_PRINCIPAL, 30, ' ') CD_CID_PRINCIPAL,
        RPAD(A.DS_OBSERVACAO, 30, ' ') DS_OBSERVACAO,
        A.DT_ENTRADA,
        A.DT_ALTA,
        RPAD('', 8, ' ') DS_BLANCO_CAB,
		LPAD(0, 7, 0) NR_INTERNO_CONTA_DET,
		'' CD_MEDICO_EXECUTOR,
		'' NM_MEDICO_EXECUTOR,
		'' CD_TIPO_NOMENCLADOR,
		LPAD(0, 7, 0) CD_ITEM,
		'' DS_ITEM,
		null DT_ITEM,
		LPAD(0, 5, 0) QT_ITEM,
		LPAD(0, 15, 0) VL_TOTAL_CONTA,
		'' CD_FATURACION,
		LPAD(0, 3, 0) TX_ITEM,
		'' DS_BLANCO_DET,
		A.NR_SEQ_PROTOCOLO,
    	A.NR_INTERNO_CONTA
FROM 	W_INTERF_CONTA_CAB A,
		W_INTERF_CONTA_AUTOR B
WHERE 	A.NR_INTERNO_CONTA	= B.NR_INTERNO_CONTA
AND     coalesce(B.NR_SEQUENCIA,0) =
        (SELECT coalesce(MAX(Y.NR_SEQUENCIA),0)
        FROM W_INTERF_CONTA_AUTOR Y 
        WHERE A.NR_INTERNO_CONTA = Y.NR_INTERNO_CONTA)

UNION ALL

SELECT	2 TP_REGISTRO,
		LPAD(0, 7, 0) NR_INTERNO_CONTA_CAB,
		null DT_PERIODO_INICIAL,
		'' CD_USUARIO_CONVENIO,
		'' CD_TIPO_DOCUMENTO,
		LPAD(0, 9, 0) NR_DOCUMENTO,
		'' NM_PACIENTE,
		'' CD_TIPO_GUIA,
		'' CD_SENHA_GUIA,
		null DT_AUTORIZACAO,
		'' NR_PROFISSIONAL_SERVICO,
		'' NM_PROFISSIONAL_SERVICO,
		'' CD_CID_PRINCIPAL,
		'' DS_OBSERVACAO,
		null DT_ENTRADA,
		null DT_ALTA,
		'' DS_BLANCO_CAB,
        LPAD(A.NR_INTERNO_CONTA, 7, 0) NR_INTERNO_CONTA_DET,
        LPAD(coalesce(B.NR_CRM_EXECUTOR, 0), 7, 0) CD_MEDICO_EXECUTOR,
        RPAD(B.NM_MEDICO_EXECUTOR, 30, ' ') NM_MEDICO_EXECUTOR,
        RPAD(CASE WHEN B.CD_AREA_PROC=1 THEN  'N'  ELSE 'G' END , 1, ' ') CD_TIPO_NOMENCLADOR,
        LPAD(B.CD_ITEM, 7, 0) CD_ITEM,
        RPAD(B.DS_ITEM, 30, ' ') DS_ITEM,
        B.DT_ITEM,
        LPAD(B.QT_ITEM, 5, 0) QT_ITEM,
        LPAD(C.VL_TOTAL_CONTA, 15, 0) VL_TOTAL_CONTA,
        RPAD('', 1, ' ') CD_FATURACION,
        LPAD(B.PR_FATURADO, 3, 0) TX_ITEM,
        RPAD('', 6, ' ') DS_BLANCO_DET,
		A.NR_SEQ_PROTOCOLO,
    	A.NR_INTERNO_CONTA
FROM 	W_INTERF_CONTA_CAB A,
		W_INTERF_CONTA_ITEM B,
		W_INTERF_CONTA_TOTAL C
WHERE 	A.NR_INTERNO_CONTA	= B.NR_INTERNO_CONTA
AND 	A.NR_INTERNO_CONTA	= C.NR_INTERNO_CONTA;
