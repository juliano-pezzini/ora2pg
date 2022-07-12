-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW med_item_avaliar_v (nr_sequencia, ds_item, nr_seq_tipo, nr_seq_apresent, ie_resultado, dt_atualizacao, nm_usuario, qt_decimais, ds_unid_med, qt_minimo, qt_maximo, qt_tamanho, qt_desloc_direita, nr_seq_superior, ie_obrigatorio, ie_tipo_campo, ds_mascara, qt_pos_esquerda, ds_regra, cd_dominio, nr_seq_item_ref, vl_padrao, ds_complemento, ds_cor_grafico, qt_altura, ds_formula, ds_alias, ds_arquivo, ie_readonly, ds_cor_fundo, ds_cor_fonte, ds_msg_aviso, ie_grafico_avaliacao, qt_max_caracter, cd_localizador, ie_copiar, ds_cor_regra, ds_cor_regra_max, ds_estilo_fonte, qt_tam_fonte, nivel, nm_item) AS WITH RECURSIVE cte AS (
select a.NR_SEQUENCIA,a.DS_ITEM,a.NR_SEQ_TIPO,a.NR_SEQ_APRESENT,a.IE_RESULTADO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.QT_DECIMAIS,a.DS_UNID_MED,a.QT_MINIMO,a.QT_MAXIMO,a.QT_TAMANHO,a.QT_DESLOC_DIREITA,a.NR_SEQ_SUPERIOR,a.IE_OBRIGATORIO,a.IE_TIPO_CAMPO,a.DS_MASCARA,a.QT_POS_ESQUERDA,a.DS_REGRA,a.CD_DOMINIO,a.NR_SEQ_ITEM_REF,a.VL_PADRAO,a.DS_COMPLEMENTO,a.DS_COR_GRAFICO,a.QT_ALTURA,a.DS_FORMULA,a.DS_ALIAS,a.DS_ARQUIVO,a.IE_READONLY,a.DS_COR_FUNDO,a.DS_COR_FONTE,a.DS_MSG_AVISO,a.IE_GRAFICO_AVALIACAO,a.QT_MAX_CARACTER,a.CD_LOCALIZADOR,a.IE_COPIAR,a.DS_COR_REGRA,a.DS_COR_REGRA_MAX,a.DS_ESTILO_FONTE,a.QT_TAM_FONTE,1 nivel,substr(Lpad(' ',3*(1-1)) || a.ds_item, 1, 60) nm_item
 FROM med_item_avaliar a WHERE a.nr_seq_superior is null
  UNION ALL
select a.NR_SEQUENCIA,a.DS_ITEM,a.NR_SEQ_TIPO,a.NR_SEQ_APRESENT,a.IE_RESULTADO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.QT_DECIMAIS,a.DS_UNID_MED,a.QT_MINIMO,a.QT_MAXIMO,a.QT_TAMANHO,a.QT_DESLOC_DIREITA,a.NR_SEQ_SUPERIOR,a.IE_OBRIGATORIO,a.IE_TIPO_CAMPO,a.DS_MASCARA,a.QT_POS_ESQUERDA,a.DS_REGRA,a.CD_DOMINIO,a.NR_SEQ_ITEM_REF,a.VL_PADRAO,a.DS_COMPLEMENTO,a.DS_COR_GRAFICO,a.QT_ALTURA,a.DS_FORMULA,a.DS_ALIAS,a.DS_ARQUIVO,a.IE_READONLY,a.DS_COR_FUNDO,a.DS_COR_FONTE,a.DS_MSG_AVISO,a.IE_GRAFICO_AVALIACAO,a.QT_MAX_CARACTER,a.CD_LOCALIZADOR,a.IE_COPIAR,a.DS_COR_REGRA,a.DS_COR_REGRA_MAX,a.DS_ESTILO_FONTE,a.QT_TAM_FONTE,(c.level+1) nivel,substr(Lpad(' ',3*((c.level+1)-1)) || a.ds_item, 1, 60) nm_item
 FROM med_item_avaliar a JOIN cte c ON (c.prior nr_sequencia = a.nr_seq_superior)

) SELECT * FROM cte;

