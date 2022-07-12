-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bsc_indicador_v (nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nm_indicador, ds_indicador, ie_situacao, ds_formula, nr_seq_medida, ie_tipo, nr_seq_superior, ie_periodo, cd_ano_limite, dt_fechamento, ie_regra_result, cd_classificacao, nr_seq_origem, ds_info_complementar, ie_regra_intervalo, nr_dia_liberacao, ie_visualizacao, qt_ano_anterior, ie_forma_consol_empresa, ie_informacao, nr_seq_qualif, cd_setor_atendimento, cd_estab_exclusivo, ie_forma_calc, vl_max_grafico, vl_min_grafico, nr_seq_risco_vinc, nr_seq_apresentacao, nr_seq_tipo, cd_exp_nm_indicador, cd_exp_ds_indicador, ds_periodo, ds_tipo, ds_regra_result, ds_unidade_medida, ds_origem_inf) AS select a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NM_INDICADOR,a.DS_INDICADOR,a.IE_SITUACAO,a.DS_FORMULA,a.NR_SEQ_MEDIDA,a.IE_TIPO,a.NR_SEQ_SUPERIOR,a.IE_PERIODO,a.CD_ANO_LIMITE,a.DT_FECHAMENTO,a.IE_REGRA_RESULT,a.CD_CLASSIFICACAO,a.NR_SEQ_ORIGEM,a.DS_INFO_COMPLEMENTAR,a.IE_REGRA_INTERVALO,a.NR_DIA_LIBERACAO,a.IE_VISUALIZACAO,a.QT_ANO_ANTERIOR,a.IE_FORMA_CONSOL_EMPRESA,a.IE_INFORMACAO,a.NR_SEQ_QUALIF,a.CD_SETOR_ATENDIMENTO,a.CD_ESTAB_EXCLUSIVO,a.IE_FORMA_CALC,a.VL_MAX_GRAFICO,a.VL_MIN_GRAFICO,a.NR_SEQ_RISCO_VINC,a.NR_SEQ_APRESENTACAO,a.NR_SEQ_TIPO,a.CD_EXP_NM_INDICADOR,a.CD_EXP_DS_INDICADOR,
	substr(obter_valor_dominio(2303,ie_periodo),1,200) ds_periodo,
	substr(obter_valor_dominio(2302,ie_tipo),1,200) ds_tipo,
	substr(obter_valor_dominio(2324,ie_regra_result),1,200) ds_regra_result,
	substr(obter_descricao_padrao_pk('BSC_UNID_MED','DS_UNIDADE','NR_SEQUENCIA',nr_seq_medida),1,255) ds_unidade_medida,
	substr(obter_descricao_padrao_pk('BSC_ORIGEM_INDIC','DS_ORIGEM_INDICADOR','NR_SEQUENCIA',nr_seq_origem),1,255) ds_origem_inf
FROM	bsc_indicador a;

