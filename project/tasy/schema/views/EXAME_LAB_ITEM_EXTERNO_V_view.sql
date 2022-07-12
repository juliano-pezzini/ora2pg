-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exame_lab_item_externo_v (nr_seq_resultado, nr_sequencia, nr_seq_exame, dt_atualizacao, nm_usuario, qt_resultado, ds_resultado, nr_seq_metodo, nr_seq_material, pr_resultado, ie_status, dt_aprovacao, nm_usuario_aprovacao, nr_seq_prescr, pr_minimo, pr_maximo, qt_minima, qt_maxima, ds_observacao, ds_referencia, ds_unidade_medida, qt_decimais, ds_regra, dt_coleta, nr_seq_reagente, nr_seq_formato, cd_medico_resp, dt_impressao, nr_seq_unid_med, cd_equipamento, ie_consiste, ds_protocolo_externo, ie_normalidade, ie_restringe_resultado, dt_digitacao, nr_seq_formato_red, nr_seq_metodo_exame, nr_lote_reagente, nr_seq_assinatura, nr_seq_assinat_inativ, dt_validade_reagente, ds_resultado_curto) AS SELECT A.NR_SEQ_RESULTADO,A.NR_SEQUENCIA,A.NR_SEQ_EXAME,A.DT_ATUALIZACAO,A.NM_USUARIO,A.QT_RESULTADO,A.DS_RESULTADO,A.NR_SEQ_METODO,A.NR_SEQ_MATERIAL,A.PR_RESULTADO,A.IE_STATUS,A.DT_APROVACAO,A.NM_USUARIO_APROVACAO,A.NR_SEQ_PRESCR,A.PR_MINIMO,A.PR_MAXIMO,A.QT_MINIMA,A.QT_MAXIMA,A.DS_OBSERVACAO,A.DS_REFERENCIA,A.DS_UNIDADE_MEDIDA,A.QT_DECIMAIS,A.DS_REGRA,A.DT_COLETA,A.NR_SEQ_REAGENTE,A.NR_SEQ_FORMATO,A.CD_MEDICO_RESP,A.DT_IMPRESSAO,A.NR_SEQ_UNID_MED,A.CD_EQUIPAMENTO,A.IE_CONSISTE,A.DS_PROTOCOLO_EXTERNO,A.IE_NORMALIDADE,A.IE_RESTRINGE_RESULTADO,A.DT_DIGITACAO,A.NR_SEQ_FORMATO_RED,A.NR_SEQ_METODO_EXAME,A.NR_LOTE_REAGENTE,A.NR_SEQ_ASSINATURA,A.NR_SEQ_ASSINAT_INATIV,A.DT_VALIDADE_REAGENTE,A.DS_RESULTADO_CURTO
FROM 	EXAME_LAB_RESULT_ITEM A;
