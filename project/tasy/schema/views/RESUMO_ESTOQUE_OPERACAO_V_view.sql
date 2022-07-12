-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW resumo_estoque_operacao_v (cd_estabelecimento, cd_local_estoque, cd_operacao_estoque, ie_entrada_saida, ds_operacao, cd_material_estoque, dt_mesano_referencia, qt_estoque, vl_estoque, vl_custo_medio, ds_material, cd_classe_material, cd_unidade_medida_estoque) AS SELECT /*+ INDEX (X SALESTO_VALOR_I) */      X.CD_ESTABELECIMENTO,
      X.CD_LOCAL_ESTOQUE,
      000 CD_OPERACAO_ESTOQUE,
      'A' IE_ENTRADA_SAIDA,
      'Estoque Anterior ' ds_operacao,
      X.CD_MATERIAL CD_MATERIAL_ESTOQUE,
      (ADD_MONTHS(X.DT_MESANO_REFERENCIA, 1)) DT_MESANO_REFERENCIA,
      X.QT_ESTOQUE,
      X.VL_ESTOQUE,
      X.VL_CUSTO_MEDIO,
      Y.DS_MATERIAL,
      Y.CD_CLASSE_MATERIAL,
      substr(obter_dados_material_estab(Y.cd_material,X.cd_estabelecimento,'UME'),1,30) cd_unidade_medida_estoque
FROM  SALDO_ESTOQUE X,
      MATERIAL Y
WHERE X.CD_MATERIAL = Y.CD_MATERIAL

UNION all

SELECT
      A.CD_ESTABELECIMENTO,
      A.CD_LOCAL_ESTOQUE,
      A.CD_OPERACAO_ESTOQUE OPERACAO,
      C.IE_ENTRADA_SAIDA,
      ' '||C.DS_OPERACAO,
      A.CD_MATERIAL,
      A.DT_MESANO_REFERENCIA,
      A.QT_ESTOQUE,
      A.VL_ESTOQUE,
      0 VL_CUSTO_MEDIO,
      B.DS_MATERIAL,
      B.CD_CLASSE_MATERIAL,
      substr(obter_dados_material_estab(b.cd_material,a.cd_estabelecimento,'UME'),1,30) cd_unidade_medida_estoque
FROM  RESUMO_MOVTO_ESTOQUE A,
      MATERIAL B,
      OPERACAO_ESTOQUE C
WHERE A.CD_MATERIAL = B.CD_MATERIAL
  AND A.CD_OPERACAO_ESTOQUE = C.CD_OPERACAO_ESTOQUE

UNION all

SELECT /*+ INDEX (X SALESTO_VALOR_I) */      V.CD_ESTABELECIMENTO,
      V.CD_LOCAL_ESTOQUE,
      999 CD_OPERACAO_ESTOQUE,
      'Z' IE_ENTRADA_SAIDA,
      'Estoque Atual',
      V.CD_MATERIAL CD_MATERIAL_ESTOQUE,
      V.DT_MESANO_REFERENCIA,
      V.QT_ESTOQUE,
      V.VL_ESTOQUE,
      V.VL_CUSTO_MEDIO,
      W.DS_MATERIAL,
      W.CD_CLASSE_MATERIAL,
      substr(obter_dados_material_estab(w.cd_material,v.cd_estabelecimento,'UME'),1,30) cd_unidade_medida_estoque
FROM  SALDO_ESTOQUE V,
      MATERIAL W
WHERE V.CD_MATERIAL = W.CD_MATERIAL;

