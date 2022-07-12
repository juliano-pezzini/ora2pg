-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW amecro_interf_v (tp_registro, cd_prestador_ci, cd_convenio_ci, cd_subconvenio_ci, nr_protocolo_ca, nr_interno_conta_ci, nr_internacao_ci, cd_usuario_convenio_ci, nm_paciente_ci, cd_tipo_documento_ci, nr_documento_ci, dt_entrada, dt_alta, nr_guia_ci, vl_total_conta, ie_medicamento, ie_material, cd_proc_principal, cd_tipo_nomenclador_ci, cd_cid_principal, ie_carater_inter_ci, ds_libres_ci, cd_prestador_di, cd_convenio_di, cd_subconvenio_di, nr_internacao_di, dt_item_di, cd_item_di, cd_tipo_nomenclador_di, ds_item_di, qt_item_di, nr_medico_executor_di, nm_medico_executor_di, vl_honorarios_di, vl_sadt_di, cd_tipo_honorario_di, tx_faturado_honorario_di, tx_faturado_gasto_di, ie_carater_inter_di, ds_libres_di, cd_prestador_da, cd_convenio_da, cd_subconvenio_da, nr_protocolo_da, nr_interno_conta_da, cd_usuario_convenio_da, nm_paciente_da, cd_tipo_documento_da, nr_documento_da, nr_guia_da, dt_item_da, cd_item_da, cd_tipo_nomenclador_da, ds_item_da, qt_item_da, nr_medico_executor_da, nm_medico_executor_da, vl_honorarios_da, vl_sadt_da, cd_tipo_honorario_da, tx_faturado_honorario_da, tx_faturado_gasto_da, ie_carater_inter_da, ds_libres_da, nr_seq_protocolo, nr_interno_conta, dt_periodo_inicial, nr_atendimento) AS SELECT  1 TP_REGISTRO,
        LPAD(coalesce(SUBSTR(A.CD_INTERNO, 1, 3),0), 3, 0) CD_PRESTADOR_CI,
        LPAD(SUBSTR(B.CD_INTERNO, 1, 2),2, 0) CD_CONVENIO_CI,
        LPAD(b.CD_REGIONAL, 2, 0) CD_SUBCONVENIO_CI,
        LPAD(coalesce((      select  substr(x.NR_NFE_IMP,length(x.NR_NFE_IMP)-7, length(x.NR_NFE_IMP))
                        FROM    nota_fiscal x
                        where   x.nr_seq_protocolo = a.nr_seq_protocolo  LIMIT 1), 'FFFFFFFF'), 8, 0) NR_PROTOCOLO_CA,
        LPAD(A.NR_INTERNO_CONTA, 7, 0) NR_INTERNO_CONTA_CI,
        LPAD(COALESCE(A.NR_ATENDIMENTO,0), 8, 0) NR_INTERNACAO_CI,
        LPAD(A.CD_USUARIO_CONVENIO, 14, 0) CD_USUARIO_CONVENIO_CI,
        RPAD(A.NM_PACIENTE, 30, ' ') NM_PACIENTE_CI,
        4 CD_TIPO_DOCUMENTO_CI,
        LPAD(A.NR_IDENTIDADE, 8, 0) NR_DOCUMENTO_CI,
        A.DT_ENTRADA,
        A.DT_ALTA,
	LPAD(max((select max(y.cd_senha) from W_INTERF_CONTA_AUTOR y
		  where y.cd_convenio = D.cd_convenio
		  and y.nr_atendimento = A.nr_atendimento
		  and y.nr_interno_conta = a.nr_interno_conta
		  and y.ie_origem_guia = 'U')), 7, 0) NR_GUIA_CI,
        LPAD(SUM(C.VL_TOTAL_CONTA), 13, 0) VL_TOTAL_CONTA,
        LPAD(SUM(
                CASE
                WHEN D.IE_TIPO_ITEM=2 AND CD_TIPO_ITEM_INTERF<>1 THEN D.VL_TOTAL_ITEM
                ELSE 0
                END), 13, 0) IE_MEDICAMENTO,
        LPAD(SUM(
                CASE
                WHEN D.IE_TIPO_ITEM=2 AND CD_TIPO_ITEM_INTERF=1 THEN D.VL_TOTAL_ITEM
                ELSE 0
                END), 13, 0) IE_MATERIAL,
        LPAD(A.CD_PROC_PRINCIPAL, 7, 0) CD_PROC_PRINCIPAL,
        RPAD(CASE WHEN D.IE_ORIGEM_PROCED IS NULL THEN                 obter_tipo_nomenclador_regra( D.cd_convenio,                  D.CD_ITEM,                  null,                  null)  ELSE obter_tipo_nomenclador_regra( D.cd_convenio,                  null,                  D.CD_ITEM,                  D.IE_ORIGEM_PROCED) END , 1, ' ') CD_TIPO_NOMENCLADOR_CI,
        RPAD(A.CD_CID_PRINCIPAL, 30, ' ') CD_CID_PRINCIPAL,
        coalesce(CASE WHEN A.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END , 'N') IE_CARATER_INTER_CI,
        RPAD('', 8, ' ') DS_LIBRES_CI,
        '' CD_PRESTADOR_DI,
        '' CD_CONVENIO_DI,
        '' CD_SUBCONVENIO_DI,
        '' NR_INTERNACAO_DI,
        NULL DT_ITEM_DI,
        LPAD(0, 7, 0) CD_ITEM_DI,
        '' CD_TIPO_NOMENCLADOR_DI,
        '' DS_ITEM_DI,
        LPAD(0, 5, 0) QT_ITEM_DI,
        '' NR_MEDICO_EXECUTOR_DI,
        '' NM_MEDICO_EXECUTOR_DI,
        LPAD(0, 13, 0) VL_HONORARIOS_DI,
        LPAD(0, 13, 0) VL_SADT_DI,
        '' CD_TIPO_HONORARIO_DI,
        LPAD(0, 3, 0) TX_FATURADO_HONORARIO_DI,
        LPAD(0, 3, 0) TX_FATURADO_GASTO_DI,
        '' IE_CARATER_INTER_DI,
        '' DS_LIBRES_DI,
        '' CD_PRESTADOR_DA,
        '' CD_CONVENIO_DA,
        '' CD_SUBCONVENIO_DA,
        '' NR_PROTOCOLO_DA,
        LPAD(0, 7, 0) NR_INTERNO_CONTA_DA,
        '' CD_USUARIO_CONVENIO_DA,
        '' NM_PACIENTE_DA,
        0 CD_TIPO_DOCUMENTO_DA,
        LPAD(0, 8, 0) NR_DOCUMENTO_DA,
        '' NR_GUIA_DA,
        NULL DT_ITEM_DA,
        LPAD(0, 7, 0) CD_ITEM_DA,
        '' CD_TIPO_NOMENCLADOR_DA,
        '' DS_ITEM_DA,
        LPAD(0, 5, 0) QT_ITEM_DA,
        '' NR_MEDICO_EXECUTOR_DA,
        '' NM_MEDICO_EXECUTOR_DA,
        LPAD(0, 13, 0) VL_HONORARIOS_DA,
        LPAD(0, 13, 0) VL_SADT_DA,
        '' CD_TIPO_HONORARIO_DA,
        LPAD(0, 3, 0) TX_FATURADO_HONORARIO_DA,
        LPAD(0, 3, 0) TX_FATURADO_GASTO_DA,
        '' IE_CARATER_INTER_DA,
        '' DS_LIBRES_DA,
        A.NR_SEQ_PROTOCOLO,
        A.NR_INTERNO_CONTA,
        A.DT_PERIODO_INICIAL,
        A.NR_ATENDIMENTO
