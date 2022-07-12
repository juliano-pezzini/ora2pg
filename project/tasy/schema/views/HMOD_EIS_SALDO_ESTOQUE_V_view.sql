-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hmod_eis_saldo_estoque_v (dt_mesano_referencia, cd_local_estoque, ds_local_estoque, cd_material, ds_material, cd_classe_material, ds_classe_material, cd_subgrupo_material, ds_subgrupo_material, cd_grupo_material, ds_grupo_material, cd_conta_contabil, ds_conta_contabil, vl_estoque, qt_estoque) AS SELECT  A.DT_MESANO_REFERENCIA,
 A.CD_LOCAL_ESTOQUE,
 SUBSTR(OBTER_DESC_LOCAL_ESTOQUE(A.CD_LOCAL_ESTOQUE),1,40)DS_LOCAL_ESTOQUE,
 B.CD_MATERIAL,
 B.DS_MATERIAL,
 C.CD_CLASSE_MATERIAL,
 C.DS_CLASSE_MATERIAL,
 D.CD_SUBGRUPO_MATERIAL,
 D.DS_SUBGRUPO_MATERIAL,
 E.CD_GRUPO_MATERIAL,
 E.DS_GRUPO_MATERIAL,
 E.CD_CONTA_CONTABIL,
 SUBSTR(OBTER_DESC_CONTA_CONTABIL(E.CD_CONTA_CONTABIL),1,60)DS_CONTA_CONTABIL,
 SUM(A.VL_ESTOQUE)VL_ESTOQUE,
 SUM(A.QT_ESTOQUE)QT_ESTOQUE
FROM  SALDO_ESTOQUE A,
 MATERIAL B,
 CLASSE_MATERIAL C,
 SUBGRUPO_MATERIAL D,
 GRUPO_MATERIAL E
WHERE  A.CD_MATERIAL  = B.CD_MATERIAL
AND B.CD_CLASSE_MATERIAL = C.CD_CLASSE_MATERIAL
AND C.CD_SUBGRUPO_MATERIAL = D.CD_SUBGRUPO_MATERIAL
AND D.CD_GRUPO_MATERIAL = E.CD_GRUPO_MATERIAL
GROUP BY A.DT_MESANO_REFERENCIA,
 B.CD_MATERIAL,
 B.DS_MATERIAL,
 C.CD_CLASSE_MATERIAL,
 C.DS_CLASSE_MATERIAL,
 D.CD_SUBGRUPO_MATERIAL,
 D.DS_SUBGRUPO_MATERIAL,
 E.CD_GRUPO_MATERIAL,
 E.DS_GRUPO_MATERIAL,
 E.CD_CONTA_CONTABIL,
 A.CD_LOCAL_ESTOQUE
;
