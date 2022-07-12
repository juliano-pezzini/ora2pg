-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW saldo_estoque_estab_v (dt_mesano_referencia, cd_material_estoque, cd_estabelecimento, vl_custo_medio, vl_preco_ult_compra, qt_estoque, vl_estoque) AS SELECT D.DT_MESANO_REFERENCIA ,
       D.CD_MATERIAL CD_MATERIAL_ESTOQUE,
       D.CD_ESTABELECIMENTO,
       D.VL_CUSTO_MEDIO,
       D.VL_PRECO_ULT_COMPRA,
       SUM(D.QT_ESTOQUE) QT_ESTOQUE ,
       SUM(D.VL_ESTOQUE) VL_ESTOQUE
FROM   SALDO_ESTOQUE D
GROUP BY D.DT_MESANO_REFERENCIA ,
         D.CD_MATERIAL,
         D.CD_ESTABELECIMENTO,
         D.VL_CUSTO_MEDIO,
         D.VL_PRECO_ULT_COMPRA;