FROM    W_INTERF_CONTA_CAB A,
        W_INTERF_CONTA_HEADER B,
        W_INTERF_CONTA_TOTAL C,
        W_INTERF_CONTA_ITEM D
WHERE   A.NR_SEQ_PROTOCOLO  = B.NR_SEQ_PROTOCOLO
AND     A.NR_INTERNO_CONTA  = C.NR_INTERNO_CONTA
AND     A.NR_INTERNO_CONTA  = D.NR_INTERNO_CONTA
GROUP BY    LPAD(A.NR_IDENTIDADE, 8, 0),LPAD(coalesce(SUBSTR(A.CD_INTERNO, 1, 3),0), 3, 0), SUBSTR(B.CD_INTERNO, 1, 2), LPAD(B.NR_SEQ_PROTOCOLO, 8, '0'),
            LPAD(b.CD_REGIONAL, 2, 0), A.NR_INTERNO_CONTA, A.NR_ATENDIMENTO, A.CD_USUARIO_CONVENIO,
            A.NM_PACIENTE, A.DT_ENTRADA, A.DT_ALTA, A.CD_SENHA_GUIA,
            A.CD_PROC_PRINCIPAL, RPAD(CASE WHEN D.IE_ORIGEM_PROCED IS NULL THEN                 obter_tipo_nomenclador_regra( D.cd_convenio,                  D.CD_ITEM,                  null,                  null)  ELSE obter_tipo_nomenclador_regra( D.cd_convenio,                  null,                  D.CD_ITEM,                  D.IE_ORIGEM_PROCED) END , 1, ' '), A.CD_CID_PRINCIPAL, 'N',
            A.IE_CARATER_INTER, A.NR_SEQ_PROTOCOLO, A.NR_INTERNO_CONTA,A.DT_PERIODO_INICIAL, 
            A.NR_ATENDIMENTO

UNION ALL

SELECT  2 TP_REGISTRO,
        '' CD_PRESTADOR_CI,
        '' CD_CONVENIO_CI,
        '' CD_SUBCONVENIO_CI,
        '' NR_PROTOCOLO_CA,
        LPAD(0, 7, 0) NR_INTERNO_CONTA_CI,
        '' NR_INTERNACAO_CI,
        '' CD_USUARIO_CONVENIO_CI,
        '' NM_PACIENTE_CI,
        0 CD_TIPO_DOCUMENTO_CI,
        LPAD(0, 8, 0) NR_DOCUMENTO_CI,
        NULL DT_ENTRADA,
        NULL DT_ALTA,
        '' NR_GUIA_CI,
        LPAD(0, 13, 0) VL_TOTAL_CONTA,
        LPAD(0, 13, 0) IE_MEDICAMENTO,
        LPAD(0, 13, 0) IE_MATERIAL,
        '' CD_PROC_PRINCIPAL,
        '' CD_TIPO_NOMENCLADOR_CI,
        '' CD_CID_PRINCIPAL,
        '' IE_CARATER_INTER_CI,
        '' DS_LIBRES_CI,
        LPAD(coalesce(SUBSTR(A.CD_INTERNO, 1, 3),0), 3, 0) CD_PRESTADOR_DI,
        LPAD(SUBSTR(B.CD_INTERNO, 0, 2), 2, 0) CD_CONVENIO_DI,
        LPAD(b.CD_REGIONAL, 2, 0) CD_SUBCONVENIO_DI,
    LPAD(COALESCE(D.NR_ATENDIMENTO,0), 8, 0) NR_INTERNACAO_DI,
        D.DT_ITEM DT_ITEM_DI,
        LPAD(D.CD_ITEM, 7, 0) CD_ITEM_DI,
        RPAD(CASE WHEN D.IE_ORIGEM_PROCED IS NULL THEN                 obter_tipo_nomenclador_regra( D.cd_convenio,                  D.CD_ITEM,                  null,                  null)  ELSE obter_tipo_nomenclador_regra( D.cd_convenio,                  null,                  D.CD_ITEM,                  D.IE_ORIGEM_PROCED) END , 1, ' ') CD_TIPO_NOMENCLADOR_DI,
        RPAD(D.DS_ITEM, 30, ' ') DS_ITEM_DI,
        LPAD(D.QT_ITEM, 5, 0) QT_ITEM_DI,
        LPAD(coalesce((select  x.cd_medico_req
                  from  procedimento_paciente x
                  where x.nr_interno_conta = D.nr_interno_conta
                        and x.nr_sequencia = D.nr_seq_item
                        and D.ie_tipo_item = 1), 0), 6, 0) NR_MEDICO_EXECUTOR_DI,
        RPAD(obter_nome_medico((select	x.cd_medico_req
		                from	procedimento_paciente x
                                where   x.nr_interno_conta = D.nr_interno_conta
                                        and x.nr_sequencia = D.nr_seq_item
                                        and D.ie_tipo_item = 1), 'N'), 30, ' ') NM_MEDICO_EXECUTOR_DI,
        LPAD(D.VL_HONORARIO, 13, 0) VL_HONORARIOS_DI,
        LPAD(D.VL_CUSTO_OPER, 13, 0) VL_SADT_DI,
    coalesce((select
    CASE
        WHEN IE_MEDICO='S' AND coalesce(IE_ANESTESISTA,'N')='N' AND coalesce(IE_AUXILIAR,'N')='N' THEN 'E'
        WHEN coalesce(IE_ANESTESISTA,'N')='S' THEN 'A'
        WHEN coalesce(IE_INSTRUMENTADOR ,'N')='S' THEN 'P'
        WHEN IE_MEDICO='S' AND coalesce(IE_AUXILIAR,'N')='S' AND substr(DS_FUNCAO,1,1)='P' THEN '1'
        WHEN IE_MEDICO='S' AND coalesce(IE_AUXILIAR,'N')='S' AND substr(DS_FUNCAO,1,1)='S' THEN '2'
        WHEN IE_MEDICO='S' AND coalesce(IE_AUXILIAR,'N')='S' AND substr(DS_FUNCAO,1,1)='T' THEN '3'
        ELSE ' '
    END DS
    from    funcao_medico x
    where   x.cd_funcao = d.CD_FUNCAO_EXECUTOR),' ') CD_TIPO_HONORARIO_DI,
        LPAD(D.PR_FATURADO, 3, 0) TX_FATURADO_HONORARIO_DI,
        LPAD(D.PR_FATURADO, 3, 0) TX_FATURADO_GASTO_DI,
        coalesce(( SELECT max(x.IE_URGENCIA)
                from PRESCR_PROCEDIMENTO x, PROCEDIMENTO_PACIENTE y
                where x.NR_SEQUENCIA = y.NR_SEQUENCIA_PRESCRICAO
                and x.NR_PRESCRICAO = y.NR_PRESCRICAO
                and y.NR_SEQUENCIA = d.NR_SEQUENCIA
                and d.IE_ORIGEM_PROCED is not null), 'N') IE_CARATER_INTER_DI,
        LPAD(coalesce(D.NR_CRM_EXECUTOR, 0), 8, 0) DS_LIBRES_DI,
        '' CD_PRESTADOR_DA,
        '' CD_CONVENIO_DA,
        '' CD_SUBCONVENIO_DA,
        '' NR_PROTOCOLO_DA,
        LPAD(0, 7, 0) NR_INTERNO_CONTA_DA,
        '' CD_USUARIO_CONVENIO_DA,
        '' NM_PACIENTE_DA,
        0 CD_TIPO_DOCUMENTO_DA,
        LPAD(0, 8, 0) NR_DOCUMENTO_DA,
        '' NR_GUIA_DA,
        NULL DT_ITEM_DA,
        LPAD(0, 7, 0) CD_ITEM_DA,
        '' CD_TIPO_NOMENCLADOR_DA,
        '' DS_ITEM_DA,
        LPAD(0, 5, 0) QT_ITEM_DA,
        '' NR_MEDICO_EXECUTOR_DA,
        '' NM_MEDICO_EXECUTOR_DA,
        LPAD(0, 13, 0) VL_HONORARIOS_DA,
        LPAD(0, 13, 0) VL_SADT_DA,
        '' CD_TIPO_HONORARIO_DA,
        LPAD(0, 3, 0) TX_FATURADO_HONORARIO_DA,
        LPAD(0, 3, 0) TX_FATURADO_GASTO_DA,
        '' IE_CARATER_INTER_DA,
        '' DS_LIBRES_DA,
        A.NR_SEQ_PROTOCOLO,
        A.NR_INTERNO_CONTA,
        A.DT_PERIODO_INICIAL, 
        A.NR_ATENDIMENTO
FROM    W_INTERF_CONTA_CAB A,
        W_INTERF_CONTA_HEADER B,
        W_INTERF_CONTA_TOTAL C,
        W_INTERF_CONTA_ITEM D
WHERE   A.NR_SEQ_PROTOCOLO  = B.NR_SEQ_PROTOCOLO
AND     A.NR_INTERNO_CONTA  = C.NR_INTERNO_CONTA
AND     A.NR_INTERNO_CONTA  = D.NR_INTERNO_CONTA

UNION ALL

SELECT  3 TP_REGISTRO,
        '' CD_PRESTADOR_CI,
        '' CD_CONVENIO_CI,
        '' CD_SUBCONVENIO_CI,
        '' NR_PROTOCOLO_CA,
        LPAD(0, 7, 0) NR_INTERNO_CONTA_CI,
        '' NR_INTERNACAO_CI,
        '' CD_USUARIO_CONVENIO_CI,
        '' NM_PACIENTE_CI,
        0 CD_TIPO_DOCUMENTO_CI,
        LPAD(0, 8, 0) NR_DOCUMENTO_CI,
        NULL DT_ENTRADA,
        NULL DT_ALTA,
        '' NR_GUIA_CI,
        LPAD(0, 13, 0) VL_TOTAL_CONTA,
        LPAD(0, 13, 0) IE_MEDICAMENTO,
        LPAD(0, 13, 0) IE_MATERIAL,
        '' CD_PROC_PRINCIPAL,
        '' CD_TIPO_NOMENCLADOR_CI,
        '' CD_CID_PRINCIPAL,
        '' IE_CARATER_INTER_CI,
        '' DS_LIBRES_CI,
        '' CD_PRESTADOR_DI,
        '' CD_CONVENIO_DI,
        '' CD_SUBCONVENIO_DI,
        '' NR_INTERNACAO_DI,
        NULL DT_ITEM_DI,
        LPAD(0, 7, 0) CD_ITEM_DI,
        '' CD_TIPO_NOMENCLADOR_DI,
        '' DS_ITEM_DI,
        LPAD(0, 5, 0) QT_ITEM_DI,
        '' NR_MEDICO_EXECUTOR_DI,
        '' NM_MEDICO_EXECUTOR_DI,
        LPAD(0, 13, 0) VL_HONORARIOS_DI,
        LPAD(0, 13, 0) VL_SADT_DI,
        '' CD_TIPO_HONORARIO_DI,
        LPAD(0, 3, 0) TX_FATURADO_HONORARIO_DI,
        LPAD(0, 3, 0) TX_FATURADO_GASTO_DI,
        '' IE_CARATER_INTER_DI,
        '' DS_LIBRES_DI,
        LPAD(coalesce(SUBSTR(A.CD_INTERNO, 1, 3),0), 3, 0) CD_PRESTADOR_DA,
        LPAD(SUBSTR((select max(x.CD_EXTERNO) from convenio x where x.cd_convenio = a.cd_convenio), 1, 2),2, 0) CD_CONVENIO_DA,
        LPAD(b.CD_REGIONAL, 2, 0) CD_SUBCONVENIO_DA,
        LPAD(coalesce((      select  substr(x.NR_NFE_IMP,length(x.NR_NFE_IMP)-7, length(x.NR_NFE_IMP))
                                from    nota_fiscal x
                                where   x.nr_seq_protocolo = a.nr_seq_protocolo  LIMIT 1), 'FFFFFFFF'), 8, 0) NR_PROTOCOLO_DA,
        LPAD(A.NR_INTERNO_CONTA, 7, 0) NR_INTERNO_CONTA_DA,
        LPAD(A.CD_USUARIO_CONVENIO, 14, 0) CD_USUARIO_CONVENIO_DA,
        RPAD(A.NM_PACIENTE, 30, ' ') NM_PACIENTE_DA,
        4 CD_TIPO_DOCUMENTO_DA,
        LPAD(A.NR_IDENTIDADE, 8, 0) NR_DOCUMENTO_DA,
        LPAD((select max(y.cd_senha) from W_INTERF_CONTA_AUTOR y
	      where y.cd_convenio = D.cd_convenio
	      and y.nr_atendimento = A.nr_atendimento
	      and y.nr_interno_conta = a.nr_interno_conta
	      and y.ie_origem_guia = 'U'), 7, 0) NR_GUIA_DA,
        D.DT_ITEM DT_ITEM_DA,
        LPAD(D.CD_ITEM, 7, 0) CD_ITEM_DA,
        RPAD(CASE WHEN D.IE_ORIGEM_PROCED IS NULL THEN                 obter_tipo_nomenclador_regra( D.cd_convenio,                  D.CD_ITEM,                  null,                  null)  ELSE obter_tipo_nomenclador_regra( D.cd_convenio,                  null,                  D.CD_ITEM,                  D.IE_ORIGEM_PROCED) END , 1, ' ') CD_TIPO_NOMENCLADOR_DA,
        RPAD(D.DS_ITEM , 30, ' ') DS_ITEM_DA,
        LPAD(D.QT_ITEM , 5, 0) QT_ITEM_DA,
        LPAD(coalesce((select  x.cd_medico_req
                  from  procedimento_paciente x
                  where x.nr_interno_conta = D.nr_interno_conta
                        and x.nr_sequencia = D.nr_seq_item
                        and D.ie_tipo_item = 1), 0), 6, 0) NR_MEDICO_EXECUTOR_DA,
        RPAD(obter_nome_medico((select	x.cd_medico_req
		                from	procedimento_paciente x
                                where   x.nr_interno_conta = D.nr_interno_conta
                                        and x.nr_sequencia = D.nr_seq_item
                                        and D.ie_tipo_item = 1), 'N'), 30, ' ') NM_MEDICO_EXECUTOR_DA,
        LPAD(D.VL_HONORARIO, 13, 0) VL_HONORARIOS_DA,
        LPAD(D.VL_CUSTO_OPER, 13, 0) VL_SADT_DA,
        coalesce((select
            CASE
                WHEN IE_MEDICO='S' AND coalesce(IE_ANESTESISTA,'N')='N' AND coalesce(IE_AUXILIAR,'N')='N' THEN 'E'
                WHEN coalesce(IE_ANESTESISTA,'N')='S' THEN 'A'
                WHEN coalesce(IE_INSTRUMENTADOR ,'N')='S' THEN 'P'
                WHEN IE_MEDICO='S' AND coalesce(IE_AUXILIAR,'N')='S' AND substr(DS_FUNCAO,1,1)='P' THEN '1'
                WHEN IE_MEDICO='S' AND coalesce(IE_AUXILIAR,'N')='S' AND substr(DS_FUNCAO,1,1)='S' THEN '2'
                WHEN IE_MEDICO='S' AND coalesce(IE_AUXILIAR,'N')='S' AND substr(DS_FUNCAO,1,1)='T' THEN '3'
                ELSE ' '
            END DS
            from    funcao_medico x
            where   x.cd_funcao = d.CD_FUNCAO_EXECUTOR),' ') CD_TIPO_HONORARIO_DA,
        LPAD(D.PR_FATURADO, 3, 0) TX_FATURADO_HONORARIO_DA,
        LPAD(D.PR_FATURADO, 3, 0) TX_FATURADO_GASTO_DA,
        coalesce(( SELECT max(x.IE_URGENCIA)
                        from PRESCR_PROCEDIMENTO x, PROCEDIMENTO_PACIENTE y
                        where x.NR_SEQUENCIA = y.NR_SEQUENCIA_PRESCRICAO
                        and x.NR_PRESCRICAO = y.NR_PRESCRICAO
                        and y.NR_SEQUENCIA = d.NR_SEQUENCIA
                        and d.IE_ORIGEM_PROCED is not null), 'N') IE_CARATER_INTER_DA,
        LPAD(coalesce(D.NR_CRM_EXECUTOR, 0), 8, 0) DS_LIBRES_DA,
        A.NR_SEQ_PROTOCOLO,
        A.NR_INTERNO_CONTA,
        A.DT_PERIODO_INICIAL, 
        A.NR_ATENDIMENTO
FROM    W_INTERF_CONTA_CAB A,
        W_INTERF_CONTA_HEADER B,
        W_INTERF_CONTA_TOTAL C,
        W_INTERF_CONTA_ITEM D
WHERE   A.NR_SEQ_PROTOCOLO  = B.NR_SEQ_PROTOCOLO
AND     A.NR_INTERNO_CONTA  = C.NR_INTERNO_CONTA
AND     A.NR_INTERNO_CONTA  = D.NR_INTERNO_CONTA;
